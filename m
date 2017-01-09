Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 5/6] Mention sg ioengine requires filename option
Date: Mon,  9 Jan 2017 23:42:02 +0900
Message-Id: <1483972923-13662-5-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1483972923-13662-1-git-send-email-tkusumi@tuxera.com>
References: <1483972923-13662-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

similar to the way net ioengine documents filename option.

Also bring in a file type check from fio_sgio_type_check()
to avoid pointless read capacity error against regfiles.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO        | 3 ++-
 engines/sg.c | 8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/HOWTO b/HOWTO
index 4cc733f..33f8718 100644
--- a/HOWTO
+++ b/HOWTO
@@ -819,7 +819,8 @@ ioengine=str	Defines how the job issues io to the file. The following
 				synchronous using the SG_IO ioctl, or if
 				the target is an sg character device
 				we use read(2) and write(2) for asynchronous
-				io.
+				io. Requires filename option to specify either
+				block or character devices.
 
 			null	Doesn't transfer any data, just pretends
 				to. This is mainly used to exercise fio
diff --git a/engines/sg.c b/engines/sg.c
index e70803c..3f7d911 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -525,7 +525,7 @@ static int fio_sgio_type_check(struct thread_data *td, struct fio_file *f)
 		}
 	} else {
 		td_verror(td, EINVAL, "wrong file type");
-		log_err("ioengine sg only works on block devices\n");
+		log_err("ioengine sg only works on block or character devices\n");
 		return 1;
 	}
 
@@ -789,6 +789,12 @@ static int fio_sgio_get_file_size(struct thread_data *td, struct fio_file *f)
 	if (fio_file_size_known(f))
 		return 0;
 
+	if (f->filetype != FIO_TYPE_BD && f->filetype != FIO_TYPE_CHAR) {
+		td_verror(td, EINVAL, "wrong file type");
+		log_err("ioengine sg only works on block or character devices\n");
+		return 1;
+	}
+
 	ret = fio_sgio_read_capacity(td, &bs, &max_lba);
 	if (ret ) {
 		td_verror(td, td->error, "fio_sgio_read_capacity");
-- 
2.5.5


