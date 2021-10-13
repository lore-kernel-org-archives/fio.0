Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17731C433EF
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 12:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6BDD60273
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 12:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhJMMCM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 13 Oct 2021 08:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhJMMCK (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 13 Oct 2021 08:02:10 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB90EC061570
        for <fio@vger.kernel.org>; Wed, 13 Oct 2021 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=c6aBhl8NTkILSe+7LJM3zCiBfB2DNMaLGMSWyuTlCuE=; b=JyQ2p1aUk9lI8av2VKV54eW7DA
        +kZaEffZeugEky4YdjDXfMkmxWCLvg+BGrcIaJmWk6qh8z7MIPOMdg1DEyNUNYCkI2yrYYzCt8qoO
        LcERPWxbykodedvkBy9xyGlfIeGGelLkjeOehRO6zc6JvYzTCwluRBeisyL3REXVX2enl0ix0EhSP
        2/f9oKfdbMa9G4s5OrlA12/8UU3An5DsAKkceTBGD/+qOHMDl2UjNrt7z8OmV4321nOI8yRGeSL9Q
        1y9JBWfTmMd3Xu47WwsahVcfKjv7//jum7qH4s1nlL0IVrPFqcVPdfX1yb2BztdtqOCWNXILgcqKK
        J3CFchkQ==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1macvV-009bQP-MM
        for fio@vger.kernel.org; Wed, 13 Oct 2021 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 9BCCE1BC0144; Wed, 13 Oct 2021 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211013120001.9BCCE1BC0144@kernel.dk>
Date:   Wed, 13 Oct 2021 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit c4cb947e8f92c10835164b67deed06828cfc01be:

  io_u: don't attempt to requeue for full residual (2021-10-11 09:49:21 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 702b0be2fe3b6cf5b3556920edaf0637a33b36e1:

  t/io_uring: update for new DMA map buffers API (2021-10-12 18:41:14 -0600)

----------------------------------------------------------------
Brandon Paupore (1):
      Query Windows clock frequency and use reported max

Erwan Velu (1):
      t/one-core-peak: Improving check_sysblock_value error handling

Jens Axboe (6):
      Merge branch 'windows-res' of https://github.com/bjpaupor/fio
      t/io_uring: show IOPS in increments of 1000 IOPS if necessary
      Merge branch 'evelu-onecore' of https://github.com/ErwanAliasr1/fio
      t/io_uring: fix silly identical branch error
      t/io_uring: add test support for pre mapping DMA buffers
      t/io_uring: update for new DMA map buffers API

 Makefile           |  4 ++--
 helper_thread.c    | 21 +++++++++-----------
 os/os.h            |  9 +++++++++
 os/windows/dlls.c  | 33 +++++++++++++++++++++++++++++++
 stat.c             |  4 ++++
 t/io_uring.c       | 57 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 t/one-core-peak.sh |  5 ++---
 7 files changed, 111 insertions(+), 22 deletions(-)
 create mode 100644 os/windows/dlls.c

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 5198f70e..c3feb53f 100644
--- a/Makefile
+++ b/Makefile
@@ -275,8 +275,8 @@ ifeq ($(CONFIG_TARGET_OS), Darwin)
   LIBS	 += -lpthread -ldl
 endif
 ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
-  SOURCE += os/windows/cpu-affinity.c os/windows/posix.c
-  WINDOWS_OBJS = os/windows/cpu-affinity.o os/windows/posix.o lib/hweight.o
+  SOURCE += os/windows/cpu-affinity.c os/windows/posix.c os/windows/dlls.c
+  WINDOWS_OBJS = os/windows/cpu-affinity.o os/windows/posix.o os/windows/dlls.o lib/hweight.o
   LIBS	 += -lpthread -lpsapi -lws2_32 -lssp
   FIO_CFLAGS += -DPSAPI_VERSION=1 -Ios/windows/posix/include -Wno-format
 endif
diff --git a/helper_thread.c b/helper_thread.c
index d8e7ebfe..b9b83db3 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -9,6 +9,10 @@
 #define DRD_IGNORE_VAR(x) do { } while (0)
 #endif
 
+#ifdef WIN32
+#include "os/os-windows.h"
+#endif
+
 #include "fio.h"
 #include "smalloc.h"
 #include "helper_thread.h"
@@ -283,19 +287,12 @@ static void *helper_thread_main(void *data)
 		}
 	};
 	struct timespec ts;
-	int clk_tck, ret = 0;
+	long clk_tck;
+	int ret = 0;
 
-#ifdef _SC_CLK_TCK
-	clk_tck = sysconf(_SC_CLK_TCK);
-#else
-	/*
-	 * The timer frequence is variable on Windows. Instead of trying to
-	 * query it, use 64 Hz, the clock frequency lower bound. See also
-	 * https://carpediemsystems.co.uk/2019/07/18/windows-system-timer-granularity/.
-	 */
-	clk_tck = 64;
-#endif
-	dprint(FD_HELPERTHREAD, "clk_tck = %d\n", clk_tck);
+	os_clk_tck(&clk_tck);
+
+	dprint(FD_HELPERTHREAD, "clk_tck = %ld\n", clk_tck);
 	assert(clk_tck > 0);
 	sleep_accuracy_ms = (1000 + clk_tck - 1) / clk_tck;
 
diff --git a/os/os.h b/os/os.h
index 827b61e9..5965d7b8 100644
--- a/os/os.h
+++ b/os/os.h
@@ -412,4 +412,13 @@ static inline bool os_cpu_has(cpu_features feature)
 # define fio_mkdir(path, mode)	mkdir(path, mode)
 #endif
 
+#ifdef _SC_CLK_TCK
+static inline void os_clk_tck(long *clk_tck)
+{
+	*clk_tck = sysconf(_SC_CLK_TCK);
+}
+#else
+extern void os_clk_tck(long *clk_tck);
+#endif
+
 #endif /* FIO_OS_H */
diff --git a/os/windows/dlls.c b/os/windows/dlls.c
new file mode 100644
index 00000000..774b1c61
--- /dev/null
+++ b/os/windows/dlls.c
@@ -0,0 +1,33 @@
+#include "os/os.h"
+
+#include <windows.h>
+
+void os_clk_tck(long *clk_tck)
+{
+	/*
+	 * The timer resolution is variable on Windows. Try to query it 
+	 * or use 64 Hz, the clock frequency lower bound. See also
+	 * https://carpediemsystems.co.uk/2019/07/18/windows-system-timer-granularity/.
+	 */
+	unsigned long minRes, maxRes, curRes;
+	HMODULE lib;
+	FARPROC queryTimer;
+	FARPROC setTimer;
+
+	if (!(lib = LoadLibrary(TEXT("ntdll.dll"))) ||
+		!(queryTimer = GetProcAddress(lib, "NtQueryTimerResolution")) ||
+		!(setTimer = GetProcAddress(lib, "NtSetTimerResolution"))) {
+		dprint(FD_HELPERTHREAD, 
+			"Failed to load ntdll library, set to lower bound 64 Hz\n");
+		*clk_tck = 64;
+	} else {
+		queryTimer(&minRes, &maxRes, &curRes);
+		dprint(FD_HELPERTHREAD, 
+			"minRes = %lu, maxRes = %lu, curRes = %lu\n",
+			minRes, maxRes, curRes);
+
+		/* Use maximum resolution for most accurate timestamps */
+		setTimer(maxRes, 1, &curRes);
+		*clk_tck = (long) (10000000L / maxRes);
+	}
+}
\ No newline at end of file
diff --git a/stat.c b/stat.c
index ac53463d..30f9b5c1 100644
--- a/stat.c
+++ b/stat.c
@@ -17,7 +17,11 @@
 #include "zbd.h"
 #include "oslib/asprintf.h"
 
+#ifdef WIN32
+#define LOG_MSEC_SLACK	2
+#else
 #define LOG_MSEC_SLACK	1
+#endif
 
 struct fio_sem *stat_sem;
 
diff --git a/t/io_uring.c b/t/io_uring.c
index cdd15986..84960ba9 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -110,6 +110,7 @@ static int batch_complete = BATCH_COMPLETE;
 static int bs = BS;
 static int polled = 1;		/* use IO polling */
 static int fixedbufs = 1;	/* use fixed user buffers */
+static int dma_map;		/* pre-map DMA buffers */
 static int register_files = 1;	/* use fixed files */
 static int buffered = 0;	/* use buffered IO, not O_DIRECT */
 static int sq_thread_poll = 0;	/* use kernel submission/poller thread */
@@ -130,6 +131,17 @@ static float plist[] = { 1.0, 5.0, 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0,
 			80.0, 90.0, 95.0, 99.0, 99.5, 99.9, 99.95, 99.99 };
 static int plist_len = 17;
 
+#ifndef IORING_REGISTER_MAP_BUFFERS
+#define IORING_REGISTER_MAP_BUFFERS	20
+struct io_uring_map_buffers {
+	__s32	fd;
+	__u32	buf_start;
+	__u32	buf_end;
+	__u32	flags;
+	__u64	rsvd[2];
+};
+#endif
+
 static unsigned long cycles_to_nsec(unsigned long cycles)
 {
 	uint64_t val;
@@ -319,6 +331,24 @@ static void add_stat(struct submitter *s, int clock_index, int nr)
 #endif
 }
 
+static int io_uring_map_buffers(struct submitter *s)
+{
+	struct io_uring_map_buffers map = {
+		.fd		= s->files[0].real_fd,
+		.buf_end	= depth,
+	};
+
+	if (do_nop)
+		return 0;
+	if (s->nr_files > 1) {
+		fprintf(stderr, "Can't map buffers with multiple files\n");
+		return -1;
+	}
+
+	return syscall(__NR_io_uring_register, s->ring_fd,
+			IORING_REGISTER_MAP_BUFFERS, &map, 1);
+}
+
 static int io_uring_register_buffers(struct submitter *s)
 {
 	if (do_nop)
@@ -945,6 +975,14 @@ static int setup_ring(struct submitter *s)
 			perror("io_uring_register_buffers");
 			return 1;
 		}
+
+		if (dma_map) {
+			ret = io_uring_map_buffers(s);
+			if (ret < 0) {
+				perror("io_uring_map_buffers");
+				return 1;
+			}
+		}
 	}
 
 	if (register_files) {
@@ -1016,6 +1054,7 @@ static void usage(char *argv, int status)
 		" -b <int>  : Block size, default %d\n"
 		" -p <bool> : Polled IO, default %d\n"
 		" -B <bool> : Fixed buffers, default %d\n"
+		" -R <bool> : DMA map fixed buffers, default %d\n"
 		" -F <bool> : Register files, default %d\n"
 		" -n <int>  : Number of threads, default %d\n"
 		" -O <bool> : Use O_DIRECT, default %d\n"
@@ -1025,8 +1064,8 @@ static void usage(char *argv, int status)
 		" -a <bool> : Use legacy aio, default %d\n"
 		" -r <int>  : Runtime in seconds, default %s\n",
 		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled,
-		fixedbufs, register_files, nthreads, !buffered, do_nop, stats, aio,
-		runtime == 0 ? "unlimited" : runtime_str);
+		fixedbufs, dma_map, register_files, nthreads, !buffered, do_nop,
+		stats, aio, runtime == 0 ? "unlimited" : runtime_str);
 	exit(status);
 }
 
@@ -1086,7 +1125,7 @@ int main(int argc, char *argv[])
 	if (!do_nop && argc < 2)
 		usage(argv[0], 1);
 
-	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:a:r:h?")) != -1) {
+	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:a:r:D:h?")) != -1) {
 		switch (opt) {
 		case 'a':
 			aio = !!atoi(optarg);
@@ -1147,6 +1186,9 @@ int main(int argc, char *argv[])
 		case 'r':
 			runtime = atoi(optarg);
 			break;
+		case 'D':
+			dma_map = !!atoi(optarg);
+			break;
 		case 'h':
 		case '?':
 		default:
@@ -1162,6 +1204,8 @@ int main(int argc, char *argv[])
 		batch_complete = depth;
 	if (batch_submit > depth)
 		batch_submit = depth;
+	if (!fixedbufs && dma_map)
+		dma_map = 0;
 
 	submitter = calloc(nthreads, sizeof(*submitter) +
 				depth * sizeof(struct iovec));
@@ -1261,7 +1305,7 @@ int main(int argc, char *argv[])
 		}
 	}
 	s = get_submitter(0);
-	printf("polled=%d, fixedbufs=%d, register_files=%d, buffered=%d, QD=%d\n", polled, fixedbufs, register_files, buffered, depth);
+	printf("polled=%d, fixedbufs=%d/%d, register_files=%d, buffered=%d, QD=%d\n", polled, fixedbufs, dma_map, register_files, buffered, depth);
 	if (!aio)
 		printf("Engine=io_uring, sq_ring=%d, cq_ring=%d\n", *s->sq_ring.ring_entries, *s->cq_ring.ring_entries);
 	else
@@ -1314,7 +1358,10 @@ int main(int argc, char *argv[])
 			bw = iops * (bs / 1048576);
 		else
 			bw = iops / (1048576 / bs);
-		printf("IOPS=%lu, ", iops);
+		if (iops > 100000)
+			printf("IOPS=%luK, ", iops / 1000);
+		else
+			printf("IOPS=%luK, ", iops);
 		if (!do_nop)
 			printf("BW=%luMiB/s, ", bw);
 		printf("IOS/call=%ld/%ld, inflight=(%s)\n", rpc, ipc, fdepths);
diff --git a/t/one-core-peak.sh b/t/one-core-peak.sh
index 11b1d69a..fba4ec95 100755
--- a/t/one-core-peak.sh
+++ b/t/one-core-peak.sh
@@ -153,10 +153,9 @@ check_sysblock_value() {
   target_file="${sys_block_dir}/$2"
   value=$3
   [ -f "${target_file}" ] || return
-  content=$(cat ${target_file})
+  content=$(cat ${target_file} 2>/dev/null)
   if [ "${content}" != "${value}" ]; then
-    info "${device_name}" "${target_file} set to ${value}."
-    echo ${value} > ${target_file} 2>/dev/null || hint "${device_name}: Cannot set ${value} on ${target_file}"
+    echo ${value} > ${target_file} 2>/dev/null && info "${device_name}" "${target_file} set to ${value}." || hint "${device_name}: Cannot set ${value} on ${target_file}"
   fi
 }
 
