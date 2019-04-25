Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44060 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728011AbfDYUcj (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Apr 2019 16:32:39 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E355C308B44D
        for <fio@vger.kernel.org>; Thu, 25 Apr 2019 20:32:38 +0000 (UTC)
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH v2] engines: Add Network Block Device (NBD) support.
Date: Thu, 25 Apr 2019 21:32:33 +0100
Message-Id: <20190425203233.17033-2-rjones@redhat.com>
In-Reply-To: <20190425203233.17033-1-rjones@redhat.com>
References: <20190425203233.17033-1-rjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: eblake@redhat.com

To test nbdkit and the memory (RAM disk) plugin:

  $ rm -f /tmp/socket
  $ nbdkit -U /tmp/socket memory size=1G --run './fio examples/nbd.fio'

To test qemu-nbd with a backing file:

  $ rm -f /tmp/disk.img /tmp/socket
  $ truncate -s 1G /tmp/disk.img
  $ qemu-nbd -t -f raw -k /tmp/socket /tmp/disk.img
  $ ./fio examples/nbd.fio

Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
---
 HOWTO            |   2 +
 Makefile         |   2 +-
 engines/nbd.c    | 563 +++++++++++++++++++++++++++++++++++++++++++++++
 examples/nbd.fio |  26 +++
 fio.1            |   3 +
 optgroup.c       |   4 +
 optgroup.h       |   2 +
 options.c        |   3 +
 8 files changed, 604 insertions(+), 1 deletion(-)

diff --git a/HOWTO b/HOWTO
index 4fd4da14..8697d182 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1993,6 +1993,8 @@ I/O engine
 			requests for IME. FIO will then decide when to commit these requests.
 		**libiscsi**
 			Read and write iscsi lun with libiscsi.
+		**nbd**
+			Synchronous read and write a Network Block Device (NBD).
 
 I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/Makefile b/Makefile
index d7e5fca7..1650a6c9 100644
--- a/Makefile
+++ b/Makefile
@@ -45,7 +45,7 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		pshared.c options.c \
 		smalloc.c filehash.c profile.c debug.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
-		engines/ftruncate.c engines/filecreate.c \
+		engines/ftruncate.c engines/filecreate.c engines/nbd.c \
 		server.c client.c iolog.c backend.c libfio.c flow.c cconv.c \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
diff --git a/engines/nbd.c b/engines/nbd.c
new file mode 100644
index 00000000..e75cb87c
--- /dev/null
+++ b/engines/nbd.c
@@ -0,0 +1,563 @@
+/*
+ * NBD engine
+ *
+ * IO engine that talks to a newstyle-fixed NBD server over a TCP or
+ * Unix domain socket.
+ *
+ * Copyright (C) 2019 Red Hat Inc.
+ * Written by Richard W.M. Jones <rjones@redhat.com>
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <errno.h>
+#include <netdb.h>
+#include <netinet/in.h>
+#include <netinet/tcp.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+
+#include "../fio.h"
+#include "../optgroup.h"
+
+/* New-style handshake. */
+struct nbd_new_handshake {
+	char nbdmagic[8];	    /* "NBDMAGIC" */
+	uint64_t version;	    /* NEW_VERSION */
+	uint16_t gflags;	    /* global flags */
+} __attribute__((packed));
+
+#define NEW_VERSION UINT64_C(0x49484156454F5054)
+
+#define NBD_FLAG_FIXED_NEWSTYLE	    1
+#define NBD_FLAG_NO_ZEROES	    2
+
+struct nbd_new_option {
+	uint64_t version;	    /* NEW_VERSION */
+	uint32_t option;	    /* NBD_OPT_* */
+	uint32_t optlen;	    /* option data length */
+	/* option data follows */
+} __attribute__((packed));
+
+#define NBD_OPT_EXPORT_NAME	    UINT32_C(1)
+
+struct nbd_new_handshake_finish {
+	uint64_t exportsize;
+	uint16_t eflags;	      /* per-export flags */
+} __attribute__((packed));
+
+/* Per-export flags. */
+#define NBD_FLAG_HAS_FLAGS	   (1 << 0)
+#define NBD_FLAG_READ_ONLY	   (1 << 1)
+#define NBD_FLAG_SEND_FLUSH	   (1 << 2)
+#define NBD_FLAG_SEND_FUA	   (1 << 3)
+#define NBD_FLAG_ROTATIONAL	   (1 << 4)
+#define NBD_FLAG_SEND_TRIM	   (1 << 5)
+#define NBD_FLAG_SEND_WRITE_ZEROES (1 << 6)
+#define NBD_FLAG_SEND_DF	   (1 << 7)
+#define NBD_FLAG_CAN_MULTI_CONN	   (1 << 8)
+
+struct nbd_request {
+	uint32_t magic;		      /* NBD_REQUEST_MAGIC. */
+	uint16_t flags;		      /* NBD_CMD_FLAG_* */
+	uint16_t type;		      /* NBD_CMD_* */
+	uint64_t handle;	      /* Opaque handle. */
+	uint64_t offset;	      /* Request offset. */
+	uint32_t count;		      /* Request length. */
+} __attribute__((packed));
+
+struct nbd_reply {
+	uint32_t magic;		      /* NBD_SIMPLE_REPLY_MAGIC. */
+	uint32_t error;		      /* NBD_SUCCESS or one of NBD_E*. */
+	uint64_t handle;	      /* Opaque handle. */
+} __attribute__((packed));
+
+#define NBD_REQUEST_MAGIC	    UINT32_C(0x25609513)
+#define NBD_SIMPLE_REPLY_MAGIC	    UINT32_C(0x67446698)
+
+#define NBD_CMD_READ		    0
+#define NBD_CMD_WRITE		    1
+#define NBD_CMD_DISC		    2
+#define NBD_CMD_FLUSH		    3
+#define NBD_CMD_TRIM		    4
+#define NBD_CMD_WRITE_ZEROES	    6
+
+#define NBD_CMD_FLAG_FUA      (1<<0)
+#define NBD_CMD_FLAG_NO_HOLE  (1<<1)
+
+#define NBD_SUCCESS	0
+#define NBD_EPERM	1
+#define NBD_EIO		5
+#define NBD_ENOMEM     12
+#define NBD_EINVAL     22
+#define NBD_ENOSPC     28
+#define NBD_ESHUTDOWN 108
+
+/* Actually this differs across servers, but for nbdkit ... */
+#define NBD_MAX_REQUEST_SIZE (64 * 1024 * 1024)
+
+static uint64_t exportsize;
+static uint16_t eflags;
+
+struct nbd_data {
+	int fd;
+};
+
+struct nbd_options {
+	void *padding;
+	char *hostname;
+	char *port;
+	char *sockname;
+	char *exportname;
+	unsigned long long size;
+};
+
+static struct fio_option options[] = {
+	{
+		.name	= "hostname",
+		.lname	= "NBD remote hostname",
+		.help	= "Hostname of remote NBD server",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_NBD,
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct nbd_options, hostname),
+	},
+	{
+		.name	= "port",
+		.lname	= "NBD port",
+		.help	= "Port or service name to use for NBD connection",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_NBD,
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct nbd_options, port),
+	},
+	{
+		.name	= "sockname",
+		.lname	= "NBD Unix domain socket",
+		.help	= "Name of Unix domain socket",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_NBD,
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct nbd_options, sockname),
+	},
+	{
+		.name	= "exportname",
+		.lname	= "NBD export name",
+		.help	= "Name of NBD export",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_NBD,
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct nbd_options, exportname),
+	},
+	{
+		.name	= "nbdsize",
+		.lname	= "NBD export size",
+		.help	= "Size of NBD export",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_NBD,
+		.type	= FIO_OPT_ULL,
+		.off1	= offsetof(struct nbd_options, size),
+		.minval = 512,
+		.interval = 512,
+	},
+	{
+		.name	= NULL,
+	},
+};
+
+/* Alocates nbd_data. */
+static int nbd_setup(struct thread_data *td)
+{
+	struct nbd_data *nbd_data;
+	struct nbd_options *o = td->eo;
+	struct fio_file *f;
+
+	if (!td->io_ops_data) {
+		nbd_data = calloc(1, sizeof(*nbd_data));
+		if (!nbd_data) return 1;
+		td->io_ops_data = nbd_data;
+	}
+
+	/* Pretend to deal with files.	See engines/rbd.c */
+	if (!td->files_index) {
+		add_file(td, "nbd", 0, 0);
+		td->o.nr_files = td->o.nr_files ? : 1;
+		td->o.open_files++;
+	}
+	f = td->files[0];
+	/* XXX We could read the size from NBD, but that's awkward as
+	 * we haven't connected to the server.	In any case nothing
+	 * bad happens (except an error) if the size is too large.
+	 */
+	f->real_file_size = o->size;
+
+	return 0;
+}
+
+/* Closes socket and frees nbd_data -- the opposite of nbd_setup. */
+static void nbd_cleanup(struct thread_data *td)
+{
+	struct nbd_data *nbd_data = td->io_ops_data;
+
+	if (nbd_data) {
+		if (nbd_data->fd >= 0)
+			close(nbd_data->fd);
+		free(nbd_data);
+	}
+}
+
+/* Connect to the NBD server. */
+static int set_nodelay(int fd)
+{
+#ifdef CONFIG_TCP_NODELAY
+	const int optval = 1;
+
+	if (setsockopt(fd, IPPROTO_TCP, TCP_NODELAY,
+		       (void *)&optval, sizeof(int)) == -1) {
+		log_err("fio: nbd: cannot set TCP_NODELAY option: %s\n",
+			strerror(errno));
+		return 1;
+	}
+#endif
+	return 0;
+}
+
+static int nbd_connect_inet(struct thread_data *td,
+			    const char *hostname, const char *port)
+{
+	struct nbd_data *nbd_data = td->io_ops_data;
+	struct addrinfo hints;
+	struct addrinfo *result, *rp;
+	int r;
+
+	memset(&hints, 0, sizeof hints);
+	hints.ai_family = AF_UNSPEC;
+	hints.ai_socktype = SOCK_STREAM;
+	hints.ai_flags = 0;
+	hints.ai_protocol = 0;
+
+	r = getaddrinfo(hostname, port, &hints, &result);
+	if (r != 0) {
+		log_err("fio: nbd: getaddrinfo: %s\n", gai_strerror(r));
+		return 1;
+	}
+
+	for (rp = result; rp; rp = rp->ai_next) {
+		nbd_data->fd = socket(rp->ai_family, rp->ai_socktype,
+				      rp->ai_protocol);
+		if (nbd_data->fd == -1)
+			continue;
+		if (connect(nbd_data->fd, rp->ai_addr, rp->ai_addrlen) != -1)
+			break;
+		close(nbd_data->fd);
+	}
+	freeaddrinfo(result);
+	if (rp == NULL) {
+		td_verror(td, errno, "connect");
+		return 1;
+	}
+
+	if (set_nodelay(nbd_data->fd)) {
+		close(nbd_data->fd);
+		nbd_data->fd = -1;
+		return 1;
+	}
+
+	return 0;
+}
+
+static int nbd_connect_unix(struct thread_data *td,
+			    const char *sockname)
+{
+	struct nbd_data *nbd_data = td->io_ops_data;
+	struct sockaddr_un sun;
+	socklen_t len;
+
+	nbd_data->fd = socket(AF_UNIX, SOCK_STREAM, 0);
+	if (nbd_data->fd == -1) {
+		td_verror(td, errno, "socket");
+		return 1;
+	}
+
+	sun.sun_family = AF_UNIX;
+	memset(sun.sun_path, 0, sizeof(sun.sun_path));
+	strncpy(sun.sun_path, sockname, sizeof(sun.sun_path) - 1);
+
+	len = sizeof(sun.sun_family) + strlen(sun.sun_path) + 1;
+	if (connect(nbd_data->fd, (struct sockaddr *) &sun, len) == -1) {
+		td_verror(td, errno, "connect");
+		goto fail;
+	}
+
+	return 0;
+
+ fail:
+	close(nbd_data->fd);
+	return 1;
+}
+
+/* Like read(2) and write(2) except they always read/write the full
+ * data or fail if that isn't possible.	 Read fails on early EOF too.
+ *
+ * Returns 0 for success or 1 for failure.
+ */
+static int full_read(struct thread_data *td,
+		     int fd, void *buf, size_t count)
+{
+	ssize_t r;
+
+	while (count > 0) {
+		r = read(fd, buf, count);
+		if (r == -1) {
+			td_verror(td, errno, "read");
+			return 1;
+		}
+		if (r == 0) {
+			log_err("fio: nbd: unexpected end of file reading from server\n");
+			return 1;
+		}
+		buf += r;
+		count -= r;
+	}
+
+	return 0;
+}
+
+static int full_write(struct thread_data *td,
+		      int fd, const void *buf, size_t count)
+{
+	ssize_t r;
+
+	while (count > 0) {
+		r = write(fd, buf, count);
+		if (r == -1) {
+			td_verror(td, errno, "write");
+			return 1;
+		}
+		buf += r;
+		count -= r;
+	}
+
+	return 0;
+}
+
+static int nbd_handshake(struct thread_data *td,
+			 const char *exportname)
+{
+	struct nbd_data *nbd_data = td->io_ops_data;
+	struct nbd_options *o = td->eo;
+	struct nbd_new_handshake handshake;
+	const int expected_gflags = NBD_FLAG_FIXED_NEWSTYLE|NBD_FLAG_NO_ZEROES;
+	uint32_t cflags;
+	struct nbd_new_option option;
+	const uint32_t exportname_len = strlen(exportname);
+	struct nbd_new_handshake_finish finish;
+
+	/* Expect the fixed newstyle handshake. */
+	if (full_read(td, nbd_data->fd, &handshake, sizeof handshake))
+		return 1;
+	handshake.version = be64_to_cpu(handshake.version);
+	handshake.gflags = be16_to_cpu(handshake.gflags);
+	if (memcmp(handshake.nbdmagic, "NBDMAGIC", 8) != 0 ||
+	    handshake.version != NEW_VERSION ||
+	    (handshake.gflags & expected_gflags) != expected_gflags) {
+		log_err("fio: nbd: handshake failed: server is not a fixed newstyle NBD server\n");
+		return 1;
+	}
+
+	/* Send 32 bit flags word back to the server containing only
+	 * the global flags we understand.
+	 */
+	cflags = handshake.gflags & expected_gflags;
+	cflags = cpu_to_be32(cflags);
+	if (full_write(td, nbd_data->fd, &cflags, sizeof cflags))
+		return 1;
+
+	/* Send NBD_OPT_EXPORT_NAME.  If we send any other options
+	 * they must go before this one, since this option terminates
+	 * the option phase.
+	 */
+	option.version = cpu_to_be64(NEW_VERSION);
+	option.option = cpu_to_be32(NBD_OPT_EXPORT_NAME);
+	option.optlen = cpu_to_be32(exportname_len);
+	if (full_write(td, nbd_data->fd, &option, sizeof option) ||
+	    full_write(td, nbd_data->fd, exportname, exportname_len))
+		return 1;
+	/* Note the server does not send an option reply to
+	 * NBD_OPT_EXPORT_NAME.
+	 */
+
+	/* Server sends handshake finish. */
+	if (full_read(td, nbd_data->fd, &finish, sizeof finish))
+		return 1;
+	finish.exportsize = be64_to_cpu(finish.exportsize);
+	finish.eflags = be16_to_cpu(finish.eflags);
+
+	exportsize = finish.exportsize;
+	eflags = finish.eflags;
+
+	if (exportsize < o->size) {
+		log_err("fio: nbd: NBD export size is smaller than test size: increase the fio size= parameter to at least %" PRIu64,
+			exportsize);
+		return 1;
+	}
+
+	return 0;
+}
+
+static int nbd_init(struct thread_data *td)
+{
+	struct nbd_options *o = td->eo;
+	int r;
+
+	if (o->sockname) {
+		/* Unix domain socket connection. */
+		if (o->hostname || o->port) {
+			log_err("fio: nbd: if sockname is specified, hostname and port cannot be used\n");
+			return 1;
+		}
+		r = nbd_connect_unix(td, o->sockname);
+	} else {
+		/* TCP connection to (usually) remote server. */
+		if (!o->hostname) {
+			log_err("fio: nbd: you must specify either hostname or sockname\n");
+			return 1;
+		}
+		r = nbd_connect_inet(td, o->hostname,
+				     o->port ? o->port : "10809");
+	}
+	if (r)
+		return 1;
+
+	log_info("fio: connected to NBD server\n");
+	r = nbd_handshake(td, o->exportname ? o->exportname : "");
+	if (r)
+		return 1;
+
+	log_info("fio: handshake with NBD server completed\n");
+	return 0;
+}
+
+/* Read or write request (handled synchronously in this engine). */
+static enum fio_q_status nbd_queue(struct thread_data *td,
+				   struct io_u *io_u)
+{
+	struct nbd_data *nbd_data = td->io_ops_data;
+	struct nbd_request rq;
+	uint16_t cmd;
+	struct nbd_reply rp;
+
+	fio_ro_check(td, io_u);
+
+	if (io_u->ddir == DDIR_WRITE || io_u->ddir == DDIR_READ)
+		assert(io_u->xfer_buflen <= NBD_MAX_REQUEST_SIZE);
+
+	rq.magic = cpu_to_be32(NBD_REQUEST_MAGIC);
+	rq.flags = 0;
+	rq.handle = 0; /* XXX If we do non-sync, need to set this. */
+	rq.offset = cpu_to_be64((uint64_t) io_u->offset);
+	rq.count = cpu_to_be32((uint32_t) io_u->xfer_buflen);
+
+	switch (io_u->ddir) {
+	case DDIR_WRITE: cmd = NBD_CMD_WRITE; break;
+	case DDIR_READ:	 cmd = NBD_CMD_READ;  break;
+	case DDIR_TRIM:	 cmd = NBD_CMD_TRIM;  break;
+		/* XXX We could probably also handle
+		 * DDIR_SYNC_FILE_RANGE with a bit of effort.
+		 */
+	case DDIR_SYNC:	 cmd = NBD_CMD_FLUSH; break;
+	default:
+		io_u->error = EINVAL;
+		return FIO_Q_COMPLETED;
+	}
+	rq.type = cpu_to_be16(cmd);
+
+	/* Send the request + optional write payload. */
+	if (full_write(td, nbd_data->fd, &rq, sizeof rq)) {
+		io_u->error = errno;
+		return FIO_Q_COMPLETED;
+	}
+	if (io_u->ddir == DDIR_WRITE) {
+		if (full_write(td, nbd_data->fd,
+			      io_u->xfer_buf, io_u->xfer_buflen)) {
+			io_u->error = errno;
+			return FIO_Q_COMPLETED;
+		}
+	}
+
+	/* Read the reply + optional read payload. */
+	if (full_read(td, nbd_data->fd, &rp, sizeof rp)) {
+		io_u->error = errno;
+		return FIO_Q_COMPLETED;
+	}
+	rp.magic = be32_to_cpu(rp.magic);
+	rp.error = be32_to_cpu(rp.error);
+	rp.handle = be64_to_cpu(rp.handle);
+	if (rp.magic != NBD_SIMPLE_REPLY_MAGIC) {
+		log_err("fio: nbd: invalid magic in reply message\n");
+		io_u->error = EINVAL;
+		return FIO_Q_COMPLETED;
+	}
+
+	if (rp.error != NBD_SUCCESS) {
+		switch (rp.error) {
+		case NBD_EPERM:	    io_u->error = EPERM; break;
+		case NBD_EIO:	    io_u->error = EIO; break;
+		case NBD_ENOMEM:    io_u->error = ENOMEM; break;
+		case NBD_ENOSPC:    io_u->error = ENOSPC; break;
+		case NBD_ESHUTDOWN: io_u->error = ESHUTDOWN; break;
+		case NBD_EINVAL: default: io_u->error = EINVAL; break;
+		}
+		return FIO_Q_COMPLETED;
+	}
+
+	if (io_u->ddir == DDIR_READ) {
+		if (full_read(td, nbd_data->fd,
+			      io_u->xfer_buf, io_u->xfer_buflen)) {
+			io_u->error = errno;
+			return FIO_Q_COMPLETED;
+		}
+	}
+
+	io_u->error = 0;
+	return FIO_Q_COMPLETED;
+}
+
+
+static int nbd_open_file(struct thread_data *td, struct fio_file *f)
+{
+	return 0;
+}
+
+static int nbd_invalidate(struct thread_data *td, struct fio_file *f)
+{
+	return 0;
+}
+
+static struct ioengine_ops ioengine = {
+	.name			= "nbd",
+	.version		= FIO_IOOPS_VERSION,
+	.options		= options,
+	.option_struct_size	= sizeof(struct nbd_options),
+	.flags			= FIO_DISKLESSIO | FIO_SYNCIO | FIO_NOEXTEND,
+
+	.setup			= nbd_setup,
+	.init			= nbd_init,
+	.cleanup		= nbd_cleanup,
+	.queue			= nbd_queue,
+	.open_file		= nbd_open_file,
+	.invalidate		= nbd_invalidate,
+};
+
+static void fio_init fio_nbd_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_nbd_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/examples/nbd.fio b/examples/nbd.fio
new file mode 100644
index 00000000..7515faab
--- /dev/null
+++ b/examples/nbd.fio
@@ -0,0 +1,26 @@
+# The NBD engine is synchronous, although could be made to work
+# asynchronously with some effort.  However because of this we
+# need to run multiple jobs in order to test parallelism.
+
+[global]
+ioengine=nbd
+sockname=/tmp/socket
+rw=randrw
+size=64m
+nbdsize=64m
+time_based
+runtime=60
+numjobs=4
+group_reporting
+
+[thread0]
+offset=0
+
+[thread1]
+offset=64m
+
+[thread2]
+offset=128m
+
+[thread3]
+offset=192m
diff --git a/fio.1 b/fio.1
index 2708b503..7e075fec 100644
--- a/fio.1
+++ b/fio.1
@@ -1754,6 +1754,9 @@ FIO will then decide when to commit these requests.
 .TP
 .B libiscsi
 Read and write iscsi lun with libiscsi.
+.TP
+.B nbd
+Synchronous read and write a Network Block Device (NBD).
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
diff --git a/optgroup.c b/optgroup.c
index 04ceec7e..c228ff29 100644
--- a/optgroup.c
+++ b/optgroup.c
@@ -169,6 +169,10 @@ static const struct opt_group fio_opt_cat_groups[] = {
 		.name	= "libhdfs I/O engine", /* libhdfs */
 		.mask	= FIO_OPT_G_HDFS,
 	},
+	{
+		.name	= "NBD I/O engine", /* NBD */
+		.mask	= FIO_OPT_G_NBD,
+	},
 	{
 		.name	= NULL,
 	},
diff --git a/optgroup.h b/optgroup.h
index 148c8da1..8009bf25 100644
--- a/optgroup.h
+++ b/optgroup.h
@@ -63,6 +63,7 @@ enum opt_category_group {
 	__FIO_OPT_G_SG,
 	__FIO_OPT_G_MMAP,
 	__FIO_OPT_G_ISCSI,
+	__FIO_OPT_G_NBD,
 	__FIO_OPT_G_NR,
 
 	FIO_OPT_G_RATE		= (1ULL << __FIO_OPT_G_RATE),
@@ -102,6 +103,7 @@ enum opt_category_group {
 	FIO_OPT_G_MMAP		= (1ULL << __FIO_OPT_G_MMAP),
 	FIO_OPT_G_INVALID	= (1ULL << __FIO_OPT_G_NR),
 	FIO_OPT_G_ISCSI         = (1ULL << __FIO_OPT_G_ISCSI),
+	FIO_OPT_G_NBD		= (1ULL << __FIO_OPT_G_NBD),
 };
 
 extern const struct opt_group *opt_group_from_mask(uint64_t *mask);
diff --git a/options.c b/options.c
index 95086074..f4c9bedf 100644
--- a/options.c
+++ b/options.c
@@ -1899,6 +1899,9 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "HTTP (WebDAV/S3) IO engine",
 			  },
 #endif
+			  { .ival = "nbd",
+			    .help = "Network Block Device (NBD) IO engine"
+			  },
 		},
 	},
 	{
-- 
2.20.1


