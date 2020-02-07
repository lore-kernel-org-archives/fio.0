Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:53708 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgBGNAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 7 Feb 2020 08:00:12 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j03Ev-0000Pw-O6
        for fio@vger.kernel.org; Fri, 07 Feb 2020 13:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200207130001.BCDD21BC0184@kernel.dk>
Date: Fri,  7 Feb 2020 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ac694f66968fe7b18c820468abd8333f3df333fb:

  Fio 3.18 (2020-02-05 07:59:58 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1b5e13beb3acc2a08321ce687727e2cbbb3b954f:

  Merge branch 'master' of https://github.com/vincentkfu/fio (2020-02-06 12:17:25 -0700)

----------------------------------------------------------------
Bart Van Assche (1):
      Make the JSON code easier to analyze

Jens Axboe (3):
      Unify architecture io_uring syscall numbers
      Merge branch 'master' of https://github.com/bvanassche/fio
      Merge branch 'master' of https://github.com/vincentkfu/fio

Vincent Fu (4):
      stat: summary statistics for both high/low priority latencies
      .gitignore: add some test programs
      gfio: add high/low priority latency results
      t/run-fio-tests: fix style issues

 .gitignore             |   3 +
 arch/arch-aarch64.h    |  12 --
 arch/arch-ppc.h        |  12 --
 arch/arch-x86-common.h |  11 -
 arch/arch.h            |  28 +++
 engines/io_uring.c     |   8 +-
 gclient.c              |  55 ++++-
 json.c                 |  68 +++---
 json.h                 | 140 ++++++++++--
 stat.c                 |  10 +-
 t/io_uring.c           |  10 +-
 t/run-fio-tests.py     | 575 ++++++++++++++++++++++++++-----------------------
 12 files changed, 564 insertions(+), 368 deletions(-)

---

Diff of recent changes:

diff --git a/.gitignore b/.gitignore
index b228938d..b84b0fda 100644
--- a/.gitignore
+++ b/.gitignore
@@ -16,7 +16,10 @@
 /t/fio-verify-state
 /t/gen-rand
 /t/ieee754
+t/io_uring
 /t/lfsr-test
+t/memlock
+t/read-to-pipe-async
 /t/stest
 /unittests/unittest
 y.tab.*
diff --git a/arch/arch-aarch64.h b/arch/arch-aarch64.h
index de9b349b..2a86cc5a 100644
--- a/arch/arch-aarch64.h
+++ b/arch/arch-aarch64.h
@@ -8,18 +8,6 @@
 
 #define FIO_ARCH	(arch_aarch64)
 
-#define ARCH_HAVE_IOURING
-
-#ifndef __NR_sys_io_uring_setup
-#define __NR_sys_io_uring_setup		425
-#endif
-#ifndef __NR_sys_io_uring_enter
-#define __NR_sys_io_uring_enter		426
-#endif
-#ifndef __NR_sys_io_uring_register
-#define __NR_sys_io_uring_register	427
-#endif
-
 #define nop		do { __asm__ __volatile__ ("yield"); } while (0)
 #define read_barrier()	do { __sync_synchronize(); } while (0)
 #define write_barrier()	do { __sync_synchronize(); } while (0)
diff --git a/arch/arch-ppc.h b/arch/arch-ppc.h
index 46246bae..804d596a 100644
--- a/arch/arch-ppc.h
+++ b/arch/arch-ppc.h
@@ -24,18 +24,6 @@
 #define PPC_CNTLZL "cntlzw"
 #endif
 
-#define ARCH_HAVE_IOURING
-
-#ifndef __NR_sys_io_uring_setup
-#define __NR_sys_io_uring_setup		425
-#endif
-#ifndef __NR_sys_io_uring_enter
-#define __NR_sys_io_uring_enter		426
-#endif
-#ifndef __NR_sys_io_uring_register
-#define __NR_sys_io_uring_register	427
-#endif
-
 static inline int __ilog2(unsigned long bitmask)
 {
 	int lz;
diff --git a/arch/arch-x86-common.h b/arch/arch-x86-common.h
index 87925bdc..f32835cc 100644
--- a/arch/arch-x86-common.h
+++ b/arch/arch-x86-common.h
@@ -3,16 +3,6 @@
 
 #include <string.h>
 
-#ifndef __NR_sys_io_uring_setup
-#define __NR_sys_io_uring_setup		425
-#endif
-#ifndef __NR_sys_io_uring_enter
-#define __NR_sys_io_uring_enter		426
-#endif
-#ifndef __NR_sys_io_uring_register
-#define __NR_sys_io_uring_register	427
-#endif
-
 static inline void cpuid(unsigned int op,
 			 unsigned int *eax, unsigned int *ebx,
 			 unsigned int *ecx, unsigned int *edx)
@@ -23,7 +13,6 @@ static inline void cpuid(unsigned int op,
 }
 
 #define ARCH_HAVE_INIT
-#define ARCH_HAVE_IOURING
 
 extern bool tsc_reliable;
 extern int arch_random;
diff --git a/arch/arch.h b/arch/arch.h
index 0ec3f10f..30c0d205 100644
--- a/arch/arch.h
+++ b/arch/arch.h
@@ -76,4 +76,32 @@ static inline int arch_init(char *envp[])
 }
 #endif
 
+#ifdef __alpha__
+/*
+ * alpha is the only exception, all other architectures
+ * have common numbers for new system calls.
+ */
+# ifndef __NR_io_uring_setup
+#  define __NR_io_uring_setup		535
+# endif
+# ifndef __NR_io_uring_enter
+#  define __NR_io_uring_enter		536
+# endif
+# ifndef __NR_io_uring_register
+#  define __NR_io_uring_register	537
+# endif
+#else /* !__alpha__ */
+# ifndef __NR_io_uring_setup
+#  define __NR_io_uring_setup		425
+# endif
+# ifndef __NR_io_uring_enter
+#  define __NR_io_uring_enter		426
+# endif
+# ifndef __NR_io_uring_register
+#  define __NR_io_uring_register	427
+# endif
+#endif
+
+#define ARCH_HAVE_IOURING
+
 #endif
diff --git a/engines/io_uring.c b/engines/io_uring.c
index f1ffc712..5e59f975 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -191,7 +191,7 @@ static struct fio_option options[] = {
 static int io_uring_enter(struct ioring_data *ld, unsigned int to_submit,
 			 unsigned int min_complete, unsigned int flags)
 {
-	return syscall(__NR_sys_io_uring_enter, ld->ring_fd, to_submit,
+	return syscall(__NR_io_uring_enter, ld->ring_fd, to_submit,
 			min_complete, flags, NULL, 0);
 }
 
@@ -548,7 +548,7 @@ static int fio_ioring_queue_init(struct thread_data *td)
 		}
 	}
 
-	ret = syscall(__NR_sys_io_uring_setup, depth, &p);
+	ret = syscall(__NR_io_uring_setup, depth, &p);
 	if (ret < 0)
 		return ret;
 
@@ -563,7 +563,7 @@ static int fio_ioring_queue_init(struct thread_data *td)
 		if (setrlimit(RLIMIT_MEMLOCK, &rlim) < 0)
 			return -1;
 
-		ret = syscall(__NR_sys_io_uring_register, ld->ring_fd,
+		ret = syscall(__NR_io_uring_register, ld->ring_fd,
 				IORING_REGISTER_BUFFERS, ld->iovecs, depth);
 		if (ret < 0)
 			return ret;
@@ -589,7 +589,7 @@ static int fio_ioring_register_files(struct thread_data *td)
 		f->engine_pos = i;
 	}
 
-	ret = syscall(__NR_sys_io_uring_register, ld->ring_fd,
+	ret = syscall(__NR_io_uring_register, ld->ring_fd,
 			IORING_REGISTER_FILES, ld->fds, td->o.nr_files);
 	if (ret) {
 err:
diff --git a/gclient.c b/gclient.c
index d2044f32..fe83382f 100644
--- a/gclient.c
+++ b/gclient.c
@@ -1155,18 +1155,21 @@ out:
 #define GFIO_CLAT	1
 #define GFIO_SLAT	2
 #define GFIO_LAT	4
+#define GFIO_HILAT	8
+#define GFIO_LOLAT	16
 
 static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 				  struct group_run_stats *rs,
 				  struct thread_stat *ts, int ddir)
 {
 	const char *ddir_label[3] = { "Read", "Write", "Trim" };
+	const char *hilat, *lolat;
 	GtkWidget *frame, *label, *box, *vbox, *main_vbox;
-	unsigned long long min[3], max[3];
+	unsigned long long min[5], max[5];
 	unsigned long runt;
 	unsigned long long bw, iops;
 	unsigned int flags = 0;
-	double mean[3], dev[3];
+	double mean[5], dev[5];
 	char *io_p, *io_palt, *bw_p, *bw_palt, *iops_p;
 	char tmp[128];
 	int i2p;
@@ -1265,6 +1268,14 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 		flags |= GFIO_CLAT;
 	if (calc_lat(&ts->lat_stat[ddir], &min[2], &max[2], &mean[2], &dev[2]))
 		flags |= GFIO_LAT;
+	if (calc_lat(&ts->clat_high_prio_stat[ddir], &min[3], &max[3], &mean[3], &dev[3])) {
+		flags |= GFIO_HILAT;
+		if (calc_lat(&ts->clat_low_prio_stat[ddir], &min[4], &max[4], &mean[4], &dev[4]))
+			flags |= GFIO_LOLAT;
+		/* we only want to print low priority statistics if other IOs were
+		 * submitted with the priority bit set
+		 */
+	}
 
 	if (flags) {
 		frame = gtk_frame_new("Latency");
@@ -1273,12 +1284,24 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 		vbox = gtk_vbox_new(FALSE, 3);
 		gtk_container_add(GTK_CONTAINER(frame), vbox);
 
+		if (ts->lat_percentiles) {
+			hilat = "High priority total latency";
+			lolat = "Low priority total latency";
+		} else {
+			hilat = "High priority completion latency";
+			lolat = "Low priority completion latency";
+		}
+
 		if (flags & GFIO_SLAT)
 			gfio_show_lat(vbox, "Submission latency", min[0], max[0], mean[0], dev[0]);
 		if (flags & GFIO_CLAT)
 			gfio_show_lat(vbox, "Completion latency", min[1], max[1], mean[1], dev[1]);
 		if (flags & GFIO_LAT)
 			gfio_show_lat(vbox, "Total latency", min[2], max[2], mean[2], dev[2]);
+		if (flags & GFIO_HILAT)
+			gfio_show_lat(vbox, hilat, min[3], max[3], mean[3], dev[3]);
+		if (flags & GFIO_LOLAT)
+			gfio_show_lat(vbox, lolat, min[4], max[4], mean[4], dev[4]);
 	}
 
 	if (ts->slat_percentiles && flags & GFIO_SLAT)
@@ -1286,16 +1309,40 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 				ts->io_u_plat[FIO_SLAT][ddir],
 				ts->slat_stat[ddir].samples,
 				"Submission");
-	if (ts->clat_percentiles && flags & GFIO_CLAT)
+	if (ts->clat_percentiles && flags & GFIO_CLAT) {
 		gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
 				ts->io_u_plat[FIO_CLAT][ddir],
 				ts->clat_stat[ddir].samples,
 				"Completion");
-	if (ts->lat_percentiles && flags & GFIO_LAT)
+		if (!ts->lat_percentiles) {
+			if (flags & GFIO_HILAT)
+				gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
+						ts->io_u_plat_high_prio[ddir],
+						ts->clat_high_prio_stat[ddir].samples,
+						"High priority completion");
+			if (flags & GFIO_LOLAT)
+				gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
+						ts->io_u_plat_low_prio[ddir],
+						ts->clat_low_prio_stat[ddir].samples,
+						"Low priority completion");
+		}
+	}
+	if (ts->lat_percentiles && flags & GFIO_LAT) {
 		gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
 				ts->io_u_plat[FIO_LAT][ddir],
 				ts->lat_stat[ddir].samples,
 				"Total");
+		if (flags & GFIO_HILAT)
+			gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
+					ts->io_u_plat_high_prio[ddir],
+					ts->clat_high_prio_stat[ddir].samples,
+					"High priority total");
+		if (flags & GFIO_LOLAT)
+			gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
+					ts->io_u_plat_low_prio[ddir],
+					ts->clat_low_prio_stat[ddir].samples,
+					"Low priority total");
+	}
 
 	free(io_p);
 	free(bw_p);
diff --git a/json.c b/json.c
index e2819a65..cd3d5d74 100644
--- a/json.c
+++ b/json.c
@@ -194,25 +194,31 @@ static int json_object_add_pair(struct json_object *obj, struct json_pair *pair)
 	return 0;
 }
 
-int json_object_add_value_type(struct json_object *obj, const char *name, int type, ...)
+int json_object_add_value_type(struct json_object *obj, const char *name,
+			       const struct json_value *arg)
 {
 	struct json_value *value;
 	struct json_pair *pair;
-	va_list args;
 	int ret;
 
-	va_start(args, type);
-	if (type == JSON_TYPE_STRING)
-		value = json_create_value_string(va_arg(args, char *));
-	else if (type == JSON_TYPE_INTEGER)
-		value = json_create_value_int(va_arg(args, long long));
-	else if (type == JSON_TYPE_FLOAT)
-		value = json_create_value_float(va_arg(args, double));
-	else if (type == JSON_TYPE_OBJECT)
-		value = json_create_value_object(va_arg(args, struct json_object *));
-	else
-		value = json_create_value_array(va_arg(args, struct json_array *));
-	va_end(args);
+	switch (arg->type) {
+	case JSON_TYPE_STRING:
+		value = json_create_value_string(arg->string);
+		break;
+	case JSON_TYPE_INTEGER:
+		value = json_create_value_int(arg->integer_number);
+		break;
+	case JSON_TYPE_FLOAT:
+		value = json_create_value_float(arg->float_number);
+		break;
+	case JSON_TYPE_OBJECT:
+		value = json_create_value_object(arg->object);
+		break;
+	default:
+	case JSON_TYPE_ARRAY:
+		value = json_create_value_array(arg->array);
+		break;
+	}
 
 	if (!value)
 		return ENOMEM;
@@ -230,24 +236,30 @@ int json_object_add_value_type(struct json_object *obj, const char *name, int ty
 	return 0;
 }
 
-int json_array_add_value_type(struct json_array *array, int type, ...)
+int json_array_add_value_type(struct json_array *array,
+			      const struct json_value *arg)
 {
 	struct json_value *value;
-	va_list args;
 	int ret;
 
-	va_start(args, type);
-	if (type == JSON_TYPE_STRING)
-		value = json_create_value_string(va_arg(args, char *));
-	else if (type == JSON_TYPE_INTEGER)
-		value = json_create_value_int(va_arg(args, long long));
-	else if (type == JSON_TYPE_FLOAT)
-		value = json_create_value_float(va_arg(args, double));
-	else if (type == JSON_TYPE_OBJECT)
-		value = json_create_value_object(va_arg(args, struct json_object *));
-	else
-		value = json_create_value_array(va_arg(args, struct json_array *));
-	va_end(args);
+	switch (arg->type) {
+	case JSON_TYPE_STRING:
+		value = json_create_value_string(arg->string);
+		break;
+	case JSON_TYPE_INTEGER:
+		value = json_create_value_int(arg->integer_number);
+		break;
+	case JSON_TYPE_FLOAT:
+		value = json_create_value_float(arg->float_number);
+		break;
+	case JSON_TYPE_OBJECT:
+		value = json_create_value_object(arg->object);
+		break;
+	default:
+	case JSON_TYPE_ARRAY:
+		value = json_create_value_array(arg->array);
+		break;
+	}
 
 	if (!value)
 		return ENOMEM;
diff --git a/json.h b/json.h
index bcc712cd..09c2f187 100644
--- a/json.h
+++ b/json.h
@@ -49,28 +49,124 @@ struct json_array *json_create_array(void);
 
 void json_free_object(struct json_object *obj);
 
-int json_object_add_value_type(struct json_object *obj, const char *name, int type, ...);
-#define json_object_add_value_int(obj, name, val) \
-	json_object_add_value_type((obj), name, JSON_TYPE_INTEGER, (long long) (val))
-#define json_object_add_value_float(obj, name, val) \
-	json_object_add_value_type((obj), name, JSON_TYPE_FLOAT, (val))
-#define json_object_add_value_string(obj, name, val) \
-	json_object_add_value_type((obj), name, JSON_TYPE_STRING, (val))
-#define json_object_add_value_object(obj, name, val) \
-	json_object_add_value_type((obj), name, JSON_TYPE_OBJECT, (val))
-#define json_object_add_value_array(obj, name, val) \
-	json_object_add_value_type((obj), name, JSON_TYPE_ARRAY, (val))
-int json_array_add_value_type(struct json_array *array, int type, ...);
-#define json_array_add_value_int(obj, val) \
-	json_array_add_value_type((obj), JSON_TYPE_INTEGER, (val))
-#define json_array_add_value_float(obj, val) \
-	json_array_add_value_type((obj), JSON_TYPE_FLOAT, (val))
-#define json_array_add_value_string(obj, val) \
-	json_array_add_value_type((obj), JSON_TYPE_STRING, (val))
-#define json_array_add_value_object(obj, val) \
-	json_array_add_value_type((obj), JSON_TYPE_OBJECT, (val))
-#define json_array_add_value_array(obj, val) \
-	json_array_add_value_type((obj), JSON_TYPE_ARRAY, (val))
+int json_object_add_value_type(struct json_object *obj, const char *name,
+			       const struct json_value *val);
+
+static inline int json_object_add_value_int(struct json_object *obj,
+					    const char *name, long long val)
+{
+	struct json_value arg = {
+		.type = JSON_TYPE_INTEGER,
+		.integer_number = val,
+	};
+
+	return json_object_add_value_type(obj, name, &arg);
+}
+
+static inline int json_object_add_value_float(struct json_object *obj,
+					      const char *name, double val)
+{
+	struct json_value arg = {
+		.type = JSON_TYPE_FLOAT,
+		.float_number = val,
+	};
+
+	return json_object_add_value_type(obj, name, &arg);
+}
+
+static inline int json_object_add_value_string(struct json_object *obj,
+					       const char *name,
+					       const char *val)
+{
+	struct json_value arg = {
+		.type = JSON_TYPE_STRING,
+		.string = (char *)val,
+	};
+
+	return json_object_add_value_type(obj, name, &arg);
+}
+
+static inline int json_object_add_value_object(struct json_object *obj,
+					       const char *name,
+					       struct json_object *val)
+{
+	struct json_value arg = {
+		.type = JSON_TYPE_OBJECT,
+		.object = val,
+	};
+
+	return json_object_add_value_type(obj, name, &arg);
+}
+
+static inline int json_object_add_value_array(struct json_object *obj,
+					      const char *name,
+					      struct json_array *val)
+{
+	struct json_value arg = {
+		.type = JSON_TYPE_ARRAY,
+		.array = val,
+	};
+
+	return json_object_add_value_type(obj, name, &arg);
+}
+
+int json_array_add_value_type(struct json_array *array,
+			      const struct json_value *val);
+
+static inline int json_array_add_value_int(struct json_array *obj,
+					   long long val)
+{
+	struct json_value arg = {
+		.type = JSON_TYPE_INTEGER,
+		.integer_number = val,
+	};
+
+	return json_array_add_value_type(obj, &arg);
+}
+
+static inline int json_array_add_value_float(struct json_array *obj,
+					     double val)
+{
+	struct json_value arg = {
+		.type = JSON_TYPE_FLOAT,
+		.float_number = val,
+	};
+
+	return json_array_add_value_type(obj, &arg);
+}
+
+static inline int json_array_add_value_string(struct json_array *obj,
+					      const char *val)
+{
+	struct json_value arg = {
+		.type = JSON_TYPE_STRING,
+		.string = (char *)val,
+	};
+
+	return json_array_add_value_type(obj, &arg);
+}
+
+static inline int json_array_add_value_object(struct json_array *obj,
+					      struct json_object *val)
+{
+	struct json_value arg = {
+		.type = JSON_TYPE_OBJECT,
+		.object = val,
+	};
+
+	return json_array_add_value_type(obj, &arg);
+}
+
+static inline int json_array_add_value_array(struct json_array *obj,
+					     struct json_array *val)
+{
+	struct json_value arg = {
+		.type = JSON_TYPE_ARRAY,
+		.array = val,
+	};
+
+	return json_array_add_value_type(obj, &arg);
+}
 
 #define json_array_last_value_object(obj) \
 	(obj->values[obj->value_cnt - 1]->object)
diff --git a/stat.c b/stat.c
index 69d57b69..d8c01d14 100644
--- a/stat.c
+++ b/stat.c
@@ -482,9 +482,13 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 		display_lat("clat", min, max, mean, dev, out);
 	if (calc_lat(&ts->lat_stat[ddir], &min, &max, &mean, &dev))
 		display_lat(" lat", min, max, mean, dev, out);
-	if (calc_lat(&ts->clat_high_prio_stat[ddir], &min, &max, &mean, &dev))
-		display_lat(ts->lat_percentiles ? "prio_lat" : "prio_clat",
+	if (calc_lat(&ts->clat_high_prio_stat[ddir], &min, &max, &mean, &dev)) {
+		display_lat(ts->lat_percentiles ? "high prio_lat" : "high prio_clat",
 				min, max, mean, dev, out);
+		if (calc_lat(&ts->clat_low_prio_stat[ddir], &min, &max, &mean, &dev))
+			display_lat(ts->lat_percentiles ? "low prio_lat" : "low prio_clat",
+					min, max, mean, dev, out);
+	}
 
 	if (ts->slat_percentiles && ts->slat_stat[ddir].samples > 0)
 		show_clat_percentiles(ts->io_u_plat[FIO_SLAT][ddir],
@@ -950,7 +954,7 @@ void json_array_add_disk_util(struct disk_util_stat *dus,
 	obj = json_create_object();
 	json_array_add_value_object(array, obj);
 
-	json_object_add_value_string(obj, "name", dus->name);
+	json_object_add_value_string(obj, "name", (const char *)dus->name);
 	json_object_add_value_int(obj, "read_ios", dus->s.ios[0]);
 	json_object_add_value_int(obj, "write_ios", dus->s.ios[1]);
 	json_object_add_value_int(obj, "read_merges", dus->s.merges[0]);
diff --git a/t/io_uring.c b/t/io_uring.c
index c2e5e098..55b75f6e 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -100,7 +100,7 @@ static int io_uring_register_buffers(struct submitter *s)
 	if (do_nop)
 		return 0;
 
-	return syscall(__NR_sys_io_uring_register, s->ring_fd,
+	return syscall(__NR_io_uring_register, s->ring_fd,
 			IORING_REGISTER_BUFFERS, s->iovecs, depth);
 }
 
@@ -117,20 +117,20 @@ static int io_uring_register_files(struct submitter *s)
 		s->files[i].fixed_fd = i;
 	}
 
-	return syscall(__NR_sys_io_uring_register, s->ring_fd,
+	return syscall(__NR_io_uring_register, s->ring_fd,
 			IORING_REGISTER_FILES, s->fds, s->nr_files);
 }
 
 static int io_uring_setup(unsigned entries, struct io_uring_params *p)
 {
-	return syscall(__NR_sys_io_uring_setup, entries, p);
+	return syscall(__NR_io_uring_setup, entries, p);
 }
 
 static int io_uring_enter(struct submitter *s, unsigned int to_submit,
 			  unsigned int min_complete, unsigned int flags)
 {
-	return syscall(__NR_sys_io_uring_enter, s->ring_fd, to_submit,
-			min_complete, flags, NULL, 0);
+	return syscall(__NR_io_uring_enter, s->ring_fd, to_submit, min_complete,
+			flags, NULL, 0);
 }
 
 #ifndef CONFIG_HAVE_GETTID
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 003ff664..36fcb2f4 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -67,8 +67,14 @@ class FioTest(object):
         self.test_dir = None
         self.passed = True
         self.failure_reason = ''
+        self.command_file = None
+        self.stdout_file = None
+        self.stderr_file = None
+        self.exitcode_file = None
 
     def setup(self, artifact_root, testnum):
+        """Setup instance variables for test."""
+
         self.artifact_root = artifact_root
         self.testnum = testnum
         self.test_dir = os.path.join(artifact_root, "{:04d}".format(testnum))
@@ -76,22 +82,26 @@ class FioTest(object):
             os.mkdir(self.test_dir)
 
         self.command_file = os.path.join(
-                self.test_dir,
-                "{0}.command".format(os.path.basename(self.exe_path)))
+            self.test_dir,
+            "{0}.command".format(os.path.basename(self.exe_path)))
         self.stdout_file = os.path.join(
-                self.test_dir,
-                "{0}.stdout".format(os.path.basename(self.exe_path)))
+            self.test_dir,
+            "{0}.stdout".format(os.path.basename(self.exe_path)))
         self.stderr_file = os.path.join(
-                self.test_dir,
-                "{0}.stderr".format(os.path.basename(self.exe_path)))
-        self.exticode_file = os.path.join(
-                self.test_dir,
-                "{0}.exitcode".format(os.path.basename(self.exe_path)))
+            self.test_dir,
+            "{0}.stderr".format(os.path.basename(self.exe_path)))
+        self.exitcode_file = os.path.join(
+            self.test_dir,
+            "{0}.exitcode".format(os.path.basename(self.exe_path)))
 
     def run(self):
+        """Run the test."""
+
         raise NotImplementedError()
 
     def check_result(self):
+        """Check test results."""
+
         raise NotImplementedError()
 
 
@@ -109,10 +119,9 @@ class FioExeTest(FioTest):
 
         FioTest.__init__(self, exe_path, parameters, success)
 
-    def setup(self, artifact_root, testnum):
-        super(FioExeTest, self).setup(artifact_root, testnum)
-
     def run(self):
+        """Execute the binary or script described by this instance."""
+
         if self.parameters:
             command = [self.exe_path] + self.parameters
         else:
@@ -123,7 +132,7 @@ class FioExeTest(FioTest):
 
         stdout_file = open(self.stdout_file, "w+")
         stderr_file = open(self.stderr_file, "w+")
-        exticode_file = open(self.exticode_file, "w+")
+        exitcode_file = open(self.exitcode_file, "w+")
         try:
             proc = None
             # Avoid using subprocess.run() here because when a timeout occurs,
@@ -136,8 +145,8 @@ class FioExeTest(FioTest):
                                     cwd=self.test_dir,
                                     universal_newlines=True)
             proc.communicate(timeout=self.success['timeout'])
-            exticode_file.write('{0}\n'.format(proc.returncode))
-            logging.debug("Test %d: return code: %d" % (self.testnum, proc.returncode))
+            exitcode_file.write('{0}\n'.format(proc.returncode))
+            logging.debug("Test %d: return code: %d", self.testnum, proc.returncode)
             self.output['proc'] = proc
         except subprocess.TimeoutExpired:
             proc.terminate()
@@ -154,17 +163,19 @@ class FioExeTest(FioTest):
         finally:
             stdout_file.close()
             stderr_file.close()
-            exticode_file.close()
+            exitcode_file.close()
 
     def check_result(self):
+        """Check results of test run."""
+
         if 'proc' not in self.output:
             if self.output['failure'] == 'timeout':
                 self.failure_reason = "{0} timeout,".format(self.failure_reason)
             else:
                 assert self.output['failure'] == 'exception'
                 self.failure_reason = '{0} exception: {1}, {2}'.format(
-                        self.failure_reason, self.output['exc_info'][0],
-                        self.output['exc_info'][1])
+                    self.failure_reason, self.output['exc_info'][0],
+                    self.output['exc_info'][1])
 
             self.passed = False
             return
@@ -222,22 +233,26 @@ class FioJobTest(FioExeTest):
         FioExeTest.__init__(self, fio_path, self.fio_args, success)
 
     def setup(self, artifact_root, testnum):
+        """Setup instance variables for fio job test."""
+
         super(FioJobTest, self).setup(artifact_root, testnum)
 
         self.command_file = os.path.join(
-                self.test_dir,
-                "{0}.command".format(os.path.basename(self.fio_job)))
+            self.test_dir,
+            "{0}.command".format(os.path.basename(self.fio_job)))
         self.stdout_file = os.path.join(
-                self.test_dir,
-                "{0}.stdout".format(os.path.basename(self.fio_job)))
+            self.test_dir,
+            "{0}.stdout".format(os.path.basename(self.fio_job)))
         self.stderr_file = os.path.join(
-                self.test_dir,
-                "{0}.stderr".format(os.path.basename(self.fio_job)))
-        self.exticode_file = os.path.join(
-                self.test_dir,
-                "{0}.exitcode".format(os.path.basename(self.fio_job)))
+            self.test_dir,
+            "{0}.stderr".format(os.path.basename(self.fio_job)))
+        self.exitcode_file = os.path.join(
+            self.test_dir,
+            "{0}.exitcode".format(os.path.basename(self.fio_job)))
 
     def run_pre_job(self):
+        """Run fio job precondition step."""
+
         precon = FioJobTest(self.exe_path, self.fio_pre_job,
                             self.fio_pre_success,
                             output_format=self.output_format)
@@ -248,15 +263,19 @@ class FioJobTest(FioExeTest):
         self.failure_reason = precon.failure_reason
 
     def run(self):
+        """Run fio job test."""
+
         if self.fio_pre_job:
             self.run_pre_job()
 
         if not self.precon_failed:
             super(FioJobTest, self).run()
         else:
-            logging.debug("Test %d: precondition step failed" % self.testnum)
+            logging.debug("Test %d: precondition step failed", self.testnum)
 
     def check_result(self):
+        """Check fio job results."""
+
         if self.precon_failed:
             self.passed = False
             self.failure_reason = "{0} precondition step failed,".format(self.failure_reason)
@@ -267,7 +286,7 @@ class FioJobTest(FioExeTest):
         if not self.passed:
             return
 
-        if not 'json' in self.output_format:
+        if 'json' not in self.output_format:
             return
 
         try:
@@ -291,7 +310,7 @@ class FioJobTest(FioExeTest):
             except json.JSONDecodeError:
                 continue
             else:
-                logging.debug("Test %d: skipped %d lines decoding JSON data" % (self.testnum, i))
+                logging.debug("Test %d: skipped %d lines decoding JSON data", self.testnum, i)
                 return
 
         self.failure_reason = "{0} unable to decode JSON data,".format(self.failure_reason)
@@ -328,7 +347,7 @@ class FioJobTest_t0006(FioJobTest):
 
         ratio = self.json_data['jobs'][0]['read']['io_kbytes'] \
             / self.json_data['jobs'][0]['write']['io_kbytes']
-        logging.debug("Test %d: ratio: %f" % (self.testnum, ratio))
+        logging.debug("Test %d: ratio: %f", self.testnum, ratio)
         if ratio < 1.99 or ratio > 2.01:
             self.failure_reason = "{0} read/write ratio mismatch,".format(self.failure_reason)
             self.passed = False
@@ -364,7 +383,7 @@ class FioJobTest_t0008(FioJobTest):
             return
 
         ratio = self.json_data['jobs'][0]['write']['io_kbytes'] / 16568
-        logging.debug("Test %d: ratio: %f" % (self.testnum, ratio))
+        logging.debug("Test %d: ratio: %f", self.testnum, ratio)
 
         if ratio < 0.99 or ratio > 1.01:
             self.failure_reason = "{0} bytes written mismatch,".format(self.failure_reason)
@@ -384,7 +403,7 @@ class FioJobTest_t0009(FioJobTest):
         if not self.passed:
             return
 
-        logging.debug('Test %d: elapsed: %d' % (self.testnum, self.json_data['jobs'][0]['elapsed']))
+        logging.debug('Test %d: elapsed: %d', self.testnum, self.json_data['jobs'][0]['elapsed'])
 
         if self.json_data['jobs'][0]['elapsed'] < 60:
             self.failure_reason = "{0} elapsed time mismatch,".format(self.failure_reason)
@@ -406,8 +425,8 @@ class FioJobTest_t0011(FioJobTest):
         iops1 = self.json_data['jobs'][0]['read']['iops']
         iops2 = self.json_data['jobs'][1]['read']['iops']
         ratio = iops2 / iops1
-        logging.debug("Test %d: iops1: %f" % (self.testnum, iops1))
-        logging.debug("Test %d: ratio: %f" % (self.testnum, ratio))
+        logging.debug("Test %d: iops1: %f", self.testnum, iops1)
+        logging.debug("Test %d: ratio: %f", self.testnum, ratio)
 
         if iops1 < 998 or iops1 > 1002:
             self.failure_reason = "{0} iops value mismatch,".format(self.failure_reason)
@@ -451,11 +470,11 @@ class Requirements(object):
 
             Requirements._root = (os.geteuid() == 0)
             if Requirements._zbd and Requirements._root:
-                    subprocess.run(["modprobe", "null_blk"],
-                                   stdout=subprocess.PIPE,
-                                   stderr=subprocess.PIPE)
-                    if os.path.exists("/sys/module/null_blk/parameters/zoned"):
-                        Requirements._zoned_nullb = True
+                subprocess.run(["modprobe", "null_blk"],
+                               stdout=subprocess.PIPE,
+                               stderr=subprocess.PIPE)
+                if os.path.exists("/sys/module/null_blk/parameters/zoned"):
+                    Requirements._zoned_nullb = True
 
         if platform.system() == "Windows":
             utest_exe = "unittest.exe"
@@ -477,253 +496,273 @@ class Requirements(object):
                     Requirements.cpucount4]
         for req in req_list:
             value, desc = req()
-            logging.debug("Requirements: Requirement '%s' met? %s" % (desc, value))
+            logging.debug("Requirements: Requirement '%s' met? %s", desc, value)
 
-    def linux():
+    @classmethod
+    def linux(cls):
+        """Are we running on Linux?"""
         return Requirements._linux, "Linux required"
 
-    def libaio():
+    @classmethod
+    def libaio(cls):
+        """Is libaio available?"""
         return Requirements._libaio, "libaio required"
 
-    def zbd():
+    @classmethod
+    def zbd(cls):
+        """Is ZBD support available?"""
         return Requirements._zbd, "Zoned block device support required"
 
-    def root():
+    @classmethod
+    def root(cls):
+        """Are we running as root?"""
         return Requirements._root, "root required"
 
-    def zoned_nullb():
+    @classmethod
+    def zoned_nullb(cls):
+        """Are zoned null block devices available?"""
         return Requirements._zoned_nullb, "Zoned null block device support required"
 
-    def not_macos():
+    @classmethod
+    def not_macos(cls):
+        """Are we running on a platform other than macOS?"""
         return Requirements._not_macos, "platform other than macOS required"
 
-    def not_windows():
+    @classmethod
+    def not_windows(cls):
+        """Are we running on a platform other than Windws?"""
         return Requirements._not_windows, "platform other than Windows required"
 
-    def unittests():
+    @classmethod
+    def unittests(cls):
+        """Were unittests built?"""
         return Requirements._unittests, "Unittests support required"
 
-    def cpucount4():
+    @classmethod
+    def cpucount4(cls):
+        """Do we have at least 4 CPUs?"""
         return Requirements._cpucount4, "4+ CPUs required"
 
 
 SUCCESS_DEFAULT = {
-        'zero_return': True,
-        'stderr_empty': True,
-        'timeout': 600,
-        }
+    'zero_return': True,
+    'stderr_empty': True,
+    'timeout': 600,
+    }
 SUCCESS_NONZERO = {
-        'zero_return': False,
-        'stderr_empty': False,
-        'timeout': 600,
-        }
+    'zero_return': False,
+    'stderr_empty': False,
+    'timeout': 600,
+    }
 SUCCESS_STDERR = {
-        'zero_return': True,
-        'stderr_empty': False,
-        'timeout': 600,
-        }
+    'zero_return': True,
+    'stderr_empty': False,
+    'timeout': 600,
+    }
 TEST_LIST = [
-        {
-            'test_id':          1,
-            'test_class':       FioJobTest,
-            'job':              't0001-52c58027.fio',
-            'success':          SUCCESS_DEFAULT,
-            'pre_job':          None,
-            'pre_success':      None,
-            'requirements':     [],
-        },
-        {
-            'test_id':          2,
-            'test_class':       FioJobTest,
-            'job':              't0002-13af05ae-post.fio',
-            'success':          SUCCESS_DEFAULT,
-            'pre_job':          't0002-13af05ae-pre.fio',
-            'pre_success':      None,
-            'requirements':     [Requirements.linux, Requirements.libaio],
-        },
-        {
-            'test_id':          3,
-            'test_class':       FioJobTest,
-            'job':              't0003-0ae2c6e1-post.fio',
-            'success':          SUCCESS_NONZERO,
-            'pre_job':          't0003-0ae2c6e1-pre.fio',
-            'pre_success':      SUCCESS_DEFAULT,
-            'requirements':     [Requirements.linux, Requirements.libaio],
-        },
-        {
-            'test_id':          4,
-            'test_class':       FioJobTest,
-            'job':              't0004-8a99fdf6.fio',
-            'success':          SUCCESS_DEFAULT,
-            'pre_job':          None,
-            'pre_success':      None,
-            'requirements':     [Requirements.linux, Requirements.libaio],
-        },
-        {
-            'test_id':          5,
-            'test_class':       FioJobTest_t0005,
-            'job':              't0005-f7078f7b.fio',
-            'success':          SUCCESS_DEFAULT,
-            'pre_job':          None,
-            'pre_success':      None,
-            'output_format':    'json',
-            'requirements':     [Requirements.not_windows],
-        },
-        {
-            'test_id':          6,
-            'test_class':       FioJobTest_t0006,
-            'job':              't0006-82af2a7c.fio',
-            'success':          SUCCESS_DEFAULT,
-            'pre_job':          None,
-            'pre_success':      None,
-            'output_format':    'json',
-            'requirements':     [Requirements.linux, Requirements.libaio],
-        },
-        {
-            'test_id':          7,
-            'test_class':       FioJobTest_t0007,
-            'job':              't0007-37cf9e3c.fio',
-            'success':          SUCCESS_DEFAULT,
-            'pre_job':          None,
-            'pre_success':      None,
-            'output_format':    'json',
-            'requirements':     [],
-        },
-        {
-            'test_id':          8,
-            'test_class':       FioJobTest_t0008,
-            'job':              't0008-ae2fafc8.fio',
-            'success':          SUCCESS_DEFAULT,
-            'pre_job':          None,
-            'pre_success':      None,
-            'output_format':    'json',
-            'requirements':     [],
-        },
-        {
-            'test_id':          9,
-            'test_class':       FioJobTest_t0009,
-            'job':              't0009-f8b0bd10.fio',
-            'success':          SUCCESS_DEFAULT,
-            'pre_job':          None,
-            'pre_success':      None,
-            'output_format':    'json',
-            'requirements':     [Requirements.not_macos,
-                                 Requirements.cpucount4],
-                                # mac os does not support CPU affinity
-        },
-        {
-            'test_id':          10,
-            'test_class':       FioJobTest,
-            'job':              't0010-b7aae4ba.fio',
-            'success':          SUCCESS_DEFAULT,
-            'pre_job':          None,
-            'pre_success':      None,
-            'requirements':     [],
-        },
-        {
-            'test_id':          11,
-            'test_class':       FioJobTest_t0011,
-            'job':              't0011-5d2788d5.fio',
-            'success':          SUCCESS_DEFAULT,
-            'pre_job':          None,
-            'pre_success':      None,
-            'output_format':    'json',
-            'requirements':     [],
-        },
-        {
-            'test_id':          1000,
-            'test_class':       FioExeTest,
-            'exe':              't/axmap',
-            'parameters':       None,
-            'success':          SUCCESS_DEFAULT,
-            'requirements':     [],
-        },
-        {
-            'test_id':          1001,
-            'test_class':       FioExeTest,
-            'exe':              't/ieee754',
-            'parameters':       None,
-            'success':          SUCCESS_DEFAULT,
-            'requirements':     [],
-        },
-        {
-            'test_id':          1002,
-            'test_class':       FioExeTest,
-            'exe':              't/lfsr-test',
-            'parameters':       ['0xFFFFFF', '0', '0', 'verify'],
-            'success':          SUCCESS_STDERR,
-            'requirements':     [],
-        },
-        {
-            'test_id':          1003,
-            'test_class':       FioExeTest,
-            'exe':              't/readonly.py',
-            'parameters':       ['-f', '{fio_path}'],
-            'success':          SUCCESS_DEFAULT,
-            'requirements':     [],
-        },
-        {
-            'test_id':          1004,
-            'test_class':       FioExeTest,
-            'exe':              't/steadystate_tests.py',
-            'parameters':       ['{fio_path}'],
-            'success':          SUCCESS_DEFAULT,
-            'requirements':     [],
-        },
-        {
-            'test_id':          1005,
-            'test_class':       FioExeTest,
-            'exe':              't/stest',
-            'parameters':       None,
-            'success':          SUCCESS_STDERR,
-            'requirements':     [],
-        },
-        {
-            'test_id':          1006,
-            'test_class':       FioExeTest,
-            'exe':              't/strided.py',
-            'parameters':       ['{fio_path}'],
-            'success':          SUCCESS_DEFAULT,
-            'requirements':     [],
-        },
-        {
-            'test_id':          1007,
-            'test_class':       FioExeTest,
-            'exe':              't/zbd/run-tests-against-regular-nullb',
-            'parameters':       None,
-            'success':          SUCCESS_DEFAULT,
-            'requirements':     [Requirements.linux, Requirements.zbd,
-                                 Requirements.root],
-        },
-        {
-            'test_id':          1008,
-            'test_class':       FioExeTest,
-            'exe':              't/zbd/run-tests-against-zoned-nullb',
-            'parameters':       None,
-            'success':          SUCCESS_DEFAULT,
-            'requirements':     [Requirements.linux, Requirements.zbd,
-                                 Requirements.root, Requirements.zoned_nullb],
-        },
-        {
-            'test_id':          1009,
-            'test_class':       FioExeTest,
-            'exe':              'unittests/unittest',
-            'parameters':       None,
-            'success':          SUCCESS_DEFAULT,
-            'requirements':     [Requirements.unittests],
-        },
-        {
-            'test_id':          1010,
-            'test_class':       FioExeTest,
-            'exe':              't/latency_percentiles.py',
-            'parameters':       ['-f', '{fio_path}'],
-            'success':          SUCCESS_DEFAULT,
-            'requirements':     [],
-        },
+    {
+        'test_id':          1,
+        'test_class':       FioJobTest,
+        'job':              't0001-52c58027.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'requirements':     [],
+    },
+    {
+        'test_id':          2,
+        'test_class':       FioJobTest,
+        'job':              't0002-13af05ae-post.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          't0002-13af05ae-pre.fio',
+        'pre_success':      None,
+        'requirements':     [Requirements.linux, Requirements.libaio],
+    },
+    {
+        'test_id':          3,
+        'test_class':       FioJobTest,
+        'job':              't0003-0ae2c6e1-post.fio',
+        'success':          SUCCESS_NONZERO,
+        'pre_job':          't0003-0ae2c6e1-pre.fio',
+        'pre_success':      SUCCESS_DEFAULT,
+        'requirements':     [Requirements.linux, Requirements.libaio],
+    },
+    {
+        'test_id':          4,
+        'test_class':       FioJobTest,
+        'job':              't0004-8a99fdf6.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'requirements':     [Requirements.linux, Requirements.libaio],
+    },
+    {
+        'test_id':          5,
+        'test_class':       FioJobTest_t0005,
+        'job':              't0005-f7078f7b.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'output_format':    'json',
+        'requirements':     [Requirements.not_windows],
+    },
+    {
+        'test_id':          6,
+        'test_class':       FioJobTest_t0006,
+        'job':              't0006-82af2a7c.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'output_format':    'json',
+        'requirements':     [Requirements.linux, Requirements.libaio],
+    },
+    {
+        'test_id':          7,
+        'test_class':       FioJobTest_t0007,
+        'job':              't0007-37cf9e3c.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'output_format':    'json',
+        'requirements':     [],
+    },
+    {
+        'test_id':          8,
+        'test_class':       FioJobTest_t0008,
+        'job':              't0008-ae2fafc8.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'output_format':    'json',
+        'requirements':     [],
+    },
+    {
+        'test_id':          9,
+        'test_class':       FioJobTest_t0009,
+        'job':              't0009-f8b0bd10.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'output_format':    'json',
+        'requirements':     [Requirements.not_macos,
+                             Requirements.cpucount4],
+        # mac os does not support CPU affinity
+    },
+    {
+        'test_id':          10,
+        'test_class':       FioJobTest,
+        'job':              't0010-b7aae4ba.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'requirements':     [],
+    },
+    {
+        'test_id':          11,
+        'test_class':       FioJobTest_t0011,
+        'job':              't0011-5d2788d5.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'output_format':    'json',
+        'requirements':     [],
+    },
+    {
+        'test_id':          1000,
+        'test_class':       FioExeTest,
+        'exe':              't/axmap',
+        'parameters':       None,
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [],
+    },
+    {
+        'test_id':          1001,
+        'test_class':       FioExeTest,
+        'exe':              't/ieee754',
+        'parameters':       None,
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [],
+    },
+    {
+        'test_id':          1002,
+        'test_class':       FioExeTest,
+        'exe':              't/lfsr-test',
+        'parameters':       ['0xFFFFFF', '0', '0', 'verify'],
+        'success':          SUCCESS_STDERR,
+        'requirements':     [],
+    },
+    {
+        'test_id':          1003,
+        'test_class':       FioExeTest,
+        'exe':              't/readonly.py',
+        'parameters':       ['-f', '{fio_path}'],
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [],
+    },
+    {
+        'test_id':          1004,
+        'test_class':       FioExeTest,
+        'exe':              't/steadystate_tests.py',
+        'parameters':       ['{fio_path}'],
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [],
+    },
+    {
+        'test_id':          1005,
+        'test_class':       FioExeTest,
+        'exe':              't/stest',
+        'parameters':       None,
+        'success':          SUCCESS_STDERR,
+        'requirements':     [],
+    },
+    {
+        'test_id':          1006,
+        'test_class':       FioExeTest,
+        'exe':              't/strided.py',
+        'parameters':       ['{fio_path}'],
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [],
+    },
+    {
+        'test_id':          1007,
+        'test_class':       FioExeTest,
+        'exe':              't/zbd/run-tests-against-regular-nullb',
+        'parameters':       None,
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [Requirements.linux, Requirements.zbd,
+                             Requirements.root],
+    },
+    {
+        'test_id':          1008,
+        'test_class':       FioExeTest,
+        'exe':              't/zbd/run-tests-against-zoned-nullb',
+        'parameters':       None,
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [Requirements.linux, Requirements.zbd,
+                             Requirements.root, Requirements.zoned_nullb],
+    },
+    {
+        'test_id':          1009,
+        'test_class':       FioExeTest,
+        'exe':              'unittests/unittest',
+        'parameters':       None,
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [Requirements.unittests],
+    },
+    {
+        'test_id':          1010,
+        'test_class':       FioExeTest,
+        'exe':              't/latency_percentiles.py',
+        'parameters':       ['-f', '{fio_path}'],
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [],
+    },
 ]
 
 
 def parse_args():
+    """Parse command-line arguments."""
+
     parser = argparse.ArgumentParser()
     parser.add_argument('-r', '--fio-root',
                         help='fio root path')
@@ -745,6 +784,8 @@ def parse_args():
 
 
 def main():
+    """Entry point."""
+
     args = parse_args()
     if args.debug:
         logging.basicConfig(level=logging.DEBUG)
@@ -829,14 +870,14 @@ def main():
             continue
 
         if not args.skip_req:
-            skip = False
+            reqs_met = True
             for req in config['requirements']:
-                ok, reason = req()
-                skip = not ok
-                logging.debug("Test %d: Requirement '%s' met? %s" % (config['test_id'], reason, ok))
-                if skip:
+                reqs_met, reason = req()
+                logging.debug("Test %d: Requirement '%s' met? %s", config['test_id'], reason,
+                              reqs_met)
+                if not reqs_met:
                     break
-            if skip:
+            if not reqs_met:
                 print("Test {0} SKIPPED ({1})".format(config['test_id'], reason))
                 skipped = skipped + 1
                 continue
@@ -851,9 +892,9 @@ def main():
             result = "FAILED: {0}".format(test.failure_reason)
             failed = failed + 1
             with open(test.stderr_file, "r") as stderr_file:
-                logging.debug("Test %d: stderr:\n%s" % (config['test_id'], stderr_file.read()))
+                logging.debug("Test %d: stderr:\n%s", config['test_id'], stderr_file.read())
             with open(test.stdout_file, "r") as stdout_file:
-                logging.debug("Test %d: stdout:\n%s" % (config['test_id'], stdout_file.read()))
+                logging.debug("Test %d: stdout:\n%s", config['test_id'], stdout_file.read())
         print("Test {0} {1}".format(config['test_id'], result))
 
     print("{0} test(s) passed, {1} failed, {2} skipped".format(passed, failed, skipped))

