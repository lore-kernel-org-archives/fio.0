Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFCA6C433FE
	for <fio@archiver.kernel.org>; Mon, 21 Nov 2022 18:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiKUSaJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 21 Nov 2022 13:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKUSaI (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Nov 2022 13:30:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FADBD0DF8
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 10:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669055348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VZJLSjFfA7X9limblNknJlN0zDUHdt1908CBlgYYh8A=;
        b=YSwqLf8wZhZGEHPGKbMIi8Df7yvW7NdiG4Oi53Eejvnf2ikwsNmRqteIbQkWkxh9evrB95
        1pi3qV2lLVJJEqc1ScJhhlZtGYhbFlN3+qUOpB+torC4eCfFWZPA1iBR5i1ypfmTZ4ZOHo
        XEBWyLIhbYOKDUor6pr3FTo+Q/Sm8iM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-lELXxv7LO-6vr63RAer7Ew-1; Mon, 21 Nov 2022 13:29:06 -0500
X-MC-Unique: lELXxv7LO-6vr63RAer7Ew-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D6FA858F13
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 18:29:06 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.39.192.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3169E492B06;
        Mon, 21 Nov 2022 18:29:05 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     fio@vger.kernel.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [PATCH 01/10] Add a libblkio engine
Date:   Mon, 21 Nov 2022 18:28:53 +0000
Message-Id: <20221121182902.373491-2-afaria@redhat.com>
In-Reply-To: <20221121182902.373491-1-afaria@redhat.com>
References: <20221121182902.373491-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The libblkio library provides a unified API for efficiently accessing
block devices using modern high-performance block I/O interfaces like
io_uring and vhost-user-blk. Using libblkio reduces the amount of code
needed for interfacing with storage devices and allows developers to
focus on their applcations.

Add a libblkio engine that uses libblkio to perform I/O. This is useful
to benchmark the library itself, and also adds support for storage
interfaces and devices otherwise not supported by fio, such as
virtio-blk PCI, vhost-user, and vhost-vDPA devices.

See the libblkio documentation [2] or KVM Forum 2022 [3] presentation
for more information on the library itself.

[1] https://gitlab.com/libblkio/libblkio
[2] https://libblkio.gitlab.io/libblkio/index.html
[3] https://static.sched.com/hosted_files/kvmforum2022/8c/libblkio-kvm-forum-2022.pdf

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 HOWTO.rst                                 |  26 ++
 Makefile                                  |   6 +
 configure                                 |  25 ++
 engines/libblkio.c                        | 463 ++++++++++++++++++++++
 examples/libblkio-io_uring.fio            |  19 +
 examples/libblkio-virtio-blk-vfio-pci.fio |  18 +
 fio.1                                     |  19 +
 optgroup.h                                |   2 +
 8 files changed, 578 insertions(+)
 create mode 100644 engines/libblkio.c
 create mode 100644 examples/libblkio-io_uring.fio
 create mode 100644 examples/libblkio-virtio-blk-vfio-pci.fio

diff --git a/HOWTO.rst b/HOWTO.rst
index e796f961..d5a2749c 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2192,6 +2192,12 @@ I/O engine
 			the SPDK NVMe driver, or your own custom NVMe driver. The xnvme engine includes
 			engine specific options. (See https://xnvme.io).
 
+		**libblkio**
+			Use the libblkio library
+			(https://gitlab.com/libblkio/libblkio). The specific
+			*driver* to use must be set using
+			:option:`libblkio_driver`.
+
 I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -2842,6 +2848,26 @@ with the caveat that when used on the command line, they must come after the
 
 	If this option is set. xnvme will use vectored read/write commands.
 
+.. option:: libblkio_driver=str : [libblkio]
+
+	The driver to be used by libblkio (e.g. **virtio-blk-vfio-pci**).
+
+.. option:: libblkio_pre_connect_props=str : [libblkio]
+
+	A colon-separated list of libblkio properties to be set after creating
+	but before connecting the ``struct blkio``. Each property must have the
+	format ``<name>=<value>``. Colons can be escaped as ``\:``. These are
+	set after the engine sets any other properties, so those can be
+	overriden.
+
+.. option:: libblkio_pre_start_props=str : [libblkio]
+
+	A colon-separated list of libblkio properties to be set after connecting
+	but before starting the ``struct blkio``. Each property must have the
+	format ``<name>=<value>``. Colons can be escaped as ``\:``. These are
+	set after the engine sets any other properties, so those can be
+	overriden.
+
 I/O depth
 ~~~~~~~~~
 
diff --git a/Makefile b/Makefile
index 7bd572d7..9fd8f59b 100644
--- a/Makefile
+++ b/Makefile
@@ -237,6 +237,12 @@ ifdef CONFIG_LIBXNVME
   xnvme_CFLAGS = $(LIBXNVME_CFLAGS)
   ENGINES += xnvme
 endif
+ifdef CONFIG_LIBBLKIO
+  libblkio_SRCS = engines/libblkio.c
+  libblkio_LIBS = $(LIBBLKIO_LIBS)
+  libblkio_CFLAGS = $(LIBBLKIO_CFLAGS)
+  ENGINES += libblkio
+endif
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
 		oslib/linux-dev-lookup.c engines/io_uring.c engines/nvme.c
diff --git a/configure b/configure
index 1b12d268..6d8e3a87 100755
--- a/configure
+++ b/configure
@@ -176,6 +176,7 @@ libiscsi="no"
 libnbd="no"
 libnfs=""
 xnvme=""
+libblkio=""
 libzbc=""
 dfs=""
 seed_buckets=""
@@ -248,6 +249,8 @@ for opt do
   ;;
   --disable-xnvme) xnvme="no"
   ;;
+  --disable-libblkio) libblkio="no"
+  ;;
   --disable-tcmalloc) disable_tcmalloc="yes"
   ;;
   --disable-libnfs) libnfs="no"
@@ -304,6 +307,7 @@ if test "$show_help" = "yes" ; then
   echo "--enable-libiscsi       Enable iscsi support"
   echo "--enable-libnbd         Enable libnbd (NBD engine) support"
   echo "--disable-xnvme         Disable xnvme support even if found"
+  echo "--disable-libblkio      Disable libblkio support even if found"
   echo "--disable-libzbc        Disable libzbc even if found"
   echo "--disable-tcmalloc      Disable tcmalloc support"
   echo "--dynamic-libengines    Lib-based ioengines as dynamic libraries"
@@ -2663,6 +2667,22 @@ if test "$xnvme" != "no" ; then
 fi
 print_config "xnvme engine" "$xnvme"
 
+##########################################
+# Check if we have libblkio
+if test "$libblkio" != "no" ; then
+  if check_min_lib_version blkio 1.0.0; then
+    libblkio="yes"
+    libblkio_cflags=$(pkg-config --cflags blkio)
+    libblkio_libs=$(pkg-config --libs blkio)
+  else
+    if test "$libblkio" = "yes" ; then
+      feature_not_found "libblkio" "libblkio-dev or libblkio-devel"
+    fi
+    libblkio="no"
+  fi
+fi
+print_config "libblkio engine" "$libblkio"
+
 ##########################################
 # check march=armv8-a+crc+crypto
 if test "$march_armv8_a_crc_crypto" != "yes" ; then
@@ -3276,6 +3296,11 @@ if test "$xnvme" = "yes" ; then
   echo "LIBXNVME_CFLAGS=$xnvme_cflags" >> $config_host_mak
   echo "LIBXNVME_LIBS=$xnvme_libs" >> $config_host_mak
 fi
+if test "$libblkio" = "yes" ; then
+  output_sym "CONFIG_LIBBLKIO"
+  echo "LIBBLKIO_CFLAGS=$libblkio_cflags" >> $config_host_mak
+  echo "LIBBLKIO_LIBS=$libblkio_libs" >> $config_host_mak
+fi
 if test "$dynamic_engines" = "yes" ; then
   output_sym "CONFIG_DYNAMIC_ENGINES"
 fi
diff --git a/engines/libblkio.c b/engines/libblkio.c
new file mode 100644
index 00000000..bd9a5c84
--- /dev/null
+++ b/engines/libblkio.c
@@ -0,0 +1,463 @@
+/*
+ * libblkio engine
+ *
+ * IO engine using libblkio to access various block I/O interfaces:
+ * https://gitlab.com/libblkio/libblkio
+ */
+
+#include <assert.h>
+#include <errno.h>
+#include <stdbool.h>
+#include <stddef.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <blkio.h>
+
+#include "../fio.h"
+#include "../optgroup.h"
+#include "../options.h"
+#include "../parse.h"
+
+struct fio_blkio_options {
+	void *pad; /* option fields must not have offset 0 */
+
+	char *driver;
+	char *pre_connect_props;
+	char *pre_start_props;
+};
+
+static struct fio_option options[] = {
+	{
+		.name	= "libblkio_driver",
+		.lname	= "libblkio driver name",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct fio_blkio_options, driver),
+		.help	= "Name of the driver to be used by libblkio",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
+	{
+		.name	= "libblkio_pre_connect_props",
+		.lname	= "Properties to be set before blkio_connect()",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct fio_blkio_options, pre_connect_props),
+		.help	= "",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
+	{
+		.name	= "libblkio_pre_start_props",
+		.lname	= "Properties to be set before blkio_start()",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct fio_blkio_options, pre_start_props),
+		.help	= "",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
+
+	{
+		.name = NULL,
+	},
+};
+
+static int fio_blkio_set_props_from_str(struct blkio *b, const char *opt_name,
+					const char *str) {
+	int ret = 0;
+	char *new_str, *name, *value;
+
+	if (!str)
+		return 0;
+
+	/* copy string */
+
+	new_str = strdup(str);
+
+	if (!new_str) {
+		log_err("fio: strdup() failed\n");
+		return 1;
+	}
+
+	/* iterate over property name-value pairs */
+
+	while ((name = get_next_str(&new_str))) {
+		/* split into property name and value */
+
+		value = strchr(name, '=');
+
+		if (!value) {
+			log_err("fio: missing '=' in option %s\n", opt_name);
+			ret = 1;
+			break;
+		}
+
+		*value = '\0';
+		++value;
+
+		/* strip whitespace from property name and value */
+
+		strip_blank_front(&name);
+		strip_blank_end(name);
+
+		if (name[0] == '\0') {
+			log_err("fio: empty property name in option %s\n",
+				opt_name);
+			ret = 1;
+			break;
+		}
+
+		strip_blank_front(&value);
+		strip_blank_end(value);
+
+		/* set property */
+
+		if (blkio_set_str(b, name, value) != 0) {
+			log_err("fio: error setting property '%s' to '%s': %s\n",
+				name, value, blkio_get_error_msg());
+			ret = 1;
+			break;
+		}
+	}
+
+	free(new_str);
+	return ret;
+}
+
+/*
+ * Log the failure of a libblkio function.
+ *
+ * `(void)func` is to ensure `func` exists and prevent typos
+ */
+#define fio_blkio_log_err(func) \
+	({ \
+		(void)func; \
+		log_err("fio: %s() failed: %s\n", #func, \
+			blkio_get_error_msg()); \
+	})
+
+static int fio_blkio_create_and_connect(struct thread_data *td,
+					struct blkio **out_blkio)
+{
+	const struct fio_blkio_options *options = td->eo;
+	struct blkio *b;
+	int ret;
+
+	/* create blkio */
+
+	if (!options->driver) {
+		log_err("fio: engine libblkio requires option libblkio_driver to be set\n");
+		return 1;
+	}
+
+	if (blkio_create(options->driver, &b) != 0) {
+		fio_blkio_log_err(blkio_create);
+		return 1;
+	}
+
+	/* set pre-connect properties */
+
+	/* don't fail if driver doesn't have a "direct" property */
+	ret = blkio_set_bool(b, "direct", td->o.odirect);
+	if (ret != 0 && ret != -ENOENT) {
+		fio_blkio_log_err(blkio_set_bool);
+		goto err_blkio_destroy;
+	}
+
+	if (blkio_set_bool(b, "read-only", read_only) != 0) {
+		fio_blkio_log_err(blkio_set_bool);
+		goto err_blkio_destroy;
+	}
+
+	if (fio_blkio_set_props_from_str(b, "libblkio_pre_connect_props",
+					 options->pre_connect_props) != 0)
+		goto err_blkio_destroy;
+
+	/* connect blkio */
+
+	if (blkio_connect(b) != 0) {
+		fio_blkio_log_err(blkio_connect);
+		goto err_blkio_destroy;
+	}
+
+	/* set pre-start properties */
+
+	if (fio_blkio_set_props_from_str(b, "libblkio_pre_start_props",
+					 options->pre_start_props) != 0)
+		goto err_blkio_destroy;
+
+	*out_blkio = b;
+	return 0;
+
+err_blkio_destroy:
+	blkio_destroy(&b);
+	return 1;
+}
+
+static int fio_blkio_setup(struct thread_data *td)
+{
+	/*
+	 * We have to determine device/file size here, so we create and connect
+	 * a blkio instance. But this callback is called from the main thread in
+	 * the original fio process, not from the processes in which jobs will
+	 * actually run. We thus subsequently destroy the blkio and create it
+	 * again in the init() callback.
+	 */
+
+	struct blkio *b;
+	int ret = 0;
+	uint64_t capacity;
+
+	assert(td->files_index == 1);
+
+	/* get target size */
+
+	if (fio_blkio_create_and_connect(td, &b) != 0)
+		return 1;
+
+	if (blkio_get_uint64(b, "capacity", &capacity) != 0) {
+		fio_blkio_log_err(blkio_get_uint64);
+		ret = 1;
+		goto out_blkio_destroy;
+	}
+
+	/* set file size for fio */
+
+	td->files[0]->real_file_size = capacity;
+	fio_file_set_size_known(td->files[0]);
+
+out_blkio_destroy:
+	blkio_destroy(&b);
+	return ret;
+}
+
+/* per-thread state */
+struct fio_blkio_data {
+	struct blkio *b;
+	struct blkioq *q;
+
+	bool has_mem_region; /* whether mem_region is valid */
+	struct blkio_mem_region mem_region;
+
+	struct blkio_completion *completions;
+};
+
+static int fio_blkio_init(struct thread_data *td)
+{
+	struct fio_blkio_data *data;
+
+	/* allocate per-thread data struct */
+
+	data = calloc(1, sizeof(*data));
+	if (!data) {
+		log_err("fio: calloc() failed\n");
+		goto err_free;
+	}
+
+	data->completions = calloc(td->o.iodepth, sizeof(data->completions[0]));
+	if (!data->completions) {
+		log_err("fio: calloc() failed\n");
+		goto err_free;
+	}
+
+	/* create, connect, and start blkio */
+
+	if (fio_blkio_create_and_connect(td, &data->b) != 0)
+		goto err_free;
+
+	if (blkio_set_int(data->b, "num-queues", 1) != 0) {
+		fio_blkio_log_err(blkio_set_int);
+		goto err_blkio_destroy;
+	}
+
+	if (blkio_start(data->b) != 0) {
+		fio_blkio_log_err(blkio_start);
+		goto err_blkio_destroy;
+	}
+
+	/* get queue */
+
+	data->q = blkio_get_queue(data->b, 0);
+
+	/* Set data only here so cleanup() does nothing if init() fails. */
+	td->io_ops_data = data;
+
+	return 0;
+
+err_blkio_destroy:
+	blkio_destroy(&data->b);
+err_free:
+	free(data->completions);
+	free(data);
+	return 1;
+}
+
+static void fio_blkio_cleanup(struct thread_data *td)
+{
+	struct fio_blkio_data *data = td->io_ops_data;
+
+	if (data) {
+		blkio_destroy(&data->b);
+		free(data->completions);
+		free(data);
+	}
+}
+
+#define align_up(x, y) ((((x) + (y) - 1) / (y)) * (y))
+
+static int fio_blkio_iomem_alloc(struct thread_data *td, size_t size)
+{
+	struct fio_blkio_data *data = td->io_ops_data;
+	int ret;
+	uint64_t mem_region_alignment;
+	size_t aligned_size;
+
+	/* round up size to satisfy mem-region-alignment */
+
+	if (blkio_get_uint64(data->b, "mem-region-alignment",
+			     &mem_region_alignment) != 0) {
+		fio_blkio_log_err(blkio_get_uint64);
+		return 1;
+	}
+
+	aligned_size = align_up(size, (size_t)mem_region_alignment);
+
+	/* allocate memory region */
+
+	if (blkio_alloc_mem_region(data->b, &data->mem_region,
+				   aligned_size) != 0) {
+		fio_blkio_log_err(blkio_alloc_mem_region);
+		ret = 1;
+		goto out;
+	}
+
+	if (blkio_map_mem_region(data->b, &data->mem_region) != 0) {
+		fio_blkio_log_err(blkio_map_mem_region);
+		ret = 1;
+		goto out_free;
+	}
+
+	td->orig_buffer = data->mem_region.addr;
+	data->has_mem_region = true;
+
+	ret = 0;
+	goto out;
+
+out_free:
+	blkio_free_mem_region(data->b, &data->mem_region);
+out:
+	return ret;
+}
+
+static void fio_blkio_iomem_free(struct thread_data *td)
+{
+	struct fio_blkio_data *data = td->io_ops_data;
+
+	if (data && data->has_mem_region) {
+		blkio_unmap_mem_region(data->b, &data->mem_region);
+		blkio_free_mem_region(data->b, &data->mem_region);
+
+		data->has_mem_region = false;
+	}
+}
+
+static int fio_blkio_open_file(struct thread_data *td, struct fio_file *f)
+{
+	return 0;
+}
+
+static enum fio_q_status fio_blkio_queue(struct thread_data *td,
+					 struct io_u *io_u)
+{
+	struct fio_blkio_data *data = td->io_ops_data;
+
+	fio_ro_check(td, io_u);
+
+	switch (io_u->ddir) {
+		case DDIR_READ:
+			blkioq_read(data->q, io_u->offset, io_u->xfer_buf,
+				    (size_t)io_u->xfer_buflen, io_u, 0);
+			break;
+
+		case DDIR_WRITE:
+			blkioq_write(data->q, io_u->offset, io_u->xfer_buf,
+				     (size_t)io_u->xfer_buflen, io_u, 0);
+			break;
+
+		case DDIR_TRIM:
+			blkioq_discard(data->q, io_u->offset, io_u->xfer_buflen,
+				       io_u, 0);
+		        break;
+
+		case DDIR_SYNC:
+		case DDIR_DATASYNC:
+			blkioq_flush(data->q, io_u, 0);
+			break;
+
+		default:
+			io_u->error = ENOTSUP;
+			io_u_log_error(td, io_u);
+			return FIO_Q_COMPLETED;
+	}
+
+	return FIO_Q_QUEUED;
+}
+
+static int fio_blkio_getevents(struct thread_data *td, unsigned int min,
+			       unsigned int max, const struct timespec *t)
+{
+	struct fio_blkio_data *data = td->io_ops_data;
+	int n;
+
+	n = blkioq_do_io(data->q, data->completions, (int)min, (int)max, NULL);
+	if (n < 0) {
+		fio_blkio_log_err(blkioq_do_io);
+		return -1;
+	}
+
+	return n;
+}
+
+static struct io_u *fio_blkio_event(struct thread_data *td, int event)
+{
+	struct fio_blkio_data *data = td->io_ops_data;
+	struct blkio_completion *completion = &data->completions[event];
+	struct io_u *io_u = completion->user_data;
+
+	io_u->error = -completion->ret;
+
+	return io_u;
+}
+
+FIO_STATIC struct ioengine_ops ioengine = {
+	.name			= "libblkio",
+	.version		= FIO_IOOPS_VERSION,
+	.flags			= FIO_DISKLESSIO | FIO_NOEXTEND |
+				  FIO_NO_OFFLOAD,
+
+	.setup			= fio_blkio_setup,
+	.init			= fio_blkio_init,
+	.cleanup		= fio_blkio_cleanup,
+
+	.iomem_alloc		= fio_blkio_iomem_alloc,
+	.iomem_free		= fio_blkio_iomem_free,
+
+	.open_file		= fio_blkio_open_file,
+
+	.queue			= fio_blkio_queue,
+	.getevents		= fio_blkio_getevents,
+	.event			= fio_blkio_event,
+
+	.options		= options,
+	.option_struct_size	= sizeof(struct fio_blkio_options),
+};
+
+static void fio_init fio_blkio_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_blkio_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/examples/libblkio-io_uring.fio b/examples/libblkio-io_uring.fio
new file mode 100644
index 00000000..d2700e51
--- /dev/null
+++ b/examples/libblkio-io_uring.fio
@@ -0,0 +1,19 @@
+; Benchmark accessing a regular file or block device using libblkio.
+;
+; Replace "libblkio_path" below with the path to your file or device, or
+; override it by passing the '--libblkio_pre_connect_props=path=...' flag to
+; fio.
+;
+; For information on libblkio, see: https://gitlab.com/libblkio/libblkio
+
+[global]
+ioengine=libblkio
+libblkio_driver=io_uring
+libblkio_pre_connect_props=path=/dev/nvme0n1  ; REPLACE THIS WITH THE RIGHT PATH
+rw=randread
+blocksize=4k
+direct=1
+time_based=1
+runtime=10s
+
+[job]
diff --git a/examples/libblkio-virtio-blk-vfio-pci.fio b/examples/libblkio-virtio-blk-vfio-pci.fio
new file mode 100644
index 00000000..79d6228d
--- /dev/null
+++ b/examples/libblkio-virtio-blk-vfio-pci.fio
@@ -0,0 +1,18 @@
+; Benchmark accessing a PCI virtio-blk device using libblkio.
+;
+; Replace "libblkio_path" below with the path to your device's sysfs directory,
+; or override it by passing the '--libblkio_pre_connect_props=path=...' flag to
+; fio. Note that colons in the path must be escaped with a backslash.
+;
+; For information on libblkio, see: https://gitlab.com/libblkio/libblkio
+
+[global]
+ioengine=libblkio
+libblkio_driver=virtio-blk-vfio-pci
+libblkio_pre_connect_props=path=/sys/bus/pci/devices/0000\:00\:01.0  ; REPLACE THIS WITH THE RIGHT PATH
+rw=randread
+blocksize=4k
+time_based=1
+runtime=10s
+
+[job]
diff --git a/fio.1 b/fio.1
index 9e33c9e1..64a774f5 100644
--- a/fio.1
+++ b/fio.1
@@ -1989,6 +1989,10 @@ I/O engine using the xNVMe C API, for NVMe devices. The xnvme engine provides
 flexibility to access GNU/Linux Kernel NVMe driver via libaio, IOCTLs, io_uring,
 the SPDK NVMe driver, or your own custom NVMe driver. The xnvme engine includes
 engine specific options. (See \fIhttps://xnvme.io/\fR).
+.TP
+.B libblkio
+Use the libblkio library (\fIhttps://gitlab.com/libblkio/libblkio\fR). The
+specific \fBdriver\fR to use must be set using \fBlibblkio_driver\fR.
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
@@ -2599,6 +2603,21 @@ xnvme namespace identifier for userspace NVMe driver such as SPDK.
 .TP
 .BI (xnvme)xnvme_iovec
 If this option is set, xnvme will use vectored read/write commands.
+.TP
+.BI (libblkio)libblkio_driver \fR=\fPstr
+The driver to be used by libblkio (e.g. \fBvirtio-blk-vfio-pci\fR).
+.TP
+.BI (libblkio)libblkio_pre_connect_props \fR=\fPstr
+A colon-separated list of libblkio properties to be set after creating but
+before connecting the \fBstruct blkio\fR. Each property must have the format
+\fB<name>=<value>\fR. Colons can be escaped as \fB\\:\fR. These are set after
+the engine sets any other properties, so those can be overriden.
+.TP
+.BI (libblkio)libblkio_pre_start_props \fR=\fPstr
+A colon-separated list of libblkio properties to be set after connecting but
+before starting the \fBstruct blkio\fR. Each property must have the format
+\fB<name>=<value>\fR. Colons can be escaped as \fB\\:\fR. These are set after
+the engine sets any other properties, so those can be overriden.
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
diff --git a/optgroup.h b/optgroup.h
index dc73c8f3..024b902f 100644
--- a/optgroup.h
+++ b/optgroup.h
@@ -73,6 +73,7 @@ enum opt_category_group {
 	__FIO_OPT_G_NFS,
 	__FIO_OPT_G_WINDOWSAIO,
 	__FIO_OPT_G_XNVME,
+	__FIO_OPT_G_LIBBLKIO,
 
 	FIO_OPT_G_RATE		= (1ULL << __FIO_OPT_G_RATE),
 	FIO_OPT_G_ZONE		= (1ULL << __FIO_OPT_G_ZONE),
@@ -120,6 +121,7 @@ enum opt_category_group {
 	FIO_OPT_G_DFS		= (1ULL << __FIO_OPT_G_DFS),
 	FIO_OPT_G_WINDOWSAIO	= (1ULL << __FIO_OPT_G_WINDOWSAIO),
 	FIO_OPT_G_XNVME         = (1ULL << __FIO_OPT_G_XNVME),
+	FIO_OPT_G_LIBBLKIO	= (1ULL << __FIO_OPT_G_LIBBLKIO),
 };
 
 extern const struct opt_group *opt_group_from_mask(uint64_t *mask);
-- 
2.38.1

