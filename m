Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/2] add FD_PARSE debug print for size= option (which exists in offset=)
Date: Wed, 28 Jun 2017 17:21:06 +0300
Message-Id: <20170628142106.31846-3-tkusumi@tuxera.com>
In-Reply-To: <20170628142106.31846-1-tkusumi@tuxera.com>
References: <20170628142106.31846-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 options.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/options.c b/options.c
index 7431ed8..f103fc4 100644
--- a/options.c
+++ b/options.c
@@ -1410,6 +1410,8 @@ static int str_size_cb(void *data, unsigned long long *__val)
 	if (parse_is_percent(v)) {
 		td->o.size = 0;
 		td->o.size_percent = -1ULL - v;
+		dprint(FD_PARSE, "SET size_percent %d\n",
+					td->o.size_percent);
 	} else
 		td->o.size = v;
 
-- 
2.9.4


