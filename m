Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/6] Non functional fixup for 16 bytes read capacity for sg ioengine
Date: Mon,  9 Jan 2017 23:42:01 +0900
Message-Id: <1483972923-13662-4-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1483972923-13662-1-git-send-email-tkusumi@tuxera.com>
References: <1483972923-13662-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 engines/sg.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/engines/sg.c b/engines/sg.c
index 00bf303..e70803c 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -20,7 +20,7 @@
 #define MAX_SB 64               // sense block maximum return size
 
 struct sgio_cmd {
-	unsigned char cdb[16];  	// increase to support 16 byte commands
+	unsigned char cdb[16];      // enhanced from 10 to support 16 byte commands
 	unsigned char sb[MAX_SB];   // add sense block to commands
 	int nr;
 };
@@ -308,7 +308,6 @@ static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 	 * blocks on medium.
 	 */
 	if (hdr->dxfer_direction != SG_DXFER_NONE) {
-
 		if (lba < MAX_10B_LBA) {
 			hdr->cmdp[2] = (unsigned char) ((lba >> 24) & 0xff);
 			hdr->cmdp[3] = (unsigned char) ((lba >> 16) & 0xff);
@@ -415,12 +414,11 @@ static int fio_sgio_read_capacity(struct thread_data *td, unsigned int *bs,
 	}
 
 	*bs	 = (buf[4] << 24) | (buf[5] << 16) | (buf[6] << 8) | buf[7];
-	*max_lba = ((buf[0] << 24) | (buf[1] << 16) | (buf[2] << 8) | buf[3]) & 0x00000000FFFFFFFFULL;  // for some reason max_lba is being sign extended even though unsigned.
-
+	*max_lba = ((buf[0] << 24) | (buf[1] << 16) | (buf[2] << 8) | buf[3]) & MAX_10B_LBA;  // for some reason max_lba is being sign extended even though unsigned.
 
 	/*
-	 * If max lba is 0xFFFFFFFF, then need to retry with
-	 * 16 byteread capacity
+	 * If max lba masked by MAX_10B_LBA equals MAX_10B_LBA,
+	 * then need to retry with 16 byte Read Capacity command.
 	 */
 	if (*max_lba == MAX_10B_LBA) {
 		hdr.cmd_len = 16;
@@ -506,7 +504,6 @@ static int fio_sgio_type_check(struct thread_data *td, struct fio_file *f)
 	unsigned int bs = 0;
 	unsigned long long max_lba = 0;
 
-
 	if (f->filetype == FIO_TYPE_BD) {
 		if (ioctl(f->fd, BLKSSZGET, &bs) < 0) {
 			td_verror(td, errno, "ioctl");
@@ -540,7 +537,6 @@ static int fio_sgio_type_check(struct thread_data *td, struct fio_file *f)
 			MAX_10B_LBA, max_lba);
 	}
 
-
 	if (f->filetype == FIO_TYPE_BD) {
 		td->io_ops->getevents = NULL;
 		td->io_ops->event = NULL;
@@ -818,7 +814,7 @@ static struct ioengine_ops ioengine = {
 	.cleanup	= fio_sgio_cleanup,
 	.open_file	= fio_sgio_open,
 	.close_file	= generic_close_file,
-	.get_file_size	= fio_sgio_get_file_size, // generic_get_file_size
+	.get_file_size	= fio_sgio_get_file_size,
 	.flags		= FIO_SYNCIO | FIO_RAWIO,
 };
 
-- 
2.5.5


