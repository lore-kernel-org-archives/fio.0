Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 5/5] Change td_var() to take void* for the first arg
Date: Thu, 19 Jan 2017 02:38:27 +0900
Message-Id: <1484761107-21387-5-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1484761107-21387-1-git-send-email-tkusumi@tuxera.com>
References: <1484761107-21387-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Callers don't always pass thread_options* to td_var(),
nor is it dependent on a certain structure type,
so just take void* without pointless cast.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 parse.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/parse.h b/parse.h
index 54e3948..fb6abd1 100644
--- a/parse.h
+++ b/parse.h
@@ -107,8 +107,7 @@ typedef int (fio_opt_str_val_fn)(void *, long long *);
 typedef int (fio_opt_int_fn)(void *, int *);
 
 struct thread_options;
-static inline void *td_var(struct thread_options *to, struct fio_option *o,
-			   unsigned int offset)
+static inline void *td_var(void *to, struct fio_option *o, unsigned int offset)
 {
 	void *ret;
 
-- 
2.5.5


