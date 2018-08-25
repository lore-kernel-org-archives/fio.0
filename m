Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52282 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbeHYPjM (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 25 Aug 2018 11:39:12 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ftXEr-0008CI-2o
        for fio@vger.kernel.org; Sat, 25 Aug 2018 12:00:22 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180825120002.8E9CC2C013C@kernel.dk>
Date: Sat, 25 Aug 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e7ff953f87d000d1de4c928493a6f67214cfcf8f:

  t/axmap: print explicit overlap ranges tested (2018-08-23 13:58:21 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 632b28a93154cb1be203d911f758d5932c0a8f86:

  Merge branch 'master' of https://github.com/bvanassche/fio (2018-08-24 18:22:13 -0600)

----------------------------------------------------------------
Bart Van Assche (12):
      configure: Add <linux/blkzoned.h> test
      Add the 'zbd' debug level
      Add the zonemode job option
      Introduce the io_u.post_submit callback function pointer
      Pass offset and buffer length explicitly to mark_random_map()
      Add two assert statements in mark_random_map()
      Add support for zoned block devices
      Collect and show zone reset statistics
      Make it possible to limit the number of open zones
      Add support for resetting zones periodically
      Add scripts for testing the fio zoned block device support code
      Fix the typehelp[] array

Jens Axboe (2):
      Merge branch 'zbd'
      Merge branch 'master' of https://github.com/bvanassche/fio

 HOWTO                                 |   88 ++-
 Makefile                              |    3 +
 cconv.c                               |    2 +
 configure                             |   21 +
 debug.h                               |    1 +
 file.h                                |    8 +
 filesetup.c                           |   15 +-
 fio.1                                 |   76 +-
 fio.h                                 |    2 +
 init.c                                |   29 +-
 io_u.c                                |   55 +-
 io_u.h                                |    6 +
 ioengines.c                           |   12 +
 options.c                             |   70 ++
 parse.c                               |   29 +-
 stat.c                                |   13 +-
 stat.h                                |    3 +
 t/zbd/functions                       |  106 +++
 t/zbd/run-tests-against-regular-nullb |   25 +
 t/zbd/run-tests-against-zoned-nullb   |   27 +
 t/zbd/test-zbd-support                |  817 +++++++++++++++++++++
 thread_options.h                      |   17 +
 zbd.c                                 | 1288 +++++++++++++++++++++++++++++++++
 zbd.h                                 |  142 ++++
 24 files changed, 2799 insertions(+), 56 deletions(-)
 create mode 100644 t/zbd/functions
 create mode 100755 t/zbd/run-tests-against-regular-nullb
 create mode 100755 t/zbd/run-tests-against-zoned-nullb
 create mode 100755 t/zbd/test-zbd-support
 create mode 100644 zbd.c
 create mode 100644 zbd.h

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 3839461..7bbd589 100644
--- a/HOWTO
+++ b/HOWTO
@@ -952,24 +952,92 @@ Target file/device
 
 	Unlink job files after each iteration or loop.  Default: false.
 
+.. option:: zonemode=str
+
+	Accepted values are:
+
+		**none**
+				The :option:`zonerange`, :option:`zonesize` and
+				:option:`zoneskip` parameters are ignored.
+		**strided**
+				I/O happens in a single zone until
+				:option:`zonesize` bytes have been transferred.
+				After that number of bytes has been
+				transferred processing of the next zone
+				starts.
+		**zbd**
+				Zoned block device mode. I/O happens
+				sequentially in each zone, even if random I/O
+				has been selected. Random I/O happens across
+				all zones instead of being restricted to a
+				single zone. The :option:`zoneskip` parameter
+				is ignored. :option:`zonerange` and
+				:option:`zonesize` must be identical.
+
 .. option:: zonerange=int
 
-	Size of a single zone in which I/O occurs. See also :option:`zonesize`
-	and :option:`zoneskip`.
+	Size of a single zone. See also :option:`zonesize` and
+	:option:`zoneskip`.
 
 .. option:: zonesize=int
 
-	Number of bytes to transfer before skipping :option:`zoneskip`
-	bytes. If this parameter is smaller than :option:`zonerange` then only
-	a fraction of each zone with :option:`zonerange` bytes will be
-	accessed.  If this parameter is larger than :option:`zonerange` then
-	each zone will be accessed multiple times before skipping
+	For :option:`zonemode` =strided, this is the number of bytes to
+	transfer before skipping :option:`zoneskip` bytes. If this parameter
+	is smaller than :option:`zonerange` then only a fraction of each zone
+	with :option:`zonerange` bytes will be accessed.  If this parameter is
+	larger than :option:`zonerange` then each zone will be accessed
+	multiple times before skipping to the next zone.
+
+	For :option:`zonemode` =zbd, this is the size of a single zone. The
+	:option:`zonerange` parameter is ignored in this mode.
 
 .. option:: zoneskip=int
 
-	Skip the specified number of bytes when :option:`zonesize` data have
-	been transferred. The three zone options can be used to do strided I/O
-	on a file.
+	For :option:`zonemode` =strided, the number of bytes to skip after
+	:option:`zonesize` bytes of data have been transferred. This parameter
+	must be zero for :option:`zonemode` =zbd.
+
+.. option:: read_beyond_wp=bool
+
+	This parameter applies to :option:`zonemode` =zbd only.
+
+	Zoned block devices are block devices that consist of multiple zones.
+	Each zone has a type, e.g. conventional or sequential. A conventional
+	zone can be written at any offset that is a multiple of the block
+	size. Sequential zones must be written sequentially. The position at
+	which a write must occur is called the write pointer. A zoned block
+	device can be either drive managed, host managed or host aware. For
+	host managed devices the host must ensure that writes happen
+	sequentially. Fio recognizes host managed devices and serializes
+	writes to sequential zones for these devices.
+
+	If a read occurs in a sequential zone beyond the write pointer then
+	the zoned block device will complete the read without reading any data
+	from the storage medium. Since such reads lead to unrealistically high
+	bandwidth and IOPS numbers fio only reads beyond the write pointer if
+	explicitly told to do so. Default: false.
+
+.. option:: max_open_zones=int
+
+	When running a random write test across an entire drive many more
+	zones will be open than in a typical application workload. Hence this
+	command line option that allows to limit the number of open zones. The
+	number of open zones is defined as the number of zones to which write
+	commands are issued.
+
+.. option:: zone_reset_threshold=float
+
+	A number between zero and one that indicates the ratio of logical
+	blocks with data to the total number of logical blocks in the test
+	above which zones should be reset periodically.
+
+.. option:: zone_reset_frequency=float
+
+	A number between zero and one that indicates how often a zone reset
+	should be issued if the zone reset threshold has been exceeded. A zone
+	reset is submitted after each (1 / zone_reset_frequency) write
+	requests. This and the previous parameter can be used to simulate
+	garbage collection activity.
 
 
 I/O type
diff --git a/Makefile b/Makefile
index e8e15fe..7e87b2f 100644
--- a/Makefile
+++ b/Makefile
@@ -148,6 +148,9 @@ endif
 ifdef CONFIG_IME
   SOURCE += engines/ime.c
 endif
+ifdef CONFIG_LINUX_BLKZONED
+  SOURCE += zbd.c
+endif
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
diff --git a/cconv.c b/cconv.c
index 534bfb0..1d7f6f2 100644
--- a/cconv.c
+++ b/cconv.c
@@ -223,6 +223,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->zone_range = le64_to_cpu(top->zone_range);
 	o->zone_size = le64_to_cpu(top->zone_size);
 	o->zone_skip = le64_to_cpu(top->zone_skip);
+	o->zone_mode = le32_to_cpu(top->zone_mode);
 	o->lockmem = le64_to_cpu(top->lockmem);
 	o->offset_increment = le64_to_cpu(top->offset_increment);
 	o->number_ios = le64_to_cpu(top->number_ios);
@@ -548,6 +549,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->zone_range = __cpu_to_le64(o->zone_range);
 	top->zone_size = __cpu_to_le64(o->zone_size);
 	top->zone_skip = __cpu_to_le64(o->zone_skip);
+	top->zone_mode = __cpu_to_le32(o->zone_mode);
 	top->lockmem = __cpu_to_le64(o->lockmem);
 	top->ddir_seq_add = __cpu_to_le64(o->ddir_seq_add);
 	top->file_size_low = __cpu_to_le64(o->file_size_low);
diff --git a/configure b/configure
index fb8b243..ab89df7 100755
--- a/configure
+++ b/configure
@@ -2195,6 +2195,24 @@ if compile_prog "" "" "valgrind_dev"; then
 fi
 print_config "Valgrind headers" "$valgrind_dev"
 
+##########################################
+# <linux/blkzoned.h> probe
+if test "$linux_blkzoned" != "yes" ; then
+  linux_blkzoned="no"
+fi
+cat > $TMPC << EOF
+#include <linux/blkzoned.h>
+int main(int argc, char **argv)
+{
+  return 0;
+}
+EOF
+if compile_prog "" "" "linux_blkzoned"; then
+  linux_blkzoned="yes"
+fi
+print_config "Zoned block device support" "$linux_blkzoned"
+
+##########################################
 # check march=armv8-a+crc+crypto
 if test "$march_armv8_a_crc_crypto" != "yes" ; then
   march_armv8_a_crc_crypto="no"
@@ -2519,6 +2537,9 @@ fi
 if test "$valgrind_dev" = "yes"; then
   output_sym "CONFIG_VALGRIND_DEV"
 fi
+if test "$linux_blkzoned" = "yes" ; then
+  output_sym "CONFIG_LINUX_BLKZONED"
+fi
 if test "$zlib" = "no" ; then
   echo "Consider installing zlib-dev (zlib-devel, some fio features depend on it."
   if test "$build_static" = "yes"; then
diff --git a/debug.h b/debug.h
index e5e8040..51b18de 100644
--- a/debug.h
+++ b/debug.h
@@ -22,6 +22,7 @@ enum {
 	FD_COMPRESS,
 	FD_STEADYSTATE,
 	FD_HELPERTHREAD,
+	FD_ZBD,
 	FD_DEBUG_MAX,
 };
 
diff --git a/file.h b/file.h
index c0a547e..446a1fb 100644
--- a/file.h
+++ b/file.h
@@ -10,6 +10,9 @@
 #include "lib/lfsr.h"
 #include "lib/gauss.h"
 
+/* Forward declarations */
+struct zoned_block_device_info;
+
 /*
  * The type of object we are working on
  */
@@ -98,6 +101,11 @@ struct fio_file {
 	uint64_t io_size;
 
 	/*
+	 * Zoned block device information. See also zonemode=zbd.
+	 */
+	struct zoned_block_device_info *zbd_info;
+
+	/*
 	 * Track last end and last start of IO for a given data direction
 	 */
 	uint64_t last_pos[DDIR_RWDIR_CNT];
diff --git a/filesetup.c b/filesetup.c
index 94a025e..580403d 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -14,6 +14,7 @@
 #include "hash.h"
 #include "lib/axmap.h"
 #include "rwlock.h"
+#include "zbd.h"
 
 #ifdef CONFIG_LINUX_FALLOCATE
 #include <linux/falloc.h>
@@ -1142,9 +1143,6 @@ int setup_files(struct thread_data *td)
 	if (err)
 		goto err_out;
 
-	if (!o->zone_size)
-		o->zone_size = o->size;
-
 	/*
 	 * iolog already set the total io size, if we read back
 	 * stored entries.
@@ -1161,7 +1159,14 @@ done:
 		td->done = 1;
 
 	td_restore_runstate(td, old_state);
+
+	if (td->o.zone_mode == ZONE_MODE_ZBD) {
+		err = zbd_init(td);
+		if (err)
+			goto err_out;
+	}
 	return 0;
+
 err_offset:
 	log_err("%s: you need to specify valid offset=\n", o->name);
 err_out:
@@ -1349,6 +1354,8 @@ void close_and_free_files(struct thread_data *td)
 			td_io_unlink_file(td, f);
 		}
 
+		zbd_free_zone_info(f);
+
 		if (use_free)
 			free(f->file_name);
 		else
@@ -1873,6 +1880,8 @@ void fio_file_reset(struct thread_data *td, struct fio_file *f)
 		axmap_reset(f->io_axmap);
 	else if (fio_file_lfsr(f))
 		lfsr_reset(&f->lfsr, td->rand_seeds[FIO_RAND_BLOCK_OFF]);
+
+	zbd_file_reset(td, f);
 }
 
 bool fio_files_done(struct thread_data *td)
diff --git a/fio.1 b/fio.1
index 4071947..b555b20 100644
--- a/fio.1
+++ b/fio.1
@@ -724,21 +724,79 @@ false.
 .BI unlink_each_loop \fR=\fPbool
 Unlink job files after each iteration or loop. Default: false.
 .TP
-Fio supports strided data access. After having read \fBzonesize\fR bytes from an area that is \fBzonerange\fR bytes big, \fBzoneskip\fR bytes are skipped.
+.BI zonemode \fR=\fPstr
+Accepted values are:
+.RS
+.RS
+.TP
+.B none
+The \fBzonerange\fR, \fBzonesize\fR and \fBzoneskip\fR parameters are ignored.
+.TP
+.B strided
+I/O happens in a single zone until \fBzonesize\fR bytes have been transferred.
+After that number of bytes has been transferred processing of the next zone
+starts.
+.TP
+.B zbd
+Zoned block device mode. I/O happens sequentially in each zone, even if random
+I/O has been selected. Random I/O happens across all zones instead of being
+restricted to a single zone.
+.RE
+.RE
 .TP
 .BI zonerange \fR=\fPint
-Size of a single zone in which I/O occurs.
+Size of a single zone. See also \fBzonesize\fR and \fBzoneskip\fR.
 .TP
 .BI zonesize \fR=\fPint
-Number of bytes to transfer before skipping \fBzoneskip\fR bytes. If this
-parameter is smaller than \fBzonerange\fR then only a fraction of each zone
-with \fBzonerange\fR bytes will be accessed.  If this parameter is larger than
-\fBzonerange\fR then each zone will be accessed multiple times before skipping
-to the next zone.
+For \fBzonemode\fR=strided, this is the number of bytes to transfer before
+skipping \fBzoneskip\fR bytes. If this parameter is smaller than
+\fBzonerange\fR then only a fraction of each zone with \fBzonerange\fR bytes
+will be accessed.  If this parameter is larger than \fBzonerange\fR then each
+zone will be accessed multiple times before skipping to the next zone.
+
+For \fBzonemode\fR=zbd, this is the size of a single zone. The \fBzonerange\fR
+parameter is ignored in this mode.
 .TP
 .BI zoneskip \fR=\fPint
-Skip the specified number of bytes after \fBzonesize\fR bytes of data have been
-transferred.
+For \fBzonemode\fR=strided, the number of bytes to skip after \fBzonesize\fR
+bytes of data have been transferred. This parameter must be zero for
+\fBzonemode\fR=zbd.
+
+.TP
+.BI read_beyond_wp \fR=\fPbool
+This parameter applies to \fBzonemode=zbd\fR only.
+
+Zoned block devices are block devices that consist of multiple zones. Each
+zone has a type, e.g. conventional or sequential. A conventional zone can be
+written at any offset that is a multiple of the block size. Sequential zones
+must be written sequentially. The position at which a write must occur is
+called the write pointer. A zoned block device can be either drive
+managed, host managed or host aware. For host managed devices the host must
+ensure that writes happen sequentially. Fio recognizes host managed devices
+and serializes writes to sequential zones for these devices.
+
+If a read occurs in a sequential zone beyond the write pointer then the zoned
+block device will complete the read without reading any data from the storage
+medium. Since such reads lead to unrealistically high bandwidth and IOPS
+numbers fio only reads beyond the write pointer if explicitly told to do
+so. Default: false.
+.TP
+.BI max_open_zones \fR=\fPint
+When running a random write test across an entire drive many more zones will be
+open than in a typical application workload. Hence this command line option
+that allows to limit the number of open zones. The number of open zones is
+defined as the number of zones to which write commands are issued.
+.TP
+.BI zone_reset_threshold \fR=\fPfloat
+A number between zero and one that indicates the ratio of logical blocks with
+data to the total number of logical blocks in the test above which zones
+should be reset periodically.
+.TP
+.BI zone_reset_frequency \fR=\fPfloat
+A number between zero and one that indicates how often a zone reset should be
+issued if the zone reset threshold has been exceeded. A zone reset is
+submitted after each (1 / zone_reset_frequency) write requests. This and the
+previous parameter can be used to simulate garbage collection activity.
 
 .SS "I/O type"
 .TP
diff --git a/fio.h b/fio.h
index 83654bb..42015d3 100644
--- a/fio.h
+++ b/fio.h
@@ -167,6 +167,8 @@ struct zone_split_index {
 	uint64_t size_prev;
 };
 
+#define FIO_MAX_OPEN_ZBD_ZONES 128
+
 /*
  * This describes a single thread/process executing a fio job.
  */
diff --git a/init.c b/init.c
index 3ed5757..b925b4c 100644
--- a/init.c
+++ b/init.c
@@ -618,17 +618,34 @@ static int fixup_options(struct thread_data *td)
 		ret |= warnings_fatal;
 	}
 
+	if (o->zone_mode == ZONE_MODE_NONE && o->zone_size) {
+		log_err("fio: --zonemode=none and --zonesize are not compatible.\n");
+		ret |= 1;
+	}
+
+	if (o->zone_mode == ZONE_MODE_STRIDED && !o->zone_size) {
+		log_err("fio: --zonesize must be specified when using --zonemode=strided.\n");
+		ret |= 1;
+	}
+
+	if (o->zone_mode == ZONE_MODE_NOT_SPECIFIED) {
+		if (o->zone_size)
+			o->zone_mode = ZONE_MODE_STRIDED;
+		else
+			o->zone_mode = ZONE_MODE_NONE;
+	}
+
 	/*
-	 * only really works with 1 file
+	 * Strided zone mode only really works with 1 file.
 	 */
-	if (o->zone_size && o->open_files > 1)
-		o->zone_size = 0;
+	if (o->zone_mode == ZONE_MODE_STRIDED && o->open_files > 1)
+		o->zone_mode = ZONE_MODE_NONE;
 
 	/*
 	 * If zone_range isn't specified, backward compatibility dictates it
 	 * should be made equal to zone_size.
 	 */
-	if (o->zone_size && !o->zone_range)
+	if (o->zone_mode == ZONE_MODE_STRIDED && !o->zone_range)
 		o->zone_range = o->zone_size;
 
 	/*
@@ -2263,6 +2280,10 @@ const struct debug_level debug_levels[] = {
 	  .help = "Helper thread logging",
 	  .shift = FD_HELPERTHREAD,
 	},
+	{ .name = "zbd",
+	  .help = "Zoned Block Device logging",
+	  .shift = FD_ZBD,
+	},
 	{ .name = NULL, },
 };
 
diff --git a/io_u.c b/io_u.c
index c58dcf0..3fbcf0f 100644
--- a/io_u.c
+++ b/io_u.c
@@ -10,6 +10,7 @@
 #include "err.h"
 #include "lib/pow2.h"
 #include "minmax.h"
+#include "zbd.h"
 
 struct io_completion_data {
 	int nr;				/* input */
@@ -31,21 +32,27 @@ static bool random_map_free(struct fio_file *f, const uint64_t block)
 /*
  * Mark a given offset as used in the map.
  */
-static void mark_random_map(struct thread_data *td, struct io_u *io_u)
+static uint64_t mark_random_map(struct thread_data *td, struct io_u *io_u,
+				uint64_t offset, uint64_t buflen)
 {
 	unsigned long long min_bs = td->o.min_bs[io_u->ddir];
 	struct fio_file *f = io_u->file;
 	unsigned long long nr_blocks;
 	uint64_t block;
 
-	block = (io_u->offset - f->file_offset) / (uint64_t) min_bs;
-	nr_blocks = (io_u->buflen + min_bs - 1) / min_bs;
+	block = (offset - f->file_offset) / (uint64_t) min_bs;
+	nr_blocks = (buflen + min_bs - 1) / min_bs;
+	assert(nr_blocks > 0);
 
-	if (!(io_u->flags & IO_U_F_BUSY_OK))
+	if (!(io_u->flags & IO_U_F_BUSY_OK)) {
 		nr_blocks = axmap_set_nr(f->io_axmap, block, nr_blocks);
+		assert(nr_blocks > 0);
+	}
+
+	if ((nr_blocks * min_bs) < buflen)
+		buflen = nr_blocks * min_bs;
 
-	if ((nr_blocks * min_bs) < io_u->buflen)
-		io_u->buflen = nr_blocks * min_bs;
+	return buflen;
 }
 
 static uint64_t last_block(struct thread_data *td, struct fio_file *f,
@@ -64,7 +71,7 @@ static uint64_t last_block(struct thread_data *td, struct fio_file *f,
 	if (max_size > f->real_file_size)
 		max_size = f->real_file_size;
 
-	if (td->o.zone_range)
+	if (td->o.zone_mode == ZONE_MODE_STRIDED && td->o.zone_range)
 		max_size = td->o.zone_range;
 
 	if (td->o.min_bs[ddir] > td->o.ba[ddir])
@@ -761,6 +768,11 @@ void put_file_log(struct thread_data *td, struct fio_file *f)
 
 void put_io_u(struct thread_data *td, struct io_u *io_u)
 {
+	if (io_u->post_submit) {
+		io_u->post_submit(io_u, io_u->error == 0);
+		io_u->post_submit = NULL;
+	}
+
 	if (td->parent)
 		td = td->parent;
 
@@ -815,10 +827,14 @@ void requeue_io_u(struct thread_data *td, struct io_u **io_u)
 	*io_u = NULL;
 }
 
-static void __fill_io_u_zone(struct thread_data *td, struct io_u *io_u)
+static void setup_strided_zone_mode(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
 
+	assert(td->o.zone_mode == ZONE_MODE_STRIDED);
+	assert(td->o.zone_size);
+	assert(td->o.zone_range);
+
 	/*
 	 * See if it's time to switch to a new zone
 	 */
@@ -857,6 +873,8 @@ static void __fill_io_u_zone(struct thread_data *td, struct io_u *io_u)
 static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 {
 	bool is_random;
+	uint64_t offset;
+	enum io_u_action ret;
 
 	if (td_ioengine_flagged(td, FIO_NOIO))
 		goto out;
@@ -869,11 +887,8 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	if (!ddir_rw(io_u->ddir))
 		goto out;
 
-	/*
-	 * When file is zoned zone_range is always positive
-	 */
-	if (td->o.zone_range)
-		__fill_io_u_zone(td, io_u);
+	if (td->o.zone_mode == ZONE_MODE_STRIDED)
+		setup_strided_zone_mode(td, io_u);
 
 	/*
 	 * No log, let the seq/rand engine retrieve the next buflen and
@@ -890,6 +905,13 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 		return 1;
 	}
 
+	offset = io_u->offset;
+	if (td->o.zone_mode == ZONE_MODE_ZBD) {
+		ret = zbd_adjust_block(td, io_u);
+		if (ret == io_u_eof)
+			return 1;
+	}
+
 	if (io_u->offset + io_u->buflen > io_u->file->real_file_size) {
 		dprint(FD_IO, "io_u %p, off=0x%llx + len=0x%llx exceeds file size=0x%llx\n",
 			io_u,
@@ -902,7 +924,7 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	 * mark entry before potentially trimming io_u
 	 */
 	if (td_random(td) && file_randommap(td, io_u->file))
-		mark_random_map(td, io_u);
+		io_u->buflen = mark_random_map(td, io_u, offset, io_u->buflen);
 
 out:
 	dprint_io_u(io_u, "fill");
@@ -1303,6 +1325,11 @@ static long set_io_u_file(struct thread_data *td, struct io_u *io_u)
 		if (!fill_io_u(td, io_u))
 			break;
 
+		if (io_u->post_submit) {
+			io_u->post_submit(io_u, false);
+			io_u->post_submit = NULL;
+		}
+
 		put_file_log(td, f);
 		td_io_close_file(td, f);
 		io_u->file = NULL;
diff --git a/io_u.h b/io_u.h
index 2e0fd3f..97270c9 100644
--- a/io_u.h
+++ b/io_u.h
@@ -93,6 +93,12 @@ struct io_u {
 	};
 
 	/*
+	 * Post-submit callback. Used by the ZBD code. @success == true means
+	 * that the I/O operation has been queued or completed successfully.
+	 */
+	void (*post_submit)(const struct io_u *, bool success);
+
+	/*
 	 * Callback for io completion
 	 */
 	int (*end_io)(struct thread_data *, struct io_u **);
diff --git a/ioengines.c b/ioengines.c
index 433da60..ba02952 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -18,6 +18,7 @@
 
 #include "fio.h"
 #include "diskutil.h"
+#include "zbd.h"
 
 static FLIST_HEAD(engine_list);
 
@@ -319,6 +320,10 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	}
 
 	ret = td->io_ops->queue(td, io_u);
+	if (ret != FIO_Q_BUSY && io_u->post_submit) {
+		io_u->post_submit(io_u, io_u->error == 0);
+		io_u->post_submit = NULL;
+	}
 
 	unlock_file(td, io_u->file);
 
@@ -350,6 +355,13 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 			 "invalid block size. Try setting direct=0.\n");
 	}
 
+	if (zbd_unaligned_write(io_u->error) &&
+	    td->io_issues[io_u->ddir & 1] == 1 &&
+	    td->o.zone_mode != ZONE_MODE_ZBD) {
+		log_info("fio: first I/O failed. If %s is a zoned block device, consider --zonemode=zbd\n",
+			 io_u->file->file_name);
+	}
+
 	if (!td->io_ops->commit) {
 		io_u_mark_submit(td, 1);
 		io_u_mark_complete(td, 1);
diff --git a/options.c b/options.c
index 86ab5d6..534233b 100644
--- a/options.c
+++ b/options.c
@@ -3240,6 +3240,30 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 #endif
 	{
+		.name	= "zonemode",
+		.lname	= "Zone mode",
+		.help	= "Mode for the zonesize, zonerange and zoneskip parameters",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct thread_options, zone_mode),
+		.def	= "none",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_ZONE,
+		.posval	= {
+			   { .ival = "none",
+			     .oval = ZONE_MODE_NONE,
+			     .help = "no zoning",
+			   },
+			   { .ival = "strided",
+			     .oval = ZONE_MODE_STRIDED,
+			     .help = "strided mode - random I/O is restricted to a single zone",
+			   },
+			   { .ival = "zbd",
+			     .oval = ZONE_MODE_ZBD,
+			     .help = "zoned block device mode - random I/O selects one of multiple zones randomly",
+			   },
+		},
+	},
+	{
 		.name	= "zonesize",
 		.lname	= "Zone size",
 		.type	= FIO_OPT_STR_VAL,
@@ -3273,6 +3297,52 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_ZONE,
 	},
 	{
+		.name	= "read_beyond_wp",
+		.lname	= "Allow reads beyond the zone write pointer",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, read_beyond_wp),
+		.help	= "Allow reads beyond the zone write pointer",
+		.def	= "0",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
+		.name	= "max_open_zones",
+		.lname	= "Maximum number of open zones",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, max_open_zones),
+		.maxval	= FIO_MAX_OPEN_ZBD_ZONES,
+		.help	= "Limit random writes to SMR drives to the specified"
+			  " number of sequential zones",
+		.def	= "0",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
+		.name	= "zone_reset_threshold",
+		.lname	= "Zone reset threshold",
+		.help	= "Zoned block device reset threshold",
+		.type	= FIO_OPT_FLOAT_LIST,
+		.maxlen	= 1,
+		.off1	= offsetof(struct thread_options, zrt),
+		.minfp	= 0,
+		.maxfp	= 1,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_ZONE,
+	},
+	{
+		.name	= "zone_reset_frequency",
+		.lname	= "Zone reset frequency",
+		.help	= "Zoned block device zone reset frequency in HZ",
+		.type	= FIO_OPT_FLOAT_LIST,
+		.maxlen	= 1,
+		.off1	= offsetof(struct thread_options, zrf),
+		.minfp	= 0,
+		.maxfp	= 1,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_ZONE,
+	},
+	{
 		.name	= "lockmem",
 		.lname	= "Lock memory",
 		.type	= FIO_OPT_STR_VAL,
diff --git a/parse.c b/parse.c
index 952118c..5d88d91 100644
--- a/parse.c
+++ b/parse.c
@@ -120,19 +120,22 @@ static void show_option_values(const struct fio_option *o)
 static void show_option_help(const struct fio_option *o, int is_err)
 {
 	const char *typehelp[] = {
-		"invalid",
-		"string (opt=bla)",
-		"string (opt=bla)",
-		"string with possible k/m/g postfix (opt=4k)",
-		"string with time postfix (opt=10s)",
-		"string (opt=bla)",
-		"string with dual range (opt=1k-4k,4k-8k)",
-		"integer value (opt=100)",
-		"boolean value (opt=1)",
-		"list of floating point values separated by ':' (opt=5.9:7.8)",
-		"no argument (opt)",
-		"deprecated",
-		"unsupported",
+		[FIO_OPT_INVALID]	  = "invalid",
+		[FIO_OPT_STR]		  = "string (opt=bla)",
+		[FIO_OPT_STR_ULL]	  = "string (opt=bla)",
+		[FIO_OPT_STR_MULTI]	  = "string with possible k/m/g postfix (opt=4k)",
+		[FIO_OPT_STR_VAL]	  = "string (opt=bla)",
+		[FIO_OPT_STR_VAL_TIME]	  = "string with time postfix (opt=10s)",
+		[FIO_OPT_STR_STORE]	  = "string (opt=bla)",
+		[FIO_OPT_RANGE]		  = "one to three ranges (opt=1k-4k[,4k-8k[,1k-8k]])",
+		[FIO_OPT_INT]		  = "integer value (opt=100)",
+		[FIO_OPT_ULL]		  = "integer value (opt=100)",
+		[FIO_OPT_BOOL]		  = "boolean value (opt=1)",
+		[FIO_OPT_FLOAT_LIST]	  = "list of floating point values separated by ':' (opt=5.9:7.8)",
+		[FIO_OPT_STR_SET]	  = "empty or boolean value ([0|1])",
+		[FIO_OPT_DEPRECATED]	  = "deprecated",
+		[FIO_OPT_SOFT_DEPRECATED] = "deprecated",
+		[FIO_OPT_UNSUPPORTED]	  = "unsupported",
 	};
 	ssize_t (*logger)(const char *format, ...);
 
diff --git a/stat.c b/stat.c
index 6cb704e..abdbb0e 100644
--- a/stat.c
+++ b/stat.c
@@ -14,6 +14,7 @@
 #include "lib/output_buffer.h"
 #include "helper_thread.h"
 #include "smalloc.h"
+#include "zbd.h"
 
 #define LOG_MSEC_SLACK	1
 
@@ -419,7 +420,7 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	unsigned long runt;
 	unsigned long long min, max, bw, iops;
 	double mean, dev;
-	char *io_p, *bw_p, *bw_p_alt, *iops_p;
+	char *io_p, *bw_p, *bw_p_alt, *iops_p, *zbd_w_st = NULL;
 	int i2p;
 
 	if (ddir_sync(ddir)) {
@@ -450,12 +451,16 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 
 	iops = (1000 * (uint64_t)ts->total_io_u[ddir]) / runt;
 	iops_p = num2str(iops, ts->sig_figs, 1, 0, N2S_NONE);
+	if (ddir == DDIR_WRITE)
+		zbd_w_st = zbd_write_status(ts);
 
-	log_buf(out, "  %s: IOPS=%s, BW=%s (%s)(%s/%llumsec)\n",
+	log_buf(out, "  %s: IOPS=%s, BW=%s (%s)(%s/%llumsec)%s\n",
 			rs->unified_rw_rep ? "mixed" : str[ddir],
 			iops_p, bw_p, bw_p_alt, io_p,
-			(unsigned long long) ts->runtime[ddir]);
+			(unsigned long long) ts->runtime[ddir],
+			zbd_w_st ? : "");
 
+	free(zbd_w_st);
 	free(io_p);
 	free(bw_p);
 	free(bw_p_alt);
@@ -1655,6 +1660,7 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 	dst->total_run_time += src->total_run_time;
 	dst->total_submit += src->total_submit;
 	dst->total_complete += src->total_complete;
+	dst->nr_zone_resets += src->nr_zone_resets;
 }
 
 void init_group_run_stat(struct group_run_stats *gs)
@@ -2337,6 +2343,7 @@ void reset_io_stats(struct thread_data *td)
 
 	ts->total_submit = 0;
 	ts->total_complete = 0;
+	ts->nr_zone_resets = 0;
 }
 
 static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
diff --git a/stat.h b/stat.h
index 5dcaae0..98de281 100644
--- a/stat.h
+++ b/stat.h
@@ -211,6 +211,9 @@ struct thread_stat {
 	uint32_t first_error;
 	uint64_t total_err_count;
 
+	/* ZBD stats */
+	uint64_t nr_zone_resets;
+
 	uint64_t nr_block_infos;
 	uint32_t block_infos[MAX_NR_BLOCK_INFOS];
 
diff --git a/t/zbd/functions b/t/zbd/functions
new file mode 100644
index 0000000..95f9bf4
--- /dev/null
+++ b/t/zbd/functions
@@ -0,0 +1,106 @@
+#!/bin/bash
+
+# To do: switch to blkzone once blkzone reset works correctly.
+blkzone=
+#blkzone=$(type -p blkzone 2>/dev/null)
+zbc_report_zones=$(type -p zbc_report_zones 2>/dev/null)
+zbc_reset_zone=$(type -p zbc_reset_zone 2>/dev/null)
+if [ -z "${blkzone}" ] &&
+       { [ -z "${zbc_report_zones}" ] || [ -z "${zbc_reset_zone}" ]; }; then
+    echo "Error: neither blkzone nor zbc_report_zones is available"
+    exit 1
+fi
+
+# Reports the starting sector and length of the first sequential zone of device
+# $1.
+first_sequential_zone() {
+    local dev=$1
+
+    if [ -n "${blkzone}" ]; then
+	${blkzone} report "$dev" |
+	    sed -n 's/^[[:blank:]]*start:[[:blank:]]\([0-9a-zA-Z]*\),[[:blank:]]len[[:blank:]]\([0-9a-zA-Z]*\),.*type:[[:blank:]]2(.*/\1 \2/p' |
+	    {
+		read -r starting_sector length &&
+		    # Convert from hex to decimal
+		    echo $((starting_sector)) $((length))
+	    }
+    else
+	${zbc_report_zones} "$dev" |
+	    sed -n 's/^Zone [0-9]*: type 0x2 .*, sector \([0-9]*\), \([0-9]*\) sectors,.*$/\1 \2/p' |
+	    head -n1
+    fi
+}
+
+max_open_zones() {
+    local dev=$1
+
+    if [ -n "${blkzone}" ]; then
+	# To do: query the maximum number of open zones using sg_raw
+	return 1
+    else
+	${zbc_report_zones} "$dev" |
+	    sed -n 's/^[[:blank:]]*Maximum number of open sequential write required zones:[[:blank:]]*//p'
+    fi
+}
+
+# Reset the write pointer of one zone on device $1 at offset $2. The offset
+# must be specified in units of 512 byte sectors. Offset -1 means reset all
+# zones.
+reset_zone() {
+    local dev=$1 offset=$2 sectors
+
+    if [ -n "${blkzone}" ]; then
+	if [ "$offset" -lt 0 ]; then
+	    sectors=$(<"/sys/class/block/${dev#/dev/}/size")
+	    ${blkzone} reset -o "${offset}" -l "$sectors" "$dev"
+	else
+	    ${blkzone} reset -o "${offset}" -c 1 "$dev"
+	fi
+    else
+	if [ "$offset" -lt 0 ]; then
+	    ${zbc_reset_zone} -all "$dev" "${offset}" >/dev/null
+	else
+	    ${zbc_reset_zone} -sector "$dev" "${offset}" >/dev/null
+	fi
+    fi
+}
+
+# Extract the number of bytes that have been transferred from a line like
+# READ: bw=6847KiB/s (7011kB/s), 6847KiB/s-6847KiB/s (7011kB/s-7011kB/s), io=257MiB (269MB), run=38406-38406msec
+fio_io() {
+    sed -n 's/^[[:blank:]]*'"$1"'.*, io=\([^[:blank:]]*\).*/\1/p' |
+	tail -n 1 |
+	(
+	    read -r io;
+	    # Parse <number>.<number><suffix> into n1, n2 and s. See also
+	    # num2str().
+	    shopt -s extglob
+	    n1=${io%${io##*([0-9])}}
+	    s=${io#${io%%*([a-zA-Z])}}
+	    n2=${io#${n1}}
+	    n2=${n2#.}
+	    n2=${n2%$s}000
+	    n2=${n2:0:3}
+	    case "$s" in
+		KiB) m=10;;
+		MiB) m=20;;
+		GiB) m=30;;
+		B)   m=0;;
+		*)   return 1;;
+	    esac
+	    [ -n "$n1" ] || return 1
+	    echo $(((n1 << m) + (n2 << m) / 1000))
+	)
+}
+
+fio_read() {
+    fio_io 'READ:'
+}
+
+fio_written() {
+    fio_io 'WRITE:'
+}
+
+fio_reset_count() {
+    sed -n 's/^.*write:[^;]*; \([0-9]*\) zone resets$/\1/p'
+}
diff --git a/t/zbd/run-tests-against-regular-nullb b/t/zbd/run-tests-against-regular-nullb
new file mode 100755
index 0000000..133c7c4
--- /dev/null
+++ b/t/zbd/run-tests-against-regular-nullb
@@ -0,0 +1,25 @@
+#!/bin/bash
+#
+# Copyright (C) 2018 Western Digital Corporation or its affiliates.
+#
+# This file is released under the GPL.
+
+for d in /sys/kernel/config/nullb/*; do [ -d "$d" ] && rmdir "$d"; done
+modprobe -r null_blk
+modprobe null_blk nr_devices=0 || return $?
+for d in /sys/kernel/config/nullb/*; do
+    [ -d "$d" ] && rmdir "$d"
+done
+modprobe -r null_blk
+[ -e /sys/module/null_blk ] && exit $?
+modprobe null_blk nr_devices=0 &&
+    cd /sys/kernel/config/nullb &&
+    mkdir nullb0 &&
+    cd nullb0 &&
+    echo 0 > completion_nsec &&
+    echo 4096 > blocksize &&
+    echo 1024 > size &&
+    echo 1 > memory_backed &&
+    echo 1 > power
+
+"$(dirname "$0")"/test-zbd-support "$@" /dev/nullb0
diff --git a/t/zbd/run-tests-against-zoned-nullb b/t/zbd/run-tests-against-zoned-nullb
new file mode 100755
index 0000000..7d9eb43
--- /dev/null
+++ b/t/zbd/run-tests-against-zoned-nullb
@@ -0,0 +1,27 @@
+#!/bin/bash
+#
+# Copyright (C) 2018 Western Digital Corporation or its affiliates.
+#
+# This file is released under the GPL.
+
+for d in /sys/kernel/config/nullb/*; do [ -d "$d" ] && rmdir "$d"; done
+modprobe -r null_blk
+modprobe null_blk nr_devices=0 || return $?
+for d in /sys/kernel/config/nullb/*; do
+    [ -d "$d" ] && rmdir "$d"
+done
+modprobe -r null_blk
+[ -e /sys/module/null_blk ] && exit $?
+modprobe null_blk nr_devices=0 &&
+    cd /sys/kernel/config/nullb &&
+    mkdir nullb0 &&
+    cd nullb0 &&
+    echo 1 > zoned &&
+    echo 1 > zone_size &&
+    echo 0 > completion_nsec &&
+    echo 4096 > blocksize &&
+    echo 1024 > size &&
+    echo 1 > memory_backed &&
+    echo 1 > power
+
+"$(dirname "$0")"/test-zbd-support "$@" /dev/nullb0
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
new file mode 100755
index 0000000..6ee5055
--- /dev/null
+++ b/t/zbd/test-zbd-support
@@ -0,0 +1,817 @@
+#!/bin/bash
+#
+# Copyright (C) 2018 Western Digital Corporation or its affiliates.
+#
+# This file is released under the GPL.
+
+usage() {
+    echo "Usage: $(basename "$0") [-d] [-e] [-r] [-v] [-t <test>] <SMR drive device node>"
+}
+
+max() {
+    if [ "$1" -gt "$2" ]; then
+	echo "$1"
+    else
+	echo "$2"
+    fi
+}
+
+min() {
+    if [ "$1" -lt "$2" ]; then
+	echo "$1"
+    else
+	echo "$2"
+    fi
+}
+
+set_io_scheduler() {
+    local dev=$1 sched=$2
+
+    [ -e "/sys/block/$dev" ] || return $?
+    if [ -e "/sys/block/$dev/mq" ]; then
+	case "$sched" in
+	    noop)        sched=none;;
+	    deadline)    sched=mq-deadline;;
+	esac
+    else
+	case "$sched" in
+	    none)        sched=noop;;
+	    mq-deadline) sched=deadline;;
+	esac
+    fi
+
+    echo "$sched" >"/sys/block/$dev/queue/scheduler"
+}
+
+check_read() {
+    local read
+
+    read=$(fio_read <"${logfile}.${test_number}")
+    echo "read: $read <> $1" >> "${logfile}.${test_number}"
+    [ "$read" = "$1" ]
+}
+
+check_written() {
+    local written
+
+    written=$(fio_written <"${logfile}.${test_number}")
+    echo "written: $written <> $1" >> "${logfile}.${test_number}"
+    [ "$written" = "$1" ]
+}
+
+# Compare the reset count from the log file with reset count $2 using operator
+# $1 (=, -ge, -gt, -le, -lt).
+check_reset_count() {
+    local reset_count
+
+    reset_count=$(fio_reset_count <"${logfile}.${test_number}")
+    echo "reset_count: test $reset_count $1 $2" >> "${logfile}.${test_number}"
+    eval "[ '$reset_count' '$1' '$2' ]"
+}
+
+# Whether or not $1 (/dev/...) is a SCSI device.
+is_scsi_device() {
+    local d f
+
+    d=$(basename "$dev")
+    for f in /sys/class/scsi_device/*/device/block/"$d"; do
+	[ -e "$f" ] && return 0
+    done
+    return 1
+}
+
+run_fio() {
+    local fio
+
+    fio=$(dirname "$0")/../../fio
+
+    { echo; echo "fio $*"; echo; } >>"${logfile}.${test_number}"
+
+    "${dynamic_analyzer[@]}" "$fio" "$@"
+}
+
+run_one_fio_job() {
+    local r
+
+    r=$(((RANDOM << 16) | RANDOM))
+    run_fio --name="$dev" --filename="$dev" "$@" --randseed="$r"	\
+	    --thread=1 --direct=1
+}
+
+# Run fio on the first four sequential zones of the disk.
+run_fio_on_seq() {
+    local opts=()
+
+    opts+=("--offset=$((first_sequential_zone_sector * 512))")
+    opts+=("--size=$((4 * zone_size))" "--zonemode=zbd")
+    if [ -z "$is_zbd" ]; then
+	opts+=("--zonesize=${zone_size}")
+    fi
+    run_one_fio_job "${opts[@]}" "$@"
+}
+
+# Check whether buffered writes are refused.
+test1() {
+    run_fio --name=job1 --filename="$dev" --rw=write --direct=0 --bs=4K	\
+	    --size="${zone_size}"					\
+	    --zonemode=zbd --zonesize="${zone_size}" 2>&1 |
+	tee -a "${logfile}.${test_number}" |
+	grep -q 'Using direct I/O is mandatory for writing to ZBD drives'
+    local fio_rc=${PIPESTATUS[0]} grep_rc=${PIPESTATUS[2]}
+    case "$fio_rc" in
+	0|1) ;;
+	*)   return "$fio_rc"
+    esac
+    if [ -n "$is_zbd" ]; then
+	[ "$grep_rc" = 0 ]
+    else
+	[ "$grep_rc" != 0 ]
+    fi
+}
+
+# Block size exceeds zone size.
+test2() {
+    local bs off opts=() rc
+
+    off=$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 512))
+    bs=$((2 * zone_size))
+    opts+=("--name=job1" "--filename=$dev" "--rw=write" "--direct=1")
+    opts+=("--zonemode=zbd" "--offset=$off" "--bs=$bs" "--size=$bs")
+    if [ -z "$is_zbd" ]; then
+	opts+=("--zonesize=${zone_size}")
+    fi
+    run_fio "${opts[@]}" 2>&1 |
+	tee -a "${logfile}.${test_number}" |
+	grep -q 'No I/O performed'
+}
+
+# Run fio against an empty zone. This causes fio to report "No I/O performed".
+test3() {
+    local off opts=() rc
+
+    off=$((first_sequential_zone_sector * 512 + 128 * zone_size))
+    size=$((zone_size))
+    [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
+    opts+=("--name=$dev" "--filename=$dev" "--offset=$off" "--bs=4K")
+    opts+=("--size=$size" "--zonemode=zbd")
+    opts+=("--ioengine=psync" "--rw=read" "--direct=1" "--thread=1")
+    if [ -z "$is_zbd" ]; then
+	opts+=("--zonesize=${zone_size}")
+    fi
+    run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
+    grep -q "No I/O performed" "${logfile}.${test_number}"
+    rc=$?
+    if [ -n "$is_zbd" ]; then
+	[ $rc = 0 ]
+    else
+	[ $rc != 0 ]
+    fi
+}
+
+# Run fio with --read_beyond_wp=1 against an empty zone.
+test4() {
+    local off opts=()
+
+    off=$((first_sequential_zone_sector * 512 + 129 * zone_size))
+    size=$((zone_size))
+    [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
+    opts+=("--name=$dev" "--filename=$dev" "--offset=$off" "--bs=$size")
+    opts+=("--size=$size" "--thread=1" "--read_beyond_wp=1")
+    opts+=("--ioengine=psync" "--rw=read" "--direct=1" "--disable_lat=1")
+    opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
+    run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
+    check_read $size || return $?
+}
+
+# Sequential write to sequential zones.
+test5() {
+    local size
+
+    size=$((4 * zone_size))
+    run_fio_on_seq --ioengine=psync --iodepth=1 --rw=write		\
+		   --bs="$(max $((zone_size / 64)) "$logical_block_size")"\
+		   --do_verify=1 --verify=md5				\
+		   >>"${logfile}.${test_number}" 2>&1 || return $?
+    check_written $size || return $?
+    check_read $size || return $?
+}
+
+# Sequential read from sequential zones. Must be run after test5.
+test6() {
+    local size
+
+    size=$((4 * zone_size))
+    run_fio_on_seq --ioengine=psync --iodepth=1 --rw=read		\
+		   --bs="$(max $((zone_size / 64)) "$logical_block_size")"\
+		   >>"${logfile}.${test_number}" 2>&1 || return $?
+    check_read $size || return $?
+}
+
+# Random write to sequential zones, libaio, queue depth 1.
+test7() {
+    local size=$((zone_size))
+
+    run_fio_on_seq --ioengine=libaio --iodepth=1 --rw=randwrite		\
+		   --bs="$(min 16384 "${zone_size}")"			\
+		   --do_verify=1 --verify=md5 --size="$size"		\
+		   >>"${logfile}.${test_number}" 2>&1 || return $?
+    check_written $size || return $?
+    check_read $size || return $?
+}
+
+# Random write to sequential zones, libaio, queue depth 64.
+test8() {
+    local size
+
+    size=$((4 * zone_size))
+    run_fio_on_seq --ioengine=libaio --iodepth=64 --rw=randwrite	\
+		   --bs="$(min 16384 "${zone_size}")"			\
+		   --do_verify=1 --verify=md5				\
+		   >>"${logfile}.${test_number}" 2>&1 || return $?
+    check_written $size || return $?
+    check_read $size || return $?
+}
+
+# Random write to sequential zones, sg, queue depth 1.
+test9() {
+    local size
+
+    if ! is_scsi_device "$dev"; then
+	echo "$dev is not a SCSI device" >>"${logfile}.${test_number}"
+	return 0
+    fi
+
+    size=$((4 * zone_size))
+    run_fio_on_seq --ioengine=sg --iodepth=1 --rw=randwrite --bs=16K	\
+		   --do_verify=1 --verify=md5				\
+		   >>"${logfile}.${test_number}" 2>&1 || return $?
+    check_written $size || return $?
+    check_read $size || return $?
+}
+
+# Random write to sequential zones, sg, queue depth 64.
+test10() {
+    local size
+
+    if ! is_scsi_device "$dev"; then
+	echo "$dev is not a SCSI device" >>"${logfile}.${test_number}"
+	return 0
+    fi
+
+    size=$((4 * zone_size))
+    run_fio_on_seq --ioengine=sg --iodepth=64 --rw=randwrite --bs=16K	\
+		   --do_verify=1 --verify=md5				\
+		   >>"${logfile}.${test_number}" 2>&1 || return $?
+    check_written $size || return $?
+    check_read $size || return $?
+}
+
+# Random write to sequential zones, libaio, queue depth 64, random block size.
+test11() {
+    local size
+
+    size=$((4 * zone_size))
+    run_fio_on_seq --ioengine=libaio --iodepth=64 --rw=randwrite	\
+		   --bsrange=4K-64K --do_verify=1 --verify=md5		\
+		   --debug=zbd >>"${logfile}.${test_number}" 2>&1 || return $?
+    check_written $size || return $?
+    check_read $size || return $?
+}
+
+# Random write to sequential zones, libaio, queue depth 64, max 1 open zone.
+test12() {
+    local size
+
+    size=$((8 * zone_size))
+    run_fio_on_seq --ioengine=libaio --iodepth=64 --rw=randwrite --bs=16K     \
+		   --max_open_zones=1 --size=$size --do_verify=1 --verify=md5 \
+		   --debug=zbd >>"${logfile}.${test_number}" 2>&1 || return $?
+    check_written $size || return $?
+    check_read $size || return $?
+}
+
+# Random write to sequential zones, libaio, queue depth 64, max 4 open zones.
+test13() {
+    local size
+
+    size=$((8 * zone_size))
+    run_fio_on_seq --ioengine=libaio --iodepth=64 --rw=randwrite --bs=16K     \
+		   --max_open_zones=4 --size=$size --do_verify=1 --verify=md5 \
+		   --debug=zbd						      \
+		   >>"${logfile}.${test_number}" 2>&1 || return $?
+    check_written $size || return $?
+    check_read $size || return $?
+}
+
+# Random write to conventional zones.
+test14() {
+    local size
+
+    size=$((16 * 2**20)) # 20 MB
+    if [ $size -gt $((first_sequential_zone_sector * 512)) ]; then
+	echo "$dev does not have enough sequential zones" \
+	     >>"${logfile}.${test_number}"
+	return 0
+    fi
+    run_one_fio_job --ioengine=libaio --iodepth=64 --rw=randwrite --bs=16K \
+		    --zonemode=zbd --zonesize="${zone_size}" --do_verify=1 \
+		    --verify=md5 --size=$size				   \
+		    >>"${logfile}.${test_number}" 2>&1 || return $?
+    check_written $((size)) || return $?
+    check_read $((size)) || return $?
+}
+
+# Sequential read on a mix of empty and full zones.
+test15() {
+    local i off size
+
+    for ((i=0;i<4;i++)); do
+	[ -n "$is_zbd" ] &&
+	    reset_zone "$dev" $((first_sequential_zone_sector +
+				 i*sectors_per_zone))
+    done
+    off=$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 512))
+    size=$((2 * zone_size))
+    run_one_fio_job --ioengine=psync --rw=write --bs=$((zone_size / 16))\
+		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off \
+		    --size=$size >>"${logfile}.${test_number}" 2>&1 ||
+	return $?
+    check_written $size || return $?
+    off=$((first_sequential_zone_sector * 512))
+    size=$((4 * zone_size))
+    run_one_fio_job --ioengine=psync --rw=read --bs=$((zone_size / 16))	\
+		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off \
+		    --size=$((size)) >>"${logfile}.${test_number}" 2>&1 ||
+	return $?
+    if [ -n "$is_zbd" ]; then
+	check_read $((size / 2))
+    else
+	check_read $size
+    fi
+}
+
+# Random read on a mix of empty and full zones. Must be run after test15.
+test16() {
+    local off size
+
+    off=$((first_sequential_zone_sector * 512))
+    size=$((4 * zone_size))
+    run_one_fio_job --ioengine=libaio --iodepth=64 --rw=randread --bs=16K \
+		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off \
+		    --size=$size >>"${logfile}.${test_number}" 2>&1 || return $?
+    check_read $size || return $?
+}
+
+# Random reads and writes in the last zone.
+test17() {
+    local io off read size written
+
+    off=$(((disk_size / zone_size - 1) * zone_size))
+    size=$((disk_size - off))
+    # Overwrite the last zone to avoid that reading from that zone fails.
+    if [ -n "$is_zbd" ]; then
+	reset_zone "$dev" $((off / 512)) || return $?
+    fi
+    run_one_fio_job --ioengine=psync --rw=write --offset="$off"		\
+		    --zonemode=zbd --zonesize="${zone_size}"		\
+		    --bs="$zone_size" --size="$zone_size"		\
+		    >>"${logfile}.${test_number}" 2>&1 || return $?
+    check_written "$zone_size" || return $?
+    run_one_fio_job --ioengine=libaio --iodepth=8 --rw=randrw --bs=4K	\
+		    --zonemode=zbd --zonesize="${zone_size}"		\
+		    --offset=$off --loops=2 --norandommap=1\
+		    >>"${logfile}.${test_number}" 2>&1 || return $?
+    written=$(fio_written <"${logfile}.${test_number}")
+    read=$(fio_read <"${logfile}.${test_number}")
+    io=$((written + read))
+    echo "Total number of bytes read and written: $io <> $size" \
+	 >>"${logfile}.${test_number}"
+    [ $io = $((size * 2)) ];
+}
+
+# Out-of-range zone reset threshold and frequency parameters.
+test18() {
+    run_fio_on_seq --zone_reset_threshold=-1 |&
+	tee -a "${logfile}.${test_number}"   |
+	    grep -q 'value out of range' || return $?
+}
+
+test19() {
+    run_fio_on_seq --zone_reset_threshold=2  |&
+	tee -a "${logfile}.${test_number}"   |
+	grep -q 'value out of range' || return $?
+}
+
+test20() {
+    run_fio_on_seq --zone_reset_threshold=.4:.6 |&
+	tee -a "${logfile}.${test_number}"   |
+	grep -q 'the list exceeding max length' || return $?
+}
+
+test21() {
+    run_fio_on_seq --zone_reset_frequency=-1 |&
+	tee -a "${logfile}.${test_number}"   |
+	grep -q 'value out of range' || return $?
+}
+
+test22() {
+    run_fio_on_seq --zone_reset_frequency=2  |&
+	tee -a "${logfile}.${test_number}"   |
+	grep -q 'value out of range' || return $?
+}
+
+test23() {
+    run_fio_on_seq --zone_reset_frequency=.4:.6  |&
+	tee -a "${logfile}.${test_number}"   |
+	grep -q 'the list exceeding max length' || return $?
+}
+
+test24() {
+    local bs loops=9 size=$((zone_size))
+
+    bs=$(min $((256*1024)) "$zone_size")
+    run_fio_on_seq --ioengine=psync --rw=write --bs="$bs" --size=$size	 \
+		   --loops=$loops					 \
+		   --zone_reset_frequency=.01 --zone_reset_threshold=.90 \
+		   >> "${logfile}.${test_number}" 2>&1 || return $?
+    check_written $((size * loops)) || return $?
+    check_reset_count -eq 8 ||
+	check_reset_count -eq 9 ||
+	check_reset_count -eq 10 || return $?
+}
+
+# Multiple non-overlapping sequential write jobs for the same drive.
+test25() {
+    local i opts=()
+
+    for ((i=0;i<16;i++)); do
+        [ -n "$is_zbd" ] &&
+	    reset_zone "$dev" $((first_sequential_zone_sector + i*sectors_per_zone))
+    done
+    for ((i=0;i<16;i++)); do
+	opts+=("--name=job$i" "--filename=$dev" "--thread=1" "--direct=1")
+	opts+=("--offset=$((first_sequential_zone_sector*512 + zone_size*i))")
+	opts+=("--size=$zone_size" "--ioengine=psync" "--rw=write" "--bs=16K")
+	opts+=("--zonemode=zbd" "--zonesize=${zone_size}" "--group_reporting=1")
+    done
+    run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
+write_to_first_seq_zone() {
+    local loops=4 r
+
+    r=$(((RANDOM << 16) | RANDOM))
+    run_fio --name="$dev" --filename="$dev" --ioengine=psync --rw="$1"	\
+	    --thread=1 --do_verify=1 --verify=md5 --direct=1 --bs=4K	\
+	    --offset=$((first_sequential_zone_sector * 512))		\
+	    "--size=$zone_size" --loops=$loops --randseed="$r"		\
+	    --zonemode=zbd --zonesize="${zone_size}" --group_reporting=1	\
+	    --gtod_reduce=1 >> "${logfile}.${test_number}" 2>&1 || return $?
+    check_written $((loops * zone_size)) || return $?
+}
+
+# Overwrite the first sequential zone four times sequentially.
+test26() {
+    write_to_first_seq_zone write
+}
+
+# Overwrite the first sequential zone four times using random writes.
+test27() {
+    write_to_first_seq_zone randwrite
+}
+
+# Multiple overlapping random write jobs for the same drive.
+test28() {
+    local i jobs=16 off opts
+
+    off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
+    [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
+    opts=("--debug=zbd")
+    for ((i=0;i<jobs;i++)); do
+	opts+=("--name=job$i" "--filename=$dev" "--offset=$off" "--bs=16K")
+	opts+=("--size=$zone_size" "--ioengine=psync" "--rw=randwrite")
+	opts+=("--thread=1" "--direct=1" "--zonemode=zbd")
+	opts+=("--zonesize=${zone_size}" "--group_reporting=1")
+    done
+    run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
+    check_written $((jobs * zone_size)) || return $?
+    check_reset_count -eq $jobs ||
+	check_reset_count -eq $((jobs - 1)) ||
+	return $?
+}
+
+# Multiple overlapping random write jobs for the same drive and with a limited
+# number of open zones.
+test29() {
+    local i jobs=16 off opts=()
+
+    off=$((first_sequential_zone_sector * 512 + 64 * zone_size))
+    size=$((16*zone_size))
+    [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
+    opts=("--debug=zbd")
+    for ((i=0;i<jobs;i++)); do
+	opts+=("--name=job$i" "--filename=$dev" "--offset=$off" "--bs=16K")
+	opts+=("--size=$size" "--io_size=$zone_size" "--thread=1")
+	opts+=("--ioengine=psync" "--rw=randwrite" "--direct=1")
+	opts+=("--max_open_zones=4" "--group_reporting=1")
+	opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
+    done
+    run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
+    check_written $((jobs * zone_size)) || return $?
+}
+
+# Random reads and writes across the entire disk for 30s.
+test30() {
+    local off
+
+    off=$((first_sequential_zone_sector * 512))
+    run_one_fio_job --ioengine=libaio --iodepth=8 --rw=randrw		\
+		    --bs="$(max $((zone_size / 128)) "$logical_block_size")"\
+		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off\
+		    --loops=2 --time_based --runtime=30s --norandommap=1\
+		    >>"${logfile}.${test_number}" 2>&1
+}
+
+# Random reads across all sequential zones for 30s. This is not only a fio
+# test but also allows to verify the performance of a drive.
+test31() {
+    local bs inc nz off opts size
+
+    # Start with writing 128 KB to 128 sequential zones.
+    bs=128K
+    nz=128
+    # shellcheck disable=SC2017
+    inc=$(((disk_size - (first_sequential_zone_sector * 512)) / (nz * zone_size)
+	   * zone_size))
+    opts=()
+    for ((off = first_sequential_zone_sector * 512; off < disk_size;
+	  off += inc)); do
+	opts+=("--name=$dev" "--filename=$dev" "--offset=$off" "--io_size=$bs")
+	opts+=("--bs=$bs" "--size=$zone_size" "--ioengine=libaio")
+	opts+=("--rw=write" "--direct=1" "--thread=1" "--stats=0")
+	opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
+    done
+    "$(dirname "$0")/../../fio" "${opts[@]}" >> "${logfile}.${test_number}" 2>&1
+    # Next, run the test.
+    off=$((first_sequential_zone_sector * 512))
+    size=$((disk_size - off))
+    opts=("--name=$dev" "--filename=$dev" "--offset=$off" "--size=$size")
+    opts+=("--bs=$bs" "--ioengine=psync" "--rw=randread" "--direct=1")
+    opts+=("--thread=1" "--time_based" "--runtime=30" "--zonemode=zbd")
+    opts+=("--zonesize=${zone_size}")
+    run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
+# Random writes across all sequential zones. This is not only a fio test but
+# also allows to verify the performance of a drive.
+test32() {
+    local off opts=() size
+
+    off=$((first_sequential_zone_sector * 512))
+    size=$((disk_size - off))
+    opts+=("--name=$dev" "--filename=$dev" "--offset=$off" "--size=$size")
+    opts+=("--bs=128K" "--ioengine=psync" "--rw=randwrite" "--direct=1")
+    opts+=("--thread=1" "--time_based" "--runtime=30")
+    opts+=("--max_open_zones=$max_open_zones" "--zonemode=zbd")
+    opts+=("--zonesize=${zone_size}")
+    run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
+# Write to sequential zones with a block size that is not a divisor of the
+# zone size.
+test33() {
+    local bs io_size size
+
+    size=$((2 * zone_size))
+    io_size=$((5 * zone_size))
+    bs=$((3 * zone_size / 4))
+    run_fio_on_seq --ioengine=psync --iodepth=1 --rw=write --size=$size	\
+		   --io_size=$io_size --bs=$bs				\
+		   >> "${logfile}.${test_number}" 2>&1 || return $?
+    check_written $(((io_size + bs - 1) / bs * bs)) || return $?
+}
+
+# Write to sequential zones with a block size that is not a divisor of the
+# zone size and with data verification enabled.
+test34() {
+    local size
+
+    size=$((2 * zone_size))
+    run_fio_on_seq --ioengine=psync --iodepth=1 --rw=write --size=$size	  \
+		   --do_verify=1 --verify=md5 --bs=$((3 * zone_size / 4)) \
+		   >> "${logfile}.${test_number}" 2>&1 && return 1
+    grep -q 'not a divisor of' "${logfile}.${test_number}"
+}
+
+# Test 1/4 for the I/O boundary rounding code: $size < $zone_size.
+test35() {
+    local bs off io_size size
+
+    off=$(((first_sequential_zone_sector + 1) * 512))
+    size=$((zone_size - 2 * 512))
+    bs=$((zone_size / 4))
+    run_one_fio_job --offset=$off --size=$size --ioengine=psync	--iodepth=1 \
+		    --rw=write --do_verify=1 --verify=md5 --bs=$bs	    \
+		    --zonemode=zbd --zonesize="${zone_size}"		    \
+		    >> "${logfile}.${test_number}" 2>&1 && return 1
+    grep -q 'io_size must be at least one zone' "${logfile}.${test_number}"
+}
+
+# Test 2/4 for the I/O boundary rounding code: $size < $zone_size.
+test36() {
+    local bs off io_size size
+
+    off=$(((first_sequential_zone_sector) * 512))
+    size=$((zone_size - 512))
+    bs=$((zone_size / 4))
+    run_one_fio_job --offset=$off --size=$size --ioengine=psync	--iodepth=1 \
+		    --rw=write --do_verify=1 --verify=md5 --bs=$bs	    \
+		    --zonemode=zbd --zonesize="${zone_size}"		    \
+		    >> "${logfile}.${test_number}" 2>&1 && return 1
+    grep -q 'io_size must be at least one zone' "${logfile}.${test_number}"
+}
+
+# Test 3/4 for the I/O boundary rounding code: $size > $zone_size.
+test37() {
+    local bs off size
+
+    if [ "$first_sequential_zone_sector" = 0 ]; then
+	off=0
+    else
+	off=$(((first_sequential_zone_sector - 1) * 512))
+    fi
+    size=$((zone_size + 2 * 512))
+    bs=$((zone_size / 4))
+    run_one_fio_job --offset=$off --size=$size --ioengine=psync	--iodepth=1 \
+		    --rw=write --do_verify=1 --verify=md5 --bs=$bs	    \
+		    --zonemode=zbd --zonesize="${zone_size}"		    \
+		    >> "${logfile}.${test_number}" 2>&1
+    check_written $((zone_size)) || return $?
+}
+
+# Test 4/4 for the I/O boundary rounding code: $offset > $disk_size - $zone_size
+test38() {
+    local bs off size
+
+    size=$((logical_block_size))
+    off=$((disk_size - logical_block_size))
+    bs=$((logical_block_size))
+    run_one_fio_job --offset=$off --size=$size --ioengine=psync	--iodepth=1 \
+		    --rw=write --do_verify=1 --verify=md5 --bs=$bs	    \
+		    --zonemode=zbd --zonesize="${zone_size}"		    \
+		    >> "${logfile}.${test_number}" 2>&1 && return 1
+    grep -q 'io_size must be at least one zone' "${logfile}.${test_number}"
+}
+
+# Read one block from a block device.
+read_one_block() {
+    local bs
+
+    bs=$((logical_block_size))
+    run_one_fio_job --rw=read --ioengine=psync --bs=$bs --size=$bs "$@" 2>&1 |
+	tee -a "${logfile}.${test_number}"
+}
+
+# Check whether fio accepts --zonemode=none for zoned block devices.
+test39() {
+    [ -n "$is_zbd" ] || return 0
+    read_one_block --zonemode=none >/dev/null || return $?
+    check_read $((logical_block_size)) || return $?
+}
+
+# Check whether fio accepts --zonemode=strided for zoned block devices.
+test40() {
+    local bs
+
+    bs=$((logical_block_size))
+    [ -n "$is_zbd" ] || return 0
+    read_one_block --zonemode=strided |
+	grep -q 'fio: --zonesize must be specified when using --zonemode=strided' ||
+	return $?
+    read_one_block --zonemode=strided --zonesize=$bs >/dev/null || return $?
+    check_read $bs || return $?
+}
+
+# Check whether fio checks the zone size for zoned block devices.
+test41() {
+    [ -n "$is_zbd" ] || return 0
+    read_one_block --zonemode=zbd --zonesize=$((2 * zone_size)) |
+	grep -q 'job parameter zonesize.*does not match disk zone size'
+}
+
+# Check whether fio handles --zonesize=0 correctly for regular block devices.
+test42() {
+    [ -n "$is_zbd" ] && return 0
+    read_one_block --zonemode=zbd --zonesize=0 |
+	grep -q 'Specifying the zone size is mandatory for regular block devices with --zonemode=zbd'
+}
+
+# Check whether fio handles --zonesize=1 correctly.
+test43() {
+    read_one_block --zonemode=zbd --zonesize=1 |
+	grep -q 'zone size must be at least 512 bytes for --zonemode=zbd'
+}
+
+# Check whether fio handles --zonemode=none --zonesize=1 correctly.
+test44() {
+    read_one_block --zonemode=none --zonesize=1 |
+	grep -q 'fio: --zonemode=none and --zonesize are not compatible'
+}
+
+test45() {
+    local bs i
+
+    [ -z "$is_zbd" ] && return 0
+    bs=$((logical_block_size))
+    run_one_fio_job --ioengine=psync --iodepth=1 --rw=randwrite --bs=$bs\
+		    --offset=$((first_sequential_zone_sector * 512)) \
+		    --size="$zone_size" --do_verify=1 --verify=md5 2>&1 |
+	tee -a "${logfile}.${test_number}" |
+	grep -q "fio: first I/O failed. If .* is a zoned block device, consider --zonemode=zbd"
+}
+
+tests=()
+dynamic_analyzer=()
+reset_all_zones=
+
+while [ "${1#-}" != "$1" ]; do
+  case "$1" in
+    -d) dynamic_analyzer=(valgrind "--read-var-info=yes" "--tool=drd"
+			  "--show-confl-seg=no");
+	shift;;
+    -e) dynamic_analyzer=(valgrind "--read-var-info=yes" "--tool=helgrind");
+	shift;;
+    -r) reset_all_zones=1; shift;;
+    -t) tests+=("$2"); shift; shift;;
+    -v) dynamic_analyzer=(valgrind "--read-var-info=yes");
+	shift;;
+    --) shift; break;;
+  esac
+done
+
+if [ $# != 1 ]; then
+    usage
+    exit 1
+fi
+
+# shellcheck source=functions
+source "$(dirname "$0")/functions" || exit $?
+
+dev=$1
+realdev=$(readlink -f "$dev")
+basename=$(basename "$realdev")
+disk_size=$(($(<"/sys/block/$basename/size")*512))
+logical_block_size=$(<"/sys/block/$basename/queue/logical_block_size")
+case "$(<"/sys/class/block/$basename/queue/zoned")" in
+    host-managed|host-aware)
+	is_zbd=true
+	if ! result=($(first_sequential_zone "$dev")); then
+	    echo "Failed to determine first sequential zone"
+	    exit 1
+	fi
+	first_sequential_zone_sector=${result[0]}
+	sectors_per_zone=${result[1]}
+	zone_size=$((sectors_per_zone * 512))
+	if ! max_open_zones=$(max_open_zones "$dev"); then
+	    echo "Failed to determine maximum number of open zones"
+	    exit 1
+	fi
+	echo "First sequential zone starts at sector $first_sequential_zone_sector; zone size: $((zone_size >> 20)) MB"
+	set_io_scheduler "$basename" deadline || exit $?
+	if [ -n "$reset_all_zones" ]; then
+	    reset_zone "$dev" -1
+	fi
+	;;
+    *)
+	first_sequential_zone_sector=$(((disk_size / 2) &
+					(logical_block_size - 1)))
+	zone_size=$(max 65536 "$logical_block_size")
+	sectors_per_zone=$((zone_size / 512))
+	max_open_zones=128
+	set_io_scheduler "$basename" none || exit $?
+	;;
+esac
+
+if [ "${#tests[@]}" = 0 ]; then
+    for ((i=1;i<=45;i++)); do
+	tests+=("$i")
+    done
+fi
+
+logfile=$0.log
+
+rc=0
+for test_number in "${tests[@]}"; do
+    rm -f "${logfile}.${test_number}"
+    echo -n "Running test $test_number ... "
+    if eval "test$test_number"; then
+	status="PASS"
+    else
+	status="FAIL"
+	rc=1
+    fi
+    echo "$status"
+    echo "$status" >> "${logfile}.${test_number}"
+done
+
+exit $rc
diff --git a/thread_options.h b/thread_options.h
index 8bbf54b..3931583 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -10,6 +10,14 @@
 #include "lib/pattern.h"
 #include "td_error.h"
 
+enum fio_zone_mode {
+	ZONE_MODE_NOT_SPECIFIED	= 0,
+	ZONE_MODE_NONE		= 1,
+	ZONE_MODE_STRIDED	= 2, /* perform I/O in one zone at a time */
+	/* perform I/O across multiple zones simultaneously */
+	ZONE_MODE_ZBD		= 3,
+};
+
 /*
  * What type of allocation to use for io buffers
  */
@@ -188,6 +196,7 @@ struct thread_options {
 	unsigned long long zone_range;
 	unsigned long long zone_size;
 	unsigned long long zone_skip;
+	enum fio_zone_mode zone_mode;
 	unsigned long long lockmem;
 	enum fio_memtype mem_type;
 	unsigned int mem_align;
@@ -325,6 +334,12 @@ struct thread_options {
 
 	unsigned int allow_create;
 	unsigned int allow_mounted_write;
+
+	/* Parameters that affect zonemode=zbd */
+	unsigned int read_beyond_wp;
+	int max_open_zones;
+	fio_fp64_t zrt;
+	fio_fp64_t zrf;
 };
 
 #define FIO_TOP_STR_MAX		256
@@ -601,6 +616,8 @@ struct thread_options_pack {
 
 	uint32_t allow_create;
 	uint32_t allow_mounted_write;
+
+	uint32_t zone_mode;
 } __attribute__((packed));
 
 extern void convert_thread_options_to_cpu(struct thread_options *o, struct thread_options_pack *top);
diff --git a/zbd.c b/zbd.c
new file mode 100644
index 0000000..5619769
--- /dev/null
+++ b/zbd.c
@@ -0,0 +1,1288 @@
+/*
+ * Copyright (C) 2018 Western Digital Corporation or its affiliates.
+ *
+ * This file is released under the GPL.
+ */
+
+#include <errno.h>
+#include <string.h>
+#include <stdlib.h>
+#include <dirent.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <linux/blkzoned.h>
+#include "file.h"
+#include "fio.h"
+#include "lib/pow2.h"
+#include "log.h"
+#include "smalloc.h"
+#include "verify.h"
+#include "zbd.h"
+
+/**
+ * zbd_zone_idx - convert an offset into a zone number
+ * @f: file pointer.
+ * @offset: offset in bytes. If this offset is in the first zone_size bytes
+ *	    past the disk size then the index of the sentinel is returned.
+ */
+static uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
+{
+	uint32_t zone_idx;
+
+	if (f->zbd_info->zone_size_log2)
+		zone_idx = offset >> f->zbd_info->zone_size_log2;
+	else
+		zone_idx = (offset >> 9) / f->zbd_info->zone_size;
+
+	return min(zone_idx, f->zbd_info->nr_zones);
+}
+
+/**
+ * zbd_zone_full - verify whether a minimum number of bytes remain in a zone
+ * @f: file pointer.
+ * @z: zone info pointer.
+ * @required: minimum number of bytes that must remain in a zone.
+ *
+ * The caller must hold z->mutex.
+ */
+static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
+			  uint64_t required)
+{
+	assert((required & 511) == 0);
+
+	return z->type == BLK_ZONE_TYPE_SEQWRITE_REQ &&
+		z->wp + (required >> 9) > z->start + f->zbd_info->zone_size;
+}
+
+static bool is_valid_offset(const struct fio_file *f, uint64_t offset)
+{
+	return (uint64_t)(offset - f->file_offset) < f->io_size;
+}
+
+/* Verify whether direct I/O is used for all host-managed zoned drives. */
+static bool zbd_using_direct_io(void)
+{
+	struct thread_data *td;
+	struct fio_file *f;
+	int i, j;
+
+	for_each_td(td, i) {
+		if (td->o.odirect || !(td->o.td_ddir & TD_DDIR_WRITE))
+			continue;
+		for_each_file(td, f, j) {
+			if (f->zbd_info &&
+			    f->zbd_info->model == ZBD_DM_HOST_MANAGED)
+				return false;
+		}
+	}
+
+	return true;
+}
+
+/* Whether or not the I/O range for f includes one or more sequential zones */
+static bool zbd_is_seq_job(struct fio_file *f)
+{
+	uint32_t zone_idx, zone_idx_b, zone_idx_e;
+
+	assert(f->zbd_info);
+	if (f->io_size == 0)
+		return false;
+	zone_idx_b = zbd_zone_idx(f, f->file_offset);
+	zone_idx_e = zbd_zone_idx(f, f->file_offset + f->io_size - 1);
+	for (zone_idx = zone_idx_b; zone_idx <= zone_idx_e; zone_idx++)
+		if (f->zbd_info->zone_info[zone_idx].type ==
+		    BLK_ZONE_TYPE_SEQWRITE_REQ)
+			return true;
+
+	return false;
+}
+
+/*
+ * Verify whether offset and size parameters are aligned with zone boundaries.
+ */
+static bool zbd_verify_sizes(void)
+{
+	const struct fio_zone_info *z;
+	struct thread_data *td;
+	struct fio_file *f;
+	uint64_t new_offset, new_end;
+	uint32_t zone_idx;
+	int i, j;
+
+	for_each_td(td, i) {
+		for_each_file(td, f, j) {
+			if (!f->zbd_info)
+				continue;
+			if (f->file_offset >= f->real_file_size)
+				continue;
+			if (!zbd_is_seq_job(f))
+				continue;
+			zone_idx = zbd_zone_idx(f, f->file_offset);
+			z = &f->zbd_info->zone_info[zone_idx];
+			if (f->file_offset != (z->start << 9)) {
+				new_offset = (z+1)->start << 9;
+				if (new_offset >= f->file_offset + f->io_size) {
+					log_info("%s: io_size must be at least one zone\n",
+						 f->file_name);
+					return false;
+				}
+				log_info("%s: rounded up offset from %lu to %lu\n",
+					 f->file_name, f->file_offset,
+					 new_offset);
+				f->io_size -= (new_offset - f->file_offset);
+				f->file_offset = new_offset;
+			}
+			zone_idx = zbd_zone_idx(f, f->file_offset + f->io_size);
+			z = &f->zbd_info->zone_info[zone_idx];
+			new_end = z->start << 9;
+			if (f->file_offset + f->io_size != new_end) {
+				if (new_end <= f->file_offset) {
+					log_info("%s: io_size must be at least one zone\n",
+						 f->file_name);
+					return false;
+				}
+				log_info("%s: rounded down io_size from %lu to %lu\n",
+					 f->file_name, f->io_size,
+					 new_end - f->file_offset);
+				f->io_size = new_end - f->file_offset;
+			}
+		}
+	}
+
+	return true;
+}
+
+static bool zbd_verify_bs(void)
+{
+	struct thread_data *td;
+	struct fio_file *f;
+	uint32_t zone_size;
+	int i, j, k;
+
+	for_each_td(td, i) {
+		for_each_file(td, f, j) {
+			if (!f->zbd_info)
+				continue;
+			zone_size = f->zbd_info->zone_size;
+			for (k = 0; k < ARRAY_SIZE(td->o.bs); k++) {
+				if (td->o.verify != VERIFY_NONE &&
+				    (zone_size << 9) % td->o.bs[k] != 0) {
+					log_info("%s: block size %llu is not a divisor of the zone size %d\n",
+						 f->file_name, td->o.bs[k],
+						 zone_size << 9);
+					return false;
+				}
+			}
+		}
+	}
+	return true;
+}
+
+/*
+ * Read zone information into @buf starting from sector @start_sector.
+ * @fd is a file descriptor that refers to a block device and @bufsz is the
+ * size of @buf.
+ *
+ * Returns 0 upon success and a negative error code upon failure.
+ */
+static int read_zone_info(int fd, uint64_t start_sector,
+			  void *buf, unsigned int bufsz)
+{
+	struct blk_zone_report *hdr = buf;
+
+	if (bufsz < sizeof(*hdr))
+		return -EINVAL;
+
+	memset(hdr, 0, sizeof(*hdr));
+
+	hdr->nr_zones = (bufsz - sizeof(*hdr)) / sizeof(struct blk_zone);
+	hdr->sector = start_sector;
+	return ioctl(fd, BLKREPORTZONE, hdr) >= 0 ? 0 : -errno;
+}
+
+/*
+ * Read up to 255 characters from the first line of a file. Strip the trailing
+ * newline.
+ */
+static char *read_file(const char *path)
+{
+	char line[256], *p = line;
+	FILE *f;
+
+	f = fopen(path, "rb");
+	if (!f)
+		return NULL;
+	if (!fgets(line, sizeof(line), f))
+		line[0] = '\0';
+	strsep(&p, "\n");
+	fclose(f);
+
+	return strdup(line);
+}
+
+static enum blk_zoned_model get_zbd_model(const char *file_name)
+{
+	enum blk_zoned_model model = ZBD_DM_NONE;
+	char *zoned_attr_path = NULL;
+	char *model_str = NULL;
+	struct stat statbuf;
+
+	if (stat(file_name, &statbuf) < 0)
+		goto out;
+	if (asprintf(&zoned_attr_path, "/sys/dev/block/%d:%d/queue/zoned",
+		     major(statbuf.st_rdev), minor(statbuf.st_rdev)) < 0)
+		goto out;
+	model_str = read_file(zoned_attr_path);
+	if (!model_str)
+		goto out;
+	dprint(FD_ZBD, "%s: zbd model string: %s\n", file_name, model_str);
+	if (strcmp(model_str, "host-aware") == 0)
+		model = ZBD_DM_HOST_AWARE;
+	else if (strcmp(model_str, "host-managed") == 0)
+		model = ZBD_DM_HOST_MANAGED;
+
+out:
+	free(model_str);
+	free(zoned_attr_path);
+	return model;
+}
+
+static int ilog2(uint64_t i)
+{
+	int log = -1;
+
+	while (i) {
+		i >>= 1;
+		log++;
+	}
+	return log;
+}
+
+/*
+ * Initialize f->zbd_info for devices that are not zoned block devices. This
+ * allows to execute a ZBD workload against a non-ZBD device.
+ */
+static int init_zone_info(struct thread_data *td, struct fio_file *f)
+{
+	uint32_t nr_zones;
+	struct fio_zone_info *p;
+	uint64_t zone_size;
+	struct zoned_block_device_info *zbd_info = NULL;
+	pthread_mutexattr_t attr;
+	int i;
+
+	zone_size = td->o.zone_size >> 9;
+	assert(zone_size);
+	nr_zones = ((f->real_file_size >> 9) + zone_size - 1) / zone_size;
+	zbd_info = scalloc(1, sizeof(*zbd_info) +
+			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
+	if (!zbd_info)
+		return -ENOMEM;
+
+	pthread_mutexattr_init(&attr);
+	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
+	pthread_mutexattr_setpshared(&attr, true);
+	pthread_mutex_init(&zbd_info->mutex, &attr);
+	zbd_info->refcount = 1;
+	p = &zbd_info->zone_info[0];
+	for (i = 0; i < nr_zones; i++, p++) {
+		pthread_mutex_init(&p->mutex, &attr);
+		p->start = i * zone_size;
+		p->wp = p->start + zone_size;
+		p->type = BLK_ZONE_TYPE_SEQWRITE_REQ;
+		p->cond = BLK_ZONE_COND_EMPTY;
+	}
+	/* a sentinel */
+	p->start = nr_zones * zone_size;
+
+	f->zbd_info = zbd_info;
+	f->zbd_info->zone_size = zone_size;
+	f->zbd_info->zone_size_log2 = is_power_of_2(zone_size) ?
+		ilog2(zone_size) + 9 : -1;
+	f->zbd_info->nr_zones = nr_zones;
+	pthread_mutexattr_destroy(&attr);
+	return 0;
+}
+
+/*
+ * Parse the BLKREPORTZONE output and store it in f->zbd_info. Must be called
+ * only for devices that support this ioctl, namely zoned block devices.
+ */
+static int parse_zone_info(struct thread_data *td, struct fio_file *f)
+{
+	const unsigned int bufsz = sizeof(struct blk_zone_report) +
+		4096 * sizeof(struct blk_zone);
+	uint32_t nr_zones;
+	struct blk_zone_report *hdr;
+	const struct blk_zone *z;
+	struct fio_zone_info *p;
+	uint64_t zone_size, start_sector;
+	struct zoned_block_device_info *zbd_info = NULL;
+	pthread_mutexattr_t attr;
+	void *buf;
+	int fd, i, j, ret = 0;
+
+	pthread_mutexattr_init(&attr);
+	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
+	pthread_mutexattr_setpshared(&attr, true);
+
+	buf = malloc(bufsz);
+	if (!buf)
+		goto out;
+
+	fd = open(f->file_name, O_RDONLY | O_LARGEFILE);
+	if (fd < 0) {
+		ret = -errno;
+		goto free;
+	}
+
+	ret = read_zone_info(fd, 0, buf, bufsz);
+	if (ret < 0) {
+		log_info("fio: BLKREPORTZONE(%lu) failed for %s (%d).\n",
+			 0UL, f->file_name, -ret);
+		goto close;
+	}
+	hdr = buf;
+	if (hdr->nr_zones < 1) {
+		log_info("fio: %s has invalid zone information.\n",
+			 f->file_name);
+		goto close;
+	}
+	z = (void *)(hdr + 1);
+	zone_size = z->len;
+	nr_zones = ((f->real_file_size >> 9) + zone_size - 1) / zone_size;
+
+	if (td->o.zone_size == 0) {
+		td->o.zone_size = zone_size << 9;
+	} else if (td->o.zone_size != zone_size << 9) {
+		log_info("fio: %s job parameter zonesize %lld does not match disk zone size %ld.\n",
+			 f->file_name, td->o.zone_size, zone_size << 9);
+		ret = -EINVAL;
+		goto close;
+	}
+
+	dprint(FD_ZBD, "Device %s has %d zones of size %lu KB\n", f->file_name,
+	       nr_zones, zone_size / 2);
+
+	zbd_info = scalloc(1, sizeof(*zbd_info) +
+			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
+	ret = -ENOMEM;
+	if (!zbd_info)
+		goto close;
+	pthread_mutex_init(&zbd_info->mutex, &attr);
+	zbd_info->refcount = 1;
+	p = &zbd_info->zone_info[0];
+	for (start_sector = 0, j = 0; j < nr_zones;) {
+		z = (void *)(hdr + 1);
+		for (i = 0; i < hdr->nr_zones; i++, j++, z++, p++) {
+			pthread_mutex_init(&p->mutex, &attr);
+			p->start = z->start;
+			switch (z->cond) {
+			case BLK_ZONE_COND_NOT_WP:
+				p->wp = z->start;
+				break;
+			case BLK_ZONE_COND_FULL:
+				p->wp = z->start + zone_size;
+				break;
+			default:
+				assert(z->start <= z->wp);
+				assert(z->wp <= z->start + zone_size);
+				p->wp = z->wp;
+				break;
+			}
+			p->type = z->type;
+			p->cond = z->cond;
+			if (j > 0 && p->start != p[-1].start + zone_size) {
+				log_info("%s: invalid zone data\n",
+					 f->file_name);
+				ret = -EINVAL;
+				goto close;
+			}
+		}
+		z--;
+		start_sector = z->start + z->len;
+		if (j >= nr_zones)
+			break;
+		ret = read_zone_info(fd, start_sector, buf, bufsz);
+		if (ret < 0) {
+			log_info("fio: BLKREPORTZONE(%lu) failed for %s (%d).\n",
+				 start_sector, f->file_name, -ret);
+			goto close;
+		}
+	}
+	/* a sentinel */
+	zbd_info->zone_info[nr_zones].start = start_sector;
+
+	f->zbd_info = zbd_info;
+	f->zbd_info->zone_size = zone_size;
+	f->zbd_info->zone_size_log2 = is_power_of_2(zone_size) ?
+		ilog2(zone_size) + 9 : -1;
+	f->zbd_info->nr_zones = nr_zones;
+	zbd_info = NULL;
+	ret = 0;
+
+close:
+	sfree(zbd_info);
+	close(fd);
+free:
+	free(buf);
+out:
+	pthread_mutexattr_destroy(&attr);
+	return ret;
+}
+
+/*
+ * Allocate zone information and store it into f->zbd_info if zonemode=zbd.
+ *
+ * Returns 0 upon success and a negative error code upon failure.
+ */
+int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
+{
+	enum blk_zoned_model zbd_model;
+	int ret = 0;
+
+	assert(td->o.zone_mode == ZONE_MODE_ZBD);
+
+	zbd_model = get_zbd_model(f->file_name);
+	switch (zbd_model) {
+	case ZBD_DM_HOST_AWARE:
+	case ZBD_DM_HOST_MANAGED:
+		ret = parse_zone_info(td, f);
+		break;
+	case ZBD_DM_NONE:
+		ret = init_zone_info(td, f);
+		break;
+	}
+	if (ret == 0)
+		f->zbd_info->model = zbd_model;
+	return ret;
+}
+
+void zbd_free_zone_info(struct fio_file *f)
+{
+	uint32_t refcount;
+
+	if (!f->zbd_info)
+		return;
+
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	refcount = --f->zbd_info->refcount;
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+
+	assert((int32_t)refcount >= 0);
+	if (refcount == 0)
+		sfree(f->zbd_info);
+	f->zbd_info = NULL;
+}
+
+/*
+ * Initialize f->zbd_info.
+ *
+ * Returns 0 upon success and a negative error code upon failure.
+ *
+ * Note: this function can only work correctly if it is called before the first
+ * fio fork() call.
+ */
+static int zbd_init_zone_info(struct thread_data *td, struct fio_file *file)
+{
+	struct thread_data *td2;
+	struct fio_file *f2;
+	int i, j, ret;
+
+	for_each_td(td2, i) {
+		for_each_file(td2, f2, j) {
+			if (td2 == td && f2 == file)
+				continue;
+			if (!f2->zbd_info ||
+			    strcmp(f2->file_name, file->file_name) != 0)
+				continue;
+			file->zbd_info = f2->zbd_info;
+			file->zbd_info->refcount++;
+			return 0;
+		}
+	}
+
+	ret = zbd_create_zone_info(td, file);
+	if (ret < 0)
+		td_verror(td, -ret, "BLKREPORTZONE failed");
+	return ret;
+}
+
+int zbd_init(struct thread_data *td)
+{
+	struct fio_file *f;
+	int i;
+
+	for_each_file(td, f, i) {
+		if (f->filetype != FIO_TYPE_BLOCK)
+			continue;
+		if (td->o.zone_size && td->o.zone_size < 512) {
+			log_err("%s: zone size must be at least 512 bytes for --zonemode=zbd\n\n",
+				f->file_name);
+			return 1;
+		}
+		if (td->o.zone_size == 0 &&
+		    get_zbd_model(f->file_name) == ZBD_DM_NONE) {
+			log_err("%s: Specifying the zone size is mandatory for regular block devices with --zonemode=zbd\n\n",
+				f->file_name);
+			return 1;
+		}
+		zbd_init_zone_info(td, f);
+	}
+
+	if (!zbd_using_direct_io()) {
+		log_err("Using direct I/O is mandatory for writing to ZBD drives\n\n");
+		return 1;
+	}
+
+	if (!zbd_verify_sizes())
+		return 1;
+
+	if (!zbd_verify_bs())
+		return 1;
+
+	return 0;
+}
+
+/**
+ * zbd_reset_range - reset zones for a range of sectors
+ * @td: FIO thread data.
+ * @f: Fio file for which to reset zones
+ * @sector: Starting sector in units of 512 bytes
+ * @nr_sectors: Number of sectors in units of 512 bytes
+ *
+ * Returns 0 upon success and a negative error code upon failure.
+ */
+static int zbd_reset_range(struct thread_data *td, const struct fio_file *f,
+			   uint64_t sector, uint64_t nr_sectors)
+{
+	struct blk_zone_range zr = {
+		.sector         = sector,
+		.nr_sectors     = nr_sectors,
+	};
+	uint32_t zone_idx_b, zone_idx_e;
+	struct fio_zone_info *zb, *ze, *z;
+	int ret = 0;
+
+	assert(f->fd != -1);
+	assert(is_valid_offset(f, ((sector + nr_sectors) << 9) - 1));
+	switch (f->zbd_info->model) {
+	case ZBD_DM_HOST_AWARE:
+	case ZBD_DM_HOST_MANAGED:
+		ret = ioctl(f->fd, BLKRESETZONE, &zr);
+		if (ret < 0) {
+			td_verror(td, errno, "resetting wp failed");
+			log_err("%s: resetting wp for %llu sectors at sector %llu failed (%d).\n",
+				f->file_name, zr.nr_sectors, zr.sector, errno);
+			return ret;
+		}
+		break;
+	case ZBD_DM_NONE:
+		break;
+	}
+
+	zone_idx_b = zbd_zone_idx(f, sector << 9);
+	zb = &f->zbd_info->zone_info[zone_idx_b];
+	zone_idx_e = zbd_zone_idx(f, (sector + nr_sectors) << 9);
+	ze = &f->zbd_info->zone_info[zone_idx_e];
+	for (z = zb; z < ze; z++) {
+		pthread_mutex_lock(&z->mutex);
+		pthread_mutex_lock(&f->zbd_info->mutex);
+		f->zbd_info->sectors_with_data -= z->wp - z->start;
+		pthread_mutex_unlock(&f->zbd_info->mutex);
+		z->wp = z->start;
+		z->verify_block = 0;
+		pthread_mutex_unlock(&z->mutex);
+	}
+
+	td->ts.nr_zone_resets += ze - zb;
+
+	return ret;
+}
+
+/**
+ * zbd_reset_zone - reset the write pointer of a single zone
+ * @td: FIO thread data.
+ * @f: FIO file associated with the disk for which to reset a write pointer.
+ * @z: Zone to reset.
+ *
+ * Returns 0 upon success and a negative error code upon failure.
+ */
+static int zbd_reset_zone(struct thread_data *td, const struct fio_file *f,
+			  struct fio_zone_info *z)
+{
+	int ret;
+
+	dprint(FD_ZBD, "%s: resetting wp of zone %lu.\n", f->file_name,
+	       z - f->zbd_info->zone_info);
+	ret = zbd_reset_range(td, f, z->start, (z+1)->start - z->start);
+	return ret;
+}
+
+/*
+ * Reset a range of zones. Returns 0 upon success and 1 upon failure.
+ * @td: fio thread data.
+ * @f: fio file for which to reset zones
+ * @zb: first zone to reset.
+ * @ze: first zone not to reset.
+ * @all_zones: whether to reset all zones or only those zones for which the
+ *	write pointer is not a multiple of td->o.min_bs[DDIR_WRITE].
+ */
+static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
+			   struct fio_zone_info *const zb,
+			   struct fio_zone_info *const ze, bool all_zones)
+{
+	struct fio_zone_info *z, *start_z = ze;
+	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE] >> 9;
+	bool reset_wp;
+	int res = 0;
+
+	dprint(FD_ZBD, "%s: examining zones %lu .. %lu\n", f->file_name,
+	       zb - f->zbd_info->zone_info, ze - f->zbd_info->zone_info);
+	assert(f->fd != -1);
+	for (z = zb; z < ze; z++) {
+		pthread_mutex_lock(&z->mutex);
+		switch (z->type) {
+		case BLK_ZONE_TYPE_SEQWRITE_REQ:
+			reset_wp = all_zones ? z->wp != z->start :
+					(td->o.td_ddir & TD_DDIR_WRITE) &&
+					z->wp % min_bs != 0;
+			if (start_z == ze && reset_wp) {
+				start_z = z;
+			} else if (start_z < ze && !reset_wp) {
+				dprint(FD_ZBD,
+				       "%s: resetting zones %lu .. %lu\n",
+				       f->file_name,
+				       start_z - f->zbd_info->zone_info,
+				       z - f->zbd_info->zone_info);
+				if (zbd_reset_range(td, f, start_z->start,
+						z->start - start_z->start) < 0)
+					res = 1;
+				start_z = ze;
+			}
+			break;
+		default:
+			if (start_z == ze)
+				break;
+			dprint(FD_ZBD, "%s: resetting zones %lu .. %lu\n",
+			       f->file_name, start_z - f->zbd_info->zone_info,
+			       z - f->zbd_info->zone_info);
+			if (zbd_reset_range(td, f, start_z->start,
+					    z->start - start_z->start) < 0)
+				res = 1;
+			start_z = ze;
+			break;
+		}
+	}
+	if (start_z < ze) {
+		dprint(FD_ZBD, "%s: resetting zones %lu .. %lu\n", f->file_name,
+		       start_z - f->zbd_info->zone_info,
+		       z - f->zbd_info->zone_info);
+		if (zbd_reset_range(td, f, start_z->start,
+				    z->start - start_z->start) < 0)
+			res = 1;
+	}
+	for (z = zb; z < ze; z++)
+		pthread_mutex_unlock(&z->mutex);
+
+	return res;
+}
+
+/*
+ * Reset zbd_info.write_cnt, the counter that counts down towards the next
+ * zone reset.
+ */
+static void zbd_reset_write_cnt(const struct thread_data *td,
+				const struct fio_file *f)
+{
+	assert(0 <= td->o.zrf.u.f && td->o.zrf.u.f <= 1);
+
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	f->zbd_info->write_cnt = td->o.zrf.u.f ?
+		min(1.0 / td->o.zrf.u.f, 0.0 + UINT_MAX) : UINT_MAX;
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+}
+
+static bool zbd_dec_and_reset_write_cnt(const struct thread_data *td,
+					const struct fio_file *f)
+{
+	uint32_t write_cnt = 0;
+
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	assert(f->zbd_info->write_cnt);
+	if (f->zbd_info->write_cnt)
+		write_cnt = --f->zbd_info->write_cnt;
+	if (write_cnt == 0)
+		zbd_reset_write_cnt(td, f);
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+
+	return write_cnt == 0;
+}
+
+/* Check whether the value of zbd_info.sectors_with_data is correct. */
+static void check_swd(const struct thread_data *td, const struct fio_file *f)
+{
+#if 0
+	struct fio_zone_info *zb, *ze, *z;
+	uint64_t swd;
+
+	zb = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset)];
+	ze = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset +
+						  f->io_size)];
+	swd = 0;
+	for (z = zb; z < ze; z++) {
+		pthread_mutex_lock(&z->mutex);
+		swd += z->wp - z->start;
+	}
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	assert(f->zbd_info->sectors_with_data == swd);
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+	for (z = zb; z < ze; z++)
+		pthread_mutex_unlock(&z->mutex);
+#endif
+}
+
+void zbd_file_reset(struct thread_data *td, struct fio_file *f)
+{
+	struct fio_zone_info *zb, *ze, *z;
+	uint32_t zone_idx_e;
+	uint64_t swd = 0;
+
+	if (!f->zbd_info)
+		return;
+
+	zb = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset)];
+	zone_idx_e = zbd_zone_idx(f, f->file_offset + f->io_size);
+	ze = &f->zbd_info->zone_info[zone_idx_e];
+	for (z = zb ; z < ze; z++) {
+		pthread_mutex_lock(&z->mutex);
+		swd += z->wp - z->start;
+	}
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	f->zbd_info->sectors_with_data = swd;
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+	for (z = zb ; z < ze; z++)
+		pthread_mutex_unlock(&z->mutex);
+	dprint(FD_ZBD, "%s(%s): swd = %ld\n", __func__, f->file_name, swd);
+	/*
+	 * If data verification is enabled reset the affected zones before
+	 * writing any data to avoid that a zone reset has to be issued while
+	 * writing data, which causes data loss.
+	 */
+	zbd_reset_zones(td, f, zb, ze, td->o.verify != VERIFY_NONE &&
+			(td->o.td_ddir & TD_DDIR_WRITE) &&
+			td->runstate != TD_VERIFYING);
+	zbd_reset_write_cnt(td, f);
+}
+
+/* The caller must hold f->zbd_info->mutex. */
+static bool is_zone_open(const struct thread_data *td, const struct fio_file *f,
+			 unsigned int zone_idx)
+{
+	struct zoned_block_device_info *zbdi = f->zbd_info;
+	int i;
+
+	assert(td->o.max_open_zones <= ARRAY_SIZE(zbdi->open_zones));
+	assert(zbdi->num_open_zones <= td->o.max_open_zones);
+
+	for (i = 0; i < zbdi->num_open_zones; i++)
+		if (zbdi->open_zones[i] == zone_idx)
+			return true;
+
+	return false;
+}
+
+/*
+ * Open a ZBD zone if it was not yet open. Returns true if either the zone was
+ * already open or if opening a new zone is allowed. Returns false if the zone
+ * was not yet open and opening a new zone would cause the zone limit to be
+ * exceeded.
+ */
+static bool zbd_open_zone(struct thread_data *td, const struct io_u *io_u,
+			  uint32_t zone_idx)
+{
+	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
+	const struct fio_file *f = io_u->file;
+	struct fio_zone_info *z = &f->zbd_info->zone_info[zone_idx];
+	bool res = true;
+
+	if (z->cond == BLK_ZONE_COND_OFFLINE)
+		return false;
+
+	/*
+	 * Skip full zones with data verification enabled because resetting a
+	 * zone causes data loss and hence causes verification to fail.
+	 */
+	if (td->o.verify != VERIFY_NONE && zbd_zone_full(f, z, min_bs))
+		return false;
+
+	/* Zero means no limit */
+	if (!td->o.max_open_zones)
+		return true;
+
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	if (is_zone_open(td, f, zone_idx))
+		goto out;
+	res = false;
+	if (f->zbd_info->num_open_zones >= td->o.max_open_zones)
+		goto out;
+	dprint(FD_ZBD, "%s: opening zone %d\n", f->file_name, zone_idx);
+	f->zbd_info->open_zones[f->zbd_info->num_open_zones++] = zone_idx;
+	z->open = 1;
+	res = true;
+
+out:
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+	return res;
+}
+
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
+		(FIO_MAX_OPEN_ZBD_ZONES - (open_zone_idx + 1)) *
+		sizeof(f->zbd_info->open_zones[0]));
+	f->zbd_info->num_open_zones--;
+	f->zbd_info->zone_info[zone_idx].open = 0;
+}
+
+/*
+ * Modify the offset of an I/O unit that does not refer to an open zone such
+ * that it refers to an open zone. Close an open zone and open a new zone if
+ * necessary. This algorithm can only work correctly if all write pointers are
+ * a multiple of the fio block size. The caller must neither hold z->mutex
+ * nor f->zbd_info->mutex. Returns with z->mutex held upon success.
+ */
+struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
+					       struct io_u *io_u)
+{
+	const uint32_t min_bs = td->o.min_bs[io_u->ddir];
+	const struct fio_file *f = io_u->file;
+	struct fio_zone_info *z;
+	unsigned int open_zone_idx = -1;
+	uint32_t zone_idx, new_zone_idx;
+	int i;
+
+	assert(is_valid_offset(f, io_u->offset));
+
+	if (td->o.max_open_zones) {
+		/*
+		 * This statement accesses f->zbd_info->open_zones[] on purpose
+		 * without locking.
+		 */
+		zone_idx = f->zbd_info->open_zones[(io_u->offset -
+						    f->file_offset) *
+				f->zbd_info->num_open_zones / f->io_size];
+	} else {
+		zone_idx = zbd_zone_idx(f, io_u->offset);
+	}
+	dprint(FD_ZBD, "%s(%s): starting from zone %d (offset %lld, buflen %lld)\n",
+	       __func__, f->file_name, zone_idx, io_u->offset, io_u->buflen);
+
+	/*
+	 * Since z->mutex is the outer lock and f->zbd_info->mutex the inner
+	 * lock it can happen that the state of the zone with index zone_idx
+	 * has changed after 'z' has been assigned and before f->zbd_info->mutex
+	 * has been obtained. Hence the loop.
+	 */
+	for (;;) {
+		z = &f->zbd_info->zone_info[zone_idx];
+
+		pthread_mutex_lock(&z->mutex);
+		pthread_mutex_lock(&f->zbd_info->mutex);
+		if (td->o.max_open_zones == 0)
+			goto examine_zone;
+		if (f->zbd_info->num_open_zones == 0) {
+			pthread_mutex_unlock(&f->zbd_info->mutex);
+			pthread_mutex_unlock(&z->mutex);
+			dprint(FD_ZBD, "%s(%s): no zones are open\n",
+			       __func__, f->file_name);
+			return NULL;
+		}
+		open_zone_idx = (io_u->offset - f->file_offset) *
+			f->zbd_info->num_open_zones / f->io_size;
+		assert(open_zone_idx < f->zbd_info->num_open_zones);
+		new_zone_idx = f->zbd_info->open_zones[open_zone_idx];
+		if (new_zone_idx == zone_idx)
+			break;
+		zone_idx = new_zone_idx;
+		pthread_mutex_unlock(&f->zbd_info->mutex);
+		pthread_mutex_unlock(&z->mutex);
+	}
+
+	/* Both z->mutex and f->zbd_info->mutex are held. */
+
+examine_zone:
+	if ((z->wp << 9) + min_bs <= ((z+1)->start << 9)) {
+		pthread_mutex_unlock(&f->zbd_info->mutex);
+		goto out;
+	}
+	dprint(FD_ZBD, "%s(%s): closing zone %d\n", __func__, f->file_name,
+	       zone_idx);
+	if (td->o.max_open_zones)
+		zbd_close_zone(td, f, open_zone_idx);
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+
+	/* Only z->mutex is held. */
+
+	/* Zone 'z' is full, so try to open a new zone. */
+	for (i = f->io_size / f->zbd_info->zone_size; i > 0; i--) {
+		zone_idx++;
+		pthread_mutex_unlock(&z->mutex);
+		z++;
+		if (!is_valid_offset(f, z->start << 9)) {
+			/* Wrap-around. */
+			zone_idx = zbd_zone_idx(f, f->file_offset);
+			z = &f->zbd_info->zone_info[zone_idx];
+		}
+		assert(is_valid_offset(f, z->start << 9));
+		pthread_mutex_lock(&z->mutex);
+		if (z->open)
+			continue;
+		if (zbd_open_zone(td, io_u, zone_idx))
+			goto out;
+	}
+
+	/* Only z->mutex is held. */
+
+	/* Check whether the write fits in any of the already opened zones. */
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	for (i = 0; i < f->zbd_info->num_open_zones; i++) {
+		zone_idx = f->zbd_info->open_zones[i];
+		pthread_mutex_unlock(&f->zbd_info->mutex);
+		pthread_mutex_unlock(&z->mutex);
+
+		z = &f->zbd_info->zone_info[zone_idx];
+
+		pthread_mutex_lock(&z->mutex);
+		if ((z->wp << 9) + min_bs <= ((z+1)->start << 9))
+			goto out;
+		pthread_mutex_lock(&f->zbd_info->mutex);
+	}
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+	pthread_mutex_unlock(&z->mutex);
+	dprint(FD_ZBD, "%s(%s): did not open another zone\n", __func__,
+	       f->file_name);
+	return NULL;
+
+out:
+	dprint(FD_ZBD, "%s(%s): returning zone %d\n", __func__, f->file_name,
+	       zone_idx);
+	io_u->offset = z->start << 9;
+	return z;
+}
+
+/* The caller must hold z->mutex. */
+static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
+						    struct io_u *io_u,
+						    struct fio_zone_info *z)
+{
+	const struct fio_file *f = io_u->file;
+	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
+
+	if (!zbd_open_zone(td, io_u, z - f->zbd_info->zone_info)) {
+		pthread_mutex_unlock(&z->mutex);
+		z = zbd_convert_to_open_zone(td, io_u);
+		assert(z);
+	}
+
+	if (z->verify_block * min_bs >= f->zbd_info->zone_size)
+		log_err("%s: %d * %d >= %ld\n", f->file_name, z->verify_block,
+			min_bs, f->zbd_info->zone_size);
+	io_u->offset = (z->start << 9) + z->verify_block++ * min_bs;
+	return z;
+}
+
+/*
+ * Find another zone for which @io_u fits below the write pointer. Start
+ * searching in zones @zb + 1 .. @zl and continue searching in zones
+ * @zf .. @zb - 1.
+ *
+ * Either returns NULL or returns a zone pointer and holds the mutex for that
+ * zone.
+ */
+static struct fio_zone_info *
+zbd_find_zone(struct thread_data *td, struct io_u *io_u,
+	      struct fio_zone_info *zb, struct fio_zone_info *zl)
+{
+	const uint32_t min_bs = td->o.min_bs[io_u->ddir];
+	const struct fio_file *f = io_u->file;
+	struct fio_zone_info *z1, *z2;
+	const struct fio_zone_info *const zf =
+		&f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset)];
+
+	/*
+	 * Skip to the next non-empty zone in case of sequential I/O and to
+	 * the nearest non-empty zone in case of random I/O.
+	 */
+	for (z1 = zb + 1, z2 = zb - 1; z1 < zl || z2 >= zf; z1++, z2--) {
+		if (z1 < zl && z1->cond != BLK_ZONE_COND_OFFLINE) {
+			pthread_mutex_lock(&z1->mutex);
+			if (z1->start + (min_bs >> 9) <= z1->wp)
+				return z1;
+			pthread_mutex_unlock(&z1->mutex);
+		} else if (!td_random(td)) {
+			break;
+		}
+		if (td_random(td) && z2 >= zf &&
+		    z2->cond != BLK_ZONE_COND_OFFLINE) {
+			pthread_mutex_lock(&z2->mutex);
+			if (z2->start + (min_bs >> 9) <= z2->wp)
+				return z2;
+			pthread_mutex_unlock(&z2->mutex);
+		}
+	}
+	dprint(FD_ZBD, "%s: adjusting random read offset failed\n",
+	       f->file_name);
+	return NULL;
+}
+
+
+/**
+ * zbd_post_submit - update the write pointer and unlock the zone lock
+ * @io_u: I/O unit
+ * @success: Whether or not the I/O unit has been executed successfully
+ *
+ * For write and trim operations, update the write pointer of all affected
+ * zones.
+ */
+static void zbd_post_submit(const struct io_u *io_u, bool success)
+{
+	struct zoned_block_device_info *zbd_info;
+	struct fio_zone_info *z;
+	uint32_t zone_idx;
+	uint64_t end, zone_end;
+
+	zbd_info = io_u->file->zbd_info;
+	if (!zbd_info)
+		return;
+
+	zone_idx = zbd_zone_idx(io_u->file, io_u->offset);
+	end = (io_u->offset + io_u->buflen) >> 9;
+	z = &zbd_info->zone_info[zone_idx];
+	assert(zone_idx < zbd_info->nr_zones);
+	if (z->type != BLK_ZONE_TYPE_SEQWRITE_REQ)
+		return;
+	if (!success)
+		goto unlock;
+	switch (io_u->ddir) {
+	case DDIR_WRITE:
+		zone_end = min(end, (z + 1)->start);
+		pthread_mutex_lock(&zbd_info->mutex);
+		/*
+		 * z->wp > zone_end means that one or more I/O errors
+		 * have occurred.
+		 */
+		if (z->wp <= zone_end)
+			zbd_info->sectors_with_data += zone_end - z->wp;
+		pthread_mutex_unlock(&zbd_info->mutex);
+		z->wp = zone_end;
+		break;
+	case DDIR_TRIM:
+		assert(z->wp == z->start);
+		break;
+	default:
+		break;
+	}
+unlock:
+	pthread_mutex_unlock(&z->mutex);
+}
+
+bool zbd_unaligned_write(int error_code)
+{
+	switch (error_code) {
+	case EIO:
+	case EREMOTEIO:
+		return true;
+	}
+	return false;
+}
+
+/**
+ * zbd_adjust_block - adjust the offset and length as necessary for ZBD drives
+ * @td: FIO thread data.
+ * @io_u: FIO I/O unit.
+ *
+ * Locking strategy: returns with z->mutex locked if and only if z refers
+ * to a sequential zone and if io_u_accept is returned. z is the zone that
+ * corresponds to io_u->offset at the end of this function.
+ */
+enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
+{
+	const struct fio_file *f = io_u->file;
+	uint32_t zone_idx_b;
+	struct fio_zone_info *zb, *zl;
+	uint32_t orig_len = io_u->buflen;
+	uint32_t min_bs = td->o.min_bs[io_u->ddir];
+	uint64_t new_len;
+	int64_t range;
+
+	if (!f->zbd_info)
+		return io_u_accept;
+
+	assert(is_valid_offset(f, io_u->offset));
+	assert(io_u->buflen);
+	zone_idx_b = zbd_zone_idx(f, io_u->offset);
+	zb = &f->zbd_info->zone_info[zone_idx_b];
+
+	/* Accept the I/O offset for conventional zones. */
+	if (zb->type == BLK_ZONE_TYPE_CONVENTIONAL)
+		return io_u_accept;
+
+	/*
+	 * Accept the I/O offset for reads if reading beyond the write pointer
+	 * is enabled.
+	 */
+	if (zb->cond != BLK_ZONE_COND_OFFLINE &&
+	    io_u->ddir == DDIR_READ && td->o.read_beyond_wp)
+		return io_u_accept;
+
+	pthread_mutex_lock(&zb->mutex);
+	switch (io_u->ddir) {
+	case DDIR_READ:
+		if (td->runstate == TD_VERIFYING) {
+			zb = zbd_replay_write_order(td, io_u, zb);
+			goto accept;
+		}
+		/*
+		 * Avoid reads past the write pointer because such reads do not
+		 * hit the medium.
+		 */
+		range = zb->cond != BLK_ZONE_COND_OFFLINE ?
+			((zb->wp - zb->start) << 9) - io_u->buflen : 0;
+		if (td_random(td) && range >= 0) {
+			io_u->offset = (zb->start << 9) +
+				((io_u->offset - (zb->start << 9)) %
+				 (range + 1)) / min_bs * min_bs;
+			assert(zb->start << 9 <= io_u->offset);
+			assert(io_u->offset + io_u->buflen <= zb->wp << 9);
+			goto accept;
+		}
+		if (zb->cond == BLK_ZONE_COND_OFFLINE ||
+		    (io_u->offset + io_u->buflen) >> 9 > zb->wp) {
+			pthread_mutex_unlock(&zb->mutex);
+			zl = &f->zbd_info->zone_info[zbd_zone_idx(f,
+						f->file_offset + f->io_size)];
+			zb = zbd_find_zone(td, io_u, zb, zl);
+			if (!zb) {
+				dprint(FD_ZBD,
+				       "%s: zbd_find_zone(%lld, %llu) failed\n",
+				       f->file_name, io_u->offset,
+				       io_u->buflen);
+				goto eof;
+			}
+			io_u->offset = zb->start << 9;
+		}
+		if ((io_u->offset + io_u->buflen) >> 9 > zb->wp) {
+			dprint(FD_ZBD, "%s: %lld + %lld > %" PRIu64 "\n",
+			       f->file_name, io_u->offset, io_u->buflen,
+			       zb->wp);
+			goto eof;
+		}
+		goto accept;
+	case DDIR_WRITE:
+		if (io_u->buflen > (f->zbd_info->zone_size << 9))
+			goto eof;
+		if (!zbd_open_zone(td, io_u, zone_idx_b)) {
+			pthread_mutex_unlock(&zb->mutex);
+			zb = zbd_convert_to_open_zone(td, io_u);
+			if (!zb)
+				goto eof;
+			zone_idx_b = zb - f->zbd_info->zone_info;
+		}
+		/* Check whether the zone reset threshold has been exceeded */
+		if (td->o.zrf.u.f) {
+			check_swd(td, f);
+			if ((f->zbd_info->sectors_with_data << 9) >=
+			    f->io_size * td->o.zrt.u.f &&
+			    zbd_dec_and_reset_write_cnt(td, f)) {
+				zb->reset_zone = 1;
+			}
+		}
+		/* Reset the zone pointer if necessary */
+		if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {
+			assert(td->o.verify == VERIFY_NONE);
+			/*
+			 * Since previous write requests may have been submitted
+			 * asynchronously and since we will submit the zone
+			 * reset synchronously, wait until previously submitted
+			 * write requests have completed before issuing a
+			 * zone reset.
+			 */
+			io_u_quiesce(td);
+			zb->reset_zone = 0;
+			if (zbd_reset_zone(td, f, zb) < 0)
+				goto eof;
+			check_swd(td, f);
+		}
+		/* Make writes occur at the write pointer */
+		assert(!zbd_zone_full(f, zb, min_bs));
+		io_u->offset = zb->wp << 9;
+		if (!is_valid_offset(f, io_u->offset)) {
+			dprint(FD_ZBD, "Dropped request with offset %llu\n",
+			       io_u->offset);
+			goto eof;
+		}
+		/*
+		 * Make sure that the buflen is a multiple of the minimal
+		 * block size. Give up if shrinking would make the request too
+		 * small.
+		 */
+		new_len = min((unsigned long long)io_u->buflen,
+			      ((zb + 1)->start << 9) - io_u->offset);
+		new_len = new_len / min_bs * min_bs;
+		if (new_len == io_u->buflen)
+			goto accept;
+		if (new_len >= min_bs) {
+			io_u->buflen = new_len;
+			dprint(FD_IO, "Changed length from %u into %llu\n",
+			       orig_len, io_u->buflen);
+			goto accept;
+		}
+		log_err("Zone remainder %lld smaller than minimum block size %d\n",
+			(((zb + 1)->start << 9) - io_u->offset),
+			min_bs);
+		goto eof;
+	case DDIR_TRIM:
+		/* fall-through */
+	case DDIR_SYNC:
+	case DDIR_DATASYNC:
+	case DDIR_SYNC_FILE_RANGE:
+	case DDIR_WAIT:
+	case DDIR_LAST:
+	case DDIR_INVAL:
+		goto accept;
+	}
+
+	assert(false);
+
+accept:
+	assert(zb);
+	assert(zb->cond != BLK_ZONE_COND_OFFLINE);
+	assert(!io_u->post_submit);
+	io_u->post_submit = zbd_post_submit;
+	return io_u_accept;
+
+eof:
+	if (zb)
+		pthread_mutex_unlock(&zb->mutex);
+	return io_u_eof;
+}
+
+/* Return a string with ZBD statistics */
+char *zbd_write_status(const struct thread_stat *ts)
+{
+	char *res;
+
+	if (asprintf(&res, "; %ld zone resets", ts->nr_zone_resets) < 0)
+		return NULL;
+	return res;
+}
diff --git a/zbd.h b/zbd.h
new file mode 100644
index 0000000..08751fd
--- /dev/null
+++ b/zbd.h
@@ -0,0 +1,142 @@
+/*
+ * Copyright (C) 2018 Western Digital Corporation or its affiliates.
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef FIO_ZBD_H
+#define FIO_ZBD_H
+
+#include <inttypes.h>
+#include "fio.h"	/* FIO_MAX_OPEN_ZBD_ZONES */
+#ifdef CONFIG_LINUX_BLKZONED
+#include <linux/blkzoned.h>
+#endif
+
+struct fio_file;
+
+/*
+ * Zoned block device models.
+ */
+enum blk_zoned_model {
+	ZBD_DM_NONE,	/* Regular block device */
+	ZBD_DM_HOST_AWARE,	/* Host-aware zoned block device */
+	ZBD_DM_HOST_MANAGED,	/* Host-managed zoned block device */
+};
+
+enum io_u_action {
+	io_u_accept	= 0,
+	io_u_eof	= 1,
+};
+
+/**
+ * struct fio_zone_info - information about a single ZBD zone
+ * @start: zone start in 512 byte units
+ * @wp: zone write pointer location in 512 byte units
+ * @verify_block: number of blocks that have been verified for this zone
+ * @mutex: protects the modifiable members in this structure
+ * @type: zone type (BLK_ZONE_TYPE_*)
+ * @cond: zone state (BLK_ZONE_COND_*)
+ * @open: whether or not this zone is currently open. Only relevant if
+ *		max_open_zones > 0.
+ * @reset_zone: whether or not this zone should be reset before writing to it
+ */
+struct fio_zone_info {
+#ifdef CONFIG_LINUX_BLKZONED
+	pthread_mutex_t		mutex;
+	uint64_t		start;
+	uint64_t		wp;
+	uint32_t		verify_block;
+	enum blk_zone_type	type:2;
+	enum blk_zone_cond	cond:4;
+	unsigned int		open:1;
+	unsigned int		reset_zone:1;
+#endif
+};
+
+/**
+ * zoned_block_device_info - zoned block device characteristics
+ * @model: Device model.
+ * @mutex: Protects the modifiable members in this structure (refcount and
+ *		num_open_zones).
+ * @zone_size: size of a single zone in units of 512 bytes
+ * @sectors_with_data: total size of data in all zones in units of 512 bytes
+ * @zone_size_log2: log2 of the zone size in bytes if it is a power of 2 or 0
+ *		if the zone size is not a power of 2.
+ * @nr_zones: number of zones
+ * @refcount: number of fio files that share this structure
+ * @num_open_zones: number of open zones
+ * @write_cnt: Number of writes since the latest zone reset triggered by
+ *	       the zone_reset_frequency fio job parameter.
+ * @open_zones: zone numbers of open zones
+ * @zone_info: description of the individual zones
+ *
+ * Only devices for which all zones have the same size are supported.
+ * Note: if the capacity is not a multiple of the zone size then the last zone
+ * will be smaller than 'zone_size'.
+ */
+struct zoned_block_device_info {
+	enum blk_zoned_model	model;
+	pthread_mutex_t		mutex;
+	uint64_t		zone_size;
+	uint64_t		sectors_with_data;
+	uint32_t		zone_size_log2;
+	uint32_t		nr_zones;
+	uint32_t		refcount;
+	uint32_t		num_open_zones;
+	uint32_t		write_cnt;
+	uint32_t		open_zones[FIO_MAX_OPEN_ZBD_ZONES];
+	struct fio_zone_info	zone_info[0];
+};
+
+#ifdef CONFIG_LINUX_BLKZONED
+void zbd_free_zone_info(struct fio_file *f);
+int zbd_init(struct thread_data *td);
+void zbd_file_reset(struct thread_data *td, struct fio_file *f);
+bool zbd_unaligned_write(int error_code);
+enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
+int zbd_do_trim(struct thread_data *td, const struct io_u *io_u);
+void zbd_update_wp(struct thread_data *td, const struct io_u *io_u);
+char *zbd_write_status(const struct thread_stat *ts);
+#else
+static inline void zbd_free_zone_info(struct fio_file *f)
+{
+}
+
+static inline int zbd_init(struct thread_data *td)
+{
+	return 0;
+}
+
+static inline void zbd_file_reset(struct thread_data *td, struct fio_file *f)
+{
+}
+
+static inline bool zbd_unaligned_write(int error_code)
+{
+	return false;
+}
+
+static inline enum io_u_action zbd_adjust_block(struct thread_data *td,
+						struct io_u *io_u)
+{
+	return io_u_accept;
+}
+
+static inline int zbd_do_trim(struct thread_data *td, const struct io_u *io_u)
+{
+	return 1;
+}
+
+static inline void zbd_update_wp(struct thread_data *td,
+				 const struct io_u *io_u)
+{
+}
+
+static inline char *zbd_write_status(const struct thread_stat *ts)
+{
+	return NULL;
+}
+#endif
+
+#endif /* FIO_ZBD_H */

