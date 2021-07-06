Return-Path: <prvs=8148fed87=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 3/4] engines/libzbc: Enable trim for libzbc I/O engine
Date: Tue,  6 Jul 2021 09:59:25 +0900
Message-Id: <20210706005926.303890-4-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20210706005926.303890-1-shinichiro.kawasaki@wdc.com>
References: <20210706005926.303890-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

The trim workload to zoned block devices is supported as zone reset, and
this feature is available for I/O engines which support both zoned
devices and trim workload. Libzbc I/O engine supports zoned but lacks
trim workload support. To enable trim support with libzbc I/O engine,
remove the check which inhibited trim from requests to libzbc I/O
engine. Also set file open flags for trim same as write, and call
zbd_do_io_u_trim() for trim I/O.

Of note is that libzbc I/O engine now can support trim to sequential
write required zones, but still can not support os_trim() call and
BLKDISCARD ioctl for the conventional zones. The trim I/Os to
conventional zones are reported as an error.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 engines/libzbc.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/engines/libzbc.c b/engines/libzbc.c
index 7f2bc431..5b4c5e8e 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -14,6 +14,7 @@
 #include "fio.h"
 #include "err.h"
 #include "zbd_types.h"
+#include "zbd.h"
 
 struct libzbc_data {
 	struct zbc_device	*zdev;
@@ -63,7 +64,7 @@ static int libzbc_open_dev(struct thread_data *td, struct fio_file *f,
 		return -EINVAL;
 	}
 
-	if (td_write(td)) {
+	if (td_write(td) || td_trim(td)) {
 		if (!read_only)
 			flags |= O_RDWR;
 	} else if (td_read(td)) {
@@ -71,10 +72,6 @@ static int libzbc_open_dev(struct thread_data *td, struct fio_file *f,
 			flags |= O_RDWR;
 		else
 			flags |= O_RDONLY;
-	} else if (td_trim(td)) {
-		td_verror(td, EINVAL, "libzbc does not support trim");
-		log_err("%s: libzbc does not support trim\n", f->file_name);
-		return -EINVAL;
 	}
 
 	if (td->o.oatomic) {
@@ -411,7 +408,14 @@ static enum fio_q_status libzbc_queue(struct thread_data *td, struct io_u *io_u)
 		ret = zbc_flush(ld->zdev);
 		if (ret)
 			log_err("zbc_flush error %zd\n", ret);
-	} else if (io_u->ddir != DDIR_TRIM) {
+	} else if (io_u->ddir == DDIR_TRIM) {
+		ret = zbd_do_io_u_trim(td, io_u);
+		if (!ret) {
+			log_err("libzbc does not support trim to "
+				"conventional zones\n");
+			ret = EINVAL;
+		}
+	} else {
 		log_err("Unsupported operation %u\n", io_u->ddir);
 		ret = -EINVAL;
 	}
-- 
2.31.1


