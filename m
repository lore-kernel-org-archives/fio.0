Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43273 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaEBOST (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 2 May 2014 10:18:19 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WgEI7-0006ZN-AS
	for fio@vger.kernel.org; Fri, 02 May 2014 14:18:19 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140502141818.3DD934012B@lyth.info>
Date: Fri,  2 May 2014 08:18:18 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8b89b91bb0b6e6321652619ce405a702c2b4e4e0:

  Merge branch 'master' of ssh://git.kernel.dk/data/git/fio (2014-04-23 09:59:05 -0600)

are available in the git repository at:


  git://git.kernel.dk/fio.git master

for you to fetch changes up to 435228488ffd062f4eac710aaa862e04cd20dfee:

  Avoid buildenv conditional in thread_option struct (2014-05-01 11:21:56 -0600)

----------------------------------------------------------------
Bruce Cran (1):
      Windows: always open files in binary mode

Daniel Gollub (7):
      Fix gfio build due to disk_stat struct seperation
      Rename time.h for third-party include of fio.h
      Replace CONFIG_CPU_COUNT with plain CPU_COUNT
      distinguish internal/ext. builds with FIO_INTERNAL
      Avoid double-declaration of ARRAY_SIZE
      Avoid double declaration of leXX_to_cpu
      Avoid buildenv conditional in thread_option struct

Danny Al-Gaaf (1):
      crc/test.c: fix include of time.h

Jens Axboe (2):
      Add option for io_limit
      Makefile: clean all *.d dependency files on make clean

 HOWTO                |    8 ++++++++
 Makefile             |    4 ++--
 backend.c            |   36 +++++++++++++++++++++++++++++-------
 cconv.c              |    2 ++
 configure            |   19 -------------------
 crc/test.c           |    2 +-
 filesetup.c          |   18 +++++++++++++++---
 fio.1                |   12 ++++++++++--
 fio.h                |    4 +++-
 time.h => fio_time.h |    0
 gclient.c            |   24 ++++++++++++------------
 mutex.c              |    2 +-
 options.c            |   24 ++++++++++++++++++++----
 os/os.h              |    5 ++++-
 server.h             |    2 +-
 thread_options.h     |    8 ++++----
 16 files changed, 112 insertions(+), 58 deletions(-)
 rename time.h => fio_time.h (100%)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index f74360d..1c89d75 100644
--- a/HOWTO
+++ b/HOWTO
@@ -430,6 +430,14 @@ size=int	The total size of file io for this job. Fio will run until
 		is given, fio will use 20% of the full size of the given
 		files or devices.
 
+io_limit=int	Normally fio operates within the region set by 'size', which
+		means that the 'size' option sets both the region and size of
+		IO to be performed. Sometimes that is not what you want. With
+		this option, it is possible to define just the amount of IO
+		that fio should do. For instance, if 'size' is set to 20G and
+		'io_limit' is set to 5G, fio will perform IO within the first
+		20G but exit when 5G have been done.
+
 filesize=int	Individual file sizes. May be a range, in which case fio
 		will select sizes for files at random within the given range
 		and limited to 'size' in total (if that is given). If not
diff --git a/Makefile b/Makefile
index 3c9e0ee..a0f0f71 100644
--- a/Makefile
+++ b/Makefile
@@ -15,7 +15,7 @@ include config-host.mak
 endif
 
 DEBUGFLAGS = -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG
-CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 $(DEBUGFLAGS)
+CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFIO_INTERNAL $(DEBUGFLAGS)
 OPTFLAGS= -O3 -g -ffast-math
 CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS)
 LIBS	+= -lm $(EXTLIBS)
@@ -274,7 +274,7 @@ t/lfsr-test: $(T_LFSR_TEST_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_LFSR_TEST_OBJS) $(LIBS)
 
 clean: FORCE
-	-rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) core.* core gfio FIO-VERSION-FILE *.d config-host.mak config-host.h
+	-rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) core.* core gfio FIO-VERSION-FILE *.d lib/*.d crc/*.d engines/*.d profiles/*.d t/*.d config-host.mak config-host.h
 
 distclean: clean FORCE
 	@rm -f cscope.out fio.pdf fio_generate_plots.pdf fio2gnuplot.pdf
diff --git a/backend.c b/backend.c
index 12e562b..9deef28 100644
--- a/backend.c
+++ b/backend.c
@@ -645,7 +645,7 @@ static unsigned int exceeds_number_ios(struct thread_data *td)
 
 static int io_bytes_exceeded(struct thread_data *td)
 {
-	unsigned long long bytes;
+	unsigned long long bytes, limit;
 
 	if (td_rw(td))
 		bytes = td->this_io_bytes[DDIR_READ] + td->this_io_bytes[DDIR_WRITE];
@@ -656,7 +656,12 @@ static int io_bytes_exceeded(struct thread_data *td)
 	else
 		bytes = td->this_io_bytes[DDIR_TRIM];
 
-	return bytes >= td->o.size || exceeds_number_ios(td);
+	if (td->o.io_limit)
+		limit = td->o.io_limit;
+	else
+		limit = td->o.size;
+
+	return bytes >= limit || exceeds_number_ios(td);
 }
 
 /*
@@ -1141,6 +1146,8 @@ static int switch_ioscheduler(struct thread_data *td)
 
 static int keep_running(struct thread_data *td)
 {
+	unsigned long long limit;
+
 	if (td->done)
 		return 0;
 	if (td->o.time_based)
@@ -1152,14 +1159,19 @@ static int keep_running(struct thread_data *td)
 	if (exceeds_number_ios(td))
 		return 0;
 
-	if (td->o.size != -1ULL && ddir_rw_sum(td->io_bytes) < td->o.size) {
+	if (td->o.io_limit)
+		limit = td->o.io_limit;
+	else
+		limit = td->o.size;
+
+	if (limit != -1ULL && ddir_rw_sum(td->io_bytes) < limit) {
 		uint64_t diff;
 
 		/*
 		 * If the difference is less than the minimum IO size, we
 		 * are done.
 		 */
-		diff = td->o.size - ddir_rw_sum(td->io_bytes);
+		diff = limit - ddir_rw_sum(td->io_bytes);
 		if (diff < td_max_bs(td))
 			return 0;
 
@@ -1327,6 +1339,7 @@ static void *thread_main(void *data)
 #ifdef CONFIG_LIBNUMA
 	/* numa node setup */
 	if (o->numa_cpumask_set || o->numa_memmask_set) {
+		struct bitmask *mask;
 		int ret;
 
 		if (numa_available() < 0) {
@@ -1335,7 +1348,9 @@ static void *thread_main(void *data)
 		}
 
 		if (o->numa_cpumask_set) {
-			ret = numa_run_on_node_mask(o->numa_cpunodesmask);
+			mask = numa_parse_nodestring(o->numa_cpunodes);
+			ret = numa_run_on_node_mask(mask);
+			numa_free_nodemask(mask);
 			if (ret == -1) {
 				td_verror(td, errno, \
 					"numa_run_on_node_mask failed\n");
@@ -1345,12 +1360,16 @@ static void *thread_main(void *data)
 
 		if (o->numa_memmask_set) {
 
+			mask = NULL;
+			if (o->numa_memnodes)
+				mask = numa_parse_nodestring(o->numa_memnodes);
+
 			switch (o->numa_mem_mode) {
 			case MPOL_INTERLEAVE:
-				numa_set_interleave_mask(o->numa_memnodesmask);
+				numa_set_interleave_mask(mask);
 				break;
 			case MPOL_BIND:
-				numa_set_membind(o->numa_memnodesmask);
+				numa_set_membind(mask);
 				break;
 			case MPOL_LOCAL:
 				numa_set_localalloc();
@@ -1363,6 +1382,9 @@ static void *thread_main(void *data)
 				break;
 			}
 
+			if (mask)
+				numa_free_nodemask(mask);
+
 		}
 	}
 #endif
diff --git a/cconv.c b/cconv.c
index ee3b0ca..2f7177d 100644
--- a/cconv.c
+++ b/cconv.c
@@ -80,6 +80,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->iodepth_batch = le32_to_cpu(top->iodepth_batch);
 	o->iodepth_batch_complete = le32_to_cpu(top->iodepth_batch_complete);
 	o->size = le64_to_cpu(top->size);
+	o->io_limit = le64_to_cpu(top->io_limit);
 	o->size_percent = le32_to_cpu(top->size_percent);
 	o->fill_device = le32_to_cpu(top->fill_device);
 	o->file_append = le32_to_cpu(top->file_append);
@@ -428,6 +429,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	memcpy(top->buffer_pattern, o->buffer_pattern, MAX_PATTERN_SIZE);
 
 	top->size = __cpu_to_le64(o->size);
+	top->io_limit = __cpu_to_le64(o->io_limit);
 	top->verify_backlog = __cpu_to_le64(o->verify_backlog);
 	top->start_delay = __cpu_to_le64(o->start_delay);
 	top->start_delay_high = __cpu_to_le64(o->start_delay_high);
diff --git a/configure b/configure
index 4757d67..2ba1daf 100755
--- a/configure
+++ b/configure
@@ -652,22 +652,6 @@ echo "sched_setaffinity(3 arg)      $linux_3arg_affinity"
 echo "sched_setaffinity(2 arg)      $linux_2arg_affinity"
 
 ##########################################
-# CPU_COUNT test
-cpu_count="no"
-cat > $TMPC << EOF
-#include <sched.h>
-int main(int argc, char **argv)
-{
-  cpu_set_t mask;
-  return CPU_COUNT(&mask);
-}
-EOF
-if compile_prog "" "" "cpu_count"; then
-  cpu_count="yes"
-fi
-echo "CPU_COUNT                     $cpu_count"
-
-##########################################
 # clock_gettime probe
 clock_gettime="no"
 cat > $TMPC << EOF
@@ -1335,9 +1319,6 @@ fi
 if test "$rbd" = "yes" ; then
   output_sym "CONFIG_RBD"
 fi
-if test "$cpu_count" = "yes" ; then
-  output_sym "CONFIG_CPU_COUNT"
-fi
 if test "$setvbuf" = "yes" ; then
   output_sym "CONFIG_SETVBUF"
 fi
diff --git a/crc/test.c b/crc/test.c
index 2cc7c0f..3773b71 100644
--- a/crc/test.c
+++ b/crc/test.c
@@ -4,7 +4,7 @@
 
 #include "../fio.h"
 #include "../gettime.h"
-#include "../time.h"
+#include "../fio_time.h"
 #include "../verify.h"
 
 #include "../crc/md5.h"
diff --git a/filesetup.c b/filesetup.c
index 79eea9f..ad7fb85 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -69,6 +69,10 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 	if (new_layout)
 		flags |= O_TRUNC;
 
+#ifdef WIN32
+	flags |= _O_BINARY;
+#endif
+
 	dprint(FD_FILE, "open file %s, flags %x\n", f->file_name, flags);
 	f->fd = open(f->file_name, flags, 0644);
 	if (f->fd < 0) {
@@ -481,6 +485,10 @@ int file_lookup_open(struct fio_file *f, int flags)
 		from_hash = 0;
 	}
 
+#ifdef WIN32
+	flags |= _O_BINARY;
+#endif
+
 	f->fd = open(f->file_name, flags, 0600);
 	return from_hash;
 }
@@ -944,8 +952,12 @@ int setup_files(struct thread_data *td)
 	 * iolog already set the total io size, if we read back
 	 * stored entries.
 	 */
-	if (!o->read_iolog_file)
-		td->total_io_size = o->size * o->loops;
+	if (!o->read_iolog_file) {
+		if (o->io_limit)
+			td->total_io_size = o->io_limit * o->loops;
+		else
+			td->total_io_size = o->size * o->loops;
+	}
 
 done:
 	if (o->create_only)
@@ -1036,7 +1048,7 @@ int init_random_map(struct thread_data *td)
 			unsigned long seed;
 
 			seed = td->rand_seeds[FIO_RAND_BLOCK_OFF];
-			
+
 			if (!lfsr_init(&f->lfsr, blocks, seed, 0))
 				continue;
 		} else if (!td->o.norandommap) {
diff --git a/fio.1 b/fio.1
index 8cf3778..eeb036e 100644
--- a/fio.1
+++ b/fio.1
@@ -369,8 +369,16 @@ Unless \fBnrfiles\fR and \fBfilesize\fR options are given, this amount will be
 divided between the available files for the job. If not set, fio will use the
 full size of the given files or devices. If the files do not exist, size
 must be given. It is also possible to give size as a percentage between 1 and
-100. If size=20% is given, fio will use 20% of the full size of the given files
-or devices.
+100. If size=20% is given, fio will use 20% of the full size of the given
+files or devices.
+.TP
+.BI io_limit \fR=\fPint
+Normally fio operates within the region set by \fBsize\fR, which means that
+the \fBsize\fR option sets both the region and size of IO to be performed.
+Sometimes that is not what you want. With this option, it is possible to
+define just the amount of IO that fio should do. For instance, if \fBsize\fR
+is set to 20G and \fBio_limit\fR is set to 5G, fio will perform IO within
+the first 20G but exit when 5G have been done.
 .TP
 .BI fill_device \fR=\fPbool "\fR,\fB fill_fs" \fR=\fPbool
 Sets size to something really large and waits for ENOSPC (no space left on
diff --git a/fio.h b/fio.h
index 9eecba3..4d4af0a 100644
--- a/fio.h
+++ b/fio.h
@@ -30,7 +30,7 @@
 #include "helpers.h"
 #include "options.h"
 #include "profile.h"
-#include "time.h"
+#include "fio_time.h"
 #include "gettime.h"
 #include "lib/getopt.h"
 #include "lib/rand.h"
@@ -618,7 +618,9 @@ static inline void td_io_u_free_notify(struct thread_data *td)
 extern const char *fio_get_arch_string(int);
 extern const char *fio_get_os_string(int);
 
+#ifdef FIO_INTERNAL
 #define ARRAY_SIZE(x) (sizeof((x)) / (sizeof((x)[0])))
+#endif
 
 enum {
 	FIO_OUTPUT_TERSE	= 0,
diff --git a/fio_time.h b/fio_time.h
new file mode 100644
index 0000000..c550a55
--- /dev/null
+++ b/fio_time.h
@@ -0,0 +1,19 @@
+#ifndef FIO_TIME_H
+#define FIO_TIME_H
+
+extern uint64_t utime_since(struct timeval *, struct timeval *);
+extern uint64_t utime_since_now(struct timeval *);
+extern uint64_t mtime_since(struct timeval *, struct timeval *);
+extern uint64_t mtime_since_now(struct timeval *);
+extern uint64_t time_since_now(struct timeval *);
+extern uint64_t mtime_since_genesis(void);
+extern uint64_t utime_since_genesis(void);
+extern void usec_spin(unsigned int);
+extern void usec_sleep(struct thread_data *, unsigned long);
+extern void fill_start_time(struct timeval *);
+extern void set_genesis_time(void);
+extern int ramp_time_over(struct thread_data *);
+extern int in_ramp_time(struct thread_data *);
+extern void fio_time_init(void);
+
+#endif
diff --git a/gclient.c b/gclient.c
index 4360aea..d236f86 100644
--- a/gclient.c
+++ b/gclient.c
@@ -195,39 +195,39 @@ static int __gfio_disk_util_show(GtkWidget *res_notebook,
 	vbox = gtk_hbox_new(TRUE, 3);
 	gtk_container_add(GTK_CONTAINER(frame), vbox);
 	entry = new_info_entry_in_frame(vbox, "IOs");
-	entry_set_int_value(entry, p->dus.ios[0]);
+	entry_set_int_value(entry, p->dus.s.ios[0]);
 	entry = new_info_entry_in_frame(vbox, "Merges");
-	entry_set_int_value(entry, p->dus.merges[0]);
+	entry_set_int_value(entry, p->dus.s.merges[0]);
 	entry = new_info_entry_in_frame(vbox, "Sectors");
-	entry_set_int_value(entry, p->dus.sectors[0]);
+	entry_set_int_value(entry, p->dus.s.sectors[0]);
 	entry = new_info_entry_in_frame(vbox, "Ticks");
-	entry_set_int_value(entry, p->dus.ticks[0]);
+	entry_set_int_value(entry, p->dus.s.ticks[0]);
 
 	frame = gtk_frame_new("Write");
 	gtk_box_pack_start(GTK_BOX(box), frame, FALSE, FALSE, 2);
 	vbox = gtk_hbox_new(TRUE, 3);
 	gtk_container_add(GTK_CONTAINER(frame), vbox);
 	entry = new_info_entry_in_frame(vbox, "IOs");
-	entry_set_int_value(entry, p->dus.ios[1]);
+	entry_set_int_value(entry, p->dus.s.ios[1]);
 	entry = new_info_entry_in_frame(vbox, "Merges");
-	entry_set_int_value(entry, p->dus.merges[1]);
+	entry_set_int_value(entry, p->dus.s.merges[1]);
 	entry = new_info_entry_in_frame(vbox, "Sectors");
-	entry_set_int_value(entry, p->dus.sectors[1]);
+	entry_set_int_value(entry, p->dus.s.sectors[1]);
 	entry = new_info_entry_in_frame(vbox, "Ticks");
-	entry_set_int_value(entry, p->dus.ticks[1]);
+	entry_set_int_value(entry, p->dus.s.ticks[1]);
 
 	frame = gtk_frame_new("Shared");
 	gtk_box_pack_start(GTK_BOX(box), frame, FALSE, FALSE, 2);
 	vbox = gtk_hbox_new(TRUE, 3);
 	gtk_container_add(GTK_CONTAINER(frame), vbox);
 	entry = new_info_entry_in_frame(vbox, "IO ticks");
-	entry_set_int_value(entry, p->dus.io_ticks);
+	entry_set_int_value(entry, p->dus.s.io_ticks);
 	entry = new_info_entry_in_frame(vbox, "Time in queue");
-	entry_set_int_value(entry, p->dus.time_in_queue);
+	entry_set_int_value(entry, p->dus.s.time_in_queue);
 
 	util = 0.0;
-	if (p->dus.msec)
-		util = (double) 100 * p->dus.io_ticks / (double) p->dus.msec;
+	if (p->dus.s.msec)
+		util = (double) 100 * p->dus.s.io_ticks / (double) p->dus.s.msec;
 	if (util > 100.0)
 		util = 100.0;
 
diff --git a/mutex.c b/mutex.c
index 466e20e..9d10c2c 100644
--- a/mutex.c
+++ b/mutex.c
@@ -15,7 +15,7 @@
 #include "arch/arch.h"
 #include "os/os.h"
 #include "helpers.h"
-#include "time.h"
+#include "fio_time.h"
 #include "gettime.h"
 
 void fio_mutex_remove(struct fio_mutex *mutex)
diff --git a/options.c b/options.c
index 50af7b4..9dcb255 100644
--- a/options.c
+++ b/options.c
@@ -554,6 +554,7 @@ static int str_verify_cpus_allowed_cb(void *data, const char *input)
 static int str_numa_cpunodes_cb(void *data, char *input)
 {
 	struct thread_data *td = data;
+	struct bitmask *verify_bitmask;
 
 	if (parse_dryrun())
 		return 0;
@@ -563,13 +564,15 @@ static int str_numa_cpunodes_cb(void *data, char *input)
 	 * numa_allocate_nodemask(), so it should be freed by
 	 * numa_free_nodemask().
 	 */
-	td->o.numa_cpunodesmask = numa_parse_nodestring(input);
-	if (td->o.numa_cpunodesmask == NULL) {
+	verify_bitmask = numa_parse_nodestring(input);
+	if (verify_bitmask == NULL) {
 		log_err("fio: numa_parse_nodestring failed\n");
 		td_verror(td, 1, "str_numa_cpunodes_cb");
 		return 1;
 	}
+	numa_free_nodemask(verify_bitmask);
 
+	td->o.numa_cpunodes = strdup(input);
 	td->o.numa_cpumask_set = 1;
 	return 0;
 }
@@ -581,6 +584,7 @@ static int str_numa_mpol_cb(void *data, char *input)
 		{ "default", "prefer", "bind", "interleave", "local", NULL };
 	int i;
 	char *nodelist;
+	struct bitmask *verify_bitmask;
 
 	if (parse_dryrun())
 		return 0;
@@ -660,12 +664,15 @@ static int str_numa_mpol_cb(void *data, char *input)
 		break;
 	case MPOL_INTERLEAVE:
 	case MPOL_BIND:
-		td->o.numa_memnodesmask = numa_parse_nodestring(nodelist);
-		if (td->o.numa_memnodesmask == NULL) {
+		verify_bitmask = numa_parse_nodestring(nodelist);
+		if (verify_bitmask == NULL) {
 			log_err("fio: numa_parse_nodestring failed\n");
 			td_verror(td, 1, "str_numa_memnodes_cb");
 			return 1;
 		}
+		td->o.numa_memnodes = strdup(nodelist);
+		numa_free_nodemask(verify_bitmask);
+                
 		break;
 	case MPOL_LOCAL:
 	case MPOL_DEFAULT:
@@ -1595,6 +1602,15 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
+		.name	= "io_limit",
+		.lname	= "IO Limit",
+		.type	= FIO_OPT_STR_VAL,
+		.off1	= td_var_offset(io_limit),
+		.interval = 1024 * 1024,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
 		.name	= "fill_device",
 		.lname	= "Fill device",
 		.alias	= "fill_fs",
diff --git a/os/os.h b/os/os.h
index 2f2d069..b8eee66 100644
--- a/os/os.h
+++ b/os/os.h
@@ -200,6 +200,7 @@ static inline uint64_t fio_swap64(uint64_t val)
 #endif
 #endif /* FIO_HAVE_BYTEORDER_FUNCS */
 
+#ifdef FIO_INTERNAL
 #define le16_to_cpu(val) ({			\
 	__le16_to_cpu(val);			\
 })
@@ -209,6 +210,8 @@ static inline uint64_t fio_swap64(uint64_t val)
 #define le64_to_cpu(val) ({			\
 	__le64_to_cpu(val);				\
 })
+#endif
+
 #define cpu_to_le16(val) ({			\
 	__cpu_to_le16(val);			\
 })
@@ -321,7 +324,7 @@ static inline unsigned int cpus_online(void)
 }
 #endif
 
-#ifndef CONFIG_CPU_COUNT
+#ifndef CPU_COUNT
 #ifdef FIO_HAVE_CPU_AFFINITY
 static inline int CPU_COUNT(os_cpu_mask_t *mask)
 {
diff --git a/server.h b/server.h
index 2958e73..4f09f28 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 33,
+	FIO_SERVER_VER			= 34,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 4642120..57d84db 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -52,6 +52,7 @@ struct thread_options {
 	unsigned int iodepth_batch_complete;
 
 	unsigned long long size;
+	unsigned long long io_limit;
 	unsigned int size_percent;
 	unsigned int fill_device;
 	unsigned int file_append;
@@ -157,14 +158,12 @@ struct thread_options {
 	os_cpu_mask_t verify_cpumask;
 	unsigned int verify_cpumask_set;
 	unsigned int cpus_allowed_policy;
-#ifdef CONFIG_LIBNUMA
-	struct bitmask *numa_cpunodesmask;
+	char *numa_cpunodes;
 	unsigned int numa_cpumask_set;
 	unsigned short numa_mem_mode;
 	unsigned int numa_mem_prefer_node;
-	struct bitmask *numa_memnodesmask;
+	char *numa_memnodes;
 	unsigned int numa_memmask_set;
-#endif
 	unsigned int iolog;
 	unsigned int rwmixcycle;
 	unsigned int rwmix[DDIR_RWDIR_CNT];
@@ -280,6 +279,7 @@ struct thread_options_pack {
 	uint32_t iodepth_batch_complete;
 
 	uint64_t size;
+	uint64_t io_limit;
 	uint32_t size_percent;
 	uint32_t fill_device;
 	uint32_t file_append;
diff --git a/time.h b/time.h
deleted file mode 100644
index c550a55..0000000
--- a/time.h
+++ /dev/null
@@ -1,19 +0,0 @@
-#ifndef FIO_TIME_H
-#define FIO_TIME_H
-
-extern uint64_t utime_since(struct timeval *, struct timeval *);
-extern uint64_t utime_since_now(struct timeval *);
-extern uint64_t mtime_since(struct timeval *, struct timeval *);
-extern uint64_t mtime_since_now(struct timeval *);
-extern uint64_t time_since_now(struct timeval *);
-extern uint64_t mtime_since_genesis(void);
-extern uint64_t utime_since_genesis(void);
-extern void usec_spin(unsigned int);
-extern void usec_sleep(struct thread_data *, unsigned long);
-extern void fill_start_time(struct timeval *);
-extern void set_genesis_time(void);
-extern int ramp_time_over(struct thread_data *);
-extern int in_ramp_time(struct thread_data *);
-extern void fio_time_init(void);
-
-#endif
