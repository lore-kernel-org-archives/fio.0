Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47839 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbbKJNAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 10 Nov 2015 08:00:03 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Zw8Wo-00036Y-LF
	for fio@vger.kernel.org; Tue, 10 Nov 2015 13:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151110130001.BEF302C00B1@kernel.dk>
Date: Tue, 10 Nov 2015 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9c3e13e3314da394698ca32f21cc46d46b7cfe47:

  smalloc: only clear the bitmap, not the whole pool (2015-11-07 17:33:38 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0127c57b82cfef26149c04b1d785897a68a6dffa:

  smalloc: get rid of global lock (2015-11-09 19:38:15 -0700)

----------------------------------------------------------------
Jens Axboe (6):
      Fixups for poisson rate
      Add poisson rate selection to FD_RATE output
      Provide some consistency in rate_* options
      Rename rate_poisson to rate_process
      Clarify spread/lambda of poisson
      smalloc: get rid of global lock

Song Liu (4):
      Enable request flow under Poisson process
      make sure __rand_0_1 does not return 0.0
      add example using --rate_poisson
      In fio.1 and HOWTO, add link to Poisson process in wikipedia

 HOWTO                                | 13 +++++++--
 backend.c                            | 22 +++++++++++++---
 cconv.c                              |  2 ++
 examples/poisson-rate-submission.fio | 14 ++++++++++
 fio.1                                | 44 ++++++++++++++++++-------------
 fio.h                                |  8 +++++-
 init.c                               |  2 ++
 lib/rand.h                           | 13 +++++++++
 options.c                            | 28 ++++++++++++++++++--
 server.h                             |  2 +-
 smalloc.c                            | 51 +++---------------------------------
 thread_options.h                     |  3 +++
 12 files changed, 127 insertions(+), 75 deletions(-)
 create mode 100644 examples/poisson-rate-submission.fio

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 81217b7..a534aa8 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1049,7 +1049,7 @@ rate=int	Cap the bandwidth used by this job. The number is in bytes/sec,
 		will only limit writes (to 500KB/sec), the latter will only
 		limit reads.
 
-ratemin=int	Tell fio to do whatever it can to maintain at least this
+rate_min=int	Tell fio to do whatever it can to maintain at least this
 		bandwidth. Failing to meet this requirement, will cause
 		the job to exit. The same format as rate is used for
 		read vs write separation.
@@ -1064,6 +1064,15 @@ rate_iops_min=int If fio doesn't meet this rate of IO, it will cause
 		the job to exit. The same format as rate is used for read vs
 		write separation.
 
+rate_process=str	This option controls how fio manages rated IO
+		submissions. The default is 'linear', which submits IO in a
+		linear fashion with fixed delays between IOs that gets
+		adjusted based on IO completion rates. If this is set to
+		'poisson', fio will submit IO based on a more real world
+		random request flow, known as the Poisson process
+		(https://en.wikipedia.org/wiki/Poisson_process). The lambda
+		will be 10^6 / IOPS for the given workload.
+
 latency_target=int	If set, fio will attempt to find the max performance
 		point that the given workload will run at while maintaining a
 		latency below this target. The values is given in microseconds.
@@ -1081,7 +1090,7 @@ latency_percentile=float	The percentage of IOs that must fall within the
 max_latency=int	If set, fio will exit the job if it exceeds this maximum
 		latency. It will exit with an ETIME error.
 
-ratecycle=int	Average bandwidth for 'rate' and 'ratemin' over this number
+rate_cycle=int	Average bandwidth for 'rate' and 'rate_min' over this number
 		of milliseconds.
 
 cpumask=int	Set the CPU affinity of this job. The parameter given is a
diff --git a/backend.c b/backend.c
index 0a42da3..aa94acf 100644
--- a/backend.c
+++ b/backend.c
@@ -35,6 +35,7 @@
 #include <sys/wait.h>
 #include <sys/ipc.h>
 #include <sys/mman.h>
+#include <math.h>
 
 #include "fio.h"
 #ifndef FIO_NO_HAVE_SHM_H
@@ -775,17 +776,30 @@ static int io_complete_bytes_exceeded(struct thread_data *td)
  */
 static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
 {
-	uint64_t secs, remainder, bps, bytes;
+	uint64_t secs, remainder, bps, bytes, iops;
 
 	assert(!(td->flags & TD_F_CHILD));
 	bytes = td->rate_io_issue_bytes[ddir];
 	bps = td->rate_bps[ddir];
-	if (bps) {
+
+	if (td->o.rate_process == RATE_PROCESS_POISSON) {
+		uint64_t val;
+		iops = bps / td->o.bs[ddir];
+		val = (int64_t) (1000000 / iops) *
+				-logf(__rand_0_1(&td->poisson_state));
+		if (val) {
+			dprint(FD_RATE, "poisson rate iops=%llu\n",
+					(unsigned long long) 1000000 / val);
+		}
+		td->last_usec += val;
+		return td->last_usec;
+	} else if (bps) {
 		secs = bytes / bps;
 		remainder = bytes % bps;
 		return remainder * 1000000 / bps + secs * 1000000;
-	} else
-		return 0;
+	}
+
+	return 0;
 }
 
 /*
diff --git a/cconv.c b/cconv.c
index fde8c6d..c309578 100644
--- a/cconv.c
+++ b/cconv.c
@@ -254,6 +254,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->per_job_logs = le32_to_cpu(top->per_job_logs);
 
 	o->trim_backlog = le64_to_cpu(top->trim_backlog);
+	o->rate_process = le32_to_cpu(top->rate_process);
 
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
 		o->percentile_list[i].u.f = fio_uint64_to_double(le64_to_cpu(top->percentile_list[i].u.i));
@@ -474,6 +475,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->trim_backlog = __cpu_to_le64(o->trim_backlog);
 	top->offset_increment = __cpu_to_le64(o->offset_increment);
 	top->number_ios = __cpu_to_le64(o->number_ios);
+	top->rate_process = cpu_to_le32(o->rate_process);
 
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
 		top->percentile_list[i].u.i = __cpu_to_le64(fio_double_to_uint64(o->percentile_list[i].u.f));
diff --git a/examples/poisson-rate-submission.fio b/examples/poisson-rate-submission.fio
new file mode 100644
index 0000000..4bb28f2
--- /dev/null
+++ b/examples/poisson-rate-submission.fio
@@ -0,0 +1,14 @@
+[poisson-rate-submit]
+size=128m
+rw=randread
+ioengine=libaio
+iodepth=32
+direct=1
+# by setting the submit mode to offload, we can guarantee a fixed rate of
+# submission regardless of what the device completion rate is.
+io_submit_mode=offload
+rate_iops=50
+# Real world random request flow follows Poisson process. To give better
+# insight on latency distribution, we simulate request flow under Poisson
+# process.
+rate_process=poisson
diff --git a/fio.1 b/fio.1
index 140c9bb..3cc353a 100644
--- a/fio.1
+++ b/fio.1
@@ -288,7 +288,7 @@ Random trim (Linux block devices only).
 .B rw, readwrite
 Mixed sequential reads and writes.
 .TP
-.B randrw 
+.B randrw
 Mixed random reads and writes.
 .TP
 .B trimwrite
@@ -658,8 +658,8 @@ IO engine that does regular EXT4_IOC_MOVE_EXT ioctls to simulate defragment acti
 request to DDIR_WRITE event
 .TP
 .B rbd
-IO engine supporting direct access to Ceph Rados Block Devices (RBD) via librbd 
-without the need to use the kernel rbd driver. This ioengine defines engine specific 
+IO engine supporting direct access to Ceph Rados Block Devices (RBD) via librbd
+without the need to use the kernel rbd driver. This ioengine defines engine specific
 options.
 .TP
 .B gfapi
@@ -750,7 +750,7 @@ we simply do polling.
 .TP
 .BI iodepth_low \fR=\fPint
 Low watermark indicating when to start filling the queue again.  Default:
-\fBiodepth\fR. 
+\fBiodepth\fR.
 .TP
 .BI io_submit_mode \fR=\fPstr
 This option controls how fio submits the IO to the IO engine. The default is
@@ -948,7 +948,7 @@ limit reads to 1MB/sec and writes to 500KB/sec. Capping only reads or writes
 can be done with \fBrate\fR=,500k or \fBrate\fR=500k,. The former will only
 limit writes (to 500KB/sec), the latter will only limit reads.
 .TP
-.BI ratemin \fR=\fPint
+.BI rate_min \fR=\fPint
 Tell \fBfio\fR to do whatever it can to maintain at least the given bandwidth.
 Failing to meet this requirement will cause the job to exit. The same format
 as \fBrate\fR is used for read vs write separation.
@@ -963,8 +963,17 @@ size is used as the metric.
 If this rate of I/O is not met, the job will exit. The same format as \fBrate\fR
 is used for read vs write separation.
 .TP
-.BI ratecycle \fR=\fPint
-Average bandwidth for \fBrate\fR and \fBratemin\fR over this number of
+.BI rate_process \fR=\fPstr
+This option controls how fio manages rated IO submissions. The default is
+\fBlinear\fR, which submits IO in a linear fashion with fixed delays between
+IOs that gets adjusted based on IO completion rates. If this is set to
+\fBpoisson\fR, fio will submit IO based on a more real world random request
+flow, known as the Poisson process
+(https://en.wikipedia.org/wiki/Poisson_process). The lambda will be
+10^6 / IOPS for the given workload.
+.TP
+.BI rate_cycle \fR=\fPint
+Average bandwidth for \fBrate\fR and \fBrate_min\fR over this number of
 milliseconds.  Default: 1000ms.
 .TP
 .BI latency_target \fR=\fPint
@@ -1280,8 +1289,8 @@ only N blocks before verifying these blocks.
 .BI verify_backlog_batch \fR=\fPint
 Control how many blocks fio will verify if verify_backlog is set. If not set,
 will default to the value of \fBverify_backlog\fR (meaning the entire queue is
-read back and verified).  If \fBverify_backlog_batch\fR is less than 
-\fBverify_backlog\fR then not all blocks will be verified,  if 
+read back and verified).  If \fBverify_backlog_batch\fR is less than
+\fBverify_backlog\fR then not all blocks will be verified,  if
 \fBverify_backlog_batch\fR is larger than \fBverify_backlog\fR,  some blocks
 will be verified more than once.
 .TP
@@ -1320,7 +1329,7 @@ Start a new reporting group.  If not given, all jobs in a file will be part
 of the same reporting group, unless separated by a stonewall.
 .TP
 .BI numjobs \fR=\fPint
-Number of clones (processes/threads performing the same workload) of this job.  
+Number of clones (processes/threads performing the same workload) of this job.
 Default: 1.
 .TP
 .B group_reporting
@@ -1513,8 +1522,8 @@ errors for given error type is separated with ':'.
 Error may be symbol ('ENOSPC', 'ENOMEM') or an integer.
 .br
 Example: ignore_error=EAGAIN,ENOSPC:122 .
-.br	
-This option will ignore EAGAIN from READ, and ENOSPC and 122(EDQUOT) from WRITE. 
+.br
+This option will ignore EAGAIN from READ, and ENOSPC and 122(EDQUOT) from WRITE.
 .TP
 .BI error_dump \fR=\fPbool
 If set dump every error even if it is non fatal, true by default. If disabled
@@ -1687,7 +1696,7 @@ Set the TCP maximum segment size (TCP_MAXSEG).
 File will be used as a block donor (swap extents between files)
 .TP
 .BI (e4defrag,inplace) \fR=\fPint
-Configure donor file block allocation strategy		
+Configure donor file block allocation strategy
 .RS
 .BI 0(default) :
 Preallocate donor's file on init
@@ -1951,7 +1960,7 @@ Disk utilization (1 for each disk used):
 .P
 Error Info (dependent on continue_on_error, default off):
 .RS
-.B total # errors, first error code 
+.B total # errors, first error code
 .RE
 .P
 .B text description (if provided in config - appears on newline)
@@ -2018,7 +2027,7 @@ fio \-\-client=server \-\-remote-config /path/to/file.fio
 Then fio will open this local (to the server) job file instead
 of being passed one from the client.
 
-If you have many servers (example: 100 VMs/containers), you can input a pathname 
+If you have many servers (example: 100 VMs/containers), you can input a pathname
 of a file containing host IPs/names as the parameter value for the \-\-client option.
 For example, here is an example "host.list" file containing 2 hostnames:
 
@@ -2034,8 +2043,8 @@ In this mode, you cannot input server-specific parameters or job files, and all
 servers receive the same job file.
 
 In order to enable fio \-\-client runs utilizing a shared filesystem from multiple hosts,
-fio \-\-client now prepends the IP address of the server to the filename. For example, 
-if fio is using directory /mnt/nfs/fio and is writing filename fileio.tmp, 
+fio \-\-client now prepends the IP address of the server to the filename. For example,
+if fio is using directory /mnt/nfs/fio and is writing filename fileio.tmp,
 with a \-\-client hostfile
 containing two hostnames h1 and h2 with IP addresses 192.168.10.120 and 192.168.10.121, then
 fio will create two files:
@@ -2059,4 +2068,3 @@ See \fBREADME\fR.
 For further documentation see \fBHOWTO\fR and \fBREADME\fR.
 .br
 Sample jobfiles are available in the \fBexamples\fR directory.
-
diff --git a/fio.h b/fio.h
index 5e8ac66..a2b3d9f 100644
--- a/fio.h
+++ b/fio.h
@@ -95,12 +95,16 @@ enum {
 	FIO_RAND_SEQ_RAND_TRIM_OFF,
 	FIO_RAND_START_DELAY,
 	FIO_DEDUPE_OFF,
+	FIO_RAND_POISSON_OFF,
 	FIO_RAND_NR_OFFS,
 };
 
 enum {
 	IO_MODE_INLINE = 0,
-	IO_MODE_OFFLOAD,
+	IO_MODE_OFFLOAD = 1,
+
+	RATE_PROCESS_LINEAR = 0,
+	RATE_PROCESS_POISSON = 1,
 };
 
 /*
@@ -243,6 +247,8 @@ struct thread_data {
 	unsigned long rate_blocks[DDIR_RWDIR_CNT];
 	unsigned long rate_io_issue_bytes[DDIR_RWDIR_CNT];
 	struct timeval lastrate[DDIR_RWDIR_CNT];
+	int64_t last_usec;
+	struct frand_state poisson_state;
 
 	/*
 	 * Enforced rate submission/completion workqueue
diff --git a/init.c b/init.c
index e09872f..04b4a1e 100644
--- a/init.c
+++ b/init.c
@@ -473,6 +473,7 @@ static int __setup_rate(struct thread_data *td, enum fio_ddir ddir)
 
 	td->rate_next_io_time[ddir] = 0;
 	td->rate_io_issue_bytes[ddir] = 0;
+	td->last_usec = 0;
 	return 0;
 }
 
@@ -857,6 +858,7 @@ static void td_fill_rand_seeds_internal(struct thread_data *td, int use64)
 	init_rand_seed(&td->file_size_state, td->rand_seeds[FIO_RAND_FILE_SIZE_OFF], use64);
 	init_rand_seed(&td->trim_state, td->rand_seeds[FIO_RAND_TRIM_OFF], use64);
 	init_rand_seed(&td->delay_state, td->rand_seeds[FIO_RAND_START_DELAY], use64);
+	init_rand_seed(&td->poisson_state, td->rand_seeds[FIO_RAND_POISSON_OFF], 0);
 
 	if (!td_random(td))
 		return;
diff --git a/lib/rand.h b/lib/rand.h
index b99f618..a95bd28 100644
--- a/lib/rand.h
+++ b/lib/rand.h
@@ -104,6 +104,19 @@ static inline uint64_t __rand(struct frand_state *state)
 		return __rand32(&state->state32);
 }
 
+static inline double __rand_0_1(struct frand_state *state)
+{
+	if (state->use64) {
+		uint64_t val = __rand64(&state->state64);
+
+		return (val + 1.0) / (FRAND64_MAX + 1.0);
+	} else {
+		uint32_t val = __rand32(&state->state32);
+
+		return (val + 1.0) / (FRAND32_MAX + 1.0);
+	}
+}
+
 extern void init_rand(struct frand_state *, int);
 extern void init_rand_seed(struct frand_state *, unsigned int seed, int);
 extern void __fill_random_buf(void *buf, unsigned int len, unsigned long seed);
diff --git a/options.c b/options.c
index 5584413..a61606c 100644
--- a/options.c
+++ b/options.c
@@ -2818,7 +2818,8 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_RATE,
 	},
 	{
-		.name	= "ratemin",
+		.name	= "rate_min",
+		.alias	= "ratemin",
 		.lname	= "I/O min rate",
 		.type	= FIO_OPT_INT,
 		.off1	= td_var_offset(ratemin[DDIR_READ]),
@@ -2856,7 +2857,30 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_RATE,
 	},
 	{
-		.name	= "ratecycle",
+		.name	= "rate_process",
+		.lname	= "Rate Process",
+		.type	= FIO_OPT_STR,
+		.off1	= td_var_offset(rate_process),
+		.help	= "What process controls how rated IO is managed",
+		.def	= "linear",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_RATE,
+		.posval = {
+			  { .ival = "linear",
+			    .oval = RATE_PROCESS_LINEAR,
+			    .help = "Linear rate of IO",
+			  },
+			  {
+			    .ival = "poisson",
+			    .oval = RATE_PROCESS_POISSON,
+			    .help = "Rate follows Poisson process",
+			  },
+		},
+		.parent = "rate",
+	},
+	{
+		.name	= "rate_cycle",
+		.alias	= "ratecycle",
 		.lname	= "I/O rate cycle",
 		.type	= FIO_OPT_INT,
 		.off1	= td_var_offset(ratecycle),
diff --git a/server.h b/server.h
index eb29de7..6709b5f 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 47,
+	FIO_SERVER_VER			= 48,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/smalloc.c b/smalloc.c
index 5047cda..b6b367a 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -56,37 +56,6 @@ struct block_hdr {
 static struct pool mp[MAX_POOLS];
 static unsigned int nr_pools;
 static unsigned int last_pool;
-static struct fio_rwlock *lock;
-
-static inline void pool_lock(struct pool *pool)
-{
-	fio_mutex_down(pool->lock);
-}
-
-static inline void pool_unlock(struct pool *pool)
-{
-	fio_mutex_up(pool->lock);
-}
-
-static inline void global_read_lock(void)
-{
-	fio_rwlock_read(lock);
-}
-
-static inline void global_read_unlock(void)
-{
-	fio_rwlock_unlock(lock);
-}
-
-static inline void global_write_lock(void)
-{
-	fio_rwlock_write(lock);
-}
-
-static inline void global_write_unlock(void)
-{
-	fio_rwlock_unlock(lock);
-}
 
 static inline int ptr_valid(struct pool *pool, void *ptr)
 {
@@ -234,8 +203,6 @@ void sinit(void)
 {
 	int i, ret;
 
-	lock = fio_rwlock_init();
-
 	for (i = 0; i < MAX_POOLS; i++) {
 		ret = add_pool(&mp[i], INITIAL_SIZE);
 		if (ret)
@@ -267,9 +234,6 @@ void scleanup(void)
 
 	for (i = 0; i < nr_pools; i++)
 		cleanup_pool(&mp[i]);
-
-	if (lock)
-		fio_rwlock_remove(lock);
 }
 
 #ifdef SMALLOC_REDZONE
@@ -338,12 +302,12 @@ static void sfree_pool(struct pool *pool, void *ptr)
 	i = offset / SMALLOC_BPL;
 	idx = (offset % SMALLOC_BPL) / SMALLOC_BPB;
 
-	pool_lock(pool);
+	fio_mutex_down(pool->lock);
 	clear_blocks(pool, i, idx, size_to_blocks(hdr->size));
 	if (i < pool->next_non_full)
 		pool->next_non_full = i;
 	pool->free_blocks += size_to_blocks(hdr->size);
-	pool_unlock(pool);
+	fio_mutex_up(pool->lock);
 }
 
 void sfree(void *ptr)
@@ -354,8 +318,6 @@ void sfree(void *ptr)
 	if (!ptr)
 		return;
 
-	global_read_lock();
-
 	for (i = 0; i < nr_pools; i++) {
 		if (ptr_valid(&mp[i], ptr)) {
 			pool = &mp[i];
@@ -363,8 +325,6 @@ void sfree(void *ptr)
 		}
 	}
 
-	global_read_unlock();
-
 	if (pool) {
 		sfree_pool(pool, ptr);
 		return;
@@ -381,7 +341,7 @@ static void *__smalloc_pool(struct pool *pool, size_t size)
 	unsigned int last_idx;
 	void *ret = NULL;
 
-	pool_lock(pool);
+	fio_mutex_down(pool->lock);
 
 	nr_blocks = size_to_blocks(size);
 	if (nr_blocks > pool->free_blocks)
@@ -424,7 +384,7 @@ static void *__smalloc_pool(struct pool *pool, size_t size)
 		ret = pool->map + offset;
 	}
 fail:
-	pool_unlock(pool);
+	fio_mutex_up(pool->lock);
 	return ret;
 }
 
@@ -463,7 +423,6 @@ void *smalloc(size_t size)
 	if (size != (unsigned int) size)
 		return NULL;
 
-	global_write_lock();
 	i = last_pool;
 	end_pool = nr_pools;
 
@@ -473,7 +432,6 @@ void *smalloc(size_t size)
 
 			if (ptr) {
 				last_pool = i;
-				global_write_unlock();
 				return ptr;
 			}
 		}
@@ -486,7 +444,6 @@ void *smalloc(size_t size)
 		break;
 	} while (1);
 
-	global_write_unlock();
 	return NULL;
 }
 
diff --git a/thread_options.h b/thread_options.h
index ed960ee..567df81 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -231,6 +231,7 @@ struct thread_options {
 	unsigned int io_submit_mode;
 	unsigned int rate_iops[DDIR_RWDIR_CNT];
 	unsigned int rate_iops_min[DDIR_RWDIR_CNT];
+	unsigned int rate_process;
 
 	char *ioscheduler;
 
@@ -471,6 +472,8 @@ struct thread_options_pack {
 	uint32_t io_submit_mode;
 	uint32_t rate_iops[DDIR_RWDIR_CNT];
 	uint32_t rate_iops_min[DDIR_RWDIR_CNT];
+	uint32_t rate_process;
+	uint32_t padding_0;   /* for alignment assert */
 
 	uint8_t ioscheduler[FIO_TOP_STR_MAX];
 
