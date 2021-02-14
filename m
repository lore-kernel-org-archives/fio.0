Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Sun, 14 Feb 2021 22:14:31 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] fio: simplify parse_is_percent()
Message-ID: <YCl2l6N+4NFMngAu@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
To: axboe@kernel.dk
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Check like this

	unsigned long long val <= -1ULL

is tautologically true because of how type conversions work.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 parse.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/parse.h
+++ b/parse.h
@@ -131,7 +131,7 @@ static inline void *td_var(void *to, const struct fio_option *o,
 
 static inline int parse_is_percent(unsigned long long val)
 {
-	return val <= -1ULL && val >= (-1ULL - 100ULL);
+	return val >= -101;
 }
 
 #define ZONE_BASE_VAL ((-1ULL >> 1) + 1)

