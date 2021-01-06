Return-Path: <prvs=6334d1505=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v3 20/38] engines/libzbc: enable block backend
Date: Thu,  7 Jan 2021 06:57:21 +0900
Message-Id: <20210106215739.264524-21-dmitry.fomichev@wdc.com>
In-Reply-To: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

When opening a device, the current version of libzbc ioengine instructs
libzbc to only try SCSI and ATA backends for scanning the drive. This
prevents opening null_blk devices that fail to be accepted by the both
above mentioned backends and require the block backend to be enabled.

Set the appropriate flag to enable the block backend in zbc_open()
libzbc call.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 engines/libzbc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/engines/libzbc.c b/engines/libzbc.c
index 552aab65..2aacf7bb 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -86,7 +86,8 @@ static int libzbc_open_dev(struct thread_data *td, struct fio_file *f,
 		return -ENOMEM;
 
 	ret = zbc_open(f->file_name,
-		       flags | ZBC_O_DRV_SCSI | ZBC_O_DRV_ATA, &ld->zdev);
+		       flags | ZBC_O_DRV_BLOCK | ZBC_O_DRV_SCSI | ZBC_O_DRV_ATA,
+		       &ld->zdev);
 	if (ret) {
 		log_err("%s: zbc_open() failed, err=%d\n",
 			f->file_name, ret);
-- 
2.28.0


