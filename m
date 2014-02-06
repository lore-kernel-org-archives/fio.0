Return-Path: <axboe@kernel.dk>
Date: Wed, 5 Feb 2014 20:34:37 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Rip out verify_backlog support?
Message-ID: <20140206033437.GA25141@kernel.dk>
References: <CANEJEGuqYiSQnyw2bVNFa3CKqmZK6+-3y5dDT4h3iccU-n0cAA@mail.gmail.com>
 <20140205193214.GI27534@kernel.dk>
 <CANEJEGs-KdsMC3fE3SvOUkkbJESXXvUHwRVq5OjWTfKyf-ooEA@mail.gmail.com>
 <20140205195317.GK27534@kernel.dk>
 <CANEJEGsqwKQssFqZPEycWR-ccqcVjWGQA=EtLtDsdxg5D1-c_g@mail.gmail.com>
 <20140205212812.GC20626@kernel.dk>
 <CANEJEGt5neHeCc-wnDDyFWY7S_AyxzKjaOj09DXR08oRjF+Dow@mail.gmail.com>
 <20140205223052.GF20626@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140205223052.GF20626@kernel.dk>
To: Grant Grundler <grundler@chromium.org>
Cc: FIO_list <fio@vger.kernel.org>, Puthikorn Voravootivat <puthik@chromium.org>
List-ID: <fio@vger.kernel.org>

On Wed, Feb 05 2014, Jens Axboe wrote:
> On Wed, Feb 05 2014, Grant Grundler wrote:
> > > It does - that's the log_io_piece() mechanism. The writer will generate
> > > on, and verify will read those and verify. We just have to ensure that
> > > it is correct in the way that it is logged. The alternative would be to
> > > rely purely on the generator rollback, and for that you would then need
> > > some specific notification on how far the reader could proceed, if async
> > > verify_backlog is used.
> > 
> > Yes - I was referring to the "rely purely on generator rollback".
> > 
> > Once log_io_piece() is called, the verify code assumes the IO is
> > complete...which isn't true if log_io_piece() is used to record "order
> > issued".
> 
> Right, we'd need to ensure the state is accurately known to the
> verifier.

Something like this should work, though I don't like the extra
overhead... Totally untested.

diff --git a/backend.c b/backend.c
index 62fa17c3a209..9ececaa1d5af 100644
--- a/backend.c
+++ b/backend.c
@@ -731,8 +731,7 @@ static uint64_t do_io(struct thread_data *td)
 		if (td_write(td) && io_u->ddir == DDIR_WRITE &&
 		    td->o.do_verify &&
 		    td->o.verify != VERIFY_NONE &&
-		    !td->o.experimental_verify &&
-		    !(td->flags & TD_F_VER_BACKLOG))
+		    !td->o.experimental_verify)
 			log_io_piece(td, io_u);
 
 		ret = td_io_queue(td, io_u);
diff --git a/io_u.c b/io_u.c
index 4264cd54115c..64ff73cd5555 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1285,6 +1285,7 @@ again:
 		io_u->acct_ddir = -1;
 		td->cur_depth++;
 		io_u->flags |= IO_U_F_IN_CUR_DEPTH;
+		io_u->ipo = NULL;
 	} else if (td->o.verify_async) {
 		/*
 		 * We ran out, wait for async verify threads to finish and
@@ -1568,6 +1569,15 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 	td_io_u_lock(td);
 	assert(io_u->flags & IO_U_F_FLIGHT);
 	io_u->flags &= ~(IO_U_F_FLIGHT | IO_U_F_BUSY_OK);
+
+	/*
+	 * Mark IO ok to verify
+	 */
+	if (io_u->ipo) {
+		io_u->ipo->flags &= ~IP_F_IN_FLIGHT;
+		write_barrier();
+	}
+
 	td_io_u_unlock(td);
 
 	if (ddir_sync(io_u->ddir)) {
@@ -1623,17 +1633,6 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 					 utime_since_now(&td->start));
 		}
 
-		/*
-		 * Verify_backlog enable: We need to log the write job after
-		 * finishing it to prevent verifying before finish writing.
-		 */
-		if (td_write(td) && idx == DDIR_WRITE &&
-		    td->o.do_verify &&
-		    td->o.verify != VERIFY_NONE &&
-		    !td->o.experimental_verify &&
-		    (td->flags & TD_F_VER_BACKLOG))
-			log_io_piece(td, io_u);
-
 		icd->bytes_done[idx] += bytes;
 
 		if (io_u->end_io) {
diff --git a/ioengine.h b/ioengine.h
index 0756bc7e6c13..37627bb1dc76 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -71,6 +71,8 @@ struct io_u {
 	 */
 	unsigned long buf_filled_len;
 
+	struct io_piece *ipo;
+
 	union {
 #ifdef CONFIG_LIBAIO
 		struct iocb iocb;
diff --git a/iolog.c b/iolog.c
index 017b235c217a..5fd9416c036e 100644
--- a/iolog.c
+++ b/iolog.c
@@ -189,6 +189,9 @@ void log_io_piece(struct thread_data *td, struct io_u *io_u)
 	ipo->offset = io_u->offset;
 	ipo->len = io_u->buflen;
 	ipo->numberio = io_u->numberio;
+	ipo->flags = IP_F_IN_FLIGHT;
+
+	io_u->ipo = ipo;
 
 	if (io_u_should_trim(td, io_u)) {
 		flist_add_tail(&ipo->trim_list, &td->trim_list);
diff --git a/iolog.h b/iolog.h
index 321576dbe611..3ec48f2100fe 100644
--- a/iolog.h
+++ b/iolog.h
@@ -67,6 +67,7 @@ enum {
 	IP_F_ONRB	= 1,
 	IP_F_ONLIST	= 2,
 	IP_F_TRIMMED	= 4,
+	IP_F_IN_FLIGHT	= 8,
 };
 
 /*
diff --git a/verify.c b/verify.c
index 90cd093add1f..93731228f1b6 100644
--- a/verify.c
+++ b/verify.c
@@ -1022,11 +1022,27 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 		struct rb_node *n = rb_first(&td->io_hist_tree);
 
 		ipo = rb_entry(n, struct io_piece, rb_node);
+
+		/*
+		 * Ensure that the associated IO has completed
+		 */
+		read_barrier();
+		if (ipo->flags & IP_F_IN_FLIGHT)
+			goto nothing;
+
 		rb_erase(n, &td->io_hist_tree);
 		assert(ipo->flags & IP_F_ONRB);
 		ipo->flags &= ~IP_F_ONRB;
 	} else if (!flist_empty(&td->io_hist_list)) {
 		ipo = flist_entry(td->io_hist_list.next, struct io_piece, list);
+
+		/*
+		 * Ensure that the associated IO has completed
+		 */
+		read_barrier();
+		if (ipo->flags & IP_F_IN_FLIGHT)
+			goto nothing;
+
 		flist_del(&ipo->list);
 		assert(ipo->flags & IP_F_ONLIST);
 		ipo->flags &= ~IP_F_ONLIST;
@@ -1072,6 +1088,7 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 		return 0;
 	}
 
+nothing:
 	dprint(FD_VERIFY, "get_next_verify: empty\n");
 	return 1;
 }

-- 
Jens Axboe


