Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/3] steadystate: Use calloc(3)
Date: Sat, 11 Feb 2017 16:28:54 +0200
Message-Id: <20170211142854.23620-3-tkusumi@tuxera.com>
In-Reply-To: <20170211142854.23620-1-tkusumi@tuxera.com>
References: <20170211142854.23620-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

which guarantees zero clear.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 steadystate.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/steadystate.c b/steadystate.c
index 951376f..43c715c 100644
--- a/steadystate.c
+++ b/steadystate.c
@@ -8,13 +8,8 @@ bool steadystate_enabled = false;
 
 static void steadystate_alloc(struct thread_data *td)
 {
-	int i;
-
-	td->ss.bw_data = malloc(td->ss.dur * sizeof(uint64_t));
-	td->ss.iops_data = malloc(td->ss.dur * sizeof(uint64_t));
-	/* initialize so that it is obvious if the cache is not full in the output */
-	for (i = 0; i < td->ss.dur; i++)
-		td->ss.iops_data[i] = td->ss.bw_data[i] = 0;
+	td->ss.bw_data = calloc(td->ss.dur, sizeof(uint64_t));
+	td->ss.iops_data = calloc(td->ss.dur, sizeof(uint64_t));
 
 	td->ss.state |= __FIO_SS_DATA;
 }
-- 
2.9.3


