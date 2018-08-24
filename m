Return-Path: <prvs=76726b587=bart.vanassche@wdc.com>
From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 02/11] Add the 'zbd' debug level
Date: Fri, 24 Aug 2018 09:30:37 -0700
Message-Id: <20180824163046.12304-3-bart.vanassche@wdc.com>
In-Reply-To: <20180824163046.12304-1-bart.vanassche@wdc.com>
References: <20180824163046.12304-1-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bart.vanassche@wdc.com>
List-ID: <fio@vger.kernel.org>

This debug level will be used in the next patch.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 debug.h | 1 +
 init.c  | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/debug.h b/debug.h
index e5e8040049ac..51b18de23544 100644
--- a/debug.h
+++ b/debug.h
@@ -22,6 +22,7 @@ enum {
 	FD_COMPRESS,
 	FD_STEADYSTATE,
 	FD_HELPERTHREAD,
+	FD_ZBD,
 	FD_DEBUG_MAX,
 };
 
diff --git a/init.c b/init.c
index 3ed57570c7e0..7514d1ab0af5 100644
--- a/init.c
+++ b/init.c
@@ -2263,6 +2263,10 @@ const struct debug_level debug_levels[] = {
 	  .help = "Helper thread logging",
 	  .shift = FD_HELPERTHREAD,
 	},
+	{ .name = "zbd",
+	  .help = "Zoned Block Device logging",
+	  .shift = FD_ZBD,
+	},
 	{ .name = NULL, },
 };
 
-- 
2.18.0


