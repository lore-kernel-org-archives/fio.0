Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/8] Don't silently terminate td when no I/O performed due to error
Date: Tue,  4 Apr 2017 23:22:11 +0300
Message-Id: <20170404202218.52260-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Some runtime configurations can cause threads/processes to terminate
without any I/O performed, yet with no explicit error message, which
is quite confusing. In the example below, fio finishes with neither
error nor regular statistics due to file offset + bs being larger
than the file size while in get_io_u().

This commit calls log_err() when this happens. Since it's difficult
to tell the exact reason after thread has left the main I/O loop[*],
it gives advice to use a command line option --debug=io, similar to
the way td_io_init() gives advice.

[*] It can't just replace dprint(FD_IO, ...) calls with td_verror()
for e.g. while in get_io_u(), since those are also used by non error
paths too.

--
 # ./fio --name=xxxxx --ioengine=sync --rw=read --bs=2k --size=1m --nrfiles=1k --unlink=1
 xxxxx: (g=0): rw=read, bs=(R) 2048B-2048B, (W) 2048B-2048B, (T) 2048B-2048B, ioengine=sync, iodepth=1
 fio-2.18-59-g618e
 Starting 1 process
 xxxxx: Laying out IO files (1024 files / total 1MiB)

 Run status group 0 (all jobs):

 Disk stats (read/write):
     dm-0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=0/0, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
   sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 backend.c | 17 +++++++++++++++--
 io_u.c    |  5 +++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/backend.c b/backend.c
index 38ef348..e5be187 100644
--- a/backend.c
+++ b/backend.c
@@ -1456,6 +1456,7 @@ static void *thread_main(void *data)
 	struct thread_data *td = fd->td;
 	struct thread_options *o = &td->o;
 	struct sk_out *sk_out = fd->sk_out;
+	uint64_t bytes_done[DDIR_RWDIR_CNT];
 	int deadlock_loop_cnt;
 	int clear_state;
 	int ret;
@@ -1677,7 +1678,9 @@ static void *thread_main(void *data)
 					sizeof(td->bw_sample_time));
 	}
 
+	memset(bytes_done, 0, sizeof(bytes_done));
 	clear_state = 0;
+
 	while (keep_running(td)) {
 		uint64_t verify_bytes;
 
@@ -1696,8 +1699,6 @@ static void *thread_main(void *data)
 		if (td->o.verify_only && td_write(td))
 			verify_bytes = do_dry_run(td);
 		else {
-			uint64_t bytes_done[DDIR_RWDIR_CNT];
-
 			do_io(td, bytes_done);
 
 			if (!ddir_rw_sum(bytes_done)) {
@@ -1776,6 +1777,18 @@ static void *thread_main(void *data)
 			break;
 	}
 
+	/*
+	 * If td ended up with no I/O when it should have had,
+	 * then something went wrong unless FIO_NOIO or FIO_DISKLESSIO.
+	 * (Are we not missing other flags that can be ignored ?)
+	 */
+	if ((td->o.size || td->o.io_size) && !ddir_rw_sum(bytes_done) &&
+	    !(td_ioengine_flagged(td, FIO_NOIO) ||
+	      td_ioengine_flagged(td, FIO_DISKLESSIO)))
+		log_err("%s: No I/O performed by %s, "
+			 "perhaps try --debug=io option for details?\n",
+			 td->o.name, td->io_ops->name);
+
 	td_set_runstate(td, TD_FINISHING);
 
 	update_rusage_stat(td);
diff --git a/io_u.c b/io_u.c
index 363bfe1..88f35c9 100644
--- a/io_u.c
+++ b/io_u.c
@@ -899,8 +899,9 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	}
 
 	if (io_u->offset + io_u->buflen > io_u->file->real_file_size) {
-		dprint(FD_IO, "io_u %p, offset too large\n", io_u);
-		dprint(FD_IO, "  off=%llu/%lu > %llu\n",
+		dprint(FD_IO, "io_u %p, offset + buflen exceeds file size\n",
+			io_u);
+		dprint(FD_IO, "  offset=%llu/buflen=%lu > %llu\n",
 			(unsigned long long) io_u->offset, io_u->buflen,
 			(unsigned long long) io_u->file->real_file_size);
 		return 1;
-- 
2.9.3


