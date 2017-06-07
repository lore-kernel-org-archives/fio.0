Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/5] fix wrong malloc size for ignore_error buffer
Date: Wed,  7 Jun 2017 23:18:45 +0300
Message-Id: <20170607201849.9448-2-tkusumi@tuxera.com>
In-Reply-To: <20170607201849.9448-1-tkusumi@tuxera.com>
References: <20170607201849.9448-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This is supposed to be allocating the initial buffer which consists
of 4 integers to store errno values to ignore.
Also explicitly zero clear the buffer.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/options.c b/options.c
index 2daa983..864e778 100644
--- a/options.c
+++ b/options.c
@@ -282,7 +282,7 @@ static int ignore_error_type(struct thread_data *td, int etype, char *str)
 	}
 
 	td->o.ignore_error_nr[etype] = 4;
-	error = malloc(4 * sizeof(struct bssplit));
+	error = calloc(4, sizeof(int));
 
 	i = 0;
 	while ((fname = strsep(&str, ":")) != NULL) {
-- 
2.9.4


