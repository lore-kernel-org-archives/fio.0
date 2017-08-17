Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH] doc: latency log unit is nsec
Date: Thu, 17 Aug 2017 14:05:33 -0400
Message-Id: <1502993133-26018-1-git-send-email-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

---
 HOWTO | 2 +-
 fio.1 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/HOWTO b/HOWTO
index 16ae708..4192ac7 100644
--- a/HOWTO
+++ b/HOWTO
@@ -3584,7 +3584,7 @@ and IOPS. The logs share a common format, which looks like this:
 on the type of log, it will be one of the following:
 
     **Latency log**
-		Value is latency in usecs
+		Value is latency in nsecs
     **Bandwidth log**
 		Value is in KiB/sec
     **IOPS log**
diff --git a/fio.1 b/fio.1
index 792bc9d..a0f1a24 100644
--- a/fio.1
+++ b/fio.1
@@ -3317,7 +3317,7 @@ on the type of log, it will be one of the following:
 .RS
 .TP
 .B Latency log
-Value is latency in usecs
+Value is latency in nsecs
 .TP
 .B Bandwidth log
 Value is in KiB/sec
-- 
2.7.4


