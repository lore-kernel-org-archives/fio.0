Return-Path: <prvs=844bea82a=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 3/5] engines/libzbc: Enable trim for libzbc I/O engine
Date: Thu,  5 Aug 2021 12:28:33 +0900
Message-Id: <20210805032835.1119908-4-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20210805032835.1119908-1-shinichiro.kawasaki@wdc.com>
References: <20210805032835.1119908-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

The trim workload to zoned block devices is supported as zone reset, and
this feature is available for I/O engines which support both zoned
devices and trim workload. Libzbc I/O engine supports zoned devices but
lacks trim workload support. To enable trim support with libzbc I/O
engine, remove the check which inhibited trim from requests to libzbc
I/O engine. Also set file open flags for trim same as write, and call
zbd_do_io_u_trim() for trim I/O.

Of note is that libzbc I/O engine now can support trim to sequential
write required zones only. The trim I/Os to conventional zones are
reported as an error.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 engines/libzbc.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/engines/libzbc.c b/engines/libzbc.c
index 7f2bc431..abee2043 100644
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
@@ -411,7 +408,11 @@ static enum fio_q_status libzbc_queue(struct thread_data *td, struct io_u *io_u)
 		ret = zbc_flush(ld->zdev);
 		if (ret)
 			log_err("zbc_flush error %zd\n", ret);
-	} else if (io_u->ddir != DDIR_TRIM) {
+	} else if (io_u->ddir == DDIR_TRIM) {
+		ret = zbd_do_io_u_trim(td, io_u);
+		if (!ret)
+			ret = EINVAL;
+	} else {
 		log_err("Unsupported operation %u\n", io_u->ddir);
 		ret = -EINVAL;
 	}
-- 
2.31.1


