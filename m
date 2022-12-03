Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1885C352A1
	for <fio@archiver.kernel.org>; Sat,  3 Dec 2022 13:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiLCNAO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 3 Dec 2022 08:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLCNAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 3 Dec 2022 08:00:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE4028710
        for <fio@vger.kernel.org>; Sat,  3 Dec 2022 05:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=yRUEiUYwTEKbquSazhQ6kSlVavwPa20QcBmMpfXKels=; b=ON0G2P5pvU2EKQmjVJs/XU7EMT
        Ohd+sa6yUWvkx4sj9YAs+7EfWjYkLc+RW9a9HWJW2FRLpgPI4ON0887bjWWo+uCh4hghs0On4eyVz
        G1xxkvNjptpbdPpwEyHZUiwfytMlKRrY0dSvXaeWjJCWxeVSq+wEtdOnuXy62Qbr2IIVgkDJqll48
        +eSpZIxlomfVJU9/bdvOFYPPsoH4vjJh4G9RJnZigcauZ6zBiddiFWr/BCMd5HmObHn9uvqSa2ZRf
        PndmYNWLmLDwvfTJQh5YBV05/WRvkzhrU5c9grBcmuA6NxhSQDXvmnOrmRJZgpeM6dHMFXQUyFqRD
        +SDSMohQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p1S7o-001Bjq-Vg
        for fio@vger.kernel.org; Sat, 03 Dec 2022 13:00:13 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 09BAC1BC0142; Sat,  3 Dec 2022 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221203130002.09BAC1BC0142@kernel.dk>
Date:   Sat,  3 Dec 2022 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 942d66c85ee8f007ea5f1097d097cf9a44b662a0:

  doc: update about size (2022-12-01 11:12:35 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3afc2d8ac30c58372a1b7ccabaea0f3eae4ddaba:

  engines/libblkio: Share a single blkio instance among threads in same process (2022-12-02 16:24:03 -0500)

----------------------------------------------------------------
Alberto Faria (10):
      Add a libblkio engine
      Add engine flag FIO_SKIPPABLE_IOMEM_ALLOC
      engines/libblkio: Allow setting option mem/iomem
      engines/libblkio: Add support for poll queues
      engines/libblkio: Add option libblkio_vectored
      engines/libblkio: Add option libblkio_write_zeroes_on_trim
      engines/libblkio: Add option libblkio_wait_mode
      engines/libblkio: Add option libblkio_force_enable_completion_eventfd
      engines/libblkio: Add options for some driver-specific properties
      engines/libblkio: Share a single blkio instance among threads in same process

 HOWTO.rst                                 |  95 ++++
 Makefile                                  |   6 +
 configure                                 |  25 +
 engines/libblkio.c                        | 914 ++++++++++++++++++++++++++++++
 examples/libblkio-io_uring.fio            |  29 +
 examples/libblkio-virtio-blk-vfio-pci.fio |  29 +
 fio.1                                     |  78 +++
 ioengines.h                               |   2 +
 memory.c                                  |  22 +-
 optgroup.h                                |   2 +
 10 files changed, 1192 insertions(+), 10 deletions(-)
 create mode 100644 engines/libblkio.c
 create mode 100644 examples/libblkio-io_uring.fio
 create mode 100644 examples/libblkio-virtio-blk-vfio-pci.fio

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 0aaf033a..5a5263c3 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2195,6 +2195,21 @@ I/O engine
 			the SPDK NVMe driver, or your own custom NVMe driver. The xnvme engine includes
 			engine specific options. (See https://xnvme.io).
 
+		**libblkio**
+			Use the libblkio library
+			(https://gitlab.com/libblkio/libblkio). The specific
+			*driver* to use must be set using
+			:option:`libblkio_driver`. If
+			:option:`mem`/:option:`iomem` is not specified, memory
+			allocation is delegated to libblkio (and so is
+			guaranteed to work with the selected *driver*). One
+			libblkio instance is used per process, so all jobs
+			setting option :option:`thread` will share a single
+			instance (with one queue per thread) and must specify
+			compatible options. Note that some drivers don't allow
+			several instances to access the same device or file
+			simultaneously, but allow it for threads.
+
 I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -2326,6 +2341,12 @@ with the caveat that when used on the command line, they must come after the
         by the application. The benefits are more efficient IO for high IOPS
         scenarios, and lower latencies for low queue depth IO.
 
+   [libblkio]
+
+	Use poll queues. This is incompatible with
+	:option:`libblkio_wait_mode=eventfd <libblkio_wait_mode>` and
+	:option:`libblkio_force_enable_completion_eventfd`.
+
    [pvsync2]
 
 	Set RWF_HIPRI on I/O, indicating to the kernel that it's of higher priority
@@ -2847,6 +2868,80 @@ with the caveat that when used on the command line, they must come after the
 
 	If this option is set. xnvme will use vectored read/write commands.
 
+.. option:: libblkio_driver=str : [libblkio]
+
+	The libblkio *driver* to use. Different drivers access devices through
+	different underlying interfaces. Available drivers depend on the
+	libblkio version in use and are listed at
+	https://libblkio.gitlab.io/libblkio/blkio.html#drivers
+
+.. option:: libblkio_path=str : [libblkio]
+
+	Sets the value of the driver-specific "path" property before connecting
+	the libblkio instance, which identifies the target device or file on
+	which to perform I/O. Its exact semantics are driver-dependent and not
+	all drivers may support it; see
+	https://libblkio.gitlab.io/libblkio/blkio.html#drivers
+
+.. option:: libblkio_pre_connect_props=str : [libblkio]
+
+	A colon-separated list of additional libblkio properties to be set after
+	creating but before connecting the libblkio instance. Each property must
+	have the format ``<name>=<value>``. Colons can be escaped as ``\:``.
+	These are set after the engine sets any other properties, so those can
+	be overriden. Available properties depend on the libblkio version in use
+	and are listed at
+	https://libblkio.gitlab.io/libblkio/blkio.html#properties
+
+.. option:: libblkio_num_entries=int : [libblkio]
+
+	Sets the value of the driver-specific "num-entries" property before
+	starting the libblkio instance. Its exact semantics are driver-dependent
+	and not all drivers may support it; see
+	https://libblkio.gitlab.io/libblkio/blkio.html#drivers
+
+.. option:: libblkio_queue_size=int : [libblkio]
+
+	Sets the value of the driver-specific "queue-size" property before
+	starting the libblkio instance. Its exact semantics are driver-dependent
+	and not all drivers may support it; see
+	https://libblkio.gitlab.io/libblkio/blkio.html#drivers
+
+.. option:: libblkio_pre_start_props=str : [libblkio]
+
+	A colon-separated list of additional libblkio properties to be set after
+	connecting but before starting the libblkio instance. Each property must
+	have the format ``<name>=<value>``. Colons can be escaped as ``\:``.
+	These are set after the engine sets any other properties, so those can
+	be overriden. Available properties depend on the libblkio version in use
+	and are listed at
+	https://libblkio.gitlab.io/libblkio/blkio.html#properties
+
+.. option:: libblkio_vectored : [libblkio]
+
+	Submit vectored read and write requests.
+
+.. option:: libblkio_write_zeroes_on_trim : [libblkio]
+
+	Submit trims as "write zeroes" requests instead of discard requests.
+
+.. option:: libblkio_wait_mode=str : [libblkio]
+
+	How to wait for completions:
+
+	**block** (default)
+		Use a blocking call to ``blkioq_do_io()``.
+	**eventfd**
+		Use a blocking call to ``read()`` on the completion eventfd.
+	**loop**
+		Use a busy loop with a non-blocking call to ``blkioq_do_io()``.
+
+.. option:: libblkio_force_enable_completion_eventfd : [libblkio]
+
+	Enable the queue's completion eventfd even when unused. This may impact
+	performance. The default is to enable it only if
+	:option:`libblkio_wait_mode=eventfd <libblkio_wait_mode>`.
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
index 00000000..054aa800
--- /dev/null
+++ b/engines/libblkio.c
@@ -0,0 +1,914 @@
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
+/* per-thread state */
+struct fio_blkio_data {
+	struct blkioq *q;
+	int completion_fd; /* may be -1 if not FIO_BLKIO_WAIT_MODE_EVENTFD */
+
+	bool has_mem_region; /* whether mem_region is valid */
+	struct blkio_mem_region mem_region; /* only if allocated by libblkio */
+
+	struct iovec *iovecs; /* for vectored requests */
+	struct blkio_completion *completions;
+};
+
+enum fio_blkio_wait_mode {
+	FIO_BLKIO_WAIT_MODE_BLOCK,
+	FIO_BLKIO_WAIT_MODE_EVENTFD,
+	FIO_BLKIO_WAIT_MODE_LOOP,
+};
+
+struct fio_blkio_options {
+	void *pad; /* option fields must not have offset 0 */
+
+	char *driver;
+
+	char *path;
+	char *pre_connect_props;
+
+	int num_entries;
+	int queue_size;
+	char *pre_start_props;
+
+	unsigned int hipri;
+	unsigned int vectored;
+	unsigned int write_zeroes_on_trim;
+	enum fio_blkio_wait_mode wait_mode;
+	unsigned int force_enable_completion_eventfd;
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
+		.name	= "libblkio_path",
+		.lname	= "libblkio \"path\" property",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct fio_blkio_options, path),
+		.help	= "Value to set the \"path\" property to",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
+	{
+		.name	= "libblkio_pre_connect_props",
+		.lname	= "Additional properties to be set before blkio_connect()",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct fio_blkio_options, pre_connect_props),
+		.help	= "",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
+	{
+		.name	= "libblkio_num_entries",
+		.lname	= "libblkio \"num-entries\" property",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct fio_blkio_options, num_entries),
+		.help	= "Value to set the \"num-entries\" property to",
+		.minval	= 1,
+		.interval = 1,
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
+	{
+		.name	= "libblkio_queue_size",
+		.lname	= "libblkio \"queue-size\" property",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct fio_blkio_options, queue_size),
+		.help	= "Value to set the \"queue-size\" property to",
+		.minval	= 1,
+		.interval = 1,
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
+	{
+		.name	= "libblkio_pre_start_props",
+		.lname	= "Additional properties to be set before blkio_start()",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct fio_blkio_options, pre_start_props),
+		.help	= "",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
+	{
+		.name	= "hipri",
+		.lname	= "Use poll queues",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct fio_blkio_options, hipri),
+		.help	= "Use poll queues",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
+	{
+		.name	= "libblkio_vectored",
+		.lname	= "Use blkioq_{readv,writev}()",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct fio_blkio_options, vectored),
+		.help	= "Use blkioq_{readv,writev}() instead of blkioq_{read,write}()",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
+	{
+		.name	= "libblkio_write_zeroes_on_trim",
+		.lname	= "Use blkioq_write_zeroes() for TRIM",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct fio_blkio_options,
+				   write_zeroes_on_trim),
+		.help	= "Use blkioq_write_zeroes() for TRIM instead of blkioq_discard()",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
+	{
+		.name	= "libblkio_wait_mode",
+		.lname	= "How to wait for completions",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct fio_blkio_options, wait_mode),
+		.help	= "How to wait for completions",
+		.def	= "block",
+		.posval = {
+			  { .ival = "block",
+			    .oval = FIO_BLKIO_WAIT_MODE_BLOCK,
+			    .help = "Blocking blkioq_do_io()",
+			  },
+			  { .ival = "eventfd",
+			    .oval = FIO_BLKIO_WAIT_MODE_EVENTFD,
+			    .help = "Blocking read() on the completion eventfd",
+			  },
+			  { .ival = "loop",
+			    .oval = FIO_BLKIO_WAIT_MODE_LOOP,
+			    .help = "Busy loop with non-blocking blkioq_do_io()",
+			  },
+		},
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
+	{
+		.name	= "libblkio_force_enable_completion_eventfd",
+		.lname	= "Force enable the completion eventfd, even if unused",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct fio_blkio_options,
+				   force_enable_completion_eventfd),
+		.help	= "This can impact performance",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBBLKIO,
+	},
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
+	/* iteration can mutate string, so copy it */
+	new_str = strdup(str);
+	if (!new_str) {
+		log_err("fio: strdup() failed\n");
+		return 1;
+	}
+
+	/* iterate over property name-value pairs */
+	while ((name = get_next_str(&new_str))) {
+		/* split into property name and value */
+		value = strchr(name, '=');
+		if (!value) {
+			log_err("fio: missing '=' in option %s\n", opt_name);
+			ret = 1;
+			break;
+		}
+
+		*value = '\0';
+		++value;
+
+		/* strip whitespace from property name */
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
+		/* strip whitespace from property value */
+		strip_blank_front(&value);
+		strip_blank_end(value);
+
+		/* set property */
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
+static int fio_blkio_create_and_connect(struct thread_data *td,
+					struct blkio **out_blkio)
+{
+	const struct fio_blkio_options *options = td->eo;
+	struct blkio *b;
+	int ret;
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
+	if (options->path) {
+		if (blkio_set_str(b, "path", options->path) != 0) {
+			fio_blkio_log_err(blkio_set_str);
+			goto err_blkio_destroy;
+		}
+	}
+
+	if (fio_blkio_set_props_from_str(b, "libblkio_pre_connect_props",
+					 options->pre_connect_props) != 0)
+		goto err_blkio_destroy;
+
+	if (blkio_connect(b) != 0) {
+		fio_blkio_log_err(blkio_connect);
+		goto err_blkio_destroy;
+	}
+
+	if (options->num_entries != 0) {
+		if (blkio_set_int(b, "num-entries",
+				  options->num_entries) != 0) {
+			fio_blkio_log_err(blkio_set_int);
+			goto err_blkio_destroy;
+		}
+	}
+
+	if (options->queue_size != 0) {
+		if (blkio_set_int(b, "queue-size", options->queue_size) != 0) {
+			fio_blkio_log_err(blkio_set_int);
+			goto err_blkio_destroy;
+		}
+	}
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
+static bool incompatible_threaded_subjob_options = false;
+
+/*
+ * This callback determines the device/file size, so it creates and connects a
+ * blkio instance. But it is invoked from the main thread in the original fio
+ * process, not from the processes in which jobs will actually run. It thus
+ * subsequently destroys the blkio, which is recreated in the init() callback.
+ */
+static int fio_blkio_setup(struct thread_data *td)
+{
+	const struct fio_blkio_options *options = td->eo;
+	struct blkio *b;
+	int ret = 0;
+	uint64_t capacity;
+
+	assert(td->files_index == 1);
+
+	if (fio_blkio_check_opt_compat(td) != 0) {
+		incompatible_threaded_subjob_options = true;
+		return 1;
+	}
+
+	if (options->hipri &&
+		options->wait_mode == FIO_BLKIO_WAIT_MODE_EVENTFD) {
+		log_err("fio: option hipri is incompatible with option libblkio_wait_mode=eventfd\n");
+		return 1;
+	}
+
+	if (options->hipri && options->force_enable_completion_eventfd) {
+		log_err("fio: option hipri is incompatible with option libblkio_force_enable_completion_eventfd\n");
+		return 1;
+	}
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
+	td->files[0]->real_file_size = capacity;
+	fio_file_set_size_known(td->files[0]);
+
+out_blkio_destroy:
+	blkio_destroy(&b);
+	return ret;
+}
+
+static int fio_blkio_init(struct thread_data *td)
+{
+	const struct fio_blkio_options *options = td->eo;
+	struct fio_blkio_data *data;
+	int flags;
+
+	if (td->o.use_thread && incompatible_threaded_subjob_options) {
+		/*
+		 * Different subjobs using option 'thread' specified
+		 * incompatible options. We don't know which configuration
+		 * should win, so we just fail all such subjobs.
+		 */
+		return 1;
+	}
+
+	/*
+	 * Request enqueueing is fast, and it's not possible to know exactly
+	 * when a request is submitted, so never report submission latencies.
+	 */
+	td->o.disable_slat = 1;
+
+	data = calloc(1, sizeof(*data));
+	if (!data) {
+		log_err("fio: calloc() failed\n");
+		return 1;
+	}
+
+	data->iovecs = calloc(td->o.iodepth, sizeof(data->iovecs[0]));
+	data->completions = calloc(td->o.iodepth, sizeof(data->completions[0]));
+	if (!data->iovecs || !data->completions) {
+		log_err("fio: calloc() failed\n");
+		goto err_free;
+	}
+
+	fio_blkio_proc_lock();
+
+	if (proc_state.initted_threads == 0) {
+		/* initialize per-process blkio */
+		int num_queues, num_poll_queues;
+
+		if (td->o.use_thread) {
+			num_queues 	= total_threaded_subjobs(false);
+			num_poll_queues = total_threaded_subjobs(true);
+		} else {
+			num_queues 	= options->hipri ? 0 : 1;
+			num_poll_queues = options->hipri ? 1 : 0;
+		}
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
+	}
+
+	if (options->hipri) {
+		int i = proc_state.initted_hipri_threads;
+		data->q = blkio_get_poll_queue(proc_state.b, i);
+	} else {
+		int i = proc_state.initted_threads -
+				proc_state.initted_hipri_threads;
+		data->q = blkio_get_queue(proc_state.b, i);
+	}
+
+	if (options->wait_mode == FIO_BLKIO_WAIT_MODE_EVENTFD ||
+		options->force_enable_completion_eventfd) {
+		/* enable completion fd and make it blocking */
+		blkioq_set_completion_fd_enabled(data->q, true);
+		data->completion_fd = blkioq_get_completion_fd(data->q);
+
+		flags = fcntl(data->completion_fd, F_GETFL);
+		if (flags < 0) {
+			log_err("fio: fcntl(F_GETFL) failed: %s\n",
+				strerror(errno));
+			goto err_blkio_destroy;
+		}
+
+		if (fcntl(data->completion_fd, F_SETFL,
+			  flags & ~O_NONBLOCK) != 0) {
+			log_err("fio: fcntl(F_SETFL) failed: %s\n",
+				strerror(errno));
+			goto err_blkio_destroy;
+		}
+	} else {
+		data->completion_fd = -1;
+	}
+
+	++proc_state.initted_threads;
+	if (options->hipri)
+		++proc_state.initted_hipri_threads;
+
+	/* Set data last so cleanup() does nothing if init() fails. */
+	td->io_ops_data = data;
+
+	fio_blkio_proc_unlock();
+
+	return 0;
+
+err_blkio_destroy:
+	if (proc_state.initted_threads == 0)
+		blkio_destroy(&proc_state.b);
+err_unlock:
+	if (proc_state.initted_threads == 0)
+		proc_state.b = NULL;
+	fio_blkio_proc_unlock();
+err_free:
+	free(data->completions);
+	free(data->iovecs);
+	free(data);
+	return 1;
+}
+
+static int fio_blkio_post_init(struct thread_data *td)
+{
+	struct fio_blkio_data *data = td->io_ops_data;
+
+	if (!data->has_mem_region) {
+		/*
+		 * Memory was allocated by the fio core and not iomem_alloc(),
+		 * so we need to register it as a memory region here.
+		 *
+		 * `td->orig_buffer_size` is computed like `len` below, but then
+		 * fio can add some padding to it to make sure it is
+		 * sufficiently aligned to the page size and the mem_align
+		 * option. However, this can make it become unaligned to the
+		 * "mem-region-alignment" property in ways that the user can't
+		 * control, so we essentially recompute `td->orig_buffer_size`
+		 * here but without adding that padding.
+		 */
+
+		unsigned long long max_block_size;
+		struct blkio_mem_region region;
+
+		max_block_size = max(td->o.max_bs[DDIR_READ],
+				     max(td->o.max_bs[DDIR_WRITE],
+					 td->o.max_bs[DDIR_TRIM]));
+
+		region = (struct blkio_mem_region) {
+			.addr	= td->orig_buffer,
+			.len	= (size_t)max_block_size *
+					(size_t)td->o.iodepth,
+			.fd	= -1,
+		};
+
+		if (blkio_map_mem_region(proc_state.b, &region) != 0) {
+			fio_blkio_log_err(blkio_map_mem_region);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static void fio_blkio_cleanup(struct thread_data *td)
+{
+	struct fio_blkio_data *data = td->io_ops_data;
+
+	/*
+	 * Subjobs from different jobs can be terminated at different times, so
+	 * this callback may be invoked for one subjob while another is still
+	 * doing I/O. Those subjobs may share the process, so we must wait until
+	 * the last subjob in the process wants to clean up to actually destroy
+	 * the blkio.
+	 */
+
+	if (data) {
+		free(data->completions);
+		free(data->iovecs);
+		free(data);
+
+		fio_blkio_proc_lock();
+		if (--proc_state.initted_threads == 0) {
+			blkio_destroy(&proc_state.b);
+			proc_state.b = NULL;
+		}
+		fio_blkio_proc_unlock();
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
+
+	if (blkio_get_uint64(proc_state.b, "mem-region-alignment",
+			     &mem_region_alignment) != 0) {
+		fio_blkio_log_err(blkio_get_uint64);
+		return 1;
+	}
+
+	/* round up size to satisfy mem-region-alignment */
+	size = align_up(size, (size_t)mem_region_alignment);
+
+	fio_blkio_proc_lock();
+
+	if (blkio_alloc_mem_region(proc_state.b, &data->mem_region,
+				   size) != 0) {
+		fio_blkio_log_err(blkio_alloc_mem_region);
+		ret = 1;
+		goto out;
+	}
+
+	if (blkio_map_mem_region(proc_state.b, &data->mem_region) != 0) {
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
+	blkio_free_mem_region(proc_state.b, &data->mem_region);
+out:
+	fio_blkio_proc_unlock();
+	return ret;
+}
+
+static void fio_blkio_iomem_free(struct thread_data *td)
+{
+	struct fio_blkio_data *data = td->io_ops_data;
+
+	if (data && data->has_mem_region) {
+		fio_blkio_proc_lock();
+		blkio_unmap_mem_region(proc_state.b, &data->mem_region);
+		blkio_free_mem_region(proc_state.b, &data->mem_region);
+		fio_blkio_proc_unlock();
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
+	const struct fio_blkio_options *options = td->eo;
+	struct fio_blkio_data *data = td->io_ops_data;
+
+	fio_ro_check(td, io_u);
+
+	switch (io_u->ddir) {
+		case DDIR_READ:
+			if (options->vectored) {
+				struct iovec *iov = &data->iovecs[io_u->index];
+				iov->iov_base = io_u->xfer_buf;
+				iov->iov_len = (size_t)io_u->xfer_buflen;
+
+				blkioq_readv(data->q, io_u->offset, iov, 1,
+					     io_u, 0);
+			} else {
+				blkioq_read(data->q, io_u->offset,
+					    io_u->xfer_buf,
+					    (size_t)io_u->xfer_buflen, io_u, 0);
+			}
+			break;
+		case DDIR_WRITE:
+			if (options->vectored) {
+				struct iovec *iov = &data->iovecs[io_u->index];
+				iov->iov_base = io_u->xfer_buf;
+				iov->iov_len = (size_t)io_u->xfer_buflen;
+
+				blkioq_writev(data->q, io_u->offset, iov, 1,
+					      io_u, 0);
+			} else {
+				blkioq_write(data->q, io_u->offset,
+					     io_u->xfer_buf,
+					     (size_t)io_u->xfer_buflen, io_u,
+					     0);
+			}
+			break;
+		case DDIR_TRIM:
+			if (options->write_zeroes_on_trim) {
+				blkioq_write_zeroes(data->q, io_u->offset,
+						    io_u->xfer_buflen, io_u, 0);
+			} else {
+				blkioq_discard(data->q, io_u->offset,
+					       io_u->xfer_buflen, io_u, 0);
+			}
+		        break;
+		case DDIR_SYNC:
+		case DDIR_DATASYNC:
+			blkioq_flush(data->q, io_u, 0);
+			break;
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
+	const struct fio_blkio_options *options = td->eo;
+	struct fio_blkio_data *data = td->io_ops_data;
+	int ret, n;
+	uint64_t event;
+
+	switch (options->wait_mode) {
+	case FIO_BLKIO_WAIT_MODE_BLOCK:
+		n = blkioq_do_io(data->q, data->completions, (int)min, (int)max,
+				 NULL);
+		if (n < 0) {
+			fio_blkio_log_err(blkioq_do_io);
+			return -1;
+		}
+		return n;
+	case FIO_BLKIO_WAIT_MODE_EVENTFD:
+		n = blkioq_do_io(data->q, data->completions, 0, (int)max, NULL);
+		if (n < 0) {
+			fio_blkio_log_err(blkioq_do_io);
+			return -1;
+		}
+		while (n < (int)min) {
+			ret = read(data->completion_fd, &event, sizeof(event));
+			if (ret != sizeof(event)) {
+				log_err("fio: read() on the completion fd returned %d\n",
+					ret);
+				return -1;
+			}
+
+			ret = blkioq_do_io(data->q, data->completions + n, 0,
+					   (int)max - n, NULL);
+			if (ret < 0) {
+				fio_blkio_log_err(blkioq_do_io);
+				return -1;
+			}
+
+			n += ret;
+		}
+		return n;
+	case FIO_BLKIO_WAIT_MODE_LOOP:
+		for (n = 0; n < (int)min; ) {
+			ret = blkioq_do_io(data->q, data->completions + n, 0,
+					   (int)max - n, NULL);
+			if (ret < 0) {
+				fio_blkio_log_err(blkioq_do_io);
+				return -1;
+			}
+
+			n += ret;
+		}
+		return n;
+	default:
+		return -1;
+	}
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
+				  FIO_NO_OFFLOAD | FIO_SKIPPABLE_IOMEM_ALLOC,
+
+	.setup			= fio_blkio_setup,
+	.init			= fio_blkio_init,
+	.post_init		= fio_blkio_post_init,
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
index 00000000..40f625cf
--- /dev/null
+++ b/examples/libblkio-io_uring.fio
@@ -0,0 +1,29 @@
+; Benchmark accessing a regular file or block device using libblkio.
+;
+; Replace "/dev/nvme0n1" below with the path to your file or device, or override
+; it by passing the '--libblkio_path=...' flag to fio.
+;
+; In the example below, the two subjobs of "job-B" *and* the single subjob of
+; "job-C" will share a single libblkio instance, and "job-A" will use a separate
+; libblkio instance.
+;
+; For information on libblkio, see: https://gitlab.com/libblkio/libblkio
+
+[global]
+ioengine=libblkio
+libblkio_driver=io_uring
+libblkio_path=/dev/nvme0n1  ; REPLACE THIS WITH THE RIGHT PATH
+rw=randread
+blocksize=4k
+direct=1
+time_based=1
+runtime=10s
+
+[job-A]
+
+[job-B]
+numjobs=2  ; run two copies of this job simultaneously
+thread=1   ; have each copy run as a separate thread in the *same* process
+
+[job-C]
+thread=1  ; have the job run as a thread in the *same* process as "job-B"
diff --git a/examples/libblkio-virtio-blk-vfio-pci.fio b/examples/libblkio-virtio-blk-vfio-pci.fio
new file mode 100644
index 00000000..024224a6
--- /dev/null
+++ b/examples/libblkio-virtio-blk-vfio-pci.fio
@@ -0,0 +1,29 @@
+; Benchmark accessing a PCI virtio-blk device using libblkio.
+;
+; Replace "/sys/bus/pci/devices/0000:00:01.0" below with the path to your
+; device's sysfs directory, or override it by passing the '--libblkio_path=...'
+; flag to fio.
+;
+; In the example below, the two subjobs of "job-B" *and* the single subjob of
+; "job-C" will share a single libblkio instance, and "job-A" will use a separate
+; libblkio instance.
+;
+; For information on libblkio, see: https://gitlab.com/libblkio/libblkio
+
+[global]
+ioengine=libblkio
+libblkio_driver=virtio-blk-vfio-pci
+libblkio_path=/sys/bus/pci/devices/0000:00:01.0  ; REPLACE THIS WITH THE RIGHT PATH
+rw=randread
+blocksize=4k
+time_based=1
+runtime=10s
+
+[job-A]
+
+[job-B]
+numjobs=2  ; run two copies of this job simultaneously
+thread=1   ; have each copy run as a separate thread in the *same* process
+
+[job-C]
+thread=1  ; have the job run as a thread in the *same* process as "job-B"
diff --git a/fio.1 b/fio.1
index 62af0bd2..7a153731 100644
--- a/fio.1
+++ b/fio.1
@@ -1992,6 +1992,16 @@ I/O engine using the xNVMe C API, for NVMe devices. The xnvme engine provides
 flexibility to access GNU/Linux Kernel NVMe driver via libaio, IOCTLs, io_uring,
 the SPDK NVMe driver, or your own custom NVMe driver. The xnvme engine includes
 engine specific options. (See \fIhttps://xnvme.io/\fR).
+.TP
+.B libblkio
+Use the libblkio library (\fIhttps://gitlab.com/libblkio/libblkio\fR). The
+specific driver to use must be set using \fBlibblkio_driver\fR. If
+\fBmem\fR/\fBiomem\fR is not specified, memory allocation is delegated to
+libblkio (and so is guaranteed to work with the selected driver). One libblkio
+instance is used per process, so all jobs setting option \fBthread\fR will share
+a single instance (with one queue per thread) and must specify compatible
+options. Note that some drivers don't allow several instances to access the same
+device or file simultaneously, but allow it for threads.
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
@@ -2604,6 +2614,74 @@ xnvme namespace identifier for userspace NVMe driver such as SPDK.
 .TP
 .BI (xnvme)xnvme_iovec
 If this option is set, xnvme will use vectored read/write commands.
+.TP
+.BI (libblkio)libblkio_driver \fR=\fPstr
+The libblkio driver to use. Different drivers access devices through different
+underlying interfaces. Available drivers depend on the libblkio version in use
+and are listed at \fIhttps://libblkio.gitlab.io/libblkio/blkio.html#drivers\fR
+.TP
+.BI (libblkio)libblkio_path \fR=\fPstr
+Sets the value of the driver-specific "path" property before connecting the
+libblkio instance, which identifies the target device or file on which to
+perform I/O. Its exact semantics are driver-dependent and not all drivers may
+support it; see \fIhttps://libblkio.gitlab.io/libblkio/blkio.html#drivers\fR
+.TP
+.BI (libblkio)libblkio_pre_connect_props \fR=\fPstr
+A colon-separated list of additional libblkio properties to be set after
+creating but before connecting the libblkio instance. Each property must have
+the format \fB<name>=<value>\fR. Colons can be escaped as \fB\\:\fR. These are
+set after the engine sets any other properties, so those can be overriden.
+Available properties depend on the libblkio version in use and are listed at
+\fIhttps://libblkio.gitlab.io/libblkio/blkio.html#properties\fR
+.TP
+.BI (libblkio)libblkio_num_entries \fR=\fPint
+Sets the value of the driver-specific "num-entries" property before starting the
+libblkio instance. Its exact semantics are driver-dependent and not all drivers
+may support it; see \fIhttps://libblkio.gitlab.io/libblkio/blkio.html#drivers\fR
+.TP
+.BI (libblkio)libblkio_queue_size \fR=\fPint
+Sets the value of the driver-specific "queue-size" property before starting the
+libblkio instance. Its exact semantics are driver-dependent and not all drivers
+may support it; see \fIhttps://libblkio.gitlab.io/libblkio/blkio.html#drivers\fR
+.TP
+.BI (libblkio)libblkio_pre_start_props \fR=\fPstr
+A colon-separated list of additional libblkio properties to be set after
+connecting but before starting the libblkio instance. Each property must have
+the format \fB<name>=<value>\fR. Colons can be escaped as \fB\\:\fR. These are
+set after the engine sets any other properties, so those can be overriden.
+Available properties depend on the libblkio version in use and are listed at
+\fIhttps://libblkio.gitlab.io/libblkio/blkio.html#properties\fR
+.TP
+.BI (libblkio)hipri
+Use poll queues. This is incompatible with \fBlibblkio_wait_mode=eventfd\fR and
+\fBlibblkio_force_enable_completion_eventfd\fR.
+.TP
+.BI (libblkio)libblkio_vectored
+Submit vectored read and write requests.
+.TP
+.BI (libblkio)libblkio_write_zeroes_on_trim
+Submit trims as "write zeroes" requests instead of discard requests.
+.TP
+.BI (libblkio)libblkio_wait_mode \fR=\fPstr
+How to wait for completions:
+.RS
+.RS
+.TP
+.B block \fR(default)
+Use a blocking call to \fBblkioq_do_io()\fR.
+.TP
+.B eventfd
+Use a blocking call to \fBread()\fR on the completion eventfd.
+.TP
+.B loop
+Use a busy loop with a non-blocking call to \fBblkioq_do_io()\fR.
+.RE
+.RE
+.TP
+.BI (libblkio)libblkio_force_enable_completion_eventfd
+Enable the queue's completion eventfd even when unused. This may impact
+performance. The default is to enable it only if
+\fBlibblkio_wait_mode=eventfd\fR.
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
diff --git a/ioengines.h b/ioengines.h
index 11d2115c..d43540d0 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -87,6 +87,8 @@ enum fio_ioengine_flags {
 	FIO_NO_OFFLOAD	= 1 << 15,	/* no async offload */
 	FIO_ASYNCIO_SETS_ISSUE_TIME
 			= 1 << 16,	/* async ioengine with commit function that sets issue_time */
+	FIO_SKIPPABLE_IOMEM_ALLOC
+			= 1 << 17,	/* skip iomem_alloc & iomem_free if job sets mem/iomem */
 };
 
 /*
diff --git a/memory.c b/memory.c
index 6cf73333..577d3dd5 100644
--- a/memory.c
+++ b/memory.c
@@ -305,16 +305,18 @@ int allocate_io_mem(struct thread_data *td)
 	dprint(FD_MEM, "Alloc %llu for buffers\n", (unsigned long long) total_mem);
 
 	/*
-	 * If the IO engine has hooks to allocate/free memory, use those. But
-	 * error out if the user explicitly asked for something else.
+	 * If the IO engine has hooks to allocate/free memory and the user
+	 * doesn't explicitly ask for something else, use those. But fail if the
+	 * user asks for something else with an engine that doesn't allow that.
 	 */
-	if (td->io_ops->iomem_alloc) {
-		if (fio_option_is_set(&td->o, mem_type)) {
-			log_err("fio: option 'mem/iomem' conflicts with specified IO engine\n");
-			ret = 1;
-		} else
-			ret = td->io_ops->iomem_alloc(td, total_mem);
-	} else if (td->o.mem_type == MEM_MALLOC)
+	if (td->io_ops->iomem_alloc && fio_option_is_set(&td->o, mem_type) &&
+	    !td_ioengine_flagged(td, FIO_SKIPPABLE_IOMEM_ALLOC)) {
+		log_err("fio: option 'mem/iomem' conflicts with specified IO engine\n");
+		ret = 1;
+	} else if (td->io_ops->iomem_alloc &&
+		   !fio_option_is_set(&td->o, mem_type))
+		ret = td->io_ops->iomem_alloc(td, total_mem);
+	else if (td->o.mem_type == MEM_MALLOC)
 		ret = alloc_mem_malloc(td, total_mem);
 	else if (td->o.mem_type == MEM_SHM || td->o.mem_type == MEM_SHMHUGE)
 		ret = alloc_mem_shm(td, total_mem);
@@ -342,7 +344,7 @@ void free_io_mem(struct thread_data *td)
 	if (td->o.odirect || td->o.oatomic)
 		total_mem += page_mask;
 
-	if (td->io_ops->iomem_alloc) {
+	if (td->io_ops->iomem_alloc && !fio_option_is_set(&td->o, mem_type)) {
 		if (td->io_ops->iomem_free)
 			td->io_ops->iomem_free(td);
 	} else if (td->o.mem_type == MEM_MALLOC)
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
