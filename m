Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/9] Drop the only local variable declaration within a for-loop (C99)
Date: Sat, 15 Apr 2017 00:06:19 +0300
Message-Id: <20170414210626.32763-3-tkusumi@tuxera.com>
In-Reply-To: <20170414210626.32763-1-tkusumi@tuxera.com>
References: <20170414210626.32763-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Nothing happens at least with gcc by default, but this is the only
C99 (or after) specific declaration, so change it to normal style.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 parse.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/parse.c b/parse.c
index fd5605f..4d4fddd 100644
--- a/parse.c
+++ b/parse.c
@@ -135,6 +135,7 @@ static unsigned long long get_mult_time(const char *str, int len,
 	const char *p = str;
 	char *c;
 	unsigned long long mult = 1;
+	int i;
 
 	/*
          * Go forward until we hit a non-digit, or +/- sign
@@ -153,7 +154,7 @@ static unsigned long long get_mult_time(const char *str, int len,
 	}
 
 	c = strdup(p);
-	for (int i = 0; i < strlen(c); i++)
+	for (i = 0; i < strlen(c); i++)
 		c[i] = tolower(c[i]);
 
 	if (!strncmp("us", c, 2) || !strncmp("usec", c, 4))
-- 
2.9.3


