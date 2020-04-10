Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Fri, 10 Apr 2020 22:06:21 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] zbd: fix zonemode=zbd with NDEBUG
Message-ID: <20200410190621.GA26148@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
To: axboe@kernel.dk
Cc: damien.lemoal@wdc.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

assert() with NDEBUG doesn't evaluate argument.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
---

 zbd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/zbd.c
+++ b/zbd.c
@@ -1220,6 +1220,7 @@ static void zbd_put_io(const struct io_u *io_u)
 	struct zoned_block_device_info *zbd_info = f->zbd_info;
 	struct fio_zone_info *z;
 	uint32_t zone_idx;
+	int ret;
 
 	if (!zbd_info)
 		return;
@@ -1235,7 +1236,8 @@ static void zbd_put_io(const struct io_u *io_u)
 	       "%s: terminate I/O (%lld, %llu) for zone %u\n",
 	       f->file_name, io_u->offset, io_u->buflen, zone_idx);
 
-	assert(pthread_mutex_unlock(&z->mutex) == 0);
+	ret = pthread_mutex_unlock(&z->mutex);
+	assert(ret == 0);
 	zbd_check_swd(f);
 }
 

