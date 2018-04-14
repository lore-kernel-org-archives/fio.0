Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:42328 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751152AbeDNMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 14 Apr 2018 08:00:09 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1f7Jqi-00021s-0P
        for fio@vger.kernel.org; Sat, 14 Apr 2018 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180414120002.7214A2C0079@kernel.dk>
Date: Sat, 14 Apr 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4fe721ac83e84df7c6be07394d1963fd1ec5d9a6:

  os/os-dragonfly: sync with header file changes in upstream (2018-04-10 09:17:22 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c479640d6208236744f0562b1e79535eec290e2b:

  Merge branch 'proc_group' of https://github.com/sitsofe/fio (2018-04-13 17:25:35 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'proc_group' of https://github.com/sitsofe/fio

Sitsofe Wheeler (7):
      windows: update EULA
      windows: prepare for Windows build split
      windows: target Windows 7 and add support for more than 64 CPUs
      doc: add Windows processor group behaviour and Windows target option
      configure/Makefile: make Cygwin force less
      appveyor: make 32 bit build target XP + minor fixes
      doc: add cpus_allowed reference to log_compression_cpus

 HOWTO                                |  47 +++--
 Makefile                             |   3 -
 README                               |  11 +-
 appveyor.yml                         |   4 +-
 configure                            |  29 ++-
 fio.1                                |  47 +++--
 os/os-windows-7.h                    | 367 +++++++++++++++++++++++++++++++++++
 os/os-windows-xp.h                   |  70 +++++++
 os/os-windows.h                      |  85 +-------
 os/windows/eula.rtf                  | Bin 1075 -> 1077 bytes
 os/windows/posix.c                   |   2 +
 os/windows/posix/include/arpa/inet.h |   2 +
 os/windows/posix/include/poll.h      |   9 +
 server.c                             |   6 +-
 14 files changed, 551 insertions(+), 131 deletions(-)
 create mode 100644 os/os-windows-7.h
 create mode 100644 os/os-windows-xp.h

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index dbbbfaa..5c8623d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2377,24 +2377,27 @@ Threads, processes and job synchronization
 
 	Set the I/O priority class. See man :manpage:`ionice(1)`.
 
-.. option:: cpumask=int
-
-	Set the CPU affinity of this job. The parameter given is a bit mask of
-	allowed CPUs the job may run on. So if you want the allowed CPUs to be 1
-	and 5, you would pass the decimal value of (1 << 1 | 1 << 5), or 34. See man
-	:manpage:`sched_setaffinity(2)`. This may not work on all supported
-	operating systems or kernel versions. This option doesn't work well for a
-	higher CPU count than what you can store in an integer mask, so it can only
-	control cpus 1-32. For boxes with larger CPU counts, use
-	:option:`cpus_allowed`.
-
 .. option:: cpus_allowed=str
 
 	Controls the same options as :option:`cpumask`, but accepts a textual
-	specification of the permitted CPUs instead. So to use CPUs 1 and 5 you
-	would specify ``cpus_allowed=1,5``. This option also allows a range of CPUs
-	to be specified -- say you wanted a binding to CPUs 1, 5, and 8 to 15, you
-	would set ``cpus_allowed=1,5,8-15``.
+	specification of the permitted CPUs instead and CPUs are indexed from 0. So
+	to use CPUs 0 and 5 you would specify ``cpus_allowed=0,5``. This option also
+	allows a range of CPUs to be specified -- say you wanted a binding to CPUs
+	0, 5, and 8 to 15, you would set ``cpus_allowed=0,5,8-15``.
+
+	On Windows, when ``cpus_allowed`` is unset only CPUs from fio's current
+	processor group will be used and affinity settings are inherited from the
+	system. An fio build configured to target Windows 7 makes options that set
+	CPUs processor group aware and values will set both the processor group
+	and a CPU from within that group. For example, on a system where processor
+	group 0 has 40 CPUs and processor group 1 has 32 CPUs, ``cpus_allowed``
+	values between 0 and 39 will bind CPUs from processor group 0 and
+	``cpus_allowed`` values between 40 and 71 will bind CPUs from processor
+	group 1. When using ``cpus_allowed_policy=shared`` all CPUs specified by a
+	single ``cpus_allowed`` option must be from the same processor group. For
+	Windows fio builds not built for Windows 7, CPUs will only be selected from
+	(and be relative to) whatever processor group fio happens to be running in
+	and CPUs from other processor groups cannot be used.
 
 .. option:: cpus_allowed_policy=str
 
@@ -2411,6 +2414,17 @@ Threads, processes and job synchronization
 	enough CPUs are given for the jobs listed, then fio will roundrobin the CPUs
 	in the set.
 
+.. option:: cpumask=int
+
+	Set the CPU affinity of this job. The parameter given is a bit mask of
+	allowed CPUs the job may run on. So if you want the allowed CPUs to be 1
+	and 5, you would pass the decimal value of (1 << 1 | 1 << 5), or 34. See man
+	:manpage:`sched_setaffinity(2)`. This may not work on all supported
+	operating systems or kernel versions. This option doesn't work well for a
+	higher CPU count than what you can store in an integer mask, so it can only
+	control cpus 1-32. For boxes with larger CPU counts, use
+	:option:`cpus_allowed`.
+
 .. option:: numa_cpu_nodes=str
 
 	Set this job running on specified NUMA nodes' CPUs. The arguments allow
@@ -2921,7 +2935,8 @@ Measurements and reporting
 
 	Define the set of CPUs that are allowed to handle online log compression for
 	the I/O jobs. This can provide better isolation between performance
-	sensitive jobs, and background compression work.
+	sensitive jobs, and background compression work. See
+	:option:`cpus_allowed` for the format used.
 
 .. option:: log_store_compressed=bool
 
diff --git a/Makefile b/Makefile
index cc4b71f..357ae98 100644
--- a/Makefile
+++ b/Makefile
@@ -59,9 +59,6 @@ ifdef CONFIG_LIBHDFS
   SOURCE += engines/libhdfs.c
 endif
 
-ifdef CONFIG_64BIT_LLP64
-  CFLAGS += -DBITS_PER_LONG=32
-endif
 ifdef CONFIG_64BIT
   CFLAGS += -DBITS_PER_LONG=64
 endif
diff --git a/README b/README
index fba5f10..38022bb 100644
--- a/README
+++ b/README
@@ -172,15 +172,18 @@ directory.
 How to compile fio on 64-bit Windows:
 
  1. Install Cygwin (http://www.cygwin.com/). Install **make** and all
-    packages starting with **mingw64-i686** and **mingw64-x86_64**. Ensure
-    **mingw64-i686-zlib** and **mingw64-x86_64-zlib** are installed if you wish
+    packages starting with **mingw64-x86_64**. Ensure
+    **mingw64-x86_64-zlib** are installed if you wish
     to enable fio's log compression functionality.
  2. Open the Cygwin Terminal.
  3. Go to the fio directory (source files).
  4. Run ``make clean && make -j``.
 
-To build fio on 32-bit Windows, run ``./configure --build-32bit-win`` before
-``make``.
+To build fio for 32-bit Windows, ensure the -i686 versions of the previously
+mentioned -x86_64 packages are installed and run ``./configure
+--build-32bit-win`` before ``make``. To build an fio that supports versions of
+Windows below Windows 7/Windows Server 2008 R2 also add ``--target-win-ver=xp``
+to the end of the configure line that you run before doing ``make``.
 
 It's recommended that once built or installed, fio be run in a Command Prompt or
 other 'native' console such as console2, since there are known to be display and
diff --git a/appveyor.yml b/appveyor.yml
index 09ebccf..ca8b2ab 100644
--- a/appveyor.yml
+++ b/appveyor.yml
@@ -10,10 +10,10 @@ environment:
       CONFIGURE_OPTIONS:
     - platform: x86
       PACKAGE_ARCH: i686
-      CONFIGURE_OPTIONS: --build-32bit-win
+      CONFIGURE_OPTIONS: --build-32bit-win --target-win-ver=xp
 
 install:
-  - '%CYG_ROOT%\setup-x86_64.exe --quiet-mode --no-shortcuts --only-site --site "%CYG_MIRROR%" --packages "mingw64-%PACKAGE_ARCH%-zlib" > NULL'
+  - '%CYG_ROOT%\setup-x86_64.exe --quiet-mode --no-shortcuts --only-site --site "%CYG_MIRROR%" --packages "mingw64-%PACKAGE_ARCH%-zlib" > NUL'
   - SET PATH=%CYG_ROOT%\bin;%PATH% #��NB: Changed env variables persist to later sections
 
 build_script:
diff --git a/configure b/configure
index 38706a9..32baec6 100755
--- a/configure
+++ b/configure
@@ -167,6 +167,8 @@ for opt do
   ;;
   --build-32bit-win) build_32bit_win="yes"
   ;;
+  --target-win-ver=*) target_win_ver="$optarg"
+  ;;
   --build-static) build_static="yes"
   ;;
   --enable-gfio) gfio_check="yes"
@@ -213,6 +215,7 @@ if test "$show_help" = "yes" ; then
   echo "--cc=                   Specify compiler to use"
   echo "--extra-cflags=         Specify extra CFLAGS to pass to compiler"
   echo "--build-32bit-win       Enable 32-bit build on Windows"
+  echo "--target-win-ver=       Minimum version of Windows to target (XP or 7)"
   echo "--build-static          Build a static fio"
   echo "--esx                   Configure build options for esx"
   echo "--enable-gfio           Enable building of gtk gfio"
@@ -329,20 +332,27 @@ CYGWIN*)
       cc="x86_64-w64-mingw32-gcc"
     fi
   fi
-  if test ! -z "$build_32bit_win" && test "$build_32bit_win" = "yes"; then
-    output_sym "CONFIG_32BIT"
+
+  target_win_ver=$(echo "$target_win_ver" | tr '[:lower:]' '[:upper:]')
+  if test -z "$target_win_ver"; then
+    # Default Windows API target
+    target_win_ver="7"
+  fi
+  if test "$target_win_ver" = "XP"; then
+    output_sym "CONFIG_WINDOWS_XP"
+  elif test "$target_win_ver" = "7"; then
+    output_sym "CONFIG_WINDOWS_7"
+    CFLAGS="$CFLAGS -D_WIN32_WINNT=0x0601"
   else
-    output_sym "CONFIG_64BIT_LLP64"
+    fatal "Unknown target Windows version"
   fi
+
   # We need this to be output_sym'd here because this is Windows specific.
   # The regular configure path never sets this config.
   output_sym "CONFIG_WINDOWSAIO"
   # We now take the regular configuration path without having exit 0 here.
   # Flags below are still necessary mostly for MinGW.
   socklen_t="yes"
-  sfaa="yes"
-  sync_sync="yes"
-  cmp_swap="yes"
   rusage_thread="yes"
   fdatasync="yes"
   clock_gettime="yes" # clock_monotonic probe has dependency on this
@@ -350,11 +360,7 @@ CYGWIN*)
   gettimeofday="yes"
   sched_idle="yes"
   tcp_nodelay="yes"
-  tls_thread="yes"
-  static_assert="yes"
   ipv6="yes"
-  mkdir_two="no"
-  echo "BUILD_CFLAGS=$CFLAGS -include config-host.h -D_GNU_SOURCE" >> $config_host_mak
   ;;
 esac
 
@@ -498,6 +504,9 @@ fi
 print_config "Operating system" "$targetos"
 print_config "CPU" "$cpu"
 print_config "Big endian" "$bigendian"
+if test ! -z "$target_win_ver"; then
+  print_config "Target Windows version" "$target_win_ver"
+fi
 print_config "Compiler" "$cc"
 print_config "Cross compile" "$cross_compile"
 echo
diff --git a/fio.1 b/fio.1
index 5ca57ce..dd4f9cb 100644
--- a/fio.1
+++ b/fio.1
@@ -2091,22 +2091,28 @@ systems since meaning of priority may differ.
 .BI prioclass \fR=\fPint
 Set the I/O priority class. See man \fBionice\fR\|(1).
 .TP
-.BI cpumask \fR=\fPint
-Set the CPU affinity of this job. The parameter given is a bit mask of
-allowed CPUs the job may run on. So if you want the allowed CPUs to be 1
-and 5, you would pass the decimal value of (1 << 1 | 1 << 5), or 34. See man
-\fBsched_setaffinity\fR\|(2). This may not work on all supported
-operating systems or kernel versions. This option doesn't work well for a
-higher CPU count than what you can store in an integer mask, so it can only
-control cpus 1\-32. For boxes with larger CPU counts, use
-\fBcpus_allowed\fR.
-.TP
 .BI cpus_allowed \fR=\fPstr
 Controls the same options as \fBcpumask\fR, but accepts a textual
-specification of the permitted CPUs instead. So to use CPUs 1 and 5 you
-would specify `cpus_allowed=1,5'. This option also allows a range of CPUs
-to be specified \-\- say you wanted a binding to CPUs 1, 5, and 8 to 15, you
-would set `cpus_allowed=1,5,8\-15'.
+specification of the permitted CPUs instead and CPUs are indexed from 0. So
+to use CPUs 0 and 5 you would specify `cpus_allowed=0,5'. This option also
+allows a range of CPUs to be specified \-\- say you wanted a binding to CPUs
+0, 5, and 8 to 15, you would set `cpus_allowed=0,5,8\-15'.
+.RS
+.P
+On Windows, when `cpus_allowed' is unset only CPUs from fio's current
+processor group will be used and affinity settings are inherited from the
+system. An fio build configured to target Windows 7 makes options that set
+CPUs processor group aware and values will set both the processor group
+and a CPU from within that group. For example, on a system where processor
+group 0 has 40 CPUs and processor group 1 has 32 CPUs, `cpus_allowed'
+values between 0 and 39 will bind CPUs from processor group 0 and
+`cpus_allowed' values between 40 and 71 will bind CPUs from processor
+group 1. When using `cpus_allowed_policy=shared' all CPUs specified by a
+single `cpus_allowed' option must be from the same processor group. For
+Windows fio builds not built for Windows 7, CPUs will only be selected from
+(and be relative to) whatever processor group fio happens to be running in
+and CPUs from other processor groups cannot be used.
+.RE
 .TP
 .BI cpus_allowed_policy \fR=\fPstr
 Set the policy of how fio distributes the CPUs specified by
@@ -2127,6 +2133,16 @@ enough CPUs are given for the jobs listed, then fio will roundrobin the CPUs
 in the set.
 .RE
 .TP
+.BI cpumask \fR=\fPint
+Set the CPU affinity of this job. The parameter given is a bit mask of
+allowed CPUs the job may run on. So if you want the allowed CPUs to be 1
+and 5, you would pass the decimal value of (1 << 1 | 1 << 5), or 34. See man
+\fBsched_setaffinity\fR\|(2). This may not work on all supported
+operating systems or kernel versions. This option doesn't work well for a
+higher CPU count than what you can store in an integer mask, so it can only
+control cpus 1\-32. For boxes with larger CPU counts, use
+\fBcpus_allowed\fR.
+.TP
 .BI numa_cpu_nodes \fR=\fPstr
 Set this job running on specified NUMA nodes' CPUs. The arguments allow
 comma delimited list of cpu numbers, A\-B ranges, or `all'. Note, to enable
@@ -2603,7 +2619,8 @@ zlib.
 .BI log_compression_cpus \fR=\fPstr
 Define the set of CPUs that are allowed to handle online log compression for
 the I/O jobs. This can provide better isolation between performance
-sensitive jobs, and background compression work.
+sensitive jobs, and background compression work. See \fBcpus_allowed\fR for
+the format used.
 .TP
 .BI log_store_compressed \fR=\fPbool
 If set, fio will store the log files in a compressed format. They can be
diff --git a/os/os-windows-7.h b/os/os-windows-7.h
new file mode 100644
index 0000000..f5ddb8e
--- /dev/null
+++ b/os/os-windows-7.h
@@ -0,0 +1,367 @@
+#define FIO_MAX_CPUS		512 /* From Hyper-V 2016's max logical processors */
+#define FIO_CPU_MASK_STRIDE	64
+#define FIO_CPU_MASK_ROWS	(FIO_MAX_CPUS / FIO_CPU_MASK_STRIDE)
+
+typedef struct {
+	uint64_t row[FIO_CPU_MASK_ROWS];
+} os_cpu_mask_t;
+
+#define FIO_HAVE_CPU_ONLINE_SYSCONF
+/* Return all processors regardless of processor group */
+static inline unsigned int cpus_online(void)
+{
+	return GetMaximumProcessorCount(ALL_PROCESSOR_GROUPS);
+}
+
+static inline void print_mask(os_cpu_mask_t *cpumask)
+{
+	for (int i = 0; i < FIO_CPU_MASK_ROWS; i++)
+		dprint(FD_PROCESS, "cpumask[%d]=%lu\n", i, cpumask->row[i]);
+}
+
+/* Return the index of the least significant set CPU in cpumask or -1 if no
+ * CPUs are set */
+static inline int first_set_cpu(os_cpu_mask_t *cpumask)
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
+static inline int last_set_cpu(os_cpu_mask_t *cpumask)
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
+static inline int mask_to_group_mask(os_cpu_mask_t *cpumask, int *processor_group, uint64_t *affinity_mask)
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
+		group_size = GetMaximumProcessorCount(group);
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
+static inline int fio_setaffinity(int pid, os_cpu_mask_t cpumask)
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
+static inline void cpu_to_row_offset(int cpu, int *row, int *offset)
+{
+	*row = cpu / FIO_CPU_MASK_STRIDE;
+	*offset = cpu << FIO_CPU_MASK_STRIDE * *row;
+}
+
+static inline int fio_cpuset_init(os_cpu_mask_t *mask)
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
+static inline int fio_getaffinity(int pid, os_cpu_mask_t *mask)
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
+	group_count = 1;
+	/*
+	 * GetProcessGroupAffinity() seems to expect more than the natural
+	 * alignment for a USHORT from the area pointed to by current_groups so
+	 * arrange for maximum alignment by allocating via malloc()
+	 */
+	current_groups = malloc(sizeof(USHORT));
+	if (!current_groups) {
+		log_err("fio_getaffinity: malloc failed\n");
+		goto err;
+	}
+	if (GetProcessGroupAffinity(handle, &group_count, current_groups) == 0) {
+		/* NB: we also fail here if we are a multi-group process */
+		log_err("fio_getaffinity: failed to get single group affinity for pid %d\n", pid);
+		goto err;
+	}
+	GetProcessAffinityMask(handle, &process_mask, &system_mask);
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
+		group_size = GetMaximumProcessorCount(group);
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
+static inline void fio_cpu_clear(os_cpu_mask_t *mask, int cpu)
+{
+	int row, offset;
+	cpu_to_row_offset(cpu, &row, &offset);
+
+	mask->row[row] &= ~(1ULL << offset);
+}
+
+static inline void fio_cpu_set(os_cpu_mask_t *mask, int cpu)
+{
+	int row, offset;
+	cpu_to_row_offset(cpu, &row, &offset);
+
+	mask->row[row] |= 1ULL << offset;
+}
+
+static inline int fio_cpu_isset(os_cpu_mask_t *mask, int cpu)
+{
+	int row, offset;
+	cpu_to_row_offset(cpu, &row, &offset);
+
+	return (mask->row[row] & (1ULL << offset)) != 0;
+}
+
+static inline int fio_cpu_count(os_cpu_mask_t *mask)
+{
+	int count = 0;
+
+	for (int i = 0; i < FIO_CPU_MASK_ROWS; i++)
+		count += hweight64(mask->row[i]);
+
+	return count;
+}
+
+static inline int fio_cpuset_exit(os_cpu_mask_t *mask)
+{
+	return 0;
+}
diff --git a/os/os-windows-xp.h b/os/os-windows-xp.h
new file mode 100644
index 0000000..1ce9ab3
--- /dev/null
+++ b/os/os-windows-xp.h
@@ -0,0 +1,70 @@
+#define FIO_MAX_CPUS	MAXIMUM_PROCESSORS
+
+typedef DWORD_PTR os_cpu_mask_t;
+
+static inline int fio_setaffinity(int pid, os_cpu_mask_t cpumask)
+{
+	HANDLE h;
+	BOOL bSuccess = FALSE;
+
+	h = OpenThread(THREAD_QUERY_INFORMATION | THREAD_SET_INFORMATION, TRUE, pid);
+	if (h != NULL) {
+		bSuccess = SetThreadAffinityMask(h, cpumask);
+		if (!bSuccess)
+			log_err("fio_setaffinity failed: failed to set thread affinity (pid %d, mask %.16llx)\n", pid, cpumask);
+
+		CloseHandle(h);
+	} else {
+		log_err("fio_setaffinity failed: failed to get handle for pid %d\n", pid);
+	}
+
+	return (bSuccess)? 0 : -1;
+}
+
+static inline int fio_getaffinity(int pid, os_cpu_mask_t *mask)
+{
+	os_cpu_mask_t systemMask;
+
+	HANDLE h = OpenProcess(PROCESS_QUERY_INFORMATION, TRUE, pid);
+
+	if (h != NULL) {
+		GetProcessAffinityMask(h, mask, &systemMask);
+		CloseHandle(h);
+	} else {
+		log_err("fio_getaffinity failed: failed to get handle for pid %d\n", pid);
+		return -1;
+	}
+
+	return 0;
+}
+
+static inline void fio_cpu_clear(os_cpu_mask_t *mask, int cpu)
+{
+	*mask &= ~(1ULL << cpu);
+}
+
+static inline void fio_cpu_set(os_cpu_mask_t *mask, int cpu)
+{
+	*mask |= 1ULL << cpu;
+}
+
+static inline int fio_cpu_isset(os_cpu_mask_t *mask, int cpu)
+{
+	return (*mask & (1ULL << cpu)) != 0;
+}
+
+static inline int fio_cpu_count(os_cpu_mask_t *mask)
+{
+	return hweight64(*mask);
+}
+
+static inline int fio_cpuset_init(os_cpu_mask_t *mask)
+{
+	*mask = 0;
+	return 0;
+}
+
+static inline int fio_cpuset_exit(os_cpu_mask_t *mask)
+{
+	return 0;
+}
diff --git a/os/os-windows.h b/os/os-windows.h
index 9b04579..01f555e 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -13,6 +13,7 @@
 #include <stdlib.h>
 
 #include "../smalloc.h"
+#include "../debug.h"
 #include "../file.h"
 #include "../log.h"
 #include "../lib/hweight.h"
@@ -21,7 +22,7 @@
 
 #include "windows/posix.h"
 
-/* Cygwin doesn't define rand_r if C99 or newer is being used */
+/* MinGW won't declare rand_r unless _POSIX is defined */
 #if defined(WIN32) && !defined(rand_r)
 int rand_r(unsigned *);
 #endif
@@ -40,16 +41,12 @@ int rand_r(unsigned *);
 #define FIO_PREFERRED_CLOCK_SOURCE	CS_CGETTIME
 #define FIO_OS_PATH_SEPARATOR		'\\'
 
-#define FIO_MAX_CPUS	MAXIMUM_PROCESSORS
-
 #define OS_MAP_ANON		MAP_ANON
 
 #define fio_swap16(x)	_byteswap_ushort(x)
 #define fio_swap32(x)	_byteswap_ulong(x)
 #define fio_swap64(x)	_byteswap_uint64(x)
 
-typedef DWORD_PTR os_cpu_mask_t;
-
 #define _SC_PAGESIZE			0x1
 #define _SC_NPROCESSORS_ONLN	0x2
 #define _SC_PHYS_PAGES			0x4
@@ -77,11 +74,6 @@ typedef DWORD_PTR os_cpu_mask_t;
 /* Winsock doesn't support MSG_WAIT */
 #define OS_MSG_DONTWAIT	0
 
-#define POLLOUT	1
-#define POLLIN	2
-#define POLLERR	0
-#define POLLHUP	1
-
 #define SIGCONT	0
 #define SIGUSR1	1
 #define SIGUSR2 2
@@ -172,73 +164,6 @@ static inline int gettid(void)
 	return GetCurrentThreadId();
 }
 
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
-
 static inline int init_random_seeds(unsigned long *rand_seeds, int size)
 {
 	HCRYPTPROV hCryptProv;
@@ -261,12 +186,16 @@ static inline int init_random_seeds(unsigned long *rand_seeds, int size)
 	return 0;
 }
 
-
 static inline int fio_set_sched_idle(void)
 {
 	/* SetThreadPriority returns nonzero for success */
 	return (SetThreadPriority(GetCurrentThread(), THREAD_PRIORITY_IDLE))? 0 : -1;
 }
 
+#ifdef CONFIG_WINDOWS_XP
+#include "os-windows-xp.h"
+#else
+#include "os-windows-7.h"
+#endif
 
 #endif /* FIO_OS_WINDOWS_H */
diff --git a/os/windows/eula.rtf b/os/windows/eula.rtf
index b2798bb..01472be 100755
Binary files a/os/windows/eula.rtf and b/os/windows/eula.rtf differ
diff --git a/os/windows/posix.c b/os/windows/posix.c
index ecc8c40..d33250d 100755
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -959,6 +959,7 @@ in_addr_t inet_network(const char *cp)
 	return hbo;
 }
 
+#ifdef CONFIG_WINDOWS_XP
 const char* inet_ntop(int af, const void *restrict src,
 		char *restrict dst, socklen_t size)
 {
@@ -1039,3 +1040,4 @@ int inet_pton(int af, const char *restrict src, void *restrict dst)
 
 	return ret;
 }
+#endif /* CONFIG_WINDOWS_XP */
diff --git a/os/windows/posix/include/arpa/inet.h b/os/windows/posix/include/arpa/inet.h
index 30498c6..056f1dd 100644
--- a/os/windows/posix/include/arpa/inet.h
+++ b/os/windows/posix/include/arpa/inet.h
@@ -12,8 +12,10 @@ typedef int in_addr_t;
 
 in_addr_t inet_network(const char *cp);
 
+#ifdef CONFIG_WINDOWS_XP
 const char *inet_ntop(int af, const void *restrict src,
         char *restrict dst, socklen_t size);
 int inet_pton(int af, const char *restrict src, void *restrict dst);
+#endif
 
 #endif /* ARPA_INET_H */
diff --git a/os/windows/posix/include/poll.h b/os/windows/posix/include/poll.h
index f064e2b..25b8183 100644
--- a/os/windows/posix/include/poll.h
+++ b/os/windows/posix/include/poll.h
@@ -1,8 +1,11 @@
 #ifndef POLL_H
 #define POLL_H
 
+#include <winsock2.h>
+
 typedef int nfds_t;
 
+#ifdef CONFIG_WINDOWS_XP
 struct pollfd
 {
 	int fd;
@@ -10,6 +13,12 @@ struct pollfd
 	short revents;
 };
 
+#define POLLOUT	1
+#define POLLIN	2
+#define POLLERR	0
+#define POLLHUP	1
+#endif /* CONFIG_WINDOWS_XP */
+
 int poll(struct pollfd fds[], nfds_t nfds, int timeout);
 
 #endif /* POLL_H */
diff --git a/server.c b/server.c
index 2e08c66..12c8d68 100644
--- a/server.c
+++ b/server.c
@@ -2144,14 +2144,14 @@ static int fio_init_server_ip(void)
 #endif
 
 	if (use_ipv6) {
-		const void *src = &saddr_in6.sin6_addr;
+		void *src = &saddr_in6.sin6_addr;
 
 		addr = (struct sockaddr *) &saddr_in6;
 		socklen = sizeof(saddr_in6);
 		saddr_in6.sin6_family = AF_INET6;
 		str = inet_ntop(AF_INET6, src, buf, sizeof(buf));
 	} else {
-		const void *src = &saddr_in.sin_addr;
+		void *src = &saddr_in.sin_addr;
 
 		addr = (struct sockaddr *) &saddr_in;
 		socklen = sizeof(saddr_in);
@@ -2219,7 +2219,7 @@ static int fio_init_server_connection(void)
 
 	if (!bind_sock) {
 		char *p, port[16];
-		const void *src;
+		void *src;
 		int af;
 
 		if (use_ipv6) {
