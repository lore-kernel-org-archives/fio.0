Return-Path: <sandeen@redhat.com>
Subject: [PATCH 1/2] fio: move dynamic library handle to io_ops structure
From: Eric Sandeen <sandeen@redhat.com>
References: <6bb40362-44e3-2138-25c5-0f7630179e09@redhat.com>
Message-ID: <34a020e0-5416-718e-023d-59e77a05f999@redhat.com>
Date: Mon, 25 Jan 2021 13:18:31 -0600
MIME-Version: 1.0
In-Reply-To: <6bb40362-44e3-2138-25c5-0f7630179e09@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: fio <fio@vger.kernel.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Yigal Korman <ykorman@gmail.com>, "Richard W.M. Jones" <rjones@redhat.com>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Keeping a dynamic engine's dlopen'd dlhandle on a thread structure doesn't
make sense; that thread may exit while others are still using the engine.

Move the dlhandle onto the ops structure itself.

We still only call dlopen for the first thead, which leaves a refcounting
issue which will be fixed in the next patch.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fio.h b/fio.h
index ee582a72..062abfa7 100644
--- a/fio.h
+++ b/fio.h
@@ -281,7 +281,6 @@ struct thread_data {
 	 * IO engine private data and dlhandle.
 	 */
 	void *io_ops_data;
-	void *io_ops_dlhandle;
 
 	/*
 	 * Queue depth of io_u's that fio MIGHT do
diff --git a/init.c b/init.c
index 1d14df16..ab38b334 100644
--- a/init.c
+++ b/init.c
@@ -1104,18 +1104,18 @@ int ioengine_load(struct thread_data *td)
 		 * for this name and see if they match. If they do, then
 		 * the engine is unchanged.
 		 */
-		dlhandle = td->io_ops_dlhandle;
+		dlhandle = td->io_ops->dlhandle;
 		ops = load_ioengine(td);
 		if (!ops)
 			goto fail;
 
-		if (ops == td->io_ops && dlhandle == td->io_ops_dlhandle) {
+		if (ops == td->io_ops && dlhandle == td->io_ops->dlhandle) {
 			if (dlhandle)
 				dlclose(dlhandle);
 			return 0;
 		}
 
-		if (dlhandle && dlhandle != td->io_ops_dlhandle)
+		if (dlhandle && dlhandle != td->io_ops->dlhandle)
 			dlclose(dlhandle);
 
 		/* Unload the old engine. */
diff --git a/ioengines.c b/ioengines.c
index 5ac512ae..dcc9496d 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -155,7 +155,7 @@ static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 		return NULL;
 	}
 
-	td->io_ops_dlhandle = dlhandle;
+	ops->dlhandle = dlhandle;
 	return ops;
 }
 
@@ -228,9 +228,9 @@ void free_ioengine(struct thread_data *td)
 		td->eo = NULL;
 	}
 
-	if (td->io_ops_dlhandle) {
-		dlclose(td->io_ops_dlhandle);
-		td->io_ops_dlhandle = NULL;
+	if (td->io_ops->dlhandle) {
+		dlclose(td->io_ops->dlhandle);
+		td->io_ops->dlhandle = NULL;
 	}
 
 	td->io_ops = NULL;
diff --git a/ioengines.h b/ioengines.h
index a928b211..839b318d 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -8,7 +8,7 @@
 #include "io_u.h"
 #include "zbd_types.h"
 
-#define FIO_IOOPS_VERSION	27
+#define FIO_IOOPS_VERSION	28
 
 #ifndef CONFIG_DYNAMIC_ENGINES
 #define FIO_STATIC	static
@@ -30,6 +30,7 @@ struct ioengine_ops {
 	const char *name;
 	int version;
 	int flags;
+	void *dlhandle;
 	int (*setup)(struct thread_data *);
 	int (*init)(struct thread_data *);
 	int (*post_init)(struct thread_data *);



