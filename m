Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39192 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937013AbdD0MAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Apr 2017 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1d3i5c-0004z1-CV
        for fio@vger.kernel.org; Thu, 27 Apr 2017 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170427120003.349912C1711@kernel.dk>
Date: Thu, 27 Apr 2017 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 306fea38fa61c305703d0269b1fc8e7da3b91a1f:

  stat: make next log time decision cleaner (2017-04-25 18:14:00 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4bd2c8b9251a2c88f44ad52168252ce2de660bf7:

  configure: fix broken test for cuda (2017-04-26 15:24:36 -0600)

----------------------------------------------------------------
Jens Axboe (8):
      stat: cleanup iops/bw logging functions
      seqlock: add simple user space code for sequence locks
      Merge branch 'gpudirect' of https://github.com/yufeiren/fio
      gpu: ensure that we convert gpu_dev_id options
      gpu: kill a lot of useless ifdefs
      server: bump protocol version
      thread_options: kill two unused pads
      configure: fix broken test for cuda

Tomohiro Kusumi (9):
      Fix num2str() output when modulo != -1U
      Drop the only local variable declaration within a for-loop (C99)
      Make lib/strntol.c a stand-alone library
      Make lib/pattern.c a stand-alone library
      Make lib/rand.c a stand-alone library
      Make lib/zipf.c a stand-alone library
      Make lib/mountcheck.c a stand-alone library
      Make oslib/strlcat.c a stand-alone library
      Make oslib/linux-dev-lookup.c a stand-alone library

Yufei Ren (1):
      GPUDirect RDMA support

 HOWTO                                |   3 +
 cconv.c                              |   2 +
 configure                            |  24 +++++++-
 examples/gpudirect-rdmaio-client.fio |  15 +++++
 examples/gpudirect-rdmaio-server.fio |  12 ++++
 fio.1                                |   3 +
 fio.h                                |  16 ++++++
 init.c                               |   3 +
 io_u.c                               |   5 ++
 lib/mountcheck.c                     |   2 +-
 lib/num2str.c                        |  34 ++++++-----
 lib/pattern.c                        |   9 ++-
 lib/rand.c                           |   2 +-
 lib/seqlock.h                        |  48 ++++++++++++++++
 lib/strntol.c                        |   2 +-
 lib/zipf.c                           |   1 -
 memory.c                             |  76 +++++++++++++++++++++++++
 options.c                            |  18 ++++++
 oslib/linux-dev-lookup.c             |   3 +-
 oslib/strlcat.c                      |   2 +-
 parse.c                              |   3 +-
 server.h                             |   2 +-
 stat.c                               | 107 +++++++++++------------------------
 thread_options.h                     |   7 ++-
 24 files changed, 298 insertions(+), 101 deletions(-)
 create mode 100644 examples/gpudirect-rdmaio-client.fio
 create mode 100644 examples/gpudirect-rdmaio-server.fio
 create mode 100644 lib/seqlock.h

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index ffdcb75..d9e881a 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1468,6 +1468,9 @@ Buffers and memory
 		**mmapshared**
 			Same as mmap, but use a MMAP_SHARED mapping.
 
+		**cudamalloc**
+			Use GPU memory as the buffers for GPUDirect RDMA benchmark.
+
 	The area allocated is a function of the maximum allowed bs size for the job,
 	multiplied by the I/O depth given. Note that for **shmhuge** and
 	**mmaphuge** to work, the system must have free huge pages allocated. This
diff --git a/cconv.c b/cconv.c
index 886140d..3295824 100644
--- a/cconv.c
+++ b/cconv.c
@@ -235,6 +235,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->new_group = le32_to_cpu(top->new_group);
 	o->numjobs = le32_to_cpu(top->numjobs);
 	o->cpus_allowed_policy = le32_to_cpu(top->cpus_allowed_policy);
+	o->gpu_dev_id = le32_to_cpu(top->gpu_dev_id);
 	o->iolog = le32_to_cpu(top->iolog);
 	o->rwmixcycle = le32_to_cpu(top->rwmixcycle);
 	o->nice = le32_to_cpu(top->nice);
@@ -420,6 +421,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->new_group = cpu_to_le32(o->new_group);
 	top->numjobs = cpu_to_le32(o->numjobs);
 	top->cpus_allowed_policy = cpu_to_le32(o->cpus_allowed_policy);
+	top->gpu_dev_id = cpu_to_le32(o->gpu_dev_id);
 	top->iolog = cpu_to_le32(o->iolog);
 	top->rwmixcycle = cpu_to_le32(o->rwmixcycle);
 	top->nice = cpu_to_le32(o->nice);
diff --git a/configure b/configure
index f42489b..83a6702 100755
--- a/configure
+++ b/configure
@@ -186,6 +186,8 @@ for opt do
   ;;
   --disable-pmem) disable_pmem="yes"
   ;;
+  --enable-cuda) enable_cuda="yes"
+  ;;
   --help)
     show_help="yes"
     ;;
@@ -206,7 +208,7 @@ if test "$show_help" = "yes" ; then
   echo "--esx                   Configure build options for esx"
   echo "--enable-gfio           Enable building of gtk gfio"
   echo "--disable-numa          Disable libnuma even if found"
-  echo "--disable-rdma         Disable RDMA support even if found"
+  echo "--disable-rdma          Disable RDMA support even if found"
   echo "--disable-gfapi         Disable gfapi"
   echo "--enable-libhdfs        Enable hdfs support"
   echo "--disable-lex           Disable use of lex/yacc for math"
@@ -214,6 +216,7 @@ if test "$show_help" = "yes" ; then
   echo "--enable-lex            Enable use of lex/yacc for math"
   echo "--disable-shm           Disable SHM support"
   echo "--disable-optimizations Don't enable compiler optimizations"
+  echo "--enable-cuda           Enable GPUDirect RDMA support"
   exit $exit_val
 fi
 
@@ -1990,6 +1993,21 @@ EOF
 fi
 echo "march_armv8_a_crc_crypto      $march_armv8_a_crc_crypto"
 
+##########################################
+# cuda probe
+cuda="no"
+cat > $TMPC << EOF
+#include <cuda.h>
+int main(int argc, char **argv)
+{
+  return cuInit(0);
+}
+EOF
+if test "$enable_cuda" = "yes" && compile_prog "" "-lcuda" "cuda"; then
+  cuda="yes"
+  LIBS="-lcuda $LIBS"
+fi
+echo "cuda                          $cuda"
 
 #############################################################################
 
@@ -2210,10 +2228,12 @@ fi
 if test "$disable_opt" = "yes" ; then
   output_sym "CONFIG_DISABLE_OPTIMIZATIONS"
 fi
-
 if test "$zlib" = "no" ; then
   echo "Consider installing zlib-dev (zlib-devel), some fio features depend on it."
 fi
+if test "$cuda" = "yes" ; then
+  output_sym "CONFIG_CUDA"
+fi
 
 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "GFIO_LIBS+=$GFIO_LIBS" >> $config_host_mak
diff --git a/examples/gpudirect-rdmaio-client.fio b/examples/gpudirect-rdmaio-client.fio
new file mode 100644
index 0000000..1e24624
--- /dev/null
+++ b/examples/gpudirect-rdmaio-client.fio
@@ -0,0 +1,15 @@
+# Example gpudirect rdma client job
+[global]
+ioengine=rdma
+hostname=[hostname]
+port=[port]
+verb=[read/write/send/recv]
+mem=cudamalloc
+gpu_dev_id=0
+bs=1m
+size=100g
+
+[sender]
+rw=write
+iodepth=1
+iodepth_batch_complete=1
diff --git a/examples/gpudirect-rdmaio-server.fio b/examples/gpudirect-rdmaio-server.fio
new file mode 100644
index 0000000..5fc4950
--- /dev/null
+++ b/examples/gpudirect-rdmaio-server.fio
@@ -0,0 +1,12 @@
+# Example rdma server job
+[global]
+ioengine=rdma
+port=[port]
+mem=cudamalloc
+gpu_dev_id=0
+bs=1m
+size=100g
+
+[receiver]
+rw=read
+iodepth=16
diff --git a/fio.1 b/fio.1
index b59025d..138bcbb 100644
--- a/fio.1
+++ b/fio.1
@@ -1309,6 +1309,9 @@ Same as \fBmmap\fR, but use huge files as backing.
 .TP
 .B mmapshared
 Same as \fBmmap\fR, but use a MMAP_SHARED mapping.
+.TP
+.B cudamalloc
+Use GPU memory as the buffers for GPUDirect RDMA benchmark. The ioengine must be \fBrdma\fR.
 .RE
 .P
 The amount of memory allocated is the maximum allowed \fBblocksize\fR for the
diff --git a/fio.h b/fio.h
index b67613e..6b2b669 100644
--- a/fio.h
+++ b/fio.h
@@ -59,6 +59,10 @@
 #define MPOL_LOCAL MPOL_MAX
 #endif
 
+#ifdef CONFIG_CUDA
+#include <cuda.h>
+#endif
+
 /*
  * offset generator types
  */
@@ -408,6 +412,18 @@ struct thread_data {
 	struct steadystate_data ss;
 
 	char verror[FIO_VERROR_SIZE];
+
+#ifdef CONFIG_CUDA
+	/*
+	 * for GPU memory management
+	 */
+	int gpu_dev_cnt;
+	int gpu_dev_id;
+	CUdevice  cu_dev;
+	CUcontext cu_ctx;
+	CUdeviceptr dev_mem_ptr;
+#endif	
+
 };
 
 /*
diff --git a/init.c b/init.c
index 9aa452d..52a5f03 100644
--- a/init.c
+++ b/init.c
@@ -1070,6 +1070,9 @@ static void init_flags(struct thread_data *td)
 
 	if (o->verify_async || o->io_submit_mode == IO_MODE_OFFLOAD)
 		td->flags |= TD_F_NEED_LOCK;
+
+	if (o->mem_type == MEM_CUDA_MALLOC)
+		td->flags &= ~TD_F_SCRAMBLE_BUFFERS;
 }
 
 static int setup_random_seeds(struct thread_data *td)
diff --git a/io_u.c b/io_u.c
index 88f35c9..fd63119 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1674,8 +1674,10 @@ out:
 	if (!td_io_prep(td, io_u)) {
 		if (!td->o.disable_lat)
 			fio_gettime(&io_u->start_time, NULL);
+
 		if (do_scramble)
 			small_content_scramble(io_u);
+
 		return io_u;
 	}
 err_put:
@@ -2043,6 +2045,9 @@ void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
 {
 	struct thread_options *o = &td->o;
 
+	if (o->mem_type == MEM_CUDA_MALLOC)
+		return;
+
 	if (o->compress_percentage || o->dedupe_percentage) {
 		unsigned int perc = td->o.compress_percentage;
 		struct frand_state *rs;
diff --git a/lib/mountcheck.c b/lib/mountcheck.c
index 0aec744..2fb6fe7 100644
--- a/lib/mountcheck.c
+++ b/lib/mountcheck.c
@@ -4,7 +4,7 @@
 #ifdef CONFIG_GETMNTENT
 #include <mntent.h>
 
-#include "lib/mountcheck.h"
+#include "mountcheck.h"
 
 #define MTAB	"/etc/mtab"
 
diff --git a/lib/num2str.c b/lib/num2str.c
index 448d3ff..8d08841 100644
--- a/lib/num2str.c
+++ b/lib/num2str.c
@@ -10,7 +10,7 @@
 /**
  * num2str() - Cheesy number->string conversion, complete with carry rounding error.
  * @num: quantity (e.g., number of blocks, bytes or bits)
- * @maxlen: max number of digits in the output string (not counting prefix and units)
+ * @maxlen: max number of digits in the output string (not counting prefix and units, but counting .)
  * @base: multiplier for num (e.g., if num represents Ki, use 1024)
  * @pow2: select unit prefix - 0=power-of-10 decimal SI, nonzero=power-of-2 binary IEC
  * @units: select units - N2S_* macros defined in num2str.h
@@ -23,9 +23,9 @@ char *num2str(uint64_t num, int maxlen, int base, int pow2, int units)
 	const char **unitprefix;
 	const char *unitstr[] = { "", "/s", "B", "bit", "B/s", "bit/s" };
 	const unsigned int thousand[] = { 1000, 1024 };
-	unsigned int modulo, decimals;
+	unsigned int modulo;
 	int unit_index = 0, post_index, carry = 0;
-	char tmp[32];
+	char tmp[32], fmt[32];
 	char *buf;
 
 	compiletime_assert(sizeof(sistr) == sizeof(iecstr), "unit prefix arrays must be identical sizes");
@@ -62,6 +62,9 @@ char *num2str(uint64_t num, int maxlen, int base, int pow2, int units)
 		break;
 	}
 
+	/*
+	 * Divide by K/Ki until string length of num <= maxlen.
+	 */
 	modulo = -1U;
 	while (post_index < sizeof(sistr)) {
 		sprintf(tmp, "%llu", (unsigned long long) num);
@@ -74,6 +77,9 @@ char *num2str(uint64_t num, int maxlen, int base, int pow2, int units)
 		post_index++;
 	}
 
+	/*
+	 * If no modulo, then we're done.
+	 */
 	if (modulo == -1U) {
 done:
 		if (post_index >= ARRAY_SIZE(sistr))
@@ -84,23 +90,25 @@ done:
 		return buf;
 	}
 
+	/*
+	 * If no room for decimals, then we're done.
+	 */
 	sprintf(tmp, "%llu", (unsigned long long) num);
-	decimals = maxlen - strlen(tmp);
-	if ((int)decimals <= 1) {
+	if ((int)(maxlen - strlen(tmp)) <= 1) {
 		if (carry)
 			num++;
 		goto done;
 	}
 
-	do {
-		sprintf(tmp, "%u", modulo);
-		if (strlen(tmp) <= decimals - 1)
-			break;
-
-		modulo = (modulo + 9) / 10;
-	} while (1);
+	/*
+	 * Fill in everything and return the result.
+	 */
+	assert(maxlen - strlen(tmp) - 1 > 0);
+	assert(modulo < thousand[!!pow2]);
+	sprintf(fmt, "%%.%df", (int)(maxlen - strlen(tmp) - 1));
+	sprintf(tmp, fmt, (double)modulo / (double)thousand[!!pow2]);
 
-	sprintf(buf, "%llu.%u%s%s", (unsigned long long) num, modulo,
+	sprintf(buf, "%llu.%s%s%s", (unsigned long long) num, &tmp[2],
 			unitprefix[post_index], unitstr[unit_index]);
 	return buf;
 }
diff --git a/lib/pattern.c b/lib/pattern.c
index b8ae809..0aeb935 100644
--- a/lib/pattern.c
+++ b/lib/pattern.c
@@ -1,6 +1,13 @@
-#include "fio.h"
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <limits.h>
+#include <errno.h>
+#include <assert.h>
+
 #include "strntol.h"
 #include "pattern.h"
+#include "../minmax.h"
 #include "../oslib/strcasestr.h"
 
 /**
diff --git a/lib/rand.c b/lib/rand.c
index 9c3e0d6..3f60a67 100644
--- a/lib/rand.c
+++ b/lib/rand.c
@@ -36,7 +36,7 @@
 #include <string.h>
 #include <assert.h>
 #include "rand.h"
-#include "lib/pattern.h"
+#include "pattern.h"
 #include "../hash.h"
 
 int arch_random;
diff --git a/lib/seqlock.h b/lib/seqlock.h
new file mode 100644
index 0000000..1ac1eb6
--- /dev/null
+++ b/lib/seqlock.h
@@ -0,0 +1,48 @@
+#ifndef FIO_SEQLOCK_H
+#define FIO_SEQLOCK_H
+
+#include "../arch/arch.h"
+
+struct seqlock {
+	volatile int sequence;
+};
+
+static inline void seqlock_init(struct seqlock *s)
+{
+	s->sequence = 0;
+}
+
+static inline unsigned int read_seqlock_begin(struct seqlock *s)
+{
+	unsigned int seq;
+
+	do {
+		seq = s->sequence;
+		if (!(seq & 1))
+			break;
+		nop;
+	} while (1);
+
+	read_barrier();
+	return seq;
+}
+
+static inline bool read_seqlock_retry(struct seqlock *s, unsigned int seq)
+{
+	read_barrier();
+	return s->sequence != seq;
+}
+
+static inline void write_seqlock_begin(struct seqlock *s)
+{
+	s->sequence++;
+	write_barrier();
+}
+
+static inline void write_seqlock_end(struct seqlock *s)
+{
+	write_barrier();
+	s->sequence++;
+}
+
+#endif
diff --git a/lib/strntol.c b/lib/strntol.c
index adf45bd..f622c8d 100644
--- a/lib/strntol.c
+++ b/lib/strntol.c
@@ -2,7 +2,7 @@
 #include <stdlib.h>
 #include <limits.h>
 
-#include "lib/strntol.h"
+#include "strntol.h"
 
 long strntol(const char *str, size_t sz, char **end, int base)
 {
diff --git a/lib/zipf.c b/lib/zipf.c
index 681df70..3d535c7 100644
--- a/lib/zipf.c
+++ b/lib/zipf.c
@@ -6,7 +6,6 @@
 #include <sys/types.h>
 #include <fcntl.h>
 #include "ieee754.h"
-#include "../log.h"
 #include "zipf.h"
 #include "../minmax.h"
 #include "../hash.h"
diff --git a/memory.c b/memory.c
index 9e73f10..22a7f5d 100644
--- a/memory.c
+++ b/memory.c
@@ -207,6 +207,78 @@ static void free_mem_malloc(struct thread_data *td)
 	free(td->orig_buffer);
 }
 
+static int alloc_mem_cudamalloc(struct thread_data *td, size_t total_mem)
+{
+#ifdef CONFIG_CUDA
+	CUresult ret;
+	char name[128];
+
+	ret = cuInit(0);
+	if (ret != CUDA_SUCCESS) {
+		log_err("fio: failed initialize cuda driver api\n");
+		return 1;
+	}
+
+	ret = cuDeviceGetCount(&td->gpu_dev_cnt);
+	if (ret != CUDA_SUCCESS) {
+		log_err("fio: failed get device count\n");
+		return 1;
+	}
+	dprint(FD_MEM, "found %d GPU devices\n", td->gpu_dev_cnt);
+
+	if (td->gpu_dev_cnt == 0) {
+		log_err("fio: no GPU device found. "
+			"Can not perform GPUDirect RDMA.\n");
+		return 1;
+	}
+
+	td->gpu_dev_id = td->o.gpu_dev_id;
+	ret = cuDeviceGet(&td->cu_dev, td->gpu_dev_id);
+	if (ret != CUDA_SUCCESS) {
+		log_err("fio: failed get GPU device\n");
+		return 1;
+	}
+
+	ret = cuDeviceGetName(name, sizeof(name), td->gpu_dev_id);
+	if (ret != CUDA_SUCCESS) {
+		log_err("fio: failed get device name\n");
+		return 1;
+	}
+	dprint(FD_MEM, "dev_id = [%d], device name = [%s]\n", \
+	       td->gpu_dev_id, name);
+
+	ret = cuCtxCreate(&td->cu_ctx, CU_CTX_MAP_HOST, td->cu_dev);
+	if (ret != CUDA_SUCCESS) {
+		log_err("fio: failed to create cuda context: %d\n", ret);
+		return 1;
+	}
+
+	ret = cuMemAlloc(&td->dev_mem_ptr, total_mem);
+	if (ret != CUDA_SUCCESS) {
+		log_err("fio: cuMemAlloc %zu bytes failed\n", total_mem);
+		return 1;
+	}
+	td->orig_buffer = (void *) td->dev_mem_ptr;
+
+	dprint(FD_MEM, "cudaMalloc %llu %p\n",				\
+	       (unsigned long long) total_mem, td->orig_buffer);
+	return 0;
+#else
+	return -EINVAL;
+#endif
+}
+
+static void free_mem_cudamalloc(struct thread_data *td)
+{
+#ifdef CONFIG_CUDA
+	if (td->dev_mem_ptr != NULL)
+		cuMemFree(td->dev_mem_ptr);
+
+	if (cuCtxDestroy(td->cu_ctx) != CUDA_SUCCESS)
+		log_err("fio: failed to destroy cuda context\n");
+#endif
+}
+
 /*
  * Set up the buffer area we need for io.
  */
@@ -246,6 +318,8 @@ int allocate_io_mem(struct thread_data *td)
 	else if (td->o.mem_type == MEM_MMAP || td->o.mem_type == MEM_MMAPHUGE ||
 		 td->o.mem_type == MEM_MMAPSHARED)
 		ret = alloc_mem_mmap(td, total_mem);
+	else if (td->o.mem_type == MEM_CUDA_MALLOC)
+		ret = alloc_mem_cudamalloc(td, total_mem);
 	else {
 		log_err("fio: bad mem type: %d\n", td->o.mem_type);
 		ret = 1;
@@ -275,6 +349,8 @@ void free_io_mem(struct thread_data *td)
 	else if (td->o.mem_type == MEM_MMAP || td->o.mem_type == MEM_MMAPHUGE ||
 		 td->o.mem_type == MEM_MMAPSHARED)
 		free_mem_mmap(td, total_mem);
+	else if (td->o.mem_type == MEM_CUDA_MALLOC)
+		free_mem_cudamalloc(td);
 	else
 		log_err("Bad memory type %u\n", td->o.mem_type);
 
diff --git a/options.c b/options.c
index e0deab0..85574d7 100644
--- a/options.c
+++ b/options.c
@@ -2604,6 +2604,12 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "Like mmap, but use huge pages",
 			  },
 #endif
+#ifdef CONFIG_CUDA
+			  { .ival = "cudamalloc",
+			    .oval = MEM_CUDA_MALLOC,
+			    .help = "Allocate GPU device memory for GPUDirect RDMA",
+			  },
+#endif
 		  },
 	},
 	{
@@ -3563,6 +3569,18 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.help	= "Build fio with libnuma-dev(el) to enable this option",
 	},
 #endif
+#ifdef CONFIG_CUDA
+	{
+		.name	= "gpu_dev_id",
+		.lname	= "GPU device ID",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, gpu_dev_id),
+		.help	= "Set GPU device ID for GPUDirect RDMA",
+		.def    = "0",
+		.category = FIO_OPT_C_GENERAL,
+		.group	= FIO_OPT_G_INVALID,
+	},
+#endif
 	{
 		.name	= "end_fsync",
 		.lname	= "End fsync",
diff --git a/oslib/linux-dev-lookup.c b/oslib/linux-dev-lookup.c
index 2bbd14a..5fbccd3 100644
--- a/oslib/linux-dev-lookup.c
+++ b/oslib/linux-dev-lookup.c
@@ -5,8 +5,7 @@
 #include <stdio.h>
 #include <unistd.h>
 
-#include "../os/os.h"
-#include "oslib/linux-dev-lookup.h"
+#include "linux-dev-lookup.h"
 
 int blktrace_lookup_device(const char *redirect, char *path, unsigned int maj,
 			   unsigned int min)
diff --git a/oslib/strlcat.c b/oslib/strlcat.c
index 3329b83..3b33d0e 100644
--- a/oslib/strlcat.c
+++ b/oslib/strlcat.c
@@ -1,5 +1,5 @@
 #include <string.h>
-#include "oslib/strlcat.h"
+#include "strlcat.h"
 
 size_t strlcat(char *dst, const char *src, size_t size)
 {
diff --git a/parse.c b/parse.c
index fd5605f..4d4fddd 100644
--- a/parse.c
+++ b/parse.c
@@ -135,6 +135,7 @@ static unsigned long long get_mult_time(const char *str, int len,
 	const char *p = str;
 	char *c;
 	unsigned long long mult = 1;
+	int i;
 
 	/*
          * Go forward until we hit a non-digit, or +/- sign
@@ -153,7 +154,7 @@ static unsigned long long get_mult_time(const char *str, int len,
 	}
 
 	c = strdup(p);
-	for (int i = 0; i < strlen(c); i++)
+	for (i = 0; i < strlen(c); i++)
 		c[i] = tolower(c[i]);
 
 	if (!strncmp("us", c, 2) || !strncmp("usec", c, 4))
diff --git a/server.h b/server.h
index 798d5a8..5c720d4 100644
--- a/server.h
+++ b/server.h
@@ -49,7 +49,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 60,
+	FIO_SERVER_VER			= 61,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.c b/stat.c
index 27d1fea..f3b82cf 100644
--- a/stat.c
+++ b/stat.c
@@ -2427,19 +2427,21 @@ void add_bw_sample(struct thread_data *td, struct io_u *io_u,
 	td_io_u_unlock(td);
 }
 
-static int add_bw_samples(struct thread_data *td, struct timeval *t)
+static int __add_samples(struct thread_data *td, struct timeval *parent_tv,
+			 struct timeval *t, unsigned int avg_time,
+			 uint64_t *this_io_bytes, uint64_t *stat_io_bytes,
+			 struct io_stat *stat, struct io_log *log,
+			 bool is_kb)
 {
-	struct thread_stat *ts = &td->ts;
 	unsigned long spent, rate;
 	enum fio_ddir ddir;
 	unsigned int next, next_log;
 
-	next_log = td->o.bw_avg_time;
+	next_log = avg_time;
 
-	spent = mtime_since(&td->bw_sample_time, t);
-	if (spent < td->o.bw_avg_time &&
-	    td->o.bw_avg_time - spent >= LOG_MSEC_SLACK)
-		return td->o.bw_avg_time - spent;
+	spent = mtime_since(parent_tv, t);
+	if (spent < avg_time && avg_time - spent >= LOG_MSEC_SLACK)
+		return avg_time - spent;
 
 	td_io_u_lock(td);
 
@@ -2449,16 +2451,19 @@ static int add_bw_samples(struct thread_data *td, struct timeval *t)
 	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 		uint64_t delta;
 
-		delta = td->this_io_bytes[ddir] - td->stat_io_bytes[ddir];
+		delta = this_io_bytes[ddir] - stat_io_bytes[ddir];
 		if (!delta)
 			continue; /* No entries for interval */
 
-		if (spent)
-			rate = delta * 1000 / spent / 1024; /* KiB/s */
-		else
+		if (spent) {
+			if (is_kb)
+				rate = delta * 1000 / spent / 1024; /* KiB/s */
+			else
+				rate = (delta * 1000) / spent;
+		} else
 			rate = 0;
 
-		add_stat_sample(&ts->bw_stat[ddir], rate);
+		add_stat_sample(&stat[ddir], rate);
 
 		if (td->bw_log) {
 			unsigned int bs = 0;
@@ -2466,26 +2471,32 @@ static int add_bw_samples(struct thread_data *td, struct timeval *t)
 			if (td->o.min_bs[ddir] == td->o.max_bs[ddir])
 				bs = td->o.min_bs[ddir];
 
-			next = add_log_sample(td, td->bw_log, sample_val(rate),
-					      ddir, bs, 0);
+			next = add_log_sample(td, log, sample_val(rate), ddir, bs, 0);
 			next_log = min(next_log, next);
 		}
 
-		td->stat_io_bytes[ddir] = td->this_io_bytes[ddir];
+		stat_io_bytes[ddir] = this_io_bytes[ddir];
 	}
 
-	timeval_add_msec(&td->bw_sample_time, td->o.bw_avg_time);
+	timeval_add_msec(parent_tv, avg_time);
 
 	td_io_u_unlock(td);
 
-	if (spent <= td->o.bw_avg_time)
-		next = td->o.bw_avg_time;
+	if (spent <= avg_time)
+		next = avg_time;
 	else
-		next = td->o.bw_avg_time - (1 + spent - td->o.bw_avg_time);
+		next = avg_time - (1 + spent - avg_time);
 
 	return min(next, next_log);
 }
 
+static int add_bw_samples(struct thread_data *td, struct timeval *t)
+{
+	return __add_samples(td, &td->bw_sample_time, t, td->o.bw_avg_time,
+				td->this_io_bytes, td->stat_io_bytes,
+				td->ts.bw_stat, td->bw_log, true);
+}
+
 void add_iops_sample(struct thread_data *td, struct io_u *io_u,
 		     unsigned int bytes)
 {
@@ -2505,61 +2516,9 @@ void add_iops_sample(struct thread_data *td, struct io_u *io_u,
 
 static int add_iops_samples(struct thread_data *td, struct timeval *t)
 {
-	struct thread_stat *ts = &td->ts;
-	unsigned long spent, iops;
-	enum fio_ddir ddir;
-	unsigned int next, next_log;
-
-	next_log = td->o.iops_avg_time;
-
-	spent = mtime_since(&td->iops_sample_time, t);
-	if (spent < td->o.iops_avg_time &&
-	    td->o.iops_avg_time - spent >= LOG_MSEC_SLACK)
-		return td->o.iops_avg_time - spent;
-
-	td_io_u_lock(td);
-
-	/*
-	 * Compute both read and write rates for the interval.
-	 */
-	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
-		uint64_t delta;
-
-		delta = td->this_io_blocks[ddir] - td->stat_io_blocks[ddir];
-		if (!delta)
-			continue; /* No entries for interval */
-
-		if (spent)
-			iops = (delta * 1000) / spent;
-		else
-			iops = 0;
-
-		add_stat_sample(&ts->iops_stat[ddir], iops);
-
-		if (td->iops_log) {
-			unsigned int bs = 0;
-
-			if (td->o.min_bs[ddir] == td->o.max_bs[ddir])
-				bs = td->o.min_bs[ddir];
-
-			next = add_log_sample(td, td->iops_log,
-					      sample_val(iops), ddir, bs, 0);
-			next_log = min(next_log, next);
-		}
-
-		td->stat_io_blocks[ddir] = td->this_io_blocks[ddir];
-	}
-
-	timeval_add_msec(&td->iops_sample_time, td->o.iops_avg_time);
-
-	td_io_u_unlock(td);
-
-	if (spent <= td->o.iops_avg_time)
-		next = td->o.iops_avg_time;
-	else
-		next = td->o.iops_avg_time - (1 + spent - td->o.iops_avg_time);
-
-	return min(next, next_log);
+	return __add_samples(td, &td->iops_sample_time, t, td->o.iops_avg_time,
+				td->this_io_blocks, td->stat_io_blocks,
+				td->ts.iops_stat, td->iops_log, false);
 }
 
 /*
diff --git a/thread_options.h b/thread_options.h
index 2b2df33..d0f3fe9 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -20,6 +20,7 @@ enum fio_memtype {
 	MEM_MMAP,	/* use anonynomous mmap */
 	MEM_MMAPHUGE,	/* memory mapped huge file */
 	MEM_MMAPSHARED, /* use mmap with shared flag */
+	MEM_CUDA_MALLOC,/* use GPU memory */
 };
 
 #define ERROR_STR_MAX	128
@@ -198,6 +199,8 @@ struct thread_options {
 	unsigned short numa_mem_mode;
 	unsigned int numa_mem_prefer_node;
 	char *numa_memnodes;
+	unsigned int gpu_dev_id;
+
 	unsigned int iolog;
 	unsigned int rwmixcycle;
 	unsigned int rwmix[DDIR_RWDIR_CNT];
@@ -336,7 +339,6 @@ struct thread_options_pack {
 	uint32_t iodepth_batch;
 	uint32_t iodepth_batch_complete_min;
 	uint32_t iodepth_batch_complete_max;
-	uint32_t __proper_alignment_for_64b;
 
 	uint64_t size;
 	uint64_t io_size;
@@ -411,7 +413,6 @@ struct thread_options_pack {
 	uint32_t bs_unaligned;
 	uint32_t fsync_on_close;
 	uint32_t bs_is_seq_rand;
-	uint32_t pad1;
 
 	uint32_t random_distribution;
 	uint32_t exitall_error;
@@ -467,6 +468,8 @@ struct thread_options_pack {
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
 	uint8_t log_gz_cpumask[FIO_TOP_STR_MAX];
 #endif
+	uint32_t gpu_dev_id;
+	uint32_t pad;
 	uint32_t cpus_allowed_policy;
 	uint32_t iolog;
 	uint32_t rwmixcycle;
