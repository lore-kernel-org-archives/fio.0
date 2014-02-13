Return-Path: <axboe@kernel.dk>
Date: Thu, 13 Feb 2014 13:34:39 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] io_u_qiter: Fix buffer overrun
Message-ID: <20140213203434.GG10926@kernel.dk>
References: <20140213070625.GA9117@sucs.org>
 <20140213161733.GD10926@kernel.dk>
 <20140213200459.GA31261@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213200459.GA31261@sucs.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Thu, Feb 13 2014, Sitsofe Wheeler wrote:
> On Thu, Feb 13, 2014 at 09:17:33AM -0700, Jens Axboe wrote:
> > 
> > Initially I didn't see the issue, but then I realized that ->io_us is a
> > pointer to the io_u pointer. So it is an issue. The fix isn't super
> > pretty, but it gets rid of the bug, so I'll apply it. It might be nicer
> > to split it into a top and bottom define.
> 
> Can you explain this top and bottom define more - would this let me turn
> it into a while loop?
> 
> The only reason for the current abuse was because I couldn't think of a
> another way to fix it while preserving the macro...

Basically you turn it into a do-while with two macros. Ala the below,
completely untested...

diff --git a/backend.c b/backend.c
index 32bc2652bd0b..e355447d1e3a 100644
--- a/backend.c
+++ b/backend.c
@@ -255,13 +255,13 @@ static void cleanup_pending_aio(struct thread_data *td)
 		struct io_u *io_u;
 		int i;
 
-		io_u_qiter(&td->io_u_all, io_u, i) {
+		io_u_do_qiter(&td->io_u_all, io_u, i) {
 			if (io_u->flags & IO_U_F_FLIGHT) {
 				r = td->io_ops->cancel(td, io_u);
 				if (!r)
 					put_io_u(td, io_u);
 			}
-		}
+		} while_each_io_u(&td->io_u_all, io_u, i);
 	}
 
 	if (td->cur_depth)
diff --git a/engines/posixaio.c b/engines/posixaio.c
index 2df26af3848e..3b27fcdfcc34 100644
--- a/engines/posixaio.c
+++ b/engines/posixaio.c
@@ -111,7 +111,7 @@ static int fio_posixaio_getevents(struct thread_data *td, unsigned int min,
 restart:
 	memset(suspend_list, 0, sizeof(*suspend_list));
 	suspend_entries = 0;
-	io_u_qiter(&td->io_u_all, io_u, i) {
+	io_u_do_qiter(&td->io_u_all, io_u, i) {
 		int err;
 
 		if (io_u->seen || !(io_u->flags & IO_U_F_FLIGHT))
@@ -138,7 +138,7 @@ restart:
 			io_u->resid = io_u->xfer_buflen - retval;
 		} else
 			io_u->error = err;
-	}
+	} while_each_io_u(&td->io_u_all, io_u, i);
 
 	if (r >= min)
 		return r;
diff --git a/engines/windowsaio.c b/engines/windowsaio.c
index 16df74035f18..c6ff27a4408f 100644
--- a/engines/windowsaio.c
+++ b/engines/windowsaio.c
@@ -275,7 +275,7 @@ static int fio_windowsaio_getevents(struct thread_data *td, unsigned int min,
 	}
 
 	do {
-		io_u_qiter(&td->io_u_all, io_u, i) {
+		io_u_do_qiter(&td->io_u_all, io_u, i) {
 			if (!(io_u->flags & IO_U_F_FLIGHT))
 				continue;
 
@@ -290,7 +290,7 @@ static int fio_windowsaio_getevents(struct thread_data *td, unsigned int min,
 
 			if (dequeued >= min)
 				break;
-		}
+		} while_each_io_u(&td->io_u_all, io_u, i);
 
 		if (dequeued < min) {
 			status = WaitForSingleObject(wd->iocomplete_event, mswait);
diff --git a/io_u_queue.h b/io_u_queue.h
index 5b6cad0ef173..649dcb5ca67c 100644
--- a/io_u_queue.h
+++ b/io_u_queue.h
@@ -28,8 +28,14 @@ static inline int io_u_qempty(struct io_u_queue *q)
 	return !q->nr;
 }
 
-#define io_u_qiter(q, io_u, i)	\
-	for (i = 0; i < (q)->nr && (io_u = (q)->io_us[i]); i++)
+#define io_u_do_qiter(q, io_u, i)				\
+	(i) = 0;						\
+	do {							\
+		(io_u) = (q)->io_us[i];				\
+		(i)++;						\
+
+#define while_each_io_u(q, io_u, i)				\
+	} while ((i) < (q)->nr);				\
 
 int io_u_qinit(struct io_u_queue *q, unsigned int nr);
 void io_u_qexit(struct io_u_queue *q);

-- 
Jens Axboe


