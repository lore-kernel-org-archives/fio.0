Return-Path: <axboe@kernel.dk>
Date: Mon, 10 Feb 2014 15:14:20 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Fio 2.1.5 release upcoming
Message-ID: <20140210221420.GD4096@kernel.dk>
References: <20140206192135.GB3950@kernel.dk>
 <CAF+0mvnBvLVqijP+Atbh9SEjt0p6-e3hy4Q3QRMtb+swp72bTQ@mail.gmail.com>
 <20140209205744.GB2750@kernel.dk>
 <CAF+0mvk+h3Hb5-KyQr7fqfmrUN6V4-HvKx4M0AYHC6mTUQu0+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+0mvk+h3Hb5-KyQr7fqfmrUN6V4-HvKx4M0AYHC6mTUQu0+Q@mail.gmail.com>
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Sun, Feb 09 2014, Matthew Eaton wrote:
> On Sun, Feb 9, 2014 at 12:57 PM, Jens Axboe <axboe@kernel.dk> wrote:
> > On Sat, Feb 08 2014, Matthew Eaton wrote:
> >> On Thu, Feb 6, 2014 at 11:21 AM, Jens Axboe <axboe@kernel.dk> wrote:
> >> > Hi,
> >> >
> >> > I've been late on this release, originally wanted it out around
> >> > Christmas. But various issues here and there prevented that. However, I
> >> > now think we are getting pretty close. It'd be great if folks running on
> >> > non-linux systems could compile and ensure that everything is in working
> >> > order, because otherwise I'm going to assume that it is...
> >> >
> >> > Similarly, if you know of bugs (particularly regressions from previous
> >> > releases), speak up now so we can get them fixed before 2.1.5 is cut.
> >> >
> >> > I'll wait until Monday to tag the release.
> >> >
> >> > --
> >> > Jens Axboe
> >> >
> >>
> >> Hi Jens,
> >>
> >> I was messing around with the openfiles flag in one of my job files
> >> last week but was unable to get it to work.  Fio would keep defaulting
> >> to opening all files set by nrfiles, but I'm not sure if I was doing
> >> something wrong.  This was with fio 2.1.4 on linux.  Can you check on
> >> this?
> >
> > It'd be easier if you include your job file / command line!
> >
> > --
> > Jens Axboe
> >
> 
> Hi Jens,
> 
> Here's an example.  In fio output I get f=50 instead of f=10 which I
> believe is the number of simultaneous opens?  Also strange to me is
> that write io is 2000 MB instead of 1024 MB.
> 
> [job]
> bs=1m
> rw=write
> size=1g
> nrfiles=50
> openfiles=10
> directory=temp
> 
> job: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=sync, iodepth=1
> fio-2.1.4
> Starting 1 process
> job: Laying out IO file(s) (50 file(s) / 1023MB)
> Jobs: 1 (f=50): [W] [-.-% done] [0KB/539.0MB/0KB /s] [0/539/0 iops]
> [eta 00m:00s]
> job: (groupid=0, jobs=1): err= 0: pid=15131: Sun Feb  9 16:18:55 2014
>   write: io=2000.0MB, bw=697785KB/s, iops=681, runt=  2935msec
>     clat (usec): min=167, max=145348, avg=1399.89, stdev=6030.76
>      lat (usec): min=175, max=145359, avg=1413.43, stdev=6031.10
>     clat percentiles (usec):
>      |  1.00th=[  175],  5.00th=[  207], 10.00th=[  253], 20.00th=[  262],
>      | 30.00th=[  274], 40.00th=[  290], 50.00th=[  302], 60.00th=[  358],
>      | 70.00th=[  516], 80.00th=[  572], 90.00th=[ 5984], 95.00th=[ 6624],
>      | 99.00th=[ 7328], 99.50th=[10816], 99.90th=[115200], 99.95th=[140288],
>      | 99.99th=[144384]
>     bw (KB  /s): min=81160, max=1503620, per=100.00%, avg=778889.75,
> stdev=604179.56
>     lat (usec) : 250=7.50%, 500=61.95%, 750=18.25%
>     lat (msec) : 10=11.70%, 20=0.20%, 50=0.15%, 100=0.10%, 250=0.15%
>   cpu          : usr=2.97%, sys=25.70%, ctx=504, majf=0, minf=33
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=0/w=2000/d=0, short=r=0/w=0/d=0
> 
> Run status group 0 (all jobs):
>   WRITE: io=2000.0MB, aggrb=697785KB/s, minb=697785KB/s,
> maxb=697785KB/s, mint=2935msec, maxt=2935msec
> 
> Disk stats (read/write):
>   sdb: ios=0/2740, merge=0/2, ticks=0/360280, in_queue=376924, util=90.05%

Can you try this patch?


diff --git a/backend.c b/backend.c
index a607134..32bc265 100644
--- a/backend.c
+++ b/backend.c
@@ -52,6 +52,7 @@
 #include "server.h"
 #include "lib/getrusage.h"
 #include "idletime.h"
+#include "err.h"
 
 static pthread_t disk_util_thread;
 static struct fio_mutex *disk_thread_mutex;
@@ -478,6 +479,12 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 				break;
 
 			while ((io_u = get_io_u(td)) != NULL) {
+				if (IS_ERR(io_u)) {
+					io_u = NULL;
+					ret = FIO_Q_BUSY;
+					goto reap;
+				}
+
 				/*
 				 * We are only interested in the places where
 				 * we wrote or trimmed IOs. Turn those into
@@ -574,6 +581,7 @@ sync_done:
 		 * completed io_u's first. Note that we can get BUSY even
 		 * without IO queued, if the system is resource starved.
 		 */
+reap:
 		full = queue_full(td) || (ret == FIO_Q_BUSY && td->cur_depth);
 		if (full || !td->o.iodepth_batch_complete) {
 			min_events = min(td->o.iodepth_batch_complete,
@@ -692,7 +700,14 @@ static uint64_t do_io(struct thread_data *td)
 			break;
 
 		io_u = get_io_u(td);
-		if (!io_u) {
+		if (IS_ERR_OR_NULL(io_u)) {
+			int err = PTR_ERR(io_u);
+
+			io_u = NULL;
+			if (err == -EBUSY) {
+				ret = FIO_Q_BUSY;
+				goto reap;
+			}
 			if (td->o.latency_target)
 				goto reap;
 			break;
@@ -1124,6 +1139,9 @@ static int keep_running(struct thread_data *td)
 		if (diff < td_max_bs(td))
 			return 0;
 
+		if (fio_files_done(td))
+			return 0;
+
 		return 1;
 	}
 
diff --git a/err.h b/err.h
new file mode 100644
index 0000000..5c024ee
--- /dev/null
+++ b/err.h
@@ -0,0 +1,44 @@
+#ifndef FIO_ERR_H
+#define FIO_ERR_H
+
+/*
+ * Kernel pointers have redundant information, so we can use a
+ * scheme where we can return either an error code or a dentry
+ * pointer with the same return value.
+ *
+ * This should be a per-architecture thing, to allow different
+ * error and pointer decisions.
+ */
+#define MAX_ERRNO	4095
+
+#define IS_ERR_VALUE(x) ((x) >= (unsigned long)-MAX_ERRNO)
+
+static inline void *ERR_PTR(long error)
+{
+	return (void *) error;
+}
+
+static inline long PTR_ERR(const void *ptr)
+{
+	return (long) ptr;
+}
+
+static inline long IS_ERR(const void *ptr)
+{
+	return IS_ERR_VALUE((unsigned long)ptr);
+}
+
+static inline long IS_ERR_OR_NULL(const void *ptr)
+{
+	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
+}
+
+static inline int PTR_ERR_OR_ZERO(const void *ptr)
+{
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+	else
+		return 0;
+}
+
+#endif
diff --git a/file.h b/file.h
index d7e05f4..19413fc 100644
--- a/file.h
+++ b/file.h
@@ -176,5 +176,6 @@ extern void dup_files(struct thread_data *, struct thread_data *);
 extern int get_fileno(struct thread_data *, const char *);
 extern void free_release_files(struct thread_data *);
 void fio_file_reset(struct thread_data *, struct fio_file *);
+int fio_files_done(struct thread_data *);
 
 #endif
diff --git a/filesetup.c b/filesetup.c
index d1702e2..975579a 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -639,7 +639,7 @@ static int get_file_sizes(struct thread_data *td)
 		}
 
 		if (f->real_file_size == -1ULL && td->o.size)
-			f->real_file_size = td->o.size / td->o.nr_files;
+			f->real_file_size = (td->o.size + td_min_bs(td) - 1) / td->o.nr_files;
 	}
 
 	return err;
@@ -801,7 +801,7 @@ int setup_files(struct thread_data *td)
 			 * total size divided by number of files. if that is
 			 * zero, set it to the real file size.
 			 */
-			f->io_size = o->size / o->nr_files;
+			f->io_size = (o->size + td_min_bs(td) - 1) / o->nr_files;
 			if (!f->io_size)
 				f->io_size = f->real_file_size - f->file_offset;
 		} else if (f->real_file_size < o->file_size_low ||
@@ -1386,3 +1386,15 @@ void fio_file_reset(struct thread_data *td, struct fio_file *f)
 	if (td->o.random_generator == FIO_RAND_GEN_LFSR)
 		lfsr_reset(&f->lfsr, td->rand_seeds[FIO_RAND_BLOCK_OFF]);
 }
+
+int fio_files_done(struct thread_data *td)
+{
+	struct fio_file *f;
+	unsigned int i;
+
+	for_each_file(td, f, i)
+		if (!fio_file_done(f))
+			return 0;
+
+	return 1;
+}
diff --git a/io_u.c b/io_u.c
index 64ff73c..acc1a7b 100644
--- a/io_u.c
+++ b/io_u.c
@@ -11,6 +11,7 @@
 #include "trim.h"
 #include "lib/rand.h"
 #include "lib/axmap.h"
+#include "err.h"
 
 struct io_completion_data {
 	int nr;				/* input */
@@ -985,6 +986,9 @@ static struct fio_file *get_next_file_rand(struct thread_data *td,
 		if (!fio_file_open(f)) {
 			int err;
 
+			if (td->nr_open_files >= td->o.open_files)
+				return ERR_PTR(-EBUSY);
+
 			err = td_io_open_file(td, f);
 			if (err)
 				continue;
@@ -1027,6 +1031,9 @@ static struct fio_file *get_next_file_rr(struct thread_data *td, int goodf,
 		if (!fio_file_open(f)) {
 			int err;
 
+			if (td->nr_open_files >= td->o.open_files)
+				return ERR_PTR(-EBUSY);
+
 			err = td_io_open_file(td, f);
 			if (err) {
 				dprint(FD_FILE, "error %d on open of %s\n",
@@ -1080,6 +1087,9 @@ static struct fio_file *__get_next_file(struct thread_data *td)
 	else
 		f = get_next_file_rand(td, FIO_FILE_open, FIO_FILE_closing);
 
+	if (IS_ERR(f))
+		return f;
+
 	td->file_service_file = f;
 	td->file_service_left = td->file_service_nr - 1;
 out:
@@ -1099,14 +1109,14 @@ static struct fio_file *get_next_file(struct thread_data *td)
 	return __get_next_file(td);
 }
 
-static int set_io_u_file(struct thread_data *td, struct io_u *io_u)
+static long set_io_u_file(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f;
 
 	do {
 		f = get_next_file(td);
-		if (!f)
-			return 1;
+		if (IS_ERR_OR_NULL(f))
+			return PTR_ERR(f);
 
 		io_u->file = f;
 		get_file(f);
@@ -1400,6 +1410,7 @@ struct io_u *get_io_u(struct thread_data *td)
 	struct fio_file *f;
 	struct io_u *io_u;
 	int do_scramble = 0;
+	long ret = 0;
 
 	io_u = __get_io_u(td);
 	if (!io_u) {
@@ -1425,11 +1436,17 @@ struct io_u *get_io_u(struct thread_data *td)
 		if (read_iolog_get(td, io_u))
 			goto err_put;
 	} else if (set_io_u_file(td, io_u)) {
+		ret = -EBUSY;
 		dprint(FD_IO, "io_u %p, setting file failed\n", io_u);
 		goto err_put;
 	}
 
 	f = io_u->file;
+	if (!f) {
+		dprint(FD_IO, "io_u %p, setting file failed\n", io_u);
+		goto err_put;
+	}
+
 	assert(fio_file_open(f));
 
 	if (ddir_rw(io_u->ddir)) {
@@ -1478,7 +1495,7 @@ out:
 err_put:
 	dprint(FD_IO, "get_io_u failed\n");
 	put_io_u(td, io_u);
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 void io_u_log_error(struct thread_data *td, struct io_u *io_u)

-- 
Jens Axboe


