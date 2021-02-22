Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Mon, 22 Feb 2021 16:20:03 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 1/4] parse: simplify parse_is_percent()
Message-ID: <YDOvg+OKTZhSoDce@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, dmitry.fomichev@wdc.com
List-ID: <fio@vger.kernel.org>

Check "unsigned long long val <= -1ULL" is tautologically true
because of how value conversions work.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
---

 parse.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/parse.h
+++ b/parse.h
@@ -130,7 +130,7 @@ static inline void *td_var(void *to, const struct fio_option *o,
 
 static inline int parse_is_percent(unsigned long long val)
 {
-	return val <= -1ULL && val >= (-1ULL - 100ULL);
+	return val >= -101;
 }
 
 static inline int parse_is_percent_uncapped(unsigned long long val)

