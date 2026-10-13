Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700DA4FB9A0
	for <fio@vger.kernel.org>; Tue, 13 Oct 2026 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892811; cv=none; b=BhvoUI+dd+o107foeKmtZ+7ixSCh2jO5A6ujLgIvOePMaEV+K91GvLlyW+5cLsmwWXxXgiHlQX8h1zZralXlOHZZjdRVSldQfFhyOgVlxZqq54HHPOuMNB+4hyZbFxKJeXGKeRuJ1HpLRDU6R9evMO6gMFSjKwzIJF7nYS0PdFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892811; c=relaxed/simple;
	bh=X+1vmuXBRjkAZT2TU3bWRSe2mnZ5063eVgzo3fS7P4o=;
	h=Subject:From:To:Date:Message-Id; b=Xgd+Vcx3p4DlP4UOXPfv0nPKUOpRlfC9GVcZwUJNhcI6FAbw2TQTDy3eDFNwinx2CSb6hpb+EcpRh/MmL+ZbVPbn3aJCwjlPg+24stU+BQ8c3cLGpQ5CQ22hnIAvnaZvhIrNoAU5u0PyLcUB60mpRB+FLNH/yjXs28Oq/3iEIeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TuOMXvoL; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TuOMXvoL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=GzKm0iRplOad+3kY12Zf4lmsrPI3G12X1IcnlPgCQ4k=; b=TuOMXvoLD2aBG8l9iYWkoGhL3V
	LLYp/OviOtjlFNSS2tOFv+rHJYWOM7vFg5StH5PyqLbJISDBZPlAGgxAPbVidI0bcgE8lzb+uFX0j
	HD6IkkFjQ4atVpWg+hNtpCD9JfireJwDXP1mOgJmRj1jVgecujfFB1nsiXl7L22Q4L7aMWh7aK6ky
	ojoCIFWGjSL/PWtXZnPP1uEjFMr+SXYbLtQpi8ybC7duUGR4MNrCC4aWvXxWnx91a3wzlgSqF28d3
	TBDdV4KmlgXSyT2vcNvilEqN2IqtF77WSAlsg3RehjlIOMcq+hbP1xXGCdNRGRCZb1VPtKRumnuR1
	gwfs5CZQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGbAq-0000000D7oE-35vr
	for fio@vger.kernel.org;
	Tue, 13 Oct 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 62CC01BC0152; Tue, 13 Oct 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Tue, 13 Oct 2026 06:00:01 -0600
Message-Id: <20261013120001.62CC01BC0152@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit daf3f3b837f81ac2464c6a67bba829c984d65a3f:

  Merge branch 'master' of https://github.com/rorychen/fio-HSMR (2026-10-01 14:26:20 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to acb7a302059b0cc397c95a232a44cb14c524bbde:

  Merge branch 'dmabuf-io_uringv1' of https://github.com/swarnagh6/fio (2026-10-12 19:21:58 -0400)

----------------------------------------------------------------
Swarna Prabhu (1):
      engines/io_uring: add support for dmabuf backed fixed buffers

Vincent Fu (1):
      Merge branch 'dmabuf-io_uringv1' of https://github.com/swarnagh6/fio

 HOWTO.rst           |  16 +++
 configure           |  32 +++++
 engines/io_uring.c  | 344 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 examples/dmabuf.fio |  14 +++
 fio.1               |  16 +++
 os/linux/io_uring.h |  23 +++-
 6 files changed, 439 insertions(+), 6 deletions(-)
 create mode 100644 examples/dmabuf.fio

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 3684fe70..0b39b01a 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2559,6 +2559,22 @@ with the caveat that when used on the command line, they must come after the
 	map and release for each IO. This is more efficient, and reduces the
 	IO latency as well.
 
+.. option:: dmabuf=str : [io_uring]
+
+	Select the DMA-BUF exporter for the IO buffers. Allowed values are:
+
+		**none**
+			Do not use DMA-BUF-backed buffers. This is the default.
+
+		**udmabuf**
+			Allocate the IO buffers from a udmabuf (``/dev/udmabuf``)
+			region and register them with io_uring as DMA-BUF-backed
+			fixed buffers, so that the device DMAs directly to/from the
+			DMA-BUF. Requires :option:`direct` =1; buffered IO is not
+			supported. Requires a kernel that supports the extended
+			buffer registration update. Not supported io_uring_cmd mode
+			as kernel lacks support for passthrough.
+
 .. option:: nonvectored=int : [io_uring] [io_uring_cmd]
 
 	With this option, fio will use non-vectored read/write commands, where
diff --git a/configure b/configure
index 2ab83371..60d0ef98 100755
--- a/configure
+++ b/configure
@@ -2709,6 +2709,38 @@ else
   nvme_uring_cmd="no"
 fi
 print_config "NVMe uring command support" "$nvme_uring_cmd"
+
+##########################################
+# Check udmabuf allocation support
+cat > $TMPC << EOF
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <sys/mman.h>
+#include <sys/ioctl.h>
+#include <linux/udmabuf.h>
+int main(void)
+{
+  struct udmabuf_create create = {
+    .memfd = 0,
+    .flags = 0,
+    .offset = 0,
+    .size = 4096,
+  };
+  int (*create_memfd)(const char *, unsigned int) = memfd_create;
+  int fd = create_memfd("fio-udmabuf", MFD_ALLOW_SEALING);
+
+  if (fcntl(fd, F_ADD_SEALS, F_SEAL_SHRINK) < 0)
+    return 1;
+  return ioctl(fd, UDMABUF_CREATE, &create);
+}
+EOF
+if compile_prog "" "" "udmabuf"; then
+  output_sym "CONFIG_UDMABUF"
+  udmabuf="yes"
+else
+  udmabuf="no"
+fi
+print_config "udmabuf allocation support" "$udmabuf"
 fi
 
 ##########################################
diff --git a/engines/io_uring.c b/engines/io_uring.c
index f1e0527c..a7b67ce7 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -26,6 +26,9 @@
 #include "zbd.h"
 #include "nvme.h"
 #include "bsg.h"
+#ifdef CONFIG_UDMABUF
+#include <linux/udmabuf.h>
+#endif
 
 #include <sys/stat.h>
 
@@ -125,6 +128,15 @@ enum uring_cmd_read_mode {
 	FIO_URING_CMD_RMODE_READ = 0,
 	FIO_URING_CMD_RMODE_PREFETCH,
 };
+/*
+ * dmabuf exporter backing the pre-mapped IO buffers. Only "udmabuf" is
+ * supported as of now, but can add support for GPU dmabuf exporters
+ * in the future.
+ */
+enum uring_dmabuf_type {
+	FIO_URING_DMABUF_NONE = 0,
+	FIO_URING_DMABUF_UDMABUF,
+};
 
 struct io_sq_ring {
 	unsigned *head;
@@ -192,6 +204,15 @@ struct ioring_data {
 	bool fua[DDIR_RWDIR_CNT];
 	enum bsg_write_mode wmode;
 	enum bsg_read_mode rmode;
+	struct buf_udma *dmabuf;
+};
+
+struct buf_udma {
+	void *ptr;
+	size_t size;
+	int dmabuf_fd;
+	int memfd;
+	int target_fd;
 };
 
 struct ioring_options {
@@ -224,6 +245,7 @@ struct ioring_options {
 	unsigned int cdb_len;
 	unsigned int verify_bytchk;
 	unsigned int read_mode;
+	enum uring_dmabuf_type dmabuf;
 };
 
 static unsigned int enter_flags = IORING_ENTER_GETEVENTS;
@@ -673,6 +695,26 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
+	{
+		.name	= "dmabuf",
+		.lname	= "Pre-mapped dma buffers",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct ioring_options, dmabuf),
+		.help	= "Back pre-mapped IO buffers with a dmabuf exporter",
+		.def	= "none",
+		.posval = {
+			  { .ival = "none",
+			    .oval = FIO_URING_DMABUF_NONE,
+			    .help = "Do not use dmabuf-backed buffers"
+			  },
+			  { .ival = "udmabuf",
+			    .oval = FIO_URING_DMABUF_UDMABUF,
+			    .help = "Use udmabuf-backed dmabuf buffers"
+			  },
+		},
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
 	{
 		.name	= NULL,
 	},
@@ -695,6 +737,238 @@ static int io_uring_enter(struct ioring_data *ld, unsigned int to_submit,
 #define BLOCK_URING_CMD_DISCARD	_IO(0x12, 0)
 #endif
 
+static int create_udmabuf(struct buf_udma *b, size_t size)
+{
+#ifdef CONFIG_UDMABUF
+	struct udmabuf_create create;
+	int memfd = -1, dmabuf_fd = -1, devfd = -1;
+	void *p;
+
+	size = (size + page_mask) & ~page_mask;
+
+	devfd = open("/dev/udmabuf", O_RDWR);
+	if (devfd < 0) {
+		log_err("fio: failed to open /dev/udmabuf: %s\n",
+			strerror(errno));
+		return -1;
+	}
+
+	memfd = memfd_create("fio-udmabuf", MFD_ALLOW_SEALING);
+	if (memfd < 0) {
+		log_err("fio: memfd_create failed: %s\n", strerror(errno));
+		goto err;
+	}
+
+	if (fcntl(memfd, F_ADD_SEALS, F_SEAL_SHRINK) < 0) {
+		log_err("fio: failed to seal memfd: %s\n", strerror(errno));
+		goto err;
+	}
+
+	if (ftruncate(memfd, size) < 0) {
+		log_err("fio: failed to size memfd to %llu bytes: %s\n",
+			(unsigned long long) size, strerror(errno));
+		goto err;
+	}
+
+	memset(&create, 0, sizeof(create));
+	create.memfd = memfd;
+	create.offset = 0;
+	create.size = size;
+	dmabuf_fd = ioctl(devfd, UDMABUF_CREATE, &create);
+	if (dmabuf_fd < 0) {
+		log_err("fio: UDMABUF_CREATE (size %llu) failed: %s\n",
+			(unsigned long long) size, strerror(errno));
+		goto err;
+	}
+
+	p = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, dmabuf_fd, 0);
+	if (p == MAP_FAILED) {
+		log_err("fio: failed to mmap udmabuf: %s\n", strerror(errno));
+		goto err;
+	}
+
+	close(devfd);
+	b->size = size;
+	b->dmabuf_fd = dmabuf_fd;
+	b->memfd = memfd;
+	b->ptr = p;
+	dprint(FD_MEM, "udmabuf dmabuf_fd=%d memfd=%d size=%llu ptr=%p\n",
+	       dmabuf_fd, memfd, (unsigned long long) size, p);
+	return 0;
+err:
+	if (dmabuf_fd >= 0)
+		close(dmabuf_fd);
+	if (memfd >= 0)
+		close(memfd);
+	close(devfd);
+	return -1;
+#else
+	(void) b;
+	(void) size;
+	log_err("fio: dmabuf=udmabuf is not supported by this build\n");
+	return -1;
+#endif
+}
+
+/*
+ * iomem hooks. When dmabuf=udmabuf, back td->orig_buffer with a udmabuf
+ * region so io_u buffers carved out of it can be registered with io_uring
+ * as dmabuf-backed fixed buffers. With dmabuf=none, use malloc by default.
+ * Note:FIO_SKIPPABLE_IOMEM_ALLOC allows an explicit iomem= setting to override
+ * these hooks and use fio's selected memory allocator instead.
+ */
+static int fio_ioring_iomem_alloc(struct thread_data *td, size_t total_mem)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+
+	if (!o->dmabuf) {
+		if (td->o.mem_type != MEM_MALLOC) {
+			log_err("fio: io_uring: unexpected mem_type expected "
+				"default malloc\n");
+			return 1;
+		}
+		td->orig_buffer = malloc(total_mem);
+		dprint(FD_MEM, "iouring malloc %llu %p\n",
+		       (unsigned long long) total_mem, td->orig_buffer);
+		return td->orig_buffer == NULL;
+	}
+
+	ld->dmabuf = calloc(1, sizeof(*ld->dmabuf));
+	if (!ld->dmabuf) {
+		log_err("fio: failed to allocate dmabuf state\n");
+		return 1;
+	}
+	ld->dmabuf->dmabuf_fd = -1;
+	ld->dmabuf->memfd = -1;
+	ld->dmabuf->target_fd = -1;
+
+	switch (o->dmabuf) {
+	case FIO_URING_DMABUF_UDMABUF:
+		if (create_udmabuf(ld->dmabuf, total_mem) < 0) {
+			free(ld->dmabuf);
+			ld->dmabuf = NULL;
+			return 1;
+		}
+		break;
+	default:
+		log_err("fio: unsupported dmabuf exporter\n");
+		free(ld->dmabuf);
+		ld->dmabuf = NULL;
+		return 1;
+	}
+
+	td->orig_buffer = ld->dmabuf->ptr;
+	dprint(FD_MEM, "iouring dmabuf %llu %p\n",
+	       (unsigned long long) total_mem, td->orig_buffer);
+	return 0;
+}
+
+static void fio_ioring_iomem_free(struct thread_data *td)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+
+	if (!o->dmabuf) {
+		free(td->orig_buffer);
+		td->orig_buffer = NULL;
+		return;
+	}
+
+	if (ld && ld->dmabuf) {
+		if (ld->dmabuf->ptr)
+			munmap(ld->dmabuf->ptr, ld->dmabuf->size);
+		if (ld->dmabuf->dmabuf_fd >= 0)
+			close(ld->dmabuf->dmabuf_fd);
+		if (ld->dmabuf->memfd >= 0)
+			close(ld->dmabuf->memfd);
+		if (ld->dmabuf->target_fd >= 0)
+			close(ld->dmabuf->target_fd);
+		free(ld->dmabuf);
+		ld->dmabuf = NULL;
+	}
+	td->orig_buffer = NULL;
+}
+
+static int fio_ioring_register_dmabuf_buffers(struct thread_data *td,
+					      struct ioring_data *ld, int depth)
+{
+	struct io_uring_rsrc_register reg = {
+		.nr = depth,
+		.flags = IORING_RSRC_REGISTER_SPARSE,
+	};
+	struct io_uring_regbuf_desc *rbs;
+	struct io_uring_rsrc_update2 up;
+	struct fio_file *f = td->files[0];
+	int i, ret, nr = td->o.iodepth;
+	bool opened = false;
+
+	ret = syscall(__NR_io_uring_register, ld->ring_fd,
+		IORING_REGISTER_BUFFERS2, &reg, sizeof(reg));
+	if (ret < 0) {
+		log_err("fio: failed to register %d sparse buffers: %s\n",
+			depth, strerror(errno));
+		return ret;
+	}
+
+	rbs = calloc(nr, sizeof(*rbs));
+	if (!rbs)
+		return -1;
+
+	/*
+	 * The buffers are attached to the device that will DMA to/from them,
+	 * so registration needs the target fd.
+	 */
+	if (f->fd == -1) {
+		if (generic_open_file(td, f)) {
+			log_err("fio: failed to open %s for dmabuf buffer "
+				"registration\n", f->file_name);
+			free(rbs);
+			return -1;
+		}
+		opened = true;
+	}
+
+	for (i = 0; i < nr; i++) {
+		rbs[i].type = IO_REGBUF_TYPE_DMABUF;
+		/* uaddr and size must be zero for IO_REGBUF_TYPE_DMABUF */
+		rbs[i].dmabuf_fd = ld->dmabuf->dmabuf_fd;
+		rbs[i].target_fd = f->fd;
+		dprint(FD_IO, "iouring dmabuf reg[%d] tfd=%d dfd=%d\n",
+		       i, rbs[i].target_fd, rbs[i].dmabuf_fd);
+	}
+
+	memset(&up, 0, sizeof(up));
+	up.flags = IORING_RSRC_UPDATE_EXTENDED;
+	up.data = (unsigned long long)(uintptr_t) rbs;
+	up.nr = nr;
+
+	ret = syscall(__NR_io_uring_register, ld->ring_fd,
+		IORING_REGISTER_BUFFERS_UPDATE, &up, sizeof(up));
+	if (ret < 0)
+		log_err("fio: dmabuf fixed buffer update failed: %s\n",
+			strerror(errno));
+
+	free(rbs);
+
+	if (ret < 0) {
+		if (opened) {
+			int fio_unused ret2;
+			ret2 = generic_close_file(td, f);
+		}
+		return ret;
+	}
+
+	/*
+	 * store the file descriptor so that it can be read from
+	 * fio_ioring_open_file correctly.
+	 */
+	ld->dmabuf->target_fd = f->fd;
+	if (opened)
+		f->fd = -1;
+	return 0;
+}
+
 static void fio_ioring_prep_md(struct thread_data *td, struct io_u *io_u)
 {
 	struct ioring_data *ld = td->io_ops_data;
@@ -732,9 +1006,13 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 	}
 
 	if (io_u->ddir == DDIR_READ || io_u->ddir == DDIR_WRITE) {
-		if (o->fixedbufs) {
+		if (o->fixedbufs || o->dmabuf) {
 			sqe->opcode = fixed_ddir_to_op[io_u->ddir];
-			sqe->addr = (unsigned long) io_u->xfer_buf;
+			if (o->dmabuf)
+				sqe->addr = (unsigned long)io_u->xfer_buf -
+					    (unsigned long)td->orig_buffer;
+			else
+				sqe->addr = (unsigned long) io_u->xfer_buf;
 			sqe->len = io_u->xfer_buflen;
 			sqe->buf_index = io_u->index;
 		} else {
@@ -1380,6 +1658,7 @@ static void fio_ioring_cleanup(struct thread_data *td)
 		free(ld->fds);
 		free(ld->dsm);
 		free(ld->bc);
+		/* ld->dmabuf is released by fio_ioring_iomem_free() */
 		free(ld);
 	}
 }
@@ -1552,6 +1831,10 @@ retry:
 				IORING_REGISTER_BUFFERS, ld->iovecs, depth);
 		if (ret < 0)
 			return ret;
+	} else if (o->dmabuf) {
+		ret = fio_ioring_register_dmabuf_buffers(td, ld, depth);
+		if (ret < 0)
+			return ret;
 	}
 
 	return fio_ioring_mmap(ld, &p);
@@ -1800,6 +2083,38 @@ static int fio_ioring_init(struct thread_data *td)
 		return 1;
 	}
 
+	if (o->dmabuf) {
+		if (td->io_ops->prep == fio_ioring_cmd_prep) {
+			log_err("fio: dmabuf is not supported in "
+				"io_uring_cmd mode\n");
+			return 1;
+		}
+		if (!td->o.odirect) {
+			log_err("fio: dmabuf requires direct=1\n");
+			return 1;
+		}
+		/*
+		 * Both register the fixed buffer table, and dmabuf needs to
+		 * own the IO buffer allocation so that the io_u buffers fio
+		 * fills and verifies are the ones the device DMAs to/from.
+		 */
+		if (o->fixedbufs) {
+			log_err("fio: dmabuf and fixedbufs are mutually "
+				"exclusive\n");
+			return 1;
+		}
+		if (fio_option_is_set(&td->o, mem_type)) {
+			log_err("fio: dmabuf cannot be combined with "
+				"mem/iomem\n");
+			return 1;
+		}
+		/* the buffers are attached to a single target device */
+		if (td->o.nr_files != 1) {
+			log_err("fio: dmabuf requires exactly one file\n");
+			return 1;
+		}
+	}
+
 	ld = calloc(1, sizeof(*ld));
 
 	ld->is_uring_cmd_eng = (td->io_ops->prep == fio_ioring_cmd_prep);
@@ -2060,6 +2375,19 @@ static int fio_ioring_open_file(struct thread_data *td, struct fio_file *f)
 			return ret;
 	}
 
+	/*
+	 * cannot use the generic_open_file routine as it will open a different fd
+	 * that would fail, since for dmabuf path we bind the buffers to struct file
+	 * from the original fd used at registration time while issuing
+	 * IORING_REGISTER_BUFFER_UPDATE syscall. Hence use the real fd that was opened
+	 * once at registration time and therefore bypassing the standard file
+	 * handling routine is needed for correctness for this case.
+	 */
+	if (ld && o->dmabuf) {
+		f->fd = ld->dmabuf->target_fd;
+		return 0;
+	}
+
 	if (!ld || !o->registerfiles)
 		return generic_open_file(td, f);
 
@@ -2189,8 +2517,14 @@ static int fio_ioring_close_file(struct thread_data *td, struct fio_file *f)
 	struct ioring_data *ld = td->io_ops_data;
 	struct ioring_options *o = td->eo;
 
-	if (!ld || !o->registerfiles)
+	if (!ld || !o->registerfiles) {
+		if (ld && o->dmabuf) {
+			/* actual close deferred to iomem_free to keep target_file alive */
+			f->fd = -1;
+			return 0;
+		}
 		return generic_close_file(td, f);
+	}
 
 	f->fd = -1;
 	return 0;
@@ -2401,9 +2735,11 @@ static struct ioengine_ops ioengine_uring = {
 	.name			= "io_uring",
 	.version		= FIO_IOOPS_VERSION,
 	.flags			= FIO_NO_OFFLOAD | FIO_ASYNCIO_SETS_ISSUE_TIME |
-				  FIO_ATOMICWRITES,
+				  FIO_ATOMICWRITES | FIO_SKIPPABLE_IOMEM_ALLOC,
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_post_init,
+	.iomem_alloc		= fio_ioring_iomem_alloc,
+	.iomem_free		= fio_ioring_iomem_free,
 	.io_u_init		= fio_ioring_io_u_init,
 	.io_u_free		= fio_ioring_io_u_free,
 	.prep			= fio_ioring_prep,
diff --git a/examples/dmabuf.fio b/examples/dmabuf.fio
new file mode 100644
index 00000000..49037bf1
--- /dev/null
+++ b/examples/dmabuf.fio
@@ -0,0 +1,14 @@
+[global]
+filename=/dev/nvme1n1
+rw=write
+bs=4096
+direct=1
+runtime=30
+time_based=1
+group_reporting=1
+
+[file1]
+iodepth=128
+fixedbufs=0
+dmabuf=udmabuf
+ioengine=io_uring
\ No newline at end of file
diff --git a/fio.1 b/fio.1
index 7dc5c353..08153d30 100644
--- a/fio.1
+++ b/fio.1
@@ -2342,6 +2342,22 @@ release them when IO is done. If this option is set, the pages are pre-mapped
 before IO is started. This eliminates the need to map and release for each IO.
 This is more efficient, and reduces the IO latency as well.
 .TP
+.BI (io_uring)dmabuf \fR=\fPstr
+Select the DMA-BUF exporter for the IO buffers. Allowed values are:
+.RS
+.TP
+.B none
+Do not use DMA-BUF-backed buffers. This is the default.
+.TP
+.B udmabuf
+Allocate the IO buffers from a udmabuf (\fB/dev/udmabuf\fR) region and
+register them with io_uring as DMA-BUF-backed fixed buffers, so that the
+device DMAs directly to/from the DMA-BUF. Requires \fBdirect\fR=1;
+buffered IO is not supported. Requires a kernel that supports
+the extended buffer registration update. Not supported io_uring_cmd mode
+as kernel lacks support for passthrough.
+.RE
+.TP
 .BI (io_uring,io_uring_cmd)nonvectored \fR=\fPint
 With this option, fio will use non-vectored read/write commands, where address
 must contain the address directly. Default is -1.
diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index cadcadae..00c86293 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -463,7 +463,7 @@ struct io_uring_files_update {
 
 struct io_uring_rsrc_register {
 	__u32 nr;
-	__u32 resv;
+	__u32 flags;
 	__u64 resv2;
 	__aligned_u64 data;
 	__aligned_u64 tags;
@@ -477,7 +477,7 @@ struct io_uring_rsrc_update {
 
 struct io_uring_rsrc_update2 {
 	__u32 offset;
-	__u32 resv;
+	__u32 flags;
 	__aligned_u64 data;
 	__aligned_u64 tags;
 	__u32 nr;
@@ -541,4 +541,23 @@ struct io_uring_getevents_arg {
 	__u64	ts;
 };
 
+#define IORING_RSRC_REGISTER_SPARSE    (1U << 0)
+#define IORING_RSRC_UPDATE_EXTENDED   (1U << 1)
+
+enum io_uring_regbuf_type {
+	IO_REGBUF_TYPE_EMPTY,
+	IO_REGBUF_TYPE_UADDR,
+	IO_REGBUF_TYPE_DMABUF,
+};
+
+struct io_uring_regbuf_desc {
+	__u32 type;
+	__u32 flags;
+	__u64 size;
+	__u64 uaddr;
+	__s32 dmabuf_fd;
+	__s32 target_fd;
+	__u64 __resv[6];
+};
+
 #endif
