Return-Path: <sandeen@redhat.com>
Subject: [PATCH 2/2] fio: fix dlopen refcounting of dynamic engines
From: Eric Sandeen <sandeen@redhat.com>
References: <6bb40362-44e3-2138-25c5-0f7630179e09@redhat.com>
Message-ID: <8283a6be-89d5-fdd8-e2c2-bf591390f82e@redhat.com>
Date: Mon, 25 Jan 2021 13:23:48 -0600
MIME-Version: 1.0
In-Reply-To: <6bb40362-44e3-2138-25c5-0f7630179e09@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: fio <fio@vger.kernel.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Yigal Korman <ykorman@gmail.com>, "Richard W.M. Jones" <rjones@redhat.com>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

ioengine_load() will dlclose the dynamic library if it matches one
that we've already got open, but this defeats the built-in refcounting
done by dlopen/dlclose.  As each thread exits, it calls free_ioengine(),
and this may do a final dlclose on a dynamic ioengine that is still
in use if we don't have the proper reference count.

Fix this by dropping the explicit dlclose of a "matching" dlopened
dynamic engine library, and let each dlclose decrement the refcount
on the engine library as is normal.

This also adds/modifies a couple of debug messages to help track this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(maybe we should add FD_DYNAMIC instead of FD_IO for this?)

diff --git a/init.c b/init.c
index ab38b334..d6dbaf7c 100644
--- a/init.c
+++ b/init.c
@@ -1109,11 +1109,8 @@ int ioengine_load(struct thread_data *td)
 		if (!ops)
 			goto fail;
 
-		if (ops == td->io_ops && dlhandle == td->io_ops->dlhandle) {
-			if (dlhandle)
-				dlclose(dlhandle);
+		if (ops == td->io_ops && dlhandle == td->io_ops->dlhandle)
 			return 0;
-		}
 
 		if (dlhandle && dlhandle != td->io_ops->dlhandle)
 			dlclose(dlhandle);
diff --git a/ioengines.c b/ioengines.c
index dcc9496d..f88b0537 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -95,6 +95,7 @@ static void *dlopen_external(struct thread_data *td, const char *engine)
 
 	sprintf(engine_path, "%s/fio-%s.so", FIO_EXT_ENG_DIR, engine);
 
+	dprint(FD_IO, "dlopen external %s\n", engine_path);
 	dlhandle = dlopen(engine_path, RTLD_LAZY);
 	if (!dlhandle)
 		log_info("Engine %s not found; Either name is invalid, was not built, or fio-engine-%s package is missing.\n",
@@ -116,7 +117,7 @@ static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 	    !strncmp(engine_lib, "aio", 3))
 		engine_lib = "libaio";
 
-	dprint(FD_IO, "dload engine %s\n", engine_lib);
+	dprint(FD_IO, "dlopen engine %s\n", engine_lib);
 
 	dlerror();
 	dlhandle = dlopen(engine_lib, RTLD_LAZY);
@@ -194,7 +195,9 @@ struct ioengine_ops *load_ioengine(struct thread_data *td)
 	 * so as not to break job files not using the prefix.
 	 */
 	ops = __load_ioengine(td->o.ioengine);
-	if (!ops)
+
+	/* We do re-dlopen existing handles, for reference counting */
+	if (!ops || ops->dlhandle)
 		ops = dlopen_ioengine(td, name);
 
 	/*
@@ -229,6 +232,7 @@ void free_ioengine(struct thread_data *td)
 	}
 
 	if (td->io_ops->dlhandle) {
+		dprint(FD_IO, "dlclose ioengine %s\n", td->io_ops->name);
 		dlclose(td->io_ops->dlhandle);
 		td->io_ops->dlhandle = NULL;
 	}



