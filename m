Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/7] HOWTO: Mention cpuload= is mandatory for cpuio
Date: Mon, 20 Mar 2017 23:28:43 +0200
Message-Id: <20170320212847.71404-3-tkusumi@tuxera.com>
In-Reply-To: <20170320212847.71404-1-tkusumi@tuxera.com>
References: <20170320212847.71404-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

fio jobs using cpuio fail without this option value specified,
so mention it's mandatory (or have default value for this ?).

fio: pid=9320, err=22/file:engines/cpu.c:75, func=cpuio, error=cpu thread needs rate (cpuload=)
Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/HOWTO b/HOWTO
index 5d378f3..1ce1b0c 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1748,7 +1748,8 @@ caveat that when used on the command line, they must come after the
 
 .. option:: cpuload=int : [cpuio]
 
-	Attempt to use the specified percentage of CPU cycles.
+	Attempt to use the specified percentage of CPU cycles. This is a mandatory
+	option when using cpuio I/O engine.
 
 .. option:: cpuchunks=int : [cpuio]
 
-- 
2.9.3


