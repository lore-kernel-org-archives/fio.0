Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [three fio patches 1/3] docs: small HOWTO fixes
Date: Wed, 28 Aug 2019 13:48:40 -0400
Message-Id: <20190828174842.25423-2-vincentfu@gmail.com>
In-Reply-To: <20190828174842.25423-1-vincentfu@gmail.com>
References: <20190828174842.25423-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Document three debug options and fix a formatting error.
---
 HOWTO | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/HOWTO b/HOWTO
index 41b959d1..1c9b2c10 100644
--- a/HOWTO
+++ b/HOWTO
@@ -93,6 +93,12 @@ Command line options
 			Dump info related to I/O rate switching.
 	*compress*
 			Dump info related to log compress/decompress.
+	*steadystate*
+			Dump info related to steadystate detection.
+	*helperthread*
+			Dump info related to the helper thread.
+	*zbd*
+			Dump info related to support for zoned block devices.
 	*?* or *help*
 			Show available debug options.
 
@@ -2388,7 +2394,7 @@ I/O depth
 	this option can reduce both performance and the :option:`iodepth` achieved.
 
 	This option only applies to I/Os issued for a single job except when it is
-	enabled along with :option:`io_submit_mode`=offload. In offload mode, fio
+	enabled along with :option:`io_submit_mode`\=offload. In offload mode, fio
 	will check for overlap among all I/Os submitted by offload jobs with :option:`serialize_overlap`
 	enabled.
 
-- 
2.17.1


