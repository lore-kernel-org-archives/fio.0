Return-Path: <prvs=1646af0c7=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/2] Revert "filesetup: honor the offset option"
Date: Wed, 25 Sep 2019 17:29:23 +0900
Message-Id: <20190925082924.9771-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20190925082924.9771-1-shinichiro.kawasaki@wdc.com>
References: <20190925082924.9771-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Vincent Fu <Vincent.Fu@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Masato Suzuki <masato.suzuki@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

This reverts commit ad46c5715ffc5d4e70d2e941225b1f504f23e409.

The commit tried to fix a failure observed with --offset=90%, --size=1T
and --ioengine=null options. However, it affected fio behavior not only
for null ioengine but also for other all ioengines. It changed io_size,
then I/O read or written bytes are not same as that specified with
command line 'size' option. This caused t/zbd/test-zbd-support test
script failures for zoned block devices: test cases #17, #28 and #38
failed.

To prepare for other fix with limited ioengine impacts, revert the fix
which affects all ioengines.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 filesetup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/filesetup.c b/filesetup.c
index b8d1d838..7904d187 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1047,7 +1047,7 @@ int setup_files(struct thread_data *td)
 			 * doesn't divide nicely with the min blocksize,
 			 * make the first files bigger.
 			 */
-			f->io_size = fs - f->file_offset;
+			f->io_size = fs;
 			if (nr_fs_extra) {
 				nr_fs_extra--;
 				f->io_size += bs;
-- 
2.21.0


