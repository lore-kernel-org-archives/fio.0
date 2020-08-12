Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbgHLMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 12 Aug 2020 08:00:12 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838A0C06174A
        for <fio@vger.kernel.org>; Wed, 12 Aug 2020 05:00:11 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k5pQO-00061f-Fc
        for fio@vger.kernel.org; Wed, 12 Aug 2020 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200812120002.48EF91BC01B2@kernel.dk>
Date: Wed, 12 Aug 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit cb7d7abbab67e03c901bfaf9517e0cae40a548bf:

  io_u: set io_u->verify_offset in fill_io_u() (2020-08-10 21:40:59 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0d578085cc7b97b783e1719b205dd563b406ecbc:

  t/zbd: check log file for failed assertions (2020-08-11 10:42:43 -0600)

----------------------------------------------------------------
Dmitry Fomichev (4):
      configure: improve libzbc version check
      configure: check if pkg-config is installed
      zbd: simplify zone reset code
      t/zbd: check log file for failed assertions

 configure              | 62 +++++++++++++++++++++++++--------------------
 t/zbd/test-zbd-support |  9 ++++++-
 zbd.c                  | 68 +++++++++++++++++---------------------------------
 3 files changed, 66 insertions(+), 73 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 5925e94f..dd7fe3d2 100755
--- a/configure
+++ b/configure
@@ -133,6 +133,23 @@ output_sym() {
   echo "#define $1" >> $config_host_h
 }
 
+check_min_lib_version() {
+  local feature=$3
+
+  if ${cross_prefix}pkg-config --atleast-version=$2 $1 > /dev/null 2>&1; then
+    return 0
+  fi
+  : ${feature:=${1}}
+  if ${cross_prefix}pkg-config --version > /dev/null 2>&1; then
+    if test ${!feature} = "yes" ; then
+      feature_not_found "$feature" "$1 >= $2"
+    fi
+  else
+    print_config "$1" "missing pkg-config, can't check $feature version"
+  fi
+  return 1
+}
+
 targetos=""
 cpu=""
 
@@ -152,6 +169,7 @@ march_set="no"
 libiscsi="no"
 libnbd="no"
 libaio_uring="no"
+libzbc=""
 dynamic_engines="no"
 prefix=/usr/local
 
@@ -213,6 +231,8 @@ for opt do
   ;;
   --enable-libnbd) libnbd="yes"
   ;;
+  --disable-libzbc) libzbc="no"
+  ;;
   --disable-tcmalloc) disable_tcmalloc="yes"
   ;;
   --enable-libaio-uring) libaio_uring="yes"
@@ -256,6 +276,7 @@ if test "$show_help" = "yes" ; then
   echo "--with-ime=             Install path for DDN's Infinite Memory Engine"
   echo "--enable-libiscsi       Enable iscsi support"
   echo "--enable-libnbd         Enable libnbd (NBD engine) support"
+  echo "--disable-libzbc        Disable libzbc even if found"
   echo "--disable-tcmalloc	Disable tcmalloc support"
   echo "--enable-libaio-uring   Enable libaio emulated over io_uring"
   echo "--dynamic-libengines	Lib-based ioengines as dynamic libraries"
@@ -1517,18 +1538,17 @@ if test "$?" != "0" ; then
   echo "configure: gtk and gthread not found"
   exit 1
 fi
-if ! ${cross_prefix}pkg-config --atleast-version 2.18.0 gtk+-2.0; then
-  echo "GTK found, but need version 2.18 or higher"
-  gfio="no"
-else
+gfio="yes"
+if check_min_lib_version gtk+-2.0 2.18.0 "gfio"; then
   if compile_prog "$GTK_CFLAGS" "$GTK_LIBS" "gfio" ; then
-    gfio="yes"
     GFIO_LIBS="$LIBS $GTK_LIBS"
     CFLAGS="$CFLAGS $GTK_CFLAGS"
   else
     echo "Please install gtk and gdk libraries"
     gfio="no"
   fi
+else
+  gfio="no"
 fi
 LDFLAGS=$ORG_LDFLAGS
 fi
@@ -2178,15 +2198,11 @@ print_config "DDN's Infinite Memory Engine" "$libime"
 ##########################################
 # Check if we have libiscsi
 if test "$libiscsi" != "no" ; then
-  minimum_libiscsi=1.9.0
-  if $(pkg-config --atleast-version=$minimum_libiscsi libiscsi); then
+  if check_min_lib_version libiscsi 1.9.0; then
     libiscsi="yes"
     libiscsi_cflags=$(pkg-config --cflags libiscsi)
     libiscsi_libs=$(pkg-config --libs libiscsi)
   else
-    if test "$libiscsi" = "yes" ; then
-      feature_not_found "libiscsi" "libiscsi >= $minimum_libiscsi"
-    fi
     libiscsi="no"
   fi
 fi
@@ -2195,15 +2211,11 @@ print_config "iscsi engine" "$libiscsi"
 ##########################################
 # Check if we have libnbd (for NBD support)
 if test "$libnbd" != "no" ; then
-  minimum_libnbd=0.9.8
-  if $(pkg-config --atleast-version=$minimum_libnbd libnbd); then
+  if check_min_lib_version libnbd 0.9.8; then
     libnbd="yes"
     libnbd_cflags=$(pkg-config --cflags libnbd)
     libnbd_libs=$(pkg-config --libs libnbd)
   else
-    if test "$libnbd" = "yes" ; then
-      feature_not_found "libnbd" "libnbd >= $minimum_libnbd"
-    fi
     libnbd="no"
   fi
 fi
@@ -2454,9 +2466,6 @@ fi
 
 ##########################################
 # libzbc probe
-if test "$libzbc" != "yes" ; then
-  libzbc="no"
-fi
 cat > $TMPC << EOF
 #include <libzbc/zbc.h>
 int main(int argc, char **argv)
@@ -2466,19 +2475,18 @@ int main(int argc, char **argv)
   return zbc_open("foo=bar", O_RDONLY, &dev);
 }
 EOF
-if compile_prog "" "-lzbc" "libzbc"; then
-  libzbcvermaj=$(pkg-config --modversion libzbc | sed 's/\.[0-9]*\.[0-9]*//')
-  if test "$libzbcvermaj" -ge "5" ; then
+if test "$libzbc" != "no" ; then
+  if compile_prog "" "-lzbc" "libzbc"; then
     libzbc="yes"
+    if ! check_min_lib_version libzbc 5; then
+      libzbc="no"
+    fi
   else
-    print_config "libzbc engine" "Unsupported libzbc version (version 5 or above required)"
-    libzbc="no"
-  fi
-else
-  if test "$libzbc" = "yes" ; then
+    if test "$libzbc" = "yes" ; then
       feature_not_found "libzbc" "libzbc or libzbc/zbc.h"
+    fi
+    libzbc="no"
   fi
-  libzbc="no"
 fi
 print_config "libzbc engine" "$libzbc"
 
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 471a3487..139495d3 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -77,6 +77,13 @@ check_reset_count() {
     eval "[ '$reset_count' '$1' '$2' ]"
 }
 
+# Check log for failed assertions and crashes. Without these checks,
+# a test can succeed even when these events happen, but it must fail.
+check_log() {
+     [ ! -f "${logfile}.${1}" ] && return 0
+     ! grep -q -e "Assertion " -e "Aborted " "${logfile}.${1}"
+}
+
 # Whether or not $1 (/dev/...) is a SCSI device.
 is_scsi_device() {
     local d f
@@ -1008,7 +1015,7 @@ trap 'intr=1' SIGINT
 for test_number in "${tests[@]}"; do
     rm -f "${logfile}.${test_number}"
     echo -n "Running test $(printf "%02d" $test_number) ... "
-    if eval "test$test_number"; then
+    if eval "test$test_number" && check_log $test_number; then
 	status="PASS"
 	cc_status="${green}${status}${end}"
 	((passed++))
diff --git a/zbd.c b/zbd.c
index 3eac5df3..e4a480b7 100644
--- a/zbd.c
+++ b/zbd.c
@@ -670,24 +670,33 @@ int zbd_setup_files(struct thread_data *td)
 	return 0;
 }
 
+static unsigned int zbd_zone_nr(struct zoned_block_device_info *zbd_info,
+				struct fio_zone_info *zone)
+{
+	return zone - zbd_info->zone_info;
+}
+
 /**
- * zbd_reset_range - reset zones for a range of sectors
+ * zbd_reset_zone - reset the write pointer of a single zone
  * @td: FIO thread data.
- * @f: Fio file for which to reset zones
- * @sector: Starting sector in units of 512 bytes
- * @nr_sectors: Number of sectors in units of 512 bytes
+ * @f: FIO file associated with the disk for which to reset a write pointer.
+ * @z: Zone to reset.
  *
  * Returns 0 upon success and a negative error code upon failure.
+ *
+ * The caller must hold z->mutex.
  */
-static int zbd_reset_range(struct thread_data *td, struct fio_file *f,
-			   uint64_t offset, uint64_t length)
+static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
+			  struct fio_zone_info *z)
 {
-	uint32_t zone_idx_b, zone_idx_e;
-	struct fio_zone_info *zb, *ze, *z;
+	uint64_t offset = z->start;
+	uint64_t length = (z+1)->start - offset;
 	int ret = 0;
 
 	assert(is_valid_offset(f, offset + length - 1));
 
+	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,
+		zbd_zone_nr(f->zbd_info, z));
 	switch (f->zbd_info->model) {
 	case ZBD_HOST_AWARE:
 	case ZBD_HOST_MANAGED:
@@ -699,48 +708,17 @@ static int zbd_reset_range(struct thread_data *td, struct fio_file *f,
 		break;
 	}
 
-	zone_idx_b = zbd_zone_idx(f, offset);
-	zb = &f->zbd_info->zone_info[zone_idx_b];
-	zone_idx_e = zbd_zone_idx(f, offset + length);
-	ze = &f->zbd_info->zone_info[zone_idx_e];
-	for (z = zb; z < ze; z++) {
-		pthread_mutex_lock(&z->mutex);
-		pthread_mutex_lock(&f->zbd_info->mutex);
-		f->zbd_info->sectors_with_data -= z->wp - z->start;
-		pthread_mutex_unlock(&f->zbd_info->mutex);
-		z->wp = z->start;
-		z->verify_block = 0;
-		pthread_mutex_unlock(&z->mutex);
-	}
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	f->zbd_info->sectors_with_data -= z->wp - z->start;
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+	z->wp = z->start;
+	z->verify_block = 0;
 
-	td->ts.nr_zone_resets += ze - zb;
+	td->ts.nr_zone_resets++;
 
 	return ret;
 }
 
-static unsigned int zbd_zone_nr(struct zoned_block_device_info *zbd_info,
-				struct fio_zone_info *zone)
-{
-	return zone - zbd_info->zone_info;
-}
-
-/**
- * zbd_reset_zone - reset the write pointer of a single zone
- * @td: FIO thread data.
- * @f: FIO file associated with the disk for which to reset a write pointer.
- * @z: Zone to reset.
- *
- * Returns 0 upon success and a negative error code upon failure.
- */
-static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
-			  struct fio_zone_info *z)
-{
-	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,
-		zbd_zone_nr(f->zbd_info, z));
-
-	return zbd_reset_range(td, f, z->start, zbd_zone_end(z) - z->start);
-}
-
 /* The caller must hold f->zbd_info->mutex */
 static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
 			   unsigned int open_zone_idx)

