Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51220 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbbLANAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 1 Dec 2015 08:00:03 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1a3kXK-0006vq-D2
	for fio@vger.kernel.org; Tue, 01 Dec 2015 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151201130001.70C662C00E9@kernel.dk>
Date: Tue,  1 Dec 2015 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6a6b11f436c822cac154da5a60c4cc6baa6a8008:

  Makefile: generate .d dep file for init.c (2015-11-25 21:24:01 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b9c8a72a5795a58bd6bf060a79393e835db57a95:

  Makefile: missing conversion, and oslib/ dep cleanup (2015-11-30 19:46:20 -0700)

----------------------------------------------------------------
Andrey Kuzmin (1):
      io_size vs. time_based discrepancy

Jens Axboe (8):
      io_u: don't use xfer_buflen before we have set it up
      Clear rusage stat when resetting all stats
      stat: use DDIR_RWDIR_CNT instead of hardwired '3'
      stat: move header declarations from iolog.h
      Move memalign to lib/
      Makefile: re-arrange lib/
      Move conditional lib files to oslib/
      Makefile: missing conversion, and oslib/ dep cleanup

 Makefile                          | 45 ++++++++++++++++++---------------------
 backend.c                         |  4 ++--
 blktrace.c                        |  2 +-
 engines/mtd.c                     |  2 +-
 init.c                            |  2 +-
 io_u.c                            |  2 +-
 iolog.h                           | 15 -------------
 memalign.c => lib/memalign.c      |  0
 memalign.h => lib/memalign.h      |  0
 libfio.c                          |  1 +
 os/os-windows.h                   |  2 +-
 os/os.h                           |  4 ++--
 {lib => oslib}/getopt_long.c      |  0
 {lib => oslib}/inet_aton.c        |  0
 {lib => oslib}/inet_aton.h        |  0
 {lib => oslib}/libmtd.c           |  0
 {lib => oslib}/libmtd.h           |  0
 {lib => oslib}/libmtd_common.h    |  0
 {lib => oslib}/libmtd_int.h       |  0
 {lib => oslib}/libmtd_legacy.c    |  0
 {lib => oslib}/libmtd_xalloc.h    |  0
 {lib => oslib}/linux-dev-lookup.c |  0
 {lib => oslib}/linux-dev-lookup.h |  0
 {lib => oslib}/strcasestr.c       |  0
 {lib => oslib}/strcasestr.h       |  0
 {lib => oslib}/strlcat.c          |  0
 {lib => oslib}/strlcat.h          |  0
 {lib => oslib}/strsep.c           |  0
 {lib => oslib}/strsep.h           |  0
 stat.c                            | 10 +++++++++
 stat.h                            | 23 +++++++++++++++++---
 t/btrace2fio.c                    |  2 +-
 t/dedupe.c                        |  2 +-
 33 files changed, 63 insertions(+), 53 deletions(-)
 rename memalign.c => lib/memalign.c (100%)
 rename memalign.h => lib/memalign.h (100%)
 rename {lib => oslib}/getopt_long.c (100%)
 rename {lib => oslib}/inet_aton.c (100%)
 rename {lib => oslib}/inet_aton.h (100%)
 rename {lib => oslib}/libmtd.c (100%)
 rename {lib => oslib}/libmtd.h (100%)
 rename {lib => oslib}/libmtd_common.h (100%)
 rename {lib => oslib}/libmtd_int.h (100%)
 rename {lib => oslib}/libmtd_legacy.c (100%)
 rename {lib => oslib}/libmtd_xalloc.h (100%)
 rename {lib => oslib}/linux-dev-lookup.c (100%)
 rename {lib => oslib}/linux-dev-lookup.h (100%)
 rename {lib => oslib}/strcasestr.c (100%)
 rename {lib => oslib}/strcasestr.h (100%)
 rename {lib => oslib}/strlcat.c (100%)
 rename {lib => oslib}/strlcat.h (100%)
 rename {lib => oslib}/strsep.c (100%)
 rename {lib => oslib}/strsep.h (100%)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index e30273c..102cc69 100644
--- a/Makefile
+++ b/Makefile
@@ -36,19 +36,16 @@ ifdef CONFIG_GFIO
   PROGS += gfio
 endif
 
-SOURCE :=	gettime.c ioengines.c init.c stat.c log.c time.c filesetup.c \
+SOURCE :=	$(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
+		$(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/lib/*.c)) \
+		gettime.c ioengines.c init.c stat.c log.c time.c filesetup.c \
 		eta.c verify.c memory.c io_u.c parse.c mutex.c options.c \
-		lib/rbtree.c smalloc.c filehash.c profile.c debug.c lib/rand.c \
-		lib/num2str.c lib/ieee754.c lib/strntol.c engines/cpu.c \
+		smalloc.c filehash.c profile.c debug.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
-		memalign.c server.c client.c iolog.c backend.c libfio.c flow.c \
-		cconv.c lib/prio_tree.c lib/zipf.c lib/axmap.c lib/pattern.c \
-		lib/lfsr.c gettime-thread.c helpers.c lib/flist_sort.c json.c \
-		lib/hweight.c lib/getrusage.c idletime.c td_error.c \
+		server.c client.c iolog.c backend.c libfio.c flow.c cconv.c \
+		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
-		lib/tp.c lib/bloom.c lib/gauss.c lib/mountcheck.c workqueue.c \
-		lib/output_buffer.c \
-		$(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c))
+		workqueue.c
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
@@ -100,19 +97,19 @@ ifdef CONFIG_RBD
   SOURCE += engines/rbd.c
 endif
 ifndef CONFIG_STRSEP
-  SOURCE += lib/strsep.c
+  SOURCE += oslib/strsep.c
 endif
 ifndef CONFIG_STRCASESTR
-  SOURCE += lib/strcasestr.c
+  SOURCE += oslib/strcasestr.c
 endif
 ifndef CONFIG_STRLCAT
-  SOURCE += lib/strlcat.c
+  SOURCE += oslib/strlcat.c
 endif
 ifndef CONFIG_GETOPT_LONG_ONLY
-  SOURCE += lib/getopt_long.c
+  SOURCE += oslib/getopt_long.c
 endif
 ifndef CONFIG_INET_ATON
-  SOURCE += lib/inet_aton.c
+  SOURCE += oslib/inet_aton.c
 endif
 ifdef CONFIG_GFAPI
   SOURCE += engines/glusterfs.c
@@ -124,19 +121,19 @@ ifdef CONFIG_GFAPI
 endif
 ifdef CONFIG_MTD
   SOURCE += engines/mtd.c
-  SOURCE += lib/libmtd.c
-  SOURCE += lib/libmtd_legacy.c
+  SOURCE += oslib/libmtd.c
+  SOURCE += oslib/libmtd_legacy.c
 endif
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
-		engines/binject.c lib/linux-dev-lookup.c
+		engines/binject.c oslib/linux-dev-lookup.c
   LIBS += -lpthread -ldl
   LDFLAGS += -rdynamic
 endif
 ifeq ($(CONFIG_TARGET_OS), Android)
   SOURCE += diskutil.c fifo.c blktrace.c trim.c profiles/tiobench.c \
-		lib/linux-dev-lookup.c
+		oslib/linux-dev-lookup.c
   LIBS += -ldl
   LDFLAGS += -rdynamic
 endif
@@ -216,14 +213,14 @@ T_LFSR_TEST_PROGS = t/lfsr-test
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
 T_BTRACE_FIO_OBJS = t/btrace2fio.o
-T_BTRACE_FIO_OBJS += fifo.o lib/flist_sort.o t/log.o lib/linux-dev-lookup.o
+T_BTRACE_FIO_OBJS += fifo.o lib/flist_sort.o t/log.o oslib/linux-dev-lookup.o
 T_BTRACE_FIO_PROGS = t/fio-btrace2fio
 endif
 
 T_DEDUPE_OBJS = t/dedupe.o
 T_DEDUPE_OBJS += lib/rbtree.o t/log.o mutex.o smalloc.o gettime.o crc/md5.o \
-		memalign.o lib/bloom.o t/debug.o crc/xxhash.o crc/murmur3.o \
-		crc/crc32c.o crc/crc32c-intel.o crc/fnv.o
+		lib/memalign.o lib/bloom.o t/debug.o crc/xxhash.o \
+		crc/murmur3.o crc/crc32c.o crc/crc32c-intel.o crc/fnv.o
 T_DEDUPE_PROGS = t/fio-dedupe
 
 T_OBJS = $(T_SMALLOC_OBJS)
@@ -238,7 +235,7 @@ ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
     T_DEDUPE_OBJS += os/windows/posix.o lib/hweight.o
     T_SMALLOC_OBJS += os/windows/posix.o lib/hweight.o
     T_LFSR_TEST_OBJS += os/windows/posix.o lib/hweight.o
-    T_ZIPF_OBJS += lib/strcasestr.o
+    T_ZIPF_OBJS += oslib/strcasestr.o
 endif
 
 T_TEST_PROGS = $(T_SMALLOC_PROGS)
@@ -390,7 +387,7 @@ t/fio-dedupe: $(T_DEDUPE_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_DEDUPE_OBJS) $(LIBS)
 
 clean: FORCE
-	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) $(T_TEST_PROGS) core.* core gfio FIO-VERSION-FILE *.d lib/*.d crc/*.d engines/*.d profiles/*.d t/*.d config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do] lexer.h
+	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) $(T_TEST_PROGS) core.* core gfio FIO-VERSION-FILE *.d lib/*.d oslib/*.d crc/*.d engines/*.d profiles/*.d t/*.d config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do] lexer.h
 
 distclean: clean FORCE
 	@rm -f cscope.out fio.pdf fio_generate_plots.pdf fio2gnuplot.pdf
diff --git a/backend.c b/backend.c
index 1560749..9a142e8 100644
--- a/backend.c
+++ b/backend.c
@@ -49,7 +49,7 @@
 #include "cgroup.h"
 #include "profile.h"
 #include "lib/rand.h"
-#include "memalign.h"
+#include "lib/memalign.h"
 #include "server.h"
 #include "lib/getrusage.h"
 #include "idletime.h"
@@ -868,7 +868,7 @@ static uint64_t do_io(struct thread_data *td)
 		if (flow_threshold_exceeded(td))
 			continue;
 
-		if (bytes_issued >= total_bytes)
+		if (!td->o.time_based && bytes_issued >= total_bytes)
 			break;
 
 		io_u = get_io_u(td);
diff --git a/blktrace.c b/blktrace.c
index 562e126..deb8b2d 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -11,7 +11,7 @@
 #include "flist.h"
 #include "fio.h"
 #include "blktrace_api.h"
-#include "lib/linux-dev-lookup.h"
+#include "oslib/linux-dev-lookup.h"
 
 #define TRACE_FIFO_SIZE	8192
 
diff --git a/engines/mtd.c b/engines/mtd.c
index 9381089..7b92c83 100644
--- a/engines/mtd.c
+++ b/engines/mtd.c
@@ -14,7 +14,7 @@
 
 #include "../fio.h"
 #include "../verify.h"
-#include "../lib/libmtd.h"
+#include "../oslib/libmtd.h"
 
 libmtd_t desc;
 
diff --git a/init.c b/init.c
index b7945cf..353cc2b 100644
--- a/init.c
+++ b/init.c
@@ -27,7 +27,7 @@
 #include "filelock.h"
 
 #include "lib/getopt.h"
-#include "lib/strcasestr.h"
+#include "oslib/strcasestr.h"
 
 #include "crc/test.h"
 
diff --git a/io_u.c b/io_u.c
index dd4502f..3b27d5e 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1527,7 +1527,7 @@ struct io_u *get_io_u(struct thread_data *td)
 			if (td->flags & TD_F_REFILL_BUFFERS) {
 				io_u_fill_buffer(td, io_u,
 					td->o.min_bs[DDIR_WRITE],
-					io_u->xfer_buflen);
+					io_u->buflen);
 			} else if ((td->flags & TD_F_SCRAMBLE_BUFFERS) &&
 				   !(td->flags & TD_F_COMPRESS))
 				do_scramble = 1;
diff --git a/iolog.h b/iolog.h
index aa4562d..eb5fdf3 100644
--- a/iolog.h
+++ b/iolog.h
@@ -203,24 +203,9 @@ struct log_params {
 };
 
 extern void finalize_logs(struct thread_data *td);
-extern void add_lat_sample(struct thread_data *, enum fio_ddir, unsigned long,
-				unsigned int, uint64_t);
-extern void add_clat_sample(struct thread_data *, enum fio_ddir, unsigned long,
-				unsigned int, uint64_t);
-extern void add_slat_sample(struct thread_data *, enum fio_ddir, unsigned long,
-				unsigned int, uint64_t);
-extern void add_bw_sample(struct thread_data *, enum fio_ddir, unsigned int,
-				struct timeval *);
-extern void add_iops_sample(struct thread_data *, enum fio_ddir, unsigned int,
-				struct timeval *);
-extern void init_disk_util(struct thread_data *);
-extern void update_rusage_stat(struct thread_data *);
 extern void setup_log(struct io_log **, struct log_params *, const char *);
 extern void flush_log(struct io_log *, int);
 extern void free_log(struct io_log *);
-extern struct io_log *agg_io_log[DDIR_RWDIR_CNT];
-extern int write_bw_log;
-extern void add_agg_sample(unsigned long, enum fio_ddir, unsigned int);
 extern void fio_writeout_logs(struct thread_data *);
 extern int iolog_flush(struct io_log *, int);
 
diff --git a/lib/getopt_long.c b/lib/getopt_long.c
deleted file mode 100644
index 11d879a..0000000
--- a/lib/getopt_long.c
+++ /dev/null
@@ -1,167 +0,0 @@
-/*
- * getopt.c
- *
- * getopt_long(), or at least a common subset thereof:
- *
- * - Option reordering is not supported
- * - -W foo is not supported
- * - First optstring character "-" not supported.
- *
- * This file was imported from the klibc library from hpa
- */
-
-#include <stdint.h>
-#include <unistd.h>
-#include <string.h>
-
-#include "getopt.h"
-
-char *optarg = NULL;
-int optind = 0, opterr = 0, optopt = 0;
-
-static struct getopt_private_state {
-	const char *optptr;
-	const char *last_optstring;
-	char *const *last_argv;
-} pvt;
-
-static inline const char *option_matches(const char *arg_str,
-					 const char *opt_name)
-{
-	while (*arg_str != '\0' && *arg_str != '=') {
-		if (*arg_str++ != *opt_name++)
-			return NULL;
-	}
-
-	if (*opt_name)
-		return NULL;
-
-	return arg_str;
-}
-
-int getopt_long_only(int argc, char *const *argv, const char *optstring,
-		const struct option *longopts, int *longindex)
-{
-	const char *carg;
-	const char *osptr;
-	int opt;
-
-	optarg = NULL;
-
-	/* getopt() relies on a number of different global state
-	   variables, which can make this really confusing if there is
-	   more than one use of getopt() in the same program.  This
-	   attempts to detect that situation by detecting if the
-	   "optstring" or "argv" argument have changed since last time
-	   we were called; if so, reinitialize the query state. */
-
-	if (optstring != pvt.last_optstring || argv != pvt.last_argv ||
-	    optind < 1 || optind > argc) {
-		/* optind doesn't match the current query */
-		pvt.last_optstring = optstring;
-		pvt.last_argv = argv;
-		optind = 1;
-		pvt.optptr = NULL;
-	}
-
-	carg = argv[optind];
-
-	/* First, eliminate all non-option cases */
-
-	if (!carg || carg[0] != '-' || !carg[1])
-		return -1;
-
-	if (carg[1] == '-') {
-		const struct option *lo;
-		const char *opt_end = NULL;
-
-		optind++;
-
-		/* Either it's a long option, or it's -- */
-		if (!carg[2]) {
-			/* It's -- */
-			return -1;
-		}
-
-		for (lo = longopts; lo->name; lo++) {
-			if ((opt_end = option_matches(carg+2, lo->name)))
-			    break;
-		}
-		if (!opt_end)
-			return '?';
-
-		if (longindex)
-			*longindex = lo-longopts;
-
-		if (*opt_end == '=') {
-			if (lo->has_arg)
-				optarg = (char *)opt_end+1;
-			else
-				return '?';
-		} else if (lo->has_arg == 1) {
-			if (!(optarg = argv[optind]))
-				return '?';
-			optind++;
-		}
-
-		if (lo->flag) {
-			*lo->flag = lo->val;
-			return 0;
-		} else {
-			return lo->val;
-		}
-	}
-
-	if ((uintptr_t) (pvt.optptr - carg) > (uintptr_t) strlen(carg)) {
-		/* Someone frobbed optind, change to new opt. */
-		pvt.optptr = carg + 1;
-	}
-
-	opt = *pvt.optptr++;
-
-	if (opt != ':' && (osptr = strchr(optstring, opt))) {
-		if (osptr[1] == ':') {
-			if (*pvt.optptr) {
-				/* Argument-taking option with attached
-				   argument */
-				optarg = (char *)pvt.optptr;
-				optind++;
-			} else {
-				/* Argument-taking option with non-attached
-				   argument */
-				if (osptr[2] == ':') {
-					if (argv[optind + 1]) {
-						optarg = (char *)argv[optind+1];
-						optind += 2;
-					} else {
-						optarg = NULL;
-						optind++;
-					}
-					return opt;
-				} else if (argv[optind + 1]) {
-					optarg = (char *)argv[optind+1];
-					optind += 2;
-				} else {
-					/* Missing argument */
-					optind++;
-					return (optstring[0] == ':')
-						? ':' : '?';
-				}
-			}
-			return opt;
-		} else {
-			/* Non-argument-taking option */
-			/* pvt.optptr will remember the exact position to
-			   resume at */
-			if (!*pvt.optptr)
-				optind++;
-			return opt;
-		}
-	} else {
-		/* Unknown option */
-		optopt = opt;
-		if (!*pvt.optptr)
-			optind++;
-		return '?';
-	}
-}
diff --git a/lib/inet_aton.c b/lib/inet_aton.c
deleted file mode 100644
index 7ae7db7..0000000
--- a/lib/inet_aton.c
+++ /dev/null
@@ -1,6 +0,0 @@
-#include "inet_aton.h"
-
-int inet_aton(const char *cp, struct in_addr *inp)
-{
-	return inet_pton(AF_INET, cp, inp);
-}
diff --git a/lib/inet_aton.h b/lib/inet_aton.h
deleted file mode 100644
index c93c87f..0000000
--- a/lib/inet_aton.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef FIO_INET_ATON_LIB_H
-#define FIO_INET_ATON_LIB_H
-
-#include <arpa/inet.h>
-
-int inet_aton(const char *cp, struct in_addr *inp);
-
-#endif
diff --git a/lib/libmtd.c b/lib/libmtd.c
deleted file mode 100644
index 5c9eac2..0000000
--- a/lib/libmtd.c
+++ /dev/null
@@ -1,1424 +0,0 @@
-/*
- * Copyright (c) International Business Machines Corp., 2006
- * Copyright (C) 2009 Nokia Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
- * the GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- * Author: Artem Bityutskiy
- *
- * MTD library.
- */
-
-/* Imported from mtd-utils by dehrenberg */
-
-#include <limits.h>
-#include <stdlib.h>
-#include <stdio.h>
-#include <errno.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <dirent.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/ioctl.h>
-#include <inttypes.h>
-
-#include <mtd/mtd-user.h>
-#include "libmtd.h"
-
-#include "libmtd_int.h"
-#include "libmtd_common.h"
-
-/**
- * mkpath - compose full path from 2 given components.
- * @path: the first component
- * @name: the second component
- *
- * This function returns the resulting path in case of success and %NULL in
- * case of failure.
- */
-static char *mkpath(const char *path, const char *name)
-{
-	char *n;
-	size_t len1 = strlen(path);
-	size_t len2 = strlen(name);
-
-	n = xmalloc(len1 + len2 + 6);
-
-	memcpy(n, path, len1);
-	if (n[len1 - 1] != '/')
-		n[len1++] = '/';
-
-	memcpy(n + len1, name, len2 + 1);
-	return n;
-}
-
-/**
- * read_data - read data from a file.
- * @file: the file to read from
- * @buf: the buffer to read to
- * @buf_len: buffer length
- *
- * This function returns number of read bytes in case of success and %-1 in
- * case of failure. Note, if the file contains more then @buf_len bytes of
- * date, this function fails with %EINVAL error code.
- */
-static int read_data(const char *file, void *buf, int buf_len)
-{
-	int fd, rd, tmp, tmp1;
-
-	fd = open(file, O_RDONLY | O_CLOEXEC);
-	if (fd == -1)
-		return -1;
-
-	rd = read(fd, buf, buf_len);
-	if (rd == -1) {
-		sys_errmsg("cannot read \"%s\"", file);
-		goto out_error;
-	}
-
-	if (rd == buf_len) {
-		errmsg("contents of \"%s\" is too long", file);
-		errno = EINVAL;
-		goto out_error;
-	}
-
-	((char *)buf)[rd] = '\0';
-
-	/* Make sure all data is read */
-	tmp1 = read(fd, &tmp, 1);
-	if (tmp1 == 1) {
-		sys_errmsg("cannot read \"%s\"", file);
-		goto out_error;
-	}
-	if (tmp1) {
-		errmsg("file \"%s\" contains too much data (> %d bytes)",
-		       file, buf_len);
-		errno = EINVAL;
-		goto out_error;
-	}
-
-	if (close(fd)) {
-		sys_errmsg("close failed on \"%s\"", file);
-		return -1;
-	}
-
-	return rd;
-
-out_error:
-	close(fd);
-	return -1;
-}
-
-/**
- * read_major - read major and minor numbers from a file.
- * @file: name of the file to read from
- * @major: major number is returned here
- * @minor: minor number is returned here
- *
- * This function returns % in case of success, and %-1 in case of failure.
- */
-static int read_major(const char *file, int *major, int *minor)
-{
-	int ret;
-	char buf[50];
-
-	ret = read_data(file, buf, 50);
-	if (ret < 0)
-		return ret;
-
-	ret = sscanf(buf, "%d:%d\n", major, minor);
-	if (ret != 2) {
-		errno = EINVAL;
-		return errmsg("\"%s\" does not have major:minor format", file);
-	}
-
-	if (*major < 0 || *minor < 0) {
-		errno = EINVAL;
-		return errmsg("bad major:minor %d:%d in \"%s\"",
-			      *major, *minor, file);
-	}
-
-	return 0;
-}
-
-/**
- * dev_get_major - get major and minor numbers of an MTD device.
- * @lib: libmtd descriptor
- * @mtd_num: MTD device number
- * @major: major number is returned here
- * @minor: minor number is returned here
- *
- * This function returns zero in case of success and %-1 in case of failure.
- */
-static int dev_get_major(struct libmtd *lib, int mtd_num, int *major, int *minor)
-{
-	char file[strlen(lib->mtd_dev) + 50];
-
-	sprintf(file, lib->mtd_dev, mtd_num);
-	return read_major(file, major, minor);
-}
-
-/**
- * dev_read_data - read data from an MTD device's sysfs file.
- * @patt: file pattern to read from
- * @mtd_num: MTD device number
- * @buf: buffer to read to
- * @buf_len: buffer length
- *
- * This function returns number of read bytes in case of success and %-1 in
- * case of failure.
- */
-static int dev_read_data(const char *patt, int mtd_num, void *buf, int buf_len)
-{
-	char file[strlen(patt) + 100];
-
-	sprintf(file, patt, mtd_num);
-	return read_data(file, buf, buf_len);
-}
-
-/**
- * read_hex_ll - read a hex 'long long' value from a file.
- * @file: the file to read from
- * @value: the result is stored here
- *
- * This function reads file @file and interprets its contents as hexadecimal
- * 'long long' integer. If this is not true, it fails with %EINVAL error code.
- * Returns %0 in case of success and %-1 in case of failure.
- */
-static int read_hex_ll(const char *file, long long *value)
-{
-	int fd, rd;
-	char buf[50];
-
-	fd = open(file, O_RDONLY | O_CLOEXEC);
-	if (fd == -1)
-		return -1;
-
-	rd = read(fd, buf, sizeof(buf));
-	if (rd == -1) {
-		sys_errmsg("cannot read \"%s\"", file);
-		goto out_error;
-	}
-	if (rd == sizeof(buf)) {
-		errmsg("contents of \"%s\" is too long", file);
-		errno = EINVAL;
-		goto out_error;
-	}
-	buf[rd] = '\0';
-
-	if (sscanf(buf, "%llx\n", value) != 1) {
-		errmsg("cannot read integer from \"%s\"\n", file);
-		errno = EINVAL;
-		goto out_error;
-	}
-
-	if (*value < 0) {
-		errmsg("negative value %lld in \"%s\"", *value, file);
-		errno = EINVAL;
-		goto out_error;
-	}
-
-	if (close(fd))
-		return sys_errmsg("close failed on \"%s\"", file);
-
-	return 0;
-
-out_error:
-	close(fd);
-	return -1;
-}
-
-/**
- * read_pos_ll - read a positive 'long long' value from a file.
- * @file: the file to read from
- * @value: the result is stored here
- *
- * This function reads file @file and interprets its contents as a positive
- * 'long long' integer. If this is not true, it fails with %EINVAL error code.
- * Returns %0 in case of success and %-1 in case of failure.
- */
-static int read_pos_ll(const char *file, long long *value)
-{
-	int fd, rd;
-	char buf[50];
-
-	fd = open(file, O_RDONLY | O_CLOEXEC);
-	if (fd == -1)
-		return -1;
-
-	rd = read(fd, buf, 50);
-	if (rd == -1) {
-		sys_errmsg("cannot read \"%s\"", file);
-		goto out_error;
-	}
-	if (rd == 50) {
-		errmsg("contents of \"%s\" is too long", file);
-		errno = EINVAL;
-		goto out_error;
-	}
-
-	if (sscanf(buf, "%lld\n", value) != 1) {
-		errmsg("cannot read integer from \"%s\"\n", file);
-		errno = EINVAL;
-		goto out_error;
-	}
-
-	if (*value < 0) {
-		errmsg("negative value %lld in \"%s\"", *value, file);
-		errno = EINVAL;
-		goto out_error;
-	}
-
-	if (close(fd))
-		return sys_errmsg("close failed on \"%s\"", file);
-
-	return 0;
-
-out_error:
-	close(fd);
-	return -1;
-}
-
-/**
- * read_hex_int - read an 'int' value from a file.
- * @file: the file to read from
- * @value: the result is stored here
- *
- * This function is the same as 'read_pos_ll()', but it reads an 'int'
- * value, not 'long long'.
- */
-static int read_hex_int(const char *file, int *value)
-{
-	long long res;
-
-	if (read_hex_ll(file, &res))
-		return -1;
-
-	/* Make sure the value has correct range */
-	if (res > INT_MAX || res < INT_MIN) {
-		errmsg("value %lld read from file \"%s\" is out of range",
-		       res, file);
-		errno = EINVAL;
-		return -1;
-	}
-
-	*value = res;
-	return 0;
-}
-
-/**
- * read_pos_int - read a positive 'int' value from a file.
- * @file: the file to read from
- * @value: the result is stored here
- *
- * This function is the same as 'read_pos_ll()', but it reads an 'int'
- * value, not 'long long'.
- */
-static int read_pos_int(const char *file, int *value)
-{
-	long long res;
-
-	if (read_pos_ll(file, &res))
-		return -1;
-
-	/* Make sure the value is not too big */
-	if (res > INT_MAX) {
-		errmsg("value %lld read from file \"%s\" is out of range",
-		       res, file);
-		errno = EINVAL;
-		return -1;
-	}
-
-	*value = res;
-	return 0;
-}
-
-/**
- * dev_read_hex_int - read an hex 'int' value from an MTD device sysfs file.
- * @patt: file pattern to read from
- * @mtd_num: MTD device number
- * @value: the result is stored here
- *
- * This function returns %0 in case of success and %-1 in case of failure.
- */
-static int dev_read_hex_int(const char *patt, int mtd_num, int *value)
-{
-	char file[strlen(patt) + 50];
-
-	sprintf(file, patt, mtd_num);
-	return read_hex_int(file, value);
-}
-
-/**
- * dev_read_pos_int - read a positive 'int' value from an MTD device sysfs file.
- * @patt: file pattern to read from
- * @mtd_num: MTD device number
- * @value: the result is stored here
- *
- * This function returns %0 in case of success and %-1 in case of failure.
- */
-static int dev_read_pos_int(const char *patt, int mtd_num, int *value)
-{
-	char file[strlen(patt) + 50];
-
-	sprintf(file, patt, mtd_num);
-	return read_pos_int(file, value);
-}
-
-/**
- * dev_read_pos_ll - read a positive 'long long' value from an MTD device sysfs file.
- * @patt: file pattern to read from
- * @mtd_num: MTD device number
- * @value: the result is stored here
- *
- * This function returns %0 in case of success and %-1 in case of failure.
- */
-static int dev_read_pos_ll(const char *patt, int mtd_num, long long *value)
-{
-	char file[strlen(patt) + 50];
-
-	sprintf(file, patt, mtd_num);
-	return read_pos_ll(file, value);
-}
-
-/**
- * type_str2int - convert MTD device type to integer.
- * @str: MTD device type string to convert
- *
- * This function converts MTD device type string @str, read from sysfs, into an
- * integer.
- */
-static int type_str2int(const char *str)
-{
-	if (!strcmp(str, "nand"))
-		return MTD_NANDFLASH;
-	if (!strcmp(str, "mlc-nand"))
-		return MTD_MLCNANDFLASH;
-	if (!strcmp(str, "nor"))
-		return MTD_NORFLASH;
-	if (!strcmp(str, "rom"))
-		return MTD_ROM;
-	if (!strcmp(str, "absent"))
-		return MTD_ABSENT;
-	if (!strcmp(str, "dataflash"))
-		return MTD_DATAFLASH;
-	if (!strcmp(str, "ram"))
-		return MTD_RAM;
-	if (!strcmp(str, "ubi"))
-		return MTD_UBIVOLUME;
-	return -1;
-}
-
-/**
- * dev_node2num - find UBI device number by its character device node.
- * @lib: MTD library descriptor
- * @node: name of the MTD device node
- * @mtd_num: MTD device number is returned here
- *
- * This function returns %0 in case of success and %-1 in case of failure.
- */
-static int dev_node2num(struct libmtd *lib, const char *node, int *mtd_num)
-{
-	struct stat st;
-	int i, mjr, mnr;
-	struct mtd_info info;
-
-	if (stat(node, &st))
-		return sys_errmsg("cannot get information about \"%s\"", node);
-
-	if (!S_ISCHR(st.st_mode)) {
-		errmsg("\"%s\" is not a character device", node);
-		errno = EINVAL;
-		return -1;
-	}
-
-	mjr = major(st.st_rdev);
-	mnr = minor(st.st_rdev);
-
-	if (mtd_get_info((libmtd_t *)lib, &info))
-		return -1;
-
-	for (i = info.lowest_mtd_num; i <= info.highest_mtd_num; i++) {
-		int mjr1, mnr1, ret;
-
-		ret = dev_get_major(lib, i, &mjr1, &mnr1);
-		if (ret) {
-			if (errno == ENOENT)
-				continue;
-			if (!errno)
-				break;
-			return -1;
-		}
-
-		if (mjr1 == mjr && mnr1 == mnr) {
-			errno = 0;
-			*mtd_num = i;
-			return 0;
-		}
-	}
-
-	errno = ENODEV;
-	return -1;
-}
-
-/**
- * sysfs_is_supported - check whether the MTD sub-system supports MTD.
- * @lib: MTD library descriptor
- *
- * The Linux kernel MTD subsystem gained MTD support starting from kernel
- * 2.6.30 and libmtd tries to use sysfs interface if possible, because the NAND
- * sub-page size is available there (and not available at all in pre-sysfs
- * kernels).
- *
- * Very old kernels did not have "/sys/class/mtd" directory. Not very old
- * kernels (e.g., 2.6.29) did have "/sys/class/mtd/mtdX" directories, by there
- * were no files there, e.g., the "name" file was not present. So all we can do
- * is to check for a "/sys/class/mtd/mtdX/name" file. But this is not a
- * reliable check, because if this is a new system with no MTD devices - we'll
- * treat it as a pre-sysfs system.
- */
-static int sysfs_is_supported(struct libmtd *lib)
-{
-	int fd, num = -1;
-	DIR *sysfs_mtd;
-	char file[strlen(lib->mtd_name) + 10];
-
-	sysfs_mtd = opendir(lib->sysfs_mtd);
-	if (!sysfs_mtd) {
-		if (errno == ENOENT) {
-			errno = 0;
-			return 0;
-		}
-		return sys_errmsg("cannot open \"%s\"", lib->sysfs_mtd);
-	}
-
-	/*
-	 * First of all find an "mtdX" directory. This is needed because there
-	 * may be, for example, mtd1 but no mtd0.
-	 */
-	while (1) {
-		int ret, mtd_num;
-		char tmp_buf[256];
-		struct dirent *dirent;
-
-		dirent = readdir(sysfs_mtd);
-		if (!dirent)
-			break;
-
-		if (strlen(dirent->d_name) >= 255) {
-			errmsg("invalid entry in %s: \"%s\"",
-			       lib->sysfs_mtd, dirent->d_name);
-			errno = EINVAL;
-			closedir(sysfs_mtd);
-			return -1;
-		}
-
-		ret = sscanf(dirent->d_name, MTD_NAME_PATT"%s",
-			     &mtd_num, tmp_buf);
-		if (ret == 1) {
-			num = mtd_num;
-			break;
-		}
-	}
-
-	if (closedir(sysfs_mtd))
-		return sys_errmsg("closedir failed on \"%s\"", lib->sysfs_mtd);
-
-	if (num == -1)
-		/* No mtd device, treat this as pre-sysfs system */
-		return 0;
-
-	sprintf(file, lib->mtd_name, num);
-	fd = open(file, O_RDONLY | O_CLOEXEC);
-	if (fd == -1)
-		return 0;
-
-	if (close(fd)) {
-		sys_errmsg("close failed on \"%s\"", file);
-		return -1;
-	}
-
-	return 1;
-}
-
-libmtd_t libmtd_open(void)
-{
-	struct libmtd *lib;
-
-	lib = xzalloc(sizeof(*lib));
-
-	lib->offs64_ioctls = OFFS64_IOCTLS_UNKNOWN;
-
-	lib->sysfs_mtd = mkpath("/sys", SYSFS_MTD);
-	if (!lib->sysfs_mtd)
-		goto out_error;
-
-	lib->mtd = mkpath(lib->sysfs_mtd, MTD_NAME_PATT);
-	if (!lib->mtd)
-		goto out_error;
-
-	lib->mtd_name = mkpath(lib->mtd, MTD_NAME);
-	if (!lib->mtd_name)
-		goto out_error;
-
-	if (!sysfs_is_supported(lib)) {
-		free(lib->mtd);
-		free(lib->sysfs_mtd);
-		free(lib->mtd_name);
-		lib->mtd_name = lib->mtd = lib->sysfs_mtd = NULL;
-		return lib;
-	}
-
-	lib->mtd_dev = mkpath(lib->mtd, MTD_DEV);
-	if (!lib->mtd_dev)
-		goto out_error;
-
-	lib->mtd_type = mkpath(lib->mtd, MTD_TYPE);
-	if (!lib->mtd_type)
-		goto out_error;
-
-	lib->mtd_eb_size = mkpath(lib->mtd, MTD_EB_SIZE);
-	if (!lib->mtd_eb_size)
-		goto out_error;
-
-	lib->mtd_size = mkpath(lib->mtd, MTD_SIZE);
-	if (!lib->mtd_size)
-		goto out_error;
-
-	lib->mtd_min_io_size = mkpath(lib->mtd, MTD_MIN_IO_SIZE);
-	if (!lib->mtd_min_io_size)
-		goto out_error;
-
-	lib->mtd_subpage_size = mkpath(lib->mtd, MTD_SUBPAGE_SIZE);
-	if (!lib->mtd_subpage_size)
-		goto out_error;
-
-	lib->mtd_oob_size = mkpath(lib->mtd, MTD_OOB_SIZE);
-	if (!lib->mtd_oob_size)
-		goto out_error;
-
-	lib->mtd_region_cnt = mkpath(lib->mtd, MTD_REGION_CNT);
-	if (!lib->mtd_region_cnt)
-		goto out_error;
-
-	lib->mtd_flags = mkpath(lib->mtd, MTD_FLAGS);
-	if (!lib->mtd_flags)
-		goto out_error;
-
-	lib->sysfs_supported = 1;
-	return lib;
-
-out_error:
-	libmtd_close((libmtd_t)lib);
-	return NULL;
-}
-
-void libmtd_close(libmtd_t desc)
-{
-	struct libmtd *lib = (struct libmtd *)desc;
-
-	free(lib->mtd_flags);
-	free(lib->mtd_region_cnt);
-	free(lib->mtd_oob_size);
-	free(lib->mtd_subpage_size);
-	free(lib->mtd_min_io_size);
-	free(lib->mtd_size);
-	free(lib->mtd_eb_size);
-	free(lib->mtd_type);
-	free(lib->mtd_dev);
-	free(lib->mtd_name);
-	free(lib->mtd);
-	free(lib->sysfs_mtd);
-	free(lib);
-}
-
-int mtd_dev_present(libmtd_t desc, int mtd_num) {
-	struct stat st;
-	struct libmtd *lib = (struct libmtd *)desc;
-
-	if (!lib->sysfs_supported) {
-		return legacy_dev_present(mtd_num) == 1;
-	} else {
-		char file[strlen(lib->mtd) + 10];
-
-		sprintf(file, lib->mtd, mtd_num);
-		return !stat(file, &st);
-	}
-}
-
-int mtd_get_info(libmtd_t desc, struct mtd_info *info)
-{
-	DIR *sysfs_mtd;
-	struct dirent *dirent;
-	struct libmtd *lib = (struct libmtd *)desc;
-
-	memset(info, 0, sizeof(struct mtd_info));
-
-	if (!lib->sysfs_supported)
-		return legacy_mtd_get_info(info);
-
-	info->sysfs_supported = 1;
-
-	/*
-	 * We have to scan the MTD sysfs directory to identify how many MTD
-	 * devices are present.
-	 */
-	sysfs_mtd = opendir(lib->sysfs_mtd);
-	if (!sysfs_mtd) {
-		if (errno == ENOENT) {
-			errno = ENODEV;
-			return -1;
-		}
-		return sys_errmsg("cannot open \"%s\"", lib->sysfs_mtd);
-	}
-
-	info->lowest_mtd_num = INT_MAX;
-	while (1) {
-		int mtd_num, ret;
-		char tmp_buf[256];
-
-		errno = 0;
-		dirent = readdir(sysfs_mtd);
-		if (!dirent)
-			break;
-
-		if (strlen(dirent->d_name) >= 255) {
-			errmsg("invalid entry in %s: \"%s\"",
-			       lib->sysfs_mtd, dirent->d_name);
-			errno = EINVAL;
-			goto out_close;
-		}
-
-		ret = sscanf(dirent->d_name, MTD_NAME_PATT"%s",
-			     &mtd_num, tmp_buf);
-		if (ret == 1) {
-			info->mtd_dev_cnt += 1;
-			if (mtd_num > info->highest_mtd_num)
-				info->highest_mtd_num = mtd_num;
-			if (mtd_num < info->lowest_mtd_num)
-				info->lowest_mtd_num = mtd_num;
-		}
-	}
-
-	if (!dirent && errno) {
-		sys_errmsg("readdir failed on \"%s\"", lib->sysfs_mtd);
-		goto out_close;
-	}
-
-	if (closedir(sysfs_mtd))
-		return sys_errmsg("closedir failed on \"%s\"", lib->sysfs_mtd);
-
-	if (info->lowest_mtd_num == INT_MAX)
-		info->lowest_mtd_num = 0;
-
-	return 0;
-
-out_close:
-	closedir(sysfs_mtd);
-	return -1;
-}
-
-int mtd_get_dev_info1(libmtd_t desc, int mtd_num, struct mtd_dev_info *mtd)
-{
-	int ret;
-	struct libmtd *lib = (struct libmtd *)desc;
-
-	memset(mtd, 0, sizeof(struct mtd_dev_info));
-	mtd->mtd_num = mtd_num;
-
-	if (!mtd_dev_present(desc, mtd_num)) {
-		errno = ENODEV;
-		return -1;
-	} else if (!lib->sysfs_supported)
-		return legacy_get_dev_info1(mtd_num, mtd);
-
-	if (dev_get_major(lib, mtd_num, &mtd->major, &mtd->minor))
-		return -1;
-
-	ret = dev_read_data(lib->mtd_name, mtd_num, &mtd->name,
-			    MTD_NAME_MAX + 1);
-	if (ret < 0)
-		return -1;
-	((char *)mtd->name)[ret - 1] = '\0';
-
-	ret = dev_read_data(lib->mtd_type, mtd_num, &mtd->type_str,
-			    MTD_TYPE_MAX + 1);
-	if (ret < 0)
-		return -1;
-	((char *)mtd->type_str)[ret - 1] = '\0';
-
-	if (dev_read_pos_int(lib->mtd_eb_size, mtd_num, &mtd->eb_size))
-		return -1;
-	if (dev_read_pos_ll(lib->mtd_size, mtd_num, &mtd->size))
-		return -1;
-	if (dev_read_pos_int(lib->mtd_min_io_size, mtd_num, &mtd->min_io_size))
-		return -1;
-	if (dev_read_pos_int(lib->mtd_subpage_size, mtd_num, &mtd->subpage_size))
-		return -1;
-	if (dev_read_pos_int(lib->mtd_oob_size, mtd_num, &mtd->oob_size))
-		return -1;
-	if (dev_read_pos_int(lib->mtd_region_cnt, mtd_num, &mtd->region_cnt))
-		return -1;
-	if (dev_read_hex_int(lib->mtd_flags, mtd_num, &ret))
-		return -1;
-	mtd->writable = !!(ret & MTD_WRITEABLE);
-
-	mtd->eb_cnt = mtd->size / mtd->eb_size;
-	mtd->type = type_str2int(mtd->type_str);
-	mtd->bb_allowed = !!(mtd->type == MTD_NANDFLASH ||
-				mtd->type == MTD_MLCNANDFLASH);
-
-	return 0;
-}
-
-int mtd_get_dev_info(libmtd_t desc, const char *node, struct mtd_dev_info *mtd)
-{
-	int mtd_num;
-	struct libmtd *lib = (struct libmtd *)desc;
-
-	if (!lib->sysfs_supported)
-		return legacy_get_dev_info(node, mtd);
-
-	if (dev_node2num(lib, node, &mtd_num))
-		return -1;
-
-	return mtd_get_dev_info1(desc, mtd_num, mtd);
-}
-
-static inline int mtd_ioctl_error(const struct mtd_dev_info *mtd, int eb,
-				  const char *sreq)
-{
-	return sys_errmsg("%s ioctl failed for eraseblock %d (mtd%d)",
-			  sreq, eb, mtd->mtd_num);
-}
-
-static int mtd_valid_erase_block(const struct mtd_dev_info *mtd, int eb)
-{
-	if (eb < 0 || eb >= mtd->eb_cnt) {
-		errmsg("bad eraseblock number %d, mtd%d has %d eraseblocks",
-		       eb, mtd->mtd_num, mtd->eb_cnt);
-		errno = EINVAL;
-		return -1;
-	}
-	return 0;
-}
-
-static int mtd_xlock(const struct mtd_dev_info *mtd, int fd, int eb, int req,
-		     const char *sreq)
-{
-	int ret;
-	struct erase_info_user ei;
-
-	ret = mtd_valid_erase_block(mtd, eb);
-	if (ret)
-		return ret;
-
-	ei.start = eb * mtd->eb_size;
-	ei.length = mtd->eb_size;
-
-	ret = ioctl(fd, req, &ei);
-	if (ret < 0)
-		return mtd_ioctl_error(mtd, eb, sreq);
-
-	return 0;
-}
-#define mtd_xlock(mtd, fd, eb, req) mtd_xlock(mtd, fd, eb, req, #req)
-
-int mtd_lock(const struct mtd_dev_info *mtd, int fd, int eb)
-{
-	return mtd_xlock(mtd, fd, eb, MEMLOCK);
-}
-
-int mtd_unlock(const struct mtd_dev_info *mtd, int fd, int eb)
-{
-	return mtd_xlock(mtd, fd, eb, MEMUNLOCK);
-}
-
-int mtd_erase(libmtd_t desc, const struct mtd_dev_info *mtd, int fd, int eb)
-{
-	int ret;
-	struct libmtd *lib = (struct libmtd *)desc;
-	struct erase_info_user64 ei64;
-	struct erase_info_user ei;
-
-	ret = mtd_valid_erase_block(mtd, eb);
-	if (ret)
-		return ret;
-
-	ei64.start = (__u64)eb * mtd->eb_size;
-	ei64.length = mtd->eb_size;
-
-	if (lib->offs64_ioctls == OFFS64_IOCTLS_SUPPORTED ||
-	    lib->offs64_ioctls == OFFS64_IOCTLS_UNKNOWN) {
-		ret = ioctl(fd, MEMERASE64, &ei64);
-		if (ret == 0)
-			return ret;
-
-		if (errno != ENOTTY ||
-		    lib->offs64_ioctls != OFFS64_IOCTLS_UNKNOWN)
-			return mtd_ioctl_error(mtd, eb, "MEMERASE64");
-
-		/*
-		 * MEMERASE64 support was added in kernel version 2.6.31, so
-		 * probably we are working with older kernel and this ioctl is
-		 * not supported.
-		 */
-		lib->offs64_ioctls = OFFS64_IOCTLS_NOT_SUPPORTED;
-	}
-
-	if (ei64.start + ei64.length > 0xFFFFFFFF) {
-		errmsg("this system can address only %u eraseblocks",
-		       0xFFFFFFFFU / mtd->eb_size);
-		errno = EINVAL;
-		return -1;
-	}
-
-	ei.start = ei64.start;
-	ei.length = ei64.length;
-	ret = ioctl(fd, MEMERASE, &ei);
-	if (ret < 0)
-		return mtd_ioctl_error(mtd, eb, "MEMERASE");
-	return 0;
-}
-
-int mtd_regioninfo(int fd, int regidx, struct region_info_user *reginfo)
-{
-	int ret;
-
-	if (regidx < 0) {
-		errno = ENODEV;
-		return -1;
-	}
-
-	reginfo->regionindex = regidx;
-
-	ret = ioctl(fd, MEMGETREGIONINFO, reginfo);
-	if (ret < 0)
-		return sys_errmsg("%s ioctl failed for erase region %d",
-			"MEMGETREGIONINFO", regidx);
-
-	return 0;
-}
-
-int mtd_is_locked(const struct mtd_dev_info *mtd, int fd, int eb)
-{
-	int ret;
-	erase_info_t ei;
-
-	ei.start = eb * mtd->eb_size;
-	ei.length = mtd->eb_size;
-
-	ret = ioctl(fd, MEMISLOCKED, &ei);
-	if (ret < 0) {
-		if (errno != ENOTTY && errno != EOPNOTSUPP)
-			return mtd_ioctl_error(mtd, eb, "MEMISLOCKED");
-		else
-			errno = EOPNOTSUPP;
-	}
-
-	return ret;
-}
-
-/* Patterns to write to a physical eraseblock when torturing it */
-static uint8_t patterns[] = {0xa5, 0x5a, 0x0};
-
-/**
- * check_pattern - check if buffer contains only a certain byte pattern.
- * @buf: buffer to check
- * @patt: the pattern to check
- * @size: buffer size in bytes
- *
- * This function returns %1 in there are only @patt bytes in @buf, and %0 if
- * something else was also found.
- */
-static int check_pattern(const void *buf, uint8_t patt, int size)
-{
-	int i;
-
-	for (i = 0; i < size; i++)
-		if (((const uint8_t *)buf)[i] != patt)
-			return 0;
-	return 1;
-}
-
-int mtd_torture(libmtd_t desc, const struct mtd_dev_info *mtd, int fd, int eb)
-{
-	int err, i, patt_count;
-	void *buf;
-
-	normsg("run torture test for PEB %d", eb);
-	patt_count = ARRAY_SIZE(patterns);
-
-	buf = xmalloc(mtd->eb_size);
-
-	for (i = 0; i < patt_count; i++) {
-		err = mtd_erase(desc, mtd, fd, eb);
-		if (err)
-			goto out;
-
-		/* Make sure the PEB contains only 0xFF bytes */
-		err = mtd_read(mtd, fd, eb, 0, buf, mtd->eb_size);
-		if (err)
-			goto out;
-
-		err = check_pattern(buf, 0xFF, mtd->eb_size);
-		if (err == 0) {
-			errmsg("erased PEB %d, but a non-0xFF byte found", eb);
-			errno = EIO;
-			goto out;
-		}
-
-		/* Write a pattern and check it */
-		memset(buf, patterns[i], mtd->eb_size);
-		err = mtd_write(desc, mtd, fd, eb, 0, buf, mtd->eb_size, NULL,
-				0, 0);
-		if (err)
-			goto out;
-
-		memset(buf, ~patterns[i], mtd->eb_size);
-		err = mtd_read(mtd, fd, eb, 0, buf, mtd->eb_size);
-		if (err)
-			goto out;
-
-		err = check_pattern(buf, patterns[i], mtd->eb_size);
-		if (err == 0) {
-			errmsg("pattern %x checking failed for PEB %d",
-				patterns[i], eb);
-			errno = EIO;
-			goto out;
-		}
-	}
-
-	err = 0;
-	normsg("PEB %d passed torture test, do not mark it a bad", eb);
-
-out:
-	free(buf);
-	return -1;
-}
-
-int mtd_is_bad(const struct mtd_dev_info *mtd, int fd, int eb)
-{
-	int ret;
-	loff_t seek;
-
-	ret = mtd_valid_erase_block(mtd, eb);
-	if (ret)
-		return ret;
-
-	if (!mtd->bb_allowed)
-		return 0;
-
-	seek = (loff_t)eb * mtd->eb_size;
-	ret = ioctl(fd, MEMGETBADBLOCK, &seek);
-	if (ret == -1)
-		return mtd_ioctl_error(mtd, eb, "MEMGETBADBLOCK");
-	return ret;
-}
-
-int mtd_mark_bad(const struct mtd_dev_info *mtd, int fd, int eb)
-{
-	int ret;
-	loff_t seek;
-
-	if (!mtd->bb_allowed) {
-		errno = EINVAL;
-		return -1;
-	}
-
-	ret = mtd_valid_erase_block(mtd, eb);
-	if (ret)
-		return ret;
-
-	seek = (loff_t)eb * mtd->eb_size;
-	ret = ioctl(fd, MEMSETBADBLOCK, &seek);
-	if (ret == -1)
-		return mtd_ioctl_error(mtd, eb, "MEMSETBADBLOCK");
-	return 0;
-}
-
-int mtd_read(const struct mtd_dev_info *mtd, int fd, int eb, int offs,
-	     void *buf, int len)
-{
-	int ret, rd = 0;
-	off_t seek;
-
-	ret = mtd_valid_erase_block(mtd, eb);
-	if (ret)
-		return ret;
-
-	if (offs < 0 || offs + len > mtd->eb_size) {
-		errmsg("bad offset %d or length %d, mtd%d eraseblock size is %d",
-		       offs, len, mtd->mtd_num, mtd->eb_size);
-		errno = EINVAL;
-		return -1;
-	}
-
-	/* Seek to the beginning of the eraseblock */
-	seek = (off_t)eb * mtd->eb_size + offs;
-	if (lseek(fd, seek, SEEK_SET) != seek)
-		return sys_errmsg("cannot seek mtd%d to offset %"PRIdoff_t,
-				  mtd->mtd_num, seek);
-
-	while (rd < len) {
-		ret = read(fd, buf, len);
-		if (ret < 0)
-			return sys_errmsg("cannot read %d bytes from mtd%d (eraseblock %d, offset %d)",
-					  len, mtd->mtd_num, eb, offs);
-		rd += ret;
-	}
-
-	return 0;
-}
-
-static int legacy_auto_oob_layout(const struct mtd_dev_info *mtd, int fd,
-				  int ooblen, void *oob) {
-	struct nand_oobinfo old_oobinfo;
-	int start, len;
-	uint8_t *tmp_buf;
-
-	/* Read the current oob info */
-	if (ioctl(fd, MEMGETOOBSEL, &old_oobinfo))
-		return sys_errmsg("MEMGETOOBSEL failed");
-
-	tmp_buf = malloc(ooblen);
-	memcpy(tmp_buf, oob, ooblen);
-
-	/*
-	 * We use autoplacement and have the oobinfo with the autoplacement
-	 * information from the kernel available
-	 */
-	if (old_oobinfo.useecc == MTD_NANDECC_AUTOPLACE) {
-		int i, tags_pos = 0;
-		for (i = 0; old_oobinfo.oobfree[i][1]; i++) {
-			/* Set the reserved bytes to 0xff */
-			start = old_oobinfo.oobfree[i][0];
-			len = old_oobinfo.oobfree[i][1];
-			memcpy(oob + start, tmp_buf + tags_pos, len);
-			tags_pos += len;
-		}
-	} else {
-		/* Set at least the ecc byte positions to 0xff */
-		start = old_oobinfo.eccbytes;
-		len = mtd->oob_size - start;
-		memcpy(oob + start, tmp_buf + start, len);
-	}
-
-	return 0;
-}
-
-int mtd_write(libmtd_t desc, const struct mtd_dev_info *mtd, int fd, int eb,
-	      int offs, void *data, int len, void *oob, int ooblen,
-	      uint8_t mode)
-{
-	int ret;
-	off_t seek;
-	struct mtd_write_req ops;
-
-	ret = mtd_valid_erase_block(mtd, eb);
-	if (ret)
-		return ret;
-
-	if (offs < 0 || offs + len > mtd->eb_size) {
-		errmsg("bad offset %d or length %d, mtd%d eraseblock size is %d",
-		       offs, len, mtd->mtd_num, mtd->eb_size);
-		errno = EINVAL;
-		return -1;
-	}
-	if (offs % mtd->subpage_size) {
-		errmsg("write offset %d is not aligned to mtd%d min. I/O size %d",
-		       offs, mtd->mtd_num, mtd->subpage_size);
-		errno = EINVAL;
-		return -1;
-	}
-	if (len % mtd->subpage_size) {
-		errmsg("write length %d is not aligned to mtd%d min. I/O size %d",
-		       len, mtd->mtd_num, mtd->subpage_size);
-		errno = EINVAL;
-		return -1;
-	}
-
-	/* Calculate seek address */
-	seek = (off_t)eb * mtd->eb_size + offs;
-
-	if (oob) {
-		ops.start = seek;
-		ops.len = len;
-		ops.ooblen = ooblen;
-		ops.usr_data = (uint64_t)(unsigned long)data;
-		ops.usr_oob = (uint64_t)(unsigned long)oob;
-		ops.mode = mode;
-
-		ret = ioctl(fd, MEMWRITE, &ops);
-		if (ret == 0)
-			return 0;
-		else if (errno != ENOTTY && errno != EOPNOTSUPP)
-			return mtd_ioctl_error(mtd, eb, "MEMWRITE");
-
-		/* Fall back to old OOB ioctl() if necessary */
-		if (mode == MTD_OPS_AUTO_OOB)
-			if (legacy_auto_oob_layout(mtd, fd, ooblen, oob))
-				return -1;
-		if (mtd_write_oob(desc, mtd, fd, seek, ooblen, oob) < 0)
-			return sys_errmsg("cannot write to OOB");
-	}
-	if (data) {
-		/* Seek to the beginning of the eraseblock */
-		if (lseek(fd, seek, SEEK_SET) != seek)
-			return sys_errmsg("cannot seek mtd%d to offset %"PRIdoff_t,
-					mtd->mtd_num, seek);
-		ret = write(fd, data, len);
-		if (ret != len)
-			return sys_errmsg("cannot write %d bytes to mtd%d "
-					  "(eraseblock %d, offset %d)",
-					  len, mtd->mtd_num, eb, offs);
-	}
-
-	return 0;
-}
-
-int do_oob_op(libmtd_t desc, const struct mtd_dev_info *mtd, int fd,
-	      uint64_t start, uint64_t length, void *data, unsigned int cmd64,
-	      unsigned int cmd)
-{
-	int ret, oob_offs;
-	struct mtd_oob_buf64 oob64;
-	struct mtd_oob_buf oob;
-	unsigned long long max_offs;
-	const char *cmd64_str, *cmd_str;
-	struct libmtd *lib = (struct libmtd *)desc;
-
-	if (cmd64 ==  MEMREADOOB64) {
-		cmd64_str = "MEMREADOOB64";
-		cmd_str   = "MEMREADOOB";
-	} else {
-		cmd64_str = "MEMWRITEOOB64";
-		cmd_str   = "MEMWRITEOOB";
-	}
-
-	max_offs = (unsigned long long)mtd->eb_cnt * mtd->eb_size;
-	if (start >= max_offs) {
-		errmsg("bad page address %" PRIu64 ", mtd%d has %d eraseblocks (%llu bytes)",
-		       start, mtd->mtd_num, mtd->eb_cnt, max_offs);
-		errno = EINVAL;
-		return -1;
-	}
-
-	oob_offs = start & (mtd->min_io_size - 1);
-	if (oob_offs + length > mtd->oob_size || length == 0) {
-		errmsg("Cannot write %" PRIu64 " OOB bytes to address %" PRIu64 " (OOB offset %u) - mtd%d OOB size is only %d bytes",
-		       length, start, oob_offs, mtd->mtd_num,  mtd->oob_size);
-		errno = EINVAL;
-		return -1;
-	}
-
-	oob64.start = start;
-	oob64.length = length;
-	oob64.usr_ptr = (uint64_t)(unsigned long)data;
-
-	if (lib->offs64_ioctls == OFFS64_IOCTLS_SUPPORTED ||
-	    lib->offs64_ioctls == OFFS64_IOCTLS_UNKNOWN) {
-		ret = ioctl(fd, cmd64, &oob64);
-		if (ret == 0)
-			return ret;
-
-		if (errno != ENOTTY ||
-		    lib->offs64_ioctls != OFFS64_IOCTLS_UNKNOWN) {
-			sys_errmsg("%s ioctl failed for mtd%d, offset %" PRIu64 " (eraseblock %" PRIu64 ")",
-				   cmd64_str, mtd->mtd_num, start, start / mtd->eb_size);
-		}
-
-		/*
-		 * MEMREADOOB64/MEMWRITEOOB64 support was added in kernel
-		 * version 2.6.31, so probably we are working with older kernel
-		 * and these ioctls are not supported.
-		 */
-		lib->offs64_ioctls = OFFS64_IOCTLS_NOT_SUPPORTED;
-	}
-
-	if (oob64.start > 0xFFFFFFFFULL) {
-		errmsg("this system can address only up to address %lu",
-		       0xFFFFFFFFUL);
-		errno = EINVAL;
-		return -1;
-	}
-
-	oob.start = oob64.start;
-	oob.length = oob64.length;
-	oob.ptr = data;
-
-	ret = ioctl(fd, cmd, &oob);
-	if (ret < 0)
-		sys_errmsg("%s ioctl failed for mtd%d, offset %" PRIu64 " (eraseblock %" PRIu64 ")",
-			   cmd_str, mtd->mtd_num, start, start / mtd->eb_size);
-	return ret;
-}
-
-int mtd_read_oob(libmtd_t desc, const struct mtd_dev_info *mtd, int fd,
-		 uint64_t start, uint64_t length, void *data)
-{
-	return do_oob_op(desc, mtd, fd, start, length, data,
-			 MEMREADOOB64, MEMREADOOB);
-}
-
-int mtd_write_oob(libmtd_t desc, const struct mtd_dev_info *mtd, int fd,
-		  uint64_t start, uint64_t length, void *data)
-{
-	return do_oob_op(desc, mtd, fd, start, length, data,
-			 MEMWRITEOOB64, MEMWRITEOOB);
-}
-
-int mtd_write_img(const struct mtd_dev_info *mtd, int fd, int eb, int offs,
-		  const char *img_name)
-{
-	int tmp, ret, in_fd, len, written = 0;
-	off_t seek;
-	struct stat st;
-	char *buf;
-
-	ret = mtd_valid_erase_block(mtd, eb);
-	if (ret)
-		return ret;
-
-	if (offs < 0 || offs >= mtd->eb_size) {
-		errmsg("bad offset %d, mtd%d eraseblock size is %d",
-		       offs, mtd->mtd_num, mtd->eb_size);
-		errno = EINVAL;
-		return -1;
-	}
-	if (offs % mtd->subpage_size) {
-		errmsg("write offset %d is not aligned to mtd%d min. I/O size %d",
-		       offs, mtd->mtd_num, mtd->subpage_size);
-		errno = EINVAL;
-		return -1;
-	}
-
-	in_fd = open(img_name, O_RDONLY | O_CLOEXEC);
-	if (in_fd == -1)
-		return sys_errmsg("cannot open \"%s\"", img_name);
-
-	if (fstat(in_fd, &st)) {
-		sys_errmsg("cannot stat %s", img_name);
-		goto out_close;
-	}
-
-	len = st.st_size;
-	if (len % mtd->subpage_size) {
-		errmsg("size of \"%s\" is %d byte, which is not aligned to "
-		       "mtd%d min. I/O size %d", img_name, len, mtd->mtd_num,
-		       mtd->subpage_size);
-		errno = EINVAL;
-		goto out_close;
-	}
-	tmp = (offs + len + mtd->eb_size - 1) / mtd->eb_size;
-	if (eb + tmp > mtd->eb_cnt) {
-		errmsg("\"%s\" image size is %d bytes, mtd%d size is %d "
-		       "eraseblocks, the image does not fit if we write it "
-		       "starting from eraseblock %d, offset %d",
-		       img_name, len, mtd->mtd_num, mtd->eb_cnt, eb, offs);
-		errno = EINVAL;
-		goto out_close;
-	}
-
-	/* Seek to the beginning of the eraseblock */
-	seek = (off_t)eb * mtd->eb_size + offs;
-	if (lseek(fd, seek, SEEK_SET) != seek) {
-		sys_errmsg("cannot seek mtd%d to offset %"PRIdoff_t,
-			    mtd->mtd_num, seek);
-		goto out_close;
-	}
-
-	buf = xmalloc(mtd->eb_size);
-
-	while (written < len) {
-		int rd = 0;
-
-		do {
-			ret = read(in_fd, buf, mtd->eb_size - offs - rd);
-			if (ret == -1) {
-				sys_errmsg("cannot read \"%s\"", img_name);
-				goto out_free;
-			}
-			rd += ret;
-		} while (ret && rd < mtd->eb_size - offs);
-
-		ret = write(fd, buf, rd);
-		if (ret != rd) {
-			sys_errmsg("cannot write %d bytes to mtd%d (eraseblock %d, offset %d)",
-				   len, mtd->mtd_num, eb, offs);
-			goto out_free;
-		}
-
-		offs = 0;
-		eb += 1;
-		written += rd;
-	}
-
-	free(buf);
-	close(in_fd);
-	return 0;
-
-out_free:
-	free(buf);
-out_close:
-	close(in_fd);
-	return -1;
-}
-
-int mtd_probe_node(libmtd_t desc, const char *node)
-{
-	struct stat st;
-	struct mtd_info info;
-	int i, mjr, mnr;
-	struct libmtd *lib = (struct libmtd *)desc;
-
-	if (stat(node, &st))
-		return sys_errmsg("cannot get information about \"%s\"", node);
-
-	if (!S_ISCHR(st.st_mode)) {
-		errmsg("\"%s\" is not a character device", node);
-		errno = EINVAL;
-		return -1;
-	}
-
-	mjr = major(st.st_rdev);
-	mnr = minor(st.st_rdev);
-
-	if (mtd_get_info((libmtd_t *)lib, &info))
-		return -1;
-
-	if (!lib->sysfs_supported)
-		return 0;
-
-	for (i = info.lowest_mtd_num; i <= info.highest_mtd_num; i++) {
-		int mjr1, mnr1, ret;
-
-		ret = dev_get_major(lib, i, &mjr1, &mnr1);
-		if (ret) {
-			if (errno == ENOENT)
-				continue;
-			if (!errno)
-				break;
-			return -1;
-		}
-
-		if (mjr1 == mjr && mnr1 == mnr)
-			return 1;
-	}
-
-	errno = 0;
-	return -1;
-}
diff --git a/lib/libmtd.h b/lib/libmtd.h
deleted file mode 100644
index 3625de5..0000000
--- a/lib/libmtd.h
+++ /dev/null
@@ -1,354 +0,0 @@
-/*
- * Copyright (C) 2008, 2009 Nokia Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
- * the GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- * Author: Artem Bityutskiy
- *
- * MTD library.
- */
-
-/* Imported from mtd-utils by dehrenberg */
-
-#ifndef __LIBMTD_H__
-#define __LIBMTD_H__
-
-#ifdef __cplusplus
-extern "C" {
-#endif
-
-/* Maximum MTD device name length */
-#define MTD_NAME_MAX 127
-/* Maximum MTD device type string length */
-#define MTD_TYPE_MAX 64
-
-/* MTD library descriptor */
-typedef void * libmtd_t;
-
-/* Forward decls */
-struct region_info_user;
-
-/**
- * @mtd_dev_cnt: count of MTD devices in system
- * @lowest_mtd_num: lowest MTD device number in system
- * @highest_mtd_num: highest MTD device number in system
- * @sysfs_supported: non-zero if sysfs is supported by MTD
- */
-struct mtd_info
-{
-	int mtd_dev_cnt;
-	int lowest_mtd_num;
-	int highest_mtd_num;
-	unsigned int sysfs_supported:1;
-};
-
-/**
- * struct mtd_dev_info - information about an MTD device.
- * @mtd_num: MTD device number
- * @major: major number of corresponding character device
- * @minor: minor number of corresponding character device
- * @type: flash type (constants like %MTD_NANDFLASH defined in mtd-abi.h)
- * @type_str: static R/O flash type string
- * @name: device name
- * @size: device size in bytes
- * @eb_cnt: count of eraseblocks
- * @eb_size: eraseblock size
- * @min_io_size: minimum input/output unit size
- * @subpage_size: sub-page size
- * @oob_size: OOB size (zero if the device does not have OOB area)
- * @region_cnt: count of additional erase regions
- * @writable: zero if the device is read-only
- * @bb_allowed: non-zero if the MTD device may have bad eraseblocks
- */
-struct mtd_dev_info
-{
-	int mtd_num;
-	int major;
-	int minor;
-	int type;
-	char type_str[MTD_TYPE_MAX + 1];
-	char name[MTD_NAME_MAX + 1];
-	long long size;
-	int eb_cnt;
-	int eb_size;
-	int min_io_size;
-	int subpage_size;
-	int oob_size;
-	int region_cnt;
-	unsigned int writable:1;
-	unsigned int bb_allowed:1;
-};
-
-/**
- * libmtd_open - open MTD library.
- *
- * This function initializes and opens the MTD library and returns MTD library
- * descriptor in case of success and %NULL in case of failure. In case of
- * failure, errno contains zero if MTD is not present in the system, or
- * contains the error code if a real error happened.
- */
-libmtd_t libmtd_open(void);
-
-/**
- * libmtd_close - close MTD library.
- * @desc: MTD library descriptor
- */
-void libmtd_close(libmtd_t desc);
-
-/**
- * mtd_dev_present - check whether a MTD device is present.
- * @desc: MTD library descriptor
- * @mtd_num: MTD device number to check
- *
- * This function returns %1 if MTD device is present and %0 if not.
- */
-int mtd_dev_present(libmtd_t desc, int mtd_num);
-
-/**
- * mtd_get_info - get general MTD information.
- * @desc: MTD library descriptor
- * @info: the MTD device information is returned here
- *
- * This function fills the passed @info object with general MTD information and
- * returns %0 in case of success and %-1 in case of failure. If MTD subsystem is
- * not present in the system, errno is set to @ENODEV.
- */
-int mtd_get_info(libmtd_t desc, struct mtd_info *info);
-
-/**
- * mtd_get_dev_info - get information about an MTD device.
- * @desc: MTD library descriptor
- * @node: name of the MTD device node
- * @mtd: the MTD device information is returned here
- *
- * This function gets information about MTD device defined by the @node device
- * node file and saves this information in the @mtd object. Returns %0 in case
- * of success and %-1 in case of failure. If MTD subsystem is not present in the
- * system, or the MTD device does not exist, errno is set to @ENODEV.
- */
-int mtd_get_dev_info(libmtd_t desc, const char *node, struct mtd_dev_info *mtd);
-
-/**
- * mtd_get_dev_info1 - get information about an MTD device.
- * @desc: MTD library descriptor
- * @mtd_num: MTD device number to fetch information about
- * @mtd: the MTD device information is returned here
- *
- * This function is identical to 'mtd_get_dev_info()' except that it accepts
- * MTD device number, not MTD character device.
- */
-int mtd_get_dev_info1(libmtd_t desc, int mtd_num, struct mtd_dev_info *mtd);
-
-/**
- * mtd_lock - lock eraseblocks.
- * @desc: MTD library descriptor
- * @mtd: MTD device description object
- * @fd: MTD device node file descriptor
- * @eb: eraseblock to lock
- *
- * This function locks eraseblock @eb. Returns %0 in case of success and %-1
- * in case of failure.
- */
-int mtd_lock(const struct mtd_dev_info *mtd, int fd, int eb);
-
-/**
- * mtd_unlock - unlock eraseblocks.
- * @desc: MTD library descriptor
- * @mtd: MTD device description object
- * @fd: MTD device node file descriptor
- * @eb: eraseblock to lock
- *
- * This function unlocks eraseblock @eb. Returns %0 in case of success and %-1
- * in case of failure.
- */
-int mtd_unlock(const struct mtd_dev_info *mtd, int fd, int eb);
-
-/**
- * mtd_erase - erase an eraseblock.
- * @desc: MTD library descriptor
- * @mtd: MTD device description object
- * @fd: MTD device node file descriptor
- * @eb: eraseblock to erase
- *
- * This function erases eraseblock @eb of MTD device described by @fd. Returns
- * %0 in case of success and %-1 in case of failure.
- */
-int mtd_erase(libmtd_t desc, const struct mtd_dev_info *mtd, int fd, int eb);
-
-/**
- * mtd_regioninfo - get information about an erase region.
- * @fd: MTD device node file descriptor
- * @regidx: index of region to look up
- * @reginfo: the region information is returned here
- *
- * This function gets information about an erase region defined by the
- * @regidx index and saves this information in the @reginfo object.
- * Returns %0 in case of success and %-1 in case of failure. If the
- * @regidx is not valid or unavailable, errno is set to @ENODEV.
- */
-int mtd_regioninfo(int fd, int regidx, struct region_info_user *reginfo);
-
-/**
- * mtd_is_locked - see if the specified eraseblock is locked.
- * @mtd: MTD device description object
- * @fd: MTD device node file descriptor
- * @eb: eraseblock to check
- *
- * This function checks to see if eraseblock @eb of MTD device described
- * by @fd is locked. Returns %0 if it is unlocked, %1 if it is locked, and
- * %-1 in case of failure. If the ioctl is not supported (support was added in
- * Linux kernel 2.6.36) or this particular device does not support it, errno is
- * set to @ENOTSUPP.
- */
-int mtd_is_locked(const struct mtd_dev_info *mtd, int fd, int eb);
-
-/**
- * mtd_torture - torture an eraseblock.
- * @desc: MTD library descriptor
- * @mtd: MTD device description object
- * @fd: MTD device node file descriptor
- * @eb: eraseblock to torture
- *
- * This function tortures eraseblock @eb. Returns %0 in case of success and %-1
- * in case of failure.
- */
-int mtd_torture(libmtd_t desc, const struct mtd_dev_info *mtd, int fd, int eb);
-
-/**
- * mtd_is_bad - check if eraseblock is bad.
- * @mtd: MTD device description object
- * @fd: MTD device node file descriptor
- * @eb: eraseblock to check
- *
- * This function checks if eraseblock @eb is bad. Returns %0 if not, %1 if yes,
- * and %-1 in case of failure.
- */
-int mtd_is_bad(const struct mtd_dev_info *mtd, int fd, int eb);
-
-/**
- * mtd_mark_bad - mark an eraseblock as bad.
- * @mtd: MTD device description object
- * @fd: MTD device node file descriptor
- * @eb: eraseblock to mark as bad
- *
- * This function marks eraseblock @eb as bad. Returns %0 in case of success and
- * %-1 in case of failure.
- */
-int mtd_mark_bad(const struct mtd_dev_info *mtd, int fd, int eb);
-
-/**
- * mtd_read - read data from an MTD device.
- * @mtd: MTD device description object
- * @fd: MTD device node file descriptor
- * @eb: eraseblock to read from
- * @offs: offset withing the eraseblock to read from
- * @buf: buffer to read data to
- * @len: how many bytes to read
- *
- * This function reads @len bytes of data from eraseblock @eb and offset @offs
- * of the MTD device defined by @mtd and stores the read data at buffer @buf.
- * Returns %0 in case of success and %-1 in case of failure.
- */
-int mtd_read(const struct mtd_dev_info *mtd, int fd, int eb, int offs,
-	     void *buf, int len);
-
-/**
- * mtd_write - write data to an MTD device.
- * @desc: MTD library descriptor
- * @mtd: MTD device description object
- * @fd: MTD device node file descriptor
- * @eb: eraseblock to write to
- * @offs: offset withing the eraseblock to write to
- * @data: data buffer to write
- * @len: how many data bytes to write
- * @oob: OOB buffer to write
- * @ooblen: how many OOB bytes to write
- * @mode: write mode (e.g., %MTD_OOB_PLACE, %MTD_OOB_RAW)
- *
- * This function writes @len bytes of data to eraseblock @eb and offset @offs
- * of the MTD device defined by @mtd. Returns %0 in case of success and %-1 in
- * case of failure.
- *
- * Can only write to a single page at a time if writing to OOB.
- */
-int mtd_write(libmtd_t desc, const struct mtd_dev_info *mtd, int fd, int eb,
-	      int offs, void *data, int len, void *oob, int ooblen,
-	      uint8_t mode);
-
-/**
- * mtd_read_oob - read out-of-band area.
- * @desc: MTD library descriptor
- * @mtd: MTD device description object
- * @fd: MTD device node file descriptor
- * @start: page-aligned start address
- * @length: number of OOB bytes to read
- * @data: read buffer
- *
- * This function reads @length OOB bytes starting from address @start on
- * MTD device described by @fd. The address is specified as page byte offset
- * from the beginning of the MTD device. This function returns %0 in case of
- * success and %-1 in case of failure.
- */
-int mtd_read_oob(libmtd_t desc, const struct mtd_dev_info *mtd, int fd,
-		 uint64_t start, uint64_t length, void *data);
-
-/**
- * mtd_write_oob - write out-of-band area.
- * @desc: MTD library descriptor
- * @mtd: MTD device description object
- * @fd: MTD device node file descriptor
- * @start: page-aligned start address
- * @length: number of OOB bytes to write
- * @data: write buffer
- *
- * This function writes @length OOB bytes starting from address @start on
- * MTD device described by @fd. The address is specified as page byte offset
- * from the beginning of the MTD device. Returns %0 in case of success and %-1
- * in case of failure.
- */
-int mtd_write_oob(libmtd_t desc, const struct mtd_dev_info *mtd, int fd,
-		  uint64_t start, uint64_t length, void *data);
-
-/**
- * mtd_write_img - write a file to MTD device.
- * @mtd: MTD device description object
- * @fd: MTD device node file descriptor
- * @eb: eraseblock to write to
- * @offs: offset withing the eraseblock to write to
- * @img_name: the file to write
- *
- * This function writes an image @img_name the MTD device defined by @mtd. @eb
- * and @offs are the starting eraseblock and offset on the MTD device. Returns
- * %0 in case of success and %-1 in case of failure.
- */
-int mtd_write_img(const struct mtd_dev_info *mtd, int fd, int eb, int offs,
-		  const char *img_name);
-
-/**
- * mtd_probe_node - test MTD node.
- * @desc: MTD library descriptor
- * @node: the node to test
- *
- * This function tests whether @node is an MTD device node and returns %1 if it
- * is, and %-1 if it is not (errno is %ENODEV in this case) or if an error
- * occurred.
- */
-int mtd_probe_node(libmtd_t desc, const char *node);
-
-#ifdef __cplusplus
-}
-#endif
-
-#endif /* __LIBMTD_H__ */
diff --git a/lib/libmtd_common.h b/lib/libmtd_common.h
deleted file mode 100644
index a123323..0000000
--- a/lib/libmtd_common.h
+++ /dev/null
@@ -1,223 +0,0 @@
-/*
- * Copyright (c) Artem Bityutskiy, 2007, 2008
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
- * the GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-/* Imported from mtd-utils by dehrenberg */
-
-#ifndef __MTD_UTILS_COMMON_H__
-#define __MTD_UTILS_COMMON_H__
-
-#include <stdbool.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <ctype.h>
-#include <string.h>
-#include <fcntl.h>
-#include <errno.h>
-#include <features.h>
-#include <inttypes.h>
-
-#ifndef PROGRAM_NAME
-# error "You must define PROGRAM_NAME before including this header"
-#endif
-
-#ifdef __cplusplus
-extern "C" {
-#endif
-
-#ifndef MIN	/* some C lib headers define this for us */
-#define MIN(a, b) ((a) < (b) ? (a) : (b))
-#endif
-#ifndef MAX
-#define MAX(a, b) ((a) > (b) ? (a) : (b))
-#endif
-#define min(a, b) MIN(a, b) /* glue for linux kernel source */
-#define ARRAY_SIZE(a) (sizeof(a) / sizeof((a)[0]))
-
-#define ALIGN(x,a) __ALIGN_MASK(x,(typeof(x))(a)-1)
-#define __ALIGN_MASK(x,mask) (((x)+(mask))&~(mask))
-
-#define min_t(t,x,y) ({ \
-	typeof((x)) _x = (x); \
-	typeof((y)) _y = (y); \
-	(_x < _y) ? _x : _y; \
-})
-
-#define max_t(t,x,y) ({ \
-	typeof((x)) _x = (x); \
-	typeof((y)) _y = (y); \
-	(_x > _y) ? _x : _y; \
-})
-
-#ifndef O_CLOEXEC
-#define O_CLOEXEC 0
-#endif
-
-/* define a print format specifier for off_t */
-#ifdef __USE_FILE_OFFSET64
-#define PRIxoff_t PRIx64
-#define PRIdoff_t PRId64
-#else
-#define PRIxoff_t "l"PRIx32
-#define PRIdoff_t "l"PRId32
-#endif
-
-/* Verbose messages */
-#define bareverbose(verbose, fmt, ...) do {                        \
-	if (verbose)                                               \
-		printf(fmt, ##__VA_ARGS__);                        \
-} while(0)
-#define verbose(verbose, fmt, ...) \
-	bareverbose(verbose, "%s: " fmt "\n", PROGRAM_NAME, ##__VA_ARGS__)
-
-/* Normal messages */
-#define normsg_cont(fmt, ...) do {                                 \
-	printf("%s: " fmt, PROGRAM_NAME, ##__VA_ARGS__);           \
-} while(0)
-#define normsg(fmt, ...) do {                                      \
-	normsg_cont(fmt "\n", ##__VA_ARGS__);                      \
-} while(0)
-
-/* Error messages */
-#define errmsg(fmt, ...)  ({                                                \
-	fprintf(stderr, "%s: error!: " fmt "\n", PROGRAM_NAME, ##__VA_ARGS__); \
-	-1;                                                                 \
-})
-#define errmsg_die(fmt, ...) do {                                           \
-	exit(errmsg(fmt, ##__VA_ARGS__));                                   \
-} while(0)
-
-/* System error messages */
-#define sys_errmsg(fmt, ...)  ({                                            \
-	int _err = errno;                                                   \
-	errmsg(fmt, ##__VA_ARGS__);                                         \
-	fprintf(stderr, "%*serror %d (%s)\n", (int)sizeof(PROGRAM_NAME) + 1,\
-		"", _err, strerror(_err));                                  \
-	-1;                                                                 \
-})
-#define sys_errmsg_die(fmt, ...) do {                                       \
-	exit(sys_errmsg(fmt, ##__VA_ARGS__));                               \
-} while(0)
-
-/* Warnings */
-#define warnmsg(fmt, ...) do {                                                \
-	fprintf(stderr, "%s: warning!: " fmt "\n", PROGRAM_NAME, ##__VA_ARGS__); \
-} while(0)
-
-#if defined(__UCLIBC__)
-/* uClibc versions before 0.9.34 don't have rpmatch() */
-#if __UCLIBC_MAJOR__ == 0 && \
-		(__UCLIBC_MINOR__ < 9 || \
-		(__UCLIBC_MINOR__ == 9 && __UCLIBC_SUBLEVEL__ < 34))
-#undef rpmatch
-#define rpmatch __rpmatch
-static inline int __rpmatch(const char *resp)
-{
-    return (resp[0] == 'y' || resp[0] == 'Y') ? 1 :
-	(resp[0] == 'n' || resp[0] == 'N') ? 0 : -1;
-}
-#endif
-#endif
-
-/**
- * prompt the user for confirmation
- */
-static inline bool prompt(const char *msg, bool def)
-{
-	char *line = NULL;
-	size_t len;
-	bool ret = def;
-
-	do {
-		normsg_cont("%s (%c/%c) ", msg, def ? 'Y' : 'y', def ? 'n' : 'N');
-		fflush(stdout);
-
-		while (getline(&line, &len, stdin) == -1) {
-			printf("failed to read prompt; assuming '%s'\n",
-				def ? "yes" : "no");
-			break;
-		}
-
-		if (strcmp("\n", line) != 0) {
-			switch (rpmatch(line)) {
-			case 0: ret = false; break;
-			case 1: ret = true; break;
-			case -1:
-				puts("unknown response; please try again");
-				continue;
-			}
-		}
-		break;
-	} while (1);
-
-	free(line);
-
-	return ret;
-}
-
-static inline int is_power_of_2(unsigned long long n)
-{
-	return (n != 0 && ((n & (n - 1)) == 0));
-}
-
-/**
- * simple_strtoX - convert a hex/dec/oct string into a number
- * @snum: buffer to convert
- * @error: set to 1 when buffer isn't fully consumed
- *
- * These functions are similar to the standard strtoX() functions, but they are
- * a little bit easier to use if you want to convert full string of digits into
- * the binary form. The typical usage:
- *
- * int error = 0;
- * unsigned long num;
- *
- * num = simple_strtoul(str, &error);
- * if (error || ... if needed, your check that num is not out of range ...)
- * 	error_happened();
- */
-#define simple_strtoX(func, type) \
-static inline type simple_##func(const char *snum, int *error) \
-{ \
-	char *endptr; \
-	type ret = func(snum, &endptr, 0); \
- \
-	if (error && (!*snum || *endptr)) { \
-		errmsg("%s: unable to parse the number '%s'", #func, snum); \
-		*error = 1; \
-	} \
- \
-	return ret; \
-}
-simple_strtoX(strtol, long int)
-simple_strtoX(strtoll, long long int)
-simple_strtoX(strtoul, unsigned long int)
-simple_strtoX(strtoull, unsigned long long int)
-
-/* Simple version-printing for utils */
-#define common_print_version() \
-do { \
-	printf("%s %s\n", PROGRAM_NAME, VERSION); \
-} while (0)
-
-#include "libmtd_xalloc.h"
-
-#ifdef __cplusplus
-}
-#endif
-
-#endif /* !__MTD_UTILS_COMMON_H__ */
diff --git a/lib/libmtd_int.h b/lib/libmtd_int.h
deleted file mode 100644
index cbe2ff5..0000000
--- a/lib/libmtd_int.h
+++ /dev/null
@@ -1,109 +0,0 @@
-/*
- * Copyright (c) International Business Machines Corp., 2006
- * Copyright (C) 2009 Nokia Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
- * the GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- * Author: Artem Bityutskiy
- *
- * MTD library.
- */
-
-/* Imported from mtd-utils by dehrenberg */
-
-#ifndef __LIBMTD_INT_H__
-#define __LIBMTD_INT_H__
-
-#ifdef __cplusplus
-extern "C" {
-#endif
-
-#define PROGRAM_NAME "libmtd"
-
-#define SYSFS_MTD        "class/mtd"
-#define MTD_NAME_PATT    "mtd%d"
-#define MTD_DEV          "dev"
-#define MTD_NAME         "name"
-#define MTD_TYPE         "type"
-#define MTD_EB_SIZE      "erasesize"
-#define MTD_SIZE         "size"
-#define MTD_MIN_IO_SIZE  "writesize"
-#define MTD_SUBPAGE_SIZE "subpagesize"
-#define MTD_OOB_SIZE     "oobsize"
-#define MTD_REGION_CNT   "numeraseregions"
-#define MTD_FLAGS        "flags"
-
-#define OFFS64_IOCTLS_UNKNOWN       0
-#define OFFS64_IOCTLS_NOT_SUPPORTED 1
-#define OFFS64_IOCTLS_SUPPORTED     2
-
-/**
- * libmtd - MTD library description data structure.
- * @sysfs_mtd: MTD directory in sysfs
- * @mtd: MTD device sysfs directory pattern
- * @mtd_dev: MTD device major/minor numbers file pattern
- * @mtd_name: MTD device name file pattern
- * @mtd_type: MTD device type file pattern
- * @mtd_eb_size: MTD device eraseblock size file pattern
- * @mtd_size: MTD device size file pattern
- * @mtd_min_io_size: minimum I/O unit size file pattern
- * @mtd_subpage_size: sub-page size file pattern
- * @mtd_oob_size: MTD device OOB size file pattern
- * @mtd_region_cnt: count of additional erase regions file pattern
- * @mtd_flags: MTD device flags file pattern
- * @sysfs_supported: non-zero if sysfs is supported by MTD
- * @offs64_ioctls: %OFFS64_IOCTLS_SUPPORTED if 64-bit %MEMERASE64,
- *                 %MEMREADOOB64, %MEMWRITEOOB64 MTD device ioctls are
- *                 supported, %OFFS64_IOCTLS_NOT_SUPPORTED if not, and
- *                 %OFFS64_IOCTLS_UNKNOWN if it is not known yet;
- *
- *  Note, we cannot find out whether 64-bit ioctls are supported by MTD when we
- *  are initializing the library, because this requires an MTD device node.
- *  Indeed, we have to actually call the ioctl and check for %ENOTTY to find
- *  out whether it is supported or not.
- *
- *  Thus, we leave %offs64_ioctls uninitialized in 'libmtd_open()', and
- *  initialize it later, when corresponding libmtd function is used, and when
- *  we actually have a device node and can invoke an ioctl command on it.
- */
-struct libmtd
-{
-	char *sysfs_mtd;
-	char *mtd;
-	char *mtd_dev;
-	char *mtd_name;
-	char *mtd_type;
-	char *mtd_eb_size;
-	char *mtd_size;
-	char *mtd_min_io_size;
-	char *mtd_subpage_size;
-	char *mtd_oob_size;
-	char *mtd_region_cnt;
-	char *mtd_flags;
-	unsigned int sysfs_supported:1;
-	unsigned int offs64_ioctls:2;
-};
-
-int legacy_libmtd_open(void);
-int legacy_dev_present(int mtd_num);
-int legacy_mtd_get_info(struct mtd_info *info);
-int legacy_get_dev_info(const char *node, struct mtd_dev_info *mtd);
-int legacy_get_dev_info1(int dev_num, struct mtd_dev_info *mtd);
-
-#ifdef __cplusplus
-}
-#endif
-
-#endif /* !__LIBMTD_INT_H__ */
diff --git a/lib/libmtd_legacy.c b/lib/libmtd_legacy.c
deleted file mode 100644
index 38dc2b7..0000000
--- a/lib/libmtd_legacy.c
+++ /dev/null
@@ -1,384 +0,0 @@
-/*
- * Copyright (C) 2009 Nokia Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
- * the GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- * Author: Artem Bityutskiy
- *
- * This file  is part of the MTD library. Implements pre-2.6.30 kernels support,
- * where MTD did not have sysfs interface. The main limitation of the old
- * kernels was that the sub-page size was not exported to user-space, so it was
- * not possible to get sub-page size.
- */
-
-/* Imported from mtd-utils by dehrenberg */
-
-#include <limits.h>
-#include <fcntl.h>
-#include <unistd.h>
-#include <stdlib.h>
-#include <errno.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/ioctl.h>
-#include <mtd/mtd-user.h>
-
-#include "libmtd.h"
-#include "libmtd_int.h"
-#include "libmtd_common.h"
-
-#define MTD_PROC_FILE "/proc/mtd"
-#define MTD_DEV_PATT  "/dev/mtd%d"
-#define MTD_DEV_MAJOR 90
-
-#define PROC_MTD_FIRST     "dev:    size   erasesize  name\n"
-#define PROC_MTD_FIRST_LEN (sizeof(PROC_MTD_FIRST) - 1)
-#define PROC_MTD_MAX_LEN   4096
-#define PROC_MTD_PATT      "mtd%d: %llx %x"
-
-/**
- * struct proc_parse_info - /proc/mtd parsing information.
- * @mtd_num: MTD device number
- * @size: device size
- * @eb_size: eraseblock size
- * @name: device name
- * @buf: contents of /proc/mtd
- * @data_size: how much data was read into @buf
- * @pos: next string in @buf to parse
- */
-struct proc_parse_info
-{
-	int mtd_num;
-	long long size;
-	char name[MTD_NAME_MAX + 1];
-	int eb_size;
-	char *buf;
-	int data_size;
-	char *next;
-};
-
-static int proc_parse_start(struct proc_parse_info *pi)
-{
-	int fd, ret;
-
-	fd = open(MTD_PROC_FILE, O_RDONLY);
-	if (fd == -1)
-		return -1;
-
-	pi->buf = xmalloc(PROC_MTD_MAX_LEN);
-
-	ret = read(fd, pi->buf, PROC_MTD_MAX_LEN);
-	if (ret == -1) {
-		sys_errmsg("cannot read \"%s\"", MTD_PROC_FILE);
-		goto out_free;
-	}
-
-	if (ret < PROC_MTD_FIRST_LEN ||
-	    memcmp(pi->buf, PROC_MTD_FIRST, PROC_MTD_FIRST_LEN)) {
-		errmsg("\"%s\" does not start with \"%s\"", MTD_PROC_FILE,
-		       PROC_MTD_FIRST);
-		goto out_free;
-	}
-
-	pi->data_size = ret;
-	pi->next = pi->buf + PROC_MTD_FIRST_LEN;
-
-	close(fd);
-	return 0;
-
-out_free:
-	free(pi->buf);
-	close(fd);
-	return -1;
-}
-
-static int proc_parse_next(struct proc_parse_info *pi)
-{
-	int ret, len, pos = pi->next - pi->buf;
-	char *p, *p1;
-
-	if (pos >= pi->data_size) {
-		free(pi->buf);
-		return 0;
-	}
-
-	ret = sscanf(pi->next, PROC_MTD_PATT, &pi->mtd_num, &pi->size,
-		     &pi->eb_size);
-	if (ret != 3)
-		return errmsg("\"%s\" pattern not found", PROC_MTD_PATT);
-
-	p = memchr(pi->next, '\"', pi->data_size - pos);
-	if (!p)
-		return errmsg("opening \" not found");
-	p += 1;
-	pos = p - pi->buf;
-	if (pos >= pi->data_size)
-		return errmsg("opening \" not found");
-
-	p1 = memchr(p, '\"', pi->data_size - pos);
-	if (!p1)
-		return errmsg("closing \" not found");
-	pos = p1 - pi->buf;
-	if (pos >= pi->data_size)
-		return errmsg("closing \" not found");
-
-	len = p1 - p;
-	if (len > MTD_NAME_MAX)
-		return errmsg("too long mtd%d device name", pi->mtd_num);
-
-	memcpy(pi->name, p, len);
-	pi->name[len] = '\0';
-
-	if (p1[1] != '\n')
-		return errmsg("opening \"\n\" not found");
-	pi->next = p1 + 2;
-	return 1;
-}
-
-/**
- * legacy_libmtd_open - legacy version of 'libmtd_open()'.
- *
- * This function is just checks that MTD is present in the system. Returns
- * zero in case of success and %-1 in case of failure. In case of failure,
- * errno contains zero if MTD is not present in the system, or contains the
- * error code if a real error happened. This is similar to the 'libmtd_open()'
- * return conventions.
- */
-int legacy_libmtd_open(void)
-{
-	int fd;
-
-	fd = open(MTD_PROC_FILE, O_RDONLY);
-	if (fd == -1) {
-		if (errno == ENOENT)
-			errno = 0;
-		return -1;
-	}
-
-	close(fd);
-	return 0;
-}
-
-/**
- * legacy_dev_presentl - legacy version of 'mtd_dev_present()'.
- * @info: the MTD device information is returned here
- *
- * When the kernel does not provide sysfs files for the MTD subsystem,
- * fall-back to parsing the /proc/mtd file to determine whether an mtd device
- * number @mtd_num is present.
- */
-int legacy_dev_present(int mtd_num)
-{
-	int ret;
-	struct proc_parse_info pi;
-
-	ret = proc_parse_start(&pi);
-	if (ret)
-		return -1;
-
-	while (proc_parse_next(&pi)) {
-		if (pi.mtd_num == mtd_num)
-			return 1;
-	}
-
-	return 0;
-}
-
-/**
- * legacy_mtd_get_info - legacy version of 'mtd_get_info()'.
- * @info: the MTD device information is returned here
- *
- * This function is similar to 'mtd_get_info()' and has the same conventions.
- */
-int legacy_mtd_get_info(struct mtd_info *info)
-{
-	int ret;
-	struct proc_parse_info pi;
-
-	ret = proc_parse_start(&pi);
-	if (ret)
-		return -1;
-
-	info->lowest_mtd_num = INT_MAX;
-	while (proc_parse_next(&pi)) {
-		info->mtd_dev_cnt += 1;
-		if (pi.mtd_num > info->highest_mtd_num)
-			info->highest_mtd_num = pi.mtd_num;
-		if (pi.mtd_num < info->lowest_mtd_num)
-			info->lowest_mtd_num = pi.mtd_num;
-	}
-
-	return 0;
-}
-
-/**
- * legacy_get_dev_info - legacy version of 'mtd_get_dev_info()'.
- * @node: name of the MTD device node
- * @mtd: the MTD device information is returned here
- *
- * This function is similar to 'mtd_get_dev_info()' and has the same
- * conventions.
- */
-int legacy_get_dev_info(const char *node, struct mtd_dev_info *mtd)
-{
-	struct stat st;
-	struct mtd_info_user ui;
-	int fd, ret;
-	loff_t offs = 0;
-	struct proc_parse_info pi;
-
-	if (stat(node, &st)) {
-		sys_errmsg("cannot open \"%s\"", node);
-		if (errno == ENOENT)
-			normsg("MTD subsystem is old and does not support "
-			       "sysfs, so MTD character device nodes have "
-			       "to exist");
-	}
-
-	if (!S_ISCHR(st.st_mode)) {
-		errno = EINVAL;
-		return errmsg("\"%s\" is not a character device", node);
-	}
-
-	memset(mtd, '\0', sizeof(struct mtd_dev_info));
-	mtd->major = major(st.st_rdev);
-	mtd->minor = minor(st.st_rdev);
-
-	if (mtd->major != MTD_DEV_MAJOR) {
-		errno = EINVAL;
-		return errmsg("\"%s\" has major number %d, MTD devices have "
-			      "major %d", node, mtd->major, MTD_DEV_MAJOR);
-	}
-
-	mtd->mtd_num = mtd->minor / 2;
-
-	fd = open(node, O_RDONLY);
-	if (fd == -1)
-		return sys_errmsg("cannot open \"%s\"", node);
-
-	if (ioctl(fd, MEMGETINFO, &ui)) {
-		sys_errmsg("MEMGETINFO ioctl request failed");
-		goto out_close;
-	}
-
-	ret = ioctl(fd, MEMGETBADBLOCK, &offs);
-	if (ret == -1) {
-		if (errno != EOPNOTSUPP) {
-			sys_errmsg("MEMGETBADBLOCK ioctl failed");
-			goto out_close;
-		}
-		errno = 0;
-		mtd->bb_allowed = 0;
-	} else
-		mtd->bb_allowed = 1;
-
-	mtd->type = ui.type;
-	mtd->size = ui.size;
-	mtd->eb_size = ui.erasesize;
-	mtd->min_io_size = ui.writesize;
-	mtd->oob_size = ui.oobsize;
-
-	if (mtd->min_io_size <= 0) {
-		errmsg("mtd%d (%s) has insane min. I/O unit size %d",
-		       mtd->mtd_num, node, mtd->min_io_size);
-		goto out_close;
-	}
-	if (mtd->eb_size <= 0 || mtd->eb_size < mtd->min_io_size) {
-		errmsg("mtd%d (%s) has insane eraseblock size %d",
-		       mtd->mtd_num, node, mtd->eb_size);
-		goto out_close;
-	}
-	if (mtd->size <= 0 || mtd->size < mtd->eb_size) {
-		errmsg("mtd%d (%s) has insane size %lld",
-		       mtd->mtd_num, node, mtd->size);
-		goto out_close;
-	}
-	mtd->eb_cnt = mtd->size / mtd->eb_size;
-
-	switch(mtd->type) {
-	case MTD_ABSENT:
-		errmsg("mtd%d (%s) is removable and is not present",
-		       mtd->mtd_num, node);
-		goto out_close;
-	case MTD_RAM:
-		strcpy((char *)mtd->type_str, "ram");
-		break;
-	case MTD_ROM:
-		strcpy((char *)mtd->type_str, "rom");
-		break;
-	case MTD_NORFLASH:
-		strcpy((char *)mtd->type_str, "nor");
-		break;
-	case MTD_NANDFLASH:
-		strcpy((char *)mtd->type_str, "nand");
-		break;
-	case MTD_MLCNANDFLASH:
-		strcpy((char *)mtd->type_str, "mlc-nand");
-		break;
-	case MTD_DATAFLASH:
-		strcpy((char *)mtd->type_str, "dataflash");
-		break;
-	case MTD_UBIVOLUME:
-		strcpy((char *)mtd->type_str, "ubi");
-		break;
-	default:
-		goto out_close;
-	}
-
-	if (ui.flags & MTD_WRITEABLE)
-		mtd->writable = 1;
-	mtd->subpage_size = mtd->min_io_size;
-
-	close(fd);
-
-	/*
-	 * Unfortunately, the device name is not available via ioctl, and
-	 * we have to parse /proc/mtd to get it.
-	 */
-	ret = proc_parse_start(&pi);
-	if (ret)
-		return -1;
-
-	while (proc_parse_next(&pi)) {
-		if (pi.mtd_num == mtd->mtd_num) {
-			strcpy((char *)mtd->name, pi.name);
-			return 0;
-		}
-	}
-
-	errmsg("mtd%d not found in \"%s\"", mtd->mtd_num, MTD_PROC_FILE);
-	errno = ENOENT;
-	return -1;
-
-out_close:
-	close(fd);
-	return -1;
-}
-
-/**
- * legacy_get_dev_info1 - legacy version of 'mtd_get_dev_info1()'.
- * @node: name of the MTD device node
- * @mtd: the MTD device information is returned here
- *
- * This function is similar to 'mtd_get_dev_info1()' and has the same
- * conventions.
- */
-int legacy_get_dev_info1(int mtd_num, struct mtd_dev_info *mtd)
-{
-	char node[sizeof(MTD_DEV_PATT) + 20];
-
-	sprintf(node, MTD_DEV_PATT, mtd_num);
-	return legacy_get_dev_info(node, mtd);
-}
diff --git a/lib/libmtd_xalloc.h b/lib/libmtd_xalloc.h
deleted file mode 100644
index 532b80f..0000000
--- a/lib/libmtd_xalloc.h
+++ /dev/null
@@ -1,106 +0,0 @@
-/*
- * memory wrappers
- *
- * Copyright (c) Artem Bityutskiy, 2007, 2008
- * Copyright 2001, 2002 Red Hat, Inc.
- *           2001 David A. Schleef <ds@lineo.com>
- *           2002 Axis Communications AB
- *           2001, 2002 Erik Andersen <andersen@codepoet.org>
- *           2004 University of Szeged, Hungary
- *           2006 KaiGai Kohei <kaigai@ak.jp.nec.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
- * the GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#ifndef __MTD_UTILS_XALLOC_H__
-#define __MTD_UTILS_XALLOC_H__
-
-#include <stdarg.h>
-#include <stdlib.h>
-#include <string.h>
-
-/*
- * Mark these functions as unused so that gcc does not emit warnings
- * when people include this header but don't use every function.
- */
-
-__attribute__((unused))
-static void *xmalloc(size_t size)
-{
-	void *ptr = malloc(size);
-
-	if (ptr == NULL && size != 0)
-		sys_errmsg_die("out of memory");
-	return ptr;
-}
-
-__attribute__((unused))
-static void *xcalloc(size_t nmemb, size_t size)
-{
-	void *ptr = calloc(nmemb, size);
-
-	if (ptr == NULL && nmemb != 0 && size != 0)
-		sys_errmsg_die("out of memory");
-	return ptr;
-}
-
-__attribute__((unused))
-static void *xzalloc(size_t size)
-{
-	return xcalloc(1, size);
-}
-
-__attribute__((unused))
-static void *xrealloc(void *ptr, size_t size)
-{
-	ptr = realloc(ptr, size);
-	if (ptr == NULL && size != 0)
-		sys_errmsg_die("out of memory");
-	return ptr;
-}
-
-__attribute__((unused))
-static char *xstrdup(const char *s)
-{
-	char *t;
-
-	if (s == NULL)
-		return NULL;
-	t = strdup(s);
-	if (t == NULL)
-		sys_errmsg_die("out of memory");
-	return t;
-}
-
-#ifdef _GNU_SOURCE
-
-__attribute__((unused))
-static int xasprintf(char **strp, const char *fmt, ...)
-{
-	int cnt;
-	va_list ap;
-
-	va_start(ap, fmt);
-	cnt = vasprintf(strp, fmt, ap);
-	va_end(ap);
-
-	if (cnt == -1)
-		sys_errmsg_die("out of memory");
-
-	return cnt;
-}
-#endif
-
-#endif /* !__MTD_UTILS_XALLOC_H__ */
diff --git a/lib/linux-dev-lookup.c b/lib/linux-dev-lookup.c
deleted file mode 100644
index 4d5f356..0000000
--- a/lib/linux-dev-lookup.c
+++ /dev/null
@@ -1,66 +0,0 @@
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <dirent.h>
-#include <string.h>
-#include <stdio.h>
-#include <unistd.h>
-
-#include "../os/os.h"
-
-int blktrace_lookup_device(const char *redirect, char *path, unsigned int maj,
-			   unsigned int min)
-{
-	struct dirent *dir;
-	struct stat st;
-	int found = 0;
-	DIR *D;
-
-	D = opendir(path);
-	if (!D)
-		return 0;
-
-	while ((dir = readdir(D)) != NULL) {
-		char full_path[256];
-
-		if (!strcmp(dir->d_name, ".") || !strcmp(dir->d_name, ".."))
-			continue;
-
-		sprintf(full_path, "%s%s%s", path, FIO_OS_PATH_SEPARATOR, dir->d_name);
-		if (lstat(full_path, &st) == -1) {
-			perror("lstat");
-			break;
-		}
-
-		if (S_ISDIR(st.st_mode)) {
-			found = blktrace_lookup_device(redirect, full_path,
-								maj, min);
-			if (found) {
-				strcpy(path, full_path);
-				break;
-			}
-		}
-
-		if (!S_ISBLK(st.st_mode))
-			continue;
-
-		/*
-		 * If replay_redirect is set then always return this device
-		 * upon lookup which overrides the device lookup based on
-		 * major minor in the actual blktrace
-		 */
-		if (redirect) {
-			strcpy(path, redirect);
-			found = 1;
-			break;
-		}
-
-		if (maj == major(st.st_rdev) && min == minor(st.st_rdev)) {
-			strcpy(path, full_path);
-			found = 1;
-			break;
-		}
-	}
-
-	closedir(D);
-	return found;
-}
diff --git a/lib/linux-dev-lookup.h b/lib/linux-dev-lookup.h
deleted file mode 100644
index 144f33a..0000000
--- a/lib/linux-dev-lookup.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef LINUX_DEV_LOOKUP
-#define LINUX_DEV_LOOKUP
-
-int blktrace_lookup_device(const char *redirect, char *path, unsigned int maj,
-			   unsigned int min);
-
-#endif
diff --git a/lib/memalign.c b/lib/memalign.c
new file mode 100644
index 0000000..cfd6e46
--- /dev/null
+++ b/lib/memalign.c
@@ -0,0 +1,36 @@
+#include <stdlib.h>
+#include <assert.h>
+#include <inttypes.h>
+
+#include "memalign.h"
+
+struct align_footer {
+	unsigned int offset;
+};
+
+#define PTR_ALIGN(ptr, mask)	\
+	(char *) (((uintptr_t) ((ptr) + (mask)) & ~(mask)))
+
+void *fio_memalign(size_t alignment, size_t size)
+{
+	struct align_footer *f;
+	void *ptr, *ret = NULL;
+
+	assert(!(alignment & (alignment - 1)));
+
+	ptr = malloc(size + alignment + size + sizeof(*f) - 1);
+	if (ptr) {
+		ret = PTR_ALIGN(ptr, alignment - 1);
+		f = ret + size;
+		f->offset = (uintptr_t) ret - (uintptr_t) ptr;
+	}
+
+	return ret;
+}
+
+void fio_memfree(void *ptr, size_t size)
+{
+	struct align_footer *f = ptr + size;
+
+	free(ptr - f->offset);
+}
diff --git a/lib/memalign.h b/lib/memalign.h
new file mode 100644
index 0000000..df412e2
--- /dev/null
+++ b/lib/memalign.h
@@ -0,0 +1,7 @@
+#ifndef FIO_MEMALIGN_H
+#define FIO_MEMALIGN_H
+
+extern void *fio_memalign(size_t alignment, size_t size);
+extern void fio_memfree(void *ptr, size_t size);
+
+#endif
diff --git a/lib/strcasestr.c b/lib/strcasestr.c
deleted file mode 100644
index 92cf24c..0000000
--- a/lib/strcasestr.c
+++ /dev/null
@@ -1,25 +0,0 @@
-#include <ctype.h>
-#include <stddef.h>
-
-char *strcasestr(const char *s1, const char *s2)
-{
-	const char *s = s1;
-	const char *p = s2;
-
-	do {
-		if (!*p)
-			return (char *) s1;
-		if ((*p == *s) ||
-		    (tolower(*p) == tolower(*s))) {
-			++p;
-			++s;
-		} else {
-			p = s2;
-			if (!*s)
-				return NULL;
-			s = ++s1;
-		}
-	} while (1);
-
-	return *p ? NULL : (char *) s1;
-}
diff --git a/lib/strcasestr.h b/lib/strcasestr.h
deleted file mode 100644
index 43d61df..0000000
--- a/lib/strcasestr.h
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifdef CONFIG_STRCASESTR
-
-#include <string.h>
-
-#else
-
-#ifndef FIO_STRCASESTR_H
-#define FIO_STRCASESTR_H
-
-char *strcasestr(const char *haystack, const char *needle);
-
-#endif
-#endif
diff --git a/lib/strlcat.c b/lib/strlcat.c
deleted file mode 100644
index 643d496..0000000
--- a/lib/strlcat.c
+++ /dev/null
@@ -1,23 +0,0 @@
-#include <string.h>
-
-size_t strlcat(char *dst, const char *src, size_t size)
-{
-	size_t dstlen;
-	size_t srclen;
-
-	dstlen = strlen(dst);
-	size -= dstlen + 1;
-
-	/* return if no room */
-	if (!size)
-		return dstlen;
-
-	srclen = strlen(src);
-	if (srclen > size)
-		srclen = size;
-
-	memcpy(dst + dstlen, src, srclen);
-	dst[dstlen + srclen] = '\0';
-
-	return dstlen + srclen;
-}
diff --git a/lib/strlcat.h b/lib/strlcat.h
deleted file mode 100644
index baeace4..0000000
--- a/lib/strlcat.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef FIO_STRLCAT_H
-#define FIO_STRLCAT_H
-
-size_t strlcat(char *dst, const char *src, size_t size);
-
-#endif
diff --git a/lib/strsep.c b/lib/strsep.c
deleted file mode 100644
index b71e9f7..0000000
--- a/lib/strsep.c
+++ /dev/null
@@ -1,29 +0,0 @@
-#include <stdio.h>
-
-char *strsep(char **stringp, const char *delim)
-{
-	char *s, *tok;
-	const char *spanp;
-	int c, sc;
-
-	s = *stringp;
-	if (!s)
-		return NULL;
-
-	tok = s;
-	do {
-		c = *s++;
-		spanp = delim;
-		do {
-			sc = *spanp++;
-			if (sc == c) {
-				if (c == 0)
-					s = NULL;
-				else
-					s[-1] = 0;
-				*stringp = s;
-				return tok;
-			}
-		} while (sc != 0);
-	} while (1);
-}
diff --git a/lib/strsep.h b/lib/strsep.h
deleted file mode 100644
index 5fea5d1..0000000
--- a/lib/strsep.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef FIO_STRSEP_LIB_H
-#define FIO_STRSEP_LIB_H
-
-char *strsep(char **, const char *);
-
-#endif
diff --git a/libfio.c b/libfio.c
index 3aa52e0..6c74852 100644
--- a/libfio.c
+++ b/libfio.c
@@ -148,6 +148,7 @@ void reset_all_stats(struct thread_data *td)
 	memcpy(&td->start, &tv, sizeof(tv));
 
 	lat_target_reset(td);
+	clear_rusage_stat(td);
 }
 
 void reset_fio_state(void)
diff --git a/memalign.c b/memalign.c
deleted file mode 100644
index cfd6e46..0000000
--- a/memalign.c
+++ /dev/null
@@ -1,36 +0,0 @@
-#include <stdlib.h>
-#include <assert.h>
-#include <inttypes.h>
-
-#include "memalign.h"
-
-struct align_footer {
-	unsigned int offset;
-};
-
-#define PTR_ALIGN(ptr, mask)	\
-	(char *) (((uintptr_t) ((ptr) + (mask)) & ~(mask)))
-
-void *fio_memalign(size_t alignment, size_t size)
-{
-	struct align_footer *f;
-	void *ptr, *ret = NULL;
-
-	assert(!(alignment & (alignment - 1)));
-
-	ptr = malloc(size + alignment + size + sizeof(*f) - 1);
-	if (ptr) {
-		ret = PTR_ALIGN(ptr, alignment - 1);
-		f = ret + size;
-		f->offset = (uintptr_t) ret - (uintptr_t) ptr;
-	}
-
-	return ret;
-}
-
-void fio_memfree(void *ptr, size_t size)
-{
-	struct align_footer *f = ptr + size;
-
-	free(ptr - f->offset);
-}
diff --git a/memalign.h b/memalign.h
deleted file mode 100644
index df412e2..0000000
--- a/memalign.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef FIO_MEMALIGN_H
-#define FIO_MEMALIGN_H
-
-extern void *fio_memalign(size_t alignment, size_t size);
-extern void fio_memfree(void *ptr, size_t size);
-
-#endif
diff --git a/os/os-windows.h b/os/os-windows.h
index ad1c3df..159c086 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -16,7 +16,7 @@
 #include "../file.h"
 #include "../log.h"
 #include "../lib/hweight.h"
-#include "../lib/strcasestr.h"
+#include "../oslib/strcasestr.h"
 
 #include "windows/posix.h"
 
diff --git a/os/os.h b/os/os.h
index 8e0b8e8..c46d8a3 100644
--- a/os/os.h
+++ b/os/os.h
@@ -65,11 +65,11 @@ typedef struct aiocb os_aiocb_t;
 #endif
 
 #ifndef CONFIG_STRSEP
-#include "../lib/strsep.h"
+#include "../oslib/strsep.h"
 #endif
 
 #ifndef CONFIG_STRLCAT
-#include "../lib/strlcat.h"
+#include "../oslib/strlcat.h"
 #endif
 
 #ifdef MSG_DONTWAIT
diff --git a/oslib/getopt_long.c b/oslib/getopt_long.c
new file mode 100644
index 0000000..11d879a
--- /dev/null
+++ b/oslib/getopt_long.c
@@ -0,0 +1,167 @@
+/*
+ * getopt.c
+ *
+ * getopt_long(), or at least a common subset thereof:
+ *
+ * - Option reordering is not supported
+ * - -W foo is not supported
+ * - First optstring character "-" not supported.
+ *
+ * This file was imported from the klibc library from hpa
+ */
+
+#include <stdint.h>
+#include <unistd.h>
+#include <string.h>
+
+#include "getopt.h"
+
+char *optarg = NULL;
+int optind = 0, opterr = 0, optopt = 0;
+
+static struct getopt_private_state {
+	const char *optptr;
+	const char *last_optstring;
+	char *const *last_argv;
+} pvt;
+
+static inline const char *option_matches(const char *arg_str,
+					 const char *opt_name)
+{
+	while (*arg_str != '\0' && *arg_str != '=') {
+		if (*arg_str++ != *opt_name++)
+			return NULL;
+	}
+
+	if (*opt_name)
+		return NULL;
+
+	return arg_str;
+}
+
+int getopt_long_only(int argc, char *const *argv, const char *optstring,
+		const struct option *longopts, int *longindex)
+{
+	const char *carg;
+	const char *osptr;
+	int opt;
+
+	optarg = NULL;
+
+	/* getopt() relies on a number of different global state
+	   variables, which can make this really confusing if there is
+	   more than one use of getopt() in the same program.  This
+	   attempts to detect that situation by detecting if the
+	   "optstring" or "argv" argument have changed since last time
+	   we were called; if so, reinitialize the query state. */
+
+	if (optstring != pvt.last_optstring || argv != pvt.last_argv ||
+	    optind < 1 || optind > argc) {
+		/* optind doesn't match the current query */
+		pvt.last_optstring = optstring;
+		pvt.last_argv = argv;
+		optind = 1;
+		pvt.optptr = NULL;
+	}
+
+	carg = argv[optind];
+
+	/* First, eliminate all non-option cases */
+
+	if (!carg || carg[0] != '-' || !carg[1])
+		return -1;
+
+	if (carg[1] == '-') {
+		const struct option *lo;
+		const char *opt_end = NULL;
+
+		optind++;
+
+		/* Either it's a long option, or it's -- */
+		if (!carg[2]) {
+			/* It's -- */
+			return -1;
+		}
+
+		for (lo = longopts; lo->name; lo++) {
+			if ((opt_end = option_matches(carg+2, lo->name)))
+			    break;
+		}
+		if (!opt_end)
+			return '?';
+
+		if (longindex)
+			*longindex = lo-longopts;
+
+		if (*opt_end == '=') {
+			if (lo->has_arg)
+				optarg = (char *)opt_end+1;
+			else
+				return '?';
+		} else if (lo->has_arg == 1) {
+			if (!(optarg = argv[optind]))
+				return '?';
+			optind++;
+		}
+
+		if (lo->flag) {
+			*lo->flag = lo->val;
+			return 0;
+		} else {
+			return lo->val;
+		}
+	}
+
+	if ((uintptr_t) (pvt.optptr - carg) > (uintptr_t) strlen(carg)) {
+		/* Someone frobbed optind, change to new opt. */
+		pvt.optptr = carg + 1;
+	}
+
+	opt = *pvt.optptr++;
+
+	if (opt != ':' && (osptr = strchr(optstring, opt))) {
+		if (osptr[1] == ':') {
+			if (*pvt.optptr) {
+				/* Argument-taking option with attached
+				   argument */
+				optarg = (char *)pvt.optptr;
+				optind++;
+			} else {
+				/* Argument-taking option with non-attached
+				   argument */
+				if (osptr[2] == ':') {
+					if (argv[optind + 1]) {
+						optarg = (char *)argv[optind+1];
+						optind += 2;
+					} else {
+						optarg = NULL;
+						optind++;
+					}
+					return opt;
+				} else if (argv[optind + 1]) {
+					optarg = (char *)argv[optind+1];
+					optind += 2;
+				} else {
+					/* Missing argument */
+					optind++;
+					return (optstring[0] == ':')
+						? ':' : '?';
+				}
+			}
+			return opt;
+		} else {
+			/* Non-argument-taking option */
+			/* pvt.optptr will remember the exact position to
+			   resume at */
+			if (!*pvt.optptr)
+				optind++;
+			return opt;
+		}
+	} else {
+		/* Unknown option */
+		optopt = opt;
+		if (!*pvt.optptr)
+			optind++;
+		return '?';
+	}
+}
diff --git a/oslib/inet_aton.c b/oslib/inet_aton.c
new file mode 100644
index 0000000..7ae7db7
--- /dev/null
+++ b/oslib/inet_aton.c
@@ -0,0 +1,6 @@
+#include "inet_aton.h"
+
+int inet_aton(const char *cp, struct in_addr *inp)
+{
+	return inet_pton(AF_INET, cp, inp);
+}
diff --git a/oslib/inet_aton.h b/oslib/inet_aton.h
new file mode 100644
index 0000000..c93c87f
--- /dev/null
+++ b/oslib/inet_aton.h
@@ -0,0 +1,8 @@
+#ifndef FIO_INET_ATON_LIB_H
+#define FIO_INET_ATON_LIB_H
+
+#include <arpa/inet.h>
+
+int inet_aton(const char *cp, struct in_addr *inp);
+
+#endif
diff --git a/oslib/libmtd.c b/oslib/libmtd.c
new file mode 100644
index 0000000..5c9eac2
--- /dev/null
+++ b/oslib/libmtd.c
@@ -0,0 +1,1424 @@
+/*
+ * Copyright (c) International Business Machines Corp., 2006
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * Author: Artem Bityutskiy
+ *
+ * MTD library.
+ */
+
+/* Imported from mtd-utils by dehrenberg */
+
+#include <limits.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <errno.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <dirent.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <inttypes.h>
+
+#include <mtd/mtd-user.h>
+#include "libmtd.h"
+
+#include "libmtd_int.h"
+#include "libmtd_common.h"
+
+/**
+ * mkpath - compose full path from 2 given components.
+ * @path: the first component
+ * @name: the second component
+ *
+ * This function returns the resulting path in case of success and %NULL in
+ * case of failure.
+ */
+static char *mkpath(const char *path, const char *name)
+{
+	char *n;
+	size_t len1 = strlen(path);
+	size_t len2 = strlen(name);
+
+	n = xmalloc(len1 + len2 + 6);
+
+	memcpy(n, path, len1);
+	if (n[len1 - 1] != '/')
+		n[len1++] = '/';
+
+	memcpy(n + len1, name, len2 + 1);
+	return n;
+}
+
+/**
+ * read_data - read data from a file.
+ * @file: the file to read from
+ * @buf: the buffer to read to
+ * @buf_len: buffer length
+ *
+ * This function returns number of read bytes in case of success and %-1 in
+ * case of failure. Note, if the file contains more then @buf_len bytes of
+ * date, this function fails with %EINVAL error code.
+ */
+static int read_data(const char *file, void *buf, int buf_len)
+{
+	int fd, rd, tmp, tmp1;
+
+	fd = open(file, O_RDONLY | O_CLOEXEC);
+	if (fd == -1)
+		return -1;
+
+	rd = read(fd, buf, buf_len);
+	if (rd == -1) {
+		sys_errmsg("cannot read \"%s\"", file);
+		goto out_error;
+	}
+
+	if (rd == buf_len) {
+		errmsg("contents of \"%s\" is too long", file);
+		errno = EINVAL;
+		goto out_error;
+	}
+
+	((char *)buf)[rd] = '\0';
+
+	/* Make sure all data is read */
+	tmp1 = read(fd, &tmp, 1);
+	if (tmp1 == 1) {
+		sys_errmsg("cannot read \"%s\"", file);
+		goto out_error;
+	}
+	if (tmp1) {
+		errmsg("file \"%s\" contains too much data (> %d bytes)",
+		       file, buf_len);
+		errno = EINVAL;
+		goto out_error;
+	}
+
+	if (close(fd)) {
+		sys_errmsg("close failed on \"%s\"", file);
+		return -1;
+	}
+
+	return rd;
+
+out_error:
+	close(fd);
+	return -1;
+}
+
+/**
+ * read_major - read major and minor numbers from a file.
+ * @file: name of the file to read from
+ * @major: major number is returned here
+ * @minor: minor number is returned here
+ *
+ * This function returns % in case of success, and %-1 in case of failure.
+ */
+static int read_major(const char *file, int *major, int *minor)
+{
+	int ret;
+	char buf[50];
+
+	ret = read_data(file, buf, 50);
+	if (ret < 0)
+		return ret;
+
+	ret = sscanf(buf, "%d:%d\n", major, minor);
+	if (ret != 2) {
+		errno = EINVAL;
+		return errmsg("\"%s\" does not have major:minor format", file);
+	}
+
+	if (*major < 0 || *minor < 0) {
+		errno = EINVAL;
+		return errmsg("bad major:minor %d:%d in \"%s\"",
+			      *major, *minor, file);
+	}
+
+	return 0;
+}
+
+/**
+ * dev_get_major - get major and minor numbers of an MTD device.
+ * @lib: libmtd descriptor
+ * @mtd_num: MTD device number
+ * @major: major number is returned here
+ * @minor: minor number is returned here
+ *
+ * This function returns zero in case of success and %-1 in case of failure.
+ */
+static int dev_get_major(struct libmtd *lib, int mtd_num, int *major, int *minor)
+{
+	char file[strlen(lib->mtd_dev) + 50];
+
+	sprintf(file, lib->mtd_dev, mtd_num);
+	return read_major(file, major, minor);
+}
+
+/**
+ * dev_read_data - read data from an MTD device's sysfs file.
+ * @patt: file pattern to read from
+ * @mtd_num: MTD device number
+ * @buf: buffer to read to
+ * @buf_len: buffer length
+ *
+ * This function returns number of read bytes in case of success and %-1 in
+ * case of failure.
+ */
+static int dev_read_data(const char *patt, int mtd_num, void *buf, int buf_len)
+{
+	char file[strlen(patt) + 100];
+
+	sprintf(file, patt, mtd_num);
+	return read_data(file, buf, buf_len);
+}
+
+/**
+ * read_hex_ll - read a hex 'long long' value from a file.
+ * @file: the file to read from
+ * @value: the result is stored here
+ *
+ * This function reads file @file and interprets its contents as hexadecimal
+ * 'long long' integer. If this is not true, it fails with %EINVAL error code.
+ * Returns %0 in case of success and %-1 in case of failure.
+ */
+static int read_hex_ll(const char *file, long long *value)
+{
+	int fd, rd;
+	char buf[50];
+
+	fd = open(file, O_RDONLY | O_CLOEXEC);
+	if (fd == -1)
+		return -1;
+
+	rd = read(fd, buf, sizeof(buf));
+	if (rd == -1) {
+		sys_errmsg("cannot read \"%s\"", file);
+		goto out_error;
+	}
+	if (rd == sizeof(buf)) {
+		errmsg("contents of \"%s\" is too long", file);
+		errno = EINVAL;
+		goto out_error;
+	}
+	buf[rd] = '\0';
+
+	if (sscanf(buf, "%llx\n", value) != 1) {
+		errmsg("cannot read integer from \"%s\"\n", file);
+		errno = EINVAL;
+		goto out_error;
+	}
+
+	if (*value < 0) {
+		errmsg("negative value %lld in \"%s\"", *value, file);
+		errno = EINVAL;
+		goto out_error;
+	}
+
+	if (close(fd))
+		return sys_errmsg("close failed on \"%s\"", file);
+
+	return 0;
+
+out_error:
+	close(fd);
+	return -1;
+}
+
+/**
+ * read_pos_ll - read a positive 'long long' value from a file.
+ * @file: the file to read from
+ * @value: the result is stored here
+ *
+ * This function reads file @file and interprets its contents as a positive
+ * 'long long' integer. If this is not true, it fails with %EINVAL error code.
+ * Returns %0 in case of success and %-1 in case of failure.
+ */
+static int read_pos_ll(const char *file, long long *value)
+{
+	int fd, rd;
+	char buf[50];
+
+	fd = open(file, O_RDONLY | O_CLOEXEC);
+	if (fd == -1)
+		return -1;
+
+	rd = read(fd, buf, 50);
+	if (rd == -1) {
+		sys_errmsg("cannot read \"%s\"", file);
+		goto out_error;
+	}
+	if (rd == 50) {
+		errmsg("contents of \"%s\" is too long", file);
+		errno = EINVAL;
+		goto out_error;
+	}
+
+	if (sscanf(buf, "%lld\n", value) != 1) {
+		errmsg("cannot read integer from \"%s\"\n", file);
+		errno = EINVAL;
+		goto out_error;
+	}
+
+	if (*value < 0) {
+		errmsg("negative value %lld in \"%s\"", *value, file);
+		errno = EINVAL;
+		goto out_error;
+	}
+
+	if (close(fd))
+		return sys_errmsg("close failed on \"%s\"", file);
+
+	return 0;
+
+out_error:
+	close(fd);
+	return -1;
+}
+
+/**
+ * read_hex_int - read an 'int' value from a file.
+ * @file: the file to read from
+ * @value: the result is stored here
+ *
+ * This function is the same as 'read_pos_ll()', but it reads an 'int'
+ * value, not 'long long'.
+ */
+static int read_hex_int(const char *file, int *value)
+{
+	long long res;
+
+	if (read_hex_ll(file, &res))
+		return -1;
+
+	/* Make sure the value has correct range */
+	if (res > INT_MAX || res < INT_MIN) {
+		errmsg("value %lld read from file \"%s\" is out of range",
+		       res, file);
+		errno = EINVAL;
+		return -1;
+	}
+
+	*value = res;
+	return 0;
+}
+
+/**
+ * read_pos_int - read a positive 'int' value from a file.
+ * @file: the file to read from
+ * @value: the result is stored here
+ *
+ * This function is the same as 'read_pos_ll()', but it reads an 'int'
+ * value, not 'long long'.
+ */
+static int read_pos_int(const char *file, int *value)
+{
+	long long res;
+
+	if (read_pos_ll(file, &res))
+		return -1;
+
+	/* Make sure the value is not too big */
+	if (res > INT_MAX) {
+		errmsg("value %lld read from file \"%s\" is out of range",
+		       res, file);
+		errno = EINVAL;
+		return -1;
+	}
+
+	*value = res;
+	return 0;
+}
+
+/**
+ * dev_read_hex_int - read an hex 'int' value from an MTD device sysfs file.
+ * @patt: file pattern to read from
+ * @mtd_num: MTD device number
+ * @value: the result is stored here
+ *
+ * This function returns %0 in case of success and %-1 in case of failure.
+ */
+static int dev_read_hex_int(const char *patt, int mtd_num, int *value)
+{
+	char file[strlen(patt) + 50];
+
+	sprintf(file, patt, mtd_num);
+	return read_hex_int(file, value);
+}
+
+/**
+ * dev_read_pos_int - read a positive 'int' value from an MTD device sysfs file.
+ * @patt: file pattern to read from
+ * @mtd_num: MTD device number
+ * @value: the result is stored here
+ *
+ * This function returns %0 in case of success and %-1 in case of failure.
+ */
+static int dev_read_pos_int(const char *patt, int mtd_num, int *value)
+{
+	char file[strlen(patt) + 50];
+
+	sprintf(file, patt, mtd_num);
+	return read_pos_int(file, value);
+}
+
+/**
+ * dev_read_pos_ll - read a positive 'long long' value from an MTD device sysfs file.
+ * @patt: file pattern to read from
+ * @mtd_num: MTD device number
+ * @value: the result is stored here
+ *
+ * This function returns %0 in case of success and %-1 in case of failure.
+ */
+static int dev_read_pos_ll(const char *patt, int mtd_num, long long *value)
+{
+	char file[strlen(patt) + 50];
+
+	sprintf(file, patt, mtd_num);
+	return read_pos_ll(file, value);
+}
+
+/**
+ * type_str2int - convert MTD device type to integer.
+ * @str: MTD device type string to convert
+ *
+ * This function converts MTD device type string @str, read from sysfs, into an
+ * integer.
+ */
+static int type_str2int(const char *str)
+{
+	if (!strcmp(str, "nand"))
+		return MTD_NANDFLASH;
+	if (!strcmp(str, "mlc-nand"))
+		return MTD_MLCNANDFLASH;
+	if (!strcmp(str, "nor"))
+		return MTD_NORFLASH;
+	if (!strcmp(str, "rom"))
+		return MTD_ROM;
+	if (!strcmp(str, "absent"))
+		return MTD_ABSENT;
+	if (!strcmp(str, "dataflash"))
+		return MTD_DATAFLASH;
+	if (!strcmp(str, "ram"))
+		return MTD_RAM;
+	if (!strcmp(str, "ubi"))
+		return MTD_UBIVOLUME;
+	return -1;
+}
+
+/**
+ * dev_node2num - find UBI device number by its character device node.
+ * @lib: MTD library descriptor
+ * @node: name of the MTD device node
+ * @mtd_num: MTD device number is returned here
+ *
+ * This function returns %0 in case of success and %-1 in case of failure.
+ */
+static int dev_node2num(struct libmtd *lib, const char *node, int *mtd_num)
+{
+	struct stat st;
+	int i, mjr, mnr;
+	struct mtd_info info;
+
+	if (stat(node, &st))
+		return sys_errmsg("cannot get information about \"%s\"", node);
+
+	if (!S_ISCHR(st.st_mode)) {
+		errmsg("\"%s\" is not a character device", node);
+		errno = EINVAL;
+		return -1;
+	}
+
+	mjr = major(st.st_rdev);
+	mnr = minor(st.st_rdev);
+
+	if (mtd_get_info((libmtd_t *)lib, &info))
+		return -1;
+
+	for (i = info.lowest_mtd_num; i <= info.highest_mtd_num; i++) {
+		int mjr1, mnr1, ret;
+
+		ret = dev_get_major(lib, i, &mjr1, &mnr1);
+		if (ret) {
+			if (errno == ENOENT)
+				continue;
+			if (!errno)
+				break;
+			return -1;
+		}
+
+		if (mjr1 == mjr && mnr1 == mnr) {
+			errno = 0;
+			*mtd_num = i;
+			return 0;
+		}
+	}
+
+	errno = ENODEV;
+	return -1;
+}
+
+/**
+ * sysfs_is_supported - check whether the MTD sub-system supports MTD.
+ * @lib: MTD library descriptor
+ *
+ * The Linux kernel MTD subsystem gained MTD support starting from kernel
+ * 2.6.30 and libmtd tries to use sysfs interface if possible, because the NAND
+ * sub-page size is available there (and not available at all in pre-sysfs
+ * kernels).
+ *
+ * Very old kernels did not have "/sys/class/mtd" directory. Not very old
+ * kernels (e.g., 2.6.29) did have "/sys/class/mtd/mtdX" directories, by there
+ * were no files there, e.g., the "name" file was not present. So all we can do
+ * is to check for a "/sys/class/mtd/mtdX/name" file. But this is not a
+ * reliable check, because if this is a new system with no MTD devices - we'll
+ * treat it as a pre-sysfs system.
+ */
+static int sysfs_is_supported(struct libmtd *lib)
+{
+	int fd, num = -1;
+	DIR *sysfs_mtd;
+	char file[strlen(lib->mtd_name) + 10];
+
+	sysfs_mtd = opendir(lib->sysfs_mtd);
+	if (!sysfs_mtd) {
+		if (errno == ENOENT) {
+			errno = 0;
+			return 0;
+		}
+		return sys_errmsg("cannot open \"%s\"", lib->sysfs_mtd);
+	}
+
+	/*
+	 * First of all find an "mtdX" directory. This is needed because there
+	 * may be, for example, mtd1 but no mtd0.
+	 */
+	while (1) {
+		int ret, mtd_num;
+		char tmp_buf[256];
+		struct dirent *dirent;
+
+		dirent = readdir(sysfs_mtd);
+		if (!dirent)
+			break;
+
+		if (strlen(dirent->d_name) >= 255) {
+			errmsg("invalid entry in %s: \"%s\"",
+			       lib->sysfs_mtd, dirent->d_name);
+			errno = EINVAL;
+			closedir(sysfs_mtd);
+			return -1;
+		}
+
+		ret = sscanf(dirent->d_name, MTD_NAME_PATT"%s",
+			     &mtd_num, tmp_buf);
+		if (ret == 1) {
+			num = mtd_num;
+			break;
+		}
+	}
+
+	if (closedir(sysfs_mtd))
+		return sys_errmsg("closedir failed on \"%s\"", lib->sysfs_mtd);
+
+	if (num == -1)
+		/* No mtd device, treat this as pre-sysfs system */
+		return 0;
+
+	sprintf(file, lib->mtd_name, num);
+	fd = open(file, O_RDONLY | O_CLOEXEC);
+	if (fd == -1)
+		return 0;
+
+	if (close(fd)) {
+		sys_errmsg("close failed on \"%s\"", file);
+		return -1;
+	}
+
+	return 1;
+}
+
+libmtd_t libmtd_open(void)
+{
+	struct libmtd *lib;
+
+	lib = xzalloc(sizeof(*lib));
+
+	lib->offs64_ioctls = OFFS64_IOCTLS_UNKNOWN;
+
+	lib->sysfs_mtd = mkpath("/sys", SYSFS_MTD);
+	if (!lib->sysfs_mtd)
+		goto out_error;
+
+	lib->mtd = mkpath(lib->sysfs_mtd, MTD_NAME_PATT);
+	if (!lib->mtd)
+		goto out_error;
+
+	lib->mtd_name = mkpath(lib->mtd, MTD_NAME);
+	if (!lib->mtd_name)
+		goto out_error;
+
+	if (!sysfs_is_supported(lib)) {
+		free(lib->mtd);
+		free(lib->sysfs_mtd);
+		free(lib->mtd_name);
+		lib->mtd_name = lib->mtd = lib->sysfs_mtd = NULL;
+		return lib;
+	}
+
+	lib->mtd_dev = mkpath(lib->mtd, MTD_DEV);
+	if (!lib->mtd_dev)
+		goto out_error;
+
+	lib->mtd_type = mkpath(lib->mtd, MTD_TYPE);
+	if (!lib->mtd_type)
+		goto out_error;
+
+	lib->mtd_eb_size = mkpath(lib->mtd, MTD_EB_SIZE);
+	if (!lib->mtd_eb_size)
+		goto out_error;
+
+	lib->mtd_size = mkpath(lib->mtd, MTD_SIZE);
+	if (!lib->mtd_size)
+		goto out_error;
+
+	lib->mtd_min_io_size = mkpath(lib->mtd, MTD_MIN_IO_SIZE);
+	if (!lib->mtd_min_io_size)
+		goto out_error;
+
+	lib->mtd_subpage_size = mkpath(lib->mtd, MTD_SUBPAGE_SIZE);
+	if (!lib->mtd_subpage_size)
+		goto out_error;
+
+	lib->mtd_oob_size = mkpath(lib->mtd, MTD_OOB_SIZE);
+	if (!lib->mtd_oob_size)
+		goto out_error;
+
+	lib->mtd_region_cnt = mkpath(lib->mtd, MTD_REGION_CNT);
+	if (!lib->mtd_region_cnt)
+		goto out_error;
+
+	lib->mtd_flags = mkpath(lib->mtd, MTD_FLAGS);
+	if (!lib->mtd_flags)
+		goto out_error;
+
+	lib->sysfs_supported = 1;
+	return lib;
+
+out_error:
+	libmtd_close((libmtd_t)lib);
+	return NULL;
+}
+
+void libmtd_close(libmtd_t desc)
+{
+	struct libmtd *lib = (struct libmtd *)desc;
+
+	free(lib->mtd_flags);
+	free(lib->mtd_region_cnt);
+	free(lib->mtd_oob_size);
+	free(lib->mtd_subpage_size);
+	free(lib->mtd_min_io_size);
+	free(lib->mtd_size);
+	free(lib->mtd_eb_size);
+	free(lib->mtd_type);
+	free(lib->mtd_dev);
+	free(lib->mtd_name);
+	free(lib->mtd);
+	free(lib->sysfs_mtd);
+	free(lib);
+}
+
+int mtd_dev_present(libmtd_t desc, int mtd_num) {
+	struct stat st;
+	struct libmtd *lib = (struct libmtd *)desc;
+
+	if (!lib->sysfs_supported) {
+		return legacy_dev_present(mtd_num) == 1;
+	} else {
+		char file[strlen(lib->mtd) + 10];
+
+		sprintf(file, lib->mtd, mtd_num);
+		return !stat(file, &st);
+	}
+}
+
+int mtd_get_info(libmtd_t desc, struct mtd_info *info)
+{
+	DIR *sysfs_mtd;
+	struct dirent *dirent;
+	struct libmtd *lib = (struct libmtd *)desc;
+
+	memset(info, 0, sizeof(struct mtd_info));
+
+	if (!lib->sysfs_supported)
+		return legacy_mtd_get_info(info);
+
+	info->sysfs_supported = 1;
+
+	/*
+	 * We have to scan the MTD sysfs directory to identify how many MTD
+	 * devices are present.
+	 */
+	sysfs_mtd = opendir(lib->sysfs_mtd);
+	if (!sysfs_mtd) {
+		if (errno == ENOENT) {
+			errno = ENODEV;
+			return -1;
+		}
+		return sys_errmsg("cannot open \"%s\"", lib->sysfs_mtd);
+	}
+
+	info->lowest_mtd_num = INT_MAX;
+	while (1) {
+		int mtd_num, ret;
+		char tmp_buf[256];
+
+		errno = 0;
+		dirent = readdir(sysfs_mtd);
+		if (!dirent)
+			break;
+
+		if (strlen(dirent->d_name) >= 255) {
+			errmsg("invalid entry in %s: \"%s\"",
+			       lib->sysfs_mtd, dirent->d_name);
+			errno = EINVAL;
+			goto out_close;
+		}
+
+		ret = sscanf(dirent->d_name, MTD_NAME_PATT"%s",
+			     &mtd_num, tmp_buf);
+		if (ret == 1) {
+			info->mtd_dev_cnt += 1;
+			if (mtd_num > info->highest_mtd_num)
+				info->highest_mtd_num = mtd_num;
+			if (mtd_num < info->lowest_mtd_num)
+				info->lowest_mtd_num = mtd_num;
+		}
+	}
+
+	if (!dirent && errno) {
+		sys_errmsg("readdir failed on \"%s\"", lib->sysfs_mtd);
+		goto out_close;
+	}
+
+	if (closedir(sysfs_mtd))
+		return sys_errmsg("closedir failed on \"%s\"", lib->sysfs_mtd);
+
+	if (info->lowest_mtd_num == INT_MAX)
+		info->lowest_mtd_num = 0;
+
+	return 0;
+
+out_close:
+	closedir(sysfs_mtd);
+	return -1;
+}
+
+int mtd_get_dev_info1(libmtd_t desc, int mtd_num, struct mtd_dev_info *mtd)
+{
+	int ret;
+	struct libmtd *lib = (struct libmtd *)desc;
+
+	memset(mtd, 0, sizeof(struct mtd_dev_info));
+	mtd->mtd_num = mtd_num;
+
+	if (!mtd_dev_present(desc, mtd_num)) {
+		errno = ENODEV;
+		return -1;
+	} else if (!lib->sysfs_supported)
+		return legacy_get_dev_info1(mtd_num, mtd);
+
+	if (dev_get_major(lib, mtd_num, &mtd->major, &mtd->minor))
+		return -1;
+
+	ret = dev_read_data(lib->mtd_name, mtd_num, &mtd->name,
+			    MTD_NAME_MAX + 1);
+	if (ret < 0)
+		return -1;
+	((char *)mtd->name)[ret - 1] = '\0';
+
+	ret = dev_read_data(lib->mtd_type, mtd_num, &mtd->type_str,
+			    MTD_TYPE_MAX + 1);
+	if (ret < 0)
+		return -1;
+	((char *)mtd->type_str)[ret - 1] = '\0';
+
+	if (dev_read_pos_int(lib->mtd_eb_size, mtd_num, &mtd->eb_size))
+		return -1;
+	if (dev_read_pos_ll(lib->mtd_size, mtd_num, &mtd->size))
+		return -1;
+	if (dev_read_pos_int(lib->mtd_min_io_size, mtd_num, &mtd->min_io_size))
+		return -1;
+	if (dev_read_pos_int(lib->mtd_subpage_size, mtd_num, &mtd->subpage_size))
+		return -1;
+	if (dev_read_pos_int(lib->mtd_oob_size, mtd_num, &mtd->oob_size))
+		return -1;
+	if (dev_read_pos_int(lib->mtd_region_cnt, mtd_num, &mtd->region_cnt))
+		return -1;
+	if (dev_read_hex_int(lib->mtd_flags, mtd_num, &ret))
+		return -1;
+	mtd->writable = !!(ret & MTD_WRITEABLE);
+
+	mtd->eb_cnt = mtd->size / mtd->eb_size;
+	mtd->type = type_str2int(mtd->type_str);
+	mtd->bb_allowed = !!(mtd->type == MTD_NANDFLASH ||
+				mtd->type == MTD_MLCNANDFLASH);
+
+	return 0;
+}
+
+int mtd_get_dev_info(libmtd_t desc, const char *node, struct mtd_dev_info *mtd)
+{
+	int mtd_num;
+	struct libmtd *lib = (struct libmtd *)desc;
+
+	if (!lib->sysfs_supported)
+		return legacy_get_dev_info(node, mtd);
+
+	if (dev_node2num(lib, node, &mtd_num))
+		return -1;
+
+	return mtd_get_dev_info1(desc, mtd_num, mtd);
+}
+
+static inline int mtd_ioctl_error(const struct mtd_dev_info *mtd, int eb,
+				  const char *sreq)
+{
+	return sys_errmsg("%s ioctl failed for eraseblock %d (mtd%d)",
+			  sreq, eb, mtd->mtd_num);
+}
+
+static int mtd_valid_erase_block(const struct mtd_dev_info *mtd, int eb)
+{
+	if (eb < 0 || eb >= mtd->eb_cnt) {
+		errmsg("bad eraseblock number %d, mtd%d has %d eraseblocks",
+		       eb, mtd->mtd_num, mtd->eb_cnt);
+		errno = EINVAL;
+		return -1;
+	}
+	return 0;
+}
+
+static int mtd_xlock(const struct mtd_dev_info *mtd, int fd, int eb, int req,
+		     const char *sreq)
+{
+	int ret;
+	struct erase_info_user ei;
+
+	ret = mtd_valid_erase_block(mtd, eb);
+	if (ret)
+		return ret;
+
+	ei.start = eb * mtd->eb_size;
+	ei.length = mtd->eb_size;
+
+	ret = ioctl(fd, req, &ei);
+	if (ret < 0)
+		return mtd_ioctl_error(mtd, eb, sreq);
+
+	return 0;
+}
+#define mtd_xlock(mtd, fd, eb, req) mtd_xlock(mtd, fd, eb, req, #req)
+
+int mtd_lock(const struct mtd_dev_info *mtd, int fd, int eb)
+{
+	return mtd_xlock(mtd, fd, eb, MEMLOCK);
+}
+
+int mtd_unlock(const struct mtd_dev_info *mtd, int fd, int eb)
+{
+	return mtd_xlock(mtd, fd, eb, MEMUNLOCK);
+}
+
+int mtd_erase(libmtd_t desc, const struct mtd_dev_info *mtd, int fd, int eb)
+{
+	int ret;
+	struct libmtd *lib = (struct libmtd *)desc;
+	struct erase_info_user64 ei64;
+	struct erase_info_user ei;
+
+	ret = mtd_valid_erase_block(mtd, eb);
+	if (ret)
+		return ret;
+
+	ei64.start = (__u64)eb * mtd->eb_size;
+	ei64.length = mtd->eb_size;
+
+	if (lib->offs64_ioctls == OFFS64_IOCTLS_SUPPORTED ||
+	    lib->offs64_ioctls == OFFS64_IOCTLS_UNKNOWN) {
+		ret = ioctl(fd, MEMERASE64, &ei64);
+		if (ret == 0)
+			return ret;
+
+		if (errno != ENOTTY ||
+		    lib->offs64_ioctls != OFFS64_IOCTLS_UNKNOWN)
+			return mtd_ioctl_error(mtd, eb, "MEMERASE64");
+
+		/*
+		 * MEMERASE64 support was added in kernel version 2.6.31, so
+		 * probably we are working with older kernel and this ioctl is
+		 * not supported.
+		 */
+		lib->offs64_ioctls = OFFS64_IOCTLS_NOT_SUPPORTED;
+	}
+
+	if (ei64.start + ei64.length > 0xFFFFFFFF) {
+		errmsg("this system can address only %u eraseblocks",
+		       0xFFFFFFFFU / mtd->eb_size);
+		errno = EINVAL;
+		return -1;
+	}
+
+	ei.start = ei64.start;
+	ei.length = ei64.length;
+	ret = ioctl(fd, MEMERASE, &ei);
+	if (ret < 0)
+		return mtd_ioctl_error(mtd, eb, "MEMERASE");
+	return 0;
+}
+
+int mtd_regioninfo(int fd, int regidx, struct region_info_user *reginfo)
+{
+	int ret;
+
+	if (regidx < 0) {
+		errno = ENODEV;
+		return -1;
+	}
+
+	reginfo->regionindex = regidx;
+
+	ret = ioctl(fd, MEMGETREGIONINFO, reginfo);
+	if (ret < 0)
+		return sys_errmsg("%s ioctl failed for erase region %d",
+			"MEMGETREGIONINFO", regidx);
+
+	return 0;
+}
+
+int mtd_is_locked(const struct mtd_dev_info *mtd, int fd, int eb)
+{
+	int ret;
+	erase_info_t ei;
+
+	ei.start = eb * mtd->eb_size;
+	ei.length = mtd->eb_size;
+
+	ret = ioctl(fd, MEMISLOCKED, &ei);
+	if (ret < 0) {
+		if (errno != ENOTTY && errno != EOPNOTSUPP)
+			return mtd_ioctl_error(mtd, eb, "MEMISLOCKED");
+		else
+			errno = EOPNOTSUPP;
+	}
+
+	return ret;
+}
+
+/* Patterns to write to a physical eraseblock when torturing it */
+static uint8_t patterns[] = {0xa5, 0x5a, 0x0};
+
+/**
+ * check_pattern - check if buffer contains only a certain byte pattern.
+ * @buf: buffer to check
+ * @patt: the pattern to check
+ * @size: buffer size in bytes
+ *
+ * This function returns %1 in there are only @patt bytes in @buf, and %0 if
+ * something else was also found.
+ */
+static int check_pattern(const void *buf, uint8_t patt, int size)
+{
+	int i;
+
+	for (i = 0; i < size; i++)
+		if (((const uint8_t *)buf)[i] != patt)
+			return 0;
+	return 1;
+}
+
+int mtd_torture(libmtd_t desc, const struct mtd_dev_info *mtd, int fd, int eb)
+{
+	int err, i, patt_count;
+	void *buf;
+
+	normsg("run torture test for PEB %d", eb);
+	patt_count = ARRAY_SIZE(patterns);
+
+	buf = xmalloc(mtd->eb_size);
+
+	for (i = 0; i < patt_count; i++) {
+		err = mtd_erase(desc, mtd, fd, eb);
+		if (err)
+			goto out;
+
+		/* Make sure the PEB contains only 0xFF bytes */
+		err = mtd_read(mtd, fd, eb, 0, buf, mtd->eb_size);
+		if (err)
+			goto out;
+
+		err = check_pattern(buf, 0xFF, mtd->eb_size);
+		if (err == 0) {
+			errmsg("erased PEB %d, but a non-0xFF byte found", eb);
+			errno = EIO;
+			goto out;
+		}
+
+		/* Write a pattern and check it */
+		memset(buf, patterns[i], mtd->eb_size);
+		err = mtd_write(desc, mtd, fd, eb, 0, buf, mtd->eb_size, NULL,
+				0, 0);
+		if (err)
+			goto out;
+
+		memset(buf, ~patterns[i], mtd->eb_size);
+		err = mtd_read(mtd, fd, eb, 0, buf, mtd->eb_size);
+		if (err)
+			goto out;
+
+		err = check_pattern(buf, patterns[i], mtd->eb_size);
+		if (err == 0) {
+			errmsg("pattern %x checking failed for PEB %d",
+				patterns[i], eb);
+			errno = EIO;
+			goto out;
+		}
+	}
+
+	err = 0;
+	normsg("PEB %d passed torture test, do not mark it a bad", eb);
+
+out:
+	free(buf);
+	return -1;
+}
+
+int mtd_is_bad(const struct mtd_dev_info *mtd, int fd, int eb)
+{
+	int ret;
+	loff_t seek;
+
+	ret = mtd_valid_erase_block(mtd, eb);
+	if (ret)
+		return ret;
+
+	if (!mtd->bb_allowed)
+		return 0;
+
+	seek = (loff_t)eb * mtd->eb_size;
+	ret = ioctl(fd, MEMGETBADBLOCK, &seek);
+	if (ret == -1)
+		return mtd_ioctl_error(mtd, eb, "MEMGETBADBLOCK");
+	return ret;
+}
+
+int mtd_mark_bad(const struct mtd_dev_info *mtd, int fd, int eb)
+{
+	int ret;
+	loff_t seek;
+
+	if (!mtd->bb_allowed) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	ret = mtd_valid_erase_block(mtd, eb);
+	if (ret)
+		return ret;
+
+	seek = (loff_t)eb * mtd->eb_size;
+	ret = ioctl(fd, MEMSETBADBLOCK, &seek);
+	if (ret == -1)
+		return mtd_ioctl_error(mtd, eb, "MEMSETBADBLOCK");
+	return 0;
+}
+
+int mtd_read(const struct mtd_dev_info *mtd, int fd, int eb, int offs,
+	     void *buf, int len)
+{
+	int ret, rd = 0;
+	off_t seek;
+
+	ret = mtd_valid_erase_block(mtd, eb);
+	if (ret)
+		return ret;
+
+	if (offs < 0 || offs + len > mtd->eb_size) {
+		errmsg("bad offset %d or length %d, mtd%d eraseblock size is %d",
+		       offs, len, mtd->mtd_num, mtd->eb_size);
+		errno = EINVAL;
+		return -1;
+	}
+
+	/* Seek to the beginning of the eraseblock */
+	seek = (off_t)eb * mtd->eb_size + offs;
+	if (lseek(fd, seek, SEEK_SET) != seek)
+		return sys_errmsg("cannot seek mtd%d to offset %"PRIdoff_t,
+				  mtd->mtd_num, seek);
+
+	while (rd < len) {
+		ret = read(fd, buf, len);
+		if (ret < 0)
+			return sys_errmsg("cannot read %d bytes from mtd%d (eraseblock %d, offset %d)",
+					  len, mtd->mtd_num, eb, offs);
+		rd += ret;
+	}
+
+	return 0;
+}
+
+static int legacy_auto_oob_layout(const struct mtd_dev_info *mtd, int fd,
+				  int ooblen, void *oob) {
+	struct nand_oobinfo old_oobinfo;
+	int start, len;
+	uint8_t *tmp_buf;
+
+	/* Read the current oob info */
+	if (ioctl(fd, MEMGETOOBSEL, &old_oobinfo))
+		return sys_errmsg("MEMGETOOBSEL failed");
+
+	tmp_buf = malloc(ooblen);
+	memcpy(tmp_buf, oob, ooblen);
+
+	/*
+	 * We use autoplacement and have the oobinfo with the autoplacement
+	 * information from the kernel available
+	 */
+	if (old_oobinfo.useecc == MTD_NANDECC_AUTOPLACE) {
+		int i, tags_pos = 0;
+		for (i = 0; old_oobinfo.oobfree[i][1]; i++) {
+			/* Set the reserved bytes to 0xff */
+			start = old_oobinfo.oobfree[i][0];
+			len = old_oobinfo.oobfree[i][1];
+			memcpy(oob + start, tmp_buf + tags_pos, len);
+			tags_pos += len;
+		}
+	} else {
+		/* Set at least the ecc byte positions to 0xff */
+		start = old_oobinfo.eccbytes;
+		len = mtd->oob_size - start;
+		memcpy(oob + start, tmp_buf + start, len);
+	}
+
+	return 0;
+}
+
+int mtd_write(libmtd_t desc, const struct mtd_dev_info *mtd, int fd, int eb,
+	      int offs, void *data, int len, void *oob, int ooblen,
+	      uint8_t mode)
+{
+	int ret;
+	off_t seek;
+	struct mtd_write_req ops;
+
+	ret = mtd_valid_erase_block(mtd, eb);
+	if (ret)
+		return ret;
+
+	if (offs < 0 || offs + len > mtd->eb_size) {
+		errmsg("bad offset %d or length %d, mtd%d eraseblock size is %d",
+		       offs, len, mtd->mtd_num, mtd->eb_size);
+		errno = EINVAL;
+		return -1;
+	}
+	if (offs % mtd->subpage_size) {
+		errmsg("write offset %d is not aligned to mtd%d min. I/O size %d",
+		       offs, mtd->mtd_num, mtd->subpage_size);
+		errno = EINVAL;
+		return -1;
+	}
+	if (len % mtd->subpage_size) {
+		errmsg("write length %d is not aligned to mtd%d min. I/O size %d",
+		       len, mtd->mtd_num, mtd->subpage_size);
+		errno = EINVAL;
+		return -1;
+	}
+
+	/* Calculate seek address */
+	seek = (off_t)eb * mtd->eb_size + offs;
+
+	if (oob) {
+		ops.start = seek;
+		ops.len = len;
+		ops.ooblen = ooblen;
+		ops.usr_data = (uint64_t)(unsigned long)data;
+		ops.usr_oob = (uint64_t)(unsigned long)oob;
+		ops.mode = mode;
+
+		ret = ioctl(fd, MEMWRITE, &ops);
+		if (ret == 0)
+			return 0;
+		else if (errno != ENOTTY && errno != EOPNOTSUPP)
+			return mtd_ioctl_error(mtd, eb, "MEMWRITE");
+
+		/* Fall back to old OOB ioctl() if necessary */
+		if (mode == MTD_OPS_AUTO_OOB)
+			if (legacy_auto_oob_layout(mtd, fd, ooblen, oob))
+				return -1;
+		if (mtd_write_oob(desc, mtd, fd, seek, ooblen, oob) < 0)
+			return sys_errmsg("cannot write to OOB");
+	}
+	if (data) {
+		/* Seek to the beginning of the eraseblock */
+		if (lseek(fd, seek, SEEK_SET) != seek)
+			return sys_errmsg("cannot seek mtd%d to offset %"PRIdoff_t,
+					mtd->mtd_num, seek);
+		ret = write(fd, data, len);
+		if (ret != len)
+			return sys_errmsg("cannot write %d bytes to mtd%d "
+					  "(eraseblock %d, offset %d)",
+					  len, mtd->mtd_num, eb, offs);
+	}
+
+	return 0;
+}
+
+int do_oob_op(libmtd_t desc, const struct mtd_dev_info *mtd, int fd,
+	      uint64_t start, uint64_t length, void *data, unsigned int cmd64,
+	      unsigned int cmd)
+{
+	int ret, oob_offs;
+	struct mtd_oob_buf64 oob64;
+	struct mtd_oob_buf oob;
+	unsigned long long max_offs;
+	const char *cmd64_str, *cmd_str;
+	struct libmtd *lib = (struct libmtd *)desc;
+
+	if (cmd64 ==  MEMREADOOB64) {
+		cmd64_str = "MEMREADOOB64";
+		cmd_str   = "MEMREADOOB";
+	} else {
+		cmd64_str = "MEMWRITEOOB64";
+		cmd_str   = "MEMWRITEOOB";
+	}
+
+	max_offs = (unsigned long long)mtd->eb_cnt * mtd->eb_size;
+	if (start >= max_offs) {
+		errmsg("bad page address %" PRIu64 ", mtd%d has %d eraseblocks (%llu bytes)",
+		       start, mtd->mtd_num, mtd->eb_cnt, max_offs);
+		errno = EINVAL;
+		return -1;
+	}
+
+	oob_offs = start & (mtd->min_io_size - 1);
+	if (oob_offs + length > mtd->oob_size || length == 0) {
+		errmsg("Cannot write %" PRIu64 " OOB bytes to address %" PRIu64 " (OOB offset %u) - mtd%d OOB size is only %d bytes",
+		       length, start, oob_offs, mtd->mtd_num,  mtd->oob_size);
+		errno = EINVAL;
+		return -1;
+	}
+
+	oob64.start = start;
+	oob64.length = length;
+	oob64.usr_ptr = (uint64_t)(unsigned long)data;
+
+	if (lib->offs64_ioctls == OFFS64_IOCTLS_SUPPORTED ||
+	    lib->offs64_ioctls == OFFS64_IOCTLS_UNKNOWN) {
+		ret = ioctl(fd, cmd64, &oob64);
+		if (ret == 0)
+			return ret;
+
+		if (errno != ENOTTY ||
+		    lib->offs64_ioctls != OFFS64_IOCTLS_UNKNOWN) {
+			sys_errmsg("%s ioctl failed for mtd%d, offset %" PRIu64 " (eraseblock %" PRIu64 ")",
+				   cmd64_str, mtd->mtd_num, start, start / mtd->eb_size);
+		}
+
+		/*
+		 * MEMREADOOB64/MEMWRITEOOB64 support was added in kernel
+		 * version 2.6.31, so probably we are working with older kernel
+		 * and these ioctls are not supported.
+		 */
+		lib->offs64_ioctls = OFFS64_IOCTLS_NOT_SUPPORTED;
+	}
+
+	if (oob64.start > 0xFFFFFFFFULL) {
+		errmsg("this system can address only up to address %lu",
+		       0xFFFFFFFFUL);
+		errno = EINVAL;
+		return -1;
+	}
+
+	oob.start = oob64.start;
+	oob.length = oob64.length;
+	oob.ptr = data;
+
+	ret = ioctl(fd, cmd, &oob);
+	if (ret < 0)
+		sys_errmsg("%s ioctl failed for mtd%d, offset %" PRIu64 " (eraseblock %" PRIu64 ")",
+			   cmd_str, mtd->mtd_num, start, start / mtd->eb_size);
+	return ret;
+}
+
+int mtd_read_oob(libmtd_t desc, const struct mtd_dev_info *mtd, int fd,
+		 uint64_t start, uint64_t length, void *data)
+{
+	return do_oob_op(desc, mtd, fd, start, length, data,
+			 MEMREADOOB64, MEMREADOOB);
+}
+
+int mtd_write_oob(libmtd_t desc, const struct mtd_dev_info *mtd, int fd,
+		  uint64_t start, uint64_t length, void *data)
+{
+	return do_oob_op(desc, mtd, fd, start, length, data,
+			 MEMWRITEOOB64, MEMWRITEOOB);
+}
+
+int mtd_write_img(const struct mtd_dev_info *mtd, int fd, int eb, int offs,
+		  const char *img_name)
+{
+	int tmp, ret, in_fd, len, written = 0;
+	off_t seek;
+	struct stat st;
+	char *buf;
+
+	ret = mtd_valid_erase_block(mtd, eb);
+	if (ret)
+		return ret;
+
+	if (offs < 0 || offs >= mtd->eb_size) {
+		errmsg("bad offset %d, mtd%d eraseblock size is %d",
+		       offs, mtd->mtd_num, mtd->eb_size);
+		errno = EINVAL;
+		return -1;
+	}
+	if (offs % mtd->subpage_size) {
+		errmsg("write offset %d is not aligned to mtd%d min. I/O size %d",
+		       offs, mtd->mtd_num, mtd->subpage_size);
+		errno = EINVAL;
+		return -1;
+	}
+
+	in_fd = open(img_name, O_RDONLY | O_CLOEXEC);
+	if (in_fd == -1)
+		return sys_errmsg("cannot open \"%s\"", img_name);
+
+	if (fstat(in_fd, &st)) {
+		sys_errmsg("cannot stat %s", img_name);
+		goto out_close;
+	}
+
+	len = st.st_size;
+	if (len % mtd->subpage_size) {
+		errmsg("size of \"%s\" is %d byte, which is not aligned to "
+		       "mtd%d min. I/O size %d", img_name, len, mtd->mtd_num,
+		       mtd->subpage_size);
+		errno = EINVAL;
+		goto out_close;
+	}
+	tmp = (offs + len + mtd->eb_size - 1) / mtd->eb_size;
+	if (eb + tmp > mtd->eb_cnt) {
+		errmsg("\"%s\" image size is %d bytes, mtd%d size is %d "
+		       "eraseblocks, the image does not fit if we write it "
+		       "starting from eraseblock %d, offset %d",
+		       img_name, len, mtd->mtd_num, mtd->eb_cnt, eb, offs);
+		errno = EINVAL;
+		goto out_close;
+	}
+
+	/* Seek to the beginning of the eraseblock */
+	seek = (off_t)eb * mtd->eb_size + offs;
+	if (lseek(fd, seek, SEEK_SET) != seek) {
+		sys_errmsg("cannot seek mtd%d to offset %"PRIdoff_t,
+			    mtd->mtd_num, seek);
+		goto out_close;
+	}
+
+	buf = xmalloc(mtd->eb_size);
+
+	while (written < len) {
+		int rd = 0;
+
+		do {
+			ret = read(in_fd, buf, mtd->eb_size - offs - rd);
+			if (ret == -1) {
+				sys_errmsg("cannot read \"%s\"", img_name);
+				goto out_free;
+			}
+			rd += ret;
+		} while (ret && rd < mtd->eb_size - offs);
+
+		ret = write(fd, buf, rd);
+		if (ret != rd) {
+			sys_errmsg("cannot write %d bytes to mtd%d (eraseblock %d, offset %d)",
+				   len, mtd->mtd_num, eb, offs);
+			goto out_free;
+		}
+
+		offs = 0;
+		eb += 1;
+		written += rd;
+	}
+
+	free(buf);
+	close(in_fd);
+	return 0;
+
+out_free:
+	free(buf);
+out_close:
+	close(in_fd);
+	return -1;
+}
+
+int mtd_probe_node(libmtd_t desc, const char *node)
+{
+	struct stat st;
+	struct mtd_info info;
+	int i, mjr, mnr;
+	struct libmtd *lib = (struct libmtd *)desc;
+
+	if (stat(node, &st))
+		return sys_errmsg("cannot get information about \"%s\"", node);
+
+	if (!S_ISCHR(st.st_mode)) {
+		errmsg("\"%s\" is not a character device", node);
+		errno = EINVAL;
+		return -1;
+	}
+
+	mjr = major(st.st_rdev);
+	mnr = minor(st.st_rdev);
+
+	if (mtd_get_info((libmtd_t *)lib, &info))
+		return -1;
+
+	if (!lib->sysfs_supported)
+		return 0;
+
+	for (i = info.lowest_mtd_num; i <= info.highest_mtd_num; i++) {
+		int mjr1, mnr1, ret;
+
+		ret = dev_get_major(lib, i, &mjr1, &mnr1);
+		if (ret) {
+			if (errno == ENOENT)
+				continue;
+			if (!errno)
+				break;
+			return -1;
+		}
+
+		if (mjr1 == mjr && mnr1 == mnr)
+			return 1;
+	}
+
+	errno = 0;
+	return -1;
+}
diff --git a/oslib/libmtd.h b/oslib/libmtd.h
new file mode 100644
index 0000000..3625de5
--- /dev/null
+++ b/oslib/libmtd.h
@@ -0,0 +1,354 @@
+/*
+ * Copyright (C) 2008, 2009 Nokia Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * Author: Artem Bityutskiy
+ *
+ * MTD library.
+ */
+
+/* Imported from mtd-utils by dehrenberg */
+
+#ifndef __LIBMTD_H__
+#define __LIBMTD_H__
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+/* Maximum MTD device name length */
+#define MTD_NAME_MAX 127
+/* Maximum MTD device type string length */
+#define MTD_TYPE_MAX 64
+
+/* MTD library descriptor */
+typedef void * libmtd_t;
+
+/* Forward decls */
+struct region_info_user;
+
+/**
+ * @mtd_dev_cnt: count of MTD devices in system
+ * @lowest_mtd_num: lowest MTD device number in system
+ * @highest_mtd_num: highest MTD device number in system
+ * @sysfs_supported: non-zero if sysfs is supported by MTD
+ */
+struct mtd_info
+{
+	int mtd_dev_cnt;
+	int lowest_mtd_num;
+	int highest_mtd_num;
+	unsigned int sysfs_supported:1;
+};
+
+/**
+ * struct mtd_dev_info - information about an MTD device.
+ * @mtd_num: MTD device number
+ * @major: major number of corresponding character device
+ * @minor: minor number of corresponding character device
+ * @type: flash type (constants like %MTD_NANDFLASH defined in mtd-abi.h)
+ * @type_str: static R/O flash type string
+ * @name: device name
+ * @size: device size in bytes
+ * @eb_cnt: count of eraseblocks
+ * @eb_size: eraseblock size
+ * @min_io_size: minimum input/output unit size
+ * @subpage_size: sub-page size
+ * @oob_size: OOB size (zero if the device does not have OOB area)
+ * @region_cnt: count of additional erase regions
+ * @writable: zero if the device is read-only
+ * @bb_allowed: non-zero if the MTD device may have bad eraseblocks
+ */
+struct mtd_dev_info
+{
+	int mtd_num;
+	int major;
+	int minor;
+	int type;
+	char type_str[MTD_TYPE_MAX + 1];
+	char name[MTD_NAME_MAX + 1];
+	long long size;
+	int eb_cnt;
+	int eb_size;
+	int min_io_size;
+	int subpage_size;
+	int oob_size;
+	int region_cnt;
+	unsigned int writable:1;
+	unsigned int bb_allowed:1;
+};
+
+/**
+ * libmtd_open - open MTD library.
+ *
+ * This function initializes and opens the MTD library and returns MTD library
+ * descriptor in case of success and %NULL in case of failure. In case of
+ * failure, errno contains zero if MTD is not present in the system, or
+ * contains the error code if a real error happened.
+ */
+libmtd_t libmtd_open(void);
+
+/**
+ * libmtd_close - close MTD library.
+ * @desc: MTD library descriptor
+ */
+void libmtd_close(libmtd_t desc);
+
+/**
+ * mtd_dev_present - check whether a MTD device is present.
+ * @desc: MTD library descriptor
+ * @mtd_num: MTD device number to check
+ *
+ * This function returns %1 if MTD device is present and %0 if not.
+ */
+int mtd_dev_present(libmtd_t desc, int mtd_num);
+
+/**
+ * mtd_get_info - get general MTD information.
+ * @desc: MTD library descriptor
+ * @info: the MTD device information is returned here
+ *
+ * This function fills the passed @info object with general MTD information and
+ * returns %0 in case of success and %-1 in case of failure. If MTD subsystem is
+ * not present in the system, errno is set to @ENODEV.
+ */
+int mtd_get_info(libmtd_t desc, struct mtd_info *info);
+
+/**
+ * mtd_get_dev_info - get information about an MTD device.
+ * @desc: MTD library descriptor
+ * @node: name of the MTD device node
+ * @mtd: the MTD device information is returned here
+ *
+ * This function gets information about MTD device defined by the @node device
+ * node file and saves this information in the @mtd object. Returns %0 in case
+ * of success and %-1 in case of failure. If MTD subsystem is not present in the
+ * system, or the MTD device does not exist, errno is set to @ENODEV.
+ */
+int mtd_get_dev_info(libmtd_t desc, const char *node, struct mtd_dev_info *mtd);
+
+/**
+ * mtd_get_dev_info1 - get information about an MTD device.
+ * @desc: MTD library descriptor
+ * @mtd_num: MTD device number to fetch information about
+ * @mtd: the MTD device information is returned here
+ *
+ * This function is identical to 'mtd_get_dev_info()' except that it accepts
+ * MTD device number, not MTD character device.
+ */
+int mtd_get_dev_info1(libmtd_t desc, int mtd_num, struct mtd_dev_info *mtd);
+
+/**
+ * mtd_lock - lock eraseblocks.
+ * @desc: MTD library descriptor
+ * @mtd: MTD device description object
+ * @fd: MTD device node file descriptor
+ * @eb: eraseblock to lock
+ *
+ * This function locks eraseblock @eb. Returns %0 in case of success and %-1
+ * in case of failure.
+ */
+int mtd_lock(const struct mtd_dev_info *mtd, int fd, int eb);
+
+/**
+ * mtd_unlock - unlock eraseblocks.
+ * @desc: MTD library descriptor
+ * @mtd: MTD device description object
+ * @fd: MTD device node file descriptor
+ * @eb: eraseblock to lock
+ *
+ * This function unlocks eraseblock @eb. Returns %0 in case of success and %-1
+ * in case of failure.
+ */
+int mtd_unlock(const struct mtd_dev_info *mtd, int fd, int eb);
+
+/**
+ * mtd_erase - erase an eraseblock.
+ * @desc: MTD library descriptor
+ * @mtd: MTD device description object
+ * @fd: MTD device node file descriptor
+ * @eb: eraseblock to erase
+ *
+ * This function erases eraseblock @eb of MTD device described by @fd. Returns
+ * %0 in case of success and %-1 in case of failure.
+ */
+int mtd_erase(libmtd_t desc, const struct mtd_dev_info *mtd, int fd, int eb);
+
+/**
+ * mtd_regioninfo - get information about an erase region.
+ * @fd: MTD device node file descriptor
+ * @regidx: index of region to look up
+ * @reginfo: the region information is returned here
+ *
+ * This function gets information about an erase region defined by the
+ * @regidx index and saves this information in the @reginfo object.
+ * Returns %0 in case of success and %-1 in case of failure. If the
+ * @regidx is not valid or unavailable, errno is set to @ENODEV.
+ */
+int mtd_regioninfo(int fd, int regidx, struct region_info_user *reginfo);
+
+/**
+ * mtd_is_locked - see if the specified eraseblock is locked.
+ * @mtd: MTD device description object
+ * @fd: MTD device node file descriptor
+ * @eb: eraseblock to check
+ *
+ * This function checks to see if eraseblock @eb of MTD device described
+ * by @fd is locked. Returns %0 if it is unlocked, %1 if it is locked, and
+ * %-1 in case of failure. If the ioctl is not supported (support was added in
+ * Linux kernel 2.6.36) or this particular device does not support it, errno is
+ * set to @ENOTSUPP.
+ */
+int mtd_is_locked(const struct mtd_dev_info *mtd, int fd, int eb);
+
+/**
+ * mtd_torture - torture an eraseblock.
+ * @desc: MTD library descriptor
+ * @mtd: MTD device description object
+ * @fd: MTD device node file descriptor
+ * @eb: eraseblock to torture
+ *
+ * This function tortures eraseblock @eb. Returns %0 in case of success and %-1
+ * in case of failure.
+ */
+int mtd_torture(libmtd_t desc, const struct mtd_dev_info *mtd, int fd, int eb);
+
+/**
+ * mtd_is_bad - check if eraseblock is bad.
+ * @mtd: MTD device description object
+ * @fd: MTD device node file descriptor
+ * @eb: eraseblock to check
+ *
+ * This function checks if eraseblock @eb is bad. Returns %0 if not, %1 if yes,
+ * and %-1 in case of failure.
+ */
+int mtd_is_bad(const struct mtd_dev_info *mtd, int fd, int eb);
+
+/**
+ * mtd_mark_bad - mark an eraseblock as bad.
+ * @mtd: MTD device description object
+ * @fd: MTD device node file descriptor
+ * @eb: eraseblock to mark as bad
+ *
+ * This function marks eraseblock @eb as bad. Returns %0 in case of success and
+ * %-1 in case of failure.
+ */
+int mtd_mark_bad(const struct mtd_dev_info *mtd, int fd, int eb);
+
+/**
+ * mtd_read - read data from an MTD device.
+ * @mtd: MTD device description object
+ * @fd: MTD device node file descriptor
+ * @eb: eraseblock to read from
+ * @offs: offset withing the eraseblock to read from
+ * @buf: buffer to read data to
+ * @len: how many bytes to read
+ *
+ * This function reads @len bytes of data from eraseblock @eb and offset @offs
+ * of the MTD device defined by @mtd and stores the read data at buffer @buf.
+ * Returns %0 in case of success and %-1 in case of failure.
+ */
+int mtd_read(const struct mtd_dev_info *mtd, int fd, int eb, int offs,
+	     void *buf, int len);
+
+/**
+ * mtd_write - write data to an MTD device.
+ * @desc: MTD library descriptor
+ * @mtd: MTD device description object
+ * @fd: MTD device node file descriptor
+ * @eb: eraseblock to write to
+ * @offs: offset withing the eraseblock to write to
+ * @data: data buffer to write
+ * @len: how many data bytes to write
+ * @oob: OOB buffer to write
+ * @ooblen: how many OOB bytes to write
+ * @mode: write mode (e.g., %MTD_OOB_PLACE, %MTD_OOB_RAW)
+ *
+ * This function writes @len bytes of data to eraseblock @eb and offset @offs
+ * of the MTD device defined by @mtd. Returns %0 in case of success and %-1 in
+ * case of failure.
+ *
+ * Can only write to a single page at a time if writing to OOB.
+ */
+int mtd_write(libmtd_t desc, const struct mtd_dev_info *mtd, int fd, int eb,
+	      int offs, void *data, int len, void *oob, int ooblen,
+	      uint8_t mode);
+
+/**
+ * mtd_read_oob - read out-of-band area.
+ * @desc: MTD library descriptor
+ * @mtd: MTD device description object
+ * @fd: MTD device node file descriptor
+ * @start: page-aligned start address
+ * @length: number of OOB bytes to read
+ * @data: read buffer
+ *
+ * This function reads @length OOB bytes starting from address @start on
+ * MTD device described by @fd. The address is specified as page byte offset
+ * from the beginning of the MTD device. This function returns %0 in case of
+ * success and %-1 in case of failure.
+ */
+int mtd_read_oob(libmtd_t desc, const struct mtd_dev_info *mtd, int fd,
+		 uint64_t start, uint64_t length, void *data);
+
+/**
+ * mtd_write_oob - write out-of-band area.
+ * @desc: MTD library descriptor
+ * @mtd: MTD device description object
+ * @fd: MTD device node file descriptor
+ * @start: page-aligned start address
+ * @length: number of OOB bytes to write
+ * @data: write buffer
+ *
+ * This function writes @length OOB bytes starting from address @start on
+ * MTD device described by @fd. The address is specified as page byte offset
+ * from the beginning of the MTD device. Returns %0 in case of success and %-1
+ * in case of failure.
+ */
+int mtd_write_oob(libmtd_t desc, const struct mtd_dev_info *mtd, int fd,
+		  uint64_t start, uint64_t length, void *data);
+
+/**
+ * mtd_write_img - write a file to MTD device.
+ * @mtd: MTD device description object
+ * @fd: MTD device node file descriptor
+ * @eb: eraseblock to write to
+ * @offs: offset withing the eraseblock to write to
+ * @img_name: the file to write
+ *
+ * This function writes an image @img_name the MTD device defined by @mtd. @eb
+ * and @offs are the starting eraseblock and offset on the MTD device. Returns
+ * %0 in case of success and %-1 in case of failure.
+ */
+int mtd_write_img(const struct mtd_dev_info *mtd, int fd, int eb, int offs,
+		  const char *img_name);
+
+/**
+ * mtd_probe_node - test MTD node.
+ * @desc: MTD library descriptor
+ * @node: the node to test
+ *
+ * This function tests whether @node is an MTD device node and returns %1 if it
+ * is, and %-1 if it is not (errno is %ENODEV in this case) or if an error
+ * occurred.
+ */
+int mtd_probe_node(libmtd_t desc, const char *node);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif /* __LIBMTD_H__ */
diff --git a/oslib/libmtd_common.h b/oslib/libmtd_common.h
new file mode 100644
index 0000000..a123323
--- /dev/null
+++ b/oslib/libmtd_common.h
@@ -0,0 +1,223 @@
+/*
+ * Copyright (c) Artem Bityutskiy, 2007, 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+/* Imported from mtd-utils by dehrenberg */
+
+#ifndef __MTD_UTILS_COMMON_H__
+#define __MTD_UTILS_COMMON_H__
+
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <ctype.h>
+#include <string.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <features.h>
+#include <inttypes.h>
+
+#ifndef PROGRAM_NAME
+# error "You must define PROGRAM_NAME before including this header"
+#endif
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+#ifndef MIN	/* some C lib headers define this for us */
+#define MIN(a, b) ((a) < (b) ? (a) : (b))
+#endif
+#ifndef MAX
+#define MAX(a, b) ((a) > (b) ? (a) : (b))
+#endif
+#define min(a, b) MIN(a, b) /* glue for linux kernel source */
+#define ARRAY_SIZE(a) (sizeof(a) / sizeof((a)[0]))
+
+#define ALIGN(x,a) __ALIGN_MASK(x,(typeof(x))(a)-1)
+#define __ALIGN_MASK(x,mask) (((x)+(mask))&~(mask))
+
+#define min_t(t,x,y) ({ \
+	typeof((x)) _x = (x); \
+	typeof((y)) _y = (y); \
+	(_x < _y) ? _x : _y; \
+})
+
+#define max_t(t,x,y) ({ \
+	typeof((x)) _x = (x); \
+	typeof((y)) _y = (y); \
+	(_x > _y) ? _x : _y; \
+})
+
+#ifndef O_CLOEXEC
+#define O_CLOEXEC 0
+#endif
+
+/* define a print format specifier for off_t */
+#ifdef __USE_FILE_OFFSET64
+#define PRIxoff_t PRIx64
+#define PRIdoff_t PRId64
+#else
+#define PRIxoff_t "l"PRIx32
+#define PRIdoff_t "l"PRId32
+#endif
+
+/* Verbose messages */
+#define bareverbose(verbose, fmt, ...) do {                        \
+	if (verbose)                                               \
+		printf(fmt, ##__VA_ARGS__);                        \
+} while(0)
+#define verbose(verbose, fmt, ...) \
+	bareverbose(verbose, "%s: " fmt "\n", PROGRAM_NAME, ##__VA_ARGS__)
+
+/* Normal messages */
+#define normsg_cont(fmt, ...) do {                                 \
+	printf("%s: " fmt, PROGRAM_NAME, ##__VA_ARGS__);           \
+} while(0)
+#define normsg(fmt, ...) do {                                      \
+	normsg_cont(fmt "\n", ##__VA_ARGS__);                      \
+} while(0)
+
+/* Error messages */
+#define errmsg(fmt, ...)  ({                                                \
+	fprintf(stderr, "%s: error!: " fmt "\n", PROGRAM_NAME, ##__VA_ARGS__); \
+	-1;                                                                 \
+})
+#define errmsg_die(fmt, ...) do {                                           \
+	exit(errmsg(fmt, ##__VA_ARGS__));                                   \
+} while(0)
+
+/* System error messages */
+#define sys_errmsg(fmt, ...)  ({                                            \
+	int _err = errno;                                                   \
+	errmsg(fmt, ##__VA_ARGS__);                                         \
+	fprintf(stderr, "%*serror %d (%s)\n", (int)sizeof(PROGRAM_NAME) + 1,\
+		"", _err, strerror(_err));                                  \
+	-1;                                                                 \
+})
+#define sys_errmsg_die(fmt, ...) do {                                       \
+	exit(sys_errmsg(fmt, ##__VA_ARGS__));                               \
+} while(0)
+
+/* Warnings */
+#define warnmsg(fmt, ...) do {                                                \
+	fprintf(stderr, "%s: warning!: " fmt "\n", PROGRAM_NAME, ##__VA_ARGS__); \
+} while(0)
+
+#if defined(__UCLIBC__)
+/* uClibc versions before 0.9.34 don't have rpmatch() */
+#if __UCLIBC_MAJOR__ == 0 && \
+		(__UCLIBC_MINOR__ < 9 || \
+		(__UCLIBC_MINOR__ == 9 && __UCLIBC_SUBLEVEL__ < 34))
+#undef rpmatch
+#define rpmatch __rpmatch
+static inline int __rpmatch(const char *resp)
+{
+    return (resp[0] == 'y' || resp[0] == 'Y') ? 1 :
+	(resp[0] == 'n' || resp[0] == 'N') ? 0 : -1;
+}
+#endif
+#endif
+
+/**
+ * prompt the user for confirmation
+ */
+static inline bool prompt(const char *msg, bool def)
+{
+	char *line = NULL;
+	size_t len;
+	bool ret = def;
+
+	do {
+		normsg_cont("%s (%c/%c) ", msg, def ? 'Y' : 'y', def ? 'n' : 'N');
+		fflush(stdout);
+
+		while (getline(&line, &len, stdin) == -1) {
+			printf("failed to read prompt; assuming '%s'\n",
+				def ? "yes" : "no");
+			break;
+		}
+
+		if (strcmp("\n", line) != 0) {
+			switch (rpmatch(line)) {
+			case 0: ret = false; break;
+			case 1: ret = true; break;
+			case -1:
+				puts("unknown response; please try again");
+				continue;
+			}
+		}
+		break;
+	} while (1);
+
+	free(line);
+
+	return ret;
+}
+
+static inline int is_power_of_2(unsigned long long n)
+{
+	return (n != 0 && ((n & (n - 1)) == 0));
+}
+
+/**
+ * simple_strtoX - convert a hex/dec/oct string into a number
+ * @snum: buffer to convert
+ * @error: set to 1 when buffer isn't fully consumed
+ *
+ * These functions are similar to the standard strtoX() functions, but they are
+ * a little bit easier to use if you want to convert full string of digits into
+ * the binary form. The typical usage:
+ *
+ * int error = 0;
+ * unsigned long num;
+ *
+ * num = simple_strtoul(str, &error);
+ * if (error || ... if needed, your check that num is not out of range ...)
+ * 	error_happened();
+ */
+#define simple_strtoX(func, type) \
+static inline type simple_##func(const char *snum, int *error) \
+{ \
+	char *endptr; \
+	type ret = func(snum, &endptr, 0); \
+ \
+	if (error && (!*snum || *endptr)) { \
+		errmsg("%s: unable to parse the number '%s'", #func, snum); \
+		*error = 1; \
+	} \
+ \
+	return ret; \
+}
+simple_strtoX(strtol, long int)
+simple_strtoX(strtoll, long long int)
+simple_strtoX(strtoul, unsigned long int)
+simple_strtoX(strtoull, unsigned long long int)
+
+/* Simple version-printing for utils */
+#define common_print_version() \
+do { \
+	printf("%s %s\n", PROGRAM_NAME, VERSION); \
+} while (0)
+
+#include "libmtd_xalloc.h"
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif /* !__MTD_UTILS_COMMON_H__ */
diff --git a/oslib/libmtd_int.h b/oslib/libmtd_int.h
new file mode 100644
index 0000000..cbe2ff5
--- /dev/null
+++ b/oslib/libmtd_int.h
@@ -0,0 +1,109 @@
+/*
+ * Copyright (c) International Business Machines Corp., 2006
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * Author: Artem Bityutskiy
+ *
+ * MTD library.
+ */
+
+/* Imported from mtd-utils by dehrenberg */
+
+#ifndef __LIBMTD_INT_H__
+#define __LIBMTD_INT_H__
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+#define PROGRAM_NAME "libmtd"
+
+#define SYSFS_MTD        "class/mtd"
+#define MTD_NAME_PATT    "mtd%d"
+#define MTD_DEV          "dev"
+#define MTD_NAME         "name"
+#define MTD_TYPE         "type"
+#define MTD_EB_SIZE      "erasesize"
+#define MTD_SIZE         "size"
+#define MTD_MIN_IO_SIZE  "writesize"
+#define MTD_SUBPAGE_SIZE "subpagesize"
+#define MTD_OOB_SIZE     "oobsize"
+#define MTD_REGION_CNT   "numeraseregions"
+#define MTD_FLAGS        "flags"
+
+#define OFFS64_IOCTLS_UNKNOWN       0
+#define OFFS64_IOCTLS_NOT_SUPPORTED 1
+#define OFFS64_IOCTLS_SUPPORTED     2
+
+/**
+ * libmtd - MTD library description data structure.
+ * @sysfs_mtd: MTD directory in sysfs
+ * @mtd: MTD device sysfs directory pattern
+ * @mtd_dev: MTD device major/minor numbers file pattern
+ * @mtd_name: MTD device name file pattern
+ * @mtd_type: MTD device type file pattern
+ * @mtd_eb_size: MTD device eraseblock size file pattern
+ * @mtd_size: MTD device size file pattern
+ * @mtd_min_io_size: minimum I/O unit size file pattern
+ * @mtd_subpage_size: sub-page size file pattern
+ * @mtd_oob_size: MTD device OOB size file pattern
+ * @mtd_region_cnt: count of additional erase regions file pattern
+ * @mtd_flags: MTD device flags file pattern
+ * @sysfs_supported: non-zero if sysfs is supported by MTD
+ * @offs64_ioctls: %OFFS64_IOCTLS_SUPPORTED if 64-bit %MEMERASE64,
+ *                 %MEMREADOOB64, %MEMWRITEOOB64 MTD device ioctls are
+ *                 supported, %OFFS64_IOCTLS_NOT_SUPPORTED if not, and
+ *                 %OFFS64_IOCTLS_UNKNOWN if it is not known yet;
+ *
+ *  Note, we cannot find out whether 64-bit ioctls are supported by MTD when we
+ *  are initializing the library, because this requires an MTD device node.
+ *  Indeed, we have to actually call the ioctl and check for %ENOTTY to find
+ *  out whether it is supported or not.
+ *
+ *  Thus, we leave %offs64_ioctls uninitialized in 'libmtd_open()', and
+ *  initialize it later, when corresponding libmtd function is used, and when
+ *  we actually have a device node and can invoke an ioctl command on it.
+ */
+struct libmtd
+{
+	char *sysfs_mtd;
+	char *mtd;
+	char *mtd_dev;
+	char *mtd_name;
+	char *mtd_type;
+	char *mtd_eb_size;
+	char *mtd_size;
+	char *mtd_min_io_size;
+	char *mtd_subpage_size;
+	char *mtd_oob_size;
+	char *mtd_region_cnt;
+	char *mtd_flags;
+	unsigned int sysfs_supported:1;
+	unsigned int offs64_ioctls:2;
+};
+
+int legacy_libmtd_open(void);
+int legacy_dev_present(int mtd_num);
+int legacy_mtd_get_info(struct mtd_info *info);
+int legacy_get_dev_info(const char *node, struct mtd_dev_info *mtd);
+int legacy_get_dev_info1(int dev_num, struct mtd_dev_info *mtd);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif /* !__LIBMTD_INT_H__ */
diff --git a/oslib/libmtd_legacy.c b/oslib/libmtd_legacy.c
new file mode 100644
index 0000000..38dc2b7
--- /dev/null
+++ b/oslib/libmtd_legacy.c
@@ -0,0 +1,384 @@
+/*
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * Author: Artem Bityutskiy
+ *
+ * This file  is part of the MTD library. Implements pre-2.6.30 kernels support,
+ * where MTD did not have sysfs interface. The main limitation of the old
+ * kernels was that the sub-page size was not exported to user-space, so it was
+ * not possible to get sub-page size.
+ */
+
+/* Imported from mtd-utils by dehrenberg */
+
+#include <limits.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <mtd/mtd-user.h>
+
+#include "libmtd.h"
+#include "libmtd_int.h"
+#include "libmtd_common.h"
+
+#define MTD_PROC_FILE "/proc/mtd"
+#define MTD_DEV_PATT  "/dev/mtd%d"
+#define MTD_DEV_MAJOR 90
+
+#define PROC_MTD_FIRST     "dev:    size   erasesize  name\n"
+#define PROC_MTD_FIRST_LEN (sizeof(PROC_MTD_FIRST) - 1)
+#define PROC_MTD_MAX_LEN   4096
+#define PROC_MTD_PATT      "mtd%d: %llx %x"
+
+/**
+ * struct proc_parse_info - /proc/mtd parsing information.
+ * @mtd_num: MTD device number
+ * @size: device size
+ * @eb_size: eraseblock size
+ * @name: device name
+ * @buf: contents of /proc/mtd
+ * @data_size: how much data was read into @buf
+ * @pos: next string in @buf to parse
+ */
+struct proc_parse_info
+{
+	int mtd_num;
+	long long size;
+	char name[MTD_NAME_MAX + 1];
+	int eb_size;
+	char *buf;
+	int data_size;
+	char *next;
+};
+
+static int proc_parse_start(struct proc_parse_info *pi)
+{
+	int fd, ret;
+
+	fd = open(MTD_PROC_FILE, O_RDONLY);
+	if (fd == -1)
+		return -1;
+
+	pi->buf = xmalloc(PROC_MTD_MAX_LEN);
+
+	ret = read(fd, pi->buf, PROC_MTD_MAX_LEN);
+	if (ret == -1) {
+		sys_errmsg("cannot read \"%s\"", MTD_PROC_FILE);
+		goto out_free;
+	}
+
+	if (ret < PROC_MTD_FIRST_LEN ||
+	    memcmp(pi->buf, PROC_MTD_FIRST, PROC_MTD_FIRST_LEN)) {
+		errmsg("\"%s\" does not start with \"%s\"", MTD_PROC_FILE,
+		       PROC_MTD_FIRST);
+		goto out_free;
+	}
+
+	pi->data_size = ret;
+	pi->next = pi->buf + PROC_MTD_FIRST_LEN;
+
+	close(fd);
+	return 0;
+
+out_free:
+	free(pi->buf);
+	close(fd);
+	return -1;
+}
+
+static int proc_parse_next(struct proc_parse_info *pi)
+{
+	int ret, len, pos = pi->next - pi->buf;
+	char *p, *p1;
+
+	if (pos >= pi->data_size) {
+		free(pi->buf);
+		return 0;
+	}
+
+	ret = sscanf(pi->next, PROC_MTD_PATT, &pi->mtd_num, &pi->size,
+		     &pi->eb_size);
+	if (ret != 3)
+		return errmsg("\"%s\" pattern not found", PROC_MTD_PATT);
+
+	p = memchr(pi->next, '\"', pi->data_size - pos);
+	if (!p)
+		return errmsg("opening \" not found");
+	p += 1;
+	pos = p - pi->buf;
+	if (pos >= pi->data_size)
+		return errmsg("opening \" not found");
+
+	p1 = memchr(p, '\"', pi->data_size - pos);
+	if (!p1)
+		return errmsg("closing \" not found");
+	pos = p1 - pi->buf;
+	if (pos >= pi->data_size)
+		return errmsg("closing \" not found");
+
+	len = p1 - p;
+	if (len > MTD_NAME_MAX)
+		return errmsg("too long mtd%d device name", pi->mtd_num);
+
+	memcpy(pi->name, p, len);
+	pi->name[len] = '\0';
+
+	if (p1[1] != '\n')
+		return errmsg("opening \"\n\" not found");
+	pi->next = p1 + 2;
+	return 1;
+}
+
+/**
+ * legacy_libmtd_open - legacy version of 'libmtd_open()'.
+ *
+ * This function is just checks that MTD is present in the system. Returns
+ * zero in case of success and %-1 in case of failure. In case of failure,
+ * errno contains zero if MTD is not present in the system, or contains the
+ * error code if a real error happened. This is similar to the 'libmtd_open()'
+ * return conventions.
+ */
+int legacy_libmtd_open(void)
+{
+	int fd;
+
+	fd = open(MTD_PROC_FILE, O_RDONLY);
+	if (fd == -1) {
+		if (errno == ENOENT)
+			errno = 0;
+		return -1;
+	}
+
+	close(fd);
+	return 0;
+}
+
+/**
+ * legacy_dev_presentl - legacy version of 'mtd_dev_present()'.
+ * @info: the MTD device information is returned here
+ *
+ * When the kernel does not provide sysfs files for the MTD subsystem,
+ * fall-back to parsing the /proc/mtd file to determine whether an mtd device
+ * number @mtd_num is present.
+ */
+int legacy_dev_present(int mtd_num)
+{
+	int ret;
+	struct proc_parse_info pi;
+
+	ret = proc_parse_start(&pi);
+	if (ret)
+		return -1;
+
+	while (proc_parse_next(&pi)) {
+		if (pi.mtd_num == mtd_num)
+			return 1;
+	}
+
+	return 0;
+}
+
+/**
+ * legacy_mtd_get_info - legacy version of 'mtd_get_info()'.
+ * @info: the MTD device information is returned here
+ *
+ * This function is similar to 'mtd_get_info()' and has the same conventions.
+ */
+int legacy_mtd_get_info(struct mtd_info *info)
+{
+	int ret;
+	struct proc_parse_info pi;
+
+	ret = proc_parse_start(&pi);
+	if (ret)
+		return -1;
+
+	info->lowest_mtd_num = INT_MAX;
+	while (proc_parse_next(&pi)) {
+		info->mtd_dev_cnt += 1;
+		if (pi.mtd_num > info->highest_mtd_num)
+			info->highest_mtd_num = pi.mtd_num;
+		if (pi.mtd_num < info->lowest_mtd_num)
+			info->lowest_mtd_num = pi.mtd_num;
+	}
+
+	return 0;
+}
+
+/**
+ * legacy_get_dev_info - legacy version of 'mtd_get_dev_info()'.
+ * @node: name of the MTD device node
+ * @mtd: the MTD device information is returned here
+ *
+ * This function is similar to 'mtd_get_dev_info()' and has the same
+ * conventions.
+ */
+int legacy_get_dev_info(const char *node, struct mtd_dev_info *mtd)
+{
+	struct stat st;
+	struct mtd_info_user ui;
+	int fd, ret;
+	loff_t offs = 0;
+	struct proc_parse_info pi;
+
+	if (stat(node, &st)) {
+		sys_errmsg("cannot open \"%s\"", node);
+		if (errno == ENOENT)
+			normsg("MTD subsystem is old and does not support "
+			       "sysfs, so MTD character device nodes have "
+			       "to exist");
+	}
+
+	if (!S_ISCHR(st.st_mode)) {
+		errno = EINVAL;
+		return errmsg("\"%s\" is not a character device", node);
+	}
+
+	memset(mtd, '\0', sizeof(struct mtd_dev_info));
+	mtd->major = major(st.st_rdev);
+	mtd->minor = minor(st.st_rdev);
+
+	if (mtd->major != MTD_DEV_MAJOR) {
+		errno = EINVAL;
+		return errmsg("\"%s\" has major number %d, MTD devices have "
+			      "major %d", node, mtd->major, MTD_DEV_MAJOR);
+	}
+
+	mtd->mtd_num = mtd->minor / 2;
+
+	fd = open(node, O_RDONLY);
+	if (fd == -1)
+		return sys_errmsg("cannot open \"%s\"", node);
+
+	if (ioctl(fd, MEMGETINFO, &ui)) {
+		sys_errmsg("MEMGETINFO ioctl request failed");
+		goto out_close;
+	}
+
+	ret = ioctl(fd, MEMGETBADBLOCK, &offs);
+	if (ret == -1) {
+		if (errno != EOPNOTSUPP) {
+			sys_errmsg("MEMGETBADBLOCK ioctl failed");
+			goto out_close;
+		}
+		errno = 0;
+		mtd->bb_allowed = 0;
+	} else
+		mtd->bb_allowed = 1;
+
+	mtd->type = ui.type;
+	mtd->size = ui.size;
+	mtd->eb_size = ui.erasesize;
+	mtd->min_io_size = ui.writesize;
+	mtd->oob_size = ui.oobsize;
+
+	if (mtd->min_io_size <= 0) {
+		errmsg("mtd%d (%s) has insane min. I/O unit size %d",
+		       mtd->mtd_num, node, mtd->min_io_size);
+		goto out_close;
+	}
+	if (mtd->eb_size <= 0 || mtd->eb_size < mtd->min_io_size) {
+		errmsg("mtd%d (%s) has insane eraseblock size %d",
+		       mtd->mtd_num, node, mtd->eb_size);
+		goto out_close;
+	}
+	if (mtd->size <= 0 || mtd->size < mtd->eb_size) {
+		errmsg("mtd%d (%s) has insane size %lld",
+		       mtd->mtd_num, node, mtd->size);
+		goto out_close;
+	}
+	mtd->eb_cnt = mtd->size / mtd->eb_size;
+
+	switch(mtd->type) {
+	case MTD_ABSENT:
+		errmsg("mtd%d (%s) is removable and is not present",
+		       mtd->mtd_num, node);
+		goto out_close;
+	case MTD_RAM:
+		strcpy((char *)mtd->type_str, "ram");
+		break;
+	case MTD_ROM:
+		strcpy((char *)mtd->type_str, "rom");
+		break;
+	case MTD_NORFLASH:
+		strcpy((char *)mtd->type_str, "nor");
+		break;
+	case MTD_NANDFLASH:
+		strcpy((char *)mtd->type_str, "nand");
+		break;
+	case MTD_MLCNANDFLASH:
+		strcpy((char *)mtd->type_str, "mlc-nand");
+		break;
+	case MTD_DATAFLASH:
+		strcpy((char *)mtd->type_str, "dataflash");
+		break;
+	case MTD_UBIVOLUME:
+		strcpy((char *)mtd->type_str, "ubi");
+		break;
+	default:
+		goto out_close;
+	}
+
+	if (ui.flags & MTD_WRITEABLE)
+		mtd->writable = 1;
+	mtd->subpage_size = mtd->min_io_size;
+
+	close(fd);
+
+	/*
+	 * Unfortunately, the device name is not available via ioctl, and
+	 * we have to parse /proc/mtd to get it.
+	 */
+	ret = proc_parse_start(&pi);
+	if (ret)
+		return -1;
+
+	while (proc_parse_next(&pi)) {
+		if (pi.mtd_num == mtd->mtd_num) {
+			strcpy((char *)mtd->name, pi.name);
+			return 0;
+		}
+	}
+
+	errmsg("mtd%d not found in \"%s\"", mtd->mtd_num, MTD_PROC_FILE);
+	errno = ENOENT;
+	return -1;
+
+out_close:
+	close(fd);
+	return -1;
+}
+
+/**
+ * legacy_get_dev_info1 - legacy version of 'mtd_get_dev_info1()'.
+ * @node: name of the MTD device node
+ * @mtd: the MTD device information is returned here
+ *
+ * This function is similar to 'mtd_get_dev_info1()' and has the same
+ * conventions.
+ */
+int legacy_get_dev_info1(int mtd_num, struct mtd_dev_info *mtd)
+{
+	char node[sizeof(MTD_DEV_PATT) + 20];
+
+	sprintf(node, MTD_DEV_PATT, mtd_num);
+	return legacy_get_dev_info(node, mtd);
+}
diff --git a/oslib/libmtd_xalloc.h b/oslib/libmtd_xalloc.h
new file mode 100644
index 0000000..532b80f
--- /dev/null
+++ b/oslib/libmtd_xalloc.h
@@ -0,0 +1,106 @@
+/*
+ * memory wrappers
+ *
+ * Copyright (c) Artem Bityutskiy, 2007, 2008
+ * Copyright 2001, 2002 Red Hat, Inc.
+ *           2001 David A. Schleef <ds@lineo.com>
+ *           2002 Axis Communications AB
+ *           2001, 2002 Erik Andersen <andersen@codepoet.org>
+ *           2004 University of Szeged, Hungary
+ *           2006 KaiGai Kohei <kaigai@ak.jp.nec.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef __MTD_UTILS_XALLOC_H__
+#define __MTD_UTILS_XALLOC_H__
+
+#include <stdarg.h>
+#include <stdlib.h>
+#include <string.h>
+
+/*
+ * Mark these functions as unused so that gcc does not emit warnings
+ * when people include this header but don't use every function.
+ */
+
+__attribute__((unused))
+static void *xmalloc(size_t size)
+{
+	void *ptr = malloc(size);
+
+	if (ptr == NULL && size != 0)
+		sys_errmsg_die("out of memory");
+	return ptr;
+}
+
+__attribute__((unused))
+static void *xcalloc(size_t nmemb, size_t size)
+{
+	void *ptr = calloc(nmemb, size);
+
+	if (ptr == NULL && nmemb != 0 && size != 0)
+		sys_errmsg_die("out of memory");
+	return ptr;
+}
+
+__attribute__((unused))
+static void *xzalloc(size_t size)
+{
+	return xcalloc(1, size);
+}
+
+__attribute__((unused))
+static void *xrealloc(void *ptr, size_t size)
+{
+	ptr = realloc(ptr, size);
+	if (ptr == NULL && size != 0)
+		sys_errmsg_die("out of memory");
+	return ptr;
+}
+
+__attribute__((unused))
+static char *xstrdup(const char *s)
+{
+	char *t;
+
+	if (s == NULL)
+		return NULL;
+	t = strdup(s);
+	if (t == NULL)
+		sys_errmsg_die("out of memory");
+	return t;
+}
+
+#ifdef _GNU_SOURCE
+
+__attribute__((unused))
+static int xasprintf(char **strp, const char *fmt, ...)
+{
+	int cnt;
+	va_list ap;
+
+	va_start(ap, fmt);
+	cnt = vasprintf(strp, fmt, ap);
+	va_end(ap);
+
+	if (cnt == -1)
+		sys_errmsg_die("out of memory");
+
+	return cnt;
+}
+#endif
+
+#endif /* !__MTD_UTILS_XALLOC_H__ */
diff --git a/oslib/linux-dev-lookup.c b/oslib/linux-dev-lookup.c
new file mode 100644
index 0000000..4d5f356
--- /dev/null
+++ b/oslib/linux-dev-lookup.c
@@ -0,0 +1,66 @@
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <dirent.h>
+#include <string.h>
+#include <stdio.h>
+#include <unistd.h>
+
+#include "../os/os.h"
+
+int blktrace_lookup_device(const char *redirect, char *path, unsigned int maj,
+			   unsigned int min)
+{
+	struct dirent *dir;
+	struct stat st;
+	int found = 0;
+	DIR *D;
+
+	D = opendir(path);
+	if (!D)
+		return 0;
+
+	while ((dir = readdir(D)) != NULL) {
+		char full_path[256];
+
+		if (!strcmp(dir->d_name, ".") || !strcmp(dir->d_name, ".."))
+			continue;
+
+		sprintf(full_path, "%s%s%s", path, FIO_OS_PATH_SEPARATOR, dir->d_name);
+		if (lstat(full_path, &st) == -1) {
+			perror("lstat");
+			break;
+		}
+
+		if (S_ISDIR(st.st_mode)) {
+			found = blktrace_lookup_device(redirect, full_path,
+								maj, min);
+			if (found) {
+				strcpy(path, full_path);
+				break;
+			}
+		}
+
+		if (!S_ISBLK(st.st_mode))
+			continue;
+
+		/*
+		 * If replay_redirect is set then always return this device
+		 * upon lookup which overrides the device lookup based on
+		 * major minor in the actual blktrace
+		 */
+		if (redirect) {
+			strcpy(path, redirect);
+			found = 1;
+			break;
+		}
+
+		if (maj == major(st.st_rdev) && min == minor(st.st_rdev)) {
+			strcpy(path, full_path);
+			found = 1;
+			break;
+		}
+	}
+
+	closedir(D);
+	return found;
+}
diff --git a/oslib/linux-dev-lookup.h b/oslib/linux-dev-lookup.h
new file mode 100644
index 0000000..144f33a
--- /dev/null
+++ b/oslib/linux-dev-lookup.h
@@ -0,0 +1,7 @@
+#ifndef LINUX_DEV_LOOKUP
+#define LINUX_DEV_LOOKUP
+
+int blktrace_lookup_device(const char *redirect, char *path, unsigned int maj,
+			   unsigned int min);
+
+#endif
diff --git a/oslib/strcasestr.c b/oslib/strcasestr.c
new file mode 100644
index 0000000..92cf24c
--- /dev/null
+++ b/oslib/strcasestr.c
@@ -0,0 +1,25 @@
+#include <ctype.h>
+#include <stddef.h>
+
+char *strcasestr(const char *s1, const char *s2)
+{
+	const char *s = s1;
+	const char *p = s2;
+
+	do {
+		if (!*p)
+			return (char *) s1;
+		if ((*p == *s) ||
+		    (tolower(*p) == tolower(*s))) {
+			++p;
+			++s;
+		} else {
+			p = s2;
+			if (!*s)
+				return NULL;
+			s = ++s1;
+		}
+	} while (1);
+
+	return *p ? NULL : (char *) s1;
+}
diff --git a/oslib/strcasestr.h b/oslib/strcasestr.h
new file mode 100644
index 0000000..43d61df
--- /dev/null
+++ b/oslib/strcasestr.h
@@ -0,0 +1,13 @@
+#ifdef CONFIG_STRCASESTR
+
+#include <string.h>
+
+#else
+
+#ifndef FIO_STRCASESTR_H
+#define FIO_STRCASESTR_H
+
+char *strcasestr(const char *haystack, const char *needle);
+
+#endif
+#endif
diff --git a/oslib/strlcat.c b/oslib/strlcat.c
new file mode 100644
index 0000000..643d496
--- /dev/null
+++ b/oslib/strlcat.c
@@ -0,0 +1,23 @@
+#include <string.h>
+
+size_t strlcat(char *dst, const char *src, size_t size)
+{
+	size_t dstlen;
+	size_t srclen;
+
+	dstlen = strlen(dst);
+	size -= dstlen + 1;
+
+	/* return if no room */
+	if (!size)
+		return dstlen;
+
+	srclen = strlen(src);
+	if (srclen > size)
+		srclen = size;
+
+	memcpy(dst + dstlen, src, srclen);
+	dst[dstlen + srclen] = '\0';
+
+	return dstlen + srclen;
+}
diff --git a/oslib/strlcat.h b/oslib/strlcat.h
new file mode 100644
index 0000000..baeace4
--- /dev/null
+++ b/oslib/strlcat.h
@@ -0,0 +1,6 @@
+#ifndef FIO_STRLCAT_H
+#define FIO_STRLCAT_H
+
+size_t strlcat(char *dst, const char *src, size_t size);
+
+#endif
diff --git a/oslib/strsep.c b/oslib/strsep.c
new file mode 100644
index 0000000..b71e9f7
--- /dev/null
+++ b/oslib/strsep.c
@@ -0,0 +1,29 @@
+#include <stdio.h>
+
+char *strsep(char **stringp, const char *delim)
+{
+	char *s, *tok;
+	const char *spanp;
+	int c, sc;
+
+	s = *stringp;
+	if (!s)
+		return NULL;
+
+	tok = s;
+	do {
+		c = *s++;
+		spanp = delim;
+		do {
+			sc = *spanp++;
+			if (sc == c) {
+				if (c == 0)
+					s = NULL;
+				else
+					s[-1] = 0;
+				*stringp = s;
+				return tok;
+			}
+		} while (sc != 0);
+	} while (1);
+}
diff --git a/oslib/strsep.h b/oslib/strsep.h
new file mode 100644
index 0000000..5fea5d1
--- /dev/null
+++ b/oslib/strsep.h
@@ -0,0 +1,6 @@
+#ifndef FIO_STRSEP_LIB_H
+#define FIO_STRSEP_LIB_H
+
+char *strsep(char **, const char *);
+
+#endif
diff --git a/stat.c b/stat.c
index da3ad2a..e5ec223 100644
--- a/stat.c
+++ b/stat.c
@@ -18,6 +18,16 @@
 
 struct fio_mutex *stat_mutex;
 
+void clear_rusage_stat(struct thread_data *td)
+{
+	struct thread_stat *ts = &td->ts;
+
+	fio_getrusage(&td->ru_start);
+	ts->usr_time = ts->sys_time = 0;
+	ts->ctx = 0;
+	ts->minf = ts->majf = 0;
+}
+
 void update_rusage_stat(struct thread_data *td)
 {
 	struct thread_stat *ts = &td->ts;
diff --git a/stat.h b/stat.h
index e289c2e..0fc5533 100644
--- a/stat.h
+++ b/stat.h
@@ -183,9 +183,9 @@ struct thread_stat {
 	uint32_t io_u_plat[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR];
 	uint32_t pad;
 
-	uint64_t total_io_u[3];
-	uint64_t short_io_u[3];
-	uint64_t drop_io_u[3];
+	uint64_t total_io_u[DDIR_RWDIR_CNT];
+	uint64_t short_io_u[DDIR_RWDIR_CNT];
+	uint64_t drop_io_u[DDIR_RWDIR_CNT];
 	uint64_t total_submit;
 	uint64_t total_complete;
 
@@ -267,6 +267,23 @@ extern void stat_calc_lat_m(struct thread_stat *ts, double *io_u_lat);
 extern void stat_calc_lat_u(struct thread_stat *ts, double *io_u_lat);
 extern void stat_calc_dist(unsigned int *map, unsigned long total, double *io_u_dist);
 extern void reset_io_stats(struct thread_data *);
+extern void update_rusage_stat(struct thread_data *);
+extern void clear_rusage_stat(struct thread_data *);
+
+extern void add_lat_sample(struct thread_data *, enum fio_ddir, unsigned long,
+				unsigned int, uint64_t);
+extern void add_clat_sample(struct thread_data *, enum fio_ddir, unsigned long,
+				unsigned int, uint64_t);
+extern void add_slat_sample(struct thread_data *, enum fio_ddir, unsigned long,
+				unsigned int, uint64_t);
+extern void add_bw_sample(struct thread_data *, enum fio_ddir, unsigned int,
+				struct timeval *);
+extern void add_iops_sample(struct thread_data *, enum fio_ddir, unsigned int,
+				struct timeval *);
+extern void add_agg_sample(unsigned long, enum fio_ddir, unsigned int);
+
+extern struct io_log *agg_io_log[DDIR_RWDIR_CNT];
+extern int write_bw_log;
 
 static inline int usec_to_msec(unsigned long *min, unsigned long *max,
 			       double *mean, double *dev)
diff --git a/t/btrace2fio.c b/t/btrace2fio.c
index 04b6abe..c589cea 100644
--- a/t/btrace2fio.c
+++ b/t/btrace2fio.c
@@ -12,7 +12,7 @@
 #include "../blktrace_api.h"
 #include "../os/os.h"
 #include "../log.h"
-#include "../lib/linux-dev-lookup.h"
+#include "../oslib/linux-dev-lookup.h"
 
 #define TRACE_FIFO_SIZE	8192
 
diff --git a/t/dedupe.c b/t/dedupe.c
index 5b88fcb..e1cea50 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -21,7 +21,7 @@
 #include "../smalloc.h"
 #include "../minmax.h"
 #include "../crc/md5.h"
-#include "../memalign.h"
+#include "../lib/memalign.h"
 #include "../os/os.h"
 #include "../gettime.h"
 #include "../fio_time.h"
