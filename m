Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/4] HOWTO: fix "should be to to"
Date: Tue, 25 Jul 2017 22:05:41 +0300
Message-Id: <20170725190544.66919-2-tkusumi@tuxera.com>
In-Reply-To: <20170725190544.66919-1-tkusumi@tuxera.com>
References: <20170725190544.66919-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 2 +-
 fio.1 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/HOWTO b/HOWTO
index e544634..5a9cda5 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1255,7 +1255,7 @@ I/O type
 
 	* 60% of accesses should be to the first 10%
 	* 30% of accesses should be to the next 20%
-	* 8% of accesses should be to to the next 30%
+	* 8% of accesses should be to the next 30%
 	* 2% of accesses should be to the next 40%
 
 	we can define that through zoning of the random accesses. For the above
diff --git a/fio.1 b/fio.1
index 7fe96e0..0badda1 100644
--- a/fio.1
+++ b/fio.1
@@ -1143,7 +1143,7 @@ given a criteria of:
 30% of accesses should be to the next 20%
 .RE
 .RS
-8% of accesses should be to to the next 30%
+8% of accesses should be to the next 30%
 .RE
 .RS
 2% of accesses should be to the next 40%
-- 
2.9.4


