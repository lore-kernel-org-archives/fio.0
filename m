Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbhAGNAt (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 7 Jan 2021 08:00:49 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B2AC0612F5
        for <fio@vger.kernel.org>; Thu,  7 Jan 2021 05:00:08 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kxUtZ-0007pm-ND
        for fio@vger.kernel.org; Thu, 07 Jan 2021 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210107130002.4F1681BC0135@kernel.dk>
Date: Thu,  7 Jan 2021 06:00:02 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4065c6a4949fa85e5f2d8de8a5556130231dd680:

  log: only compile log_prevalist() if FIO_INC_DEBUG is set (2021-01-05 13:14:28 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 59f94d26f98e9c0bc18d4e013f3361c51a2c6b25:

  Change ARRAY_SIZE to FIO_ARRAY_SIZE (2021-01-06 11:32:59 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'drop_xp' of https://github.com/sitsofe/fio
      Change ARRAY_SIZE to FIO_ARRAY_SIZE

Sitsofe Wheeler (1):
      windows: drop XP support

 .appveyor.yml                        |  2 +-
 README                               |  9 ++--
 compiler/compiler.h                  |  4 +-
 configure                            |  8 +---
 diskutil.c                           |  6 +--
 engines/io_uring.c                   |  2 +-
 filesetup.c                          |  4 +-
 gclient.c                            |  4 +-
 gfio.c                               |  4 +-
 helper_thread.c                      |  6 +--
 lib/num2str.c                        |  8 ++--
 lib/prio_tree.c                      |  6 +--
 options.c                            |  4 +-
 os/os-windows-xp.h                   |  3 --
 os/os-windows.h                      |  6 +--
 os/windows/cpu-affinity.c            | 73 ------------------------------
 os/windows/posix.c                   | 87 ------------------------------------
 os/windows/posix/include/arpa/inet.h |  6 ---
 os/windows/posix/include/poll.h      | 14 ------
 oslib/libmtd.c                       |  4 +-
 oslib/libmtd_common.h                |  1 -
 parse.c                              |  2 +-
 td_error.c                           |  2 +-
 unittests/lib/num2str.c              |  2 +-
 zbd.c                                |  2 +-
 25 files changed, 37 insertions(+), 232 deletions(-)
 delete mode 100644 os/os-windows-xp.h

---

Diff of recent changes:

diff --git a/.appveyor.yml b/.appveyor.yml
index fad16326..42b79958 100644
--- a/.appveyor.yml
+++ b/.appveyor.yml
@@ -19,7 +19,7 @@ environment:
       CONFIGURE_OPTIONS:
       DISTRO: cygwin
     - ARCHITECTURE: x86
-      CONFIGURE_OPTIONS: --build-32bit-win --target-win-ver=xp
+      CONFIGURE_OPTIONS: --build-32bit-win
       DISTRO: cygwin
 
 install:
diff --git a/README b/README
index 0f943bcc..2fecf0e0 100644
--- a/README
+++ b/README
@@ -164,8 +164,9 @@ configure.
 Windows
 ~~~~~~~
 
-On Windows, Cygwin (https://www.cygwin.com/) is required in order to build
-fio. To create an MSI installer package install WiX from
+The minimum versions of Windows for building/runing fio are Windows 7/Windows
+Server 2008 R2. On Windows, Cygwin (https://www.cygwin.com/) is required in
+order to build fio. To create an MSI installer package install WiX from
 https://wixtoolset.org and run :file:`dobuild.cmd` from the :file:`os/windows`
 directory.
 
@@ -181,9 +182,7 @@ How to compile fio on 64-bit Windows:
 
 To build fio for 32-bit Windows, ensure the -i686 versions of the previously
 mentioned -x86_64 packages are installed and run ``./configure
---build-32bit-win`` before ``make``. To build an fio that supports versions of
-Windows below Windows 7/Windows Server 2008 R2 also add ``--target-win-ver=xp``
-to the end of the configure line that you run before doing ``make``.
+--build-32bit-win`` before ``make``.
 
 It's recommended that once built or installed, fio be run in a Command Prompt or
 other 'native' console such as console2, since there are known to be display and
diff --git a/compiler/compiler.h b/compiler/compiler.h
index 8988236c..44fa87b9 100644
--- a/compiler/compiler.h
+++ b/compiler/compiler.h
@@ -62,8 +62,8 @@
 #endif
 
 #ifdef FIO_INTERNAL
-#define ARRAY_SIZE(x)    (sizeof((x)) / (sizeof((x)[0])))
-#define FIELD_SIZE(s, f) (sizeof(((__typeof__(s))0)->f))
+#define FIO_ARRAY_SIZE(x)    (sizeof((x)) / (sizeof((x)[0])))
+#define FIO_FIELD_SIZE(s, f) (sizeof(((__typeof__(s))0)->f))
 #endif
 
 #ifndef __has_attribute
diff --git a/configure b/configure
index d247a041..e3e37d56 100755
--- a/configure
+++ b/configure
@@ -257,7 +257,7 @@ if test "$show_help" = "yes" ; then
   echo "--cc=                   Specify compiler to use"
   echo "--extra-cflags=         Specify extra CFLAGS to pass to compiler"
   echo "--build-32bit-win       Enable 32-bit build on Windows"
-  echo "--target-win-ver=       Minimum version of Windows to target (XP or 7)"
+  echo "--target-win-ver=       Minimum version of Windows to target (only accepts 7)"
   echo "--enable-pdb            Enable Windows PDB symbols generation (needs clang/lld)"
   echo "--build-static          Build a static fio"
   echo "--esx                   Configure build options for esx"
@@ -395,11 +395,7 @@ CYGWIN*)
     # Default Windows API target
     target_win_ver="7"
   fi
-  if test "$target_win_ver" = "XP"; then
-    output_sym "CONFIG_WINDOWS_XP"
-    # Technically the below is targeting 2003
-    CFLAGS="$CFLAGS -D_WIN32_WINNT=0x0502"
-  elif test "$target_win_ver" = "7"; then
+  if test "$target_win_ver" = "7"; then
     output_sym "CONFIG_WINDOWS_7"
     CFLAGS="$CFLAGS -D_WIN32_WINNT=0x0601"
   else
diff --git a/diskutil.c b/diskutil.c
index 6c6380bb..0051a7a0 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -181,7 +181,7 @@ static int get_device_numbers(char *file_name, int *maj, int *min)
 		/*
 		 * must be a file, open "." in that path
 		 */
-		snprintf(tempname, ARRAY_SIZE(tempname), "%s", file_name);
+		snprintf(tempname, FIO_ARRAY_SIZE(tempname), "%s", file_name);
 		p = dirname(tempname);
 		if (stat(p, &st)) {
 			perror("disk util stat");
@@ -313,7 +313,7 @@ static struct disk_util *disk_util_add(struct thread_data *td, int majdev,
 		sfree(du);
 		return NULL;
 	}
-	snprintf((char *) du->dus.name, ARRAY_SIZE(du->dus.name), "%s",
+	snprintf((char *) du->dus.name, FIO_ARRAY_SIZE(du->dus.name), "%s",
 		 basename(path));
 	du->sysfs_root = strdup(path);
 	du->major = majdev;
@@ -435,7 +435,7 @@ static struct disk_util *__init_per_file_disk_util(struct thread_data *td,
 			log_err("unknown sysfs layout\n");
 			return NULL;
 		}
-		snprintf(tmp, ARRAY_SIZE(tmp), "%s", p);
+		snprintf(tmp, FIO_ARRAY_SIZE(tmp), "%s", p);
 		sprintf(path, "%s", tmp);
 	}
 
diff --git a/engines/io_uring.c b/engines/io_uring.c
index b997c8d8..9ce2ae80 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -507,7 +507,7 @@ static void fio_ioring_unmap(struct ioring_data *ld)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(ld->mmap); i++)
+	for (i = 0; i < FIO_ARRAY_SIZE(ld->mmap); i++)
 		munmap(ld->mmap[i].ptr, ld->mmap[i].len);
 	close(ld->ring_fd);
 }
diff --git a/filesetup.c b/filesetup.c
index d3c370ca..76b3f935 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -815,7 +815,7 @@ static unsigned long long get_fs_free_counts(struct thread_data *td)
 		} else if (f->filetype != FIO_TYPE_FILE)
 			continue;
 
-		snprintf(buf, ARRAY_SIZE(buf), "%s", f->file_name);
+		snprintf(buf, FIO_ARRAY_SIZE(buf), "%s", f->file_name);
 
 		if (stat(buf, &sb) < 0) {
 			if (errno != ENOENT)
@@ -838,7 +838,7 @@ static unsigned long long get_fs_free_counts(struct thread_data *td)
 			continue;
 
 		fm = calloc(1, sizeof(*fm));
-		snprintf(fm->__base, ARRAY_SIZE(fm->__base), "%s", buf);
+		snprintf(fm->__base, FIO_ARRAY_SIZE(fm->__base), "%s", buf);
 		fm->base = basename(fm->__base);
 		fm->key = sb.st_dev;
 		flist_add(&fm->list, &list);
diff --git a/gclient.c b/gclient.c
index fe83382f..e0e0e7bf 100644
--- a/gclient.c
+++ b/gclient.c
@@ -48,7 +48,7 @@ static GtkActionEntry results_menu_items[] = {
 	{ "PrintFile", GTK_STOCK_PRINT, "Print", "<Control>P", NULL, G_CALLBACK(results_print) },
 	{ "CloseFile", GTK_STOCK_CLOSE, "Close", "<Control>W", NULL, G_CALLBACK(results_close) },
 };
-static gint results_nmenu_items = ARRAY_SIZE(results_menu_items);
+static gint results_nmenu_items = FIO_ARRAY_SIZE(results_menu_items);
 
 static const gchar *results_ui_string = " \
 	<ui> \
@@ -755,7 +755,7 @@ static void gfio_show_io_depths(GtkWidget *vbox, struct thread_stat *ts)
 	GtkListStore *model;
 	int i;
 	const char *labels[] = { "Depth", "0", "1", "2", "4", "8", "16", "32", "64", ">= 64" };
-	const int nr_labels = ARRAY_SIZE(labels);
+	const int nr_labels = FIO_ARRAY_SIZE(labels);
 	GType types[nr_labels];
 
 	frame = gtk_frame_new("IO depths");
diff --git a/gfio.c b/gfio.c
index 734651b6..22c5314d 100644
--- a/gfio.c
+++ b/gfio.c
@@ -1274,7 +1274,7 @@ static GtkActionEntry menu_items[] = {
 	{ "Quit", GTK_STOCK_QUIT, NULL,   "<Control>Q", NULL, G_CALLBACK(quit_clicked) },
 	{ "About", GTK_STOCK_ABOUT, NULL,  NULL, NULL, G_CALLBACK(about_dialog) },
 };
-static gint nmenu_items = ARRAY_SIZE(menu_items);
+static gint nmenu_items = FIO_ARRAY_SIZE(menu_items);
 
 static const gchar *ui_string = " \
 	<ui> \
@@ -1447,7 +1447,7 @@ static GtkWidget *new_client_page(struct gui_entry *ge)
 	gtk_container_add(GTK_CONTAINER(bottom_align), ge->buttonbox);
 	gtk_box_pack_start(GTK_BOX(main_vbox), bottom_align, FALSE, FALSE, 0);
 
-	add_buttons(ge, buttonspeclist, ARRAY_SIZE(buttonspeclist));
+	add_buttons(ge, buttonspeclist, FIO_ARRAY_SIZE(buttonspeclist));
 
 	/*
 	 * Set up thread status progress bar
diff --git a/helper_thread.c b/helper_thread.c
index 2d553654..d8e7ebfe 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -311,7 +311,7 @@ static void *helper_thread_main(void *data)
 	block_signals();
 
 	fio_get_mono_time(&ts);
-	msec_to_next_event = reset_timers(timer, ARRAY_SIZE(timer), &ts);
+	msec_to_next_event = reset_timers(timer, FIO_ARRAY_SIZE(timer), &ts);
 
 	fio_sem_up(hd->startup_sem);
 
@@ -329,9 +329,9 @@ static void *helper_thread_main(void *data)
 
 		if (action == A_RESET)
 			msec_to_next_event = reset_timers(timer,
-						ARRAY_SIZE(timer), &ts);
+						FIO_ARRAY_SIZE(timer), &ts);
 
-		for (i = 0; i < ARRAY_SIZE(timer); ++i)
+		for (i = 0; i < FIO_ARRAY_SIZE(timer); ++i)
 			ret = eval_timer(&timer[i], &ts, &msec_to_next_event);
 
 		if (action == A_DO_STAT)
diff --git a/lib/num2str.c b/lib/num2str.c
index 726f1c44..3597de2f 100644
--- a/lib/num2str.c
+++ b/lib/num2str.c
@@ -7,8 +7,6 @@
 #include "../oslib/asprintf.h"
 #include "num2str.h"
 
-#define ARRAY_SIZE(x)    (sizeof((x)) / (sizeof((x)[0])))
-
 /**
  * num2str() - Cheesy number->string conversion, complete with carry rounding error.
  * @num: quantity (e.g., number of blocks, bytes or bits)
@@ -38,7 +36,7 @@ char *num2str(uint64_t num, int maxlen, int base, int pow2, enum n2s_unit units)
 	char *buf;
 
 	compiletime_assert(sizeof(sistr) == sizeof(iecstr), "unit prefix arrays must be identical sizes");
-	assert(units < ARRAY_SIZE(unitstr));
+	assert(units < FIO_ARRAY_SIZE(unitstr));
 
 	if (pow2)
 		unitprefix = iecstr;
@@ -69,7 +67,7 @@ char *num2str(uint64_t num, int maxlen, int base, int pow2, enum n2s_unit units)
 	 * Divide by K/Ki until string length of num <= maxlen.
 	 */
 	modulo = -1U;
-	while (post_index < ARRAY_SIZE(sistr)) {
+	while (post_index < FIO_ARRAY_SIZE(sistr)) {
 		sprintf(tmp, "%llu", (unsigned long long) num);
 		if (strlen(tmp) <= maxlen)
 			break;
@@ -80,7 +78,7 @@ char *num2str(uint64_t num, int maxlen, int base, int pow2, enum n2s_unit units)
 		post_index++;
 	}
 
-	if (post_index >= ARRAY_SIZE(sistr))
+	if (post_index >= FIO_ARRAY_SIZE(sistr))
 		post_index = 0;
 
 	/*
diff --git a/lib/prio_tree.c b/lib/prio_tree.c
index d8e1b89a..c4f66a49 100644
--- a/lib/prio_tree.c
+++ b/lib/prio_tree.c
@@ -18,8 +18,6 @@
 #include "../compiler/compiler.h"
 #include "prio_tree.h"
 
-#define ARRAY_SIZE(x)    (sizeof((x)) / (sizeof((x)[0])))
-
 /*
  * A clever mix of heap and radix trees forms a radix priority search tree (PST)
  * which is useful for storing intervals, e.g, we can consider a vma as a closed
@@ -57,9 +55,9 @@ static void fio_init prio_tree_init(void)
 {
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(index_bits_to_maxindex) - 1; i++)
+	for (i = 0; i < FIO_ARRAY_SIZE(index_bits_to_maxindex) - 1; i++)
 		index_bits_to_maxindex[i] = (1UL << (i + 1)) - 1;
-	index_bits_to_maxindex[ARRAY_SIZE(index_bits_to_maxindex) - 1] = ~0UL;
+	index_bits_to_maxindex[FIO_ARRAY_SIZE(index_bits_to_maxindex) - 1] = ~0UL;
 }
 
 /*
diff --git a/options.c b/options.c
index 1e91b3e9..4c472589 100644
--- a/options.c
+++ b/options.c
@@ -22,7 +22,7 @@ char client_sockaddr_str[INET6_ADDRSTRLEN] = { 0 };
 static const struct pattern_fmt_desc fmt_desc[] = {
 	{
 		.fmt   = "%o",
-		.len   = FIELD_SIZE(struct io_u *, offset),
+		.len   = FIO_FIELD_SIZE(struct io_u *, offset),
 		.paste = paste_blockoff
 	},
 	{ }
@@ -1387,7 +1387,7 @@ static int str_verify_pattern_cb(void *data, const char *input)
 	struct thread_data *td = cb_data_to_td(data);
 	int ret;
 
-	td->o.verify_fmt_sz = ARRAY_SIZE(td->o.verify_fmt);
+	td->o.verify_fmt_sz = FIO_ARRAY_SIZE(td->o.verify_fmt);
 	ret = parse_and_fill_pattern(input, strlen(input), td->o.verify_pattern,
 				     MAX_PATTERN_SIZE, fmt_desc,
 				     td->o.verify_fmt, &td->o.verify_fmt_sz);
diff --git a/os/os-windows-xp.h b/os/os-windows-xp.h
deleted file mode 100644
index fbc23e2c..00000000
--- a/os/os-windows-xp.h
+++ /dev/null
@@ -1,3 +0,0 @@
-#define FIO_MAX_CPUS	MAXIMUM_PROCESSORS
-
-typedef DWORD_PTR os_cpu_mask_t;
diff --git a/os/os-windows.h b/os/os-windows.h
index fa2955f9..ddfae413 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -21,6 +21,7 @@
 #include "../lib/types.h"
 
 #include "windows/posix.h"
+#include "os-windows-7.h"
 
 #ifndef PTHREAD_STACK_MIN
 #define PTHREAD_STACK_MIN 65535
@@ -215,13 +216,8 @@ static inline int fio_mkdir(const char *path, mode_t mode) {
 	return 0;
 }
 
-#ifdef CONFIG_WINDOWS_XP
-#include "os-windows-xp.h"
-#else
 #define FIO_HAVE_CPU_ONLINE_SYSCONF
 unsigned int cpus_online(void);
-#include "os-windows-7.h"
-#endif
 
 int first_set_cpu(os_cpu_mask_t *cpumask);
 int fio_setaffinity(int pid, os_cpu_mask_t cpumask);
diff --git a/os/windows/cpu-affinity.c b/os/windows/cpu-affinity.c
index 46fd048d..7601970f 100644
--- a/os/windows/cpu-affinity.c
+++ b/os/windows/cpu-affinity.c
@@ -2,78 +2,6 @@
 
 #include <windows.h>
 
-#ifdef CONFIG_WINDOWS_XP
-int fio_setaffinity(int pid, os_cpu_mask_t cpumask)
-{
-	HANDLE h;
-	BOOL bSuccess = FALSE;
-
-	h = OpenThread(THREAD_QUERY_INFORMATION | THREAD_SET_INFORMATION, TRUE,
-		       pid);
-	if (h != NULL) {
-		bSuccess = SetThreadAffinityMask(h, cpumask);
-		if (!bSuccess)
-			log_err("fio_setaffinity failed: failed to set thread affinity (pid %d, mask %.16llx)\n",
-				pid, (long long unsigned) cpumask);
-
-		CloseHandle(h);
-	} else {
-		log_err("fio_setaffinity failed: failed to get handle for pid %d\n",
-			pid);
-	}
-
-	return bSuccess ? 0 : -1;
-}
-
-int fio_getaffinity(int pid, os_cpu_mask_t *mask)
-{
-	os_cpu_mask_t systemMask;
-
-	HANDLE h = OpenProcess(PROCESS_QUERY_INFORMATION, TRUE, pid);
-
-	if (h != NULL) {
-		GetProcessAffinityMask(h, mask, &systemMask);
-		CloseHandle(h);
-	} else {
-		log_err("fio_getaffinity failed: failed to get handle for pid %d\n",
-			pid);
-		return -1;
-	}
-
-	return 0;
-}
-
-void fio_cpu_clear(os_cpu_mask_t *mask, int cpu)
-{
-	*mask &= ~(1ULL << cpu);
-}
-
-void fio_cpu_set(os_cpu_mask_t *mask, int cpu)
-{
-	*mask |= 1ULL << cpu;
-}
-
-int fio_cpu_isset(os_cpu_mask_t *mask, int cpu)
-{
-	return (*mask & (1ULL << cpu)) != 0;
-}
-
-int fio_cpu_count(os_cpu_mask_t *mask)
-{
-	return hweight64(*mask);
-}
-
-int fio_cpuset_init(os_cpu_mask_t *mask)
-{
-	*mask = 0;
-	return 0;
-}
-
-int fio_cpuset_exit(os_cpu_mask_t *mask)
-{
-	return 0;
-}
-#else /* CONFIG_WINDOWS_XP */
 /* Return all processors regardless of processor group */
 unsigned int cpus_online(void)
 {
@@ -443,4 +371,3 @@ int fio_cpuset_exit(os_cpu_mask_t *mask)
 {
 	return 0;
 }
-#endif /* CONFIG_WINDOWS_XP */
diff --git a/os/windows/posix.c b/os/windows/posix.c
index 9e9f12ef..09c2e4a7 100644
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -1026,90 +1026,3 @@ in_addr_t inet_network(const char *cp)
 	hbo = ((nbo & 0xFF) << 24) + ((nbo & 0xFF00) << 8) + ((nbo & 0xFF0000) >> 8) + ((nbo & 0xFF000000) >> 24);
 	return hbo;
 }
-
-#ifdef CONFIG_WINDOWS_XP
-const char *inet_ntop(int af, const void *restrict src, char *restrict dst,
-		      socklen_t size)
-{
-	INT status = SOCKET_ERROR;
-	WSADATA wsd;
-	char *ret = NULL;
-
-	if (af != AF_INET && af != AF_INET6) {
-		errno = EAFNOSUPPORT;
-		return NULL;
-	}
-
-	WSAStartup(MAKEWORD(2,2), &wsd);
-
-	if (af == AF_INET) {
-		struct sockaddr_in si;
-		DWORD len = size;
-
-		memset(&si, 0, sizeof(si));
-		si.sin_family = af;
-		memcpy(&si.sin_addr, src, sizeof(si.sin_addr));
-		status = WSAAddressToString((struct sockaddr*)&si, sizeof(si), NULL, dst, &len);
-	} else if (af == AF_INET6) {
-		struct sockaddr_in6 si6;
-		DWORD len = size;
-
-		memset(&si6, 0, sizeof(si6));
-		si6.sin6_family = af;
-		memcpy(&si6.sin6_addr, src, sizeof(si6.sin6_addr));
-		status = WSAAddressToString((struct sockaddr*)&si6, sizeof(si6), NULL, dst, &len);
-	}
-
-	if (status != SOCKET_ERROR)
-		ret = dst;
-	else
-		errno = ENOSPC;
-
-	WSACleanup();
-
-	return ret;
-}
-
-int inet_pton(int af, const char *restrict src, void *restrict dst)
-{
-	INT status = SOCKET_ERROR;
-	WSADATA wsd;
-	int ret = 1;
-
-	if (af != AF_INET && af != AF_INET6) {
-		errno = EAFNOSUPPORT;
-		return -1;
-	}
-
-	WSAStartup(MAKEWORD(2,2), &wsd);
-
-	if (af == AF_INET) {
-		struct sockaddr_in si;
-		INT len = sizeof(si);
-
-		memset(&si, 0, sizeof(si));
-		si.sin_family = af;
-		status = WSAStringToAddressA((char*)src, af, NULL, (struct sockaddr*)&si, &len);
-		if (status != SOCKET_ERROR)
-			memcpy(dst, &si.sin_addr, sizeof(si.sin_addr));
-	} else if (af == AF_INET6) {
-		struct sockaddr_in6 si6;
-		INT len = sizeof(si6);
-
-		memset(&si6, 0, sizeof(si6));
-		si6.sin6_family = af;
-		status = WSAStringToAddressA((char*)src, af, NULL, (struct sockaddr*)&si6, &len);
-		if (status != SOCKET_ERROR)
-			memcpy(dst, &si6.sin6_addr, sizeof(si6.sin6_addr));
-	}
-
-	if (status == SOCKET_ERROR) {
-		errno = ENOSPC;
-		ret = 0;
-	}
-
-	WSACleanup();
-
-	return ret;
-}
-#endif /* CONFIG_WINDOWS_XP */
diff --git a/os/windows/posix/include/arpa/inet.h b/os/windows/posix/include/arpa/inet.h
index 056f1dd5..1024db37 100644
--- a/os/windows/posix/include/arpa/inet.h
+++ b/os/windows/posix/include/arpa/inet.h
@@ -12,10 +12,4 @@ typedef int in_addr_t;
 
 in_addr_t inet_network(const char *cp);
 
-#ifdef CONFIG_WINDOWS_XP
-const char *inet_ntop(int af, const void *restrict src,
-        char *restrict dst, socklen_t size);
-int inet_pton(int af, const char *restrict src, void *restrict dst);
-#endif
-
 #endif /* ARPA_INET_H */
diff --git a/os/windows/posix/include/poll.h b/os/windows/posix/include/poll.h
index 25b8183f..5099cf2e 100644
--- a/os/windows/posix/include/poll.h
+++ b/os/windows/posix/include/poll.h
@@ -5,20 +5,6 @@
 
 typedef int nfds_t;
 
-#ifdef CONFIG_WINDOWS_XP
-struct pollfd
-{
-	int fd;
-	short events;
-	short revents;
-};
-
-#define POLLOUT	1
-#define POLLIN	2
-#define POLLERR	0
-#define POLLHUP	1
-#endif /* CONFIG_WINDOWS_XP */
-
 int poll(struct pollfd fds[], nfds_t nfds, int timeout);
 
 #endif /* POLL_H */
diff --git a/oslib/libmtd.c b/oslib/libmtd.c
index 385b9d2f..5fca3a01 100644
--- a/oslib/libmtd.c
+++ b/oslib/libmtd.c
@@ -35,6 +35,8 @@
 #include <sys/ioctl.h>
 #include <inttypes.h>
 
+#include "../compiler/compiler.h"
+
 #include <mtd/mtd-user.h>
 #include "libmtd.h"
 
@@ -960,7 +962,7 @@ int mtd_torture(libmtd_t desc, const struct mtd_dev_info *mtd, int fd, int eb)
 	void *buf;
 
 	normsg("run torture test for PEB %d", eb);
-	patt_count = ARRAY_SIZE(patterns);
+	patt_count = FIO_ARRAY_SIZE(patterns);
 
 	buf = xmalloc(mtd->eb_size);
 
diff --git a/oslib/libmtd_common.h b/oslib/libmtd_common.h
index 4ed9f0ba..db0494dd 100644
--- a/oslib/libmtd_common.h
+++ b/oslib/libmtd_common.h
@@ -47,7 +47,6 @@ extern "C" {
 #define MAX(a, b) ((a) > (b) ? (a) : (b))
 #endif
 #define min(a, b) MIN(a, b) /* glue for linux kernel source */
-#define ARRAY_SIZE(a) (sizeof(a) / sizeof((a)[0]))
 
 #define ALIGN(x,a) __ALIGN_MASK(x,(__typeof__(x))(a)-1)
 #define __ALIGN_MASK(x,mask) (((x)+(mask))&~(mask))
diff --git a/parse.c b/parse.c
index f4cefcf6..c28d82ef 100644
--- a/parse.c
+++ b/parse.c
@@ -501,7 +501,7 @@ static int str_match_len(const struct value_pair *vp, const char *str)
 
 static const char *opt_type_name(const struct fio_option *o)
 {
-	compiletime_assert(ARRAY_SIZE(opt_type_names) - 1 == FIO_OPT_UNSUPPORTED,
+	compiletime_assert(FIO_ARRAY_SIZE(opt_type_names) - 1 == FIO_OPT_UNSUPPORTED,
 				"opt_type_names[] index");
 
 	if (o->type <= FIO_OPT_UNSUPPORTED)
diff --git a/td_error.c b/td_error.c
index 9d58a314..13408f2e 100644
--- a/td_error.c
+++ b/td_error.c
@@ -20,7 +20,7 @@ int td_non_fatal_error(struct thread_data *td, enum error_type_bit etype,
 
 	if (!td->o.ignore_error[etype]) {
 		td->o.ignore_error[etype] = __NON_FATAL_ERR;
-		td->o.ignore_error_nr[etype] = ARRAY_SIZE(__NON_FATAL_ERR);
+		td->o.ignore_error_nr[etype] = FIO_ARRAY_SIZE(__NON_FATAL_ERR);
 	}
 
 	if (!(td->o.continue_on_error & (1 << etype)))
diff --git a/unittests/lib/num2str.c b/unittests/lib/num2str.c
index a3492a8d..8f12cf83 100644
--- a/unittests/lib/num2str.c
+++ b/unittests/lib/num2str.c
@@ -29,7 +29,7 @@ static void test_num2str(void)
 	char *str;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(testcases); ++i) {
+	for (i = 0; i < FIO_ARRAY_SIZE(testcases); ++i) {
 		p = &testcases[i];
 		str = num2str(p->num, p->maxlen, p->base, p->pow2, p->unit);
 		CU_ASSERT_STRING_EQUAL(str, p->expected);
diff --git a/zbd.c b/zbd.c
index 9327816a..f2599bd4 100644
--- a/zbd.c
+++ b/zbd.c
@@ -338,7 +338,7 @@ static bool zbd_verify_bs(void)
 			if (!f->zbd_info)
 				continue;
 			zone_size = f->zbd_info->zone_size;
-			for (k = 0; k < ARRAY_SIZE(td->o.bs); k++) {
+			for (k = 0; k < FIO_ARRAY_SIZE(td->o.bs); k++) {
 				if (td->o.verify != VERIFY_NONE &&
 				    zone_size % td->o.bs[k] != 0) {
 					log_info("%s: block size %llu is not a divisor of the zone size %d\n",

