Return-Path: <prvs=94868c4cd=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 2/9] sg: Avoid READ CAPACITY failures
Date: Thu, 21 Feb 2019 13:11:00 +0900
Message-Id: <20190221041107.8576-3-damien.lemoal@wdc.com>
In-Reply-To: <20190221041107.8576-1-damien.lemoal@wdc.com>
References: <20190221041107.8576-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Matias Bjorling <matias.bjorling@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Some SCSI devices (very large disks or SMR zoned disks in particular)
do not support the READ CAPACITY(10) command and only reply
successfully to the READ CAPACITY(16) command. This patch forces the
execution READ CAPACITY(16) if READ CAPACITY(10) fails with
CHECK CONDITION.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 engines/sg.c | 45 ++++++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/engines/sg.c b/engines/sg.c
index 3cc068f3..9105c24c 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -723,6 +723,8 @@ static int fio_sgio_read_capacity(struct thread_data *td, unsigned int *bs,
 	 * io_u structures, which are not initialized until later.
 	 */
 	struct sg_io_hdr hdr;
+	unsigned long long hlba;
+	unsigned int blksz = 0;
 	unsigned char cmd[16];
 	unsigned char sb[64];
 	unsigned char buf[32];  // read capacity return
@@ -759,16 +761,21 @@ static int fio_sgio_read_capacity(struct thread_data *td, unsigned int *bs,
 		return ret;
 	}
 
-	*bs	 = ((unsigned long) buf[4] << 24) | ((unsigned long) buf[5] << 16) |
-		   ((unsigned long) buf[6] << 8) | (unsigned long) buf[7];
-	*max_lba = ((unsigned long) buf[0] << 24) | ((unsigned long) buf[1] << 16) |
-		   ((unsigned long) buf[2] << 8) | (unsigned long) buf[3];
+	if (hdr.info & SG_INFO_CHECK) {
+		/* RCAP(10) might be unsupported by device. Force RCAP(16) */
+		hlba = MAX_10B_LBA;
+	} else {
+		blksz	 = ((unsigned long) buf[4] << 24) | ((unsigned long) buf[5] << 16) |
+			   ((unsigned long) buf[6] << 8) | (unsigned long) buf[7];
+		hlba	 = ((unsigned long) buf[0] << 24) | ((unsigned long) buf[1] << 16) |
+			   ((unsigned long) buf[2] << 8) | (unsigned long) buf[3];
+	}
 
 	/*
 	 * If max lba masked by MAX_10B_LBA equals MAX_10B_LBA,
 	 * then need to retry with 16 byte Read Capacity command.
 	 */
-	if (*max_lba == MAX_10B_LBA) {
+	if (hlba == MAX_10B_LBA) {
 		hdr.cmd_len = 16;
 		hdr.cmdp[0] = 0x9e; // service action
 		hdr.cmdp[1] = 0x10; // Read Capacity(16)
@@ -791,19 +798,27 @@ static int fio_sgio_read_capacity(struct thread_data *td, unsigned int *bs,
 		if (hdr.info & SG_INFO_CHECK)
 			td_verror(td, EIO, "fio_sgio_read_capacity");
 
-		*bs = (buf[8] << 24) | (buf[9] << 16) | (buf[10] << 8) | buf[11];
-		*max_lba = ((unsigned long long)buf[0] << 56) |
-				((unsigned long long)buf[1] << 48) |
-				((unsigned long long)buf[2] << 40) |
-				((unsigned long long)buf[3] << 32) |
-				((unsigned long long)buf[4] << 24) |
-				((unsigned long long)buf[5] << 16) |
-				((unsigned long long)buf[6] << 8) |
-				(unsigned long long)buf[7];
+		blksz = (buf[8] << 24) | (buf[9] << 16) | (buf[10] << 8) | buf[11];
+		hlba  = ((unsigned long long)buf[0] << 56) |
+			((unsigned long long)buf[1] << 48) |
+			((unsigned long long)buf[2] << 40) |
+			((unsigned long long)buf[3] << 32) |
+			((unsigned long long)buf[4] << 24) |
+			((unsigned long long)buf[5] << 16) |
+			((unsigned long long)buf[6] << 8) |
+			(unsigned long long)buf[7];
+	}
+
+	if (blksz) {
+		*bs = blksz;
+		*max_lba = hlba;
+		ret = 0;
+	} else {
+		ret = EIO;
 	}
 
 	close(fd);
-	return 0;
+	return ret;
 }
 
 static void fio_sgio_cleanup(struct thread_data *td)
-- 
2.20.1


