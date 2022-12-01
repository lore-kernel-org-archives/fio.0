Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A6BFC4321E
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 22:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiLAWJi (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 17:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiLAWJe (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 17:09:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF2B4C266
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 14:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669932508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iR6SeAEb0Ob0EdhJKFw3eO69FH0ezFB9YrQh8kKRMI0=;
        b=BuB/7BjwN440qj4xYuWSt8DmBAwvsBzG74Yl0gMa9u3hsTYYim8AniZD3Aa2+oAo/Ht39i
        w0bT7swLCqRuP29heErS8ogFk5Kfas/Um6FvEUssg7muj0bfB4C4U8pY1EEG65SBsxz4iC
        9n+gxUtUsubFmhj0Iqwqo9b+T1kKBlw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-tGA9djQ9MAC951Fdn9VipA-1; Thu, 01 Dec 2022 17:08:24 -0500
X-MC-Unique: tGA9djQ9MAC951Fdn9VipA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D01B3C025AD;
        Thu,  1 Dec 2022 22:08:24 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.192.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1365D477F55;
        Thu,  1 Dec 2022 22:08:22 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     fio@vger.kernel.org
Cc:     Vincent Fu <vincentfu@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [PATCH v2 10/10] engines/libblkio: Share a single blkio instance among threads in same process
Date:   Thu,  1 Dec 2022 22:08:03 +0000
Message-Id: <20221201220803.52057-11-afaria@redhat.com>
In-Reply-To: <20221201220803.52057-1-afaria@redhat.com>
References: <20221201220803.52057-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
 engines/libblkio.c                        | 242 +++++++++++++++++++---
 examples/libblkio-io_uring.fio            |  13 +-
 examples/libblkio-virtio-blk-vfio-pci.fio |  13 +-
 fio.1                                     |   6 +-
 5 files changed, 250 insertions(+), 32 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 10e6bc79..5a5263c3 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2202,7 +2202,13 @@ I/O engine
 			:option:`libblkio_driver`. If
 			:option:`mem`/:option:`iomem` is not specified, memory
 			allocation is delegated to libblkio (and so is
-			guaranteed to work with the selected *driver*).
+			guaranteed to work with the selected *driver*). One
+			libblkio instance is used per process, so all jobs
+			setting option :option:`thread` will share a single
+			instance (with one queue per thread) and must specify
+			compatible options. Note that some drivers don't allow
+			several instances to access the same device or file
+			simultaneously, but allow it for threads.
 
 I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/engines/libblkio.c b/engines/libblkio.c
index fc4e3f8a..054aa800 100644
--- a/engines/libblkio.c
+++ b/engines/libblkio.c
@@ -20,9 +20,28 @@
 #include "../options.h"
 #include "../parse.h"
 
+/* per-process state */
+static struct {
+	pthread_mutex_t mutex;
+	int initted_threads;
+	int initted_hipri_threads;
+	struct blkio *b;
+} proc_state = { PTHREAD_MUTEX_INITIALIZER, 0, 0, NULL };
+
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
 /* per-thread state */
 struct fio_blkio_data {
-	struct blkio *b;
 	struct blkioq *q;
 	int completion_fd; /* may be -1 if not FIO_BLKIO_WAIT_MODE_EVENTFD */
 
@@ -252,6 +271,106 @@ static int fio_blkio_set_props_from_str(struct blkio *b, const char *opt_name,
 			blkio_get_error_msg()); \
 	})
 
+static bool possibly_null_strs_equal(const char *a, const char *b)
+{
+	return (!a && !b) || (a && b && strcmp(a, b) == 0);
+}
+
+/*
+ * Returns the total number of subjobs using the 'libblkio' ioengine and setting
+ * the 'thread' option in the entire workload that have the given value for the
+ * 'hipri' option.
+ */
+static int total_threaded_subjobs(bool hipri)
+{
+	struct thread_data *td;
+	unsigned int i;
+	int count = 0;
+
+	for_each_td(td, i) {
+		const struct fio_blkio_options *options = td->eo;
+		if (strcmp(td->o.ioengine, "libblkio") == 0 &&
+		    td->o.use_thread && (bool)options->hipri == hipri)
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
@@ -324,6 +443,8 @@ err_blkio_destroy:
 	return 1;
 }
 
+static bool incompatible_threaded_subjob_options = false;
+
 /*
  * This callback determines the device/file size, so it creates and connects a
  * blkio instance. But it is invoked from the main thread in the original fio
@@ -339,6 +460,11 @@ static int fio_blkio_setup(struct thread_data *td)
 
 	assert(td->files_index == 1);
 
+	if (fio_blkio_check_opt_compat(td) != 0) {
+		incompatible_threaded_subjob_options = true;
+		return 1;
+	}
+
 	if (options->hipri &&
 		options->wait_mode == FIO_BLKIO_WAIT_MODE_EVENTFD) {
 		log_err("fio: option hipri is incompatible with option libblkio_wait_mode=eventfd\n");
@@ -373,6 +499,15 @@ static int fio_blkio_init(struct thread_data *td)
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
 	/*
 	 * Request enqueueing is fast, and it's not possible to know exactly
 	 * when a request is submitted, so never report submission latencies.
@@ -392,29 +527,49 @@ static int fio_blkio_init(struct thread_data *td)
 		goto err_free;
 	}
 
-	if (fio_blkio_create_and_connect(td, &data->b) != 0)
-		goto err_free;
+	fio_blkio_proc_lock();
 
-	if (blkio_set_int(data->b, "num-queues", options->hipri ? 0 : 1) != 0) {
-		fio_blkio_log_err(blkio_set_int);
-		goto err_blkio_destroy;
-	}
+	if (proc_state.initted_threads == 0) {
+		/* initialize per-process blkio */
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
 
 	if (options->wait_mode == FIO_BLKIO_WAIT_MODE_EVENTFD ||
 		options->force_enable_completion_eventfd) {
@@ -439,13 +594,24 @@ static int fio_blkio_init(struct thread_data *td)
 		data->completion_fd = -1;
 	}
 
+	++proc_state.initted_threads;
+	if (options->hipri)
+		++proc_state.initted_hipri_threads;
+
 	/* Set data last so cleanup() does nothing if init() fails. */
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
@@ -485,7 +651,7 @@ static int fio_blkio_post_init(struct thread_data *td)
 			.fd	= -1,
 		};
 
-		if (blkio_map_mem_region(data->b, &region) != 0) {
+		if (blkio_map_mem_region(proc_state.b, &region) != 0) {
 			fio_blkio_log_err(blkio_map_mem_region);
 			return 1;
 		}
@@ -498,11 +664,25 @@ static void fio_blkio_cleanup(struct thread_data *td)
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
+		if (--proc_state.initted_threads == 0) {
+			blkio_destroy(&proc_state.b);
+			proc_state.b = NULL;
+		}
+		fio_blkio_proc_unlock();
 	}
 }
 
@@ -514,7 +694,7 @@ static int fio_blkio_iomem_alloc(struct thread_data *td, size_t size)
 	int ret;
 	uint64_t mem_region_alignment;
 
-	if (blkio_get_uint64(data->b, "mem-region-alignment",
+	if (blkio_get_uint64(proc_state.b, "mem-region-alignment",
 			     &mem_region_alignment) != 0) {
 		fio_blkio_log_err(blkio_get_uint64);
 		return 1;
@@ -523,13 +703,16 @@ static int fio_blkio_iomem_alloc(struct thread_data *td, size_t size)
 	/* round up size to satisfy mem-region-alignment */
 	size = align_up(size, (size_t)mem_region_alignment);
 
-	if (blkio_alloc_mem_region(data->b, &data->mem_region, size) != 0) {
+	fio_blkio_proc_lock();
+
+	if (blkio_alloc_mem_region(proc_state.b, &data->mem_region,
+				   size) != 0) {
 		fio_blkio_log_err(blkio_alloc_mem_region);
 		ret = 1;
 		goto out;
 	}
 
-	if (blkio_map_mem_region(data->b, &data->mem_region) != 0) {
+	if (blkio_map_mem_region(proc_state.b, &data->mem_region) != 0) {
 		fio_blkio_log_err(blkio_map_mem_region);
 		ret = 1;
 		goto out_free;
@@ -542,8 +725,9 @@ static int fio_blkio_iomem_alloc(struct thread_data *td, size_t size)
 	goto out;
 
 out_free:
-	blkio_free_mem_region(data->b, &data->mem_region);
+	blkio_free_mem_region(proc_state.b, &data->mem_region);
 out:
+	fio_blkio_proc_unlock();
 	return ret;
 }
 
@@ -552,8 +736,10 @@ static void fio_blkio_iomem_free(struct thread_data *td)
 	struct fio_blkio_data *data = td->io_ops_data;
 
 	if (data && data->has_mem_region) {
-		blkio_unmap_mem_region(data->b, &data->mem_region);
-		blkio_free_mem_region(data->b, &data->mem_region);
+		fio_blkio_proc_lock();
+		blkio_unmap_mem_region(proc_state.b, &data->mem_region);
+		blkio_free_mem_region(proc_state.b, &data->mem_region);
+		fio_blkio_proc_unlock();
 
 		data->has_mem_region = false;
 	}
diff --git a/examples/libblkio-io_uring.fio b/examples/libblkio-io_uring.fio
index 3485b97e..40f625cf 100644
--- a/examples/libblkio-io_uring.fio
+++ b/examples/libblkio-io_uring.fio
@@ -3,6 +3,10 @@
 ; Replace "/dev/nvme0n1" below with the path to your file or device, or override
 ; it by passing the '--libblkio_path=...' flag to fio.
 ;
+; In the example below, the two subjobs of "job-B" *and* the single subjob of
+; "job-C" will share a single libblkio instance, and "job-A" will use a separate
+; libblkio instance.
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
index 6bed664b..024224a6 100644
--- a/examples/libblkio-virtio-blk-vfio-pci.fio
+++ b/examples/libblkio-virtio-blk-vfio-pci.fio
@@ -4,6 +4,10 @@
 ; device's sysfs directory, or override it by passing the '--libblkio_path=...'
 ; flag to fio.
 ;
+; In the example below, the two subjobs of "job-B" *and* the single subjob of
+; "job-C" will share a single libblkio instance, and "job-A" will use a separate
+; libblkio instance.
+;
 ; For information on libblkio, see: https://gitlab.com/libblkio/libblkio
 
 [global]
@@ -15,4 +19,11 @@ blocksize=4k
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
index 6f7a608d..7a153731 100644
--- a/fio.1
+++ b/fio.1
@@ -1997,7 +1997,11 @@ engine specific options. (See \fIhttps://xnvme.io/\fR).
 Use the libblkio library (\fIhttps://gitlab.com/libblkio/libblkio\fR). The
 specific driver to use must be set using \fBlibblkio_driver\fR. If
 \fBmem\fR/\fBiomem\fR is not specified, memory allocation is delegated to
-libblkio (and so is guaranteed to work with the selected driver).
+libblkio (and so is guaranteed to work with the selected driver). One libblkio
+instance is used per process, so all jobs setting option \fBthread\fR will share
+a single instance (with one queue per thread) and must specify compatible
+options. Note that some drivers don't allow several instances to access the same
+device or file simultaneously, but allow it for threads.
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
-- 
2.38.1

