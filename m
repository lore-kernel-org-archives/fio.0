Return-Path: <prvs=6334d1505=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v3 13/38] zbd: initialize min_zone and max_zone for all zone types
Date: Thu,  7 Jan 2021 06:57:14 +0900
Message-Id: <20210106215739.264524-14-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

The function zbd_verify_sizes() checks if the given I/O range includes
write pointer zones. When all zones in the I/O range are conventional,
it skips checks for size options and leaves min_zone and max_zone in
struct fio_file with zero values. These uninitialized min_zone and
max_zone fields trigger unexpected behaviors such as unset
sectors_with_data.

Fix this by moving min_zone and max_zone set up from zbd_verify_sizes()
to zbd_setup_files(). This allows for setting up the values regardless
of zone types in I/O range.

Bypass the assertion to ensure that max_zone is larger than min_zone if
all zones in the I/O range are conventional. In this case, io_size
can be smaller than zone size and, consequently, min_zone may become
the same as max_zone.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/zbd.c b/zbd.c
index 757e72d5..563f941b 100644
--- a/zbd.c
+++ b/zbd.c
@@ -324,10 +324,6 @@ static bool zbd_verify_sizes(void)
 					 (unsigned long long) new_end - f->file_offset);
 				f->io_size = new_end - f->file_offset;
 			}
-
-			f->min_zone = zbd_zone_idx(f, f->file_offset);
-			f->max_zone = zbd_zone_idx(f, f->file_offset + f->io_size);
-			assert(f->min_zone < f->max_zone);
 		}
 	}
 
@@ -680,6 +676,18 @@ int zbd_setup_files(struct thread_data *td)
 		if (!zbd)
 			continue;
 
+		f->min_zone = zbd_zone_idx(f, f->file_offset);
+		f->max_zone = zbd_zone_idx(f, f->file_offset + f->io_size);
+
+		/*
+		 * When all zones in the I/O range are conventional, io_size
+		 * can be smaller than zone size, making min_zone the same
+		 * as max_zone. This is why the assert below needs to be made
+		 * conditional.
+		 */
+		if (zbd_is_seq_job(f))
+			assert(f->min_zone < f->max_zone);
+
 		zbd->max_open_zones = zbd->max_open_zones ?: ZBD_MAX_OPEN_ZONES;
 
 		if (td->o.max_open_zones > 0 &&
-- 
2.28.0


