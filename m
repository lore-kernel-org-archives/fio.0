Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/6] Fix conditional/message for max lba for sg ioengine
Date: Mon,  9 Jan 2017 23:42:00 +0900
Message-Id: <1483972923-13662-3-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1483972923-13662-1-git-send-email-tkusumi@tuxera.com>
References: <1483972923-13662-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Whether sg ioengine uses 10 or 16 bytes read/write command (by 5ad7be56)
is determined by ->prep() depending on lba to read/write vs 0xFFFFFFFFULL,
so let the message show it depends.

Also remove unused sgio_data::max_lba which is essentially the same
(divide by bs minus 1) as fio_file::real_file_size.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 engines/sg.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/engines/sg.c b/engines/sg.c
index c9a1448..00bf303 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -32,7 +32,6 @@ struct sgio_data {
 	int *fd_flags;
 	void *sgbuf;
 	unsigned int bs;
-	long long max_lba;
 	int type_checked;
 };
 
@@ -535,9 +534,10 @@ static int fio_sgio_type_check(struct thread_data *td, struct fio_file *f)
 
 	sd->bs = bs;
 	// Determine size of commands needed based on max_lba
-	sd->max_lba = max_lba;
-	if (max_lba > MAX_10B_LBA) {
-		dprint(FD_IO, "sgio_type_check: using 16 byte operations: max_lba = 0x%016llx\n", max_lba);
+	if (max_lba >= MAX_10B_LBA) {
+		dprint(FD_IO, "sgio_type_check: using 16 byte read/write "
+			"commands for lba above 0x%016llx/0x%016llx\n",
+			MAX_10B_LBA, max_lba);
 	}
 
 
-- 
2.5.5


