Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46212 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbcHCMA4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 3 Aug 2016 08:00:56 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bUuqB-0003bc-KL
	for fio@vger.kernel.org; Wed, 03 Aug 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160803120001.C14212C00A2@kernel.dk>
Date: Wed,  3 Aug 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 059b61f219b15db434eddc2207b876c6a0bad6c0:

  backend: do_verify() cleanup (2016-08-01 13:46:17 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 550beaad94a11beef70dfb4057797ff8800c8a72:

  engines/rbd: fix compile without blkin support (2016-08-02 15:23:43 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      Revert "filesetup: ensure that we align file starting offset"
      Merge branch 'wip-traceinfo' of https://github.com/vears91/fio
      engines/rbd: fix compile without blkin support

vears91 (1):
      Add support for blkin tracing in rbd engine

 configure     | 33 +++++++++++++++++++++++++++++++++
 engines/rbd.c | 18 ++++++++++++++++++
 filesetup.c   |  8 ++------
 3 files changed, 53 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 5f6bca3..93c3720 100755
--- a/configure
+++ b/configure
@@ -166,6 +166,8 @@ for opt do
   ;;
   --disable-rbd) disable_rbd="yes"
   ;;
+  --disable-rbd-blkin) disable_rbd_blkin="yes"
+  ;;
   --disable-gfapi) disable_gfapi="yes"
   ;;
   --enable-libhdfs) libhdfs="yes"
@@ -1334,6 +1336,34 @@ echo "rbd_invalidate_cache          $rbd_inval"
 fi
 
 ##########################################
+# check for blkin
+rbd_blkin="no"
+cat > $TMPC << EOF
+#include <rbd/librbd.h>
+#include <zipkin_c.h>
+
+int main(int argc, char **argv)
+{
+  int r;
+  struct blkin_trace_info t_info;
+  blkin_init_trace_info(&t_info);
+  rbd_completion_t completion;
+  rbd_image_t image;
+  uint64_t off;
+  size_t len;
+  const char *buf;
+  r = rbd_aio_write_traced(image, off, len, buf, completion, &t_info);
+  return 0;
+}
+EOF
+if test "$disable_rbd" != "yes" && test "$disable_rbd_blkin" != "yes" \
+ && compile_prog "" "-lrbd -lrados -lblkin" "rbd_blkin"; then
+  LIBS="-lblkin $LIBS"
+  rbd_blkin="yes"
+fi
+echo "rbd blkin tracing             $rbd_blkin"
+
+##########################################
 # Check whether we have setvbuf
 setvbuf="no"
 cat > $TMPC << EOF
@@ -1778,6 +1808,9 @@ fi
 if test "$rbd_inval" = "yes" ; then
   output_sym "CONFIG_RBD_INVAL"
 fi
+if test "$rbd_blkin" = "yes" ; then
+  output_sym "CONFIG_RBD_BLKIN"
+fi
 if test "$setvbuf" = "yes" ; then
   output_sym "CONFIG_SETVBUF"
 fi
diff --git a/engines/rbd.c b/engines/rbd.c
index c85645a..5e17fbe 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -9,12 +9,18 @@
 
 #include "../fio.h"
 #include "../optgroup.h"
+#ifdef CONFIG_RBD_BLKIN
+#include <zipkin_c.h>
+#endif
 
 struct fio_rbd_iou {
 	struct io_u *io_u;
 	rbd_completion_t completion;
 	int io_seen;
 	int io_complete;
+#ifdef CONFIG_RBD_BLKIN
+	struct blkin_trace_info info;
+#endif
 };
 
 struct rbd_data {
@@ -391,16 +397,28 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 	}
 
 	if (io_u->ddir == DDIR_WRITE) {
+#ifdef CONFIG_RBD_BLKIN
+		blkin_init_trace_info(&fri->info);
+		r = rbd_aio_write_traced(rbd->image, io_u->offset, io_u->xfer_buflen,
+					 io_u->xfer_buf, fri->completion, &fri->info);
+#else
 		r = rbd_aio_write(rbd->image, io_u->offset, io_u->xfer_buflen,
 					 io_u->xfer_buf, fri->completion);
+#endif
 		if (r < 0) {
 			log_err("rbd_aio_write failed.\n");
 			goto failed_comp;
 		}
 
 	} else if (io_u->ddir == DDIR_READ) {
+#ifdef CONFIG_RBD_BLKIN
+		blkin_init_trace_info(&fri->info);
+		r = rbd_aio_read_traced(rbd->image, io_u->offset, io_u->xfer_buflen,
+					io_u->xfer_buf, fri->completion, &fri->info);
+#else
 		r = rbd_aio_read(rbd->image, io_u->offset, io_u->xfer_buflen,
 					io_u->xfer_buf, fri->completion);
+#endif
 
 		if (r < 0) {
 			log_err("rbd_aio_read failed.\n");
diff --git a/filesetup.c b/filesetup.c
index a48faf5..1ecdda6 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -761,16 +761,12 @@ static unsigned long long get_fs_free_counts(struct thread_data *td)
 uint64_t get_start_offset(struct thread_data *td, struct fio_file *f)
 {
 	struct thread_options *o = &td->o;
-	uint64_t offset;
 
 	if (o->file_append && f->filetype == FIO_TYPE_FILE)
 		return f->real_file_size;
 
-	offset = td->o.start_offset + td->subjob_number * td->o.offset_increment;
-	if (offset % td_max_bs(td))
-		offset -= (offset % td_max_bs(td));
-
-	return offset;
+	return td->o.start_offset +
+		td->subjob_number * td->o.offset_increment;
 }
 
 /*
