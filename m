Return-Path: <axboe@kernel.dk>
Message-ID: <53695B3C.8060201@kernel.dk>
Date: Tue, 06 May 2014 15:59:24 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Meta verification regression starting with fio 2.1.5
References: <536928FE.6020109@skyera.com>
In-Reply-To: <536928FE.6020109@skyera.com>
Content-Type: multipart/mixed;
 boundary="------------080703070703030505010800"
To: Stoo Davies <sdavies@skyera.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------080703070703030505010800
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 05/06/2014 12:25 PM, Stoo Davies wrote:
> I'm doing some powerfail recovery testing on a storage array over iSCSI.
> Host is RHEL 6.4 kernel 2.6.32-358.el6.x86_64.
> 
> With fio 2.1.2 -> 2.1.4 the job file below rides through the disks going
> away, and continues I/O after they come back, without reporting any errors.
> With fio 2.1.5 -> 2.1.8 when the disks come back fio immediately reports
> a meta verification error.
> 
> I captured a trace with an finisar analyzer, and can see that after the
> disks come back and the host logs back in, a read is issued for an lba
> which was never written to.
> Since I don't see verification errors outside of the powerfail testing,
> I suspect fio isn't correctly handling failed writes during the time the
> disks are unavailable.
> 
> The trace file is rather large, but I can make it available if you need
> to see it.
> 
> [whee]
> bs=8k
> thread=4
> time_based=1
> runtime=864000
> readwrite=randrw
> direct=1
> iodepth=128
> ioengine=libaio
> size=100%
> verify=meta
> do_verify=1
> verify_fatal=1
> verify_dump=1
> verify_backlog=8192
> buffer_compress_percentage=95
> ignore_error=ENODEV:EIO,ENODEV:EIO,ENODEV:EIO
> filename=/dev/mapper/lun0
> .
> .
> filename=/dev/mapper/lun9

2.1.5 did indeed change when the IO was logged for verification, so that
does explain why it fails for you now. That's a problem.

Can you try with this patch? I'm not going to commit it yet, I want to
carefully audit all paths to ensure we also unlog or trim an io_piece,
if we don't fully complete it.

-- 
Jens Axboe


--------------080703070703030505010800
Content-Type: text/x-patch;
 name="unlog.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="unlog.patch"

diff --git a/backend.c b/backend.c
index 9deef284e36b..e6a47716094f 100644
--- a/backend.c
+++ b/backend.c
@@ -780,6 +780,7 @@ static uint64_t do_io(struct thread_data *td)
 		case FIO_Q_COMPLETED:
 			if (io_u->error) {
 				ret = -io_u->error;
+				unlog_io_piece(td, io_u);
 				clear_io_u(td, io_u);
 			} else if (io_u->resid) {
 				int bytes = io_u->xfer_buflen - io_u->resid;
@@ -830,6 +831,7 @@ sync_done:
 			bytes_issued += io_u->xfer_buflen;
 			break;
 		case FIO_Q_BUSY:
+			unlog_io_piece(td, io_u);
 			requeue_io_u(td, &io_u);
 			ret2 = td_io_commit(td);
 			if (ret2 < 0)
diff --git a/io_u.c b/io_u.c
index 4b0b5a7a11bd..e132fd9d2d98 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1622,8 +1622,15 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 	 * Mark IO ok to verify
 	 */
 	if (io_u->ipo) {
-		io_u->ipo->flags &= ~IP_F_IN_FLIGHT;
-		write_barrier();
+		/*
+		 * Remove errored entry from the verification list
+		 */
+		if (io_u->error)
+			unlog_io_piece(td, io_u);
+		else {
+			io_u->ipo->flags &= ~IP_F_IN_FLIGHT;
+			write_barrier();
+		}
 	}
 
 	td_io_u_unlock(td);
diff --git a/iolog.c b/iolog.c
index f49895929c34..33ec07afed4e 100644
--- a/iolog.c
+++ b/iolog.c
@@ -268,6 +268,23 @@ restart:
 	td->io_hist_len++;
 }
 
+void unlog_io_piece(struct thread_data *td, struct io_u *io_u)
+{
+	struct io_piece *ipo = io_u->ipo;
+
+	if (!ipo)
+		return;
+
+	if (ipo->flags & IP_F_ONRB)
+		rb_erase(&ipo->rb_node, &td->io_hist_tree);
+	else if (ipo->flags & IP_F_ONLIST)
+		flist_del(&ipo->list);
+
+	free(ipo);
+	io_u->ipo = NULL;
+	td->io_hist_len--;
+}
+
 void write_iolog_close(struct thread_data *td)
 {
 	fflush(td->iolog_f);
diff --git a/iolog.h b/iolog.h
index 50d09e26bfbe..8b1d5880da74 100644
--- a/iolog.h
+++ b/iolog.h
@@ -110,6 +110,7 @@ extern void log_io_u(struct thread_data *, struct io_u *);
 extern void log_file(struct thread_data *, struct fio_file *, enum file_log_act);
 extern int __must_check init_iolog(struct thread_data *td);
 extern void log_io_piece(struct thread_data *, struct io_u *);
+extern void unlog_io_piece(struct thread_data *, struct io_u *);
 extern void queue_io_piece(struct thread_data *, struct io_piece *);
 extern void prune_io_piece_log(struct thread_data *);
 extern void write_iolog_close(struct thread_data *);

--------------080703070703030505010800--

