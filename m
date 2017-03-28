Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 02/13] Use GOLDEN_RATIO_PRIME
Date: Tue, 28 Mar 2017 23:02:50 +0300
Message-Id: <20170328200301.8622-2-tkusumi@tuxera.com>
In-Reply-To: <20170328200301.8622-1-tkusumi@tuxera.com>
References: <20170328200301.8622-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Using this macro (originally for hash in Linux kernel) for rand seed
instead of hard-coded value should make sense. rdma ioengine uses
this for the seed as well.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 init.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/init.c b/init.c
index 6af6c45..eef5150 100644
--- a/init.c
+++ b/init.c
@@ -26,6 +26,7 @@
 #include "idletime.h"
 #include "filelock.h"
 #include "steadystate.h"
+#include "hash.h"
 
 #include "oslib/getopt.h"
 #include "oslib/strcasestr.h"
@@ -1083,11 +1084,11 @@ static int setup_random_seeds(struct thread_data *td)
 
 	seed = td->o.rand_seed;
 	for (i = 0; i < 4; i++)
-		seed *= 0x9e370001UL;
+		seed *= GOLDEN_RATIO_PRIME;
 
 	for (i = 0; i < FIO_RAND_NR_OFFS; i++) {
 		td->rand_seeds[i] = seed * td->thread_number + i;
-		seed *= 0x9e370001UL;
+		seed *= GOLDEN_RATIO_PRIME;
 	}
 
 	td_fill_rand_seeds(td);
-- 
2.9.3


