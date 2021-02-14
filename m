Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Sun, 14 Feb 2021 22:16:55 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] fio: simplify zoneskip= validness check
Message-ID: <YCl3J7vD5juMk+/h@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
To: axboe@kernel.dk
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Simply check the remainder

	(zoneskip % zone_size) > 0

It will do the right thing for all zoneskip= values, and
zonesize being positive is checked earlier.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
---

 zbd.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/zbd.c
+++ b/zbd.c
@@ -285,9 +285,7 @@ static bool zbd_verify_sizes(void)
 				return false;
 			}
 
-			if (td->o.zone_skip &&
-			    (td->o.zone_skip < td->o.zone_size ||
-			     td->o.zone_skip % td->o.zone_size)) {
+			if (td->o.zone_skip % td->o.zone_size) {
 				log_err("%s: zoneskip %llu is not a multiple of the device zone size %llu.\n",
 					f->file_name, (unsigned long long) td->o.zone_skip,
 					(unsigned long long) td->o.zone_size);

