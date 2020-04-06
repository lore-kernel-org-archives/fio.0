Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Mon, 6 Apr 2020 22:56:10 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] zbd: fixup ->zone_size_log2 if zone size is not power of 2
Message-ID: <20200406195610.GA3255@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, damien.lemoal@wdc.com
List-ID: <fio@vger.kernel.org>

Code like this doesn't work if log2 is 0xffffffff.

	if (f->zbd_info->zone_size_log2 > 0)
                zone_idx = offset >> f->zbd_info->zone_size_log2;
        else
                zone_idx = offset / f->zbd_info->zone_size;

Other than that everything else works!

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
---

 zbd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/zbd.c
+++ b/zbd.c
@@ -393,7 +393,7 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 	f->zbd_info = zbd_info;
 	f->zbd_info->zone_size = zone_size;
 	f->zbd_info->zone_size_log2 = is_power_of_2(zone_size) ?
-		ilog2(zone_size) : -1;
+		ilog2(zone_size) : 0;
 	f->zbd_info->nr_zones = nr_zones;
 	pthread_mutexattr_destroy(&attr);
 	return 0;
@@ -510,7 +510,7 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	f->zbd_info = zbd_info;
 	f->zbd_info->zone_size = zone_size;
 	f->zbd_info->zone_size_log2 = is_power_of_2(zone_size) ?
-		ilog2(zone_size) : -1;
+		ilog2(zone_size) : 0;
 	f->zbd_info->nr_zones = nr_zones;
 	zbd_info = NULL;
 	ret = 0;

