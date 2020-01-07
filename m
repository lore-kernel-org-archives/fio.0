Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33572 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbgAGNAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Jan 2020 08:00:14 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iooT0-0000Nf-A9
        for fio@vger.kernel.org; Tue, 07 Jan 2020 13:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200107130002.2A53E1BC0C75@kernel.dk>
Date: Tue,  7 Jan 2020 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dbab52955aeb0b58cc88c8eff1b1c2239241f0bd:

  Merge branch 'memalign1' of https://github.com/kusumi/fio (2020-01-05 10:31:40 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2198a6b5a9f40726b40aced24cf2dcdb3b639898:

  Merge branch 'master' of https://github.com/bvanassche/fio (2020-01-06 18:38:02 -0700)

----------------------------------------------------------------
Bart Van Assche (12):
      Makefile: Avoid duplicating code
      Makefile: Use 'tr' if 'fmt' is not available
      configure: Improve the ibverbs test
      configure: Improve the getopt_long_only() test
      Windows: Fix multiple configure tests
      Fix the build in case FIO_HAVE_DISK_UTIL is not defined
      Change off64_t into uint64_t
      Windows: Remove more unused OS dependent code
      Include "oslib/asprintf.h" where necessary
      Windows: Use snprintf() instead of StringCch*()
      Windows: Uninline CPU affinity functions
      Windows >= 7: Make fio_getaffinity() error reporting more detailed

Jens Axboe (3):
      Merge branch 'json1' of https://github.com/kusumi/fio
      Merge branch 'master' of https://github.com/vincentkfu/fio
      Merge branch 'master' of https://github.com/bvanassche/fio

Tomohiro Kusumi (1):
      json: remove two redundant json_print_array() prototypes

Vincent Fu (2):
      t/run-fio-tests: automatically skip t/jobs/t0005 on Windows
      t/steadystate_tests: relax acceptance criterion

 .appveyor.yml             |   2 +-
 Makefile                  |  37 ++--
 configure                 |  43 ++++-
 diskutil.h                |   2 +-
 helpers.c                 |   3 +-
 helpers.h                 |   4 +-
 init.c                    |   1 +
 io_u.c                    |   2 +-
 json.c                    |   3 +-
 os/os-dragonfly.h         |   1 -
 os/os-freebsd.h           |   2 -
 os/os-mac.h               |   2 -
 os/os-netbsd.h            |   2 -
 os/os-openbsd.h           |   2 -
 os/os-windows-7.h         | 360 -------------------------------------
 os/os-windows-xp.h        |  67 -------
 os/os-windows.h           |  17 +-
 os/windows/cpu-affinity.c | 444 ++++++++++++++++++++++++++++++++++++++++++++++
 os/windows/posix.c        |  23 ++-
 os/windows/posix.h        |   1 -
 stat.c                    |   1 +
 t/run-fio-tests.py        |   8 +-
 t/steadystate_tests.py    |  10 +-
 verify.c                  |   1 +
 zbd.c                     |   2 +
 25 files changed, 542 insertions(+), 498 deletions(-)
 create mode 100644 os/windows/cpu-affinity.c

---

Diff of recent changes:

diff --git a/.appveyor.yml b/.appveyor.yml
index 4fb0a90d..bf0978ad 100644
--- a/.appveyor.yml
+++ b/.appveyor.yml
@@ -25,7 +25,7 @@ after_build:
 
 test_script:
   - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && file.exe fio.exe && make.exe test'
-  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && python.exe t/run-fio-tests.py --skip 5 --debug'
+  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && python.exe t/run-fio-tests.py --debug'
 
 artifacts:
   - path: os\windows\*.msi
diff --git a/Makefile b/Makefile
index dd26afca..3c5e0f5b 100644
--- a/Makefile
+++ b/Makefile
@@ -208,7 +208,8 @@ ifeq ($(CONFIG_TARGET_OS), Darwin)
   LIBS	 += -lpthread -ldl
 endif
 ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
-  SOURCE += os/windows/posix.c
+  SOURCE += os/windows/cpu-affinity.c os/windows/posix.c
+  WINDOWS_OBJS = os/windows/cpu-affinity.o os/windows/posix.o lib/hweight.o
   LIBS	 += -lpthread -lpsapi -lws2_32 -lssp
   CFLAGS += -DPSAPI_VERSION=1 -Ios/windows/posix/include -Wno-format
 endif
@@ -299,9 +300,9 @@ T_OBJS += $(T_TT_OBJS)
 T_OBJS += $(T_IOU_RING_OBJS)
 
 ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
-    T_DEDUPE_OBJS += os/windows/posix.o lib/hweight.o
-    T_SMALLOC_OBJS += os/windows/posix.o lib/hweight.o
-    T_LFSR_TEST_OBJS += os/windows/posix.o lib/hweight.o
+    T_DEDUPE_OBJS += $(WINDOWS_OBJS)
+    T_SMALLOC_OBJS += $(WINDOWS_OBJS)
+    T_LFSR_TEST_OBJS += $(WINDOWS_OBJS)
 endif
 
 T_TEST_PROGS = $(T_SMALLOC_PROGS)
@@ -387,13 +388,14 @@ override CFLAGS += -DFIO_VERSION='"$(FIO_VERSION)"'
 	@$(CC) -MM $(CFLAGS) $(CPPFLAGS) $(SRCDIR)/$*.c > $*.d
 	@mv -f $*.d $*.d.tmp
 	@sed -e 's|.*:|$*.o:|' < $*.d.tmp > $*.d
-ifeq ($(CONFIG_TARGET_OS), NetBSD)
-	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | tr -cs "[:graph:]" "\n" | \
-		sed -e 's/^ *//' -e '/^$$/ d' -e 's/$$/:/' >> $*.d
-else
-	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -w 1 | \
-		sed -e 's/^ *//' -e 's/$$/:/' >> $*.d
-endif
+	@if type -p fmt >/dev/null 2>&1; then				\
+		sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -w 1 |	\
+		sed -e 's/^ *//' -e 's/$$/:/' >> $*.d;			\
+	else								\
+		sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp |		\
+		tr -cs "[:graph:]" "\n" |				\
+		sed -e 's/^ *//' -e '/^$$/ d' -e 's/$$/:/' >> $*.d;	\
+	fi
 	@rm -f $*.d.tmp
 
 ifdef CONFIG_ARITHMETIC
@@ -426,19 +428,6 @@ parse.o: lex.yy.o y.tab.o
 endif
 
 init.o: init.c FIO-VERSION-FILE
-	@mkdir -p $(dir $@)
-	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
-	@$(CC) -MM $(CFLAGS) $(CPPFLAGS) $(SRCDIR)/$*.c > $*.d
-	@mv -f $*.d $*.d.tmp
-	@sed -e 's|.*:|$*.o:|' < $*.d.tmp > $*.d
-ifeq ($(CONFIG_TARGET_OS), NetBSD)
-	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | tr -cs "[:graph:]" "\n" | \
-		sed -e 's/^ *//' -e '/^$$/ d' -e 's/$$/:/' >> $*.d
-else
-	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -w 1 | \
-		sed -e 's/^ *//' -e 's/$$/:/' >> $*.d
-endif
-	@rm -f $*.d.tmp
 
 gcompat.o: gcompat.c gcompat.h
 	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c $<
diff --git a/configure b/configure
index fa6df532..a1217700 100755
--- a/configure
+++ b/configure
@@ -381,15 +381,11 @@ CYGWIN*)
   # We now take the regular configuration path without having exit 0 here.
   # Flags below are still necessary mostly for MinGW.
   build_static="yes"
-  socklen_t="yes"
   rusage_thread="yes"
   fdatasync="yes"
   clock_gettime="yes" # clock_monotonic probe has dependency on this
   clock_monotonic="yes"
-  gettimeofday="yes"
   sched_idle="yes"
-  tcp_nodelay="yes"
-  ipv6="yes"
   ;;
 esac
 
@@ -841,7 +837,7 @@ cat > $TMPC << EOF
 int main(int argc, char **argv)
 {
   struct ibv_pd *pd = ibv_alloc_pd(NULL);
-  return 0;
+  return pd != NULL;
 }
 EOF
 if test "$disable_rdma" != "yes" && compile_prog "" "-libverbs" "libverbs" ; then
@@ -1374,7 +1370,7 @@ cat > $TMPC << EOF
 #include <getopt.h>
 int main(int argc, char **argv)
 {
-  int c = getopt_long_only(argc, argv, NULL, NULL, NULL);
+  int c = getopt_long_only(argc, argv, "", NULL, NULL);
   return c;
 }
 EOF
@@ -1389,8 +1385,12 @@ if test "$inet_aton" != "yes" ; then
   inet_aton="no"
 fi
 cat > $TMPC << EOF
+#ifdef _WIN32
+#include <winsock2.h>
+#else
 #include <sys/socket.h>
 #include <arpa/inet.h>
+#endif
 #include <stdio.h>
 int main(int argc, char **argv)
 {
@@ -1409,7 +1409,12 @@ if test "$socklen_t" != "yes" ; then
   socklen_t="no"
 fi
 cat > $TMPC << EOF
+#ifdef _WIN32
+#include <winsock2.h>
+#include <ws2tcpip.h>
+#else
 #include <sys/socket.h>
+#endif
 int main(int argc, char **argv)
 {
   socklen_t len = 0;
@@ -1533,10 +1538,14 @@ if test "$tcp_nodelay" != "yes" ; then
   tcp_nodelay="no"
 fi
 cat > $TMPC << EOF
+#ifdef _WIN32
+#include <winsock2.h>
+#else
 #include <stdio.h>
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <netinet/tcp.h>
+#endif
 int main(int argc, char **argv)
 {
   return getsockopt(0, 0, TCP_NODELAY, NULL, NULL);
@@ -1544,6 +1553,9 @@ int main(int argc, char **argv)
 EOF
 if compile_prog "" "" "TCP_NODELAY"; then
   tcp_nodelay="yes"
+elif compile_prog "" "-lws2_32" "TCP_NODELAY"; then
+  tcp_nodelay="yes"
+  LIBS="$LIBS -lws2_32"
 fi
 print_config "TCP_NODELAY" "$tcp_nodelay"
 
@@ -1553,10 +1565,14 @@ if test "$window_size" != "yes" ; then
   window_size="no"
 fi
 cat > $TMPC << EOF
+#ifdef _WIN32
+#include <winsock2.h>
+#else
 #include <stdio.h>
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <netinet/tcp.h>
+#endif
 int main(int argc, char **argv)
 {
   setsockopt(0, SOL_SOCKET, SO_SNDBUF, NULL, 0);
@@ -1565,6 +1581,9 @@ int main(int argc, char **argv)
 EOF
 if compile_prog "" "" "SO_SNDBUF"; then
   window_size="yes"
+elif compile_prog "" "-lws2_32" "SO_SNDBUF"; then
+  window_size="yes"
+  LIBS="$LIBS -lws2_32"
 fi
 print_config "Net engine window_size" "$window_size"
 
@@ -1574,12 +1593,16 @@ if test "$mss" != "yes" ; then
   mss="no"
 fi
 cat > $TMPC << EOF
+#ifdef _WIN32
+#include <winsock2.h>
+#else
 #include <stdio.h>
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <netinet/tcp.h>
 #include <arpa/inet.h>
 #include <netinet/in.h>
+#endif
 int main(int argc, char **argv)
 {
   return setsockopt(0, IPPROTO_TCP, TCP_MAXSEG, NULL, 0);
@@ -1587,6 +1610,9 @@ int main(int argc, char **argv)
 EOF
 if compile_prog "" "" "TCP_MAXSEG"; then
   mss="yes"
+elif compile_prog "" "-lws2_32" "TCP_MAXSEG"; then
+  mss="yes"
+  LIBS="$LIBS -lws2_32"
 fi
 print_config "TCP_MAXSEG" "$mss"
 
@@ -1651,10 +1677,15 @@ if test "$ipv6" != "yes" ; then
   ipv6="no"
 fi
 cat > $TMPC << EOF
+#ifdef _WIN32
+#include <winsock2.h>
+#include <ws2tcpip.h>
+#else
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <netinet/in.h>
 #include <netdb.h>
+#endif
 #include <stdio.h>
 int main(int argc, char **argv)
 {
diff --git a/diskutil.h b/diskutil.h
index 15ec681a..f6b09d22 100644
--- a/diskutil.h
+++ b/diskutil.h
@@ -120,7 +120,7 @@ static inline void print_disk_util(struct disk_util_stat *du,
 				   struct buf_output *out)
 {
 }
-#define show_disk_util(terse, parent, out)
+#define show_disk_util(terse, parent, out) do { } while (0)
 #define disk_util_prune_entries()
 #define init_disk_util(td)
 #define setup_disk_util()
diff --git a/helpers.c b/helpers.c
index a0ee3704..ab9d706d 100644
--- a/helpers.c
+++ b/helpers.c
@@ -18,7 +18,8 @@ int posix_fallocate(int fd, off_t offset, off_t len)
 #endif
 
 #ifndef CONFIG_SYNC_FILE_RANGE
-int sync_file_range(int fd, off64_t offset, off64_t nbytes, unsigned int flags)
+int sync_file_range(int fd, uint64_t offset, uint64_t nbytes,
+		    unsigned int flags)
 {
 	errno = ENOSYS;
 	return -1;
diff --git a/helpers.h b/helpers.h
index a0b32858..4ec0f052 100644
--- a/helpers.h
+++ b/helpers.h
@@ -7,8 +7,10 @@
 
 extern int fallocate(int fd, int mode, off_t offset, off_t len);
 extern int posix_fallocate(int fd, off_t offset, off_t len);
-extern int sync_file_range(int fd, off64_t offset, off64_t nbytes,
+#ifndef CONFIG_SYNC_FILE_RANGE
+extern int sync_file_range(int fd, uint64_t offset, uint64_t nbytes,
 					unsigned int flags);
+#endif
 extern int posix_fadvise(int fd, off_t offset, off_t len, int advice);
 
 #endif /* FIO_HELPERS_H_ */
diff --git a/init.c b/init.c
index 60c85761..2f64726c 100644
--- a/init.c
+++ b/init.c
@@ -32,6 +32,7 @@
 #include "steadystate.h"
 #include "blktrace.h"
 
+#include "oslib/asprintf.h"
 #include "oslib/getopt.h"
 #include "oslib/strcasestr.h"
 
diff --git a/io_u.c b/io_u.c
index 4a0c725a..03f5c21f 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2182,7 +2182,7 @@ void io_u_fill_buffer(struct thread_data *td, struct io_u *io_u,
 static int do_sync_file_range(const struct thread_data *td,
 			      struct fio_file *f)
 {
-	off64_t offset, nbytes;
+	uint64_t offset, nbytes;
 
 	offset = f->first_write;
 	nbytes = f->last_write - f->first_write;
diff --git a/json.c b/json.c
index 75212c85..e2819a65 100644
--- a/json.c
+++ b/json.c
@@ -230,7 +230,6 @@ int json_object_add_value_type(struct json_object *obj, const char *name, int ty
 	return 0;
 }
 
-static void json_print_array(struct json_array *array, struct buf_output *);
 int json_array_add_value_type(struct json_array *array, int type, ...)
 {
 	struct json_value *value;
@@ -296,8 +295,8 @@ static void json_print_level(int level, struct buf_output *out)
 }
 
 static void json_print_pair(struct json_pair *pair, struct buf_output *);
-static void json_print_array(struct json_array *array, struct buf_output *);
 static void json_print_value(struct json_value *value, struct buf_output *);
+
 void json_print_object(struct json_object *obj, struct buf_output *out)
 {
 	int i;
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index 3c460ae2..44bfcd5d 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -47,7 +47,6 @@
 /* This is supposed to equal (sizeof(cpumask_t)*8) */
 #define FIO_MAX_CPUS	SMP_MAXCPU
 
-typedef off_t off64_t;
 typedef cpumask_t os_cpu_mask_t;
 
 /*
diff --git a/os/os-freebsd.h b/os/os-freebsd.h
index 789da178..b3addf98 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -30,8 +30,6 @@
 #define fio_swap32(x)	bswap32(x)
 #define fio_swap64(x)	bswap64(x)
 
-typedef off_t off64_t;
-
 typedef cpuset_t os_cpu_mask_t;
 
 #define fio_cpu_clear(mask, cpu)        (void) CPU_CLR((cpu), (mask))
diff --git a/os/os-mac.h b/os/os-mac.h
index 0d97f6b9..2852ac67 100644
--- a/os/os-mac.h
+++ b/os/os-mac.h
@@ -33,8 +33,6 @@
  */
 #define FIO_MAX_JOBS		128
 
-typedef off_t off64_t;
-
 #ifndef CONFIG_CLOCKID_T
 typedef unsigned int clockid_t;
 #endif
diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index 88fb3ef1..abc1d3cb 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -35,8 +35,6 @@
 #define fio_swap32(x)	bswap32(x)
 #define fio_swap64(x)	bswap64(x)
 
-typedef off_t off64_t;
-
 static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
 {
 	struct disklabel dl;
diff --git a/os/os-openbsd.h b/os/os-openbsd.h
index 43a649d4..085a6f2b 100644
--- a/os/os-openbsd.h
+++ b/os/os-openbsd.h
@@ -35,8 +35,6 @@
 #define fio_swap32(x)	bswap32(x)
 #define fio_swap64(x)	bswap64(x)
 
-typedef off_t off64_t;
-
 static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
 {
 	struct disklabel dl;
diff --git a/os/os-windows-7.h b/os/os-windows-7.h
index 0a6eaa3c..b8bd9e7c 100644
--- a/os/os-windows-7.h
+++ b/os/os-windows-7.h
@@ -5,363 +5,3 @@
 typedef struct {
 	uint64_t row[FIO_CPU_MASK_ROWS];
 } os_cpu_mask_t;
-
-#define FIO_HAVE_CPU_ONLINE_SYSCONF
-/* Return all processors regardless of processor group */
-static inline unsigned int cpus_online(void)
-{
-	return GetActiveProcessorCount(ALL_PROCESSOR_GROUPS);
-}
-
-static inline void print_mask(os_cpu_mask_t *cpumask)
-{
-	for (int i = 0; i < FIO_CPU_MASK_ROWS; i++)
-		dprint(FD_PROCESS, "cpumask[%d]=%lu\n", i, cpumask->row[i]);
-}
-
-/* Return the index of the least significant set CPU in cpumask or -1 if no
- * CPUs are set */
-static inline int first_set_cpu(os_cpu_mask_t *cpumask)
-{
-	int cpus_offset, mask_first_cpu, row;
-
-	cpus_offset = 0;
-	row = 0;
-	mask_first_cpu = -1;
-	while (mask_first_cpu < 0 && row < FIO_CPU_MASK_ROWS) {
-		int row_first_cpu;
-
-		row_first_cpu = __builtin_ffsll(cpumask->row[row]) - 1;
-		dprint(FD_PROCESS, "row_first_cpu=%d cpumask->row[%d]=%lu\n",
-		       row_first_cpu, row, cpumask->row[row]);
-		if (row_first_cpu > -1) {
-			mask_first_cpu = cpus_offset + row_first_cpu;
-			dprint(FD_PROCESS, "first set cpu in mask is at index %d\n",
-			       mask_first_cpu);
-		} else {
-			cpus_offset += FIO_CPU_MASK_STRIDE;
-			row++;
-		}
-	}
-
-	return mask_first_cpu;
-}
-
-/* Return the index of the most significant set CPU in cpumask or -1 if no
- * CPUs are set */
-static inline int last_set_cpu(os_cpu_mask_t *cpumask)
-{
-	int cpus_offset, mask_last_cpu, row;
-
-	cpus_offset = (FIO_CPU_MASK_ROWS - 1) * FIO_CPU_MASK_STRIDE;
-	row = FIO_CPU_MASK_ROWS - 1;
-	mask_last_cpu = -1;
-	while (mask_last_cpu < 0 && row >= 0) {
-		int row_last_cpu;
-
-		if (cpumask->row[row] == 0)
-			row_last_cpu = -1;
-		else {
-			uint64_t tmp = cpumask->row[row];
-
-			row_last_cpu = 0;
-			while (tmp >>= 1)
-			    row_last_cpu++;
-		}
-
-		dprint(FD_PROCESS, "row_last_cpu=%d cpumask->row[%d]=%lu\n",
-		       row_last_cpu, row, cpumask->row[row]);
-		if (row_last_cpu > -1) {
-			mask_last_cpu = cpus_offset + row_last_cpu;
-			dprint(FD_PROCESS, "last set cpu in mask is at index %d\n",
-			       mask_last_cpu);
-		} else {
-			cpus_offset -= FIO_CPU_MASK_STRIDE;
-			row--;
-		}
-	}
-
-	return mask_last_cpu;
-}
-
-static inline int mask_to_group_mask(os_cpu_mask_t *cpumask, int *processor_group, uint64_t *affinity_mask)
-{
-	WORD online_groups, group, group_size;
-	bool found;
-	int cpus_offset, search_cpu, last_cpu, bit_offset, row, end;
-	uint64_t group_cpumask;
-
-	search_cpu = first_set_cpu(cpumask);
-	if (search_cpu < 0) {
-		log_info("CPU mask doesn't set any CPUs\n");
-		return 1;
-	}
-
-	/* Find processor group first set CPU applies to */
-	online_groups = GetActiveProcessorGroupCount();
-	group = 0;
-	found = false;
-	cpus_offset = 0;
-	group_size = 0;
-	while (!found && group < online_groups) {
-		group_size = GetActiveProcessorCount(group);
-		dprint(FD_PROCESS, "group=%d group_start=%d group_size=%u search_cpu=%d\n",
-		       group, cpus_offset, group_size, search_cpu);
-		if (cpus_offset + group_size > search_cpu)
-			found = true;
-		else {
-			cpus_offset += group_size;
-			group++;
-		}
-	}
-
-	if (!found) {
-		log_err("CPU mask contains processor beyond last active processor index (%d)\n",
-			 cpus_offset - 1);
-		print_mask(cpumask);
-		return 1;
-	}
-
-	/* Check all the CPUs in the mask apply to ONLY that processor group */
-	last_cpu = last_set_cpu(cpumask);
-	if (last_cpu > (cpus_offset + group_size - 1)) {
-		log_info("CPU mask cannot bind CPUs (e.g. %d, %d) that are "
-			 "in different processor groups\n", search_cpu,
-			 last_cpu);
-		print_mask(cpumask);
-		return 1;
-	}
-
-	/* Extract the current processor group mask from the cpumask */
-	row = cpus_offset / FIO_CPU_MASK_STRIDE;
-	bit_offset = cpus_offset % FIO_CPU_MASK_STRIDE;
-	group_cpumask = cpumask->row[row] >> bit_offset;
-	end = bit_offset + group_size;
-	if (end > FIO_CPU_MASK_STRIDE && (row + 1 < FIO_CPU_MASK_ROWS)) {
-		/* Some of the next row needs to be part of the mask */
-		int needed, needed_shift, needed_mask_shift;
-		uint64_t needed_mask;
-
-		needed = end - FIO_CPU_MASK_STRIDE;
-		needed_shift = FIO_CPU_MASK_STRIDE - bit_offset;
-		needed_mask_shift = FIO_CPU_MASK_STRIDE - needed;
-		needed_mask = (uint64_t)-1 >> needed_mask_shift;
-		dprint(FD_PROCESS, "bit_offset=%d end=%d needed=%d needed_shift=%d needed_mask=%ld needed_mask_shift=%d\n", bit_offset, end, needed, needed_shift, needed_mask, needed_mask_shift);
-		group_cpumask |= (cpumask->row[row + 1] & needed_mask) << needed_shift;
-	}
-	group_cpumask &= (uint64_t)-1 >> (FIO_CPU_MASK_STRIDE - group_size);
-
-	/* Return group and mask */
-	dprint(FD_PROCESS, "Returning group=%d group_mask=%lu\n", group, group_cpumask);
-	*processor_group = group;
-	*affinity_mask = group_cpumask;
-
-	return 0;
-}
-
-static inline int fio_setaffinity(int pid, os_cpu_mask_t cpumask)
-{
-	HANDLE handle = NULL;
-	int group, ret;
-	uint64_t group_mask = 0;
-	GROUP_AFFINITY new_group_affinity;
-
-	ret = -1;
-
-	if (mask_to_group_mask(&cpumask, &group, &group_mask) != 0)
-		goto err;
-
-	handle = OpenThread(THREAD_QUERY_INFORMATION | THREAD_SET_INFORMATION,
-			    TRUE, pid);
-	if (handle == NULL) {
-		log_err("fio_setaffinity: failed to get handle for pid %d\n", pid);
-		goto err;
-	}
-
-	/* Set group and mask.
-	 * Note: if the GROUP_AFFINITY struct's Reserved members are not
-	 * initialised to 0 then SetThreadGroupAffinity will fail with
-	 * GetLastError() set to ERROR_INVALID_PARAMETER */
-	new_group_affinity.Mask = (KAFFINITY) group_mask;
-	new_group_affinity.Group = group;
-	new_group_affinity.Reserved[0] = 0;
-	new_group_affinity.Reserved[1] = 0;
-	new_group_affinity.Reserved[2] = 0;
-	if (SetThreadGroupAffinity(handle, &new_group_affinity, NULL) != 0)
-		ret = 0;
-	else {
-		log_err("fio_setaffinity: failed to set thread affinity "
-			 "(pid %d, group %d, mask %" PRIx64 ", "
-			 "GetLastError=%d)\n", pid, group, group_mask,
-			 GetLastError());
-		goto err;
-	}
-
-err:
-	if (handle)
-		CloseHandle(handle);
-	return ret;
-}
-
-static inline void cpu_to_row_offset(int cpu, int *row, int *offset)
-{
-	*row = cpu / FIO_CPU_MASK_STRIDE;
-	*offset = cpu << FIO_CPU_MASK_STRIDE * *row;
-}
-
-static inline int fio_cpuset_init(os_cpu_mask_t *mask)
-{
-	for (int i = 0; i < FIO_CPU_MASK_ROWS; i++)
-		mask->row[i] = 0;
-	return 0;
-}
-
-/*
- * fio_getaffinity() should not be called once a fio_setaffinity() call has
- * been made because fio_setaffinity() may put the process into multiple
- * processor groups
- */
-static inline int fio_getaffinity(int pid, os_cpu_mask_t *mask)
-{
-	int ret;
-	int row, offset, end, group, group_size, group_start_cpu;
-	DWORD_PTR process_mask, system_mask;
-	HANDLE handle;
-	PUSHORT current_groups;
-	USHORT group_count;
-	WORD online_groups;
-
-	ret = -1;
-	current_groups = NULL;
-	handle = OpenProcess(PROCESS_QUERY_INFORMATION, TRUE, pid);
-	if (handle == NULL) {
-		log_err("fio_getaffinity: failed to get handle for pid %d\n",
-			pid);
-		goto err;
-	}
-
-	group_count = 1;
-	/*
-	 * GetProcessGroupAffinity() seems to expect more than the natural
-	 * alignment for a USHORT from the area pointed to by current_groups so
-	 * arrange for maximum alignment by allocating via malloc()
-	 */
-	current_groups = malloc(sizeof(USHORT));
-	if (!current_groups) {
-		log_err("fio_getaffinity: malloc failed\n");
-		goto err;
-	}
-	if (GetProcessGroupAffinity(handle, &group_count, current_groups) == 0) {
-		/* NB: we also fail here if we are a multi-group process */
-		log_err("fio_getaffinity: failed to get single group affinity for pid %d\n", pid);
-		goto err;
-	}
-	GetProcessAffinityMask(handle, &process_mask, &system_mask);
-
-	/* Convert group and group relative mask to full CPU mask */
-	online_groups = GetActiveProcessorGroupCount();
-	if (online_groups == 0) {
-		log_err("fio_getaffinity: error retrieving total processor groups\n");
-		goto err;
-	}
-
-	group = 0;
-	group_start_cpu = 0;
-	group_size = 0;
-	dprint(FD_PROCESS, "current_groups=%d group_count=%d\n",
-	       current_groups[0], group_count);
-	while (true) {
-		group_size = GetActiveProcessorCount(group);
-		if (group_size == 0) {
-			log_err("fio_getaffinity: error retrieving size of "
-				"processor group %d\n", group);
-			goto err;
-		} else if (group >= current_groups[0] || group >= online_groups)
-			break;
-		else {
-			group_start_cpu += group_size;
-			group++;
-		}
-	}
-
-	if (group != current_groups[0]) {
-		log_err("fio_getaffinity: could not find processor group %d\n",
-			current_groups[0]);
-		goto err;
-	}
-
-	dprint(FD_PROCESS, "group_start_cpu=%d, group size=%u\n",
-	       group_start_cpu, group_size);
-	if ((group_start_cpu + group_size) >= FIO_MAX_CPUS) {
-		log_err("fio_getaffinity failed: current CPU affinity (group "
-			"%d, group_start_cpu %d, group_size %d) extends "
-			"beyond mask's highest CPU (%d)\n", group,
-			group_start_cpu, group_size, FIO_MAX_CPUS);
-		goto err;
-	}
-
-	fio_cpuset_init(mask);
-	cpu_to_row_offset(group_start_cpu, &row, &offset);
-	mask->row[row] = process_mask;
-	mask->row[row] <<= offset;
-	end = offset + group_size;
-	if (end > FIO_CPU_MASK_STRIDE) {
-		int needed;
-		uint64_t needed_mask;
-
-		needed = FIO_CPU_MASK_STRIDE - end;
-		needed_mask = (uint64_t)-1 >> (FIO_CPU_MASK_STRIDE - needed);
-		row++;
-		mask->row[row] = process_mask;
-		mask->row[row] >>= needed;
-		mask->row[row] &= needed_mask;
-	}
-	ret = 0;
-
-err:
-	if (handle)
-		CloseHandle(handle);
-	if (current_groups)
-		free(current_groups);
-
-	return ret;
-}
-
-static inline void fio_cpu_clear(os_cpu_mask_t *mask, int cpu)
-{
-	int row, offset;
-	cpu_to_row_offset(cpu, &row, &offset);
-
-	mask->row[row] &= ~(1ULL << offset);
-}
-
-static inline void fio_cpu_set(os_cpu_mask_t *mask, int cpu)
-{
-	int row, offset;
-	cpu_to_row_offset(cpu, &row, &offset);
-
-	mask->row[row] |= 1ULL << offset;
-}
-
-static inline int fio_cpu_isset(os_cpu_mask_t *mask, int cpu)
-{
-	int row, offset;
-	cpu_to_row_offset(cpu, &row, &offset);
-
-	return (mask->row[row] & (1ULL << offset)) != 0;
-}
-
-static inline int fio_cpu_count(os_cpu_mask_t *mask)
-{
-	int count = 0;
-
-	for (int i = 0; i < FIO_CPU_MASK_ROWS; i++)
-		count += hweight64(mask->row[i]);
-
-	return count;
-}
-
-static inline int fio_cpuset_exit(os_cpu_mask_t *mask)
-{
-	return 0;
-}
diff --git a/os/os-windows-xp.h b/os/os-windows-xp.h
index 1ce9ab31..fbc23e2c 100644
--- a/os/os-windows-xp.h
+++ b/os/os-windows-xp.h
@@ -1,70 +1,3 @@
 #define FIO_MAX_CPUS	MAXIMUM_PROCESSORS
 
 typedef DWORD_PTR os_cpu_mask_t;
-
-static inline int fio_setaffinity(int pid, os_cpu_mask_t cpumask)
-{
-	HANDLE h;
-	BOOL bSuccess = FALSE;
-
-	h = OpenThread(THREAD_QUERY_INFORMATION | THREAD_SET_INFORMATION, TRUE, pid);
-	if (h != NULL) {
-		bSuccess = SetThreadAffinityMask(h, cpumask);
-		if (!bSuccess)
-			log_err("fio_setaffinity failed: failed to set thread affinity (pid %d, mask %.16llx)\n", pid, cpumask);
-
-		CloseHandle(h);
-	} else {
-		log_err("fio_setaffinity failed: failed to get handle for pid %d\n", pid);
-	}
-
-	return (bSuccess)? 0 : -1;
-}
-
-static inline int fio_getaffinity(int pid, os_cpu_mask_t *mask)
-{
-	os_cpu_mask_t systemMask;
-
-	HANDLE h = OpenProcess(PROCESS_QUERY_INFORMATION, TRUE, pid);
-
-	if (h != NULL) {
-		GetProcessAffinityMask(h, mask, &systemMask);
-		CloseHandle(h);
-	} else {
-		log_err("fio_getaffinity failed: failed to get handle for pid %d\n", pid);
-		return -1;
-	}
-
-	return 0;
-}
-
-static inline void fio_cpu_clear(os_cpu_mask_t *mask, int cpu)
-{
-	*mask &= ~(1ULL << cpu);
-}
-
-static inline void fio_cpu_set(os_cpu_mask_t *mask, int cpu)
-{
-	*mask |= 1ULL << cpu;
-}
-
-static inline int fio_cpu_isset(os_cpu_mask_t *mask, int cpu)
-{
-	return (*mask & (1ULL << cpu)) != 0;
-}
-
-static inline int fio_cpu_count(os_cpu_mask_t *mask)
-{
-	return hweight64(*mask);
-}
-
-static inline int fio_cpuset_init(os_cpu_mask_t *mask)
-{
-	*mask = 0;
-	return 0;
-}
-
-static inline int fio_cpuset_exit(os_cpu_mask_t *mask)
-{
-	return 0;
-}
diff --git a/os/os-windows.h b/os/os-windows.h
index 6061d8c7..6d48ffe8 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -22,11 +22,6 @@
 
 #include "windows/posix.h"
 
-/* MinGW won't declare rand_r unless _POSIX is defined */
-#if defined(WIN32) && !defined(rand_r)
-int rand_r(unsigned *);
-#endif
-
 #ifndef PTHREAD_STACK_MIN
 #define PTHREAD_STACK_MIN 65535
 #endif
@@ -219,7 +214,19 @@ static inline int fio_mkdir(const char *path, mode_t mode) {
 #ifdef CONFIG_WINDOWS_XP
 #include "os-windows-xp.h"
 #else
+#define FIO_HAVE_CPU_ONLINE_SYSCONF
+unsigned int cpus_online(void);
 #include "os-windows-7.h"
 #endif
 
+int first_set_cpu(os_cpu_mask_t *cpumask);
+int fio_setaffinity(int pid, os_cpu_mask_t cpumask);
+int fio_cpuset_init(os_cpu_mask_t *mask);
+int fio_getaffinity(int pid, os_cpu_mask_t *mask);
+void fio_cpu_clear(os_cpu_mask_t *mask, int cpu);
+void fio_cpu_set(os_cpu_mask_t *mask, int cpu);
+int fio_cpu_isset(os_cpu_mask_t *mask, int cpu);
+int fio_cpu_count(os_cpu_mask_t *mask);
+int fio_cpuset_exit(os_cpu_mask_t *mask);
+
 #endif /* FIO_OS_WINDOWS_H */
diff --git a/os/windows/cpu-affinity.c b/os/windows/cpu-affinity.c
new file mode 100644
index 00000000..69997b24
--- /dev/null
+++ b/os/windows/cpu-affinity.c
@@ -0,0 +1,444 @@
+#include "os/os.h"
+
+#include <windows.h>
+
+#ifdef CONFIG_WINDOWS_XP
+int fio_setaffinity(int pid, os_cpu_mask_t cpumask)
+{
+	HANDLE h;
+	BOOL bSuccess = FALSE;
+
+	h = OpenThread(THREAD_QUERY_INFORMATION | THREAD_SET_INFORMATION, TRUE,
+		       pid);
+	if (h != NULL) {
+		bSuccess = SetThreadAffinityMask(h, cpumask);
+		if (!bSuccess)
+			log_err("fio_setaffinity failed: failed to set thread affinity (pid %d, mask %.16llx)\n",
+				pid, cpumask);
+
+		CloseHandle(h);
+	} else {
+		log_err("fio_setaffinity failed: failed to get handle for pid %d\n",
+			pid);
+	}
+
+	return bSuccess ? 0 : -1;
+}
+
+int fio_getaffinity(int pid, os_cpu_mask_t *mask)
+{
+	os_cpu_mask_t systemMask;
+
+	HANDLE h = OpenProcess(PROCESS_QUERY_INFORMATION, TRUE, pid);
+
+	if (h != NULL) {
+		GetProcessAffinityMask(h, mask, &systemMask);
+		CloseHandle(h);
+	} else {
+		log_err("fio_getaffinity failed: failed to get handle for pid %d\n",
+			pid);
+		return -1;
+	}
+
+	return 0;
+}
+
+void fio_cpu_clear(os_cpu_mask_t *mask, int cpu)
+{
+	*mask &= ~(1ULL << cpu);
+}
+
+void fio_cpu_set(os_cpu_mask_t *mask, int cpu)
+{
+	*mask |= 1ULL << cpu;
+}
+
+int fio_cpu_isset(os_cpu_mask_t *mask, int cpu)
+{
+	return (*mask & (1ULL << cpu)) != 0;
+}
+
+int fio_cpu_count(os_cpu_mask_t *mask)
+{
+	return hweight64(*mask);
+}
+
+int fio_cpuset_init(os_cpu_mask_t *mask)
+{
+	*mask = 0;
+	return 0;
+}
+
+int fio_cpuset_exit(os_cpu_mask_t *mask)
+{
+	return 0;
+}
+#else /* CONFIG_WINDOWS_XP */
+/* Return all processors regardless of processor group */
+unsigned int cpus_online(void)
+{
+	return GetActiveProcessorCount(ALL_PROCESSOR_GROUPS);
+}
+
+static void print_mask(os_cpu_mask_t *cpumask)
+{
+	for (int i = 0; i < FIO_CPU_MASK_ROWS; i++)
+		dprint(FD_PROCESS, "cpumask[%d]=%lu\n", i, cpumask->row[i]);
+}
+
+/* Return the index of the least significant set CPU in cpumask or -1 if no
+ * CPUs are set */
+int first_set_cpu(os_cpu_mask_t *cpumask)
+{
+	int cpus_offset, mask_first_cpu, row;
+
+	cpus_offset = 0;
+	row = 0;
+	mask_first_cpu = -1;
+	while (mask_first_cpu < 0 && row < FIO_CPU_MASK_ROWS) {
+		int row_first_cpu;
+
+		row_first_cpu = __builtin_ffsll(cpumask->row[row]) - 1;
+		dprint(FD_PROCESS, "row_first_cpu=%d cpumask->row[%d]=%lu\n",
+		       row_first_cpu, row, cpumask->row[row]);
+		if (row_first_cpu > -1) {
+			mask_first_cpu = cpus_offset + row_first_cpu;
+			dprint(FD_PROCESS, "first set cpu in mask is at index %d\n",
+			       mask_first_cpu);
+		} else {
+			cpus_offset += FIO_CPU_MASK_STRIDE;
+			row++;
+		}
+	}
+
+	return mask_first_cpu;
+}
+
+/* Return the index of the most significant set CPU in cpumask or -1 if no
+ * CPUs are set */
+static int last_set_cpu(os_cpu_mask_t *cpumask)
+{
+	int cpus_offset, mask_last_cpu, row;
+
+	cpus_offset = (FIO_CPU_MASK_ROWS - 1) * FIO_CPU_MASK_STRIDE;
+	row = FIO_CPU_MASK_ROWS - 1;
+	mask_last_cpu = -1;
+	while (mask_last_cpu < 0 && row >= 0) {
+		int row_last_cpu;
+
+		if (cpumask->row[row] == 0)
+			row_last_cpu = -1;
+		else {
+			uint64_t tmp = cpumask->row[row];
+
+			row_last_cpu = 0;
+			while (tmp >>= 1)
+			    row_last_cpu++;
+		}
+
+		dprint(FD_PROCESS, "row_last_cpu=%d cpumask->row[%d]=%lu\n",
+		       row_last_cpu, row, cpumask->row[row]);
+		if (row_last_cpu > -1) {
+			mask_last_cpu = cpus_offset + row_last_cpu;
+			dprint(FD_PROCESS, "last set cpu in mask is at index %d\n",
+			       mask_last_cpu);
+		} else {
+			cpus_offset -= FIO_CPU_MASK_STRIDE;
+			row--;
+		}
+	}
+
+	return mask_last_cpu;
+}
+
+static int mask_to_group_mask(os_cpu_mask_t *cpumask, int *processor_group, uint64_t *affinity_mask)
+{
+	WORD online_groups, group, group_size;
+	bool found;
+	int cpus_offset, search_cpu, last_cpu, bit_offset, row, end;
+	uint64_t group_cpumask;
+
+	search_cpu = first_set_cpu(cpumask);
+	if (search_cpu < 0) {
+		log_info("CPU mask doesn't set any CPUs\n");
+		return 1;
+	}
+
+	/* Find processor group first set CPU applies to */
+	online_groups = GetActiveProcessorGroupCount();
+	group = 0;
+	found = false;
+	cpus_offset = 0;
+	group_size = 0;
+	while (!found && group < online_groups) {
+		group_size = GetActiveProcessorCount(group);
+		dprint(FD_PROCESS, "group=%d group_start=%d group_size=%u search_cpu=%d\n",
+		       group, cpus_offset, group_size, search_cpu);
+		if (cpus_offset + group_size > search_cpu)
+			found = true;
+		else {
+			cpus_offset += group_size;
+			group++;
+		}
+	}
+
+	if (!found) {
+		log_err("CPU mask contains processor beyond last active processor index (%d)\n",
+			 cpus_offset - 1);
+		print_mask(cpumask);
+		return 1;
+	}
+
+	/* Check all the CPUs in the mask apply to ONLY that processor group */
+	last_cpu = last_set_cpu(cpumask);
+	if (last_cpu > (cpus_offset + group_size - 1)) {
+		log_info("CPU mask cannot bind CPUs (e.g. %d, %d) that are "
+			 "in different processor groups\n", search_cpu,
+			 last_cpu);
+		print_mask(cpumask);
+		return 1;
+	}
+
+	/* Extract the current processor group mask from the cpumask */
+	row = cpus_offset / FIO_CPU_MASK_STRIDE;
+	bit_offset = cpus_offset % FIO_CPU_MASK_STRIDE;
+	group_cpumask = cpumask->row[row] >> bit_offset;
+	end = bit_offset + group_size;
+	if (end > FIO_CPU_MASK_STRIDE && (row + 1 < FIO_CPU_MASK_ROWS)) {
+		/* Some of the next row needs to be part of the mask */
+		int needed, needed_shift, needed_mask_shift;
+		uint64_t needed_mask;
+
+		needed = end - FIO_CPU_MASK_STRIDE;
+		needed_shift = FIO_CPU_MASK_STRIDE - bit_offset;
+		needed_mask_shift = FIO_CPU_MASK_STRIDE - needed;
+		needed_mask = (uint64_t)-1 >> needed_mask_shift;
+		dprint(FD_PROCESS, "bit_offset=%d end=%d needed=%d needed_shift=%d needed_mask=%ld needed_mask_shift=%d\n", bit_offset, end, needed, needed_shift, needed_mask, needed_mask_shift);
+		group_cpumask |= (cpumask->row[row + 1] & needed_mask) << needed_shift;
+	}
+	group_cpumask &= (uint64_t)-1 >> (FIO_CPU_MASK_STRIDE - group_size);
+
+	/* Return group and mask */
+	dprint(FD_PROCESS, "Returning group=%d group_mask=%lu\n", group, group_cpumask);
+	*processor_group = group;
+	*affinity_mask = group_cpumask;
+
+	return 0;
+}
+
+int fio_setaffinity(int pid, os_cpu_mask_t cpumask)
+{
+	HANDLE handle = NULL;
+	int group, ret;
+	uint64_t group_mask = 0;
+	GROUP_AFFINITY new_group_affinity;
+
+	ret = -1;
+
+	if (mask_to_group_mask(&cpumask, &group, &group_mask) != 0)
+		goto err;
+
+	handle = OpenThread(THREAD_QUERY_INFORMATION | THREAD_SET_INFORMATION,
+			    TRUE, pid);
+	if (handle == NULL) {
+		log_err("fio_setaffinity: failed to get handle for pid %d\n", pid);
+		goto err;
+	}
+
+	/* Set group and mask.
+	 * Note: if the GROUP_AFFINITY struct's Reserved members are not
+	 * initialised to 0 then SetThreadGroupAffinity will fail with
+	 * GetLastError() set to ERROR_INVALID_PARAMETER */
+	new_group_affinity.Mask = (KAFFINITY) group_mask;
+	new_group_affinity.Group = group;
+	new_group_affinity.Reserved[0] = 0;
+	new_group_affinity.Reserved[1] = 0;
+	new_group_affinity.Reserved[2] = 0;
+	if (SetThreadGroupAffinity(handle, &new_group_affinity, NULL) != 0)
+		ret = 0;
+	else {
+		log_err("fio_setaffinity: failed to set thread affinity "
+			 "(pid %d, group %d, mask %" PRIx64 ", "
+			 "GetLastError=%d)\n", pid, group, group_mask,
+			 GetLastError());
+		goto err;
+	}
+
+err:
+	if (handle)
+		CloseHandle(handle);
+	return ret;
+}
+
+static void cpu_to_row_offset(int cpu, int *row, int *offset)
+{
+	*row = cpu / FIO_CPU_MASK_STRIDE;
+	*offset = cpu << FIO_CPU_MASK_STRIDE * *row;
+}
+
+int fio_cpuset_init(os_cpu_mask_t *mask)
+{
+	for (int i = 0; i < FIO_CPU_MASK_ROWS; i++)
+		mask->row[i] = 0;
+	return 0;
+}
+
+/*
+ * fio_getaffinity() should not be called once a fio_setaffinity() call has
+ * been made because fio_setaffinity() may put the process into multiple
+ * processor groups
+ */
+int fio_getaffinity(int pid, os_cpu_mask_t *mask)
+{
+	int ret;
+	int row, offset, end, group, group_size, group_start_cpu;
+	DWORD_PTR process_mask, system_mask;
+	HANDLE handle;
+	PUSHORT current_groups;
+	USHORT group_count;
+	WORD online_groups;
+
+	ret = -1;
+	current_groups = NULL;
+	handle = OpenProcess(PROCESS_QUERY_INFORMATION, TRUE, pid);
+	if (handle == NULL) {
+		log_err("fio_getaffinity: failed to get handle for pid %d\n",
+			pid);
+		goto err;
+	}
+
+	group_count = 16;
+	/*
+	 * GetProcessGroupAffinity() seems to expect more than the natural
+	 * alignment for a USHORT from the area pointed to by current_groups so
+	 * arrange for maximum alignment by allocating via malloc()
+	 */
+	current_groups = malloc(group_count * sizeof(USHORT));
+	if (!current_groups) {
+		log_err("fio_getaffinity: malloc failed\n");
+		goto err;
+	}
+	if (!GetProcessGroupAffinity(handle, &group_count, current_groups)) {
+		log_err("%s: failed to get single group affinity for pid %d (%d)\n",
+			__func__, pid, GetLastError());
+		goto err;
+	}
+	if (group_count > 1) {
+		log_err("%s: pid %d is associated with %d process groups\n",
+			__func__, pid, group_count);
+		goto err;
+	}
+	if (!GetProcessAffinityMask(handle, &process_mask, &system_mask)) {
+		log_err("%s: GetProcessAffinityMask() failed for pid\n",
+			__func__, pid);
+		goto err;
+	}
+
+	/* Convert group and group relative mask to full CPU mask */
+	online_groups = GetActiveProcessorGroupCount();
+	if (online_groups == 0) {
+		log_err("fio_getaffinity: error retrieving total processor groups\n");
+		goto err;
+	}
+
+	group = 0;
+	group_start_cpu = 0;
+	group_size = 0;
+	dprint(FD_PROCESS, "current_groups=%d group_count=%d\n",
+	       current_groups[0], group_count);
+	while (true) {
+		group_size = GetActiveProcessorCount(group);
+		if (group_size == 0) {
+			log_err("fio_getaffinity: error retrieving size of "
+				"processor group %d\n", group);
+			goto err;
+		} else if (group >= current_groups[0] || group >= online_groups)
+			break;
+		else {
+			group_start_cpu += group_size;
+			group++;
+		}
+	}
+
+	if (group != current_groups[0]) {
+		log_err("fio_getaffinity: could not find processor group %d\n",
+			current_groups[0]);
+		goto err;
+	}
+
+	dprint(FD_PROCESS, "group_start_cpu=%d, group size=%u\n",
+	       group_start_cpu, group_size);
+	if ((group_start_cpu + group_size) >= FIO_MAX_CPUS) {
+		log_err("fio_getaffinity failed: current CPU affinity (group "
+			"%d, group_start_cpu %d, group_size %d) extends "
+			"beyond mask's highest CPU (%d)\n", group,
+			group_start_cpu, group_size, FIO_MAX_CPUS);
+		goto err;
+	}
+
+	fio_cpuset_init(mask);
+	cpu_to_row_offset(group_start_cpu, &row, &offset);
+	mask->row[row] = process_mask;
+	mask->row[row] <<= offset;
+	end = offset + group_size;
+	if (end > FIO_CPU_MASK_STRIDE) {
+		int needed;
+		uint64_t needed_mask;
+
+		needed = FIO_CPU_MASK_STRIDE - end;
+		needed_mask = (uint64_t)-1 >> (FIO_CPU_MASK_STRIDE - needed);
+		row++;
+		mask->row[row] = process_mask;
+		mask->row[row] >>= needed;
+		mask->row[row] &= needed_mask;
+	}
+	ret = 0;
+
+err:
+	if (handle)
+		CloseHandle(handle);
+	if (current_groups)
+		free(current_groups);
+
+	return ret;
+}
+
+void fio_cpu_clear(os_cpu_mask_t *mask, int cpu)
+{
+	int row, offset;
+	cpu_to_row_offset(cpu, &row, &offset);
+
+	mask->row[row] &= ~(1ULL << offset);
+}
+
+void fio_cpu_set(os_cpu_mask_t *mask, int cpu)
+{
+	int row, offset;
+	cpu_to_row_offset(cpu, &row, &offset);
+
+	mask->row[row] |= 1ULL << offset;
+}
+
+int fio_cpu_isset(os_cpu_mask_t *mask, int cpu)
+{
+	int row, offset;
+	cpu_to_row_offset(cpu, &row, &offset);
+
+	return (mask->row[row] & (1ULL << offset)) != 0;
+}
+
+int fio_cpu_count(os_cpu_mask_t *mask)
+{
+	int count = 0;
+
+	for (int i = 0; i < FIO_CPU_MASK_ROWS; i++)
+		count += hweight64(mask->row[i]);
+
+	return count;
+}
+
+int fio_cpuset_exit(os_cpu_mask_t *mask)
+{
+	return 0;
+}
+#endif /* CONFIG_WINDOWS_XP */
diff --git a/os/windows/posix.c b/os/windows/posix.c
index fd1d5582..e36453e9 100644
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -28,10 +28,6 @@
 extern unsigned long mtime_since_now(struct timespec *);
 extern void fio_gettime(struct timespec *, void *);
 
-/* These aren't defined in the MinGW headers */
-HRESULT WINAPI StringCchCopyA(char *pszDest, size_t cchDest, const char *pszSrc);
-HRESULT WINAPI StringCchPrintfA(char *pszDest, size_t cchDest, const char *pszFormat, ...);
-
 int win_to_posix_error(DWORD winerr)
 {
 	switch (winerr) {
@@ -312,11 +308,11 @@ char *ctime_r(const time_t *t, char *buf)
 	 * We don't know how long `buf` is, but assume it's rounded up from
 	 * the minimum of 25 to 32
 	 */
-	StringCchPrintfA(buf, 31, "%s %s %d %02d:%02d:%02d %04d\n",
-				dayOfWeek[systime.wDayOfWeek % 7],
-				monthOfYear[(systime.wMonth - 1) % 12],
-				systime.wDay, systime.wHour, systime.wMinute,
-				systime.wSecond, systime.wYear);
+	snprintf(buf, 32, "%s %s %d %02d:%02d:%02d %04d\n",
+		 dayOfWeek[systime.wDayOfWeek % 7],
+		 monthOfYear[(systime.wMonth - 1) % 12],
+		 systime.wDay, systime.wHour, systime.wMinute,
+		 systime.wSecond, systime.wYear);
 	return buf;
 }
 
@@ -958,8 +954,8 @@ DIR *opendir(const char *dirname)
 				OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS, NULL);
 	if (file != INVALID_HANDLE_VALUE) {
 		CloseHandle(file);
-		dc = (struct dirent_ctx*)malloc(sizeof(struct dirent_ctx));
-		StringCchCopyA(dc->dirname, MAX_PATH, dirname);
+		dc = malloc(sizeof(struct dirent_ctx));
+		snprintf(dc->dirname, sizeof(dc->dirname), "%s", dirname);
 		dc->find_handle = INVALID_HANDLE_VALUE;
 	} else {
 		DWORD error = GetLastError();
@@ -999,7 +995,8 @@ struct dirent *readdir(DIR *dirp)
 	if (dirp->find_handle == INVALID_HANDLE_VALUE) {
 		char search_pattern[MAX_PATH];
 
-		StringCchPrintfA(search_pattern, MAX_PATH-1, "%s\\*", dirp->dirname);
+		snprintf(search_pattern, sizeof(search_pattern), "%s\\*",
+			 dirp->dirname);
 		dirp->find_handle = FindFirstFileA(search_pattern, &find_data);
 		if (dirp->find_handle == INVALID_HANDLE_VALUE)
 			return NULL;
@@ -1008,7 +1005,7 @@ struct dirent *readdir(DIR *dirp)
 			return NULL;
 	}
 
-	StringCchCopyA(de.d_name, MAX_PATH, find_data.cFileName);
+	snprintf(de.d_name, sizeof(de.d_name), find_data.cFileName);
 	de.d_ino = 0;
 
 	return &de;
diff --git a/os/windows/posix.h b/os/windows/posix.h
index 85640a21..02a9075b 100644
--- a/os/windows/posix.h
+++ b/os/windows/posix.h
@@ -1,7 +1,6 @@
 #ifndef FIO_WINDOWS_POSIX_H
 #define FIO_WINDOWS_POSIX_H
 
-typedef off_t off64_t;
 typedef int clockid_t;
 
 extern int clock_gettime(clockid_t clock_id, struct timespec *tp);
diff --git a/stat.c b/stat.c
index e2bc8ddb..2b303494 100644
--- a/stat.c
+++ b/stat.c
@@ -15,6 +15,7 @@
 #include "helper_thread.h"
 #include "smalloc.h"
 #include "zbd.h"
+#include "oslib/asprintf.h"
 
 #define LOG_MSEC_SLACK	1
 
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index a0a1e8fa..3d236e37 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -428,11 +428,13 @@ class Requirements(object):
     _root = False
     _zoned_nullb = False
     _not_macos = False
+    _not_windows = False
     _unittests = False
     _cpucount4 = False
 
     def __init__(self, fio_root):
         Requirements._not_macos = platform.system() != "Darwin"
+        Requirements._not_windows = platform.system() != "Windows"
         Requirements._linux = platform.system() == "Linux"
 
         if Requirements._linux:
@@ -470,6 +472,7 @@ class Requirements(object):
                     Requirements.root,
                     Requirements.zoned_nullb,
                     Requirements.not_macos,
+                    Requirements.not_windows,
                     Requirements.unittests,
                     Requirements.cpucount4]
         for req in req_list:
@@ -494,6 +497,9 @@ class Requirements(object):
     def not_macos():
         return Requirements._not_macos, "platform other than macOS required"
 
+    def not_windows():
+        return Requirements._not_windows, "platform other than Windows required"
+
     def unittests():
         return Requirements._unittests, "Unittests support required"
 
@@ -561,7 +567,7 @@ TEST_LIST = [
             'pre_job':          None,
             'pre_success':      None,
             'output_format':    'json',
-            'requirements':     [],
+            'requirements':     [Requirements.not_windows],
         },
         {
             'test_id':          6,
diff --git a/t/steadystate_tests.py b/t/steadystate_tests.py
index 9122a60f..b55a67ac 100755
--- a/t/steadystate_tests.py
+++ b/t/steadystate_tests.py
@@ -187,7 +187,7 @@ if __name__ == '__main__':
                     # check runtime, confirm criterion calculation, and confirm that criterion was not met
                     expected = job['timeout'] * 1000
                     actual = jsonjob['read']['runtime']
-                    if abs(expected - actual) > 10:
+                    if abs(expected - actual) > 50:
                         line = 'FAILED ' + line + ' ss not attained, expected runtime {0} != actual runtime {1}'.format(expected, actual)
                     else:
                         line = line + ' ss not attained, runtime {0} != ss_dur {1} + ss_ramp {2},'.format(actual, job['ss_dur'], job['ss_ramp'])
@@ -215,12 +215,12 @@ if __name__ == '__main__':
             else:
                 expected = job['timeout'] * 1000
                 actual = jsonjob['read']['runtime']
-                if abs(expected - actual) < 10:
-                    result = 'PASSED '
-                    passed = passed + 1
-                else:
+                if abs(expected - actual) > 50:
                     result = 'FAILED '
                     failed = failed + 1
+                else:
+                    result = 'PASSED '
+                    passed = passed + 1
                 line = result + line + ' no ss, expected runtime {0} ~= actual runtime {1}'.format(expected, actual)
             print(line)
             if 'steadystate' in jsonjob:
diff --git a/verify.c b/verify.c
index 37d2be8d..a2c0d41d 100644
--- a/verify.c
+++ b/verify.c
@@ -14,6 +14,7 @@
 #include "lib/rand.h"
 #include "lib/hweight.h"
 #include "lib/pattern.h"
+#include "oslib/asprintf.h"
 
 #include "crc/md5.h"
 #include "crc/crc64.h"
diff --git a/zbd.c b/zbd.c
index 99310c49..ee8bcb30 100644
--- a/zbd.c
+++ b/zbd.c
@@ -13,10 +13,12 @@
 #include <sys/stat.h>
 #include <unistd.h>
 #include <linux/blkzoned.h>
+
 #include "file.h"
 #include "fio.h"
 #include "lib/pow2.h"
 #include "log.h"
+#include "oslib/asprintf.h"
 #include "smalloc.h"
 #include "verify.h"
 #include "zbd.h"

