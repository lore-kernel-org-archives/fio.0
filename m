Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 07/13] Ignore pre-read for FIO_NOIO td
Date: Tue, 28 Mar 2017 23:02:55 +0300
Message-Id: <20170328200301.8622-7-tkusumi@tuxera.com>
In-Reply-To: <20170328200301.8622-1-tkusumi@tuxera.com>
References: <20170328200301.8622-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

pre_read_file() should ignore FIO_NOIO (i.e. cpuio) in addition to
FIO_PIPEIO. It does/should fail anyway since FIO_NOIO td is supposed
to have -1 for fd for not supporting any I/O.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/filesetup.c b/filesetup.c
index 9335dcd..bd971e8 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -235,7 +235,8 @@ static int pre_read_file(struct thread_data *td, struct fio_file *f)
 	unsigned int bs;
 	char *b;
 
-	if (td_ioengine_flagged(td, FIO_PIPEIO))
+	if (td_ioengine_flagged(td, FIO_PIPEIO) ||
+	    td_ioengine_flagged(td, FIO_NOIO))
 		return 0;
 
 	if (!fio_file_open(f)) {
-- 
2.9.3


