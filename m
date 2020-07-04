Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbgGDMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 4 Jul 2020 08:00:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C330EC061794
        for <fio@vger.kernel.org>; Sat,  4 Jul 2020 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jrgpx-0000Ag-NA
        for fio@vger.kernel.org; Sat, 04 Jul 2020 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200704120002.2F0431BC0F06@kernel.dk>
Date: Sat,  4 Jul 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5144df064b2fc011615868e59083cfc1786bd073:

  Merge branch 'num2str' of https://github.com/bvanassche/fio (2020-07-02 18:08:14 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a504a3902e00b6db0183872b0ff62e35abae7119:

  configure: fix bad indentation (2020-07-03 08:34:56 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      configure: fix bad indentation

Yigal Korman (4):
      fio: don't retry engine search on failure
      configure/Makefile: engine LIBS consistency
      configure: new --dynamic-libengines build option
      fio: better info when engine not found

 .gitignore         |  1 +
 Makefile           | 86 +++++++++++++++++++++++++++++++++++++++++++-----------
 configure          | 20 +++++--------
 engines/dev-dax.c  |  2 +-
 engines/guasi.c    |  2 +-
 engines/http.c     |  2 +-
 engines/libaio.c   |  2 +-
 engines/libhdfs.c  |  6 ++--
 engines/libiscsi.c |  6 ++--
 engines/libpmem.c  |  2 +-
 engines/libzbc.c   |  2 +-
 engines/nbd.c      |  2 +-
 engines/pmemblk.c  |  2 +-
 engines/rados.c    |  2 +-
 engines/rbd.c      |  2 +-
 engines/rdma.c     |  9 +++---
 init.c             | 14 ++++++---
 ioengines.c        | 26 +++++++++++++++--
 ioengines.h        |  6 ++++
 os/os-linux.h      |  2 ++
 20 files changed, 141 insertions(+), 55 deletions(-)

---

Diff of recent changes:

diff --git a/.gitignore b/.gitignore
index b84b0fda..0aa4a361 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,5 +1,6 @@
 *.d
 *.o
+*.so
 *.exe
 /.depend
 /FIO-VERSION-FILE
diff --git a/Makefile b/Makefile
index 99e96635..8f8d9b9a 100644
--- a/Makefile
+++ b/Makefile
@@ -60,15 +60,17 @@ ifdef CONFIG_LIBHDFS
 endif
 
 ifdef CONFIG_LIBISCSI
-  CFLAGS := $(LIBISCSI_CFLAGS) $(CFLAGS)
-  LIBS += $(LIBISCSI_LIBS)
-  SOURCE += engines/libiscsi.c
+  iscsi_SRCS = engines/libiscsi.c
+  iscsi_LIBS = $(LIBISCSI_LIBS)
+  iscsi_CFLAGS = $(LIBISCSI_LIBS)
+  ENGINES += iscsi
 endif
 
 ifdef CONFIG_LIBNBD
-  CFLAGS := $(LIBNBD_CFLAGS) $(CFLAGS)
-  LIBS += $(LIBNBD_LIBS)
-  SOURCE += engines/nbd.c
+  nbd_SRCS = engines/nbd.c
+  nbd_LIBS = $(LIBNBD_LIBS)
+  nbd_CFLAGS = $(LIBNBD_CFLAGS)
+  ENGINES += nbd
 endif
 
 ifdef CONFIG_64BIT
@@ -78,10 +80,19 @@ ifdef CONFIG_32BIT
   CFLAGS := -DBITS_PER_LONG=32 $(CFLAGS)
 endif
 ifdef CONFIG_LIBAIO
-  SOURCE += engines/libaio.c
+  aio_SRCS = engines/libaio.c
+  aio_LIBS = -laio
+  ifdef CONFIG_LIBAIO_URING
+    aio_LIBS = -luring
+  else
+    aio_LIBS = -laio
+  endif
+  ENGINES += aio
 endif
 ifdef CONFIG_RDMA
-  SOURCE += engines/rdma.c
+  rdma_SRCS = engines/rdma.c
+  rdma_LIBS = -libverbs -lrdmacm
+  ENGINES += rdma
 endif
 ifdef CONFIG_POSIXAIO
   SOURCE += engines/posixaio.c
@@ -96,7 +107,8 @@ ifdef CONFIG_LINUX_SPLICE
   SOURCE += engines/splice.c
 endif
 ifdef CONFIG_GUASI
-  SOURCE += engines/guasi.c
+  guasi_SRCS = engines/guasi.c
+  ENGINES += guasi
 endif
 ifdef CONFIG_SOLARISAIO
   SOURCE += engines/solarisaio.c
@@ -105,13 +117,19 @@ ifdef CONFIG_WINDOWSAIO
   SOURCE += engines/windowsaio.c
 endif
 ifdef CONFIG_RADOS
-  SOURCE += engines/rados.c
+  rados_SRCS = engines/rados.c
+  rados_LIBS = -lrados
+  ENGINES += rados
 endif
 ifdef CONFIG_RBD
-  SOURCE += engines/rbd.c
+  rbd_SRCS = engines/rbd.c
+  rbd_LIBS = -lrbd -lrados
+  ENGINES += rbd
 endif
 ifdef CONFIG_HTTP
-  SOURCE += engines/http.c
+  http_SRCS = engines/http.c
+  http_LIBS = -lcurl -lssl -lcrypto
+  ENGINES += http
 endif
 SOURCE += oslib/asprintf.c
 ifndef CONFIG_STRSEP
@@ -139,6 +157,7 @@ ifdef CONFIG_GFAPI
   SOURCE += engines/glusterfs.c
   SOURCE += engines/glusterfs_sync.c
   SOURCE += engines/glusterfs_async.c
+  LIBS += -lgfapi -lglusterfs
   ifdef CONFIG_GF_FADVISE
     CFLAGS := "-DGFAPI_USE_FADVISE" $(CFLAGS)
   endif
@@ -149,19 +168,27 @@ ifdef CONFIG_MTD
   SOURCE += oslib/libmtd_legacy.c
 endif
 ifdef CONFIG_PMEMBLK
-  SOURCE += engines/pmemblk.c
+  pmemblk_SRCS = engines/pmemblk.c
+  pmemblk_LIBS = -lpmemblk
+  ENGINES += pmemblk
 endif
 ifdef CONFIG_LINUX_DEVDAX
-  SOURCE += engines/dev-dax.c
+  devdax_SRCS = engines/dev-dax.c
+  devdax_LIBS = -lpmem
+  ENGINES += dev-dax
 endif
 ifdef CONFIG_LIBPMEM
-  SOURCE += engines/libpmem.c
+  pmem_SRCS = engines/libpmem.c
+  pmem_LIBS = -lpmem
+  ENGINES += pmem
 endif
 ifdef CONFIG_IME
   SOURCE += engines/ime.c
 endif
 ifdef CONFIG_LIBZBC
-  SOURCE += engines/libzbc.c
+  zbc_SRCS = engines/libzbc.c
+  zbc_LIBS = -lzbc
+  ENGINES += zbc
 endif
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
@@ -223,6 +250,26 @@ ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
   CFLAGS := -DPSAPI_VERSION=1 -Ios/windows/posix/include -Wno-format $(CFLAGS)
 endif
 
+ifdef CONFIG_DYNAMIC_ENGINES
+ DYNAMIC_ENGS := $(ENGINES)
+define engine_template =
+$(1)_OBJS := $$($(1)_SRCS:.c=.o)
+$$($(1)_OBJS): CFLAGS := -fPIC $$($(1)_CFLAGS) $(CFLAGS)
+engines/lib$(1).so: $$($(1)_OBJS)
+	$$(QUIET_LINK)$(CC) -shared -rdynamic -fPIC -Wl,-soname,lib$(1).so.1 $$($(1)_LIBS) -o $$@ $$<
+ENGS_OBJS += engines/lib$(1).so
+all install: $(ENGS_OBJS)
+endef
+else # !CONFIG_DYNAMIC_ENGINES
+define engine_template =
+SOURCE += $$($(1)_SRCS)
+LIBS += $$($(1)_LIBS)
+CFLAGS := $$($(1)_CFLAGS) $(CFLAGS)
+endef
+endif
+
+$(foreach eng,$(ENGINES),$(eval $(call engine_template,$(eng))))
+
 OBJS := $(SOURCE:.c=.o)
 
 FIO_OBJS = $(OBJS) fio.o
@@ -374,6 +421,7 @@ else
 endif
 prefix = $(INSTALL_PREFIX)
 bindir = $(prefix)/bin
+libdir = $(prefix)/lib/fio
 
 ifeq ($(CONFIG_TARGET_OS), Darwin)
 mandir = /usr/share/man
@@ -522,7 +570,7 @@ unittests/unittest: $(UT_OBJS) $(UT_TARGET_OBJS)
 endif
 
 clean: FORCE
-	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(UT_OBJS) $(PROGS) $(T_PROGS) $(T_TEST_PROGS) core.* core gfio unittests/unittest FIO-VERSION-FILE *.[do] lib/*.d oslib/*.[do] crc/*.d engines/*.[do] profiles/*.[do] t/*.[do] unittests/*.[do] unittests/*/*.[do] config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do] lexer.h
+	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(UT_OBJS) $(PROGS) $(T_PROGS) $(T_TEST_PROGS) core.* core gfio unittests/unittest FIO-VERSION-FILE *.[do] lib/*.d oslib/*.[do] crc/*.d engines/*.[do] engines/*.so profiles/*.[do] t/*.[do] unittests/*.[do] unittests/*/*.[do] config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do] lexer.h
 	@rm -f t/fio-btrace2fio t/io_uring t/read-to-pipe-async
 	@rm -rf  doc/output
 
@@ -562,6 +610,10 @@ fulltest:
 install: $(PROGS) $(SCRIPTS) tools/plot/fio2gnuplot.1 FORCE
 	$(INSTALL) -m 755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)
+ifdef CONFIG_DYNAMIC_ENGINES
+	$(INSTALL) -m 755 -d $(DESTDIR)$(libdir)
+	$(INSTALL) -m 755 $(SRCDIR)/engines/*.so $(DESTDIR)$(libdir)
+endif
 	$(INSTALL) -m 755 -d $(DESTDIR)$(mandir)/man1
 	$(INSTALL) -m 644 $(SRCDIR)/fio.1 $(DESTDIR)$(mandir)/man1
 	$(INSTALL) -m 644 $(SRCDIR)/tools/fio_generate_plots.1 $(DESTDIR)$(mandir)/man1
diff --git a/configure b/configure
index 63b30555..6991393b 100755
--- a/configure
+++ b/configure
@@ -151,6 +151,7 @@ march_set="no"
 libiscsi="no"
 libnbd="no"
 libaio_uring="no"
+dynamic_engines="no"
 prefix=/usr/local
 
 # parse options
@@ -215,6 +216,8 @@ for opt do
   ;;
   --enable-libaio-uring) libaio_uring="yes"
   ;;
+  --dynamic-libengines) dynamic_engines="yes"
+  ;;
   --help)
     show_help="yes"
     ;;
@@ -254,6 +257,7 @@ if test "$show_help" = "yes" ; then
   echo "--enable-libnbd         Enable libnbd (NBD engine) support"
   echo "--disable-tcmalloc	Disable tcmalloc support"
   echo "--enable-libaio-uring   Enable libaio emulated over io_uring"
+  echo "--dynamic-libengines	Lib-based ioengines as dynamic libraries"
   exit $exit_val
 fi
 
@@ -605,11 +609,9 @@ int main(void)
 EOF
   if test "$libaio_uring" = "yes" && compile_prog "" "-luring" "libaio io_uring" ; then
     libaio=yes
-    LIBS="-luring $LIBS"
   elif compile_prog "" "-laio" "libaio" ; then
     libaio=yes
     libaio_uring=no
-    LIBS="-laio $LIBS"
   else
     if test "$libaio" = "yes" ; then
       feature_not_found "linux AIO" "libaio-dev or libaio-devel"
@@ -859,7 +861,6 @@ int main(int argc, char **argv)
 EOF
 if test "$disable_rdma" != "yes" && compile_prog "" "-libverbs" "libverbs" ; then
     libverbs="yes"
-    LIBS="-libverbs $LIBS"
 fi
 print_config "libverbs" "$libverbs"
 
@@ -879,7 +880,6 @@ int main(int argc, char **argv)
 EOF
 if test "$disable_rdma" != "yes" && compile_prog "" "-lrdmacm" "rdma"; then
     rdmacm="yes"
-    LIBS="-lrdmacm $LIBS"
 fi
 print_config "rdmacm" "$rdmacm"
 
@@ -1770,10 +1770,8 @@ if test "$disable_http" != "yes"; then
   if compile_prog "" "$HTTP_LIBS" "curl-new-ssl"; then
     output_sym "CONFIG_HAVE_OPAQUE_HMAC_CTX"
     http="yes"
-    LIBS="$HTTP_LIBS $LIBS"
   elif mv $TMPC2 $TMPC && compile_prog "" "$HTTP_LIBS" "curl-old-ssl"; then
     http="yes"
-    LIBS="$HTTP_LIBS $LIBS"
   fi
 fi
 print_config "http engine" "$http"
@@ -1802,7 +1800,6 @@ int main(int argc, char **argv)
 }
 EOF
 if test "$disable_rados" != "yes"  && compile_prog "" "-lrados" "rados"; then
-  LIBS="-lrados $LIBS"
   rados="yes"
 fi
 print_config "Rados engine" "$rados"
@@ -1833,7 +1830,6 @@ int main(int argc, char **argv)
 }
 EOF
 if test "$disable_rbd" != "yes"  && compile_prog "" "-lrbd -lrados" "rbd"; then
-  LIBS="-lrbd -lrados $LIBS"
   rbd="yes"
 fi
 print_config "Rados Block Device engine" "$rbd"
@@ -1924,7 +1920,6 @@ int main(int argc, char **argv)
 }
 EOF
 if test "$disable_gfapi" != "yes"  && compile_prog "" "-lgfapi -lglusterfs" "gfapi"; then
-  LIBS="-lgfapi -lglusterfs $LIBS"
   gfapi="yes"
 fi
 print_config "Gluster API engine" "$gfapi"
@@ -2086,7 +2081,6 @@ int main(int argc, char **argv)
 EOF
 if compile_prog "" "-lpmem" "libpmem"; then
   libpmem="yes"
-  LIBS="-lpmem $LIBS"
 fi
 print_config "libpmem" "$libpmem"
 
@@ -2108,7 +2102,6 @@ int main(int argc, char **argv)
 EOF
   if compile_prog "" "-lpmemblk" "libpmemblk"; then
     libpmemblk="yes"
-    LIBS="-lpmemblk $LIBS"
   fi
 fi
 print_config "libpmemblk" "$libpmemblk"
@@ -2432,7 +2425,6 @@ if compile_prog "" "-lzbc" "libzbc"; then
   libzbcvermaj=$(pkg-config --modversion libzbc | sed 's/\.[0-9]*\.[0-9]*//')
   if test "$libzbcvermaj" -ge "5" ; then
     libzbc="yes"
-    LIBS="-lzbc $LIBS"
   else
     print_config "libzbc engine" "Unsupported libzbc version (version 5 or above required)"
     libzbc="no"
@@ -2966,6 +2958,10 @@ if test "$libnbd" = "yes" ; then
   echo "LIBNBD_CFLAGS=$libnbd_cflags" >> $config_host_mak
   echo "LIBNBD_LIBS=$libnbd_libs" >> $config_host_mak
 fi
+if test "$dynamic_engines" = "yes" ; then
+  output_sym "CONFIG_DYNAMIC_ENGINES"
+fi
+print_config "Lib-based ioengines dynamic" "$dynamic_engines"
 cat > $TMPC << EOF
 int main(int argc, char **argv)
 {
diff --git a/engines/dev-dax.c b/engines/dev-dax.c
index 422ea634..1d0f66cb 100644
--- a/engines/dev-dax.c
+++ b/engines/dev-dax.c
@@ -328,7 +328,7 @@ fio_devdax_get_file_size(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
-static struct ioengine_ops ioengine = {
+FIO_STATIC struct ioengine_ops ioengine = {
 	.name		= "dev-dax",
 	.version	= FIO_IOOPS_VERSION,
 	.init		= fio_devdax_init,
diff --git a/engines/guasi.c b/engines/guasi.c
index cb26802c..d4121757 100644
--- a/engines/guasi.c
+++ b/engines/guasi.c
@@ -242,7 +242,7 @@ static int fio_guasi_init(struct thread_data *td)
 	return 0;
 }
 
-static struct ioengine_ops ioengine = {
+FIO_STATIC struct ioengine_ops ioengine = {
 	.name		= "guasi",
 	.version	= FIO_IOOPS_VERSION,
 	.init		= fio_guasi_init,
diff --git a/engines/http.c b/engines/http.c
index 275fcab5..7a61b132 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -639,7 +639,7 @@ static int fio_http_invalidate(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
-static struct ioengine_ops ioengine = {
+FIO_STATIC struct ioengine_ops ioengine = {
 	.name = "http",
 	.version		= FIO_IOOPS_VERSION,
 	.flags			= FIO_DISKLESSIO | FIO_SYNCIO,
diff --git a/engines/libaio.c b/engines/libaio.c
index 398fdf91..b909b79e 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -445,7 +445,7 @@ static int fio_libaio_init(struct thread_data *td)
 	return 0;
 }
 
-static struct ioengine_ops ioengine = {
+FIO_STATIC struct ioengine_ops ioengine = {
 	.name			= "libaio",
 	.version		= FIO_IOOPS_VERSION,
 	.flags			= FIO_ASYNCIO_SYNC_TRIM,
diff --git a/engines/libhdfs.c b/engines/libhdfs.c
index c57fcea6..9ca82f78 100644
--- a/engines/libhdfs.c
+++ b/engines/libhdfs.c
@@ -393,7 +393,7 @@ static void fio_hdfsio_io_u_free(struct thread_data *td, struct io_u *io_u)
 	}
 }
 
-static struct ioengine_ops ioengine_hdfs = {
+FIO_STATIC struct ioengine_ops ioengine = {
 	.name = "libhdfs",
 	.version = FIO_IOOPS_VERSION,
 	.flags = FIO_SYNCIO | FIO_DISKLESSIO | FIO_NODISKUTIL,
@@ -412,10 +412,10 @@ static struct ioengine_ops ioengine_hdfs = {
 
 static void fio_init fio_hdfsio_register(void)
 {
-	register_ioengine(&ioengine_hdfs);
+	register_ioengine(&ioengine);
 }
 
 static void fio_exit fio_hdfsio_unregister(void)
 {
-	unregister_ioengine(&ioengine_hdfs);
+	unregister_ioengine(&ioengine);
 }
diff --git a/engines/libiscsi.c b/engines/libiscsi.c
index 35761a61..c97b5709 100644
--- a/engines/libiscsi.c
+++ b/engines/libiscsi.c
@@ -383,7 +383,7 @@ static struct io_u *fio_iscsi_event(struct thread_data *td, int event)
 	return io_u;
 }
 
-static struct ioengine_ops ioengine_iscsi = {
+FIO_STATIC struct ioengine_ops ioengine = {
 	.name               = "libiscsi",
 	.version            = FIO_IOOPS_VERSION,
 	.flags              = FIO_SYNCIO | FIO_DISKLESSIO | FIO_NODISKUTIL,
@@ -402,10 +402,10 @@ static struct ioengine_ops ioengine_iscsi = {
 
 static void fio_init fio_iscsi_register(void)
 {
-	register_ioengine(&ioengine_iscsi);
+	register_ioengine(&ioengine);
 }
 
 static void fio_exit fio_iscsi_unregister(void)
 {
-	unregister_ioengine(&ioengine_iscsi);
+	unregister_ioengine(&ioengine);
 }
diff --git a/engines/libpmem.c b/engines/libpmem.c
index 99c7b50d..3f63055c 100644
--- a/engines/libpmem.c
+++ b/engines/libpmem.c
@@ -558,7 +558,7 @@ static int fio_libpmem_close_file(struct thread_data *td, struct fio_file *f)
 	return generic_close_file(td, f);
 }
 
-static struct ioengine_ops ioengine = {
+FIO_STATIC struct ioengine_ops ioengine = {
 	.name		= "libpmem",
 	.version	= FIO_IOOPS_VERSION,
 	.init		= fio_libpmem_init,
diff --git a/engines/libzbc.c b/engines/libzbc.c
index 9e568334..fdde8ca6 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -397,7 +397,7 @@ static enum fio_q_status libzbc_queue(struct thread_data *td, struct io_u *io_u)
 	return FIO_Q_COMPLETED;
 }
 
-static struct ioengine_ops ioengine = {
+FIO_STATIC struct ioengine_ops ioengine = {
 	.name			= "libzbc",
 	.version		= FIO_IOOPS_VERSION,
 	.open_file		= libzbc_open_file,
diff --git a/engines/nbd.c b/engines/nbd.c
index 53237929..b0ba75e6 100644
--- a/engines/nbd.c
+++ b/engines/nbd.c
@@ -328,7 +328,7 @@ static int nbd_invalidate(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
-static struct ioengine_ops ioengine = {
+FIO_STATIC struct ioengine_ops ioengine = {
 	.name			= "nbd",
 	.version		= FIO_IOOPS_VERSION,
 	.options		= options,
diff --git a/engines/pmemblk.c b/engines/pmemblk.c
index e2eaa15e..fc6358e8 100644
--- a/engines/pmemblk.c
+++ b/engines/pmemblk.c
@@ -426,7 +426,7 @@ static int fio_pmemblk_unlink_file(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
-static struct ioengine_ops ioengine = {
+FIO_STATIC struct ioengine_ops ioengine = {
 	.name = "pmemblk",
 	.version = FIO_IOOPS_VERSION,
 	.queue = fio_pmemblk_queue,
diff --git a/engines/rados.c b/engines/rados.c
index d4413427..42ee48ff 100644
--- a/engines/rados.c
+++ b/engines/rados.c
@@ -444,7 +444,7 @@ static int fio_rados_io_u_init(struct thread_data *td, struct io_u *io_u)
 }
 
 /* ioengine_ops for get_ioengine() */
-static struct ioengine_ops ioengine = {
+FIO_STATIC struct ioengine_ops ioengine = {
 	.name = "rados",
 	.version		= FIO_IOOPS_VERSION,
 	.flags			= FIO_DISKLESSIO,
diff --git a/engines/rbd.c b/engines/rbd.c
index a08f4775..268b6ebd 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -668,7 +668,7 @@ static int fio_rbd_io_u_init(struct thread_data *td, struct io_u *io_u)
 	return 0;
 }
 
-static struct ioengine_ops ioengine = {
+FIO_STATIC struct ioengine_ops ioengine = {
 	.name			= "rbd",
 	.version		= FIO_IOOPS_VERSION,
 	.setup			= fio_rbd_setup,
diff --git a/engines/rdma.c b/engines/rdma.c
index f192f432..f4471869 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -226,7 +226,8 @@ static int client_recv(struct thread_data *td, struct ibv_wc *wc)
 		rd->rmt_nr = ntohl(rd->recv_buf.nr);
 
 		for (i = 0; i < rd->rmt_nr; i++) {
-			rd->rmt_us[i].buf = be64_to_cpu(rd->recv_buf.rmt_us[i].buf);
+			rd->rmt_us[i].buf = __be64_to_cpu(
+						rd->recv_buf.rmt_us[i].buf);
 			rd->rmt_us[i].rkey = ntohl(rd->recv_buf.rmt_us[i].rkey);
 			rd->rmt_us[i].size = ntohl(rd->recv_buf.rmt_us[i].size);
 
@@ -1389,7 +1390,7 @@ static int fio_rdmaio_setup(struct thread_data *td)
 	return 0;
 }
 
-static struct ioengine_ops ioengine_rw = {
+FIO_STATIC struct ioengine_ops ioengine = {
 	.name			= "rdma",
 	.version		= FIO_IOOPS_VERSION,
 	.setup			= fio_rdmaio_setup,
@@ -1410,10 +1411,10 @@ static struct ioengine_ops ioengine_rw = {
 
 static void fio_init fio_rdmaio_register(void)
 {
-	register_ioengine(&ioengine_rw);
+	register_ioengine(&ioengine);
 }
 
 static void fio_exit fio_rdmaio_unregister(void)
 {
-	unregister_ioengine(&ioengine_rw);
+	unregister_ioengine(&ioengine);
 }
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
diff --git a/ioengines.c b/ioengines.c
index 2c7a0df9..c1b430a1 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -75,6 +75,25 @@ static struct ioengine_ops *find_ioengine(const char *name)
 	return NULL;
 }
 
+#ifdef CONFIG_DYNAMIC_ENGINES
+static void *dlopen_external(struct thread_data *td, const char *engine)
+{
+	char engine_path[PATH_MAX];
+	void *dlhandle;
+
+	sprintf(engine_path, "%s/lib%s.so", FIO_EXT_ENG_DIR, engine);
+
+	dlhandle = dlopen(engine_path, RTLD_LAZY);
+	if (!dlhandle)
+		log_info("Engine %s not found; Either name is invalid, was not built, or fio-engine-%s package is missing.\n",
+			 engine, engine);
+
+	return dlhandle;
+}
+#else
+#define dlopen_external(td, engine) (NULL)
+#endif
+
 static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 					    const char *engine_lib)
 {
@@ -86,8 +105,11 @@ static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 	dlerror();
 	dlhandle = dlopen(engine_lib, RTLD_LAZY);
 	if (!dlhandle) {
-		td_vmsg(td, -1, dlerror(), "dlopen");
-		return NULL;
+		dlhandle = dlopen_external(td, engine_lib);
+		if (!dlhandle) {
+			td_vmsg(td, -1, dlerror(), "dlopen");
+			return NULL;
+		}
 	}
 
 	/*
diff --git a/ioengines.h b/ioengines.h
index f48b4db9..54dadba2 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -10,6 +10,12 @@
 
 #define FIO_IOOPS_VERSION	26
 
+#ifndef CONFIG_DYNAMIC_ENGINES
+#define FIO_STATIC	static
+#else
+#define FIO_STATIC
+#endif
+
 /*
  * io_ops->queue() return values
  */
diff --git a/os/os-linux.h b/os/os-linux.h
index 6ec7243d..65d3b429 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -58,6 +58,8 @@
 
 #define OS_MAP_ANON		MAP_ANONYMOUS
 
+#define FIO_EXT_ENG_DIR	"/usr/lib/fio"
+
 typedef cpu_set_t os_cpu_mask_t;
 
 #ifdef CONFIG_3ARG_AFFINITY

