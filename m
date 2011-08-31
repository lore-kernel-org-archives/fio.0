Return-Path: <dehrenberg@google.com>
From: Dan Ehrenberg <dehrenberg@google.com>
Subject: [PATCH v2] Adding userspace_libaio_reap option
Date: Tue, 30 Aug 2011 17:50:23 -0700
Message-Id: <1314751823-17972-1-git-send-email-dehrenberg@google.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Dan Ehrenberg <dehrenberg@google.com>
List-ID: <fio@vger.kernel.org>

When a single thread is reading from a libaio io_context_t object
in a non-blocking polling manner (that is, with the minimum number
of events to return being 0), then it is possible to safely read
events directly from user-space, taking advantage of the fact that
the io_context_t object is a pointer to memory with a certain layout.
This patch adds an option, userspace_libaio_reap, which allows
reading events in this manner when the libaio engine is used.

You can observe its effect by setting iodepth_batch_complete=0
and seeing the change in distribution of system/user time based on
whether this new flag is set. If userspace_libaio_reap=1, then
busy polling takes place in userspace, and there is a larger amount of
usr CPU. If userspace_libaio_reap=0 (the default), then there is a
larger amount of sys CPU from the polling in the kernel.

Polling from a queue in this manner is several times faster. In my
testing, it took less than an eighth as much time to execute a
polling operation in user-space than with the io_getevents syscall.
---
 HOWTO            |    7 +++++++
 engines/libaio.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fio.h            |    2 ++
 options.c        |    9 +++++++++
 4 files changed, 69 insertions(+), 1 deletions(-)

---
Version 2 updates the HOWTO file and uses the necessary read barrier.
I am not sure if this needs a flush_dcache_page call in the kernel
for correctness. A future version should consider cleaning up the
option interface and consider moving the reaping code to libaio.

diff --git a/HOWTO b/HOWTO
index a1b2e8c..ad4e454 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1187,6 +1187,13 @@ uid=int		Instead of running as the invoking user, set the user ID to
 
 gid=int		Set group ID, see uid.
 
+userspace_libaio_reap=bool  Normally, with the libaio engine in use, fio
+		will use the io_getevents system call to reap newly returned
+		events. With this flag turned on, the AIO ring will be read
+		directly from user-space to reap events. The reaping mode is
+		only enabled when polling for a minimum of 0 events (eg when
+		iodepth_batch_complete=0).
+
 6.0 Interpreting the output
 ---------------------------
 
diff --git a/engines/libaio.c b/engines/libaio.c
index c837ab6..ea05c63 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -58,6 +58,47 @@ static struct io_u *fio_libaio_event(struct thread_data *td, int event)
 	return io_u;
 }
 
+struct aio_ring {
+	unsigned id;		 /** kernel internal index number */
+	unsigned nr;		 /** number of io_events */
+	unsigned head;
+	unsigned tail;
+ 
+	unsigned magic;
+	unsigned compat_features;
+	unsigned incompat_features;
+	unsigned header_length;	/** size of aio_ring */
+
+	struct io_event events[0];
+};
+
+#define AIO_RING_MAGIC	0xa10a10a1
+
+static int user_io_getevents(io_context_t aio_ctx, unsigned int max,
+			struct io_event *events)
+{
+	long i = 0;
+	unsigned head;
+	struct aio_ring *ring = (struct aio_ring*)aio_ctx;
+
+	while (i < max) {
+		head = ring->head;
+
+		if (head == ring->tail) {
+			/* There are no more completions */
+			break;
+		} else {
+			/* There is another completion to reap */
+			events[i] = ring->events[head];
+			read_barrier();
+    			ring->head = (head + 1) % ring->nr;
+			i++;
+		}
+	}
+
+	return i;
+}
+
 static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
 				unsigned int max, struct timespec *t)
 {
@@ -66,7 +107,16 @@ static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
 	int r, events = 0;
 
 	do {
-		r = io_getevents(ld->aio_ctx, actual_min, max, ld->aio_events + events, t);
+		if (td->o.userspace_libaio_reap == 1
+		    && actual_min == 0
+		    && ((struct aio_ring *)(ld->aio_ctx))->magic
+				== AIO_RING_MAGIC) {
+			r = user_io_getevents(ld->aio_ctx, max,
+				ld->aio_events + events);
+		} else {
+			r = io_getevents(ld->aio_ctx, actual_min,
+				max, ld->aio_events + events, t);
+		}
 		if (r >= 0)
 			events += r;
 		else if (r == -EAGAIN)
diff --git a/fio.h b/fio.h
index 9d2a61c..0c86f28 100644
--- a/fio.h
+++ b/fio.h
@@ -413,6 +413,8 @@ struct thread_options {
 	unsigned int gid;
 
 	unsigned int sync_file_range;
+
+	unsigned int userspace_libaio_reap;
 };
 
 #define FIO_VERROR_SIZE	128
diff --git a/options.c b/options.c
index 6a87e98..6f7c41e 100644
--- a/options.c
+++ b/options.c
@@ -2069,6 +2069,15 @@ static struct fio_option options[FIO_MAX_OPTS] = {
 		.off1	= td_var_offset(gid),
 		.help	= "Run job with this group ID",
 	},
+#ifdef FIO_HAVE_LIBAIO
+	{
+		.name	= "userspace_libaio_reap",
+		.type	= FIO_OPT_BOOL,
+		.off1	= td_var_offset(userspace_libaio_reap),
+		.help	= "When using the libaio engine with iodepth_batch_complete=0, enable userspace reaping",
+		.def	= "0",
+	},
+#endif
 	{
 		.name = NULL,
 	},
-- 
1.7.3.1


