Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH] man: add missing \ for fcntl(2) in write_hint option
Date: Sun, 16 Jul 2017 15:40:20 +0300
Message-Id: <20170716124020.2585-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

8f4b9f24 ('Update documentation for write_hint') was missing \.
Without this '|' becomes visible.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 fio.1 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fio.1 b/fio.1
index 8a41321..7fe96e0 100644
--- a/fio.1
+++ b/fio.1
@@ -565,7 +565,7 @@ Advise using \fBFADV_RANDOM\fR
 .RE
 .TP
 .BI write_hint \fR=\fPstr
-Use \fBfcntl\fR|(2) to advise the kernel what life time to expect from a write.
+Use \fBfcntl\fR\|(2) to advise the kernel what life time to expect from a write.
 Only supported on Linux, as of version 4.13. The values are all relative to
 each other, and no absolute meaning should be associated with them. Accepted
 values are:
-- 
2.9.4


