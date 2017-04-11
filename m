Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54764 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752623AbdDKMAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 Apr 2017 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cxuSp-0000iF-0S
        for fio@vger.kernel.org; Tue, 11 Apr 2017 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170411120001.D3BBF2C0084@kernel.dk>
Date: Tue, 11 Apr 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e5a415c889251928dd256738a8022f1eab91c73b:

  Fix num2str() output when maxlen <= strlen(tmp) (2017-04-08 11:04:21 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b94d4d75a2e474561dcda8ee852cd5e67dde884e:

  Merge branch 'pull-2' of https://github.com/dmonakhov/fio (2017-04-10 11:41:09 -0600)

----------------------------------------------------------------
Dmitry Monakhov (2):
      engine: e4defrag fix error reporting
      engine: add ftruncate ioengine

Jens Axboe (1):
      Merge branch 'pull-2' of https://github.com/dmonakhov/fio

Sitsofe Wheeler (1):
      doc: add ftruncate engine documentation and example jobfile

 HOWTO                  |  5 +++++
 Makefile               |  1 +
 engines/e4defrag.c     |  9 ++++++--
 engines/ftruncate.c    | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++
 examples/ftruncate.fio | 27 ++++++++++++++++++++++++
 5 files changed, 96 insertions(+), 2 deletions(-)
 create mode 100644 engines/ftruncate.c
 create mode 100644 examples/ftruncate.fio

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 80b9e75..ffdcb75 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1675,6 +1675,11 @@ I/O engine
 			DDIR_TRIM
 				does fallocate(,mode = FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE).
 
+		**ftruncate**
+			I/O engine that sends :manpage:`ftruncate(2)` operations in response
+			to write (DDIR_WRITE) events. Each ftruncate issued sets the file's
+			size to the current block offset. Block size is ignored.
+
 		**e4defrag**
 			I/O engine that does regular EXT4_IOC_MOVE_EXT ioctls to simulate
 			defragment activity in request to DDIR_WRITE event.
diff --git a/Makefile b/Makefile
index 37150c6..66083ff 100644
--- a/Makefile
+++ b/Makefile
@@ -42,6 +42,7 @@ SOURCE :=	$(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		eta.c verify.c memory.c io_u.c parse.c mutex.c options.c \
 		smalloc.c filehash.c profile.c debug.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
+		engines/ftruncate.c \
 		server.c client.c iolog.c backend.c libfio.c flow.c cconv.c \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
diff --git a/engines/e4defrag.c b/engines/e4defrag.c
index 1e4996f..4b44488 100644
--- a/engines/e4defrag.c
+++ b/engines/e4defrag.c
@@ -172,8 +172,13 @@ static int fio_e4defrag_queue(struct thread_data *td, struct io_u *io_u)
 		len = io_u->xfer_buflen;
 
 	if (len != io_u->xfer_buflen) {
-		io_u->resid = io_u->xfer_buflen - len;
-		io_u->error = 0;
+		if (len) {
+			io_u->resid = io_u->xfer_buflen - len;
+			io_u->error = 0;
+		} else {
+			/* access beyond i_size */
+			io_u->error = EINVAL;
+		}
 	}
 	if (ret)
 		io_u->error = errno;
diff --git a/engines/ftruncate.c b/engines/ftruncate.c
new file mode 100644
index 0000000..e86dbac
--- /dev/null
+++ b/engines/ftruncate.c
@@ -0,0 +1,56 @@
+/*
+ * ftruncate: ioengine for git://git.kernel.dk/fio.git
+ *
+ * IO engine that does regular truncates to simulate data transfer
+ * as fio ioengine.
+ * DDIR_WRITE does ftruncate
+ *
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/uio.h>
+#include <errno.h>
+#include <assert.h>
+#include <fcntl.h>
+
+#include "../fio.h"
+#include "../filehash.h"
+
+static int fio_ftruncate_queue(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_file *f = io_u->file;
+	int ret;
+	fio_ro_check(td, io_u);
+
+	if (io_u->ddir != DDIR_WRITE) {
+		io_u->error = EINVAL;
+		return FIO_Q_COMPLETED;
+	}
+	ret = ftruncate(f->fd, io_u->offset);
+
+	if (ret)
+		io_u->error = errno;
+
+	return FIO_Q_COMPLETED;
+}
+
+static struct ioengine_ops ioengine = {
+	.name		= "ftruncate",
+	.version	= FIO_IOOPS_VERSION,
+	.queue		= fio_ftruncate_queue,
+	.open_file	= generic_open_file,
+	.close_file	= generic_close_file,
+	.get_file_size	= generic_get_file_size,
+	.flags		= FIO_SYNCIO | FIO_FAKEIO
+};
+
+static void fio_init fio_syncio_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_syncio_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/examples/ftruncate.fio b/examples/ftruncate.fio
new file mode 100644
index 0000000..a6ef457
--- /dev/null
+++ b/examples/ftruncate.fio
@@ -0,0 +1,27 @@
+# Example ftruncate engine jobs
+
+[global]
+ioengine=ftruncate
+directory=/scratch
+size=102404k ; 100Mb+4k
+stonewall
+filename=truncate
+runtime=10s
+time_based
+direct=1
+#
+# bs option is stub here. Truncation is performed on the current block offset.
+# blocksize value is ignored
+bs=4k
+
+# truncate the file to 4Kbytes then repeatedly grow the file back to just over
+# its original size using subsequent truncates
+[grow-truncate]
+rw=write
+
+# Repeatedly change a file to a random size between 0Kbytes and 100Mb
+# using truncates
+[rand-truncate]
+rw=randwrite
+norandommap
+
