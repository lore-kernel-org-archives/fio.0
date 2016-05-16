Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:20639 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbcEPVuW convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 16 May 2016 17:50:22 -0400
Received: from mail.micron.com (bowex36d.micron.com [137.201.85.223])
	by mailout.micron.com (8.14.4/8.14.6) with ESMTP id u4GLoJB3027598
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL)
	for <fio@vger.kernel.org>; Mon, 16 May 2016 15:50:20 -0600
From: "Michael Schoberg (mschoberg)" <mschoberg@micron.com>
Subject: Windows crash in ctime_r()
Date: Mon, 16 May 2016 21:50:19 +0000
Message-ID: <f803f397a70446f98a8af0a14634cb31@bowex36a.micron.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I think I found an issue in os\windows\posix.c that results in a FIO crash (on Windows.)  I'm including a patch that resolves the crash for us, but includes another (optional) fix.

Crash issue:  possix.c  - ctime_r() will reference a negative array index on Sunday.  SYSTEMTIME states the days of the week as: "0=Sunday, .. , 6=Saturday."  The "fix" can likely be dialed back to safely assume the days/months will adhere to how they're documented.

Optional - StringCchPrintfA() calls should allow for the string plus a NULL character.  Instead, the value getting passed in is for the entire string size.



os/windows/posix.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/os/windows/posix.c b/os/windows/posix.c
index 41fc480..fd3d9ab 100755
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -243,12 +243,12 @@ void Time_tToSystemTime(time_t dosTime, SYSTEMTIME *systemTime)
 char* ctime_r(const time_t *t, char *buf)
 {
     SYSTEMTIME systime;
-    const char * const dayOfWeek[] = { "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" };
+    const char * const dayOfWeek[] = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" };
     const char * const monthOfYear[] = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
 
     Time_tToSystemTime(*t, &systime);
     /* We don't know how long `buf` is, but assume it's rounded up from the minimum of 25 to 32 */
-    StringCchPrintfA(buf, 32, "%s %s %d %02d:%02d:%02d %04d", dayOfWeek[systime.wDayOfWeek - 1], monthOfYear[systime.wMonth - 1],
+    StringCchPrintfA(buf, 31, "%s %s %d %02d:%02d:%02d %04d", dayOfWeek[systime.wDayOfWeek % 7], monthOfYear[(systime.wMonth - 1) % 12],
 										 systime.wDay, systime.wHour, systime.wMinute, systime.wSecond, systime.wYear);
     return buf;
 }
@@ -888,7 +888,7 @@ struct dirent *readdir(DIR *dirp)
 
 	if (dirp->find_handle == INVALID_HANDLE_VALUE) {
 		char search_pattern[MAX_PATH];
-		StringCchPrintfA(search_pattern, MAX_PATH, "%s\\*", dirp->dirname);
+		StringCchPrintfA(search_pattern, MAX_PATH-1, "%s\\*", dirp->dirname);
 		dirp->find_handle = FindFirstFileA(search_pattern, &find_data);
 		if (dirp->find_handle == INVALID_HANDLE_VALUE)
 			return NULL;


