Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48874 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751557AbeDIMAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 9 Apr 2018 08:00:11 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1f5VT1-0001ct-4l
        for fio@vger.kernel.org; Mon, 09 Apr 2018 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180409120002.587EF2C0075@kernel.dk>
Date: Mon,  9 Apr 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 465964a6c8ff3ccac62b92e9af57377075e04579:

  Merge branch 'master' of https://github.com/bvanassche/fio (2018-04-06 17:59:20 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9fac0db7a09bac08bbff9b213d3b1daceee07679:

  steadystate: check for division by zero in mean calculation (2018-04-08 15:54:26 -0600)

----------------------------------------------------------------
Jens Axboe (8):
      Remove binject engine
      axmap: use calloc() for level alloc
      server: fix dead assignment of variable
      client: fix bad shadowing of 'ret'
      filesetup: fix dead assignment of 'ret'
      parse: fix dead 'org' assignment
      eta: fix dead variable assignments
      steadystate: check for division by zero in mean calculation

 Makefile          |   2 +-
 client.c          |   6 +-
 engines/binject.c | 458 ------------------------------------------------------
 eta.c             |   4 +-
 filesetup.c       |   3 -
 io_u.h            |   3 -
 lib/axmap.c       |   2 +-
 options.c         |   5 -
 os/binject.h      |  71 ---------
 os/os-android.h   |   1 -
 os/os-linux.h     |   2 -
 parse.c           |   2 -
 server.c          |   1 -
 steadystate.c     |   6 +
 14 files changed, 13 insertions(+), 553 deletions(-)
 delete mode 100644 engines/binject.c
 delete mode 100644 os/binject.h

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index d45ba6b..cc4b71f 100644
--- a/Makefile
+++ b/Makefile
@@ -148,7 +148,7 @@ endif
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
-		engines/binject.c oslib/linux-dev-lookup.c
+		oslib/linux-dev-lookup.c
   LIBS += -lpthread -ldl
   LDFLAGS += -rdynamic
 endif
diff --git a/client.c b/client.c
index 970974a..ea1a4d2 100644
--- a/client.c
+++ b/client.c
@@ -1339,7 +1339,7 @@ static int fio_client_handle_iolog(struct fio_client *client,
 	sprintf(log_pathname, "%s.%s", pdu->name, client->hostname);
 
 	if (store_direct) {
-		ssize_t ret;
+		ssize_t wrote;
 		size_t sz;
 		int fd;
 
@@ -1353,10 +1353,10 @@ static int fio_client_handle_iolog(struct fio_client *client,
 		}
 
 		sz = cmd->pdu_len - sizeof(*pdu);
-		ret = write(fd, pdu->samples, sz);
+		wrote = write(fd, pdu->samples, sz);
 		close(fd);
 
-		if (ret != sz) {
+		if (wrote != sz) {
 			log_err("fio: short write on compressed log\n");
 			ret = 1;
 			goto out;
diff --git a/engines/binject.c b/engines/binject.c
deleted file mode 100644
index 49042a3..0000000
--- a/engines/binject.c
+++ /dev/null
@@ -1,458 +0,0 @@
-/*
- * binject engine
- *
- * IO engine that uses the Linux binject interface to directly inject
- * bio's to block devices.
- *
- */
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <errno.h>
-#include <assert.h>
-#include <string.h>
-#include <poll.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-
-#include "../fio.h"
-
-#ifdef FIO_HAVE_BINJECT
-
-struct binject_data {
-	struct b_user_cmd *cmds;
-	struct io_u **events;
-	struct pollfd *pfds;
-	int *fd_flags;
-};
-
-struct binject_file {
-	unsigned int bs;
-	int minor;
-	int fd;
-};
-
-static void binject_buc_init(struct binject_data *bd, struct io_u *io_u)
-{
-	struct b_user_cmd *buc = &io_u->buc;
-
-	memset(buc, 0, sizeof(*buc));
-	binject_buc_set_magic(buc);
-
-	buc->buf = (unsigned long) io_u->xfer_buf;
-	buc->len = io_u->xfer_buflen;
-	buc->offset = io_u->offset;
-	buc->usr_ptr = (unsigned long) io_u;
-
-	buc->flags = B_FLAG_NOIDLE | B_FLAG_UNPLUG;
-	assert(buc->buf);
-}
-
-static int pollin_events(struct pollfd *pfds, int fds)
-{
-	int i;
-
-	for (i = 0; i < fds; i++)
-		if (pfds[i].revents & POLLIN)
-			return 1;
-
-	return 0;
-}
-
-static unsigned int binject_read_commands(struct thread_data *td, void *buf,
-					  int left, int *err)
-{
-	struct fio_file *f;
-	int i, ret, events;
-	char *p = buf;
-
-one_more:
-	events = 0;
-	for_each_file(td, f, i) {
-		struct binject_file *bf = FILE_ENG_DATA(f);
-
-		ret = read(bf->fd, p, left * sizeof(struct b_user_cmd));
-		if (ret < 0) {
-			if (errno == EAGAIN)
-				continue;
-			*err = -errno;
-			td_verror(td, errno, "read");
-			break;
-		} else if (ret) {
-			p += ret;
-			events += ret / sizeof(struct b_user_cmd);
-		}
-	}
-
-	if (*err || events)
-		return events;
-
-	usleep(1000);
-	goto one_more;
-}
-
-static int fio_binject_getevents(struct thread_data *td, unsigned int min,
-				 unsigned int max,
-				 const struct timespec fio_unused *t)
-{
-	struct binject_data *bd = td->io_ops_data;
-	int left = max, ret, r = 0, ev_index = 0;
-	void *buf = bd->cmds;
-	unsigned int i, events;
-	struct fio_file *f;
-
-	/*
-	 * Fill in the file descriptors
-	 */
-	for_each_file(td, f, i) {
-		struct binject_file *bf = FILE_ENG_DATA(f);
-
-		/*
-		 * don't block for min events == 0
-		 */
-		if (!min)
-			bd->fd_flags[i] = fio_set_fd_nonblocking(bf->fd, "binject");
-		else
-			bd->fd_flags[i] = -1;
-
-		bd->pfds[i].fd = bf->fd;
-		bd->pfds[i].events = POLLIN;
-	}
-
-	while (left) {
-		while (!min) {
-			ret = poll(bd->pfds, td->o.nr_files, -1);
-			if (ret < 0) {
-				if (!r)
-					r = -errno;
-				td_verror(td, errno, "poll");
-				break;
-			} else if (!ret)
-				continue;
-
-			if (pollin_events(bd->pfds, td->o.nr_files))
-				break;
-		}
-
-		if (r < 0)
-			break;
-
-		events = binject_read_commands(td, buf, left, &r);
-
-		if (r < 0)
-			break;
-
-		left -= events;
-		r += events;
-
-		for (i = 0; i < events; i++) {
-			struct b_user_cmd *buc = (struct b_user_cmd *) buf + i;
-
-			bd->events[ev_index] = (struct io_u *) (unsigned long) buc->usr_ptr;
-			ev_index++;
-		}
-	}
-
-	if (!min) {
-		for_each_file(td, f, i) {
-			struct binject_file *bf = FILE_ENG_DATA(f);
-
-			if (bd->fd_flags[i] == -1)
-				continue;
-
-			if (fcntl(bf->fd, F_SETFL, bd->fd_flags[i]) < 0)
-				log_err("fio: binject failed to restore fcntl flags: %s\n", strerror(errno));
-		}
-	}
-
-	if (r > 0)
-		assert(ev_index == r);
-
-	return r;
-}
-
-static int fio_binject_doio(struct thread_data *td, struct io_u *io_u)
-{
-	struct b_user_cmd *buc = &io_u->buc;
-	struct binject_file *bf = FILE_ENG_DATA(io_u->file);
-	int ret;
-
-	ret = write(bf->fd, buc, sizeof(*buc));
-	if (ret < 0)
-		return ret;
-
-	return FIO_Q_QUEUED;
-}
-
-static int fio_binject_prep(struct thread_data *td, struct io_u *io_u)
-{
-	struct binject_data *bd = td->io_ops_data;
-	struct b_user_cmd *buc = &io_u->buc;
-	struct binject_file *bf = FILE_ENG_DATA(io_u->file);
-
-	if (io_u->xfer_buflen & (bf->bs - 1)) {
-		log_err("read/write not sector aligned\n");
-		return EINVAL;
-	}
-
-	if (io_u->ddir == DDIR_READ) {
-		binject_buc_init(bd, io_u);
-		buc->type = B_TYPE_READ;
-	} else if (io_u->ddir == DDIR_WRITE) {
-		binject_buc_init(bd, io_u);
-		if (io_u->flags & IO_U_F_BARRIER)
-			buc->type = B_TYPE_WRITEBARRIER;
-		else
-			buc->type = B_TYPE_WRITE;
-	} else if (io_u->ddir == DDIR_TRIM) {
-		binject_buc_init(bd, io_u);
-		buc->type = B_TYPE_DISCARD;
-	} else {
-		assert(0);
-	}
-
-	return 0;
-}
-
-static int fio_binject_queue(struct thread_data *td, struct io_u *io_u)
-{
-	int ret;
-
-	fio_ro_check(td, io_u);
-
-	ret = fio_binject_doio(td, io_u);
-
-	if (ret < 0)
-		io_u->error = errno;
-
-	if (io_u->error) {
-		td_verror(td, io_u->error, "xfer");
-		return FIO_Q_COMPLETED;
-	}
-
-	return ret;
-}
-
-static struct io_u *fio_binject_event(struct thread_data *td, int event)
-{
-	struct binject_data *bd = td->io_ops_data;
-
-	return bd->events[event];
-}
-
-static int binject_open_ctl(struct thread_data *td)
-{
-	int fd;
-
-	fd = open("/dev/binject-ctl", O_RDWR);
-	if (fd < 0)
-		td_verror(td, errno, "open binject-ctl");
-
-	return fd;
-}
-
-static void binject_unmap_dev(struct thread_data *td, struct binject_file *bf)
-{
-	struct b_ioctl_cmd bic;
-	int fdb;
-
-	if (bf->fd >= 0) {
-		close(bf->fd);
-		bf->fd = -1;
-	}
-
-	fdb = binject_open_ctl(td);
-	if (fdb < 0)
-		return;
-
-	bic.minor = bf->minor;
-
-	if (ioctl(fdb, B_IOCTL_DEL, &bic) < 0)
-		td_verror(td, errno, "binject dev unmap");
-
-	close(fdb);
-}
-
-static int binject_map_dev(struct thread_data *td, struct binject_file *bf,
-			   int fd)
-{
-	struct b_ioctl_cmd bic;
-	char name[80];
-	struct stat sb;
-	int fdb, dev_there, loops;
-
-	fdb = binject_open_ctl(td);
-	if (fdb < 0)
-		return 1;
-
-	bic.fd = fd;
-
-	if (ioctl(fdb, B_IOCTL_ADD, &bic) < 0) {
-		td_verror(td, errno, "binject dev map");
-		close(fdb);
-		return 1;
-	}
-
-	bf->minor = bic.minor;
-
-	sprintf(name, "/dev/binject%u", bf->minor);
-
-	/*
-	 * Wait for udev to create the node...
-	 */
-	dev_there = loops = 0;
-	do {
-		if (!stat(name, &sb)) {
-			dev_there = 1;
-			break;
-		}
-
-		usleep(10000);
-	} while (++loops < 100);
-
-	close(fdb);
-
-	if (!dev_there) {
-		log_err("fio: timed out waiting for binject dev\n");
-		goto err_unmap;
-	}
-
-	bf->fd = open(name, O_RDWR);
-	if (bf->fd < 0) {
-		td_verror(td, errno, "binject dev open");
-err_unmap:
-		binject_unmap_dev(td, bf);
-		return 1;
-	}
-
-	return 0;
-}
-
-static int fio_binject_close_file(struct thread_data *td, struct fio_file *f)
-{
-	struct binject_file *bf = FILE_ENG_DATA(f);
-
-	if (bf) {
-		binject_unmap_dev(td, bf);
-		free(bf);
-		FILE_SET_ENG_DATA(f, NULL);
-		return generic_close_file(td, f);
-	}
-
-	return 0;
-}
-
-static int fio_binject_open_file(struct thread_data *td, struct fio_file *f)
-{
-	struct binject_file *bf;
-	unsigned int bs;
-	int ret;
-
-	ret = generic_open_file(td, f);
-	if (ret)
-		return 1;
-
-	if (f->filetype != FIO_TYPE_BLOCK) {
-		log_err("fio: binject only works with block devices\n");
-		goto err_close;
-	}
-	if (ioctl(f->fd, BLKSSZGET, &bs) < 0) {
-		td_verror(td, errno, "BLKSSZGET");
-		goto err_close;
-	}
-
-	bf = malloc(sizeof(*bf));
-	bf->bs = bs;
-	bf->minor = bf->fd = -1;
-	FILE_SET_ENG_DATA(f, bf);
-
-	if (binject_map_dev(td, bf, f->fd)) {
-err_close:
-		ret = generic_close_file(td, f);
-		return 1;
-	}
-
-	return 0;
-}
-
-static void fio_binject_cleanup(struct thread_data *td)
-{
-	struct binject_data *bd = td->io_ops_data;
-
-	if (bd) {
-		free(bd->events);
-		free(bd->cmds);
-		free(bd->fd_flags);
-		free(bd->pfds);
-		free(bd);
-	}
-}
-
-static int fio_binject_init(struct thread_data *td)
-{
-	struct binject_data *bd;
-
-	bd = malloc(sizeof(*bd));
-	memset(bd, 0, sizeof(*bd));
-
-	bd->cmds = malloc(td->o.iodepth * sizeof(struct b_user_cmd));
-	memset(bd->cmds, 0, td->o.iodepth * sizeof(struct b_user_cmd));
-
-	bd->events = malloc(td->o.iodepth * sizeof(struct io_u *));
-	memset(bd->events, 0, td->o.iodepth * sizeof(struct io_u *));
-
-	bd->pfds = malloc(sizeof(struct pollfd) * td->o.nr_files);
-	memset(bd->pfds, 0, sizeof(struct pollfd) * td->o.nr_files);
-
-	bd->fd_flags = malloc(sizeof(int) * td->o.nr_files);
-	memset(bd->fd_flags, 0, sizeof(int) * td->o.nr_files);
-
-	td->io_ops_data = bd;
-	return 0;
-}
-
-static struct ioengine_ops ioengine = {
-	.name		= "binject",
-	.version	= FIO_IOOPS_VERSION,
-	.init		= fio_binject_init,
-	.prep		= fio_binject_prep,
-	.queue		= fio_binject_queue,
-	.getevents	= fio_binject_getevents,
-	.event		= fio_binject_event,
-	.cleanup	= fio_binject_cleanup,
-	.open_file	= fio_binject_open_file,
-	.close_file	= fio_binject_close_file,
-	.get_file_size	= generic_get_file_size,
-	.flags		= FIO_RAWIO | FIO_BARRIER | FIO_MEMALIGN,
-};
-
-#else /* FIO_HAVE_BINJECT */
-
-/*
- * When we have a proper configure system in place, we simply wont build
- * and install this io engine. For now install a crippled version that
- * just complains and fails to load.
- */
-static int fio_binject_init(struct thread_data fio_unused *td)
-{
-	log_err("fio: ioengine binject not available\n");
-	return 1;
-}
-
-static struct ioengine_ops ioengine = {
-	.name		= "binject",
-	.version	= FIO_IOOPS_VERSION,
-	.init		= fio_binject_init,
-};
-
-#endif
-
-static void fio_init fio_binject_register(void)
-{
-	register_ioengine(&ioengine);
-}
-
-static void fio_exit fio_binject_unregister(void)
-{
-	unregister_ioengine(&ioengine);
-}
diff --git a/eta.c b/eta.c
index 2d549ee..9111f5e 100644
--- a/eta.c
+++ b/eta.c
@@ -149,7 +149,7 @@ void eta_to_str(char *str, unsigned long eta_sec)
 		str += sprintf(str, "%02uh:", h);
 
 	str += sprintf(str, "%02um:", m);
-	str += sprintf(str, "%02us", s);
+	sprintf(str, "%02us", s);
 }
 
 /*
@@ -621,7 +621,7 @@ void display_thread_status(struct jobs_eta *je)
 			free(iops_str[ddir]);
 		}
 	}
-	p += sprintf(p, "\r");
+	sprintf(p, "\r");
 
 	printf("%s", output);
 
diff --git a/filesetup.c b/filesetup.c
index b246e0f..75694bd 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -490,7 +490,6 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 	} else if (td_ioengine_flagged(td, FIO_DISKLESSIO)) {
 		dprint(FD_IO, "invalidate not supported by ioengine %s\n",
 		       td->io_ops->name);
-		ret = 0;
 	} else if (f->filetype == FIO_TYPE_FILE) {
 		dprint(FD_IO, "declare unneeded cache %s: %llu/%llu\n",
 			f->file_name, off, len);
@@ -517,14 +516,12 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 				log_err("fio: only root may flush block "
 					"devices. Cache flush bypassed!\n");
 			}
-			ret = 0;
 		}
 		if (ret < 0)
 			errval = errno;
 	} else if (f->filetype == FIO_TYPE_CHAR ||
 		   f->filetype == FIO_TYPE_PIPE) {
 		dprint(FD_IO, "invalidate not supported %s\n", f->file_name);
-		ret = 0;
 	}
 
 	/*
diff --git a/io_u.h b/io_u.h
index aaa7d97..4f433c3 100644
--- a/io_u.h
+++ b/io_u.h
@@ -113,9 +113,6 @@ struct io_u {
 #ifdef CONFIG_SOLARISAIO
 		aio_result_t resultp;
 #endif
-#ifdef FIO_HAVE_BINJECT
-		struct b_user_cmd buc;
-#endif
 #ifdef CONFIG_RDMA
 		struct ibv_mr *mr;
 #endif
diff --git a/lib/axmap.c b/lib/axmap.c
index bf203df..3c65308 100644
--- a/lib/axmap.c
+++ b/lib/axmap.c
@@ -102,7 +102,7 @@ struct axmap *axmap_new(unsigned long nr_bits)
 	}
 
 	axmap->nr_levels = levels;
-	axmap->levels = malloc(axmap->nr_levels * sizeof(struct axmap_level));
+	axmap->levels = calloc(axmap->nr_levels, sizeof(struct axmap_level));
 	axmap->nr_bits = nr_bits;
 
 	for (i = 0; i < axmap->nr_levels; i++) {
diff --git a/options.c b/options.c
index 17d7245..fae3943 100644
--- a/options.c
+++ b/options.c
@@ -1816,11 +1816,6 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "GUASI IO engine",
 			  },
 #endif
-#ifdef FIO_HAVE_BINJECT
-			  { .ival = "binject",
-			    .help = "binject direct inject block engine",
-			  },
-#endif
 #ifdef CONFIG_RDMA
 			  { .ival = "rdma",
 			    .help = "RDMA IO engine",
diff --git a/os/binject.h b/os/binject.h
deleted file mode 100644
index 1d862c8..0000000
--- a/os/binject.h
+++ /dev/null
@@ -1,71 +0,0 @@
-#ifndef BINJECT_H
-#define BINJECT_H
-
-#include <linux/types.h>
-
-#define BINJECT_MAGIC		0x89
-#define BINJECT_VER		0x01
-#define BINJECT_MAGIC_SHIFT	8
-#define BINJECT_VER_MASK	((1 << BINJECT_MAGIC_SHIFT) - 1)
-
-struct b_user_cmd {
-	__u16 magic;	/* INPUT */
-	__u16 type;	/* INPUT */
-	__u32 error;	/* OUTPUT */
-	__u32 flags;	/* INPUT */
-	__u32 len;	/* INPUT */
-	__u64 offset;	/* INPUT */
-	__u64 buf;	/* INPUT */
-	__u64 usr_ptr;	/* PASSED THROUGH */
-	__u64 nsec;	/* OUTPUT */
-};
-
-struct b_ioctl_cmd {
-	int fd;
-	int minor;
-};
-
-#define BINJECT_IOCTL_CHR	'J'
-#define B_IOCTL_ADD		_IOWR(BINJECT_IOCTL_CHR, 1, struct b_ioctl_cmd)
-#define B_IOCTL_DEL		_IOWR(BINJECT_IOCTL_CHR, 2, struct b_ioctl_cmd)
-
-enum {
-	B_TYPE_READ		= 0,
-	B_TYPE_WRITE,
-	B_TYPE_DISCARD,
-	B_TYPE_READVOID,
-	B_TYPE_WRITEZERO,
-	B_TYPE_READBARRIER,
-	B_TYPE_WRITEBARRIER,
-	B_TYPE_NR
-};
-
-enum {
-	__B_FLAG_SYNC	= 0,
-	__B_FLAG_UNPLUG,
-	__B_FLAG_NOIDLE,
-	__B_FLAG_BARRIER,
-	__B_FLAG_META,
-	__B_FLAG_RAHEAD,
-	__B_FLAG_FAILFAST_DEV,
-	__B_FLAG_FAILFAST_TRANSPORT,
-	__B_FLAG_FAILFAST_DRIVER,
-	__B_FLAG_NR,
-
-	B_FLAG_SYNC			= 1 << __B_FLAG_SYNC,
-	B_FLAG_UNPLUG			= 1 << __B_FLAG_UNPLUG,
-	B_FLAG_NOIDLE			= 1 << __B_FLAG_NOIDLE,
-	B_FLAG_BARRIER			= 1 << __B_FLAG_BARRIER,
-	B_FLAG_META			= 1 << __B_FLAG_META,
-	B_FLAG_RAHEAD			= 1 << __B_FLAG_RAHEAD,
-	B_FLAG_FAILFAST_DEV		= 1 << __B_FLAG_FAILFAST_DEV,
-	B_FLAG_FAILFAST_TRANSPORT	= 1 << __B_FLAG_FAILFAST_TRANSPORT,
-	B_FLAG_FAILFAST_DRIVER		= 1 << __B_FLAG_FAILFAST_DRIVER,
-};
-
-static inline void binject_buc_set_magic(struct b_user_cmd *buc)
-{
-	buc->magic = (BINJECT_MAGIC << BINJECT_MAGIC_SHIFT) | BINJECT_VER;
-}
-
-#endif
diff --git a/os/os-android.h b/os/os-android.h
index bb590e4..1483275 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -18,7 +18,6 @@
 #include <asm/byteorder.h>
 
 #include "./os-linux-syscall.h"
-#include "binject.h"
 #include "../file.h"
 
 #ifndef __has_builtin         // Optional of course.
diff --git a/os/os-linux.h b/os/os-linux.h
index 1d400a0..a550bba 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -27,7 +27,6 @@
 #endif /* ARCH_HAVE_CRC_CRYPTO */
 
 #include "./os-linux-syscall.h"
-#include "binject.h"
 #include "../file.h"
 
 #ifndef __has_builtin         // Optional of course.
@@ -48,7 +47,6 @@
 #define FIO_HAVE_CGROUPS
 #define FIO_HAVE_FS_STAT
 #define FIO_HAVE_TRIM
-#define FIO_HAVE_BINJECT
 #define FIO_HAVE_GETTID
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_PWRITEV2
diff --git a/parse.c b/parse.c
index 3993471..539c602 100644
--- a/parse.c
+++ b/parse.c
@@ -1185,8 +1185,6 @@ static void __print_option(const struct fio_option *o,
 
 	if (!o)
 		return;
-	if (!org)
-		org = o;
 
 	p = name;
 	depth = level;
diff --git a/server.c b/server.c
index d3f6977..2e08c66 100644
--- a/server.c
+++ b/server.c
@@ -1199,7 +1199,6 @@ static int handle_connection(struct sk_out *sk_out)
 			.events	= POLLIN,
 		};
 
-		ret = 0;
 		do {
 			int timeout = 1000;
 
diff --git a/steadystate.c b/steadystate.c
index 1e3a546..ee1c0e5 100644
--- a/steadystate.c
+++ b/steadystate.c
@@ -350,6 +350,9 @@ uint64_t steadystate_bw_mean(struct thread_stat *ts)
 	int i;
 	uint64_t sum;
 
+	if (!ts->ss_dur)
+		return 0;
+
 	for (i = 0, sum = 0; i < ts->ss_dur; i++)
 		sum += ts->ss_bw_data[i];
 
@@ -361,6 +364,9 @@ uint64_t steadystate_iops_mean(struct thread_stat *ts)
 	int i;
 	uint64_t sum;
 
+	if (!ts->ss_dur)
+		return 0;
+
 	for (i = 0, sum = 0; i < ts->ss_dur; i++)
 		sum += ts->ss_iops_data[i];
 
