Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66113BB9F3
	for <fio@vger.kernel.org>; Wed,  8 Apr 2026 12:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775649608; cv=none; b=fsuqIwDwIeusnLGaBD2R9nUzRvaBProW//MIa9NMRT+qt+SHVYaML1B+BDbdLFxF/PBhz4QMC/d1j0SNxq6QO+txxh70wLWG01VL7dyGWtufid/ktbY7qehEraEt2kkfDXPHbjqQfqsxAHeG4/56fwW9znClF6S8zviTn4HlBw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775649608; c=relaxed/simple;
	bh=lrqoaDGyt9uolrYd/g93KFqVFBTqkl80bUC3qAl9IRs=;
	h=Subject:From:To:Date:Message-Id; b=OFqQRxGw/QriM17L/absu4e3fwO4WYNk+kbwSIyBewyzbFCm7WUiynSww8sVI35i29YOHPkvCP4+NR+eE+5O0tAFWbA8nAcPnzHcDUvodoO2sXrkEvcx+4fnKwkmIOFIJdxCbkxFgdWGU3X00QA0F5Sad/NlVl0kbDWtPLssEHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fI3AWX50; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fI3AWX50"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=BGQ5d/lciZLKcIF03lSItcIpwaLD+uNvo7G8PwY2Mtk=; b=fI3AWX50P8QQ3wW/DZG1+DWJsQ
	C+oPjavOtxO+xHNF1BOIFJt7wSKgYEtcPMPsIz+spnymQQswgSfkILEIM0k4Rv6W9zY9Keswkvp1V
	WF8nPlgIzJguN/RbQ3XHgEI4cC5hTLUwxdI3u5ikEPmnQ2RcYfdFM1G6XRUjioOOHcbqIndKz+GWP
	i0NhnK+5QG5sPEviORlJOioSS1T/kApf5s+/Nrcnv3iD4wDuwV/Qx5xavIVNOmXPQ/f9/XvP4fxZD
	ciHAVoZue/cxwL66JEhpiD7JrVCM/O9SEFxzQAmhMfUnXn+3gxzSGj9LZP/1jZXGxUTx55B7yvI2T
	8xjRk6Fw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wARZk-00000009zIL-0tJd
	for fio@vger.kernel.org;
	Wed, 08 Apr 2026 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 45B621BC017F; Wed,  8 Apr 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed,  8 Apr 2026 06:00:01 -0600
Message-Id: <20260408120001.45B621BC017F@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit ab77643023f5d7e3c1b71a7576a564f368bf577a:

  Fio 3.42 (2026-04-06 20:11:47 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f4e93793cbe3e4703520a9d4e1d6596bb1b43c73:

  Merge branch 'anon-fault' (2026-04-07 20:00:49 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      engines/page_fault: minor style cleanups
      Merge branch 'anon-fault'

Nico Pache (2):
      page_fault: add mmap-backed ioengine for anonymous faults
      Documentation: update the documentation to include the page_fault engine

 HOWTO.rst               |   5 ++
 Makefile                |   2 +-
 engines/page_fault.c    | 126 ++++++++++++++++++++++++++++++++++++++++++++++++
 examples/page_fault.fio |  60 +++++++++++++++++++++++
 fio.1                   |   5 ++
 5 files changed, 197 insertions(+), 1 deletion(-)
 create mode 100644 engines/page_fault.c
 create mode 100644 examples/page_fault.fio

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 5e3266df..bb97ee22 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2379,6 +2379,11 @@ I/O engine
 			several instances to access the same device or file
 			simultaneously, but allow it for threads.
 
+		**page_fault**
+			I/O engine that uses an mmap region to simulate data transfer by
+			allocating anonymous memory and copying data on read/write to
+			intentionally trigger page faults.
+
 	File/directory operation engines define how the job operates file or directory. The
 	following types are defined:
 
diff --git a/Makefile b/Makefile
index 0337e8fe..099e2f94 100644
--- a/Makefile
+++ b/Makefile
@@ -57,7 +57,7 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		smalloc.c filehash.c profile.c debug.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
 		engines/ftruncate.c engines/fileoperations.c \
-		engines/exec.c \
+		engines/exec.c engines/page_fault.c \
 		server.c client.c iolog.c backend.c libfio.c flow.c cconv.c \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
diff --git a/engines/page_fault.c b/engines/page_fault.c
new file mode 100644
index 00000000..d6c32bcc
--- /dev/null
+++ b/engines/page_fault.c
@@ -0,0 +1,126 @@
+/*
+ * page_fault engine
+ *
+ * IO engine that reads/writes directly to/from anonymous memory
+ * by triggering page faults.
+ */
+#include "fio.h"
+#include "ioengines.h"
+#include <sys/mman.h>
+
+struct fio_page_fault_data {
+	void *mmap_ptr;
+	size_t mmap_sz;
+};
+
+static int fio_page_fault_init(struct thread_data *td)
+{
+	size_t total_io_size;
+	struct fio_page_fault_data *fpd;
+
+	if (td->o.nr_files > 1) {
+		log_err("fio: page_fault ioengine does not support multiple files\n");
+		return 1;
+	}
+
+	if (td->o.start_offset != 0) {
+		log_err("fio: page_fault engine does not support start_offset\n");
+		return 1;
+	}
+
+	fpd = calloc(1, sizeof(*fpd));
+	if (!fpd)
+		return 1;
+
+	total_io_size = td->o.size;
+	fpd->mmap_sz = total_io_size;
+	fpd->mmap_ptr = mmap(NULL, total_io_size, PROT_READ | PROT_WRITE,
+			     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (fpd->mmap_ptr == MAP_FAILED) {
+		free(fpd);
+		return 1;
+	}
+
+	td->io_ops_data = fpd;
+	return 0;
+}
+
+static enum fio_q_status fio_page_fault_queue(struct thread_data *td,
+					      struct io_u *io_u)
+{
+	struct fio_page_fault_data *fpd = td->io_ops_data;
+	void *mmap_head;
+
+	if (!fpd) {
+		io_u->error = EINVAL;
+		return FIO_Q_COMPLETED;
+	}
+
+	if (io_u->offset + io_u->buflen > fpd->mmap_sz) {
+		io_u->error = EINVAL;
+		return FIO_Q_COMPLETED;
+	}
+
+	mmap_head = fpd->mmap_ptr + io_u->offset;
+	switch (io_u->ddir) {
+	case DDIR_READ:
+		memcpy(io_u->xfer_buf, mmap_head, io_u->buflen);
+		break;
+	case DDIR_WRITE:
+		memcpy(mmap_head, io_u->xfer_buf, io_u->buflen);
+		break;
+	case DDIR_SYNC:
+	case DDIR_DATASYNC:
+	case DDIR_SYNC_FILE_RANGE:
+	case DDIR_SYNCFS:
+		break;
+	default:
+		io_u->error = EINVAL;
+		break;
+	}
+
+	return FIO_Q_COMPLETED;
+}
+
+static int fio_page_fault_open_file(struct thread_data *td, struct fio_file *f)
+{
+	return 0;
+}
+
+static int fio_page_fault_close_file(struct thread_data *td, struct fio_file *f)
+{
+	return 0;
+}
+
+static void fio_page_fault_cleanup(struct thread_data *td)
+{
+	struct fio_page_fault_data *fpd = td->io_ops_data;
+
+	if (!fpd)
+		return;
+	if (fpd->mmap_ptr && fpd->mmap_sz)
+		munmap(fpd->mmap_ptr, fpd->mmap_sz);
+	free(fpd);
+}
+
+static struct ioengine_ops ioengine = {
+	.name = "page_fault",
+	.version = FIO_IOOPS_VERSION,
+	.init = fio_page_fault_init,
+	.cleanup = fio_page_fault_cleanup,
+	.queue = fio_page_fault_queue,
+	.open_file = fio_page_fault_open_file,
+	.close_file = fio_page_fault_close_file,
+	.get_file_size = generic_get_file_size,
+	.flags = FIO_SYNCIO | FIO_NOEXTEND | FIO_DISKLESSIO,
+};
+
+static void fio_init fio_page_fault_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_page_fault_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/examples/page_fault.fio b/examples/page_fault.fio
new file mode 100644
index 00000000..4a49fb7d
--- /dev/null
+++ b/examples/page_fault.fio
@@ -0,0 +1,60 @@
+[global]
+stonewall
+ioengine=page_fault
+size=5*1024*1024*$mb_memory/8 # 5/8 of the memory
+bs=$pagesize
+
+[page_fault_write]
+rw=write
+
+[page_fault_mixed]
+rw=randrw
+rwmixread=50
+
+[page_fault_process_storm]
+size=8*1024*$pagesize
+rw=randrw
+rwmixread=50
+numjobs=$ncpus
+
+[page_fault_mthp]
+bsrange=16k-1M
+blockalign=2M
+rw=write
+
+[page_fault_seq_read]
+rw=read
+
+[page_fault_rand_read]
+rw=randread
+
+[page_fault_rand_write]
+rw=randwrite
+
+[page_fault_warm]
+rw=randrw
+rwmixread=50
+loops=3
+
+[page_fault_read_heavy]
+rw=randrw
+rwmixread=90
+
+[page_fault_write_heavy]
+rw=randrw
+rwmixread=10
+
+[page_fault_large_block]
+bs=2M
+blockalign=2M
+rw=write
+
+[page_fault_cache_hot]
+size=64*$pagesize
+rw=randrw
+rwmixread=50
+loops=100
+
+[page_fault_pressure]
+size=7*1024*1024*$mb_memory/8 # 7/8 of the memory
+rw=write
diff --git a/fio.1 b/fio.1
index 664d7e3b..14ea6427 100644
--- a/fio.1
+++ b/fio.1
@@ -2168,6 +2168,11 @@ instance is used per process, so all jobs setting option \fBthread\fR will share
 a single instance (with one queue per thread) and must specify compatible
 options. Note that some drivers don't allow several instances to access the same
 device or file simultaneously, but allow it for threads.
+.TP
+.B page_fault
+I/O engine that uses an mmap region to simulate data transfer by allocating
+anonymous memory and copying data on read/write to intentionally trigger page
+faults.
 .RE
 .P
 File/directory operation engines define how the job operates file or directory.
