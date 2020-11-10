Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730542AbgKJNAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 10 Nov 2020 08:00:07 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E912C0613D1
        for <fio@vger.kernel.org>; Tue, 10 Nov 2020 05:00:06 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kcTFk-0001fv-2W
        for fio@vger.kernel.org; Tue, 10 Nov 2020 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201110130001.C50611BC0163@kernel.dk>
Date: Tue, 10 Nov 2020 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ea693b6e4501a1385bf62a01f6fb1f3609d31a4a:

  Revert "Windows: update dobuild.cmd to run the configure/make" (2020-11-05 15:33:00 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e82ec77644f4fb7eccb3441485762c1c1c574b2f:

  t/latency_percentiles.py: correct terse parse (2020-11-09 12:13:25 -0700)

----------------------------------------------------------------
Eric Sandeen (3):
      fix dynamic engine build
      fix dynamic engine loading for libaio engine etc
      list all available dynamic ioengines with --enghelp

Jens Axboe (6):
      FIO_EXT_ENG_DIR should be default path
      Remove the "libaio over io_uring" mode
      Makefile: ensure that external libs are linked properly with dynamic engine
      configure: remove libaio-uring remnant
      Make sure we do libaio engine compatability names
      t/latency_percentiles.py: correct terse parse

 Makefile                 | 46 +++++++++++++++++++---------------------------
 configure                | 19 +------------------
 ioengines.c              | 42 +++++++++++++++++++++++++++++++++++++++---
 os/os-linux.h            |  2 +-
 t/latency_percentiles.py |  2 +-
 5 files changed, 61 insertions(+), 50 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 8c8a8fce..0d3c877e 100644
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
@@ -85,14 +85,9 @@ else ifdef CONFIG_32BIT
   CPPFLAGS += -DBITS_PER_LONG=32
 endif
 ifdef CONFIG_LIBAIO
-  aio_SRCS = engines/libaio.c
-  aio_LIBS = -laio
-  ifdef CONFIG_LIBAIO_URING
-    aio_LIBS = -luring
-  else
-    aio_LIBS = -laio
-  endif
-  ENGINES += aio
+  libaio_SRCS = engines/libaio.c
+  libaio_LIBS = -laio
+  ENGINES += libaio
 endif
 ifdef CONFIG_RDMA
   rdma_SRCS = engines/rdma.c
@@ -179,17 +174,17 @@ ifdef CONFIG_LINUX_DEVDAX
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
@@ -255,8 +250,10 @@ ifdef CONFIG_DYNAMIC_ENGINES
  DYNAMIC_ENGS := $(ENGINES)
 define engine_template =
 $(1)_OBJS := $$($(1)_SRCS:.c=.o)
-$$($(1)_OBJS): FIO_CFLAGS += -fPIC $$($(1)_CFLAGS)
-ENGS_OBJS += engines/lib$(1).so
+$$($(1)_OBJS): CFLAGS := -fPIC $$($(1)_CFLAGS) $(CFLAGS)
+engines/fio-$(1).so: $$($(1)_OBJS)
+	$$(QUIET_LINK)$(CC) -shared -rdynamic -fPIC -Wl,-soname,fio-$(1).so.1 -o $$@ $$< $$($(1)_LIBS)
+ENGS_OBJS += engines/fio-$(1).so
 endef
 else # !CONFIG_DYNAMIC_ENGINES
 define engine_template =
@@ -266,6 +263,8 @@ CFLAGS += $$($(1)_CFLAGS)
 endef
 endif
 
+override CFLAGS := -DFIO_VERSION='"$(FIO_VERSION)"' $(FIO_CFLAGS) $(CFLAGS)
+
 $(foreach eng,$(ENGINES),$(eval $(call engine_template,$(eng))))
 
 OBJS := $(SOURCE:.c=.o)
@@ -438,8 +437,6 @@ FIO-VERSION-FILE: FORCE
 	@$(SHELL) $(SRCDIR)/FIO-VERSION-GEN
 -include FIO-VERSION-FILE
 
-override CFLAGS := -DFIO_VERSION='"$(FIO_VERSION)"' $(FIO_CFLAGS) $(CFLAGS)
-
 %.o : %.c
 	@mkdir -p $(dir $@)
 	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
@@ -567,11 +564,6 @@ unittests/unittest: $(UT_OBJS) $(UT_TARGET_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(UT_OBJS) $(UT_TARGET_OBJS) -lcunit $(LIBS)
 endif
 
-ifdef CONFIG_DYNAMIC_ENGINES
-engines/lib$(1).so: $$($(1)_OBJS)
-	$$(QUIET_LINK)$(CC) -shared -rdynamic -fPIC -Wl,-soname,fio-$(1).so.1 $$($(1)_LIBS) -o $$@ $$<
-endif
-
 clean: FORCE
 	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(UT_OBJS) $(PROGS) $(T_PROGS) $(T_TEST_PROGS) core.* core gfio unittests/unittest FIO-VERSION-FILE *.[do] lib/*.d oslib/*.[do] crc/*.d engines/*.[do] engines/*.so profiles/*.[do] t/*.[do] unittests/*.[do] unittests/*/*.[do] config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do] lexer.h
 	@rm -f t/fio-btrace2fio t/io_uring t/read-to-pipe-async
diff --git a/configure b/configure
index 39a9248d..d2ca8934 100755
--- a/configure
+++ b/configure
@@ -168,7 +168,6 @@ disable_native="no"
 march_set="no"
 libiscsi="no"
 libnbd="no"
-libaio_uring="no"
 libzbc=""
 dynamic_engines="no"
 prefix=/usr/local
@@ -237,8 +236,6 @@ for opt do
   ;;
   --disable-tcmalloc) disable_tcmalloc="yes"
   ;;
-  --enable-libaio-uring) libaio_uring="yes"
-  ;;
   --dynamic-libengines) dynamic_engines="yes"
   ;;
   --help)
@@ -281,7 +278,6 @@ if test "$show_help" = "yes" ; then
   echo "--enable-libnbd         Enable libnbd (NBD engine) support"
   echo "--disable-libzbc        Disable libzbc even if found"
   echo "--disable-tcmalloc	Disable tcmalloc support"
-  echo "--enable-libaio-uring   Enable libaio emulated over io_uring"
   echo "--dynamic-libengines	Lib-based ioengines as dynamic libraries"
   exit $exit_val
 fi
@@ -653,22 +649,13 @@ int main(void)
   return 0;
 }
 EOF
-  if test "$libaio_uring" = "yes"; then
-    if compile_prog "" "-luring" "libaio io_uring" ; then
-      libaio=yes
-      LIBS="-luring $LIBS"
-    else
-      feature_not_found "libaio io_uring" ""
-    fi
-  elif compile_prog "" "-laio" "libaio" ; then
+  if compile_prog "" "-laio" "libaio" ; then
     libaio=yes
-    libaio_uring=no
   else
     if test "$libaio" = "yes" ; then
       feature_not_found "linux AIO" "libaio-dev or libaio-devel"
     fi
     libaio=no
-    libaio_uring=no
   fi
 
   cat > $TMPC <<EOF
@@ -689,7 +676,6 @@ EOF
 fi
 print_config "Linux AIO support" "$libaio"
 print_config "Linux AIO support rw flags" "$libaio_rw_flags"
-print_config "Linux AIO over io_uring" "$libaio_uring"
 
 ##########################################
 # posix aio probe
@@ -2722,9 +2708,6 @@ if test "$libaio" = "yes" ; then
   if test "$libaio_rw_flags" = "yes" ; then
     output_sym "CONFIG_LIBAIO_RW_FLAGS"
   fi
-  if test "$libaio_uring" = "yes" ; then
-    output_sym "CONFIG_LIBAIO_URING"
-  fi
 fi
 if test "$posix_aio" = "yes" ; then
   output_sym "CONFIG_POSIXAIO"
diff --git a/ioengines.c b/ioengines.c
index 3e43ef2f..5ac512ae 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -15,6 +15,8 @@
 #include <dlfcn.h>
 #include <fcntl.h>
 #include <assert.h>
+#include <sys/types.h>
+#include <dirent.h>
 
 #include "fio.h"
 #include "diskutil.h"
@@ -91,7 +93,7 @@ static void *dlopen_external(struct thread_data *td, const char *engine)
 	char engine_path[PATH_MAX];
 	void *dlhandle;
 
-	sprintf(engine_path, "%s/lib%s.so", FIO_EXT_ENG_DIR, engine);
+	sprintf(engine_path, "%s/fio-%s.so", FIO_EXT_ENG_DIR, engine);
 
 	dlhandle = dlopen(engine_path, RTLD_LAZY);
 	if (!dlhandle)
@@ -110,6 +112,10 @@ static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 	struct ioengine_ops *ops;
 	void *dlhandle;
 
+	if (!strncmp(engine_lib, "linuxaio", 8) ||
+	    !strncmp(engine_lib, "aio", 3))
+		engine_lib = "libaio";
+
 	dprint(FD_IO, "dload engine %s\n", engine_lib);
 
 	dlerror();
@@ -158,7 +164,7 @@ static struct ioengine_ops *__load_ioengine(const char *engine)
 	/*
 	 * linux libaio has alias names, so convert to what we want
 	 */
-	if (!strncmp(engine, "linuxaio", 8)) {
+	if (!strncmp(engine, "linuxaio", 8) || !strncmp(engine, "aio", 3)) {
 		dprint(FD_IO, "converting ioengine name: %s -> libaio\n",
 		       engine);
 		engine = "libaio";
@@ -630,6 +636,34 @@ int td_io_get_file_size(struct thread_data *td, struct fio_file *f)
 	return td->io_ops->get_file_size(td, f);
 }
 
+#ifdef CONFIG_DYNAMIC_ENGINES
+/* Load all dynamic engines in FIO_EXT_ENG_DIR for enghelp command */
+static void
+fio_load_dynamic_engines(struct thread_data *td)
+{
+	DIR *dirhandle = NULL;
+	struct dirent *dirent = NULL;
+	char engine_path[PATH_MAX];
+
+	dirhandle = opendir(FIO_EXT_ENG_DIR);
+	if (!dirhandle)
+		return;
+
+	while ((dirent = readdir(dirhandle)) != NULL) {
+		if (!strcmp(dirent->d_name, ".") ||
+		    !strcmp(dirent->d_name, ".."))
+			continue;
+
+		sprintf(engine_path, "%s/%s", FIO_EXT_ENG_DIR, dirent->d_name);
+		dlopen_ioengine(td, engine_path);
+	}
+
+	closedir(dirhandle);
+}
+#else
+#define fio_load_dynamic_engines(td) do { } while (0)
+#endif
+
 int fio_show_ioengine_help(const char *engine)
 {
 	struct flist_head *entry;
@@ -638,8 +672,11 @@ int fio_show_ioengine_help(const char *engine)
 	char *sep;
 	int ret = 1;
 
+	memset(&td, 0, sizeof(struct thread_data));
+
 	if (!engine || !*engine) {
 		log_info("Available IO engines:\n");
+		fio_load_dynamic_engines(&td);
 		flist_for_each(entry, &engine_list) {
 			io_ops = flist_entry(entry, struct ioengine_ops, list);
 			log_info("\t%s\n", io_ops->name);
@@ -652,7 +689,6 @@ int fio_show_ioengine_help(const char *engine)
 		sep++;
 	}
 
-	memset(&td, 0, sizeof(struct thread_data));
 	td.o.ioengine = (char *)engine;
 	io_ops = load_ioengine(&td);
 
diff --git a/os/os-linux.h b/os/os-linux.h
index 65d3b429..5562b0da 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -58,7 +58,7 @@
 
 #define OS_MAP_ANON		MAP_ANONYMOUS
 
-#define FIO_EXT_ENG_DIR	"/usr/lib/fio"
+#define FIO_EXT_ENG_DIR	"/usr/local/lib/fio"
 
 typedef cpu_set_t os_cpu_mask_t;
 
diff --git a/t/latency_percentiles.py b/t/latency_percentiles.py
index 6ce4579a..a9aee019 100755
--- a/t/latency_percentiles.py
+++ b/t/latency_percentiles.py
@@ -224,7 +224,7 @@ class FioLatTest():
         lines = file_data.splitlines()
         for i in range(8):
             file_data = lines[i]
-            if file_data.startswith('3;fio-'):
+            if file_data.startswith('3;;latency'):
                 self.terse_data = file_data.split(';')
                 return True
 

