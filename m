Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52155 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbdH1MAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 28 Aug 2017 08:00:14 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dmIiD-00069n-L9
        for fio@vger.kernel.org; Mon, 28 Aug 2017 12:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170828120001.C03B42C0098@kernel.dk>
Date: Mon, 28 Aug 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b427f2e12beba7b0c9a655f8ecbd19187c0b6029:

  Merge branch 'stat_base_overflow' of https://github.com/football1222/fio (2017-08-23 08:34:37 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0c76294c12bdc3df90a41754b05fa30b612ea6eb:

  engines/windowsaio: kill useless forward declarations (2017-08-27 15:21:26 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      Merge branch 'fixes' of https://github.com/sitsofe/fio
      Merge branch 'doc_runtime' of https://github.com/sitsofe/fio
      engines/windowsaio: kill useless forward declarations

Sitsofe Wheeler (4):
      doc: remove '--runtime' command line option
      fio: implement 64 bit network/big endian byte swapping macros
      configure: clean up libverbs configure test
      README: update/add mintty issue links

 HOWTO                |  3 ---
 README               |  4 +++-
 configure            |  3 +--
 engines/rdma.c       |  5 ++---
 engines/windowsaio.c | 11 -----------
 fio.1                |  3 ---
 os/os.h              | 12 ++++++++++++
 7 files changed, 18 insertions(+), 23 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 4192ac7..f36d4a7 100644
--- a/HOWTO
+++ b/HOWTO
@@ -111,9 +111,6 @@ Command line options
 	format.  `json+` is like `json`, except it adds a full dump of the latency
 	buckets.
 
-.. option:: --runtime
-	Limit run time to runtime seconds.
-
 .. option:: --bandwidth-log
 
 	Generate aggregate bandwidth logs.
diff --git a/README b/README
index a6eba8f..72ff465 100644
--- a/README
+++ b/README
@@ -181,7 +181,9 @@ To build fio on 32-bit Windows, run ``./configure --build-32bit-win`` before
 It's recommended that once built or installed, fio be run in a Command Prompt or
 other 'native' console such as console2, since there are known to be display and
 signal issues when running it under a Cygwin shell (see
-http://code.google.com/p/mintty/issues/detail?id=56 for details).
+https://github.com/mintty/mintty/issues/56 and
+https://github.com/mintty/mintty/wiki/Tips#inputoutput-interaction-with-alien-programs
+for details).
 
 
 Documentation
diff --git a/configure b/configure
index 59af1b6..cefd610 100755
--- a/configure
+++ b/configure
@@ -697,8 +697,7 @@ if test "$libverbs" != "yes" ; then
   libverbs="no"
 fi
 cat > $TMPC << EOF
-#include <stdio.h>
-#include <infiniband/arch.h>
+#include <infiniband/verbs.h>
 int main(int argc, char **argv)
 {
   struct ibv_pd *pd = ibv_alloc_pd(NULL);
diff --git a/engines/rdma.c b/engines/rdma.c
index 8d31ff3..da00cba 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -44,7 +44,6 @@
 #include "../optgroup.h"
 
 #include <rdma/rdma_cma.h>
-#include <infiniband/arch.h>
 
 #define FIO_RDMA_MAX_IO_DEPTH    512
 
@@ -216,7 +215,7 @@ static int client_recv(struct thread_data *td, struct ibv_wc *wc)
 		rd->rmt_nr = ntohl(rd->recv_buf.nr);
 
 		for (i = 0; i < rd->rmt_nr; i++) {
-			rd->rmt_us[i].buf = ntohll(rd->recv_buf.rmt_us[i].buf);
+			rd->rmt_us[i].buf = be64_to_cpu(rd->recv_buf.rmt_us[i].buf);
 			rd->rmt_us[i].rkey = ntohl(rd->recv_buf.rmt_us[i].rkey);
 			rd->rmt_us[i].size = ntohl(rd->recv_buf.rmt_us[i].size);
 
@@ -1300,7 +1299,7 @@ static int fio_rdmaio_init(struct thread_data *td)
 		}
 
 		rd->send_buf.rmt_us[i].buf =
-		    htonll((uint64_t) (unsigned long)io_u->buf);
+		    cpu_to_be64((uint64_t) (unsigned long)io_u->buf);
 		rd->send_buf.rmt_us[i].rkey = htonl(io_u->mr->rkey);
 		rd->send_buf.rmt_us[i].size = htonl(max_bs);
 
diff --git a/engines/windowsaio.c b/engines/windowsaio.c
index f5cb048..c4c5abd 100644
--- a/engines/windowsaio.c
+++ b/engines/windowsaio.c
@@ -35,17 +35,7 @@ struct thread_ctx {
 	struct windowsaio_data *wd;
 };
 
-static BOOL timeout_expired(DWORD start_count, DWORD end_count);
-static int fio_windowsaio_getevents(struct thread_data *td, unsigned int min,
-				unsigned int max, const struct timespec *t);
-static struct io_u *fio_windowsaio_event(struct thread_data *td, int event);
-static int fio_windowsaio_queue(struct thread_data *td,
-				  struct io_u *io_u);
-static void fio_windowsaio_cleanup(struct thread_data *td);
 static DWORD WINAPI IoCompletionRoutine(LPVOID lpParameter);
-static int fio_windowsaio_init(struct thread_data *td);
-static int fio_windowsaio_open_file(struct thread_data *td, struct fio_file *f);
-static int fio_windowsaio_close_file(struct thread_data fio_unused *td, struct fio_file *f);
 
 static int fio_windowsaio_init(struct thread_data *td)
 {
@@ -152,7 +142,6 @@ static void fio_windowsaio_cleanup(struct thread_data *td)
 	}
 }
 
-
 static int fio_windowsaio_open_file(struct thread_data *td, struct fio_file *f)
 {
 	int rc = 0;
diff --git a/fio.1 b/fio.1
index a0f1a24..b8b3da2 100644
--- a/fio.1
+++ b/fio.1
@@ -29,9 +29,6 @@ Set the reporting \fIformat\fR to `normal', `terse', `json', or
 is a CSV based format. `json+' is like `json', except it adds a full
 dump of the latency buckets.
 .TP
-.BI \-\-runtime \fR=\fPruntime
-Limit run time to \fIruntime\fR seconds.
-.TP
 .BI \-\-bandwidth\-log
 Generate aggregate bandwidth logs.
 .TP
diff --git a/os/os.h b/os/os.h
index 2e15529..f62b427 100644
--- a/os/os.h
+++ b/os/os.h
@@ -204,16 +204,20 @@ static inline uint64_t fio_swap64(uint64_t val)
 
 #ifndef FIO_HAVE_BYTEORDER_FUNCS
 #ifdef CONFIG_LITTLE_ENDIAN
+#define __be64_to_cpu(x)		fio_swap64(x)
 #define __le16_to_cpu(x)		(x)
 #define __le32_to_cpu(x)		(x)
 #define __le64_to_cpu(x)		(x)
+#define __cpu_to_be64(x)		fio_swap64(x)
 #define __cpu_to_le16(x)		(x)
 #define __cpu_to_le32(x)		(x)
 #define __cpu_to_le64(x)		(x)
 #else
+#define __be64_to_cpu(x)		(x)
 #define __le16_to_cpu(x)		fio_swap16(x)
 #define __le32_to_cpu(x)		fio_swap32(x)
 #define __le64_to_cpu(x)		fio_swap64(x)
+#define __cpu_to_be64(x)		(x)
 #define __cpu_to_le16(x)		fio_swap16(x)
 #define __cpu_to_le32(x)		fio_swap32(x)
 #define __cpu_to_le64(x)		fio_swap64(x)
@@ -221,6 +225,10 @@ static inline uint64_t fio_swap64(uint64_t val)
 #endif /* FIO_HAVE_BYTEORDER_FUNCS */
 
 #ifdef FIO_INTERNAL
+#define be64_to_cpu(val) ({			\
+	typecheck(uint64_t, val);		\
+	__be64_to_cpu(val);			\
+})
 #define le16_to_cpu(val) ({			\
 	typecheck(uint16_t, val);		\
 	__le16_to_cpu(val);			\
@@ -235,6 +243,10 @@ static inline uint64_t fio_swap64(uint64_t val)
 })
 #endif
 
+#define cpu_to_be64(val) ({			\
+	typecheck(uint64_t, val);		\
+	__cpu_to_be64(val);			\
+})
 #define cpu_to_le16(val) ({			\
 	typecheck(uint16_t, val);		\
 	__cpu_to_le16(val);			\
