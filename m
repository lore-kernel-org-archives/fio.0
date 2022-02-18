Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1553FC433EF
	for <fio@archiver.kernel.org>; Fri, 18 Feb 2022 13:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbiBRNAY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 18 Feb 2022 08:00:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbiBRNAY (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 18 Feb 2022 08:00:24 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3699E18B161
        for <fio@vger.kernel.org>; Fri, 18 Feb 2022 05:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=7Z02eAX2kjTQe5q1GZmWX7kUS4zdSoCqzkq00g4i+ig=; b=VqPoDGQurFsLRV/UPwYQckQUV4
        82uUTMxPMTmL+fybFgJLOBrYPeoUiacLLGJ5RBsjPSOJREQXfNmkwto/g4MK+sYvVGeiuTlf73FP/
        jR7Y8AX5rnXXXc+NFPFVxvzNHU0iX1RDFTG079WEYYqfh2zURjcoVzddzvLCMdLzQ+F1GhXRfhJEj
        IDDL+FxdSb6/OPUO7AnJdkv39z2f6A4GFwnBa9t/oj25FxutuECMdeC35OlSa5G5bmUZckXQPwPdC
        QdrCifaTOsb14vU9bO1wjkicb3RVYJ0fOV+FNsfaZpqTd6yR2TtDD0dPyd2Ok2BInFcynFNb3xULX
        qjR1j7aA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nL2rl-00Gats-6c
        for fio@vger.kernel.org; Fri, 18 Feb 2022 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id C63F91BC0173; Fri, 18 Feb 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220218130001.C63F91BC0173@kernel.dk>
Date:   Fri, 18 Feb 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 6a16e9e9531a5f746c4e2fe43873de1db434b4fc:

  diskutil: include limits.h for PATH_MAX (2022-02-15 17:17:30 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c99c81adb3510a8dc34d47fd40b19ef657e32192:

  Correct F_FULLSYNC -> F_FULLFSYNC (2022-02-17 12:53:59 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      t/io_uring: allow non-power-of-2 queue depths
      t/io_uring: align buffers correctly on non-4k page sizes
      Use fcntl(..., F_FULLSYNC) if available
      Correct F_FULLSYNC -> F_FULLFSYNC

 configure    | 22 ++++++++++++++++++++++
 io_u.c       |  4 ++++
 t/io_uring.c | 15 ++++++++++-----
 3 files changed, 36 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 0efde7d6..6160d84d 100755
--- a/configure
+++ b/configure
@@ -645,6 +645,25 @@ if compile_prog "" "-lz" "zlib" ; then
 fi
 print_config "zlib" "$zlib"
 
+##########################################
+# fcntl(F_FULLFSYNC) support
+if test "$fcntl_sync" != "yes" ; then
+  fcntl_sync="no"
+fi
+cat > $TMPC << EOF
+#include <unistd.h>
+#include <fcntl.h>
+
+int main(int argc, char **argv)
+{
+  return fcntl(0, F_FULLFSYNC);
+}
+EOF
+if compile_prog "" "" "fcntl(F_FULLFSYNC)" ; then
+    fcntl_sync="yes"
+fi
+print_config "fcntl(F_FULLFSYNC)" "$fcntl_sync"
+
 ##########################################
 # linux-aio probe
 if test "$libaio" != "yes" ; then
@@ -3174,6 +3193,9 @@ fi
 if test "$pdb" = yes; then
   output_sym "CONFIG_PDB"
 fi
+if test "$fcntl_sync" = "yes" ; then
+  output_sym "CONFIG_FCNTL_SYNC"
+fi
 
 print_config "Lib-based ioengines dynamic" "$dynamic_engines"
 cat > $TMPC << EOF
diff --git a/io_u.c b/io_u.c
index 059637e5..806ceb77 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2297,7 +2297,11 @@ int do_io_u_sync(const struct thread_data *td, struct io_u *io_u)
 	int ret;
 
 	if (io_u->ddir == DDIR_SYNC) {
+#ifdef CONFIG_FCNTL_SYNC
+		ret = fcntl(io_u->file->fd, F_FULLFSYNC);
+#else
 		ret = fsync(io_u->file->fd);
+#endif
 	} else if (io_u->ddir == DDIR_DATASYNC) {
 #ifdef CONFIG_FDATASYNC
 		ret = fdatasync(io_u->file->fd);
diff --git a/t/io_uring.c b/t/io_uring.c
index 4520de43..f513d7dc 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -364,7 +364,7 @@ static int io_uring_register_buffers(struct submitter *s)
 		return 0;
 
 	return syscall(__NR_io_uring_register, s->ring_fd,
-			IORING_REGISTER_BUFFERS, s->iovecs, depth);
+			IORING_REGISTER_BUFFERS, s->iovecs, roundup_pow2(depth));
 }
 
 static int io_uring_register_files(struct submitter *s)
@@ -962,7 +962,7 @@ static int setup_aio(struct submitter *s)
 		fixedbufs = register_files = 0;
 	}
 
-	return io_queue_init(depth, &s->aio_ctx);
+	return io_queue_init(roundup_pow2(depth), &s->aio_ctx);
 #else
 	fprintf(stderr, "Legacy AIO not available on this system/build\n");
 	errno = EINVAL;
@@ -1156,6 +1156,7 @@ int main(int argc, char *argv[])
 	struct submitter *s;
 	unsigned long done, calls, reap;
 	int err, i, j, flags, fd, opt, threads_per_f, threads_rem = 0, nfiles;
+	long page_size;
 	struct file f;
 	char *fdepths;
 	void *ret;
@@ -1249,7 +1250,7 @@ int main(int argc, char *argv[])
 		dma_map = 0;
 
 	submitter = calloc(nthreads, sizeof(*submitter) +
-				depth * sizeof(struct iovec));
+				roundup_pow2(depth) * sizeof(struct iovec));
 	for (j = 0; j < nthreads; j++) {
 		s = get_submitter(j);
 		s->index = j;
@@ -1319,12 +1320,16 @@ int main(int argc, char *argv[])
 
 	arm_sig_int();
 
+	page_size = sysconf(_SC_PAGESIZE);
+	if (page_size < 0)
+		page_size = 4096;
+
 	for (j = 0; j < nthreads; j++) {
 		s = get_submitter(j);
-		for (i = 0; i < depth; i++) {
+		for (i = 0; i < roundup_pow2(depth); i++) {
 			void *buf;
 
-			if (posix_memalign(&buf, bs, bs)) {
+			if (posix_memalign(&buf, page_size, bs)) {
 				printf("failed alloc\n");
 				return 1;
 			}
