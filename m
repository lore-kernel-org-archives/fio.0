Return-Path: <ms@mango.of.teamix.net>
From: Martin Steigerwald <ms@teamix.de>
Subject: [PATCH] Fix spelling error in fio manpage.
Date: Tue, 27 Aug 2013 16:26:40 +0200
Message-Id: <1377613600-7322-1-git-send-email-ms@teamix.de>
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Martin Steigerwald <ms@teamix.de>
List-ID: <fio@vger.kernel.org>

---
 fio.1 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fio.1 b/fio.1
index e35bd93..b8082af 100644
--- a/fio.1
+++ b/fio.1
@@ -321,7 +321,7 @@ are likely to be issued. Default: true.
 .TP
 .BI size \fR=\fPint
 Total size of I/O for this job.  \fBfio\fR will run until this many bytes have
-been transfered, unless limited by other options (\fBruntime\fR, for instance).
+been transferred, unless limited by other options (\fBruntime\fR, for instance).
 Unless \fBnrfiles\fR and \fBfilesize\fR options are given, this amount will be
 divided between the available files for the job. If not set, fio will use the
 full size of the given files or devices. If the the files do not exist, size
-- 
1.8.4.rc3


