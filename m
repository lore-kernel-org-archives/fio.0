Return-Path: <axboe@kernel.dk>
Date: Tue, 11 Feb 2014 08:27:21 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Fio 2.1.5 release upcoming
Message-ID: <20140211152721.GA19057@kernel.dk>
References: <20140206192135.GB3950@kernel.dk>
 <CAF+0mvnBvLVqijP+Atbh9SEjt0p6-e3hy4Q3QRMtb+swp72bTQ@mail.gmail.com>
 <20140209205744.GB2750@kernel.dk>
 <CAF+0mvk+h3Hb5-KyQr7fqfmrUN6V4-HvKx4M0AYHC6mTUQu0+Q@mail.gmail.com>
 <20140210221420.GD4096@kernel.dk>
 <CAF+0mvmhEBaYSmLh99MST9MCg3rHan339rQkQb2Nw3fvStUfTg@mail.gmail.com>
 <52F95D7B.1000002@kernel.dk>
 <CAF+0mvkg4sD4r75G6+warH0UtMOzYWm29-=MVQx5MDGiRk3sPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+0mvkg4sD4r75G6+warH0UtMOzYWm29-=MVQx5MDGiRk3sPA@mail.gmail.com>
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Mon, Feb 10 2014, Matthew Eaton wrote:
> On Mon, Feb 10, 2014 at 3:15 PM, Jens Axboe <axboe@kernel.dk> wrote:
> >> To be honest I'm not sure how to apply a patch.  Thus far I have only
> >> used release versions of fio.  Do I need to get fio from git, apply
> >> the patch, and then compile?
> >
> >
> > The easiest would be:
> >
> > $ git clone git://git.kernel.dk/fio
> >
> > Then save the patch from mail in a file, eg /tmp/patch. Then do:
> >
> > $ cd fio
> > $ patch -p1 --dry-run < /tmp/patch
> >
> > If the patch command spews any errors, the most likely explanation is that
> > your mailer mangled it somehow. You can try and add -l and see if that makes
> > patch happier, it'll ignore white space then.
> >
> > Assuming that worked, just do:
> >
> > $ ./configure
> > $ make
> >
> > and re-run with ./fio and your job file.
> >
> > --
> > Jens Axboe
> 
> Jens, thanks a lot for your help.  Here is the output from fio from
> git + your patch.  Looks correct except that write io should be 1024
> MB instead of 1000 MB?

The below should be a bit better.


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
index d1702e2..e37307b 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -639,7 +639,7 @@ static int get_file_sizes(struct thread_data *td)
 		}
 
 		if (f->real_file_size == -1ULL && td->o.size)
-			f->real_file_size = td->o.size / td->o.nr_files;
+			f->real_file_size = (td->o.size + td_min_bs(td) - 1) / td->o.nr_files;
 	}
 
 	return err;
@@ -734,9 +734,11 @@ int setup_files(struct thread_data *td)
 	unsigned long long total_size, extend_size;
 	struct thread_options *o = &td->o;
 	struct fio_file *f;
-	unsigned int i;
+	unsigned int i, nr_fs_extra = 0;
 	int err = 0, need_extend;
 	int old_state;
+	const unsigned int bs = td_min_bs(td);
+	uint64_t fs = 0;
 
 	dprint(FD_FILE, "setup files\n");
 
@@ -786,6 +788,20 @@ int setup_files(struct thread_data *td)
 	}
 
 	/*
+	 * Calculate per-file size and potential extra size for the
+	 * first files, if needed.
+	 */
+	if (!o->file_size_low) {
+		uint64_t all_fs;
+
+		fs = o->size / o->nr_files;
+		all_fs = fs * o->nr_files;
+
+		if (all_fs < o->size)
+			nr_fs_extra = (o->size - all_fs) / bs;
+	}
+
+	/*
 	 * now file sizes are known, so we can set ->io_size. if size= is
 	 * not given, ->io_size is just equal to ->real_file_size. if size
 	 * is given, ->io_size is size / nr_files.
@@ -798,10 +814,17 @@ int setup_files(struct thread_data *td)
 		if (!o->file_size_low) {
 			/*
 			 * no file size range given, file size is equal to
-			 * total size divided by number of files. if that is
-			 * zero, set it to the real file size.
+			 * total size divided by number of files. If that is
+			 * zero, set it to the real file size. If the size
+			 * doesn't divide nicely with the min blocksize,
+			 * make the first files bigger.
 			 */
-			f->io_size = o->size / o->nr_files;
+			f->io_size = fs;
+			if (nr_fs_extra) {
+				nr_fs_extra--;
+				f->io_size += bs;
+			}
+
 			if (!f->io_size)
 				f->io_size = f->real_file_size - f->file_offset;
 		} else if (f->real_file_size < o->file_size_low ||
@@ -1386,3 +1409,15 @@ void fio_file_reset(struct thread_data *td, struct fio_file *f)
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


