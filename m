Return-Path: <prvs=620a42eaa=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 08/36] zbd: avoid zone buffer overrun
Date: Thu, 24 Dec 2020 11:11:51 +0900
Message-Id: <20201224021219.189727-9-dmitry.fomichev@wdc.com>
In-Reply-To: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
References: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

If the total number of zones on a drive is calculated to a value that
is less than the number of zones it can actually report, zone info
buffer can be overrun. This may happen not only due to drive firmware
problems, but also because of underlying software incorrectly
reporting zoned device capacity.

Fix this by more carefully setting zone report size.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/zbd.c b/zbd.c
index 69befd5a..db0d650a 100644
--- a/zbd.c
+++ b/zbd.c
@@ -526,8 +526,9 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 		offset = z->start + z->len;
 		if (j >= nr_zones)
 			break;
-		nrz = zbd_report_zones(td, f, offset,
-					    zones, ZBD_REPORT_MAX_ZONES);
+		nrz = zbd_report_zones(td, f, offset, zones,
+				       min((uint32_t)(nr_zones - j),
+					   ZBD_REPORT_MAX_ZONES));
 		if (nrz < 0) {
 			ret = nrz;
 			log_info("fio: report zones (offset %llu) failed for %s (%d).\n",
-- 
2.28.0


