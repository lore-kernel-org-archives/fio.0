Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A631AC7619A
	for <fio@archiver.kernel.org>; Wed,  5 Apr 2023 12:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbjDEMAN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 5 Apr 2023 08:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237597AbjDEMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Apr 2023 08:00:12 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E7219B2
        for <fio@vger.kernel.org>; Wed,  5 Apr 2023 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=YZEgQpNh1gyFQD3tZb6s+Uqh0fnvJyikQZIsYo5901c=; b=YrCdU3fJ7skehvbo9YgX/GT3XZ
        pMe87bse0XKRyww3Cyu4H1eJcDj8/CeWhtynyhw6uvZNkXEqF5+DA9UYtA2vHG1Y5M4pKQGwx6XAv
        N7YfWzUmOPiIixYcRdrJreMvDshio+/b+sWsdbXN+kKhIBdPcT33LrrVCv4PH2JyH3iZmX8RDBLVC
        PUxTTmax+Pn5uR87Vg2j8cuHH2kxCicpwFPTXq/r7OUv2gl+TSfunmG/ExwJKhIbVPU5woN65jlTy
        3oPQP9xvVZGCUB4W6Oa4kNTBCQjp/9dY6d+PpAM1Rt2LpaqPAAPranejxAluOlznluO5kzI3q95tu
        AMQUGxAQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pk1o3-009u8c-34
        for fio@vger.kernel.org;
        Wed, 05 Apr 2023 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 751121BC012D; Wed,  5 Apr 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230405120001.751121BC012D@kernel.dk>
Date:   Wed,  5 Apr 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 638689b15af35bd746f9114a3e8895e7a983ed83:

  Only expose fadvise_hint=noreuse if supported (2023-03-31 12:52:01 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2d8c2709dc067aabdeab8bc1eea1992d9d802375:

  io_u: fix bad style (2023-04-04 09:49:19 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      Merge branch 'master' of https://github.com/SuhoSon/fio
      engines/nvme: cache errno value
      engines/nfs: fix the most egregious style violations
      io_u: fix bad style

suho.son (1):
      thinktime: Fix missing re-init thinktime when using ramptime

 engines/nfs.c  | 147 ++++++++++++++++++++++++++++++++++-----------------------
 engines/nvme.c |   6 ++-
 fio.h          |   2 +-
 io_u.c         |   4 +-
 libfio.c       |   6 +++
 5 files changed, 102 insertions(+), 63 deletions(-)

---

Diff of recent changes:

diff --git a/engines/nfs.c b/engines/nfs.c
index 7031769d..336e670b 100644
--- a/engines/nfs.c
+++ b/engines/nfs.c
@@ -16,10 +16,17 @@ enum nfs_op_type {
 struct fio_libnfs_options {
 	struct nfs_context *context;
 	char *nfs_url;
-	unsigned int queue_depth; /* nfs_callback needs this info, but doesn't have fio td structure to pull it from */
+	/* nfs_callback needs this info, but doesn't have fio td structure to
+	 * pull it from
+	 */
+	unsigned int queue_depth;
+
 	/* the following implement a circular queue of outstanding IOs */
-	int outstanding_events; /* IOs issued to libnfs, that have not returned yet */
-	int prev_requested_event_index; /* event last returned via fio_libnfs_event */
+
+	/* IOs issued to libnfs, that have not returned yet */
+	int outstanding_events;
+	/* event last returned via fio_libnfs_event */
+	int prev_requested_event_index;
 	int next_buffered_event; /* round robin-pointer within events[] */
 	int buffered_event_count; /* IOs completed by libnfs, waiting for FIO */
 	int free_event_buffer_index; /* next free buffer */
@@ -33,11 +40,12 @@ struct nfs_data {
 
 static struct fio_option options[] = {
 	{
-		.name     = "nfs_url",
-		.lname    = "nfs_url",
-		.type     = FIO_OPT_STR_STORE,
-		.help	= "URL in libnfs format, eg nfs://<server|ipv4|ipv6>/path[?arg=val[&arg=val]*]",
-		.off1     = offsetof(struct fio_libnfs_options, nfs_url),
+		.name	= "nfs_url",
+		.lname	= "nfs_url",
+		.type	= FIO_OPT_STR_STORE,
+		.help	= "URL in libnfs format, eg nfs://<server|ipv4|"
+			  "ipv6>/path[?arg=val[&arg=val]*]",
+		.off1	= offsetof(struct fio_libnfs_options, nfs_url),
 		.category = FIO_OPT_C_ENGINE,
 		.group	= __FIO_OPT_G_NFS,
 	},
@@ -50,44 +58,53 @@ static struct io_u *fio_libnfs_event(struct thread_data *td, int event)
 {
 	struct fio_libnfs_options *o = td->eo;
 	struct io_u *io_u = o->events[o->next_buffered_event];
+
 	assert(o->events[o->next_buffered_event]);
 	o->events[o->next_buffered_event] = NULL;
 	o->next_buffered_event = (o->next_buffered_event + 1) % td->o.iodepth;
+
 	/* validate our state machine */
 	assert(o->buffered_event_count);
 	o->buffered_event_count--;
 	assert(io_u);
+
 	/* assert that fio_libnfs_event is being called in sequential fashion */
 	assert(event == 0 || o->prev_requested_event_index + 1 == event);
-	if (o->buffered_event_count == 0) {
+	if (o->buffered_event_count == 0)
 		o->prev_requested_event_index = -1;
-	} else {
+	else
 		o->prev_requested_event_index = event;
-	}
 	return io_u;
 }
 
-static int nfs_event_loop(struct thread_data *td, bool flush) {
+/*
+ * fio core logic seems to stop calling this event-loop if we ever return with
+ * 0 events
+ */
+#define SHOULD_WAIT(td, o, flush)			\
+ 	((o)->outstanding_events == (td)->o.iodepth ||	\
+		(flush && (o)->outstanding_events))
+
+static int nfs_event_loop(struct thread_data *td, bool flush)
+{
 	struct fio_libnfs_options *o = td->eo;
 	struct pollfd pfds[1]; /* nfs:0 */
+
 	/* we already have stuff queued for fio, no need to waste cpu on poll() */
 	if (o->buffered_event_count)
 		return o->buffered_event_count;
-	/* fio core logic seems to stop calling this event-loop if we ever return with 0 events */
-	#define SHOULD_WAIT() (o->outstanding_events == td->o.iodepth || (flush && o->outstanding_events))
 
 	do {
-		int timeout = SHOULD_WAIT() ? -1 : 0;
+		int timeout = SHOULD_WAIT(td, o, flush) ? -1 : 0;
 		int ret = 0;
+
 		pfds[0].fd = nfs_get_fd(o->context);
 		pfds[0].events = nfs_which_events(o->context);
 		ret = poll(&pfds[0], 1, timeout);
 		if (ret < 0) {
-			if (errno == EINTR || errno == EAGAIN) {
+			if (errno == EINTR || errno == EAGAIN)
 				continue;
-			}
-			log_err("nfs: failed to poll events: %s.\n",
-				strerror(errno));
+			log_err("nfs: failed to poll events: %s\n", strerror(errno));
 			break;
 		}
 
@@ -96,27 +113,30 @@ static int nfs_event_loop(struct thread_data *td, bool flush) {
 			log_err("nfs: socket is in an unrecoverable error state.\n");
 			break;
 		}
-	} while (SHOULD_WAIT());
+	} while (SHOULD_WAIT(td, o, flush));
+
 	return o->buffered_event_count;
-#undef SHOULD_WAIT
 }
 
 static int fio_libnfs_getevents(struct thread_data *td, unsigned int min,
-				  unsigned int max, const struct timespec *t)
+				unsigned int max, const struct timespec *t)
 {
 	return nfs_event_loop(td, false);
 }
 
 static void nfs_callback(int res, struct nfs_context *nfs, void *data,
-                       void *private_data)
+			 void *private_data)
 {
 	struct io_u *io_u = private_data;
 	struct nfs_data *nfs_data = io_u->file->engine_data;
 	struct fio_libnfs_options *o = nfs_data->options;
 	if (res < 0) {
-		log_err("Failed NFS operation(code:%d): %s\n", res, nfs_get_error(o->context));
+		log_err("Failed NFS operation(code:%d): %s\n", res,
+						nfs_get_error(o->context));
 		io_u->error = -res;
-		/* res is used for read math below, don't wanna pass negative there */
+		/* res is used for read math below, don't want to pass negative
+		 * there
+		 */
 		res = 0;
 	} else if (io_u->ddir == DDIR_READ) {
 		memcpy(io_u->buf, data, res);
@@ -133,42 +153,46 @@ static void nfs_callback(int res, struct nfs_context *nfs, void *data,
 	o->buffered_event_count++;
 }
 
-static int queue_write(struct fio_libnfs_options *o, struct io_u *io_u) {
+static int queue_write(struct fio_libnfs_options *o, struct io_u *io_u)
+{
 	struct nfs_data *nfs_data = io_u->engine_data;
-	return nfs_pwrite_async(o->context, nfs_data->nfsfh,
-                           io_u->offset, io_u->buflen, io_u->buf, nfs_callback,
-                           io_u);
+
+	return nfs_pwrite_async(o->context, nfs_data->nfsfh, io_u->offset,
+				io_u->buflen, io_u->buf, nfs_callback, io_u);
 }
 
-static int queue_read(struct fio_libnfs_options *o, struct io_u *io_u) {
+static int queue_read(struct fio_libnfs_options *o, struct io_u *io_u)
+{
 	struct nfs_data *nfs_data = io_u->engine_data;
-	return nfs_pread_async(o->context,  nfs_data->nfsfh, io_u->offset, io_u->buflen, nfs_callback,  io_u);
+
+	return nfs_pread_async(o->context, nfs_data->nfsfh, io_u->offset,
+				io_u->buflen, nfs_callback, io_u);
 }
 
 static enum fio_q_status fio_libnfs_queue(struct thread_data *td,
-					    struct io_u *io_u)
+					  struct io_u *io_u)
 {
 	struct nfs_data *nfs_data = io_u->file->engine_data;
 	struct fio_libnfs_options *o = nfs_data->options;
 	struct nfs_context *nfs = o->context;
-	int err;
 	enum fio_q_status ret = FIO_Q_QUEUED;
+	int err;
 
 	io_u->engine_data = nfs_data;
-	switch(io_u->ddir) {
-		case DDIR_WRITE:
-			err = queue_write(o, io_u);
-			break;
-		case DDIR_READ:
-			err = queue_read(o, io_u);
-			break;
-		case DDIR_TRIM:
-			log_err("nfs: trim is not supported");
-			err = -1;
-			break;
-		default:
-			log_err("nfs: unhandled io %d\n", io_u->ddir);
-			err = -1;
+	switch (io_u->ddir) {
+	case DDIR_WRITE:
+		err = queue_write(o, io_u);
+		break;
+	case DDIR_READ:
+		err = queue_read(o, io_u);
+		break;
+	case DDIR_TRIM:
+		log_err("nfs: trim is not supported");
+		err = -1;
+		break;
+	default:
+		log_err("nfs: unhandled io %d\n", io_u->ddir);
+		err = -1;
 	}
 	if (err) {
 		log_err("nfs: Failed to queue nfs op: %s\n", nfs_get_error(nfs));
@@ -195,7 +219,7 @@ static int do_mount(struct thread_data *td, const char *url)
 		return 0;
 
 	options->context = nfs_init_context();
-	if (options->context == NULL) {
+	if (!options->context) {
 		log_err("nfs: failed to init nfs context\n");
 		return -1;
 	}
@@ -219,7 +243,9 @@ static int do_mount(struct thread_data *td, const char *url)
 
 static int fio_libnfs_setup(struct thread_data *td)
 {
-	/* Using threads with libnfs causes fio to hang on exit, lower performance */
+	/* Using threads with libnfs causes fio to hang on exit, lower
+	 * performance
+	 */
 	td->o.use_thread = 0;
 	return 0;
 }
@@ -227,6 +253,7 @@ static int fio_libnfs_setup(struct thread_data *td)
 static void fio_libnfs_cleanup(struct thread_data *td)
 {
 	struct fio_libnfs_options *o = td->eo;
+
 	nfs_umount(o->context);
 	nfs_destroy_context(o->context);
 	free(o->events);
@@ -234,10 +261,10 @@ static void fio_libnfs_cleanup(struct thread_data *td)
 
 static int fio_libnfs_open(struct thread_data *td, struct fio_file *f)
 {
-	int ret;
 	struct fio_libnfs_options *options = td->eo;
 	struct nfs_data *nfs_data = NULL;
 	int flags = 0;
+	int ret;
 
 	if (!options->nfs_url) {
 		log_err("nfs: nfs_url is a required parameter\n");
@@ -246,23 +273,25 @@ static int fio_libnfs_open(struct thread_data *td, struct fio_file *f)
 
 	ret = do_mount(td, options->nfs_url);
 
-	if (ret != 0) {
-		log_err("nfs: Failed to mount %s with code %d: %s\n", options->nfs_url, ret, nfs_get_error(options->context));
+	if (ret) {
+		log_err("nfs: Failed to mount %s with code %d: %s\n",
+			options->nfs_url, ret, nfs_get_error(options->context));
 		return ret;
 	}
 	nfs_data = malloc(sizeof(struct nfs_data));
 	memset(nfs_data, 0, sizeof(struct nfs_data));
 	nfs_data->options = options;
 
-	if (td->o.td_ddir == TD_DDIR_WRITE) {
+	if (td->o.td_ddir == TD_DDIR_WRITE)
 		flags |= O_CREAT | O_RDWR;
-	} else {
+	else
 		flags |= O_RDWR;
-	}
+
 	ret = nfs_open(options->context, f->file_name, flags, &nfs_data->nfsfh);
 
-	if (ret != 0)
-		log_err("Failed to open %s: %s\n", f->file_name, nfs_get_error(options->context));
+	if (ret)
+		log_err("Failed to open %s: %s\n", f->file_name,
+					nfs_get_error(options->context));
 	f->engine_data = nfs_data;
 	return ret;
 }
@@ -272,8 +301,10 @@ static int fio_libnfs_close(struct thread_data *td, struct fio_file *f)
 	struct nfs_data *nfs_data = f->engine_data;
 	struct fio_libnfs_options *o = nfs_data->options;
 	int ret = 0;
+
 	if (nfs_data->nfsfh)
 		ret = nfs_close(o->context, nfs_data->nfsfh);
+
 	free(nfs_data);
 	f->engine_data = NULL;
 	return ret;
@@ -289,7 +320,7 @@ struct ioengine_ops ioengine = {
 	.cleanup	= fio_libnfs_cleanup,
 	.open_file	= fio_libnfs_open,
 	.close_file	= fio_libnfs_close,
-	.flags      = FIO_DISKLESSIO | FIO_NOEXTEND | FIO_NODISKUTIL,
+	.flags		= FIO_DISKLESSIO | FIO_NOEXTEND | FIO_NODISKUTIL,
 	.options	= options,
 	.option_struct_size	= sizeof(struct fio_libnfs_options),
 };
diff --git a/engines/nvme.c b/engines/nvme.c
index ac908687..fd2161f3 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -112,9 +112,10 @@ int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
 
 	namespace_id = ioctl(fd, NVME_IOCTL_ID);
 	if (namespace_id < 0) {
+		err = -errno;
 		log_err("failed to fetch namespace-id");
 		close(fd);
-		return -errno;
+		return err;
 	}
 
 	/*
@@ -414,6 +415,7 @@ int fio_nvme_iomgmt_ruhs(struct thread_data *td, struct fio_file *f,
 	} else
 		errno = 0;
 
+	ret = -errno;
 	close(fd);
-	return -errno;
+	return ret;
 }
diff --git a/fio.h b/fio.h
index f2acd430..6b841e9c 100644
--- a/fio.h
+++ b/fio.h
@@ -377,7 +377,7 @@ struct thread_data {
 
 	uint64_t *thinktime_blocks_counter;
 	struct timespec last_thinktime;
-	uint64_t last_thinktime_blocks;
+	int64_t last_thinktime_blocks;
 
 	/*
 	 * State for random io, a bitmap of blocks done vs not done
diff --git a/io_u.c b/io_u.c
index ca7ee68f..30265cfb 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1370,8 +1370,8 @@ static struct fio_file *__get_next_file(struct thread_data *td)
 		if (td->o.file_service_type == FIO_FSERVICE_SEQ)
 			goto out;
 		if (td->file_service_left) {
-		  td->file_service_left--;
-		  goto out;
+			td->file_service_left--;
+			goto out;
 		}
 	}
 
diff --git a/libfio.c b/libfio.c
index a52014ce..ddd49cd7 100644
--- a/libfio.c
+++ b/libfio.c
@@ -131,10 +131,14 @@ void clear_io_state(struct thread_data *td, int all)
 
 void reset_all_stats(struct thread_data *td)
 {
+	unsigned long long b;
 	int i;
 
 	reset_io_counters(td, 1);
 
+	b = ddir_rw_sum(td->thinktime_blocks_counter);
+	td->last_thinktime_blocks -= b;
+
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		td->io_bytes[i] = 0;
 		td->io_blocks[i] = 0;
@@ -149,6 +153,8 @@ void reset_all_stats(struct thread_data *td)
 	memcpy(&td->bw_sample_time, &td->epoch, sizeof(td->epoch));
 	memcpy(&td->ss.prev_time, &td->epoch, sizeof(td->epoch));
 
+	td->last_thinktime = td->epoch;
+
 	lat_target_reset(td);
 	clear_rusage_stat(td);
 	helper_reset();
