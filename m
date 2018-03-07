Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43856 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754378AbeCGNAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Mar 2018 08:00:11 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1etYfy-0004Vr-Ao
        for fio@vger.kernel.org; Wed, 07 Mar 2018 13:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180307130002.2B6B22C1D65@kernel.dk>
Date: Wed,  7 Mar 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b979af5cba25e31dc2a8f2fd89ac5e40c24b6519:

  Merge branch 'howto_typos' of https://github.com/dirtyharrycallahan/fio (2018-03-05 10:29:39 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 674456bf7d0f775f774c8097c8bcb98b48cccc51:

  Reduce LOG_MSEC_SLACK (2018-03-06 17:53:20 -0700)

----------------------------------------------------------------
Jason Dillaman (2):
      rbd: fixed busy-loop when using eventfd polling
      rbd: remove support for blkin tracing

Jeff Furlong (1):
      Reduce LOG_MSEC_SLACK

Jens Axboe (3):
      Don't make fadvise failure fatal
      Default to building native code
      Merge branch 'wip-rbd-engine' of https://github.com/dillaman/fio

 Makefile      |  3 +++
 configure     | 56 +++++++++++++++++++++-----------------------------------
 debug.h       |  1 +
 engines/rbd.c | 41 ++++++++++++++++++-----------------------
 ioengines.c   |  4 ++--
 stat.c        | 14 ++++++++------
 6 files changed, 53 insertions(+), 66 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index c25b422..19ba40a 100644
--- a/Makefile
+++ b/Makefile
@@ -31,6 +31,9 @@ SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot
 ifndef CONFIG_FIO_NO_OPT
   CFLAGS += -O3 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
 endif
+ifdef CONFIG_BUILD_NATIVE
+  CFLAGS += -march=native
+endif
 
 ifdef CONFIG_GFIO
   PROGS += gfio
diff --git a/configure b/configure
index 2e8eb18..589ff3f 100755
--- a/configure
+++ b/configure
@@ -145,6 +145,7 @@ devdax="no"
 pmem="no"
 disable_lex=""
 disable_pmem="no"
+disable_native="no"
 prefix=/usr/local
 
 # parse options
@@ -177,8 +178,6 @@ for opt do
   ;;
   --disable-rbd) disable_rbd="yes"
   ;;
-  --disable-rbd-blkin) disable_rbd_blkin="yes"
-  ;;
   --disable-gfapi) disable_gfapi="yes"
   ;;
   --enable-libhdfs) libhdfs="yes"
@@ -195,6 +194,8 @@ for opt do
   ;;
   --enable-cuda) enable_cuda="yes"
   ;;
+  --disable-native) disable_native="yes"
+  ;;
   --help)
     show_help="yes"
     ;;
@@ -224,6 +225,7 @@ if test "$show_help" = "yes" ; then
   echo "--disable-shm           Disable SHM support"
   echo "--disable-optimizations Don't enable compiler optimizations"
   echo "--enable-cuda           Enable GPUDirect RDMA support"
+  echo "--disable-native        Don't build for native host"
   exit $exit_val
 fi
 
@@ -1629,36 +1631,6 @@ print_config "rbd_invalidate_cache" "$rbd_inval"
 fi
 
 ##########################################
-# check for blkin
-if test "$rbd_blkin" != "yes" ; then
-  rbd_blkin="no"
-fi
-cat > $TMPC << EOF
-#include <rbd/librbd.h>
-#include <zipkin_c.h>
-
-int main(int argc, char **argv)
-{
-  int r;
-  struct blkin_trace_info t_info;
-  blkin_init_trace_info(&t_info);
-  rbd_completion_t completion;
-  rbd_image_t image;
-  uint64_t off;
-  size_t len;
-  const char *buf;
-  r = rbd_aio_write_traced(image, off, len, buf, completion, &t_info);
-  return 0;
-}
-EOF
-if test "$disable_rbd" != "yes" && test "$disable_rbd_blkin" != "yes" \
- && compile_prog "" "-lrbd -lrados -lblkin" "rbd_blkin"; then
-  LIBS="-lblkin $LIBS"
-  rbd_blkin="yes"
-fi
-print_config "rbd blkin tracing" "$rbd_blkin"
-
-##########################################
 # Check whether we have setvbuf
 if test "$setvbuf" != "yes" ; then
   setvbuf="no"
@@ -2131,6 +2103,20 @@ if compile_prog "" "" "mkdir(a, b)"; then
 fi
 print_config "mkdir(a, b)" "$mkdir_two"
 
+##########################################
+# check for cc -march=native
+build_native="no"
+cat > $TMPC << EOF
+int main(int argc, char **argv)
+{
+  return 0;
+}
+EOF
+if test "$disable_native" = "no" && compile_prog "-march=native" "" "march=native"; then
+  build_native="yes"
+fi
+print_config "Build march=native" "$build_native"
+
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -2295,9 +2281,6 @@ fi
 if test "$rbd_inval" = "yes" ; then
   output_sym "CONFIG_RBD_INVAL"
 fi
-if test "$rbd_blkin" = "yes" ; then
-  output_sym "CONFIG_RBD_BLKIN"
-fi
 if test "$setvbuf" = "yes" ; then
   output_sym "CONFIG_SETVBUF"
 fi
@@ -2377,6 +2360,9 @@ fi
 if test "$mkdir_two" = "yes" ; then
   output_sym "CONFIG_HAVE_MKDIR_TWO"
 fi
+if test "$build_native" = "yes" ; then
+  output_sym "CONFIG_BUILD_NATIVE"
+fi
 
 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "GFIO_LIBS+=$GFIO_LIBS" >> $config_host_mak
diff --git a/debug.h b/debug.h
index ba62214..ac5f2cc 100644
--- a/debug.h
+++ b/debug.h
@@ -43,6 +43,7 @@ enum {
 	FIO_WARN_VERIFY_BUF	= 2,
 	FIO_WARN_ZONED_BUG	= 4,
 	FIO_WARN_IOLOG_DROP	= 8,
+	FIO_WARN_FADVISE	= 16,
 };
 
 #ifdef FIO_INC_DEBUG
diff --git a/engines/rbd.c b/engines/rbd.c
index 39501eb..6582b06 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -9,9 +9,6 @@
 
 #include "../fio.h"
 #include "../optgroup.h"
-#ifdef CONFIG_RBD_BLKIN
-#include <zipkin_c.h>
-#endif
 
 #ifdef CONFIG_RBD_POLL
 /* add for poll */
@@ -24,9 +21,6 @@ struct fio_rbd_iou {
 	rbd_completion_t completion;
 	int io_seen;
 	int io_complete;
-#ifdef CONFIG_RBD_BLKIN
-	struct blkin_trace_info info;
-#endif
 };
 
 struct rbd_data {
@@ -146,7 +140,7 @@ static bool _fio_rbd_setup_poll(struct rbd_data *rbd)
 	int r;
 
 	/* add for rbd poll */
-	rbd->fd = eventfd(0, EFD_NONBLOCK);
+	rbd->fd = eventfd(0, EFD_SEMAPHORE);
 	if (rbd->fd < 0) {
 		log_err("eventfd failed.\n");
 		return false;
@@ -366,25 +360,37 @@ static int rbd_iter_events(struct thread_data *td, unsigned int *events,
 	int event_num = 0;
 	struct fio_rbd_iou *fri = NULL;
 	rbd_completion_t comps[min_evts];
+	uint64_t counter;
+	bool completed;
 
 	struct pollfd pfd;
 	pfd.fd = rbd->fd;
 	pfd.events = POLLIN;
 
-	ret = poll(&pfd, 1, -1);
+	ret = poll(&pfd, 1, wait ? -1 : 0);
 	if (ret <= 0)
 		return 0;
-
-	assert(pfd.revents & POLLIN);
+	if (!(pfd.revents & POLLIN))
+		return 0;
 
 	event_num = rbd_poll_io_events(rbd->image, comps, min_evts);
 
 	for (i = 0; i < event_num; i++) {
 		fri = rbd_aio_get_arg(comps[i]);
 		io_u = fri->io_u;
+
+		/* best effort to decrement the semaphore */
+		ret = read(rbd->fd, &counter, sizeof(counter));
+		if (ret <= 0)
+			log_err("rbd_iter_events failed to decrement semaphore.\n");
+
+		completed = fri_check_complete(rbd, io_u, events);
+		assert(completed);
+
+		this_events++;
+	}
 #else
 	io_u_qiter(&td->io_u_all, io_u, i) {
-#endif
 		if (!(io_u->flags & IO_U_F_FLIGHT))
 			continue;
 		if (rbd_io_u_seen(io_u))
@@ -395,6 +401,7 @@ static int rbd_iter_events(struct thread_data *td, unsigned int *events,
 		else if (wait)
 			rbd->sort_events[sidx++] = io_u;
 	}
+#endif
 
 	if (!wait || !sidx)
 		return this_events;
@@ -474,28 +481,16 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 	}
 
 	if (io_u->ddir == DDIR_WRITE) {
-#ifdef CONFIG_RBD_BLKIN
-		blkin_init_trace_info(&fri->info);
-		r = rbd_aio_write_traced(rbd->image, io_u->offset, io_u->xfer_buflen,
-					 io_u->xfer_buf, fri->completion, &fri->info);
-#else
 		r = rbd_aio_write(rbd->image, io_u->offset, io_u->xfer_buflen,
 					 io_u->xfer_buf, fri->completion);
-#endif
 		if (r < 0) {
 			log_err("rbd_aio_write failed.\n");
 			goto failed_comp;
 		}
 
 	} else if (io_u->ddir == DDIR_READ) {
-#ifdef CONFIG_RBD_BLKIN
-		blkin_init_trace_info(&fri->info);
-		r = rbd_aio_read_traced(rbd->image, io_u->offset, io_u->xfer_buflen,
-					io_u->xfer_buf, fri->completion, &fri->info);
-#else
 		r = rbd_aio_read(rbd->image, io_u->offset, io_u->xfer_buflen,
 					io_u->xfer_buf, fri->completion);
-#endif
 
 		if (r < 0) {
 			log_err("rbd_aio_read failed.\n");
diff --git a/ioengines.c b/ioengines.c
index 5dd2311..965581a 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -498,8 +498,8 @@ int td_io_open_file(struct thread_data *td, struct fio_file *f)
 		}
 
 		if (posix_fadvise(f->fd, f->file_offset, f->io_size, flags) < 0) {
-			td_verror(td, errno, "fadvise");
-			goto err;
+			if (!fio_did_warn(FIO_WARN_FADVISE))
+				log_err("fio: fadvise hint failed\n");
 		}
 	}
 #ifdef FIO_HAVE_WRITE_HINT
diff --git a/stat.c b/stat.c
index 5bbc056..f89913b 100644
--- a/stat.c
+++ b/stat.c
@@ -18,7 +18,7 @@
 #include "helper_thread.h"
 #include "smalloc.h"
 
-#define LOG_MSEC_SLACK	10
+#define LOG_MSEC_SLACK	1
 
 struct fio_mutex *stat_mutex;
 
@@ -2340,9 +2340,11 @@ static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed,
 		__add_stat_to_log(iolog, ddir, elapsed, log_max);
 }
 
-static long add_log_sample(struct thread_data *td, struct io_log *iolog,
-			   union io_sample_data data, enum fio_ddir ddir,
-			   unsigned int bs, uint64_t offset)
+static unsigned long add_log_sample(struct thread_data *td,
+				    struct io_log *iolog,
+				    union io_sample_data data,
+				    enum fio_ddir ddir, unsigned int bs,
+				    uint64_t offset)
 {
 	unsigned long elapsed, this_window;
 
@@ -2373,7 +2375,7 @@ static long add_log_sample(struct thread_data *td, struct io_log *iolog,
 	if (elapsed < iolog->avg_last[ddir])
 		return iolog->avg_last[ddir] - elapsed;
 	else if (this_window < iolog->avg_msec) {
-		int diff = iolog->avg_msec - this_window;
+		unsigned long diff = iolog->avg_msec - this_window;
 
 		if (inline_log(iolog) || diff > LOG_MSEC_SLACK)
 			return diff;
@@ -2562,7 +2564,7 @@ static int __add_samples(struct thread_data *td, struct timespec *parent_tv,
 {
 	unsigned long spent, rate;
 	enum fio_ddir ddir;
-	unsigned int next, next_log;
+	unsigned long next, next_log;
 
 	next_log = avg_time;
 
