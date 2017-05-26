Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/3] verify: mention some default option values
Date: Fri, 26 May 2017 22:25:10 +0300
Message-Id: <20170526192511.31502-2-tkusumi@tuxera.com>
In-Reply-To: <20170526192511.31502-1-tkusumi@tuxera.com>
References: <20170526192511.31502-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/HOWTO b/HOWTO
index a899b90..8cfa12c 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2467,6 +2467,7 @@ Verification
 	contents to one or more separate threads. If using this offload option, even
 	sync I/O engines can benefit from using an :option:`iodepth` setting higher
 	than 1, as it allows them to have I/O in flight while verifies are running.
+	Defaults to 0 async thread, i.e. verification is not asynchronous.
 
 .. option:: verify_async_cpus=str
 
@@ -2503,7 +2504,7 @@ Verification
 
 	<type> is "local" for a local run, "sock" for a client/server socket
 	connection, and "ip" (192.168.0.1, for instance) for a networked
-	client/server connection.
+	client/server connection. Defaults to true.
 
 .. option:: verify_state_load=bool
 
-- 
2.9.4


