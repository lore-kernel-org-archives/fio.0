Return-Path: <ykorman@gmail.com>
Return-Path: <ykorman@gmail.com>
From: Yigal Korman <ykorman@gmail.com>
Subject: [PATCH v2 1/4] fio: don't retry engine search on failure
Date: Fri,  3 Jul 2020 15:38:40 +0300
Message-Id: <e2ad15c3cde2bea866594b790b653d7ededd95c8.1593761533.git.ykorman@gmail.com>
In-Reply-To: <cover.1593761533.git.ykorman@gmail.com>
References: <cover.1593761533.git.ykorman@gmail.com>
In-Reply-To: <cover.1593761533.git.ykorman@gmail.com>
References: <cover.1593761533.git.ykorman@gmail.com>
To: axboe@kernel.dk
Cc: Yigal Korman <ykorman@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

ioengine_load will try to load a given engine and if it doesn't match
the current one (default is always psync), it will remove the current
one and try again.
This makes sense when the engine is loaded successfully, but if it's
not, we try to load it twice for no reason.

Fix by failing if we were unable to load requested engine and not
retrying.

Signed-off-by: Yigal Korman <ykorman@gmail.com>
---
 init.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/init.c b/init.c
index e53be35a..3710e3d4 100644
--- a/init.c
+++ b/init.c
@@ -1099,6 +1099,9 @@ int ioengine_load(struct thread_data *td)
 		 */
 		dlhandle = td->io_ops_dlhandle;
 		ops = load_ioengine(td);
+		if (!ops)
+			goto fail;
+
 		if (ops == td->io_ops && dlhandle == td->io_ops_dlhandle) {
 			if (dlhandle)
 				dlclose(dlhandle);
@@ -1113,10 +1116,8 @@ int ioengine_load(struct thread_data *td)
 	}
 
 	td->io_ops = load_ioengine(td);
-	if (!td->io_ops) {
-		log_err("fio: failed to load engine\n");
-		return 1;
-	}
+	if (!td->io_ops)
+		goto fail;
 
 	if (td->io_ops->option_struct_size && td->io_ops->options) {
 		/*
@@ -1155,6 +1156,11 @@ int ioengine_load(struct thread_data *td)
 
 	td_set_ioengine_flags(td);
 	return 0;
+
+fail:
+	log_err("fio: failed to load engine\n");
+	return 1;
+
 }
 
 static void init_flags(struct thread_data *td)
-- 
2.17.1


