Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39902 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750820AbcJTMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Oct 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bxC0x-0005rP-Nr
        for fio@vger.kernel.org; Thu, 20 Oct 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161020120001.DFD372C302E@kernel.dk>
Date: Thu, 20 Oct 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0228cfe7bb04b3c8329f8e77ee47e30e1a5a03cd:

  HOWTO: update to include iolog replay (2016-10-18 09:12:45 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 99350ae471e1271cae7bb3ef68b5ee0e11c21828:

  Merge branch 'rbd-poll' (2016-10-19 09:24:04 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      rbd: poll cleanups
      Merge branch 'rbd-poll'

Pan Liu (1):
      use poll() and rbd_poll_io_events to speed up io retrieval.

 configure     | 29 ++++++++++++++++++++++
 engines/rbd.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 105 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index e91ec25..833b6d3 100755
--- a/configure
+++ b/configure
@@ -1335,6 +1335,32 @@ fi
 echo "Rados Block Device engine     $rbd"
 
 ##########################################
+# check for rbd_poll
+rbd_poll="no"
+if test "$rbd" = "yes"; then
+cat > $TMPC << EOF
+#include <rbd/librbd.h>
+#include <sys/eventfd.h>
+
+int main(int argc, char **argv)
+{
+  rbd_image_t image;
+  rbd_completion_t comp;
+
+  int fd = eventfd(0, EFD_NONBLOCK);
+  rbd_set_image_notification(image, fd, EVENT_TYPE_EVENTFD);
+  rbd_poll_io_events(image, comp, 1);
+
+  return 0;
+}
+EOF
+if compile_prog "" "-lrbd -lrados" "rbd"; then
+  rbd_poll="yes"
+fi
+echo "rbd_poll                      $rbd_poll"
+fi
+
+##########################################
 # check for rbd_invaidate_cache()
 rbd_inval="no"
 if test "$rbd" = "yes"; then
@@ -1853,6 +1879,9 @@ fi
 if test "$rbd" = "yes" ; then
   output_sym "CONFIG_RBD"
 fi
+if test "$rbd_poll" = "yes" ; then
+  output_sym "CONFIG_RBD_POLL"
+fi
 if test "$rbd_inval" = "yes" ; then
   output_sym "CONFIG_RBD_INVAL"
 fi
diff --git a/engines/rbd.c b/engines/rbd.c
index 5e17fbe..aa50c80 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -13,6 +13,12 @@
 #include <zipkin_c.h>
 #endif
 
+#ifdef CONFIG_RBD_POLL
+/* add for poll */
+#include <poll.h>
+#include <sys/eventfd.h>
+#endif
+
 struct fio_rbd_iou {
 	struct io_u *io_u;
 	rbd_completion_t completion;
@@ -29,6 +35,7 @@ struct rbd_data {
 	rbd_image_t image;
 	struct io_u **aio_events;
 	struct io_u **sort_events;
+	int fd; /* add for poll */
 };
 
 struct rbd_options {
@@ -104,6 +111,9 @@ static int _fio_setup_rbd_data(struct thread_data *td,
 	if (!rbd)
 		goto failed;
 
+	/* add for poll, init fd: -1 */
+	rbd->fd = -1;
+
 	rbd->aio_events = calloc(td->o.iodepth, sizeof(struct io_u *));
 	if (!rbd->aio_events)
 		goto failed;
@@ -127,6 +137,35 @@ failed:
 
 }
 
+#ifdef CONFIG_RBD_POLL
+static bool _fio_rbd_setup_poll(struct rbd_data *rbd)
+{
+	int r;
+
+	/* add for rbd poll */
+	rbd->fd = eventfd(0, EFD_NONBLOCK);
+	if (rbd->fd < 0) {
+		log_err("eventfd failed.\n");
+		return false;
+	}
+
+	r = rbd_set_image_notification(rbd->image, rbd->fd, EVENT_TYPE_EVENTFD);
+	if (r < 0) {
+		log_err("rbd_set_image_notification failed.\n");
+		close(rbd->fd);
+		rbd->fd = -1;
+		return false;
+	}
+
+	return true;
+}
+#else
+static bool _fio_rbd_setup_poll(struct rbd_data *rbd)
+{
+	return true;
+}
+#endif
+
 static int _fio_rbd_connect(struct thread_data *td)
 {
 	struct rbd_data *rbd = td->io_ops_data;
@@ -188,8 +227,15 @@ static int _fio_rbd_connect(struct thread_data *td)
 		log_err("rbd_open failed.\n");
 		goto failed_open;
 	}
+
+	if (!_fio_rbd_setup_poll(rbd))
+		goto failed_poll;
+
 	return 0;
 
+failed_poll:
+	rbd_close(rbd->image);
+	rbd->image = NULL;
 failed_open:
 	rados_ioctx_destroy(rbd->io_ctx);
 	rbd->io_ctx = NULL;
@@ -205,6 +251,12 @@ static void _fio_rbd_disconnect(struct rbd_data *rbd)
 	if (!rbd)
 		return;
 
+	/* close eventfd */
+	if (rbd->fd != -1) {
+		close(rbd->fd);
+		rbd->fd = -1;
+	}
+
 	/* shutdown everything */
 	if (rbd->image) {
 		rbd_close(rbd->image);
@@ -304,10 +356,32 @@ static int rbd_iter_events(struct thread_data *td, unsigned int *events,
 	struct rbd_data *rbd = td->io_ops_data;
 	unsigned int this_events = 0;
 	struct io_u *io_u;
-	int i, sidx;
+	int i, sidx = 0;
+
+#ifdef CONFIG_RBD_POLL
+	int ret = 0;
+	int event_num = 0;
+	struct fio_rbd_iou *fri = NULL;
+	rbd_completion_t comps[min_evts];
 
-	sidx = 0;
+	struct pollfd pfd;
+	pfd.fd = rbd->fd;
+	pfd.events = POLLIN;
+
+	ret = poll(&pfd, 1, -1);
+	if (ret <= 0)
+		return 0;
+
+	assert(pfd.revents & POLLIN);
+
+	event_num = rbd_poll_io_events(rbd->image, comps, min_evts);
+
+	for (i = 0; i < event_num; i++) {
+		fri = rbd_aio_get_arg(comps[i]);
+		io_u = fri->io_u;
+#else
 	io_u_qiter(&td->io_u_all, io_u, i) {
+#endif
 		if (!(io_u->flags & IO_U_F_FLIGHT))
 			continue;
 		if (rbd_io_u_seen(io_u))
