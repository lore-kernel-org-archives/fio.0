Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 09/13] Ignore pre-read for character devices
Date: Tue, 28 Mar 2017 23:02:57 +0300
Message-Id: <20170328200301.8622-9-tkusumi@tuxera.com>
In-Reply-To: <20170328200301.8622-1-tkusumi@tuxera.com>
References: <20170328200301.8622-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

pre_read_file() could ignore a chrdev due to its purpose of providing
unbuffered access to devices not limited to seekable disk devices,
while the purpose of this function (i.e. pre_read= option) is to
lseek(2) the given offset and page cache whatever read via read(2)
which is basically for filesystems and blkdevs.

(This commit directly goes on top of the one before previous one)

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/filesetup.c b/filesetup.c
index cd486ea..612e794 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -239,6 +239,9 @@ static int pre_read_file(struct thread_data *td, struct fio_file *f)
 	    td_ioengine_flagged(td, FIO_NOIO))
 		return 0;
 
+	if (f->filetype == FIO_TYPE_CHAR)
+		return 0;
+
 	if (!fio_file_open(f)) {
 		if (td->io_ops->open_file(td, f)) {
 			log_err("fio: cannot pre-read, failed to open file\n");
-- 
2.9.3


