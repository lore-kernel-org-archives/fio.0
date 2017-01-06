Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/2] Fix comment on SCSI commands
Date: Sat,  7 Jan 2017 03:15:18 +0900
Message-Id: <1483726518-10712-2-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1483726518-10712-1-git-send-email-tkusumi@tuxera.com>
References: <1483726518-10712-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

[0] is service action (unless this is intentional).

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 engines/sg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/engines/sg.c b/engines/sg.c
index 001193d..2ad3394 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -425,8 +425,8 @@ static int fio_sgio_read_capacity(struct thread_data *td, unsigned int *bs,
 	 */
 	if (*max_lba == MAX_10B_LBA) {
 		hdr.cmd_len = 16;
-		hdr.cmdp[0] = 0x9e; // Read Capacity(16)
-		hdr.cmdp[1] = 0x10; // service action
+		hdr.cmdp[0] = 0x9e; // service action
+		hdr.cmdp[1] = 0x10; // Read Capacity(16)
 		hdr.cmdp[10] = (unsigned char) ((sizeof(buf) >> 24) & 0xff);
 		hdr.cmdp[11] = (unsigned char) ((sizeof(buf) >> 16) & 0xff);
 		hdr.cmdp[12] = (unsigned char) ((sizeof(buf) >> 8) & 0xff);
-- 
2.5.5


