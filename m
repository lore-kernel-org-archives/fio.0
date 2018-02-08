Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33997 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbeBHNAZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Feb 2018 08:00:25 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1ejloP-00034s-DP
        for fio@vger.kernel.org; Thu, 08 Feb 2018 13:00:25 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180208130002.2DF562C00A7@kernel.dk>
Date: Thu,  8 Feb 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f5ec81235eaf21bd3a97556427d4a84e48a87e54:

  stat: add total fsync ios to json output (2018-01-25 16:04:20 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c69f6bf3ed1b413562d7aab1aa9c476101348726:

  mmap: don't include MADV_FREE in fadvise_hint check (2018-02-07 11:30:59 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Let fadvise_hint also apply too mmap engine and madvise
      mmap: don't include MADV_FREE in fadvise_hint check

 HOWTO          |  5 +++--
 engines/mmap.c | 38 +++++++++++++++++++++++++++-----------
 fio.1          |  4 ++--
 options.c      |  2 +-
 4 files changed, 33 insertions(+), 16 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 78fa6cc..307b50d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1093,8 +1093,9 @@ I/O type
 
 .. option:: fadvise_hint=str
 
-	Use :manpage:`posix_fadvise(2)` to advise the kernel on what I/O patterns
-	are likely to be issued.  Accepted values are:
+	Use :manpage:`posix_fadvise(2)` or :manpage:`posix_fadvise(2)` to
+	advise the kernel on what I/O patterns are likely to be issued.
+	Accepted values are:
 
 		**0**
 			Backwards-compatible hint for "no hint".
diff --git a/engines/mmap.c b/engines/mmap.c
index 7755658..ea7179d 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -27,6 +27,30 @@ struct fio_mmap_data {
 	off_t mmap_off;
 };
 
+static bool fio_madvise_file(struct thread_data *td, struct fio_file *f,
+			     size_t length)
+
+{
+	struct fio_mmap_data *fmd = FILE_ENG_DATA(f);
+
+	if (!td->o.fadvise_hint)
+		return true;
+
+	if (!td_random(td)) {
+		if (posix_madvise(fmd->mmap_ptr, length, POSIX_MADV_SEQUENTIAL) < 0) {
+			td_verror(td, errno, "madvise");
+			return false;
+		}
+	} else {
+		if (posix_madvise(fmd->mmap_ptr, length, POSIX_MADV_RANDOM) < 0) {
+			td_verror(td, errno, "madvise");
+			return false;
+		}
+	}
+
+	return true;
+}
+
 static int fio_mmap_file(struct thread_data *td, struct fio_file *f,
 			 size_t length, off_t off)
 {
@@ -50,17 +74,9 @@ static int fio_mmap_file(struct thread_data *td, struct fio_file *f,
 		goto err;
 	}
 
-	if (!td_random(td)) {
-		if (posix_madvise(fmd->mmap_ptr, length, POSIX_MADV_SEQUENTIAL) < 0) {
-			td_verror(td, errno, "madvise");
-			goto err;
-		}
-	} else {
-		if (posix_madvise(fmd->mmap_ptr, length, POSIX_MADV_RANDOM) < 0) {
-			td_verror(td, errno, "madvise");
-			goto err;
-		}
-	}
+	if (!fio_madvise_file(td, f, length))
+		goto err;
+
 	if (posix_madvise(fmd->mmap_ptr, length, POSIX_MADV_DONTNEED) < 0) {
 		td_verror(td, errno, "madvise");
 		goto err;
diff --git a/fio.1 b/fio.1
index 70eeeb0..91ae4a2 100644
--- a/fio.1
+++ b/fio.1
@@ -870,8 +870,8 @@ pre\-allocation methods are available, \fBnone\fR if not.
 .RE
 .TP
 .BI fadvise_hint \fR=\fPstr
-Use \fBposix_fadvise\fR\|(2) to advise the kernel what I/O patterns
-are likely to be issued. Accepted values are:
+Use \fBposix_fadvise\fR\|(2) or \fBposix_madvise\fR\|(2) to advise the kernel
+what I/O patterns are likely to be issued. Accepted values are:
 .RS
 .RS
 .TP
diff --git a/options.c b/options.c
index 9a3431d..6810521 100644
--- a/options.c
+++ b/options.c
@@ -2443,7 +2443,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.posval	= {
 			  { .ival = "0",
 			    .oval = F_ADV_NONE,
-			    .help = "Don't issue fadvise",
+			    .help = "Don't issue fadvise/madvise",
 			  },
 			  { .ival = "1",
 			    .oval = F_ADV_TYPE,
