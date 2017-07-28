Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40516 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751628AbdG1MAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Jul 2017 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1db3w4-00077P-IV
        for fio@vger.kernel.org; Fri, 28 Jul 2017 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170728120002.739052C1196@kernel.dk>
Date: Fri, 28 Jul 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e1933299ed9f1525e010e0489f0185c063d6d129:

  drop logging when blkdev invalidation failed on unsupported platforms (2017-07-25 13:56:21 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f271a3f2d598b9dd8036543071cad573295d8e8e:

  don't print native_fallocate() error if ENOSYS (2017-07-27 14:44:23 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'minor_fixes' of https://github.com/sitsofe/fio

Sitsofe Wheeler (10):
      HOWTO: remove unnecessary escaping
      travis: get rid of non-breaking space characters
      os: add missing include for bswap_* on BSDs
      arch: raise an error when compiling for an unknown ARM platform
      examples: add a butterfly seek job file
      time: Add chosen clocksource debug
      doc: add block size to log file format
      doc: minor grammar fixes
      init: force fallocate_mode to none when fallocate is unsupported
      fio: refactor fallocate defines

Stephen Bates (1):
      pvsync2: Add hipri_percentage option

Tomohiro Kusumi (1):
      don't print native_fallocate() error if ENOSYS

 .travis.yml            |  2 +-
 HOWTO                  | 36 ++++++++++++++++++++++--------------
 arch/arch-arm.h        |  2 ++
 doc/fio_examples.rst   | 10 ++++++++++
 engines/sync.c         | 20 +++++++++++++++++++-
 examples/butterfly.fio | 19 +++++++++++++++++++
 filesetup.c            |  3 +--
 fio.1                  | 30 ++++++++++++++++++------------
 gettime.c              |  1 +
 init.c                 |  5 +++++
 options.c              |  6 +++---
 os/os-dragonfly.h      |  1 +
 os/os-freebsd.h        |  1 +
 os/os-netbsd.h         |  1 +
 os/os-openbsd.h        |  1 +
 os/os.h                |  4 ++++
 16 files changed, 109 insertions(+), 33 deletions(-)
 create mode 100644 examples/butterfly.fio

---

Diff of recent changes:

diff --git a/.travis.yml b/.travis.yml
index ca50e22..e84e61f 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -16,7 +16,7 @@ matrix:
 #     compiler: clang
 #     osx_image: xcode8
 #     env: SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk MACOSX_DEPLOYMENT_TARGET=10.11
-    #��Build on the latest OSX version (will eventually become��obsolete)
+    # Build on the latest OSX version (will eventually become obsolete)
     - os: osx
       compiler: clang
       osx_image: xcode8.2
diff --git a/HOWTO b/HOWTO
index 2fa8fc2..caf6591 100644
--- a/HOWTO
+++ b/HOWTO
@@ -98,7 +98,7 @@ Command line options
 
 .. option:: --parse-only
 
-	Parse options only, don\'t start any I/O.
+	Parse options only, don't start any I/O.
 
 .. option:: --output=filename
 
@@ -1015,8 +1015,8 @@ I/O type
 
 	``sequential`` is only useful for random I/O, where fio would normally
 	generate a new random offset for every I/O. If you append e.g. 8 to randread,
-	you would get a new random offset for every 8 I/O's. The result would be a
-	seek for only every 8 I/O's, instead of for every I/O. Use ``rw=randread:8``
+	you would get a new random offset for every 8 I/Os. The result would be a
+	seek for only every 8 I/Os, instead of for every I/O. Use ``rw=randread:8``
 	to specify that. As sequential I/O is already sequential, setting
 	``sequential`` for that would not result in any differences.  ``identical``
 	behaves in a similar fashion, except it sends the same offset 8 number of
@@ -1819,6 +1819,11 @@ caveat that when used on the command line, they must come after the
 	Set RWF_HIPRI on I/O, indicating to the kernel that it's of higher priority
 	than normal.
 
+.. option:: hipri_percentage : [pvsync2]
+
+	When hipri is set this determines the probability of a pvsync2 IO being high
+	priority. The default is 100%.
+
 .. option:: cpuload=int : [cpuio]
 
 	Attempt to use the specified percentage of CPU cycles. This is a mandatory
@@ -2761,7 +2766,8 @@ Measurements and reporting
 .. option:: log_offset=int
 
 	If this is set, the iolog options will include the byte offset for the I/O
-	entry as well as the other data values.
+	entry as well as the other data values. Defaults to 0 meaning that
+	offsets are not present in logs. Also see `Log File Formats`_.
 
 .. option:: log_compression=int
 
@@ -3242,7 +3248,7 @@ numbers denote:
 **ios**
 		Number of I/Os performed by all groups.
 **merge**
-		Number of merges I/O the I/O scheduler.
+		Number of merges performed by the I/O scheduler.
 **ticks**
 		Number of ticks we kept the disk busy.
 **in_queue**
@@ -3278,7 +3284,7 @@ changed for some reason, this number will be incremented by 1 to signify that
 change.
 
 Split up, the format is as follows (comments in brackets denote when a
-field was introduced or whether its specific to some terse version):
+field was introduced or whether it's specific to some terse version):
 
     ::
 
@@ -3531,9 +3537,10 @@ Log File Formats
 Fio supports a variety of log file formats, for logging latencies, bandwidth,
 and IOPS. The logs share a common format, which looks like this:
 
-    *time* (`msec`), *value*, *data direction*, *offset*
+    *time* (`msec`), *value*, *data direction*, *block size* (`bytes`),
+    *offset* (`bytes`)
 
-Time for the log entry is always in milliseconds. The *value* logged depends
+*Time* for the log entry is always in milliseconds. The *value* logged depends
 on the type of log, it will be one of the following:
 
     **Latency log**
@@ -3552,16 +3559,17 @@ on the type of log, it will be one of the following:
 	**2**
 		I/O is a TRIM
 
-The *offset* is the offset, in bytes, from the start of the file, for that
-particular I/O. The logging of the offset can be toggled with
-:option:`log_offset`.
+The entry's *block size* is always in bytes. The *offset* is the offset, in bytes,
+from the start of the file, for that particular I/O. The logging of the offset can be
+toggled with :option:`log_offset`.
 
 Fio defaults to logging every individual I/O.  When IOPS are logged for individual
-I/Os the value entry will always be 1.  If windowed logging is enabled through
+I/Os the *value* entry will always be 1. If windowed logging is enabled through
 :option:`log_avg_msec`, fio logs the average values over the specified period of time.
 If windowed logging is enabled and :option:`log_max_value` is set, then fio logs
-maximum values in that window instead of averages.  Since 'data direction' and
-'offset' are per-I/O values, they aren't applicable if windowed logging is enabled.
+maximum values in that window instead of averages. Since *data direction*, *block
+size* and *offset* are per-I/O values, if windowed logging is enabled they
+aren't applicable and will be 0.
 
 Client/Server
 -------------
diff --git a/arch/arch-arm.h b/arch/arch-arm.h
index 31671fd..dd286d0 100644
--- a/arch/arch-arm.h
+++ b/arch/arch-arm.h
@@ -14,6 +14,8 @@
 #define	nop		__asm__ __volatile__ ("nop")
 #define read_barrier()	__sync_synchronize()
 #define write_barrier()	__sync_synchronize()
+#else
+#error "unsupported ARM architecture"
 #endif
 
 #endif
diff --git a/doc/fio_examples.rst b/doc/fio_examples.rst
index ae0ef6f..cff1f39 100644
--- a/doc/fio_examples.rst
+++ b/doc/fio_examples.rst
@@ -60,3 +60,13 @@ Fixed rate submission
 
 .. literalinclude:: ../examples/fixed-rate-submission.fio
 	:language: ini
+
+Butterfly seek pattern
+-----------------------
+
+.. only:: builder_html
+
+:download:`Download butterfly.fio <../examples/butterfly.fio>`
+
+.. literalinclude:: ../examples/butterfly.fio
+	:language: ini
diff --git a/engines/sync.c b/engines/sync.c
index e76bbbb..26b98b6 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -14,6 +14,7 @@
 
 #include "../fio.h"
 #include "../optgroup.h"
+#include "../lib/rand.h"
 
 /*
  * Sync engine uses engine_data to store last offset
@@ -30,12 +31,15 @@ struct syncio_data {
 	unsigned long long last_offset;
 	struct fio_file *last_file;
 	enum fio_ddir last_ddir;
+
+	struct frand_state rand_state;
 };
 
 #ifdef FIO_HAVE_PWRITEV2
 struct psyncv2_options {
 	void *pad;
 	unsigned int hipri;
+	unsigned int hipri_percentage;
 };
 
 static struct fio_option options[] = {
@@ -49,6 +53,18 @@ static struct fio_option options[] = {
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
+		.name	= "hipri_percentage",
+		.lname	= "RWF_HIPRI_PERCENTAGE",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct psyncv2_options, hipri_percentage),
+		.minval	= 0,
+		.maxval	= 100,
+		.def    = "100",
+		.help	= "Probabilistically set RWF_HIPRI for pwritev2/preadv2",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
 		.name	= NULL,
 	},
 };
@@ -132,7 +148,8 @@ static int fio_pvsyncio2_queue(struct thread_data *td, struct io_u *io_u)
 
 	fio_ro_check(td, io_u);
 
-	if (o->hipri)
+	if (o->hipri &&
+	    (rand32_between(&sd->rand_state, 1, 100) <= o->hipri_percentage))
 		flags |= RWF_HIPRI;
 
 	iov->iov_base = io_u->xfer_buf;
@@ -363,6 +380,7 @@ static int fio_vsyncio_init(struct thread_data *td)
 	sd->last_offset = -1ULL;
 	sd->iovecs = malloc(td->o.iodepth * sizeof(struct iovec));
 	sd->io_us = malloc(td->o.iodepth * sizeof(struct io_u *));
+	init_rand(&sd->rand_state, 0);
 
 	td->io_ops_data = sd;
 	return 0;
diff --git a/examples/butterfly.fio b/examples/butterfly.fio
new file mode 100644
index 0000000..42d253d
--- /dev/null
+++ b/examples/butterfly.fio
@@ -0,0 +1,19 @@
+# Perform a butterfly/funnel seek pattern. This won't always alternate ends on
+# every I/O but it will get close.
+
+[global]
+filename=/tmp/testfile
+bs=4k
+direct=1
+
+[forward]
+rw=read
+flow=2
+# Uncomment the size= and offset= lines to prevent each direction going past
+# the middle of the file
+#size=50%
+
+[backward]
+rw=read:-8k
+flow=-2
+#offset=50%
diff --git a/filesetup.c b/filesetup.c
index 3b2ebd9..839aefc 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -67,7 +67,7 @@ static void fallocate_file(struct thread_data *td, struct fio_file *f)
 	switch (td->o.fallocate_mode) {
 	case FIO_FALLOCATE_NATIVE:
 		r = native_fallocate(td, f);
-		if (r != 0)
+		if (r != 0 && errno != ENOSYS)
 			log_err("fio: native_fallocate call failed: %s\n",
 					strerror(errno));
 		break;
@@ -100,7 +100,6 @@ static void fallocate_file(struct thread_data *td, struct fio_file *f)
 		log_err("fio: unknown fallocate mode: %d\n", td->o.fallocate_mode);
 		assert(0);
 	}
-
 }
 
 /*
diff --git a/fio.1 b/fio.1
index 768b209..a5ec199 100644
--- a/fio.1
+++ b/fio.1
@@ -453,7 +453,7 @@ the same blocks will be written to.
 Fio defaults to read if the option is not specified.
 For mixed I/O, the default split is 50/50. For certain types of io the result
 may still be skewed a bit, since the speed may be different. It is possible to
-specify a number of IO's to do before getting a new offset, this is done by
+specify a number of IOs to do before getting a new offset, this is done by
 appending a `:\fI<nr>\fR to the end of the string given. For a random read, it
 would look like \fBrw=randread:8\fR for passing in an offset modifier with a
 value of 8. If the postfix is used with a sequential IO pattern, then the value
@@ -478,8 +478,8 @@ Generate the same offset
 .P
 \fBsequential\fR is only useful for random IO, where fio would normally
 generate a new random offset for every IO. If you append eg 8 to randread, you
-would get a new random offset for every 8 IO's. The result would be a seek for
-only every 8 IO's, instead of for every IO. Use \fBrw=randread:8\fR to specify
+would get a new random offset for every 8 IOs. The result would be a seek for
+only every 8 IOs, instead of for every IO. Use \fBrw=randread:8\fR to specify
 that. As sequential IO is already sequential, setting \fBsequential\fR for that
 would not result in any differences.  \fBidentical\fR behaves in a similar
 fashion, except it sends the same offset 8 number of times before generating a
@@ -1794,7 +1794,8 @@ logs contain 1216 latency bins. See the \fBLOG FILE FORMATS\fR section.
 .TP
 .BI log_offset \fR=\fPbool
 If this is set, the iolog options will include the byte offset for the IO
-entry as well as the other data values.
+entry as well as the other data values. Defaults to 0 meaning that offsets are
+not present in logs. See the \fBLOG FILE FORMATS\fR section.
 .TP
 .BI log_compression \fR=\fPint
 If this is set, fio will compress the IO logs as it goes, to keep the memory
@@ -2017,6 +2018,10 @@ iodepth_batch_complete=0).
 Set RWF_HIPRI on IO, indicating to the kernel that it's of
 higher priority than normal.
 .TP
+.BI (pvsync2)hipri_percentage
+When hipri is set this determines the probability of a pvsync2 IO being high
+priority. The default is 100%.
+.TP
 .BI (net,netsplice)hostname \fR=\fPstr
 The host name or IP address to use for TCP or UDP based IO.
 If the job is a TCP listener or UDP reader, the hostname is not
@@ -2251,7 +2256,7 @@ Finally, disk statistics are printed with reads first:
 Number of I/Os performed by all groups.
 .TP
 .B merge
-Number of merges in the I/O scheduler.
+Number of merges performed by the I/O scheduler.
 .TP
 .B ticks
 Number of ticks we kept the disk busy.
@@ -2581,7 +2586,7 @@ the files over and load them from there.
 Fio supports a variety of log file formats, for logging latencies, bandwidth,
 and IOPS. The logs share a common format, which looks like this:
 
-.B time (msec), value, data direction, offset
+.B time (msec), value, data direction, block size (bytes), offset (bytes)
 
 Time for the log entry is always in milliseconds. The value logged depends
 on the type of log, it will be one of the following:
@@ -2616,15 +2621,16 @@ IO is a TRIM
 .PD
 .P
 
-The \fIoffset\fR is the offset, in bytes, from the start of the file, for that
-particular IO. The logging of the offset can be toggled with \fBlog_offset\fR.
+The entry's *block size* is always in bytes. The \fIoffset\fR is the offset, in
+bytes, from the start of the file, for that particular IO. The logging of the
+offset can be toggled with \fBlog_offset\fR.
 
 If windowed logging is enabled through \fBlog_avg_msec\fR, then fio doesn't log
 individual IOs. Instead of logs the average values over the specified
-period of time. Since \fIdata direction\fR and \fIoffset\fR are per-IO values,
-they aren't applicable if windowed logging is enabled. If windowed logging
-is enabled and \fBlog_max_value\fR is set, then fio logs maximum values in
-that window instead of averages.
+period of time. Since \fIdata direction\fR, \fIblock size\fR and \fIoffset\fR
+are per-IO values, if windowed logging is enabled they aren't applicable and
+will be 0. If windowed logging is enabled and \fBlog_max_value\fR is set, then
+fio logs maximum values in that window instead of averages.
 
 For histogram logging the logs look like this:
 
diff --git a/gettime.c b/gettime.c
index 9e5457e..3dcaaf6 100644
--- a/gettime.c
+++ b/gettime.c
@@ -425,6 +425,7 @@ void fio_clock_init(void)
 			fio_clock_source = CS_CPUCLOCK;
 	} else if (fio_clock_source == CS_CPUCLOCK)
 		log_info("fio: clocksource=cpu may not be reliable\n");
+	dprint(FD_TIME, "gettime: clocksource=%d\n", (int) fio_clock_source);
 }
 
 uint64_t ntime_since(const struct timespec *s, const struct timespec *e)
diff --git a/init.c b/init.c
index 90cc0bc..42e7107 100644
--- a/init.c
+++ b/init.c
@@ -781,6 +781,11 @@ static int fixup_options(struct thread_data *td)
 			o->unit_base = 8;
 	}
 
+#ifndef FIO_HAVE_ANY_FALLOCATE
+	/* Platform doesn't support any fallocate so force it to none */
+	o->fallocate_mode = FIO_FALLOCATE_NONE;
+#endif
+
 #ifndef CONFIG_FDATASYNC
 	if (o->fdatasync_blocks) {
 		log_info("fio: this platform does not support fdatasync()"
diff --git a/options.c b/options.c
index b21f09a..5a2ab57 100644
--- a/options.c
+++ b/options.c
@@ -2289,7 +2289,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.parent = "nrfiles",
 		.hide	= 1,
 	},
-#if defined(CONFIG_POSIX_FALLOCATE) || defined(FIO_HAVE_NATIVE_FALLOCATE)
+#ifdef FIO_HAVE_ANY_FALLOCATE
 	{
 		.name	= "fallocate",
 		.lname	= "Fallocate",
@@ -2333,14 +2333,14 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 #endif
 		},
 	},
-#else	/* CONFIG_POSIX_FALLOCATE */
+#else	/* FIO_HAVE_ANY_FALLOCATE */
 	{
 		.name	= "fallocate",
 		.lname	= "Fallocate",
 		.type	= FIO_OPT_UNSUPPORTED,
 		.help	= "Your platform does not support fallocate",
 	},
-#endif /* CONFIG_POSIX_FALLOCATE || FIO_HAVE_NATIVE_FALLOCATE */
+#endif /* FIO_HAVE_ANY_FALLOCATE */
 	{
 		.name	= "fadvise_hint",
 		.lname	= "Fadvise hint",
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index 8a116e6..8d15833 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -5,6 +5,7 @@
 
 #include <errno.h>
 #include <unistd.h>
+#include <sys/endian.h>
 #include <sys/param.h>
 #include <sys/sysctl.h>
 #include <sys/statvfs.h>
diff --git a/os/os-freebsd.h b/os/os-freebsd.h
index c7863b5..e6da286 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -6,6 +6,7 @@
 #include <errno.h>
 #include <sys/sysctl.h>
 #include <sys/disk.h>
+#include <sys/endian.h>
 #include <sys/thr.h>
 #include <sys/socket.h>
 #include <sys/param.h>
diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index 7be02a7..eac76cf 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -10,6 +10,7 @@
 #include <sys/ioctl.h>
 #include <sys/dkio.h>
 #include <sys/disklabel.h>
+#include <sys/endian.h>
 /* XXX hack to avoid confilcts between rbtree.h and <sys/rb.h> */
 #define	rb_node	_rb_node
 #include <sys/sysctl.h>
diff --git a/os/os-openbsd.h b/os/os-openbsd.h
index d874ee2..675bf89 100644
--- a/os/os-openbsd.h
+++ b/os/os-openbsd.h
@@ -9,6 +9,7 @@
 #include <sys/ioctl.h>
 #include <sys/dkio.h>
 #include <sys/disklabel.h>
+#include <sys/endian.h>
 #include <sys/utsname.h>
 /* XXX hack to avoid conflicts between rbtree.h and <sys/tree.h> */
 #include <sys/sysctl.h>
diff --git a/os/os.h b/os/os.h
index afee9f9..2e15529 100644
--- a/os/os.h
+++ b/os/os.h
@@ -369,4 +369,8 @@ static inline bool fio_fallocate(struct fio_file *f, uint64_t offset, uint64_t l
 }
 #endif
 
+#if defined(CONFIG_POSIX_FALLOCATE) || defined(FIO_HAVE_NATIVE_FALLOCATE)
+# define FIO_HAVE_ANY_FALLOCATE
+#endif
+
 #endif
