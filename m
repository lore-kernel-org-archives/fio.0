Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/3] HOWTO: minor fix and backport from man page
Date: Tue,  1 Aug 2017 22:49:28 +0300
Message-Id: <20170801194928.50146-4-tkusumi@tuxera.com>
In-Reply-To: <20170801194928.50146-1-tkusumi@tuxera.com>
References: <20170801194928.50146-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/HOWTO b/HOWTO
index 3a02cc6..ee2b996 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1529,6 +1529,7 @@ Buffers and memory
 
 		**cudamalloc**
 			Use GPU memory as the buffers for GPUDirect RDMA benchmark.
+			The ioengine must be rdma.
 
 	The area allocated is a function of the maximum allowed bs size for the job,
 	multiplied by the I/O depth given. Note that for **shmhuge** and
@@ -1857,7 +1858,7 @@ caveat that when used on the command line, they must come after the
 
    [libhdfs]
 
-		the listening port of the HFDS cluster namenode.
+		The listening port of the HFDS cluster namenode.
 
 .. option:: interface=str : [netsplice] [net]
 
@@ -1930,7 +1931,7 @@ caveat that when used on the command line, they must come after the
 	**0**
 		Default. Preallocate donor's file on init.
 	**1**
-		Allocate space immediately inside defragment event,	and free right
+		Allocate space immediately inside defragment event, and free right
 		after event.
 
 .. option:: clustername=str : [rbd]
@@ -1962,7 +1963,7 @@ caveat that when used on the command line, they must come after the
 
 .. option:: chunk_size : [libhdfs]
 
-	the size of the chunk to use for each file.
+	The size of the chunk to use for each file.
 
 
 I/O depth
@@ -2486,7 +2487,7 @@ Verification
 
 .. option:: verifysort_nr=int
 
-   Pre-load and sort verify blocks for a read workload.
+	Pre-load and sort verify blocks for a read workload.
 
 .. option:: verify_offset=int
 
-- 
2.9.4


