Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41658 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbbB0NAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 27 Feb 2015 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YRKWT-0001Iv-FP
	for fio@vger.kernel.org; Fri, 27 Feb 2015 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150227130003.41E9940186@lyth.info>
Date: Fri, 27 Feb 2015 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 93eeb5582d56fe5e36f455c8de26c302e317fdeb:

  Fix implicit function declaration on Android (2015-02-25 14:00:01 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3d0e3417997d9caa27cf97462e15ba437d285d29:

  Fix segfault due to bad munmap() (2015-02-26 15:38:42 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'master' of ssh://git.kernel.dk/data/git/fio
      Fix segfault due to bad munmap()

Lars Marowsky-Bree (1):
      Typo fix in man page.

 filelock.c |    4 ++--
 fio.1      |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/filelock.c b/filelock.c
index 17b5a85..b113007 100644
--- a/filelock.c
+++ b/filelock.c
@@ -101,7 +101,7 @@ void fio_filelock_exit(void)
 		return;
 
 	assert(flist_empty(&fld->list));
-	fio_mutex_remove(&fld->lock);
+	__fio_mutex_remove(&fld->lock);
 
 	while (!flist_empty(&fld->free_list)) {
 		struct fio_filelock *ff;
@@ -109,7 +109,7 @@ void fio_filelock_exit(void)
 		ff = flist_first_entry(&fld->free_list, struct fio_filelock, list);
 
 		flist_del_init(&ff->list);
-		fio_mutex_remove(&ff->lock);
+		__fio_mutex_remove(&ff->lock);
 	}
 
 	sfree(fld);
diff --git a/fio.1 b/fio.1
index b746da1..84d71a0 100644
--- a/fio.1
+++ b/fio.1
@@ -21,7 +21,7 @@ list all available tracing options.
 Write output to \fIfilename\fR.
 .TP
 .BI \-\-output-format \fR=\fPformat
-Set the reporting format to \fInormal\fR, \fIterse\fR, or \fIjosn\fR.
+Set the reporting format to \fInormal\fR, \fIterse\fR, or \fIjson\fR.
 .TP
 .BI \-\-runtime \fR=\fPruntime
 Limit run time to \fIruntime\fR seconds.
