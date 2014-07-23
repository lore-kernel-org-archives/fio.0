Return-Path: <axboe@kernel.dk>
Message-ID: <53CF8A01.2090001@kernel.dk>
Date: Wed, 23 Jul 2014 12:10:09 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio crash when using verify
References: <20140722205947.GD14599@beardog.cce.hp.com>
In-Reply-To: <20140722205947.GD14599@beardog.cce.hp.com>
Content-Type: multipart/mixed;
 boundary="------------090407060005070207020007"
To: scameron@beardog.cce.hp.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------090407060005070207020007
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 2014-07-22 22:59, scameron@beardog.cce.hp.com wrote:
>
> Hi Jens,
>
> I'm running into a crash with fio today, seems to be easily reproducible.
>
> [root@msablackburn saperf]# fio --version
> fio-2.1.11-2-g90811
>
> (top of current git tree.)
>
>
> [root@msablackburn saperf]# fio ./2drive_sdr_verify.fio
> 4_KiB_RR_drive_r: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=170
> 4_KiB_RR_drive_s: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=170
> fio-2.1.11-2-g90811
> Starting 2 threads
> fio: io_u.c:1315: __get_io_u: Assertion `io_u->flags & IO_U_F_FREE' failed.a 58m:59s]
> Aborted (core dumped)

Looks like there's a long standing race in the async verification. Does 
this patch fix it for you?

-- 
Jens Axboe


--------------090407060005070207020007
Content-Type: text/x-patch;
 name="async-verify-race.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="async-verify-race.patch"

diff --git a/io_u.c b/io_u.c
index 16b52d63aa09..c3c1d76d2ec1 100644
--- a/io_u.c
+++ b/io_u.c
@@ -688,10 +688,10 @@ void put_io_u(struct thread_data *td, struct io_u *io_u)
 {
 	td_io_u_lock(td);
 
-	if (io_u->file && !(io_u->flags & IO_U_F_FREE_DEF))
+	if (io_u->file && !(io_u->flags & IO_U_F_NO_FILE_PUT))
 		put_file_log(td, io_u->file);
+
 	io_u->file = NULL;
-	io_u->flags &= ~IO_U_F_FREE_DEF;
 	io_u->flags |= IO_U_F_FREE;
 
 	if (io_u->flags & IO_U_F_IN_CUR_DEPTH)
@@ -1313,9 +1313,9 @@ again:
 
 	if (io_u) {
 		assert(io_u->flags & IO_U_F_FREE);
-		io_u->flags &= ~(IO_U_F_FREE | IO_U_F_FREE_DEF);
-		io_u->flags &= ~(IO_U_F_TRIMMED | IO_U_F_BARRIER);
-		io_u->flags &= ~IO_U_F_VER_LIST;
+		io_u->flags &= ~(IO_U_F_FREE | IO_U_F_NO_FILE_PUT |
+				 IO_U_F_TRIMMED | IO_U_F_BARRIER |
+				 IO_U_F_VER_LIST);
 
 		io_u->error = 0;
 		io_u->acct_ddir = -1;
@@ -1607,9 +1607,11 @@ static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
 	return remainder * 1000000 / bps + secs * 1000000;
 }
 
-static void io_completed(struct thread_data *td, struct io_u *io_u,
+static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 			 struct io_completion_data *icd)
 {
+	struct io_u *io_u = *io_u_ptr;
+	enum fio_ddir ddir = io_u->ddir;
 	struct fio_file *f;
 
 	dprint_io_u(io_u, "io complete");
@@ -1635,7 +1637,7 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 
 	td_io_u_unlock(td);
 
-	if (ddir_sync(io_u->ddir)) {
+	if (ddir_sync(ddir)) {
 		td->last_was_sync = 1;
 		f = io_u->file;
 		if (f) {
@@ -1646,12 +1648,12 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 	}
 
 	td->last_was_sync = 0;
-	td->last_ddir = io_u->ddir;
+	td->last_ddir = ddir;
 
-	if (!io_u->error && ddir_rw(io_u->ddir)) {
+	if (!io_u->error && ddir_rw(ddir)) {
 		unsigned int bytes = io_u->buflen - io_u->resid;
-		const enum fio_ddir idx = io_u->ddir;
-		const enum fio_ddir odx = io_u->ddir ^ 1;
+		const enum fio_ddir idx = ddir;
+		const enum fio_ddir odx = ddir ^ 1;
 		int ret;
 
 		td->io_blocks[idx]++;
@@ -1691,7 +1693,8 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 		icd->bytes_done[idx] += bytes;
 
 		if (io_u->end_io) {
-			ret = io_u->end_io(td, io_u);
+			ret = io_u->end_io(td, io_u_ptr);
+			io_u = *io_u_ptr;
 			if (ret && !icd->error)
 				icd->error = ret;
 		}
@@ -1700,9 +1703,11 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 		io_u_log_error(td, io_u);
 	}
 	if (icd->error) {
-		enum error_type_bit eb = td_error_type(io_u->ddir, icd->error);
+		enum error_type_bit eb = td_error_type(ddir, icd->error);
+
 		if (!td_non_fatal_error(td, eb, icd->error))
 			return;
+
 		/*
 		 * If there is a non_fatal error, then add to the error count
 		 * and clear all the errors.
@@ -1710,7 +1715,8 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 		update_error_count(td, icd->error);
 		td_clear_error(td);
 		icd->error = 0;
-		io_u->error = 0;
+		if (io_u)
+			io_u->error = 0;
 	}
 }
 
@@ -1738,9 +1744,9 @@ static void ios_completed(struct thread_data *td,
 	for (i = 0; i < icd->nr; i++) {
 		io_u = td->io_ops->event(td, i);
 
-		io_completed(td, io_u, icd);
+		io_completed(td, &io_u, icd);
 
-		if (!(io_u->flags & IO_U_F_FREE_DEF))
+		if (io_u)
 			put_io_u(td, io_u);
 	}
 }
@@ -1754,9 +1760,9 @@ int io_u_sync_complete(struct thread_data *td, struct io_u *io_u,
 	struct io_completion_data icd;
 
 	init_icd(td, &icd, 1);
-	io_completed(td, io_u, &icd);
+	io_completed(td, &io_u, &icd);
 
-	if (!(io_u->flags & IO_U_F_FREE_DEF))
+	if (io_u)
 		put_io_u(td, io_u);
 
 	if (icd.error) {
diff --git a/io_u_queue.h b/io_u_queue.h
index 5b6cad0ef173..b702b1f39875 100644
--- a/io_u_queue.h
+++ b/io_u_queue.h
@@ -12,8 +12,13 @@ struct io_u_queue {
 
 static inline struct io_u *io_u_qpop(struct io_u_queue *q)
 {
-	if (q->nr)
-		return q->io_us[--q->nr];
+	if (q->nr) {
+		const unsigned int next = --q->nr;
+		struct io_u *io_u = q->io_us[next];
+
+		q->io_us[next] = NULL;
+		return io_u;
+	}
 
 	return NULL;
 }
diff --git a/ioengine.h b/ioengine.h
index 37bf5fce125e..29c8487a0c12 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -20,7 +20,7 @@
 enum {
 	IO_U_F_FREE		= 1 << 0,
 	IO_U_F_FLIGHT		= 1 << 1,
-	IO_U_F_FREE_DEF		= 1 << 2,
+	IO_U_F_NO_FILE_PUT	= 1 << 2,
 	IO_U_F_IN_CUR_DEPTH	= 1 << 3,
 	IO_U_F_BUSY_OK		= 1 << 4,
 	IO_U_F_TRIMMED		= 1 << 5,
@@ -90,7 +90,7 @@ struct io_u {
 	/*
 	 * Callback for io completion
 	 */
-	int (*end_io)(struct thread_data *, struct io_u *);
+	int (*end_io)(struct thread_data *, struct io_u **);
 
 	union {
 #ifdef CONFIG_LIBAIO
diff --git a/verify.c b/verify.c
index 7c99e15e73be..217b68695045 100644
--- a/verify.c
+++ b/verify.c
@@ -656,19 +656,21 @@ static int verify_io_u_md5(struct verify_header *hdr, struct vcont *vc)
 /*
  * Push IO verification to a separate thread
  */
-int verify_io_u_async(struct thread_data *td, struct io_u *io_u)
+int verify_io_u_async(struct thread_data *td, struct io_u **io_u_ptr)
 {
-	if (io_u->file)
-		put_file_log(td, io_u->file);
+	struct io_u *io_u = *io_u_ptr;
 
 	pthread_mutex_lock(&td->io_u_lock);
 
+	if (io_u->file)
+		put_file_log(td, io_u->file);
+
 	if (io_u->flags & IO_U_F_IN_CUR_DEPTH) {
 		td->cur_depth--;
 		io_u->flags &= ~IO_U_F_IN_CUR_DEPTH;
 	}
 	flist_add_tail(&io_u->verify_list, &td->verify_list);
-	io_u->flags |= IO_U_F_FREE_DEF;
+	*io_u_ptr = NULL;
 	pthread_mutex_unlock(&td->io_u_lock);
 
 	pthread_cond_signal(&td->verify_cond);
@@ -747,9 +749,10 @@ err:
 	return EILSEQ;
 }
 
-int verify_io_u(struct thread_data *td, struct io_u *io_u)
+int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 {
 	struct verify_header *hdr;
+	struct io_u *io_u = *io_u_ptr;
 	unsigned int header_size, hdr_inc, hdr_num = 0;
 	void *p;
 	int ret;
@@ -1188,9 +1191,11 @@ static void *verify_async_thread(void *data)
 
 		while (!flist_empty(&list)) {
 			io_u = flist_first_entry(&list, struct io_u, verify_list);
-			flist_del(&io_u->verify_list);
+			flist_del_init(&io_u->verify_list);
+
+			io_u->flags |= IO_U_F_NO_FILE_PUT;
+			ret = verify_io_u(td, &io_u);
 
-			ret = verify_io_u(td, io_u);
 			put_io_u(td, io_u);
 			if (!ret)
 				continue;
diff --git a/verify.h b/verify.h
index dba7743a75d6..bb3fd492ccbc 100644
--- a/verify.h
+++ b/verify.h
@@ -76,8 +76,8 @@ struct vhdr_xxhash {
  */
 extern void populate_verify_io_u(struct thread_data *, struct io_u *);
 extern int __must_check get_next_verify(struct thread_data *td, struct io_u *);
-extern int __must_check verify_io_u(struct thread_data *, struct io_u *);
-extern int verify_io_u_async(struct thread_data *, struct io_u *);
+extern int __must_check verify_io_u(struct thread_data *, struct io_u **);
+extern int verify_io_u_async(struct thread_data *, struct io_u **);
 extern void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len, struct io_u *io_u, unsigned long seed, int use_seed);
 extern void fill_buffer_pattern(struct thread_data *td, void *p, unsigned int len);
 extern void fio_verify_init(struct thread_data *td);

--------------090407060005070207020007--

