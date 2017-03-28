Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 04/13] Don't malloc more than necessary on extending/prereading file
Date: Tue, 28 Mar 2017 23:02:52 +0300
Message-Id: <20170328200301.8622-4-tkusumi@tuxera.com>
In-Reply-To: <20170328200301.8622-1-tkusumi@tuxera.com>
References: <20170328200301.8622-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

If td->o.max_bs[DDIR_XXX] were larger than file size to extend/preread,
it only needs to malloc the file size.

Given that td->o.max_bs[DDIR_XXX] are tunable parameters, it's better
not to malloc whatever size specified if needed size is smaller than
that. Users could specify as large as maximum of uint.

I dropped "bs = td->o.max_bs[DDIR_WRITE];" inside the first while loop
since now it works the same with or without this.

(This commit directly goes on top of the previous one)

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index ce19cf0..9335dcd 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -159,15 +159,18 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 		}
 	}
 
-	b = malloc(td->o.max_bs[DDIR_WRITE]);
+	left = f->real_file_size;
+	bs = td->o.max_bs[DDIR_WRITE];
+	if (bs > left)
+		bs = left;
+
+	b = malloc(bs);
 	if (!b) {
 		td_verror(td, errno, "malloc");
 		goto err;
 	}
 
-	left = f->real_file_size;
 	while (left && !td->terminate) {
-		bs = td->o.max_bs[DDIR_WRITE];
 		if (bs > left)
 			bs = left;
 
@@ -245,7 +248,11 @@ static int pre_read_file(struct thread_data *td, struct fio_file *f)
 
 	old_runstate = td_bump_runstate(td, TD_PRE_READING);
 
+	left = f->io_size;
 	bs = td->o.max_bs[DDIR_READ];
+	if (bs > left)
+		bs = left;
+
 	b = malloc(bs);
 	if (!b) {
 		td_verror(td, errno, "malloc");
@@ -261,8 +268,6 @@ static int pre_read_file(struct thread_data *td, struct fio_file *f)
 		goto error;
 	}
 
-	left = f->io_size;
-
 	while (left && !td->terminate) {
 		if (bs > left)
 			bs = left;
-- 
2.9.3


