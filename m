Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49468 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728749AbgDNMAX (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Apr 2020 08:00:23 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jOKEV-0005rC-R6
        for fio@vger.kernel.org; Tue, 14 Apr 2020 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200414120001.B8E8F1BC0176@kernel.dk>
Date: Tue, 14 Apr 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3f2dcb7f855d43244ec178aa2a34bb1475bf6901:

  Merge branch 'zbd-build' of https://github.com/vincentkfu/fio (2020-04-08 08:46:35 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 25dc6606fbbaca35aec3009c4ff9512ed02d41ba:

  zbd: fix sequential write pattern with verify= and max_open_zones= (2020-04-13 17:18:31 -0600)

----------------------------------------------------------------
Alexey Dobriyan (2):
      zbd: fix zonemode=zbd with NDEBUG
      zbd: fix sequential write pattern with verify= and max_open_zones=

Jens Axboe (1):
      Merge branch 'fix-cflags' of https://github.com/Hi-Angel/fio

Konstantin Kharlamov (1):
      configure/Makefile: don't override user CFLAGS

Shin'ichiro Kawasaki (3):
      t/zbd: Fix a bug in max_open_zones()
      t/zbd: Fix a bug in reset_zone() for all zones reset
      zbd: Ensure first I/O is write for random read/write to sequential zones

 Makefile        | 24 ++++++++++-----------
 configure       |  2 +-
 t/zbd/functions |  6 +++---
 zbd.c           | 66 ++++++++++++++++++++++++++++++++++++++++-----------------
 4 files changed, 62 insertions(+), 36 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 5bcd6064..cb9e1775 100644
--- a/Makefile
+++ b/Makefile
@@ -22,16 +22,16 @@ endif
 DEBUGFLAGS = -DFIO_INC_DEBUG
 CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFIO_INTERNAL $(DEBUGFLAGS)
 OPTFLAGS= -g -ffast-math
-CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR)
+CFLAGS	:= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR) $(CFLAGS)
 LIBS	+= -lm $(EXTLIBS)
 PROGS	= fio
 SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio tools/fiologparser.py tools/hist/fiologparser_hist.py tools/fio_jsonplus_clat2csv)
 
 ifndef CONFIG_FIO_NO_OPT
-  CFLAGS += -O3 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
+  CFLAGS := -O3 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 $(CFLAGS)
 endif
 ifdef CONFIG_BUILD_NATIVE
-  CFLAGS += -march=native
+  CFLAGS := -march=native $(CFLAGS)
 endif
 
 ifdef CONFIG_GFIO
@@ -55,27 +55,27 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
   HDFSLIB= -Wl,-rpath $(JAVA_HOME)/jre/lib/$(FIO_HDFS_CPU)/server -L$(JAVA_HOME)/jre/lib/$(FIO_HDFS_CPU)/server $(FIO_LIBHDFS_LIB)/libhdfs.a -ljvm
-  CFLAGS += $(HDFSFLAGS)
+  CFLAGS := $(HDFSFLAGS) $(CFLAGS)
   SOURCE += engines/libhdfs.c
 endif
 
 ifdef CONFIG_LIBISCSI
-  CFLAGS += $(LIBISCSI_CFLAGS)
+  CFLAGS := $(LIBISCSI_CFLAGS) $(CFLAGS)
   LIBS += $(LIBISCSI_LIBS)
   SOURCE += engines/libiscsi.c
 endif
 
 ifdef CONFIG_LIBNBD
-  CFLAGS += $(LIBNBD_CFLAGS)
+  CFLAGS := $(LIBNBD_CFLAGS) $(CFLAGS)
   LIBS += $(LIBNBD_LIBS)
   SOURCE += engines/nbd.c
 endif
 
 ifdef CONFIG_64BIT
-  CFLAGS += -DBITS_PER_LONG=64
+  CFLAGS := -DBITS_PER_LONG=64 $(CFLAGS)
 endif
 ifdef CONFIG_32BIT
-  CFLAGS += -DBITS_PER_LONG=32
+  CFLAGS := -DBITS_PER_LONG=32 $(CFLAGS)
 endif
 ifdef CONFIG_LIBAIO
   SOURCE += engines/libaio.c
@@ -140,7 +140,7 @@ ifdef CONFIG_GFAPI
   SOURCE += engines/glusterfs_sync.c
   SOURCE += engines/glusterfs_async.c
   ifdef CONFIG_GF_FADVISE
-    CFLAGS += "-DGFAPI_USE_FADVISE"
+    CFLAGS := "-DGFAPI_USE_FADVISE" $(CFLAGS)
   endif
 endif
 ifdef CONFIG_MTD
@@ -208,7 +208,7 @@ ifeq ($(CONFIG_TARGET_OS), AIX)
 endif
 ifeq ($(CONFIG_TARGET_OS), HP-UX)
   LIBS   += -lpthread -ldl -lrt
-  CFLAGS += -D_LARGEFILE64_SOURCE -D_XOPEN_SOURCE_EXTENDED
+  CFLAGS := -D_LARGEFILE64_SOURCE -D_XOPEN_SOURCE_EXTENDED $(CFLAGS)
 endif
 ifeq ($(CONFIG_TARGET_OS), Darwin)
   LIBS	 += -lpthread -ldl
@@ -217,7 +217,7 @@ ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
   SOURCE += os/windows/cpu-affinity.c os/windows/posix.c
   WINDOWS_OBJS = os/windows/cpu-affinity.o os/windows/posix.o lib/hweight.o
   LIBS	 += -lpthread -lpsapi -lws2_32 -lssp
-  CFLAGS += -DPSAPI_VERSION=1 -Ios/windows/posix/include -Wno-format
+  CFLAGS := -DPSAPI_VERSION=1 -Ios/windows/posix/include -Wno-format $(CFLAGS)
 endif
 
 OBJS := $(SOURCE:.c=.o)
@@ -386,7 +386,7 @@ FIO-VERSION-FILE: FORCE
 	@$(SHELL) $(SRCDIR)/FIO-VERSION-GEN
 -include FIO-VERSION-FILE
 
-override CFLAGS += -DFIO_VERSION='"$(FIO_VERSION)"'
+override CFLAGS := -DFIO_VERSION='"$(FIO_VERSION)"' $(CFLAGS)
 
 %.o : %.c
 	@mkdir -p $(dir $@)
diff --git a/configure b/configure
index ae2b3589..cf8b88e4 100755
--- a/configure
+++ b/configure
@@ -44,7 +44,7 @@ print_config() {
 }
 
 # Default CFLAGS
-CFLAGS="-D_GNU_SOURCE -include config-host.h"
+CFLAGS="-D_GNU_SOURCE -include config-host.h $CFLAGS"
 BUILD_CFLAGS=""
 
 # Print a helpful header at the top of config.log
diff --git a/t/zbd/functions b/t/zbd/functions
index 35087b15..1bd22ec4 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -43,7 +43,8 @@ max_open_zones() {
     local dev=$1
 
     if [ -n "${sg_inq}" ] && [ ! -n "${use_libzbc}" ]; then
-	if ! ${sg_inq} -e --page=0xB6 --len=20 --hex "$dev" 2> /dev/null; then
+	if ! ${sg_inq} -e --page=0xB6 --len=20 --hex "$dev" \
+		 > /dev/null 2>&1; then
 	    # Non scsi device such as null_blk can not return max open zones.
 	    # Use default value.
 	    echo 128
@@ -96,8 +97,7 @@ reset_zone() {
 
     if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then
 	if [ "$offset" -lt 0 ]; then
-	    sectors=$(<"/sys/class/block/${dev#/dev/}/size")
-	    ${blkzone} reset -o "${offset}" -l "$sectors" "$dev"
+	    ${blkzone} reset "$dev"
 	else
 	    ${blkzone} reset -o "${offset}" -c 1 "$dev"
 	fi
diff --git a/zbd.c b/zbd.c
index 0b0d4f40..de0c5bf4 100644
--- a/zbd.c
+++ b/zbd.c
@@ -687,6 +687,22 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	return zbd_reset_range(td, f, z->start, (z+1)->start - z->start);
 }
 
+/* The caller must hold f->zbd_info->mutex */
+static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
+			   unsigned int open_zone_idx)
+{
+	uint32_t zone_idx;
+
+	assert(open_zone_idx < f->zbd_info->num_open_zones);
+	zone_idx = f->zbd_info->open_zones[open_zone_idx];
+	memmove(f->zbd_info->open_zones + open_zone_idx,
+		f->zbd_info->open_zones + open_zone_idx + 1,
+		(ZBD_MAX_OPEN_ZONES - (open_zone_idx + 1)) *
+		sizeof(f->zbd_info->open_zones[0]));
+	f->zbd_info->num_open_zones--;
+	f->zbd_info->zone_info[zone_idx].open = 0;
+}
+
 /*
  * Reset a range of zones. Returns 0 upon success and 1 upon failure.
  * @td: fio thread data.
@@ -710,12 +726,26 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 	dprint(FD_ZBD, "%s: examining zones %u .. %u\n", f->file_name,
 		zbd_zone_nr(f->zbd_info, zb), zbd_zone_nr(f->zbd_info, ze));
 	for (z = zb; z < ze; z++) {
+		uint32_t nz = z - f->zbd_info->zone_info;
+
 		if (!zbd_zone_swr(z))
 			continue;
 		zone_lock(td, z);
-		reset_wp = all_zones ? z->wp != z->start :
-				(td->o.td_ddir & TD_DDIR_WRITE) &&
-				z->wp % min_bs != 0;
+		if (all_zones) {
+			unsigned int i;
+
+			pthread_mutex_lock(&f->zbd_info->mutex);
+			for (i = 0; i < f->zbd_info->num_open_zones; i++) {
+				if (f->zbd_info->open_zones[i] == nz)
+					zbd_close_zone(td, f, i);
+			}
+			pthread_mutex_unlock(&f->zbd_info->mutex);
+
+			reset_wp = z->wp != z->start;
+		} else {
+			reset_wp = (td->o.td_ddir & TD_DDIR_WRITE) &&
+					z->wp % min_bs != 0;
+		}
 		if (reset_wp) {
 			dprint(FD_ZBD, "%s: resetting zone %u\n",
 			       f->file_name,
@@ -905,22 +935,6 @@ out:
 	return res;
 }
 
-/* The caller must hold f->zbd_info->mutex */
-static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
-			   unsigned int open_zone_idx)
-{
-	uint32_t zone_idx;
-
-	assert(open_zone_idx < f->zbd_info->num_open_zones);
-	zone_idx = f->zbd_info->open_zones[open_zone_idx];
-	memmove(f->zbd_info->open_zones + open_zone_idx,
-		f->zbd_info->open_zones + open_zone_idx + 1,
-		(ZBD_MAX_OPEN_ZONES - (open_zone_idx + 1)) *
-		sizeof(f->zbd_info->open_zones[0]));
-	f->zbd_info->num_open_zones--;
-	f->zbd_info->zone_info[zone_idx].open = 0;
-}
-
 /* Anything goes as long as it is not a constant. */
 static uint32_t pick_random_zone_idx(const struct fio_file *f,
 				     const struct io_u *io_u)
@@ -1220,6 +1234,7 @@ static void zbd_put_io(const struct io_u *io_u)
 	struct zoned_block_device_info *zbd_info = f->zbd_info;
 	struct fio_zone_info *z;
 	uint32_t zone_idx;
+	int ret;
 
 	if (!zbd_info)
 		return;
@@ -1235,7 +1250,8 @@ static void zbd_put_io(const struct io_u *io_u)
 	       "%s: terminate I/O (%lld, %llu) for zone %u\n",
 	       f->file_name, io_u->offset, io_u->buflen, zone_idx);
 
-	assert(pthread_mutex_unlock(&z->mutex) == 0);
+	ret = pthread_mutex_unlock(&z->mutex);
+	assert(ret == 0);
 	zbd_check_swd(f);
 }
 
@@ -1348,6 +1364,16 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	if (!zbd_zone_swr(zb))
 		return io_u_accept;
 
+	/*
+	 * In case read direction is chosen for the first random I/O, fio with
+	 * zonemode=zbd stops because no data can be read from zoned block
+	 * devices with all empty zones. Overwrite the first I/O direction as
+	 * write to make sure data to read exists.
+	 */
+	if (td_rw(td) && !f->zbd_info->sectors_with_data
+	    && !td->o.read_beyond_wp)
+		io_u->ddir = DDIR_WRITE;
+
 	/*
 	 * Accept the I/O offset for reads if reading beyond the write pointer
 	 * is enabled.

