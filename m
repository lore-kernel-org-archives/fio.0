Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37226 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752158AbcITMAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 20 Sep 2016 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bmJiW-0004Y9-Kw
        for fio@vger.kernel.org; Tue, 20 Sep 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160920120002.79B772C009B@kernel.dk>
Date: Tue, 20 Sep 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d22042d2117b78e16b06bab0880422c417007d37:

  workqueue: kill SW_F_EXITED (2016-09-16 12:48:32 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5de1ade5a8a8dd118bdfac835a6cfb4bcf013734:

  Windows: fix Time_tToSystemTime function to be 64-bit compliant (2016-09-19 08:28:11 -0600)

----------------------------------------------------------------
Josh Sinykin (2):
      Fix garbage characters in json output caused by time_buf being uninitialized
      Windows: fix Time_tToSystemTime function to be 64-bit compliant

 os/windows/posix.c | 10 ++++++----
 stat.c             |  2 ++
 2 files changed, 8 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/os/windows/posix.c b/os/windows/posix.c
index fd3d9ab..5830e4c 100755
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -232,10 +232,12 @@ char *dlerror(void)
 /* Copied from http://blogs.msdn.com/b/joshpoley/archive/2007/12/19/date-time-formats-and-conversions.aspx */
 void Time_tToSystemTime(time_t dosTime, SYSTEMTIME *systemTime)
 {
-    LARGE_INTEGER jan1970FT;
-    LARGE_INTEGER utcFT;
-    jan1970FT.QuadPart = 116444736000000000LL; // january 1st 1970
-    utcFT.QuadPart = ((unsigned __int64)dosTime) * 10000000 + jan1970FT.QuadPart;
+    FILETIME utcFT;
+    LONGLONG jan1970;
+
+    jan1970 = Int32x32To64(dosTime, 10000000) + 116444736000000000;
+    utcFT.dwLowDateTime = (DWORD)jan1970;
+    utcFT.dwHighDateTime = jan1970 >> 32;
 
     FileTimeToSystemTime((FILETIME*)&utcFT, systemTime);
 }
diff --git a/stat.c b/stat.c
index 74c2686..c9148ad 100644
--- a/stat.c
+++ b/stat.c
@@ -669,6 +669,8 @@ static void show_thread_status_normal(struct thread_stat *ts,
 
 	if (!ddir_rw_sum(ts->io_bytes) && !ddir_rw_sum(ts->total_io_u))
 		return;
+		
+	memset(time_buf, 0, sizeof(time_buf));
 
 	time(&time_p);
 	os_ctime_r((const time_t *) &time_p, time_buf, sizeof(time_buf));
