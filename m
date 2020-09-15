Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgIOMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 Sep 2020 08:00:08 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D10C061797
        for <fio@vger.kernel.org>; Tue, 15 Sep 2020 05:00:06 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kI9cx-0004fc-N8
        for fio@vger.kernel.org; Tue, 15 Sep 2020 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200915120002.4AA291BC0118@kernel.dk>
Date: Tue, 15 Sep 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 695611a9d4cd554d44d8b2ec5da2811061950a2e:

  Allow offload with FAKEIO engines (2020-09-11 09:58:15 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7064f8942a3b8070acf60b8e5fabc16f8221ae40:

  Merge branch 'msys2' of https://github.com/sitsofe/fio into master (2020-09-14 19:43:39 -0600)

----------------------------------------------------------------
Bart Van Assche (2):
      backend: Remove two superfluous casts
      backend: Use asprintf() instead of strlen() + sprintf()

Jens Axboe (2):
      Merge branch 'backend' of https://github.com/bvanassche/fio into master
      Merge branch 'msys2' of https://github.com/sitsofe/fio into master

Sitsofe Wheeler (12):
      configure: pass non-null pointer to (v)asprintf
      net: coerce the result of htonl before printing
      windows: fix wrong format strings
      windows: fix DWORD format string complaints
      configure: be explicit about "XP" Windows API version
      configure/Makefile: add option to generate pdb symbols
      Makefile/ci: Don't pass CFLAGS when linking
      appveyor: cleanup and add separate install script
      Makefile: introduce FIO_CFLAGS
      memlock: avoid type confusion in format string
      configure: cleanup lex/yacc tests
      travis: cleanup build script

 .appveyor.yml             | 40 ++++++++++++++++--------
 Makefile                  | 77 ++++++++++++++++++++++++++---------------------
 backend.c                 | 15 ++++-----
 ci/appveyor-install.sh    | 41 +++++++++++++++++++++++++
 ci/travis-build.sh        |  8 +++--
 ci/travis-install.sh      |  5 ++-
 configure                 | 60 ++++++++++++++++++++++++++----------
 engines/net.c             |  5 +--
 engines/windowsaio.c      |  8 ++---
 os/windows/cpu-affinity.c | 26 ++++++++--------
 os/windows/dobuild.cmd    | 10 ++++--
 os/windows/install.wxs    |  8 +++++
 os/windows/posix.c        |  5 +--
 t/memlock.c               |  2 +-
 14 files changed, 211 insertions(+), 99 deletions(-)
 create mode 100755 ci/appveyor-install.sh

---

Diff of recent changes:

diff --git a/.appveyor.yml b/.appveyor.yml
index 352caeee..fad16326 100644
--- a/.appveyor.yml
+++ b/.appveyor.yml
@@ -5,33 +5,49 @@ image:
 
 environment:
   CYG_MIRROR: http://cygwin.mirror.constant.com
-  CYG_ROOT: C:\cygwin64
-  MAKEFLAGS: -j 2
   matrix:
-    - platform: x64
-      PACKAGE_ARCH: x86_64
+    - ARCHITECTURE: x64
+      CC: clang
+      CONFIGURE_OPTIONS: --enable-pdb
+      DISTRO: msys2
+# Skip 32 bit clang build
+#    - ARCHITECTURE: x86
+#      CC: clang
+#      CONFIGURE_OPTIONS: --enable-pdb
+#      DISTRO: msys2
+    - ARCHITECTURE: x64
       CONFIGURE_OPTIONS:
-    - platform: x86
-      PACKAGE_ARCH: i686
+      DISTRO: cygwin
+    - ARCHITECTURE: x86
       CONFIGURE_OPTIONS: --build-32bit-win --target-win-ver=xp
+      DISTRO: cygwin
 
 install:
-  - '%CYG_ROOT%\setup-x86_64.exe --quiet-mode --no-shortcuts --only-site --site "%CYG_MIRROR%" --packages "mingw64-%PACKAGE_ARCH%-zlib,mingw64-%PACKAGE_ARCH%-CUnit" > NUL'
-  - SET PATH=C:\Python38-x64;%CYG_ROOT%\bin;%PATH% # NB: Changed env variables persist to later sections
+  - if %DISTRO%==cygwin (
+      SET "PATH=C:\cygwin64\bin;C:\cygwin64;%PATH%"
+    )
+  - if %DISTRO%==msys2 if %ARCHITECTURE%==x86 (
+      SET "PATH=C:\msys64\mingw32\bin;C:\msys64\usr\bin;%PATH%"
+    )
+  - if %DISTRO%==msys2 if %ARCHITECTURE%==x64 (
+      SET "PATH=C:\msys64\mingw64\bin;C:\msys64\usr\bin;%PATH%"
+    )
+  - SET PATH=C:\Python38-x64;%PATH% # NB: Changed env variables persist to later sections
   - SET PYTHONUNBUFFERED=TRUE
-  - python.exe -m pip install scipy six
+  - bash.exe ci\appveyor-install.sh
 
 build_script:
-  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && ./configure --disable-native --extra-cflags=\"-Werror\" ${CONFIGURE_OPTIONS} && make.exe'
+  - bash.exe configure --extra-cflags=-Werror --disable-native %CONFIGURE_OPTIONS%
+  - make.exe -j2
 
 after_build:
   - file.exe fio.exe
   - make.exe test
-  - 'cd os\windows && dobuild.cmd %PLATFORM% && cd ..'
+  - 'cd os\windows && dobuild.cmd %ARCHITECTURE% && cd ..'
   - ps: Get-ChildItem .\os\windows\*.msi | % { Push-AppveyorArtifact $_.FullName -FileName $_.Name -DeploymentName fio.msi }
 
 test_script:
-  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && [ -f fio.exe ] && python.exe t/run-fio-tests.py --artifact-root test-artifacts --debug'
+  - python.exe t/run-fio-tests.py --artifact-root test-artifacts --debug
 
 on_finish:
   - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && [ -d test-artifacts ] && 7z a -t7z test-artifacts.7z test-artifacts -xr!foo.0.0 -xr!latency.?.0 -xr!fio_jsonplus_clat2csv.test && appveyor PushArtifact test-artifacts.7z'
diff --git a/Makefile b/Makefile
index b00daca2..5ed8a808 100644
--- a/Makefile
+++ b/Makefile
@@ -22,16 +22,22 @@ endif
 DEBUGFLAGS = -DFIO_INC_DEBUG
 CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFIO_INTERNAL $(DEBUGFLAGS)
 OPTFLAGS= -g -ffast-math
-CFLAGS	:= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR) $(CFLAGS)
+FIO_CFLAGS= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR)
 LIBS	+= -lm $(EXTLIBS)
 PROGS	= fio
 SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio tools/fiologparser.py tools/hist/fiologparser_hist.py tools/hist/fio-histo-log-pctiles.py tools/fio_jsonplus_clat2csv)
 
 ifndef CONFIG_FIO_NO_OPT
-  CFLAGS := -O3 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 $(CFLAGS)
+  FIO_CFLAGS += -O3 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
 endif
 ifdef CONFIG_BUILD_NATIVE
-  CFLAGS := -march=native $(CFLAGS)
+  FIO_CFLAGS += -march=native
+endif
+
+ifdef CONFIG_PDB
+  LINK_PDBFILE ?= -Wl,-pdb,$(dir $@)/$(basename $(@F)).pdb
+  FIO_CFLAGS += -gcodeview
+  LDFLAGS += -fuse-ld=lld $(LINK_PDBFILE)
 endif
 
 ifdef CONFIG_GFIO
@@ -55,7 +61,7 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
   HDFSLIB= -Wl,-rpath $(JAVA_HOME)/jre/lib/$(FIO_HDFS_CPU)/server -L$(JAVA_HOME)/jre/lib/$(FIO_HDFS_CPU)/server $(FIO_LIBHDFS_LIB)/libhdfs.a -ljvm
-  CFLAGS := $(HDFSFLAGS) $(CFLAGS)
+  FIO_CFLAGS += $(HDFSFLAGS)
   SOURCE += engines/libhdfs.c
 endif
 
@@ -74,10 +80,9 @@ ifdef CONFIG_LIBNBD
 endif
 
 ifdef CONFIG_64BIT
-  CFLAGS := -DBITS_PER_LONG=64 $(CFLAGS)
-endif
-ifdef CONFIG_32BIT
-  CFLAGS := -DBITS_PER_LONG=32 $(CFLAGS)
+  CPPFLAGS += -DBITS_PER_LONG=64
+else ifdef CONFIG_32BIT
+  CPPFLAGS += -DBITS_PER_LONG=32
 endif
 ifdef CONFIG_LIBAIO
   aio_SRCS = engines/libaio.c
@@ -155,7 +160,7 @@ ifdef CONFIG_GFAPI
   SOURCE += engines/glusterfs_async.c
   LIBS += -lgfapi -lglusterfs
   ifdef CONFIG_GF_FADVISE
-    CFLAGS := "-DGFAPI_USE_FADVISE" $(CFLAGS)
+    FIO_CFLAGS += "-DGFAPI_USE_FADVISE"
   endif
 endif
 ifdef CONFIG_MTD
@@ -234,7 +239,7 @@ ifeq ($(CONFIG_TARGET_OS), AIX)
 endif
 ifeq ($(CONFIG_TARGET_OS), HP-UX)
   LIBS   += -lpthread -ldl -lrt
-  CFLAGS := -D_LARGEFILE64_SOURCE -D_XOPEN_SOURCE_EXTENDED $(CFLAGS)
+  FIO_CFLAGS += -D_LARGEFILE64_SOURCE -D_XOPEN_SOURCE_EXTENDED
 endif
 ifeq ($(CONFIG_TARGET_OS), Darwin)
   LIBS	 += -lpthread -ldl
@@ -243,24 +248,21 @@ ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
   SOURCE += os/windows/cpu-affinity.c os/windows/posix.c
   WINDOWS_OBJS = os/windows/cpu-affinity.o os/windows/posix.o lib/hweight.o
   LIBS	 += -lpthread -lpsapi -lws2_32 -lssp
-  CFLAGS := -DPSAPI_VERSION=1 -Ios/windows/posix/include -Wno-format $(CFLAGS)
+  FIO_CFLAGS += -DPSAPI_VERSION=1 -Ios/windows/posix/include -Wno-format
 endif
 
 ifdef CONFIG_DYNAMIC_ENGINES
  DYNAMIC_ENGS := $(ENGINES)
 define engine_template =
 $(1)_OBJS := $$($(1)_SRCS:.c=.o)
-$$($(1)_OBJS): CFLAGS := -fPIC $$($(1)_CFLAGS) $(CFLAGS)
-engines/lib$(1).so: $$($(1)_OBJS)
-	$$(QUIET_LINK)$(CC) -shared -rdynamic -fPIC -Wl,-soname,lib$(1).so.1 $$($(1)_LIBS) -o $$@ $$<
+$$($(1)_OBJS): FIO_CFLAGS += -fPIC $$($(1)_CFLAGS)
 ENGS_OBJS += engines/lib$(1).so
-all install: $(ENGS_OBJS)
 endef
 else # !CONFIG_DYNAMIC_ENGINES
 define engine_template =
 SOURCE += $$($(1)_SRCS)
 LIBS += $$($(1)_LIBS)
-CFLAGS := $$($(1)_CFLAGS) $(CFLAGS)
+CFLAGS += $$($(1)_CFLAGS)
 endef
 endif
 
@@ -427,7 +429,7 @@ mandir = $(prefix)/man
 sharedir = $(prefix)/share/fio
 endif
 
-all: $(PROGS) $(T_TEST_PROGS) $(UT_PROGS) $(SCRIPTS) FORCE
+all: $(PROGS) $(T_TEST_PROGS) $(UT_PROGS) $(SCRIPTS) $(ENGS_OBJS) FORCE
 
 .PHONY: all install clean test
 .PHONY: FORCE cscope
@@ -436,7 +438,7 @@ FIO-VERSION-FILE: FORCE
 	@$(SHELL) $(SRCDIR)/FIO-VERSION-GEN
 -include FIO-VERSION-FILE
 
-override CFLAGS := -DFIO_VERSION='"$(FIO_VERSION)"' $(CFLAGS)
+override CFLAGS := -DFIO_VERSION='"$(FIO_VERSION)"' $(FIO_CFLAGS) $(CFLAGS)
 
 %.o : %.c
 	@mkdir -p $(dir $@)
@@ -478,7 +480,7 @@ lexer.h: lex.yy.c
 exp/test-expression-parser.o: exp/test-expression-parser.c
 	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
 exp/test-expression-parser: exp/test-expression-parser.o
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) $< y.tab.o lex.yy.o -o $@ $(LIBS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) $< y.tab.o lex.yy.o -o $@ $(LIBS)
 
 parse.o: lex.yy.o y.tab.o
 endif
@@ -514,55 +516,60 @@ printing.o: printing.c printing.h
 
 t/io_uring.o: os/linux/io_uring.h
 t/io_uring: $(T_IOU_RING_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_IOU_RING_OBJS) $(LIBS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(T_IOU_RING_OBJS) $(LIBS)
 
 t/read-to-pipe-async: $(T_PIPE_ASYNC_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_PIPE_ASYNC_OBJS) $(LIBS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(T_PIPE_ASYNC_OBJS) $(LIBS)
 
 t/memlock: $(T_MEMLOCK_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_MEMLOCK_OBJS) $(LIBS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(T_MEMLOCK_OBJS) $(LIBS)
 
 t/stest: $(T_SMALLOC_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_SMALLOC_OBJS) $(LIBS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(T_SMALLOC_OBJS) $(LIBS)
 
 t/ieee754: $(T_IEEE_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_IEEE_OBJS) $(LIBS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(T_IEEE_OBJS) $(LIBS)
 
 fio: $(FIO_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(FIO_OBJS) $(LIBS) $(HDFSLIB)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(FIO_OBJS) $(LIBS) $(HDFSLIB)
 
 gfio: $(GFIO_OBJS)
 	$(QUIET_LINK)$(CC) $(filter-out -static, $(LDFLAGS)) -o gfio $(GFIO_OBJS) $(LIBS) $(GFIO_LIBS) $(GTK_LDFLAGS) $(HDFSLIB)
 
 t/fio-genzipf: $(T_ZIPF_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_ZIPF_OBJS) $(LIBS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(T_ZIPF_OBJS) $(LIBS)
 
 t/axmap: $(T_AXMAP_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_AXMAP_OBJS) $(LIBS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(T_AXMAP_OBJS) $(LIBS)
 
 t/lfsr-test: $(T_LFSR_TEST_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_LFSR_TEST_OBJS) $(LIBS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(T_LFSR_TEST_OBJS) $(LIBS)
 
 t/gen-rand: $(T_GEN_RAND_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_GEN_RAND_OBJS) $(LIBS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(T_GEN_RAND_OBJS) $(LIBS)
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
 t/fio-btrace2fio: $(T_BTRACE_FIO_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_BTRACE_FIO_OBJS) $(LIBS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(T_BTRACE_FIO_OBJS) $(LIBS)
 endif
 
 t/fio-dedupe: $(T_DEDUPE_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_DEDUPE_OBJS) $(LIBS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(T_DEDUPE_OBJS) $(LIBS)
 
 t/fio-verify-state: $(T_VS_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_VS_OBJS) $(LIBS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(T_VS_OBJS) $(LIBS)
 
 t/time-test: $(T_TT_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_TT_OBJS) $(LIBS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(T_TT_OBJS) $(LIBS)
 
 ifdef CONFIG_HAVE_CUNIT
 unittests/unittest: $(UT_OBJS) $(UT_TARGET_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(UT_OBJS) $(UT_TARGET_OBJS) -lcunit $(LIBS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(UT_OBJS) $(UT_TARGET_OBJS) -lcunit $(LIBS)
+endif
+
+ifdef CONFIG_DYNAMIC_ENGINES
+engines/lib$(1).so: $$($(1)_OBJS)
+	$$(QUIET_LINK)$(CC) -shared -rdynamic -fPIC -Wl,-soname,lib$(1).so.1 $$($(1)_LIBS) -o $$@ $$<
 endif
 
 clean: FORCE
@@ -603,7 +610,7 @@ fulltest:
 		sudo t/zbd/run-tests-against-zoned-nullb;	 	\
 	fi
 
-install: $(PROGS) $(SCRIPTS) tools/plot/fio2gnuplot.1 FORCE
+install: $(PROGS) $(SCRIPTS) $(ENGS_OBJS) tools/plot/fio2gnuplot.1 FORCE
 	$(INSTALL) -m 755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)
 ifdef CONFIG_DYNAMIC_ENGINES
diff --git a/backend.c b/backend.c
index 05453ae2..f91f3caf 100644
--- a/backend.c
+++ b/backend.c
@@ -1458,16 +1458,17 @@ static bool keep_running(struct thread_data *td)
 	return false;
 }
 
-static int exec_string(struct thread_options *o, const char *string, const char *mode)
+static int exec_string(struct thread_options *o, const char *string,
+		       const char *mode)
 {
-	size_t newlen = strlen(string) + strlen(o->name) + strlen(mode) + 13 + 1;
 	int ret;
 	char *str;
 
-	str = malloc(newlen);
-	sprintf(str, "%s > %s.%s.txt 2>&1", string, o->name, mode);
+	if (asprintf(&str, "%s > %s.%s.txt 2>&1", string, o->name, mode) < 0)
+		return -1;
 
-	log_info("%s : Saving output of %s in %s.%s.txt\n",o->name, mode, o->name, mode);
+	log_info("%s : Saving output of %s in %s.%s.txt\n", o->name, mode,
+		 o->name, mode);
 	ret = system(str);
 	if (ret == -1)
 		log_err("fio: exec of cmd <%s> failed\n", str);
@@ -1731,7 +1732,7 @@ static void *thread_main(void *data)
 	if (!init_random_map(td))
 		goto err;
 
-	if (o->exec_prerun && exec_string(o, o->exec_prerun, (const char *)"prerun"))
+	if (o->exec_prerun && exec_string(o, o->exec_prerun, "prerun"))
 		goto err;
 
 	if (o->pre_read && !pre_read_files(td))
@@ -1890,7 +1891,7 @@ static void *thread_main(void *data)
 	rate_submit_exit(td);
 
 	if (o->exec_postrun)
-		exec_string(o, o->exec_postrun, (const char *)"postrun");
+		exec_string(o, o->exec_postrun, "postrun");
 
 	if (exitall_on_terminate || (o->exitall_error && td->error))
 		fio_terminate_threads(td->groupid, td->o.exit_what);
diff --git a/ci/appveyor-install.sh b/ci/appveyor-install.sh
new file mode 100755
index 00000000..c73e4cb5
--- /dev/null
+++ b/ci/appveyor-install.sh
@@ -0,0 +1,41 @@
+#!/bin/bash
+# The PATH to appropriate distro commands must already be set before invoking
+# this script
+# The following environment variables must be set:
+# PLATFORM={i686,x64}
+# DISTRO={cygwin,msys2}
+# The following environment can optionally be set:
+# CYG_MIRROR=<URL>
+set -eu
+
+case "${ARCHITECTURE}" in
+    "x64")
+        PACKAGE_ARCH="x86_64"
+        ;;
+    "x86")
+        PACKAGE_ARCH="i686"
+        ;;
+esac
+
+echo "Installing packages..."
+case "${DISTRO}" in
+    "cygwin")
+        CYG_MIRROR=${CYG_MIRROR:-"http://cygwin.mirror.constant.com"}
+        setup-x86_64.exe --quiet-mode --no-shortcuts --only-site \
+            --site "${CYG_MIRROR}" --packages \
+            "mingw64-${PACKAGE_ARCH}-CUnit,mingw64-${PACKAGE_ARCH}-zlib"
+        ;;
+    "msys2")
+        #pacman --noconfirm -Syuu # MSYS2 core update
+        #pacman --noconfirm -Syuu # MSYS2 normal update
+        pacman.exe --noconfirm -S \
+            mingw-w64-${PACKAGE_ARCH}-clang \
+            mingw-w64-${PACKAGE_ARCH}-cunit \
+            mingw-w64-${PACKAGE_ARCH}-lld
+        ;;
+esac
+
+python.exe -m pip install scipy six
+
+echo "Python3 path: $(type -p python3 2>&1)"
+echo "Python3 version: $(python3 -V 2>&1)"
diff --git a/ci/travis-build.sh b/ci/travis-build.sh
index 231417e2..923d882d 100755
--- a/ci/travis-build.sh
+++ b/ci/travis-build.sh
@@ -1,8 +1,9 @@
 #!/bin/bash
+set -eu
 
 CI_TARGET_ARCH="${BUILD_ARCH:-$TRAVIS_CPU_ARCH}"
 EXTRA_CFLAGS="-Werror"
-PYTHONUNBUFFERED=TRUE
+export PYTHONUNBUFFERED=TRUE
 CONFIGURE_FLAGS=()
 
 case "$TRAVIS_OS_NAME" in
@@ -11,6 +12,7 @@ case "$TRAVIS_OS_NAME" in
         case "$CI_TARGET_ARCH" in
             "x86")
                 EXTRA_CFLAGS="${EXTRA_CFLAGS} -m32"
+                export LDFLAGS="-m32"
                 ;;
             "amd64")
                 CONFIGURE_FLAGS+=(--enable-cuda)
@@ -24,7 +26,7 @@ CONFIGURE_FLAGS+=(--extra-cflags="${EXTRA_CFLAGS}")
     make &&
     make test &&
     if [[ "$CI_TARGET_ARCH" == "arm64" ]]; then
-	sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug -p 1010:"--skip 15 16 17 18 19 20"
+        sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug -p 1010:"--skip 15 16 17 18 19 20"
     else
-	sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug
+        sudo python3 t/run-fio-tests.py --skip 6 1007 1008 --debug
     fi
diff --git a/ci/travis-install.sh b/ci/travis-install.sh
index b6895e82..103695dc 100755
--- a/ci/travis-install.sh
+++ b/ci/travis-install.sh
@@ -1,5 +1,5 @@
 #!/bin/bash
-set -e
+set -eu
 
 CI_TARGET_ARCH="${BUILD_ARCH:-$TRAVIS_CPU_ARCH}"
 case "$TRAVIS_OS_NAME" in
@@ -51,6 +51,5 @@ case "$TRAVIS_OS_NAME" in
 	;;
 esac
 
-echo "Python version: $(/usr/bin/python -V 2>&1)"
-echo "Python3 path: $(which python3 2>&1)"
+echo "Python3 path: $(type -p python3 2>&1)"
 echo "Python3 version: $(python3 -V 2>&1)"
diff --git a/configure b/configure
index 08571fb0..12b7cb58 100755
--- a/configure
+++ b/configure
@@ -193,6 +193,8 @@ for opt do
   ;;
   --target-win-ver=*) target_win_ver="$optarg"
   ;;
+  --enable-pdb) pdb="yes"
+  ;;
   --build-static) build_static="yes"
   ;;
   --enable-gfio) gfio_check="yes"
@@ -256,6 +258,7 @@ if test "$show_help" = "yes" ; then
   echo "--extra-cflags=         Specify extra CFLAGS to pass to compiler"
   echo "--build-32bit-win       Enable 32-bit build on Windows"
   echo "--target-win-ver=       Minimum version of Windows to target (XP or 7)"
+  echo "--enable-pdb            Enable Windows PDB symbols generation (needs clang/lld)"
   echo "--build-static          Build a static fio"
   echo "--esx                   Configure build options for esx"
   echo "--enable-gfio           Enable building of gtk gfio"
@@ -394,6 +397,8 @@ CYGWIN*)
   fi
   if test "$target_win_ver" = "XP"; then
     output_sym "CONFIG_WINDOWS_XP"
+    # Technically the below is targeting 2003
+    CFLAGS="$CFLAGS -D_WIN32_WINNT=0x0502"
   elif test "$target_win_ver" = "7"; then
     output_sym "CONFIG_WINDOWS_7"
     CFLAGS="$CFLAGS -D_WIN32_WINNT=0x0601"
@@ -939,7 +944,8 @@ cat > $TMPC << EOF
 
 int main(int argc, char **argv)
 {
-  return asprintf(NULL, "%s", "str") == 0;
+  char *buf;
+  return asprintf(&buf, "%s", "str") == 0;
 }
 EOF
 if compile_prog "" "" "have_asprintf"; then
@@ -956,7 +962,8 @@ cat > $TMPC << EOF
 int main(int argc, char **argv)
 {
   va_list ap;
-  return vasprintf(NULL, "%s", ap) == 0;
+  char *buf;
+  return vasprintf(&buf, "%s", ap) == 0;
 }
 EOF
 if compile_prog "" "" "have_vasprintf"; then
@@ -2234,19 +2241,14 @@ lex="no"
 arith="no"
 if test "$disable_lex" = "no" || test -z "$disable_lex" ; then
 if test "$targetos" != "SunOS" ; then
-LEX=$(which lex 2> /dev/null)
-if test -x "$LEX" ; then
+if has lex; then
   lex="yes"
 fi
-YACC=$(which bison 2> /dev/null)
-if test -x "$YACC" ; then
+if has bison; then
   yacc="yes"
   yacc_is_bison="yes"
-else
-  YACC=$(which yacc 2> /dev/null)
-  if test -x "$YACC" ; then
-    yacc="yes"
-  fi
+elif has yacc; then
+  yacc="yes"
 fi
 if test "$yacc" = "yes" && test "$lex" = "yes" ; then
   arith="yes"
@@ -2262,7 +2264,9 @@ int main(int argc, char **argv)
   return 0;
 }
 EOF
-if compile_prog "" "-ll" "lex"; then
+if compile_prog "" "-lfl" "flex"; then
+  LIBS="-lfl $LIBS"
+elif compile_prog "" "-ll" "lex"; then
   LIBS="-ll $LIBS"
 else
   arith="no"
@@ -2276,8 +2280,7 @@ if test "$arith" = "yes" ; then
 if test "$force_no_lex_o" = "yes" ; then
   lex_use_o="no"
 else
-$LEX -o lex.yy.c exp/expression-parser.l 2> /dev/null
-if test "$?" = "0" ; then
+if lex -o lex.yy.c exp/expression-parser.l 2> /dev/null; then
   lex_use_o="yes"
 else
   lex_use_o="no"
@@ -2698,6 +2701,27 @@ if compile_prog "" "" "statx_syscall"; then
 fi
 print_config "statx(2)/syscall" "$statx_syscall"
 
+##########################################
+# check for Windows PDB generation support
+if test "pdb" != "no" ; then
+  cat > $TMPC <<EOF
+int main(void)
+{
+  return 0;
+}
+EOF
+  if compile_prog "-g -gcodeview" "-fuse-ld=lld -Wl,-pdb,$TMPO" "pdb"; then
+    pdb=yes
+  else
+    if test "$pdb" = "yes"; then
+      feature_not_found "PDB" "clang and lld"
+    fi
+    pdb=no
+  fi
+else
+  pdb=no
+fi
+print_config "Windows PDB generation" "$pdb"
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -2931,9 +2955,9 @@ fi
 if test "$arith" = "yes" ; then
   output_sym "CONFIG_ARITHMETIC"
   if test "$yacc_is_bison" = "yes" ; then
-    echo "YACC=$YACC -y" >> $config_host_mak
+    echo "YACC=bison -y" >> $config_host_mak
   else
-    echo "YACC=$YACC" >> $config_host_mak
+    echo "YACC=yacc" >> $config_host_mak
   fi
   if test "$lex_use_o" = "yes" ; then
     echo "CONFIG_LEX_USE_O=y" >> $config_host_mak
@@ -3020,6 +3044,10 @@ fi
 if test "$dynamic_engines" = "yes" ; then
   output_sym "CONFIG_DYNAMIC_ENGINES"
 fi
+if test "$pdb" = yes; then
+  output_sym "CONFIG_PDB"
+fi
+
 print_config "Lib-based ioengines dynamic" "$dynamic_engines"
 cat > $TMPC << EOF
 int main(int argc, char **argv)
diff --git a/engines/net.c b/engines/net.c
index 91f25774..c6cec584 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -938,8 +938,9 @@ static int fio_netio_udp_recv_open(struct thread_data *td, struct fio_file *f)
 
 	if (ntohl(msg.magic) != FIO_LINK_OPEN_CLOSE_MAGIC ||
 	    ntohl(msg.cmd) != FIO_LINK_OPEN) {
-		log_err("fio: bad udp open magic %x/%x\n", ntohl(msg.magic),
-								ntohl(msg.cmd));
+		log_err("fio: bad udp open magic %x/%x\n",
+			(unsigned int) ntohl(msg.magic),
+			(unsigned int) ntohl(msg.cmd));
 		return -1;
 	}
 
diff --git a/engines/windowsaio.c b/engines/windowsaio.c
index 5c7e7964..9868e816 100644
--- a/engines/windowsaio.c
+++ b/engines/windowsaio.c
@@ -161,15 +161,15 @@ static int windowsaio_invalidate_cache(struct fio_file *f)
 	if (ihFile != INVALID_HANDLE_VALUE) {
 		if (!CloseHandle(ihFile)) {
 			error = GetLastError();
-			log_info("windowsaio: invalidation fd close %s "
-				 "failed: error %d\n", f->file_name, error);
+			log_info("windowsaio: invalidation fd close %s failed: error %lu\n",
+				 f->file_name, error);
 			rc = 1;
 		}
 	} else {
 		error = GetLastError();
 		if (error != ERROR_FILE_NOT_FOUND) {
-			log_info("windowsaio: cache invalidation of %s failed: "
-					"error %d\n", f->file_name, error);
+			log_info("windowsaio: cache invalidation of %s failed: error %lu\n",
+				 f->file_name, error);
 			rc = 1;
 		}
 	}
diff --git a/os/windows/cpu-affinity.c b/os/windows/cpu-affinity.c
index 69997b24..46fd048d 100644
--- a/os/windows/cpu-affinity.c
+++ b/os/windows/cpu-affinity.c
@@ -14,7 +14,7 @@ int fio_setaffinity(int pid, os_cpu_mask_t cpumask)
 		bSuccess = SetThreadAffinityMask(h, cpumask);
 		if (!bSuccess)
 			log_err("fio_setaffinity failed: failed to set thread affinity (pid %d, mask %.16llx)\n",
-				pid, cpumask);
+				pid, (long long unsigned) cpumask);
 
 		CloseHandle(h);
 	} else {
@@ -83,7 +83,7 @@ unsigned int cpus_online(void)
 static void print_mask(os_cpu_mask_t *cpumask)
 {
 	for (int i = 0; i < FIO_CPU_MASK_ROWS; i++)
-		dprint(FD_PROCESS, "cpumask[%d]=%lu\n", i, cpumask->row[i]);
+		dprint(FD_PROCESS, "cpumask[%d]=%" PRIu64 "\n", i, cpumask->row[i]);
 }
 
 /* Return the index of the least significant set CPU in cpumask or -1 if no
@@ -99,7 +99,7 @@ int first_set_cpu(os_cpu_mask_t *cpumask)
 		int row_first_cpu;
 
 		row_first_cpu = __builtin_ffsll(cpumask->row[row]) - 1;
-		dprint(FD_PROCESS, "row_first_cpu=%d cpumask->row[%d]=%lu\n",
+		dprint(FD_PROCESS, "row_first_cpu=%d cpumask->row[%d]=%" PRIu64 "\n",
 		       row_first_cpu, row, cpumask->row[row]);
 		if (row_first_cpu > -1) {
 			mask_first_cpu = cpus_offset + row_first_cpu;
@@ -136,7 +136,7 @@ static int last_set_cpu(os_cpu_mask_t *cpumask)
 			    row_last_cpu++;
 		}
 
-		dprint(FD_PROCESS, "row_last_cpu=%d cpumask->row[%d]=%lu\n",
+		dprint(FD_PROCESS, "row_last_cpu=%d cpumask->row[%d]=%" PRIu64 "\n",
 		       row_last_cpu, row, cpumask->row[row]);
 		if (row_last_cpu > -1) {
 			mask_last_cpu = cpus_offset + row_last_cpu;
@@ -213,13 +213,17 @@ static int mask_to_group_mask(os_cpu_mask_t *cpumask, int *processor_group, uint
 		needed_shift = FIO_CPU_MASK_STRIDE - bit_offset;
 		needed_mask_shift = FIO_CPU_MASK_STRIDE - needed;
 		needed_mask = (uint64_t)-1 >> needed_mask_shift;
-		dprint(FD_PROCESS, "bit_offset=%d end=%d needed=%d needed_shift=%d needed_mask=%ld needed_mask_shift=%d\n", bit_offset, end, needed, needed_shift, needed_mask, needed_mask_shift);
+		dprint(FD_PROCESS,
+		       "bit_offset=%d end=%d needed=%d needed_shift=%d needed_mask=%" PRIu64 "needed_mask_shift=%d\n",
+		       bit_offset, end, needed, needed_shift, needed_mask,
+		       needed_mask_shift);
 		group_cpumask |= (cpumask->row[row + 1] & needed_mask) << needed_shift;
 	}
 	group_cpumask &= (uint64_t)-1 >> (FIO_CPU_MASK_STRIDE - group_size);
 
 	/* Return group and mask */
-	dprint(FD_PROCESS, "Returning group=%d group_mask=%lu\n", group, group_cpumask);
+	dprint(FD_PROCESS, "Returning group=%d group_mask=%" PRIu64 "\n",
+	       group, group_cpumask);
 	*processor_group = group;
 	*affinity_mask = group_cpumask;
 
@@ -257,10 +261,8 @@ int fio_setaffinity(int pid, os_cpu_mask_t cpumask)
 	if (SetThreadGroupAffinity(handle, &new_group_affinity, NULL) != 0)
 		ret = 0;
 	else {
-		log_err("fio_setaffinity: failed to set thread affinity "
-			 "(pid %d, group %d, mask %" PRIx64 ", "
-			 "GetLastError=%d)\n", pid, group, group_mask,
-			 GetLastError());
+		log_err("fio_setaffinity: failed to set thread affinity (pid %d, group %d, mask %" PRIx64 ", GetLastError=%lu)\n",
+			pid, group, group_mask, GetLastError());
 		goto err;
 	}
 
@@ -319,7 +321,7 @@ int fio_getaffinity(int pid, os_cpu_mask_t *mask)
 		goto err;
 	}
 	if (!GetProcessGroupAffinity(handle, &group_count, current_groups)) {
-		log_err("%s: failed to get single group affinity for pid %d (%d)\n",
+		log_err("%s: failed to get single group affinity for pid %d (%lu)\n",
 			__func__, pid, GetLastError());
 		goto err;
 	}
@@ -329,7 +331,7 @@ int fio_getaffinity(int pid, os_cpu_mask_t *mask)
 		goto err;
 	}
 	if (!GetProcessAffinityMask(handle, &process_mask, &system_mask)) {
-		log_err("%s: GetProcessAffinityMask() failed for pid\n",
+		log_err("%s: GetProcessAffinityMask() failed for pid %d\n",
 			__func__, pid);
 		goto err;
 	}
diff --git a/os/windows/dobuild.cmd b/os/windows/dobuild.cmd
index d06a2afa..08df3e87 100644
--- a/os/windows/dobuild.cmd
+++ b/os/windows/dobuild.cmd
@@ -34,7 +34,13 @@ if defined SIGN_FIO (
   signtool sign /as /n "%SIGNING_CN%" /tr http://timestamp.digicert.com /td sha256 /fd sha256 ..\..\t\*.exe
 )
 
-"%WIX%bin\candle" -nologo -arch %FIO_ARCH% -dFioVersionNumbers="%FIO_VERSION_NUMBERS%" install.wxs
+if exist ..\..\fio.pdb (
+  set FIO_PDB=true
+) else (
+  set FIO_PDB=false
+)
+
+"%WIX%bin\candle" -nologo -arch %FIO_ARCH% -dFioVersionNumbers="%FIO_VERSION_NUMBERS%" -dFioPDB="%FIO_PDB%" install.wxs
 @if ERRORLEVEL 1 goto end
 "%WIX%bin\candle" -nologo -arch %FIO_ARCH% examples.wxs
 @if ERRORLEVEL 1 goto end
@@ -43,4 +49,4 @@ if defined SIGN_FIO (
 
 if defined SIGN_FIO (
   signtool sign /n "%SIGNING_CN%" /tr http://timestamp.digicert.com /td sha256 /fd sha256 %FIO_VERSION%-%FIO_ARCH%.msi
-)
\ No newline at end of file
+)
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index dcb8c92c..f73ec5e2 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -27,6 +27,11 @@
 							<File Source="..\..\fio.exe"/>
 							<Environment Action="set" Part="last" Id="PATH" Name="PATH" Value="[INSTALLDIR]fio\" System="yes"/>
 						</Component>
+						<?if $(var.FioPDB) = true?>
+						<Component>
+							<File Id="fio.pdb" Name="fio.pdb" Source="..\..\fio.pdb"/>
+						</Component>
+						<?endif?>
 						<Component>
 							<File Id="README" Name="README.txt" Source="..\..\README"/>
 						</Component>
@@ -76,6 +81,9 @@
 
 	<Feature Id="AlwaysInstall" Absent="disallow" ConfigurableDirectory="INSTALLDIR" Display="hidden" Level="1" Title="Flexible I/O Tester">
 		<ComponentRef Id="fio.exe"/>
+		<?if $(var.FioPDB) = true?>
+		<ComponentRef Id="fio.pdb"/>
+		<?endif?>
 		<ComponentRef Id="HOWTO"/>
 		<ComponentRef Id="README"/>
 		<ComponentRef Id="REPORTING_BUGS"/>
diff --git a/os/windows/posix.c b/os/windows/posix.c
index 31271de0..9e9f12ef 100644
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -168,7 +168,7 @@ int win_to_posix_error(DWORD winerr)
 	case ERROR_FILE_INVALID:
 		return ENXIO;
 	default:
-		log_err("fio: windows error %d not handled\n", winerr);
+		log_err("fio: windows error %lu not handled\n", winerr);
 		return EIO;
 	}
 
@@ -188,7 +188,8 @@ int GetNumLogicalProcessors(void)
 		if (error == ERROR_INSUFFICIENT_BUFFER)
 			processor_info = malloc(len);
 		else {
-			log_err("Error: GetLogicalProcessorInformation failed: %d\n", error);
+			log_err("Error: GetLogicalProcessorInformation failed: %lu\n",
+				error);
 			return -1;
 		}
 
diff --git a/t/memlock.c b/t/memlock.c
index 418dc3c4..9f5a3ea8 100644
--- a/t/memlock.c
+++ b/t/memlock.c
@@ -22,7 +22,7 @@ static void *worker(void *data)
 		for (index = 0; index + 4096 < size; index += 4096)
 			memset(&buf[index+512], 0x89, 512);
 		if (first) {
-			printf("loop%d: did %lu MiB\n", i+1, size/(1024UL*1024UL));
+			printf("loop%d: did %lu MiB\n", i+1, td->mib);
 			first = 0;
 		}
 	}

