Return-Path: <fio-owner@vger.kernel.org>
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39791 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728290AbgKFUHg (ORCPT
        <rfc822;fio@vger.kernel.org>); Fri, 6 Nov 2020 15:07:36 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] fix dynamic engine loading for libaio engine etc
Message-ID: <e2dfbe94-1c52-1127-185e-e68d38fb3ca6@redhat.com>
Date: Fri, 6 Nov 2020 14:07:30 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>
Cc: Yigal Korman <ykorman@gmail.com>

The dynamic engine loading for libaio (and some others) currently
fails because the dlopen routine is looking for ("lib%s", enginename)
which translates into "liblibiscsi.so":

openat(AT_FDCWD, "/usr/lib64/fio/liblibiscsi.so", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
Engine libiscsi not found; Either name is invalid, was not built, or fio-engine-libiscsi package is missing.
fio: engine libiscsi not loadable
IO engine libiscsi not found

The Makefile decide to name this engine "iscsi" instead of "libiscsi",
which leads to "libiscsi.so" not "liblibiscsi.so" hence the mismatch.

OTOH, "liblibiscsi.so" seems a bit bonkers.

Try to resolve all this by:

1) make all of the engine names match the documented engine names
   in the Makefile, i.e. "iscsi" -> "libiscsi"
2) change the created library filenames to "fio-$(ENGINENAME)"
   from "lib$(ENGINENAME)" to avoid the "liblib" prefix.

So now we consistently have the libraries named "fio-$(ENGINENAME).so"

fio-http.so
fio-libaio.so

etc.

Fixes: 5a8a6a03 ("configure: new --dynamic-libengines build option")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

This depends on the previous patch to fix the dynamic
engine library build process.

I could split this into 2 patches if desired, but it's really just
the last 2 hunks that implement 2) above

diff --git a/Makefile b/Makefile
index b0b9f864..ac3a590c 100644
--- a/Makefile
+++ b/Makefile
@@ -66,10 +66,10 @@ ifdef CONFIG_LIBHDFS
 endif
 
 ifdef CONFIG_LIBISCSI
-  iscsi_SRCS = engines/libiscsi.c
-  iscsi_LIBS = $(LIBISCSI_LIBS)
-  iscsi_CFLAGS = $(LIBISCSI_CFLAGS)
-  ENGINES += iscsi
+  libiscsi_SRCS = engines/libiscsi.c
+  libiscsi_LIBS = $(LIBISCSI_LIBS)
+  libiscsi_CFLAGS = $(LIBISCSI_CFLAGS)
+  ENGINES += libiscsi
 endif
 
 ifdef CONFIG_LIBNBD
@@ -85,14 +85,14 @@ else ifdef CONFIG_32BIT
   CPPFLAGS += -DBITS_PER_LONG=32
 endif
 ifdef CONFIG_LIBAIO
-  aio_SRCS = engines/libaio.c
-  aio_LIBS = -laio
+  libaio_SRCS = engines/libaio.c
+  libaio_LIBS = -laio
   ifdef CONFIG_LIBAIO_URING
-    aio_LIBS = -luring
+    libaio_LIBS = -luring
   else
-    aio_LIBS = -laio
+    libaio_LIBS = -laio
   endif
-  ENGINES += aio
+  ENGINES += libaio
 endif
 ifdef CONFIG_RDMA
   rdma_SRCS = engines/rdma.c
@@ -179,17 +179,17 @@ ifdef CONFIG_LINUX_DEVDAX
   ENGINES += dev-dax
 endif
 ifdef CONFIG_LIBPMEM
-  pmem_SRCS = engines/libpmem.c
-  pmem_LIBS = -lpmem
-  ENGINES += pmem
+  libpmem_SRCS = engines/libpmem.c
+  libpmem_LIBS = -lpmem
+  ENGINES += libpmem
 endif
 ifdef CONFIG_IME
   SOURCE += engines/ime.c
 endif
 ifdef CONFIG_LIBZBC
-  zbc_SRCS = engines/libzbc.c
-  zbc_LIBS = -lzbc
-  ENGINES += zbc
+  libzbc_SRCS = engines/libzbc.c
+  libzbc_LIBS = -lzbc
+  ENGINES += libzbc
 endif
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
@@ -256,9 +256,9 @@ ifdef CONFIG_DYNAMIC_ENGINES
 define engine_template =
 $(1)_OBJS := $$($(1)_SRCS:.c=.o)
 $$($(1)_OBJS): CFLAGS := -fPIC $$($(1)_CFLAGS) $(CFLAGS)
-engines/lib$(1).so: $$($(1)_OBJS)
+engines/fio-$(1).so: $$($(1)_OBJS)
 	$$(QUIET_LINK)$(CC) -shared -rdynamic -fPIC -Wl,-soname,fio-$(1).so.1 $$($(1)_LIBS) -o $$@ $$<
-ENGS_OBJS += engines/lib$(1).so
+ENGS_OBJS += engines/fio-$(1).so
 endef
 else # !CONFIG_DYNAMIC_ENGINES
 define engine_template =
diff --git a/ioengines.c b/ioengines.c
index 3e43ef2f..fb59349a 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -91,7 +91,7 @@ static void *dlopen_external(struct thread_data *td, const char *engine)
 	char engine_path[PATH_MAX];
 	void *dlhandle;
 
-	sprintf(engine_path, "%s/lib%s.so", FIO_EXT_ENG_DIR, engine);
+	sprintf(engine_path, "%s/fio-%s.so", FIO_EXT_ENG_DIR, engine);
 
 	dlhandle = dlopen(engine_path, RTLD_LAZY);
 	if (!dlhandle)


