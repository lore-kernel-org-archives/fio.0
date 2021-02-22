Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Mon, 22 Feb 2021 16:24:01 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 3/4] zbd: fix check against 32-bit zone size
Message-ID: <YDOwcVQ0xooNjqR1@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, dmitry.fomichev@wdc.com
List-ID: <fio@vger.kernel.org>

Zone size can be bigger than 4GB.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
---

 zbd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/zbd.c
+++ b/zbd.c
@@ -333,20 +333,21 @@ static bool zbd_verify_bs(void)
 {
 	struct thread_data *td;
 	struct fio_file *f;
-	uint32_t zone_size;
 	int i, j, k;
 
 	for_each_td(td, i) {
 		for_each_file(td, f, j) {
+			uint64_t zone_size;
+
 			if (!f->zbd_info)
 				continue;
 			zone_size = f->zbd_info->zone_size;
 			for (k = 0; k < FIO_ARRAY_SIZE(td->o.bs); k++) {
 				if (td->o.verify != VERIFY_NONE &&
 				    zone_size % td->o.bs[k] != 0) {
-					log_info("%s: block size %llu is not a divisor of the zone size %d\n",
+					log_info("%s: block size %llu is not a divisor of the zone size %llu\n",
 						 f->file_name, td->o.bs[k],
-						 zone_size);
+						 (unsigned long long)zone_size);
 					return false;
 				}
 			}

