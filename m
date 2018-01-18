Return-Path: <fio-owner@vger.kernel.org>
Received: from g2t2353.austin.hpe.com ([15.233.44.26]:34140 "EHLO
        g2t2353.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932166AbeARXxy (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 18 Jan 2018 18:53:54 -0500
Received: from g2t2360.austin.hpecorp.net (g2t2360.austin.hpecorp.net [16.196.225.135])
        by g2t2353.austin.hpe.com (Postfix) with ESMTP id 43B1565
        for <fio@vger.kernel.org>; Thu, 18 Jan 2018 23:53:54 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH 3/3] ioengines: add memtest workloads for ioengines using mmap
Date: Thu, 18 Jan 2018 17:53:47 -0600
Message-Id: <20180118235347.30370-4-elliott@hpe.com>
In-Reply-To: <20180118235347.30370-1-elliott@hpe.com>
References: <20180118235347.30370-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

From: Robert Elliott <elliott@hpe.com>

Add memtest workloads for an ioengine using mmap to run within
the memory mapped region (not to/from another transfer buffer in
regular memory).  Useful for persistent memory testing.

Tests include:
  memcpy = copy with libc memcpy() (d = s)(one read, one write)
  memscan = read memory to registers (one read)
  memset = write memory from registers with libc memset() (one write)
  wmemset = write memory from registers with libc wmemset() (one write)
  streamcopy = STREAM copy (d = s)(one read, one write)
  streamadd = STREAM add (d = s1 + s2)(two reads, add, one write)
  streamscale = STREAM scale (d = 3 * s1)(one read, multiply, one write)
  streamtriad = STREAM triad (d = s1 + 3 * s2)(two reads, add and multiply, one write)

NOTE: memscan function is x86-specific, not ready for inclusion yet.
---
 HOWTO            |  37 ++++++++++++++++
 debug.h          |   1 +
 engines/mmap.c   | 127 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 fio.1            |  37 ++++++++++++++++
 init.c           |   4 ++
 io_ddir.h        |  27 ++++++++++--
 io_u.c           |   3 +-
 io_u.h           |   9 +++-
 options.c        |  91 +++++++++++++++++++++++++++++++++++++++
 thread_options.h |   7 +++
 10 files changed, 334 insertions(+), 9 deletions(-)

diff --git a/HOWTO b/HOWTO
index 78fa6ccf..b2d0c69e 100644
--- a/HOWTO
+++ b/HOWTO
@@ -992,6 +992,9 @@ I/O type
 				Sequential writes.
 		**trim**
 				Sequential trims (Linux block devices only).
+		**memtest**
+				Memory test (ioengines using mmap only).
+				Specified with memtest=.
 		**randread**
 				Random reads.
 		**randwrite**
@@ -1019,6 +1022,40 @@ I/O type
 	For instance, using ``rw=write:4k`` will skip 4k for every write.  Also see
 	the :option:`rw_sequencer` option.
 
+.. option:: memtest=str
+
+	Type of memory test to perform if rw=memtest is specified.
+	For use with ioengines supporting mmap() - performs the tests within the
+	memory mapped region.  Useful for persistent memory testing.
+
+	Accepted values are:
+
+		**memcpy**
+				copy with libc memcpy() (d = s)(one read, one write)
+		**memscan** (default)
+				read memory to registers (one read)
+		**memset**
+				write memory from registers with libc memset() (one write)
+		**wmemset**
+				write memory from registers with libc wmemset() (one write)
+		**streamcopy**
+				STREAM copy (d = s)(one read, one write)
+		**streamadd**
+				STREAM add (d = s1 + s2)(two reads, add, one write)
+		**streamscale**
+				STREAM scale (d = 3 * s1)(one read, multiply, one write)
+		**streamtriad**
+				STREAM triad (d = s1 + 3 * s2)(two reads, add and multiply, one write)
+
+	If library functions are provided by glibc, memcpy() honors this
+	environment variable:
+		export GLIBC_TUNABLES=glibc.tune.x86_non_temporal_threshold=131072
+	to select the threshold for choosing non-temporal stores (e.g., vmovnt)
+	rather than normal stores (e.g., rep movsb).
+
+	Additional tunables might also be needed:
+		export GLIBC_TUNABLES=glibc.tune.x86_non_temporal_threshold=131072:glibc.tune.hwcaps=AVX2_Usable,ERMS,-Prefer_No_VZEROUPPER,AVX_Fast_Unaligned_Load
+
 .. option:: rw_sequencer=str
 
 	If an offset modifier is given by appending a number to the ``rw=<str>``
diff --git a/debug.h b/debug.h
index e3aa3f18..e7b176c6 100644
--- a/debug.h
+++ b/debug.h
@@ -23,6 +23,7 @@ enum {
 	FD_COMPRESS,
 	FD_STEADYSTATE,
 	FD_HELPERTHREAD,
+	FD_MEMTEST,
 	FD_DEBUG_MAX,
 };
 
diff --git a/engines/mmap.c b/engines/mmap.c
index 54b5b11d..edc59f50 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -10,7 +10,9 @@
 #include <unistd.h>
 #include <errno.h>
 #include <sys/mman.h>
+#include <wchar.h>
 
+#include "../lib/memcpy.h"
 #include "../fio.h"
 #include "../verify.h"
 
@@ -34,7 +36,9 @@ static int fio_mmap_file(struct thread_data *td, struct fio_file *f,
 	int prot = 0;
 	int flags = MAP_SHARED;
 
-	if (td_rw(td) && !td->o.verify_only)
+	if (td->o.td_memtest)
+		prot = PROT_READ | PROT_WRITE;
+	else if (td_rw(td) && !td->o.verify_only)
 		prot = PROT_READ | PROT_WRITE;
 	else if (td_write(td) && !td->o.verify_only) {
 		prot = PROT_WRITE;
@@ -44,7 +48,12 @@ static int fio_mmap_file(struct thread_data *td, struct fio_file *f,
 	} else
 		prot = PROT_READ;
 
+	if (td->o.use_map_populate)
+		flags |= MAP_POPULATE;
 	fmd->mmap_ptr = mmap(NULL, length, prot, flags, f->fd, off);
+	dprint(FD_MEMTEST,
+	       "mmap addr=%p len=0x%lx=%ld off=0x%lx=%ld prot=0x%x flags=0x%x\n",
+	       fmd->mmap_ptr, length, length, off, off, prot, flags);
 	if (fmd->mmap_ptr == MAP_FAILED) {
 		fmd->mmap_ptr = NULL;
 		td_verror(td, errno, "mmap");
@@ -163,6 +172,30 @@ done:
 	return 0;
 }
 
+/* read from memory to register (don't write to memory) */
+static void memtoreg(uint64_t const *p, size_t len)
+{
+	uint64_t localreg = 0;
+        uint64_t ptmp = (uint64_t)p;
+	uint64_t end = (uint64_t)p + len / 8;
+
+	/* read 0x8 bytes per pass */
+	__asm__ __volatile__(
+		"loop:\n\t"
+		"mov 0(%[ptmp]), %[localreg]\n\t"
+		"add $0x8, %[ptmp]\n\t"
+		"cmp %[ptmp], %[end]\n\t"
+		"jne loop"
+		/* Output operands */
+		:"=r" (localreg)
+		/* Input operands */
+		:[localreg] "0" (localreg),
+		 [ptmp] "rp" (ptmp),
+		 [end] "r" (end)
+		/* Clobbered registers after another : */
+	);
+}
+
 static int fio_mmapio_queue(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
@@ -170,7 +203,95 @@ static int fio_mmapio_queue(struct thread_data *td, struct io_u *io_u)
 
 	fio_ro_check(td, io_u);
 
-	if (io_u->ddir == DDIR_READ)
+	if (io_u->memtest == TD_MEMTEST_MEMSCAN) {
+		/* presence of this keeps the compiler from optimizing away memtoreg() */
+		uint32_t volatile result = 0;
+
+		dprint(FD_MEMTEST, "memscan %p len=0x%lx\n",
+		       io_u->mmap_data, io_u->xfer_buflen);
+		memtoreg(io_u->mmap_data, io_u->xfer_buflen);
+	} else if (io_u->memtest == TD_MEMTEST_MEMSET) {
+		dprint(FD_MEMTEST, "memset %p len=0x%lx\n",
+		       io_u->mmap_data, io_u->xfer_buflen);
+		memset(io_u->mmap_data, 0x00, io_u->xfer_buflen);
+	} else if (io_u->memtest == TD_MEMTEST_WMEMSET) {
+		dprint(FD_MEMTEST, "wmemset %p len=0x%lx\n",
+		       io_u->mmap_data, io_u->xfer_buflen);
+		wmemset(io_u->mmap_data, 0x00, io_u->xfer_buflen / sizeof(wchar_t));
+
+// HACKHACK
+#define PAGE_SIZE 4096
+
+	} else if (io_u->memtest == TD_MEMTEST_MEMCPY) {
+		size_t len = io_u->xfer_buflen / 2;
+		void *dst = io_u->mmap_data;
+		void *src = io_u->mmap_data + len;
+
+		dprint(FD_MEMTEST, "memcpy dst=%p src=%p len=0x%lx\n", dst, src, len);
+
+		// FIXFIX this doesn't work here, must be done before the process makes
+		// any memcpy() calls (first call selects the function to use)
+		if (td->o.use_glibc_nt) {
+			char ntstr[96];
+			int err;
+
+			// 1 = off (huge threshold)
+			// 2 = on (low threshold)
+			snprintf(ntstr, sizeof ntstr,
+				 "GLIBC_TUNABLES=glibc.tune.x86_non_temporal_threshold=%lu",
+				 (td->o.use_glibc_nt == 1)? len * 2: 0);
+
+			err = putenv(ntstr);
+			if (err)
+				dprint(FD_MEMTEST, "error setting GLIBC_TUNABLES=%s\n", ntstr);
+			else
+				dprint(FD_MEMTEST, "setting GLIBC_TUNABLES=%s\n", ntstr);
+		}
+		memcpy(dst, src, io_u->xfer_buflen / 2);
+		unsetenv("GLIBC_TUNABLES");
+	} else if (io_u->memtest == TD_MEMTEST_STREAM_COPY) {
+		size_t len = io_u->xfer_buflen / 2;
+		void *dst = io_u->mmap_data;
+		void *src = io_u->mmap_data + len;
+
+		dprint(FD_MEMTEST, "streamcopy dst=%p src=%p len=0x%lx\n",
+		       dst, src, len);
+		streamcopy(dst, src, io_u->xfer_buflen / 2);
+	} else if (io_u->memtest == TD_MEMTEST_STREAM_SCALE) {
+		size_t len = io_u->xfer_buflen / 2;
+		void *dst = io_u->mmap_data;
+		void *src = io_u->mmap_data + len;
+
+		dprint(FD_MEMTEST, "streamscale dst=%p src=%p len=0x%lx\n",
+		       dst, src, len);
+		streamscale(dst, src, io_u->xfer_buflen / 2);
+	} else if (io_u->memtest == TD_MEMTEST_STREAM_ADD) {
+		size_t len = (io_u->xfer_buflen / 3) & ~(PAGE_SIZE - 1);
+		void *dst = io_u->mmap_data;
+		void *src1 = PTR_ALIGN(io_u->mmap_data + len, PAGE_SIZE);
+		void *src2 = PTR_ALIGN(io_u->mmap_data + 2 * len, PAGE_SIZE);
+
+		dprint(FD_MEMTEST,
+		       "streamadd     dst=%p src1=%p src2=%p len=0x%lx=%ld\n",
+		       dst, src1, src2, len, len);
+		dprint(FD_MEMTEST,
+		       "streamadd rel dst=0x%lx src1=0x%lx src2=0x%lx\n",
+		       dst - dst, src1 - dst, src2 - dst);
+		streamadd(dst, src1, src2, len);
+	} else if (io_u->memtest == TD_MEMTEST_STREAM_TRIAD) {
+		size_t len = (io_u->xfer_buflen / 3) & ~(PAGE_SIZE - 1);
+		void *dst = io_u->mmap_data;
+		void *src1 = PTR_ALIGN(io_u->mmap_data + len, PAGE_SIZE);
+		void *src2 = PTR_ALIGN(io_u->mmap_data + 2 * len, PAGE_SIZE);
+
+		dprint(FD_MEMTEST,
+		       "streamtriad     dst=%p src1=%p src2=%p len=0x%lx=%ld\n",
+		       dst, src1, src2, len, len);
+		dprint(FD_MEMTEST,
+		       "streamtriad rel dst=0x%lx src1=0x%lx src2=0x%lx\n",
+		       dst - dst, src1 - dst, src2 - dst);
+		streamtriad(dst, src1, src2, len);
+	} else if (io_u->ddir == DDIR_READ)
 		memcpy(io_u->xfer_buf, io_u->mmap_data, io_u->xfer_buflen);
 	else if (io_u->ddir == DDIR_WRITE)
 		memcpy(io_u->mmap_data, io_u->xfer_buf, io_u->xfer_buflen);
@@ -186,7 +307,6 @@ static int fio_mmapio_queue(struct thread_data *td, struct io_u *io_u)
 			td_verror(td, io_u->error, "trim");
 	}
 
-
 	/*
 	 * not really direct, but should drop the pages from the cache
 	 */
@@ -216,6 +336,7 @@ static int fio_mmapio_init(struct thread_data *td)
 	}
 
 	mmap_map_size = MMAP_TOTAL_SZ / o->nr_files;
+
 	return 0;
 }
 
diff --git a/fio.1 b/fio.1
index 70eeeb0f..7672e9e7 100644
--- a/fio.1
+++ b/fio.1
@@ -769,6 +769,9 @@ Random writes.
 .B randtrim
 Random trims (Linux block devices only).
 .TP
+.B memtest
+Memory test (for ioengines using mmap only).
+.TP
 .B rw,readwrite
 Sequential mixed reads and writes.
 .TP
@@ -818,6 +821,40 @@ behaves in a similar fashion, except it sends the same offset 8 number of
 times before generating a new offset.
 .RE
 .TP
+.BI memtest \fR=\fPstr "\fR
+Type of memory test to perform if rw=memtest is specified.
+For use with ioengines supporting mmap() - performs the tests within the
+mapped region.  Useful for persistent memory testing.
+Accepted values are:
+.RS
+.RS
+.TP
+.B memcpy
+.thcopy with libc memcpy() (d = s)(one read, one write)
+.TP
+.B memscan (default)
+read memory to registers (one read)
+.TP
+.B memset
+write memory from registers with libc memset() (one write)
+.TP
+.B wmemset
+write memory from registers with libc wmemset() (one write)
+.TP
+.B streamcopy
+STREAM copy (d = s)(one read, one write)
+.TP
+.B streamadd
+STREAM add (d = s1 + s2)(two reads, add, one write)
+.TP
+.B streamscale
+STREAM scale (d = 3 * s1)(one read, multiply, one write)
+.TP
+.B streamtriad
+STREAM triad (d = s1 + 3 * s2)(two reads, add and multiply, one write)
+.RE
+.RE
+.TP
 .BI unified_rw_reporting \fR=\fPbool
 Fio normally reports statistics on a per data direction basis, meaning that
 reads, writes, and trims are accounted and reported separately. If this
diff --git a/init.c b/init.c
index 8a801383..78167a47 100644
--- a/init.c
+++ b/init.c
@@ -2251,6 +2251,10 @@ struct debug_level debug_levels[] = {
 	  .help = "Helper thread logging",
 	  .shift = FD_HELPERTHREAD,
 	},
+	{ .name = "mmap",
+	  .help = "mmap-based memory test logging",
+	  .shift = FD_MEMTEST,
+	},
 	{ .name = NULL, },
 };
 
diff --git a/io_ddir.h b/io_ddir.h
index 613d5fbc..0b0a0139 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -37,6 +37,7 @@ enum td_ddir {
 	TD_DDIR_RANDRW		= TD_DDIR_RW | TD_DDIR_RAND,
 	TD_DDIR_RANDTRIM	= TD_DDIR_TRIM | TD_DDIR_RAND,
 	TD_DDIR_TRIMWRITE	= TD_DDIR_TRIM | TD_DDIR_WRITE,
+	TD_DDIR_LAST		= TD_DDIR_TRIMWRITE + 1
 };
 
 #define td_read(td)		((td)->o.td_ddir & TD_DDIR_READ)
@@ -61,14 +62,32 @@ static inline int ddir_rw(enum fio_ddir ddir)
 
 static inline const char *ddir_str(enum td_ddir ddir)
 {
-	static const char *__str[] = { NULL, "read", "write", "rw", "rand",
-				"randread", "randwrite", "randrw",
-				"trim", NULL, "trimwrite", NULL, "randtrim" };
+	static const char *__str[] = {
+		NULL, "read", "write", "rw",			// 0x0 - 0x3
+		"rand", "randread", "randwrite", "randrw",	// 0x4 - 0x7 RAND
+		NULL, NULL, "trimwrite", NULL,			// 0x8 - 0xB TRIM
+		"randtrim", NULL, NULL, NULL,			// 0xC - 0xF RAND, TRIM
+	};
 
-	return __str[ddir];
+	if (ddir < TD_DDIR_LAST)
+		return __str[ddir];
+	else
+		return NULL;
 }
 
 #define ddir_rw_sum(arr)	\
 	((arr)[DDIR_READ] + (arr)[DDIR_WRITE] + (arr)[DDIR_TRIM])
 
+enum td_memtest {
+	TD_MEMTEST_MEMCPY,
+	TD_MEMTEST_MEMSCAN,
+	TD_MEMTEST_MEMSET,
+	TD_MEMTEST_WMEMSET,
+	TD_MEMTEST_STREAM_COPY,
+	TD_MEMTEST_STREAM_ADD,
+	TD_MEMTEST_STREAM_SCALE,
+	TD_MEMTEST_STREAM_TRIAD,
+};
+
 #endif
+
diff --git a/io_u.c b/io_u.c
index 1d6872ed..738801a1 100644
--- a/io_u.c
+++ b/io_u.c
@@ -968,6 +968,7 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	if (td_ioengine_flagged(td, FIO_NOIO))
 		goto out;
 
+	io_u->memtest = td->o.td_memtest;
 	set_rw_ddir(td, io_u);
 
 	/*
@@ -1791,7 +1792,7 @@ struct io_u *get_io_u(struct thread_data *td)
 		f->last_start[io_u->ddir] = io_u->offset;
 		f->last_pos[io_u->ddir] = io_u->offset + io_u->buflen;
 
-		if (io_u->ddir == DDIR_WRITE) {
+		if (io_u->ddir == DDIR_WRITE && !io_u->memtest) {
 			if (td->flags & TD_F_REFILL_BUFFERS) {
 				io_u_fill_buffer(td, io_u,
 					td->o.min_bs[DDIR_WRITE],
diff --git a/io_u.h b/io_u.h
index da25efb9..4d39a10b 100644
--- a/io_u.h
+++ b/io_u.h
@@ -37,6 +37,7 @@ struct io_u {
 	struct fio_file *file;
 	unsigned int flags;
 	enum fio_ddir ddir;
+	unsigned int memtest;
 
 	/*
 	 * For replay workloads, we may want to account as a different
@@ -152,7 +153,13 @@ static inline void dprint_io_u(struct io_u *io_u, const char *p)
 {
 	struct fio_file *f = io_u->file;
 
-	if (f)
+	if (f && io_u->memtest)
+		dprint(FD_IO, "%s: io_u %p: off=0x%llx,len=0x%lx,ddir=%d,memtest=%d,file=%s\n",
+				p, io_u,
+				(unsigned long long) io_u->offset,
+				io_u->buflen, io_u->ddir, io_u->memtest,
+				f->file_name);
+	else if (f)
 		dprint(FD_IO, "%s: io_u %p: off=0x%llx,len=0x%lx,ddir=%d,file=%s\n",
 				p, io_u,
 				(unsigned long long) io_u->offset,
diff --git a/options.c b/options.c
index 9a3431d8..e6b214e1 100644
--- a/options.c
+++ b/options.c
@@ -409,6 +409,14 @@ static int str_rw_cb(void *data, const char *str)
 	return 0;
 }
 
+static int str_memtest_cb(void *data, const char *str)
+{
+	//struct thread_data *td = cb_data_to_td(data);
+	//struct thread_options *o = &td->o;
+
+	return 0;
+}
+
 static int str_mem_cb(void *data, const char *mem)
 {
 	struct thread_data *td = cb_data_to_td(data);
@@ -1534,6 +1542,19 @@ static int rw_verify(struct fio_option *o, void *data)
 	return 0;
 }
 
+// FIXFIX add more checks
+static int memtest_verify(struct fio_option *o, void *data)
+{
+	struct thread_data *td = cb_data_to_td(data);
+
+	if (read_only && td_write(td)) {
+		log_err("fio: job <%s> has write bit set, but fio is in read-only mode\n", td->o.name);
+		return 1;
+	}
+
+	return 0;
+}
+
 static int gtod_cpu_verify(struct fio_option *o, void *data)
 {
 #ifndef FIO_HAVE_CPU_AFFINITY
@@ -1685,6 +1706,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = TD_DDIR_TRIM,
 			    .help = "Sequential trim",
 			  },
+			  { .ival = "memtest",
+			    .oval = TD_DDIR_WRITE,	// assume both directions for accounting
+			    .help = "Memory test for mmap engines (specify with memtest option)",
+			  },
 			  { .ival = "randread",
 			    .oval = TD_DDIR_RANDREAD,
 			    .help = "Random read",
@@ -1715,6 +1740,72 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			  },
 		},
 	},
+	{
+		.name	= "memtest",
+		.lname	= "memory test for ioengines using mmap()",
+		.type	= FIO_OPT_STR,
+		.cb	= str_memtest_cb,
+		.off1	= offsetof(struct thread_options, td_memtest),
+		.help	= "memory test within the mmap() region of the specified file or device",
+		.def	= "memscan",
+		.verify	= memtest_verify,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_IO_BASIC,
+		.posval = {
+			  { .ival = "memcpy",
+			    .oval = TD_MEMTEST_MEMCPY,
+			    .help = "copy with libc memcpy() (d = s)(one read, one write)",
+			  },
+			  { .ival = "memscan",
+			    .oval = TD_MEMTEST_MEMSCAN,
+			    .help = "read memory to registers (one read)",
+			  },
+			  { .ival = "memset",
+			    .oval = TD_MEMTEST_MEMSET,
+			    .help = "write memory from registers with libc memset() (one write)",
+			  },
+			  { .ival = "wmemset",
+			    .oval = TD_MEMTEST_WMEMSET,
+			    .help = "write memory from registers with libc wmemset() (one write)",
+			  },
+			  { .ival = "streamcopy",
+			    .oval = TD_MEMTEST_STREAM_COPY,
+			    .help = "STREAM copy (d = s)(one read, one write)",
+			  },
+			  { .ival = "streamadd",
+			    .oval = TD_MEMTEST_STREAM_ADD,
+			    .help = "STREAM add (d = s1 + s2)(two reads, add, one write)",
+			  },
+			  { .ival = "streamscale",
+			    .oval = TD_MEMTEST_STREAM_SCALE,
+			    .help = "STREAM scale (d = 3 * s1)(one read, multiply, one write)",
+			  },
+			  { .ival = "streamtriad",
+			    .oval = TD_MEMTEST_STREAM_TRIAD,
+			    .help = "STREAM triad (d = s1 + 3 * s2)(two reads, add and multiply, one write)",
+			  },
+		},
+	},
+	{
+		.name	= "mmap_populate",
+		.lname	= "mmap MAP_POPULATE",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct thread_options, use_map_populate),
+		.help	= "Use MAP_POPULATE on mmap() calls",
+		.def	= 0,
+		.category = FIO_OPT_C_GENERAL,
+		.group	= FIO_OPT_G_IO_BASIC,
+	},
+	{
+		.name	= "memtest_nt",
+		.lname	= "memtest non-temporal GLIBC tunable",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct thread_options, use_glibc_nt),
+		.help	= "Set GLIBC_TUNABLES nontemporal threshold below the transfer size (0=natural, 1=force temporal, 2=force NT)",
+		.def	= 0,
+		.category = FIO_OPT_C_GENERAL,
+		.group	= FIO_OPT_G_IO_BASIC,
+	},
 	{
 		.name	= "rw_sequencer",
 		.lname	= "RW Sequencer",
diff --git a/thread_options.h b/thread_options.h
index dc290b0b..ee51e898 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -58,6 +58,7 @@ struct thread_options {
 	char *ioengine_so_path;
 	char *mmapfile;
 	enum td_ddir td_ddir;
+	enum td_memtest td_memtest;
 	unsigned int rw_seq;
 	unsigned int kb_base;
 	unsigned int unit_base;
@@ -191,6 +192,8 @@ struct thread_options {
 	unsigned long long lockmem;
 	enum fio_memtype mem_type;
 	unsigned int mem_align;
+	unsigned int use_map_populate;
+	unsigned int use_glibc_nt;
 
 	unsigned long long max_latency;
 
@@ -338,6 +341,8 @@ struct thread_options_pack {
 	uint8_t ioengine[FIO_TOP_STR_MAX];
 	uint8_t mmapfile[FIO_TOP_STR_MAX];
 	uint32_t td_ddir;
+	uint32_t td_memtest;
+	uint32_t reserved;
 	uint32_t rw_seq;
 	uint32_t kb_base;
 	uint32_t unit_base;
@@ -469,6 +474,8 @@ struct thread_options_pack {
 	uint64_t lockmem;
 	uint32_t mem_type;
 	uint32_t mem_align;
+	uint32_t use_map_populate;
+	uint32_t use_glibc_nt;
 
 	uint32_t stonewall;
 	uint32_t new_group;
-- 
2.14.3

