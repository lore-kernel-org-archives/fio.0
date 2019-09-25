Return-Path: <prvs=1646af0c7=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/2] filesetup: Extend file size for 'null' and 'filecreate' ioengines
Date: Wed, 25 Sep 2019 17:29:24 +0900
Message-Id: <20190925082924.9771-3-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20190925082924.9771-1-shinichiro.kawasaki@wdc.com>
References: <20190925082924.9771-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Vincent Fu <Vincent.Fu@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Masato Suzuki <masato.suzuki@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

It was reported the fio command with following options fails because of
file access beyond the file size specified with size option.

./fio --name=test --rw=randread --runtime=10s --offset=90% --time_based --ioengine=null --size=1T --norandommap --randrepeat=0

One of the options specifies null ioengine which has FIO_DISKLESSIO and
FIO_FAKEIO flags. When FIO_DISKLESSIO flag is set, current fio code does
not extend the file size even when io_size + file_offset is larger than
real_file_size. With this, random offsets are generated within io_size +
file_offset range and fail comparison with real_file_size. This failure
does not happen with other engines such as libaio since the target file
is extended to ensure real_file_size is larger than io_size +
file_offset.

To avoid the failure, extend file size for ioengines with FIO_DISKLESSIO
and FIO_FAKEIO. This changes behavior of two ioengines only: null
ioengine and filecreate engine. It does not change behavior of all other
ioengines including 12 ioengines with FIO_DISKLESSIO flag, such as nbd,
glusterfs, pmemblk, etc.

Signed-off-by: Masato Suzuki <masato.suzuki@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 filesetup.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index 7904d187..a439b6d6 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1104,13 +1104,15 @@ int setup_files(struct thread_data *td)
 		}
 
 		if (f->filetype == FIO_TYPE_FILE &&
-		    (f->io_size + f->file_offset) > f->real_file_size &&
-		    !td_ioengine_flagged(td, FIO_DISKLESSIO)) {
-			if (!o->create_on_open) {
+		    (f->io_size + f->file_offset) > f->real_file_size) {
+			if (!td_ioengine_flagged(td, FIO_DISKLESSIO) &&
+			    !o->create_on_open) {
 				need_extend++;
 				extend_size += (f->io_size + f->file_offset);
 				fio_file_set_extend(f);
-			} else
+			} else if (!td_ioengine_flagged(td, FIO_DISKLESSIO) ||
+				   (td_ioengine_flagged(td, FIO_DISKLESSIO) &&
+				    td_ioengine_flagged(td, FIO_FAKEIO)))
 				f->real_file_size = f->io_size + f->file_offset;
 		}
 	}
-- 
2.21.0


