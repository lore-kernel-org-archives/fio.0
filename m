Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 6/6] Add missing "rand"/"trimwrite" strings to corresponding ddir slots
Date: Mon, 13 Feb 2017 18:32:39 +0200
Message-Id: <20170213163239.46188-6-tkusumi@tuxera.com>
In-Reply-To: <20170213163239.46188-1-tkusumi@tuxera.com>
References: <20170213163239.46188-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

though "rand" alone is unused.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 io_ddir.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_ddir.h b/io_ddir.h
index 2141119..613d5fb 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -61,9 +61,9 @@ static inline int ddir_rw(enum fio_ddir ddir)
 
 static inline const char *ddir_str(enum td_ddir ddir)
 {
-	static const char *__str[] = { NULL, "read", "write", "rw", NULL,
+	static const char *__str[] = { NULL, "read", "write", "rw", "rand",
 				"randread", "randwrite", "randrw",
-				"trim", NULL, NULL, NULL, "randtrim" };
+				"trim", NULL, "trimwrite", NULL, "randtrim" };
 
 	return __str[ddir];
 }
-- 
2.9.3


