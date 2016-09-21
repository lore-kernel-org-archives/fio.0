Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:42060 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753281AbcIUMAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Sep 2016 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bmgC4-0004hM-7c
        for fio@vger.kernel.org; Wed, 21 Sep 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160921120002.7C3832C2003@kernel.dk>
Date: Wed, 21 Sep 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5de1ade5a8a8dd118bdfac835a6cfb4bcf013734:

  Windows: fix Time_tToSystemTime function to be 64-bit compliant (2016-09-19 08:28:11 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1d272416412b0c867224a2b667e6b6124cbc26e8:

  stat: check if ctime_r() ends in a newline before stripping (2016-09-20 21:58:34 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      os/windows/posix.c: ensure that ctime_r() adds a newline
      stat: check if ctime_r() ends in a newline before stripping

 os/windows/posix.c | 2 +-
 stat.c             | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/os/windows/posix.c b/os/windows/posix.c
index 5830e4c..3388127 100755
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -250,7 +250,7 @@ char* ctime_r(const time_t *t, char *buf)
 
     Time_tToSystemTime(*t, &systime);
     /* We don't know how long `buf` is, but assume it's rounded up from the minimum of 25 to 32 */
-    StringCchPrintfA(buf, 31, "%s %s %d %02d:%02d:%02d %04d", dayOfWeek[systime.wDayOfWeek % 7], monthOfYear[(systime.wMonth - 1) % 12],
+    StringCchPrintfA(buf, 31, "%s %s %d %02d:%02d:%02d %04d\n", dayOfWeek[systime.wDayOfWeek % 7], monthOfYear[(systime.wMonth - 1) % 12],
 										 systime.wDay, systime.wHour, systime.wMinute, systime.wSecond, systime.wYear);
     return buf;
 }
diff --git a/stat.c b/stat.c
index c9148ad..3c72a6c 100644
--- a/stat.c
+++ b/stat.c
@@ -1650,7 +1650,8 @@ void __show_run_stats(void)
 
 		os_ctime_r((const time_t *) &now.tv_sec, time_buf,
 				sizeof(time_buf));
-		time_buf[strlen(time_buf) - 1] = '\0';
+		if (time_buf[strlen(time_buf) - 1] == '\n')
+			time_buf[strlen(time_buf) - 1] = '\0';
 
 		root = json_create_object();
 		json_object_add_value_string(root, "fio version", fio_version_string);
