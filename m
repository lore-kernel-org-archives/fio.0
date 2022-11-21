Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 199C7C433FE
	for <fio@archiver.kernel.org>; Mon, 21 Nov 2022 18:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiKUSae (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 21 Nov 2022 13:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiKUSab (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Nov 2022 13:30:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA16D14D3
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 10:29:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669055366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fKzznMHy2kWLq3qkLozP3XlqFOv2XSOk6/m2Uvw62Ok=;
        b=asi/jvK3wJKhxYT9XAc1USUzDiqZ4h9n6TNW2dm+H3DJ/6lOExHcdqkluf0npqPZ7pVrG8
        IEWe+99uRDd/RpJo6VJvljoU1YlDjMmjAcvgkV5k4VHqqHe/mkV9OtPv+vKT2zhx1BEIiA
        bJtExhwg9RmpWqv7GH+wY8HFAe2cHj4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-8CpIQmCKOkSpUDkiaeQ1-w-1; Mon, 21 Nov 2022 13:29:24 -0500
X-MC-Unique: 8CpIQmCKOkSpUDkiaeQ1-w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CA85101A528
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 18:29:24 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.192.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92C87492B06;
        Mon, 21 Nov 2022 18:29:18 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     fio@vger.kernel.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [PATCH 10/10] engines/libblkio: Share a single blkio instance among threads in same process
Date:   Mon, 21 Nov 2022 18:29:02 +0000
Message-Id: <20221121182902.373491-11-afaria@redhat.com>
In-Reply-To: <20221121182902.373491-1-afaria@redhat.com>
References: <20221121182902.373491-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

fio groups all subjobs that set option 'thread' into a single process.
Have them all share a single `struct blkio` instance, with one `struct
blkioq` per thread/subjob. This allows benchmarking multi-queue setups.

Note that `struct blkio` instances cannot be shared across different
processes.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 HOWTO.rst                                 |   8 +-
 engines/libblkio.c                        | 250 +++++++++++++++++++---
 examples/libblkio-io_uring.fio            |  13 +-
 examples/libblkio-virtio-blk-vfio-pci.fio |  13 +-
 fio.1                                     |   7 +-
 5 files changed, 257 insertions(+), 34 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 763f4f51..4e69abfc 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2199,7 +2199,13 @@ I/O engine
 			:option:`libblkio_driver`. If
 			:option:`mem`/:option:`iomem` is not specified, memory
 			allocation is delegated to libblkio (and so is
-			guaranteed to work with the selected *driver*).
+			guaranteed to work with the selected *driver*). One
+			``struct blkio`` instance is used per process, so all
+			jobs setting option :option:`thread` will share a single
+			``struct blkio`` (with one queue per thread) and must
+			specify compatible options. Note that some drivers don't
+			allow several processes to access the same device or
+			file simultaneously, but allow it for threads.
 
 I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/engines/libblkio.c b/engines/libblkio.c
index a80be66f..987dea4f 100644
--- a/engines/libblkio.c
+++ b/engines/libblkio.c
@@ -249,6 +249,105 @@ static int fio_blkio_set_props_from_str(struct blkio *b, const char *opt_name,
 			blkio_get_error_msg()); \
 	})
 
+static bool possibly_null_strs_equal(const char *a, const char *b)
+{
+	return (!a && !b) || (a && b && strcmp(a, b) == 0);
+}
+
+/*
+ * Returns the total number of subjobs using option 'thread' in the entire
+ * workload that have the given value for the 'hipri' option.
+ */
+static int total_threaded_subjobs(bool hipri)
+{
+	struct thread_data *td;
+	unsigned int i;
+	int count = 0;
+
+	for_each_td(td, i) {
+		const struct fio_blkio_options *options = td->eo;
+		if (td->o.use_thread && (bool)options->hipri == hipri)
+			++count;
+	}
+
+	return count;
+}
+
+static struct {
+	bool set_up;
+	bool direct;
+	struct fio_blkio_options opts;
+} first_threaded_subjob = { 0 };
+
+static void fio_blkio_log_opt_compat_err(const char *option_name)
+{
+	log_err("fio: jobs using engine libblkio and sharing a process must agree on the %s option\n",
+		option_name);
+}
+
+/*
+ * If td represents a subjob with option 'thread', check if its options are
+ * compatible with those of other threaded subjobs that were already set up.
+ */
+static int fio_blkio_check_opt_compat(struct thread_data *td)
+{
+	const struct fio_blkio_options *options = td->eo, *prev_options;
+
+	if (!td->o.use_thread)
+		return 0; /* subjob doesn't use 'thread' */
+
+	if (!first_threaded_subjob.set_up) {
+		/* first subjob using 'thread', store options for later */
+		first_threaded_subjob.set_up	= true;
+		first_threaded_subjob.direct	= td->o.odirect;
+		first_threaded_subjob.opts	= *options;
+		return 0;
+	}
+
+	/* not first subjob using 'thread', check option compatibility */
+
+	prev_options = &first_threaded_subjob.opts;
+
+	if (td->o.odirect != first_threaded_subjob.direct) {
+		fio_blkio_log_opt_compat_err("direct/buffered");
+		return 1;
+	}
+
+	if (strcmp(options->driver, prev_options->driver) != 0) {
+		fio_blkio_log_opt_compat_err("libblkio_driver");
+		return 1;
+	}
+
+	if (!possibly_null_strs_equal(options->path, prev_options->path)) {
+		fio_blkio_log_opt_compat_err("libblkio_path");
+		return 1;
+	}
+
+	if (!possibly_null_strs_equal(options->pre_connect_props,
+				      prev_options->pre_connect_props)) {
+		fio_blkio_log_opt_compat_err("libblkio_pre_connect_props");
+		return 1;
+	}
+
+	if (options->num_entries != prev_options->num_entries) {
+		fio_blkio_log_opt_compat_err("libblkio_num_entries");
+		return 1;
+	}
+
+	if (options->queue_size != prev_options->queue_size) {
+		fio_blkio_log_opt_compat_err("libblkio_queue_size");
+		return 1;
+	}
+
+	if (!possibly_null_strs_equal(options->pre_start_props,
+				      prev_options->pre_start_props)) {
+		fio_blkio_log_opt_compat_err("libblkio_pre_start_props");
+		return 1;
+	}
+
+	return 0;
+}
+
 static int fio_blkio_create_and_connect(struct thread_data *td,
 					struct blkio **out_blkio)
 {
@@ -329,6 +428,8 @@ err_blkio_destroy:
 	return 1;
 }
 
+static bool incompatible_threaded_subjob_options = false;
+
 static int fio_blkio_setup(struct thread_data *td)
 {
 	/*
@@ -348,6 +449,11 @@ static int fio_blkio_setup(struct thread_data *td)
 
 	/* validate options */
 
+	if (fio_blkio_check_opt_compat(td) != 0) {
+		incompatible_threaded_subjob_options = true;
+		return 1;
+	}
+
 	if (options->hipri &&
 		options->wait_mode == FIO_BLKIO_WAIT_MODE_EVENTFD) {
 		log_err("fio: option hipri is incompatible with option libblkio_wait_mode=eventfd\n");
@@ -380,9 +486,16 @@ out_blkio_destroy:
 	return ret;
 }
 
+/* per-process state */
+static struct {
+	pthread_mutex_t mutex;
+	int initted_threads;
+	int initted_hipri_threads;
+	struct blkio *b;
+} proc_state = { PTHREAD_MUTEX_INITIALIZER, 0, 0, NULL };
+
 /* per-thread state */
 struct fio_blkio_data {
-	struct blkio *b;
 	struct blkioq *q;
 	int completion_fd; /* may be -1 if not FIO_BLKIO_WAIT_MODE_EVENTFD */
 
@@ -393,12 +506,33 @@ struct fio_blkio_data {
 	struct blkio_completion *completions;
 };
 
+static void fio_blkio_proc_lock(void) {
+	int ret;
+	ret = pthread_mutex_lock(&proc_state.mutex);
+	assert(ret == 0);
+}
+
+static void fio_blkio_proc_unlock(void) {
+	int ret;
+	ret = pthread_mutex_unlock(&proc_state.mutex);
+	assert(ret == 0);
+}
+
 static int fio_blkio_init(struct thread_data *td)
 {
 	const struct fio_blkio_options *options = td->eo;
 	struct fio_blkio_data *data;
 	int flags;
 
+	if (td->o.use_thread && incompatible_threaded_subjob_options) {
+		/*
+		 * Different subjobs using option 'thread' specified
+		 * incompatible options. We don't know which configuration
+		 * should win, so we just fail all such subjobs.
+		 */
+		return 1;
+	}
+
 	/* allocate per-thread data struct */
 
 	data = calloc(1, sizeof(*data));
@@ -414,33 +548,54 @@ static int fio_blkio_init(struct thread_data *td)
 		goto err_free;
 	}
 
-	/* create, connect, and start blkio */
+	/* initialize per-process blkio */
 
-	if (fio_blkio_create_and_connect(td, &data->b) != 0)
-		goto err_free;
+	fio_blkio_proc_lock();
 
-	if (blkio_set_int(data->b, "num-queues", options->hipri ? 0 : 1) != 0) {
-		fio_blkio_log_err(blkio_set_int);
-		goto err_blkio_destroy;
-	}
+	if (proc_state.initted_threads == 0) {
+		int num_queues, num_poll_queues;
 
-	if (blkio_set_int(data->b, "num-poll-queues",
-			  options->hipri ? 1 : 0) != 0) {
-		fio_blkio_log_err(blkio_set_int);
-		goto err_blkio_destroy;
-	}
+		if (td->o.use_thread) {
+			num_queues 	= total_threaded_subjobs(false);
+			num_poll_queues = total_threaded_subjobs(true);
+		} else {
+			num_queues 	= options->hipri ? 0 : 1;
+			num_poll_queues = options->hipri ? 1 : 0;
+		}
 
-	if (blkio_start(data->b) != 0) {
-		fio_blkio_log_err(blkio_start);
-		goto err_blkio_destroy;
+		/* create, connect, and start blkio */
+
+		if (fio_blkio_create_and_connect(td, &proc_state.b) != 0)
+			goto err_unlock;
+
+		if (blkio_set_int(proc_state.b, "num-queues",
+				  num_queues) != 0) {
+			fio_blkio_log_err(blkio_set_int);
+			goto err_blkio_destroy;
+		}
+
+		if (blkio_set_int(proc_state.b, "num-poll-queues",
+				  num_poll_queues) != 0) {
+			fio_blkio_log_err(blkio_set_int);
+			goto err_blkio_destroy;
+		}
+
+		if (blkio_start(proc_state.b) != 0) {
+			fio_blkio_log_err(blkio_start);
+			goto err_blkio_destroy;
+		}
 	}
 
-	/* get queue */
+	/* get per-thread queue */
 
-	if (options->hipri)
-		data->q = blkio_get_poll_queue(data->b, 0);
-	else
-		data->q = blkio_get_queue(data->b, 0);
+	if (options->hipri) {
+		int i = proc_state.initted_hipri_threads;
+		data->q = blkio_get_poll_queue(proc_state.b, i);
+	} else {
+		int i = proc_state.initted_threads -
+				proc_state.initted_hipri_threads;
+		data->q = blkio_get_queue(proc_state.b, i);
+	}
 
 	/* enable completion fd and make it blocking */
 
@@ -468,13 +623,25 @@ static int fio_blkio_init(struct thread_data *td)
 		data->completion_fd = -1;
 	}
 
+	++proc_state.initted_threads;
+
+	if (options->hipri)
+		++proc_state.initted_hipri_threads;
+
 	/* Set data only here so cleanup() does nothing if init() fails. */
 	td->io_ops_data = data;
 
+	fio_blkio_proc_unlock();
+
 	return 0;
 
 err_blkio_destroy:
-	blkio_destroy(&data->b);
+	if (proc_state.initted_threads == 0)
+		blkio_destroy(&proc_state.b);
+err_unlock:
+	if (proc_state.initted_threads == 0)
+		proc_state.b = NULL;
+	fio_blkio_proc_unlock();
 err_free:
 	free(data->completions);
 	free(data->iovecs);
@@ -514,7 +681,7 @@ static int fio_blkio_post_init(struct thread_data *td)
 			.fd	= -1,
 		};
 
-		if (blkio_map_mem_region(data->b, &region) != 0) {
+		if (blkio_map_mem_region(proc_state.b, &region) != 0) {
 			fio_blkio_log_err(blkio_map_mem_region);
 			return 1;
 		}
@@ -527,11 +694,27 @@ static void fio_blkio_cleanup(struct thread_data *td)
 {
 	struct fio_blkio_data *data = td->io_ops_data;
 
+	/*
+	 * Subjobs from different jobs can be terminated at different times, so
+	 * this callback may be invoked for one subjob while another is still
+	 * doing I/O. Those subjobs may share the process, so we must wait until
+	 * the last subjob in the process wants to clean up to actually destroy
+	 * the blkio.
+	 */
+
 	if (data) {
-		blkio_destroy(&data->b);
 		free(data->completions);
 		free(data->iovecs);
 		free(data);
+
+		fio_blkio_proc_lock();
+
+		if (--proc_state.initted_threads == 0) {
+			blkio_destroy(&proc_state.b);
+			proc_state.b = NULL;
+		}
+
+		fio_blkio_proc_unlock();
 	}
 }
 
@@ -546,7 +729,7 @@ static int fio_blkio_iomem_alloc(struct thread_data *td, size_t size)
 
 	/* round up size to satisfy mem-region-alignment */
 
-	if (blkio_get_uint64(data->b, "mem-region-alignment",
+	if (blkio_get_uint64(proc_state.b, "mem-region-alignment",
 			     &mem_region_alignment) != 0) {
 		fio_blkio_log_err(blkio_get_uint64);
 		return 1;
@@ -556,14 +739,16 @@ static int fio_blkio_iomem_alloc(struct thread_data *td, size_t size)
 
 	/* allocate memory region */
 
-	if (blkio_alloc_mem_region(data->b, &data->mem_region,
+	fio_blkio_proc_lock();
+
+	if (blkio_alloc_mem_region(proc_state.b, &data->mem_region,
 				   aligned_size) != 0) {
 		fio_blkio_log_err(blkio_alloc_mem_region);
 		ret = 1;
 		goto out;
 	}
 
-	if (blkio_map_mem_region(data->b, &data->mem_region) != 0) {
+	if (blkio_map_mem_region(proc_state.b, &data->mem_region) != 0) {
 		fio_blkio_log_err(blkio_map_mem_region);
 		ret = 1;
 		goto out_free;
@@ -576,8 +761,9 @@ static int fio_blkio_iomem_alloc(struct thread_data *td, size_t size)
 	goto out;
 
 out_free:
-	blkio_free_mem_region(data->b, &data->mem_region);
+	blkio_free_mem_region(proc_state.b, &data->mem_region);
 out:
+	fio_blkio_proc_unlock();
 	return ret;
 }
 
@@ -586,8 +772,12 @@ static void fio_blkio_iomem_free(struct thread_data *td)
 	struct fio_blkio_data *data = td->io_ops_data;
 
 	if (data && data->has_mem_region) {
-		blkio_unmap_mem_region(data->b, &data->mem_region);
-		blkio_free_mem_region(data->b, &data->mem_region);
+		fio_blkio_proc_lock();
+
+		blkio_unmap_mem_region(proc_state.b, &data->mem_region);
+		blkio_free_mem_region(proc_state.b, &data->mem_region);
+
+		fio_blkio_proc_unlock();
 
 		data->has_mem_region = false;
 	}
diff --git a/examples/libblkio-io_uring.fio b/examples/libblkio-io_uring.fio
index e5885094..99a79dbe 100644
--- a/examples/libblkio-io_uring.fio
+++ b/examples/libblkio-io_uring.fio
@@ -3,6 +3,10 @@
 ; Replace "libblkio_path" below with the path to your file or device, or
 ; override it by passing the '--libblkio_path=...' flag to fio.
 ;
+; In the example below, the two subjobs of "job-B" *and* the single subjob of
+; "job-C" will share a single `struct blkio` instance, and "job-A" will use a
+; separate `struct blkio` instance.
+;
 ; For information on libblkio, see: https://gitlab.com/libblkio/libblkio
 
 [global]
@@ -15,4 +19,11 @@ direct=1
 time_based=1
 runtime=10s
 
-[job]
+[job-A]
+
+[job-B]
+numjobs=2  ; run two copies of this job simultaneously
+thread=1   ; have each copy run as a separate thread in the *same* process
+
+[job-C]
+thread=1  ; have the job run as a thread in the *same* process as "job-B"
diff --git a/examples/libblkio-virtio-blk-vfio-pci.fio b/examples/libblkio-virtio-blk-vfio-pci.fio
index ba89f7ef..f78e5714 100644
--- a/examples/libblkio-virtio-blk-vfio-pci.fio
+++ b/examples/libblkio-virtio-blk-vfio-pci.fio
@@ -3,6 +3,10 @@
 ; Replace "libblkio_path" below with the path to your device's sysfs directory,
 ; or override it by passing the '--libblkio_path=...' flag to fio.
 ;
+; In the example below, the two subjobs of "job-B" *and* the single subjob of
+; "job-C" will share a single `struct blkio` instance, and "job-A" will use a
+; separate `struct blkio` instance.
+;
 ; For information on libblkio, see: https://gitlab.com/libblkio/libblkio
 
 [global]
@@ -14,4 +18,11 @@ blocksize=4k
 time_based=1
 runtime=10s
 
-[job]
+[job-A]
+
+[job-B]
+numjobs=2  ; run two copies of this job simultaneously
+thread=1   ; have each copy run as a separate thread in the *same* process
+
+[job-C]
+thread=1  ; have the job run as a thread in the *same* process as "job-B"
diff --git a/fio.1 b/fio.1
index f20a4164..cc743174 100644
--- a/fio.1
+++ b/fio.1
@@ -1994,7 +1994,12 @@ engine specific options. (See \fIhttps://xnvme.io/\fR).
 Use the libblkio library (\fIhttps://gitlab.com/libblkio/libblkio\fR). The
 specific \fBdriver\fR to use must be set using \fBlibblkio_driver\fR. If
 \fBmem\fR/\fBiomem\fR is not specified, memory allocation is delegated to
-libblkio (and so is guaranteed to work with the selected \fBdriver\fR).
+libblkio (and so is guaranteed to work with the selected \fBdriver\fR). One
+\fBstruct blkio\fR instance is used per process, so all jobs setting option
+\fBthread\fR will share a single \fBstruct blkio\fR (with one queue per thread)
+and must specify compatible options. Note that some drivers don't allow several
+processes to access the same device or file simultaneously, but allow it for
+threads.
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
-- 
2.38.1

