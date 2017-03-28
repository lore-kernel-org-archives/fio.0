Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 03/13] Test malloc result when allocation size is tunable
Date: Tue, 28 Mar 2017 23:02:51 +0300
Message-Id: <20170328200301.8622-3-tkusumi@tuxera.com>
In-Reply-To: <20170328200301.8622-1-tkusumi@tuxera.com>
References: <20170328200301.8622-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

The allocation size td->o.max_bs[DDIR_XXX] can be specified by user,
so test the result although it can be over committed on some platforms.
In theory allocation size could be as large as maximum of uint.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/filesetup.c b/filesetup.c
index bcf95bd..ce19cf0 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -160,6 +160,10 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 	}
 
 	b = malloc(td->o.max_bs[DDIR_WRITE]);
+	if (!b) {
+		td_verror(td, errno, "malloc");
+		goto err;
+	}
 
 	left = f->real_file_size;
 	while (left && !td->terminate) {
@@ -243,6 +247,11 @@ static int pre_read_file(struct thread_data *td, struct fio_file *f)
 
 	bs = td->o.max_bs[DDIR_READ];
 	b = malloc(bs);
+	if (!b) {
+		td_verror(td, errno, "malloc");
+		ret = 1;
+		goto error;
+	}
 	memset(b, 0, bs);
 
 	if (lseek(f->fd, f->file_offset, SEEK_SET) < 0) {
-- 
2.9.3


