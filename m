Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 7/7] Add missing .help string for io_size option
Date: Tue,  3 Jan 2017 23:40:11 +0900
Message-Id: <1483454411-14535-7-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1483454411-14535-1-git-send-email-tkusumi@tuxera.com>
References: <1483454411-14535-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

fio --cmdhelp currently prints "(null)" for io_size.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 options.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/options.c b/options.c
index 0f2adcd..1ca16e8 100644
--- a/options.c
+++ b/options.c
@@ -1883,6 +1883,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "IO Size",
 		.type	= FIO_OPT_STR_VAL,
 		.off1	= offsetof(struct thread_options, io_limit),
+		.help	= "Total size of I/O to be performed",
 		.interval = 1024 * 1024,
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
-- 
2.5.5


