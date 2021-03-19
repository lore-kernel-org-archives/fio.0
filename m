Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhCSMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 19 Mar 2021 08:00:08 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84D7C06174A
        for <fio@vger.kernel.org>; Fri, 19 Mar 2021 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lNDnQ-007Mda-W5
        for fio@vger.kernel.org; Fri, 19 Mar 2021 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210319120002.531501BC012B@kernel.dk>
Date: Fri, 19 Mar 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dede9b9fae3ab670c1ca864ac66aea5e997e1f34:

  Merge branch 'free-dump-options' of https://github.com/floatious/fio (2021-03-17 09:25:46 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e7e536b665bd6a9d3e936e0847dbbb6957101da4:

  Merge branch 'unified-merge' of https://github.com/jeffreyalien/fio (2021-03-18 10:19:57 -0600)

----------------------------------------------------------------
Brandon Paupore (1):
      Add functionality to the unified_rw_reporting parameter to output separate and mixed stats when set to 'both' or 2.

Jan Michalski (1):
      rpma: add librpma_apm_* and librpma_gpspm_* engines

Jens Axboe (2):
      Merge branch 'add-librpma-engines' of https://github.com/janekmi/fio
      Merge branch 'unified-merge' of https://github.com/jeffreyalien/fio

 HOWTO                              |   37 +-
 Makefile                           |   15 +
 ci/travis-install-librpma.sh       |   22 +
 ci/travis-install-pmdk.sh          |   28 +
 ci/travis-install.sh               |   10 +
 configure                          |   52 ++
 engines/librpma_apm.c              |  256 +++++++++
 engines/librpma_fio.c              | 1051 ++++++++++++++++++++++++++++++++++++
 engines/librpma_fio.h              |  273 ++++++++++
 engines/librpma_gpspm.c            |  755 ++++++++++++++++++++++++++
 engines/librpma_gpspm_flush.pb-c.c |  214 ++++++++
 engines/librpma_gpspm_flush.pb-c.h |  120 ++++
 engines/librpma_gpspm_flush.proto  |   15 +
 eta.c                              |    4 +-
 examples/librpma_apm-client.fio    |   24 +
 examples/librpma_apm-server.fio    |   26 +
 examples/librpma_gpspm-client.fio  |   23 +
 examples/librpma_gpspm-server.fio  |   31 ++
 fio.1                              |   36 +-
 optgroup.c                         |    4 +
 optgroup.h                         |    2 +
 options.c                          |   41 +-
 stat.c                             |  316 ++++++++++-
 stat.h                             |    3 +
 24 files changed, 3329 insertions(+), 29 deletions(-)
 create mode 100755 ci/travis-install-librpma.sh
 create mode 100755 ci/travis-install-pmdk.sh
 create mode 100644 engines/librpma_apm.c
 create mode 100644 engines/librpma_fio.c
 create mode 100644 engines/librpma_fio.h
 create mode 100644 engines/librpma_gpspm.c
 create mode 100644 engines/librpma_gpspm_flush.pb-c.c
 create mode 100644 engines/librpma_gpspm_flush.pb-c.h
 create mode 100644 engines/librpma_gpspm_flush.proto
 create mode 100644 examples/librpma_apm-client.fio
 create mode 100644 examples/librpma_apm-server.fio
 create mode 100644 examples/librpma_gpspm-client.fio
 create mode 100644 examples/librpma_gpspm-server.fio

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 041b91fa..c48f46d8 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1146,11 +1146,31 @@ I/O type
 	behaves in a similar fashion, except it sends the same offset 8 number of
 	times before generating a new offset.
 
-.. option:: unified_rw_reporting=bool
+.. option:: unified_rw_reporting=str
 
 	Fio normally reports statistics on a per data direction basis, meaning that
-	reads, writes, and trims are accounted and reported separately. If this
-	option is set fio sums the results and report them as "mixed" instead.
+	reads, writes, and trims are accounted and reported separately. This option
+	determines whether fio reports the results normally, summed together, or as
+	both options.
+	Accepted values are:
+
+		**none**
+			Normal statistics reporting.
+
+		**mixed**
+			Statistics are summed per data direction and reported together.
+
+		**both**
+			Statistics are reported normally, followed by the mixed statistics.
+
+		**0**
+			Backward-compatible alias for **none**.
+
+		**1**
+			Backward-compatible alias for **mixed**.
+		
+		**2**
+			Alias for **both**.
 
 .. option:: randrepeat=bool
 
@@ -2192,7 +2212,7 @@ with the caveat that when used on the command line, they must come after the
 		this will be the starting port number since fio will use a range of
 		ports.
 
-   [rdma]
+   [rdma], [librpma_*]
 
 		The port to use for RDMA-CM communication. This should be the same value
 		on the client and the server side.
@@ -2203,6 +2223,15 @@ with the caveat that when used on the command line, they must come after the
 	is a TCP listener or UDP reader, the hostname is not used and must be omitted
 	unless it is a valid UDP multicast address.
 
+.. option:: serverip=str : [librpma_*]
+
+	The IP address to be used for RDMA-CM based I/O.
+
+.. option:: direct_write_to_pmem=bool : [librpma_*]
+
+	Set to 1 only when Direct Write to PMem from the remote host is possible.
+	Otherwise, set to 0.
+
 .. option:: interface=str : [netsplice] [net]
 
 	The IP address of the network interface used to send or receive UDP
diff --git a/Makefile b/Makefile
index 87a47b66..fce3d0d1 100644
--- a/Makefile
+++ b/Makefile
@@ -94,6 +94,21 @@ ifdef CONFIG_RDMA
   rdma_LIBS = -libverbs -lrdmacm
   ENGINES += rdma
 endif
+ifdef CONFIG_LIBRPMA_APM
+  librpma_apm_SRCS = engines/librpma_apm.c
+  librpma_fio_SRCS = engines/librpma_fio.c
+  librpma_apm_LIBS = -lrpma -lpmem
+  ENGINES += librpma_apm
+endif
+ifdef CONFIG_LIBRPMA_GPSPM
+  librpma_gpspm_SRCS = engines/librpma_gpspm.c engines/librpma_gpspm_flush.pb-c.c
+  librpma_fio_SRCS = engines/librpma_fio.c
+  librpma_gpspm_LIBS = -lrpma -lpmem -lprotobuf-c
+  ENGINES += librpma_gpspm
+endif
+ifdef librpma_fio_SRCS
+  SOURCE += $(librpma_fio_SRCS)
+endif
 ifdef CONFIG_POSIXAIO
   SOURCE += engines/posixaio.c
 endif
diff --git a/ci/travis-install-librpma.sh b/ci/travis-install-librpma.sh
new file mode 100755
index 00000000..b127f3f5
--- /dev/null
+++ b/ci/travis-install-librpma.sh
@@ -0,0 +1,22 @@
+#!/bin/bash -e
+
+# 11.02.2021 Merge pull request #866 from ldorau/rpma-mmap-memory-for-rpma_mr_reg-in-rpma_flush_apm_new
+LIBRPMA_VERSION=fbac593917e98f3f26abf14f4fad5a832b330f5c
+ZIP_FILE=rpma.zip
+
+WORKDIR=$(pwd)
+
+# install librpma
+wget -O $ZIP_FILE https://github.com/pmem/rpma/archive/${LIBRPMA_VERSION}.zip
+unzip $ZIP_FILE
+mkdir -p rpma-${LIBRPMA_VERSION}/build
+cd rpma-${LIBRPMA_VERSION}/build
+cmake .. -DCMAKE_BUILD_TYPE=Release \
+	-DCMAKE_INSTALL_PREFIX=/usr \
+	-DBUILD_DOC=OFF \
+	-DBUILD_EXAMPLES=OFF \
+	-DBUILD_TESTS=OFF
+make -j$(nproc)
+sudo make -j$(nproc) install
+cd $WORKDIR
+rm -rf $ZIP_FILE rpma-${LIBRPMA_VERSION}
diff --git a/ci/travis-install-pmdk.sh b/ci/travis-install-pmdk.sh
new file mode 100755
index 00000000..803438f8
--- /dev/null
+++ b/ci/travis-install-pmdk.sh
@@ -0,0 +1,28 @@
+#!/bin/bash -e
+
+# pmdk v1.9.1 release
+PMDK_VERSION=1.9.1
+
+WORKDIR=$(pwd)
+
+#
+# The '/bin/sh' shell used by PMDK's 'make install'
+# does not know the exact localization of clang
+# and fails with:
+#    /bin/sh: 1: clang: not found
+# if CC is not set to the full path of clang.
+#
+export CC=$(which $CC)
+
+# Install PMDK libraries, because PMDK's libpmem
+# is a dependency of the librpma fio engine.
+# Install it from a release package
+# with already generated documentation,
+# in order to not install 'pandoc'.
+wget https://github.com/pmem/pmdk/releases/download/${PMDK_VERSION}/pmdk-${PMDK_VERSION}.tar.gz
+tar -xzf pmdk-${PMDK_VERSION}.tar.gz
+cd pmdk-${PMDK_VERSION}
+make -j$(nproc) NDCTL_ENABLE=n
+sudo make -j$(nproc) install prefix=/usr NDCTL_ENABLE=n
+cd $WORKDIR
+rm -rf pmdk-${PMDK_VERSION}
diff --git a/ci/travis-install.sh b/ci/travis-install.sh
index 103695dc..4c4c04c5 100755
--- a/ci/travis-install.sh
+++ b/ci/travis-install.sh
@@ -43,6 +43,16 @@ case "$TRAVIS_OS_NAME" in
 	)
 	sudo apt-get -qq update
 	sudo apt-get install --no-install-recommends -qq -y "${pkgs[@]}"
+	# librpma is supported on the amd64 (x86_64) architecture for now
+	if [[ $CI_TARGET_ARCH == "amd64" ]]; then
+		# install libprotobuf-c-dev required by librpma_gpspm
+		sudo apt-get install --no-install-recommends -qq -y libprotobuf-c-dev
+		# PMDK libraries have to be installed, because
+		# libpmem is a dependency of the librpma fio engine
+		ci/travis-install-pmdk.sh
+		# install librpma from sources from GitHub
+		ci/travis-install-librpma.sh
+	fi
 	;;
     "osx")
 	brew update >/dev/null 2>&1
diff --git a/configure b/configure
index d79f6521..2f5ac91f 100755
--- a/configure
+++ b/configure
@@ -924,6 +924,49 @@ if test "$disable_rdma" != "yes" && compile_prog "" "-lrdmacm" "rdma"; then
 fi
 print_config "rdmacm" "$rdmacm"
 
+##########################################
+# librpma probe
+if test "$librpma" != "yes" ; then
+  librpma="no"
+fi
+cat > $TMPC << EOF
+#include <stdio.h>
+#include <librpma.h>
+int main(int argc, char **argv)
+{
+  enum rpma_conn_event event = RPMA_CONN_REJECTED;
+  (void) event; /* unused */
+  rpma_log_set_threshold(RPMA_LOG_THRESHOLD, RPMA_LOG_LEVEL_INFO);
+  return 0;
+}
+EOF
+if test "$disable_rdma" != "yes" && compile_prog "" "-lrpma" "rpma"; then
+    librpma="yes"
+fi
+print_config "librpma" "$librpma"
+
+##########################################
+# libprotobuf-c probe
+if test "$libprotobuf_c" != "yes" ; then
+  libprotobuf_c="no"
+fi
+cat > $TMPC << EOF
+#include <stdio.h>
+#include <protobuf-c/protobuf-c.h>
+#if !defined(PROTOBUF_C_VERSION_NUMBER)
+# error PROTOBUF_C_VERSION_NUMBER is not defined!
+#endif
+int main(int argc, char **argv)
+{
+  (void)protobuf_c_message_check(NULL);
+  return 0;
+}
+EOF
+if compile_prog "" "-lprotobuf-c" "protobuf_c"; then
+    libprotobuf_c="yes"
+fi
+print_config "libprotobuf_c" "$libprotobuf_c"
+
 ##########################################
 # asprintf() and vasprintf() probes
 if test "$have_asprintf" != "yes" ; then
@@ -2819,6 +2862,15 @@ fi
 if test "$libverbs" = "yes" -a "$rdmacm" = "yes" ; then
   output_sym "CONFIG_RDMA"
 fi
+# librpma is supported on the 'x86_64' architecture for now
+if test "$cpu" = "x86_64" -a "$libverbs" = "yes" -a "$rdmacm" = "yes" \
+    -a "$librpma" = "yes" -a "$libpmem" = "yes" ; then
+  output_sym "CONFIG_LIBRPMA_APM"
+fi
+if test "$cpu" = "x86_64" -a "$libverbs" = "yes" -a "$rdmacm" = "yes" \
+    -a "$librpma" = "yes" -a "$libpmem" = "yes" -a "$libprotobuf_c" = "yes" ; then
+  output_sym "CONFIG_LIBRPMA_GPSPM"
+fi
 if test "$clock_gettime" = "yes" ; then
   output_sym "CONFIG_CLOCK_GETTIME"
 fi
diff --git a/engines/librpma_apm.c b/engines/librpma_apm.c
new file mode 100644
index 00000000..ffa3769d
--- /dev/null
+++ b/engines/librpma_apm.c
@@ -0,0 +1,256 @@
+/*
+* librpma_apm: IO engine that uses PMDK librpma to read and write data,
+ *		based on Appliance Persistency Method
+ *
+ * Copyright 2020-2021, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License,
+ * version 2 as published by the Free Software Foundation..
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include "librpma_fio.h"
+
+/* client side implementation */
+
+static inline int client_io_flush(struct thread_data *td,
+		struct io_u *first_io_u, struct io_u *last_io_u,
+		unsigned long long int len);
+
+static int client_get_io_u_index(struct rpma_completion *cmpl,
+		unsigned int *io_u_index);
+
+static int client_init(struct thread_data *td)
+{
+	struct librpma_fio_client_data *ccd;
+	unsigned int sq_size;
+	uint32_t cq_size;
+	struct rpma_conn_cfg *cfg = NULL;
+	struct rpma_peer_cfg *pcfg = NULL;
+	int ret;
+
+	/* not supported readwrite = trim / randtrim / trimwrite */
+	if (td_trim(td)) {
+		td_verror(td, EINVAL, "Not supported mode.");
+		return -1;
+	}
+
+	/*
+	 * Calculate the required queue sizes where:
+	 * - the send queue (SQ) has to be big enough to accommodate
+	 *   all io_us (WRITEs) and all flush requests (FLUSHes)
+	 * - the completion queue (CQ) has to be big enough to accommodate all
+	 *   success and error completions (cq_size = sq_size)
+	 */
+	if (td_random(td) || td_rw(td)) {
+		/*
+		 * sq_size = max(rand_read_sq_size, rand_write_sq_size)
+		 * where rand_read_sq_size < rand_write_sq_size because read
+		 * does not require flush afterwards
+		 * rand_write_sq_size = N * (WRITE + FLUSH)
+		 *
+		 * Note: rw is no different from random write since having
+		 * interleaved reads with writes in extreme forces you to flush
+		 * as often as when the writes are random.
+		 */
+		sq_size = 2 * td->o.iodepth;
+	} else if (td_write(td)) {
+		/* sequential TD_DDIR_WRITE only */
+		if (td->o.sync_io) {
+			sq_size = 2; /* WRITE + FLUSH */
+		} else {
+			/*
+			 * N * WRITE + B * FLUSH where:
+			 * - B == ceil(iodepth / iodepth_batch)
+			 *   which is the number of batches for N writes
+			 */
+			sq_size = td->o.iodepth + LIBRPMA_FIO_CEIL(td->o.iodepth,
+					td->o.iodepth_batch);
+		}
+	} else {
+		/* TD_DDIR_READ only */
+		if (td->o.sync_io) {
+			sq_size = 1; /* READ */
+		} else {
+			sq_size = td->o.iodepth; /* N x READ */
+		}
+	}
+	cq_size = sq_size;
+
+	/* create a connection configuration object */
+	if ((ret = rpma_conn_cfg_new(&cfg))) {
+		librpma_td_verror(td, ret, "rpma_conn_cfg_new");
+		return -1;
+	}
+
+	/* apply queue sizes */
+	if ((ret = rpma_conn_cfg_set_sq_size(cfg, sq_size))) {
+		librpma_td_verror(td, ret, "rpma_conn_cfg_set_sq_size");
+		goto err_cfg_delete;
+	}
+	if ((ret = rpma_conn_cfg_set_cq_size(cfg, cq_size))) {
+		librpma_td_verror(td, ret, "rpma_conn_cfg_set_cq_size");
+		goto err_cfg_delete;
+	}
+
+	if (librpma_fio_client_init(td, cfg))
+		goto err_cfg_delete;
+
+	ccd = td->io_ops_data;
+
+	if (ccd->server_mr_flush_type == RPMA_FLUSH_TYPE_PERSISTENT) {
+		if (!ccd->ws->direct_write_to_pmem) {
+			if (td->thread_number == 1)
+				log_err(
+					"Fio librpma engine will not work until the Direct Write to PMem on the server side is possible (direct_write_to_pmem)\n");
+			goto err_cleanup_common;
+		}
+
+		/* configure peer's direct write to pmem support */
+		if ((ret = rpma_peer_cfg_new(&pcfg))) {
+			librpma_td_verror(td, ret, "rpma_peer_cfg_new");
+			goto err_cleanup_common;
+		}
+
+		if ((ret = rpma_peer_cfg_set_direct_write_to_pmem(pcfg, true))) {
+			librpma_td_verror(td, ret,
+				"rpma_peer_cfg_set_direct_write_to_pmem");
+			(void) rpma_peer_cfg_delete(&pcfg);
+			goto err_cleanup_common;
+		}
+
+		if ((ret = rpma_conn_apply_remote_peer_cfg(ccd->conn, pcfg))) {
+			librpma_td_verror(td, ret,
+				"rpma_conn_apply_remote_peer_cfg");
+			(void) rpma_peer_cfg_delete(&pcfg);
+			goto err_cleanup_common;
+		}
+
+		(void) rpma_peer_cfg_delete(&pcfg);
+	} else if (td->thread_number == 1) {
+		/* XXX log_info mixes with the JSON output */
+		log_err(
+			"Note: Direct Write to PMem is not supported by default nor required if you use DRAM instead of PMem on the server side (direct_write_to_pmem).\n"
+			"Remember that flushing to DRAM does not make your data persistent and may be used only for experimental purposes.\n");
+	}
+
+	if ((ret = rpma_conn_cfg_delete(&cfg))) {
+		librpma_td_verror(td, ret, "rpma_conn_cfg_delete");
+		/* non fatal error - continue */
+	}
+
+	ccd->flush = client_io_flush;
+	ccd->get_io_u_index = client_get_io_u_index;
+
+	return 0;
+
+err_cleanup_common:
+	librpma_fio_client_cleanup(td);
+
+err_cfg_delete:
+	(void) rpma_conn_cfg_delete(&cfg);
+
+	return -1;
+}
+
+static void client_cleanup(struct thread_data *td)
+{
+	struct librpma_fio_client_data *ccd = td->io_ops_data;
+
+	if (ccd == NULL)
+		return;
+
+	free(ccd->client_data);
+
+	librpma_fio_client_cleanup(td);
+}
+
+static inline int client_io_flush(struct thread_data *td,
+		struct io_u *first_io_u, struct io_u *last_io_u,
+		unsigned long long int len)
+{
+	struct librpma_fio_client_data *ccd = td->io_ops_data;
+	size_t dst_offset = first_io_u->offset;
+	int ret;
+
+	if ((ret = rpma_flush(ccd->conn, ccd->server_mr, dst_offset, len,
+			ccd->server_mr_flush_type, RPMA_F_COMPLETION_ALWAYS,
+			(void *)(uintptr_t)last_io_u->index))) {
+		librpma_td_verror(td, ret, "rpma_flush");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int client_get_io_u_index(struct rpma_completion *cmpl,
+		unsigned int *io_u_index)
+{
+	memcpy(io_u_index, &cmpl->op_context, sizeof(*io_u_index));
+
+	return 1;
+}
+
+FIO_STATIC struct ioengine_ops ioengine_client = {
+	.name			= "librpma_apm_client",
+	.version		= FIO_IOOPS_VERSION,
+	.init			= client_init,
+	.post_init		= librpma_fio_client_post_init,
+	.get_file_size		= librpma_fio_client_get_file_size,
+	.open_file		= librpma_fio_file_nop,
+	.queue			= librpma_fio_client_queue,
+	.commit			= librpma_fio_client_commit,
+	.getevents		= librpma_fio_client_getevents,
+	.event			= librpma_fio_client_event,
+	.errdetails		= librpma_fio_client_errdetails,
+	.close_file		= librpma_fio_file_nop,
+	.cleanup		= client_cleanup,
+	.flags			= FIO_DISKLESSIO,
+	.options		= librpma_fio_options,
+	.option_struct_size	= sizeof(struct librpma_fio_options_values),
+};
+
+/* server side implementation */
+
+static int server_open_file(struct thread_data *td, struct fio_file *f)
+{
+	return librpma_fio_server_open_file(td, f, NULL);
+}
+
+static enum fio_q_status server_queue(struct thread_data *td, struct io_u *io_u)
+{
+	return FIO_Q_COMPLETED;
+}
+
+FIO_STATIC struct ioengine_ops ioengine_server = {
+	.name			= "librpma_apm_server",
+	.version		= FIO_IOOPS_VERSION,
+	.init			= librpma_fio_server_init,
+	.open_file		= server_open_file,
+	.close_file		= librpma_fio_server_close_file,
+	.queue			= server_queue,
+	.invalidate		= librpma_fio_file_nop,
+	.cleanup		= librpma_fio_server_cleanup,
+	.flags			= FIO_SYNCIO,
+	.options		= librpma_fio_options,
+	.option_struct_size	= sizeof(struct librpma_fio_options_values),
+};
+
+/* register both engines */
+
+static void fio_init fio_librpma_apm_register(void)
+{
+	register_ioengine(&ioengine_client);
+	register_ioengine(&ioengine_server);
+}
+
+static void fio_exit fio_librpma_apm_unregister(void)
+{
+	unregister_ioengine(&ioengine_client);
+	unregister_ioengine(&ioengine_server);
+}
diff --git a/engines/librpma_fio.c b/engines/librpma_fio.c
new file mode 100644
index 00000000..810b55e2
--- /dev/null
+++ b/engines/librpma_fio.c
@@ -0,0 +1,1051 @@
+/*
+ * librpma_fio: librpma_apm and librpma_gpspm engines' common part.
+ *
+ * Copyright 2021, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License,
+ * version 2 as published by the Free Software Foundation..
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include "librpma_fio.h"
+
+#include <libpmem.h>
+
+struct fio_option librpma_fio_options[] = {
+	{
+		.name	= "serverip",
+		.lname	= "rpma_server_ip",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct librpma_fio_options_values, server_ip),
+		.help	= "IP address the server is listening on",
+		.def	= "",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBRPMA,
+	},
+	{
+		.name	= "port",
+		.lname	= "rpma_server port",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct librpma_fio_options_values, port),
+		.help	= "port the server is listening on",
+		.def	= "7204",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBRPMA,
+	},
+	{
+		.name	= "direct_write_to_pmem",
+		.lname	= "Direct Write to PMem (via RDMA) from the remote host is possible",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct librpma_fio_options_values,
+					direct_write_to_pmem),
+		.help	= "Set to true ONLY when Direct Write to PMem from the remote host is possible (https://pmem.io/rpma/documentation/basic-direct-write-to-pmem.html)",
+		.def	= "",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBRPMA,
+	},
+	{
+		.name	= NULL,
+	},
+};
+
+int librpma_fio_td_port(const char *port_base_str, struct thread_data *td,
+		char *port_out)
+{
+	unsigned long int port_ul = strtoul(port_base_str, NULL, 10);
+	unsigned int port_new;
+
+	port_out[0] = '\0';
+
+	if (port_ul == ULONG_MAX) {
+		td_verror(td, errno, "strtoul");
+		return -1;
+	}
+	port_ul += td->thread_number - 1;
+	if (port_ul >= UINT_MAX) {
+		log_err("[%u] port number (%lu) bigger than UINT_MAX\n",
+			td->thread_number, port_ul);
+		return -1;
+	}
+
+	port_new = port_ul;
+	snprintf(port_out, LIBRPMA_FIO_PORT_STR_LEN_MAX - 1, "%u", port_new);
+
+	return 0;
+}
+
+char *librpma_fio_allocate_dram(struct thread_data *td, size_t size,
+	struct librpma_fio_mem *mem)
+{
+	char *mem_ptr = NULL;
+	int ret;
+
+	if ((ret = posix_memalign((void **)&mem_ptr, page_size, size))) {
+		log_err("fio: posix_memalign() failed\n");
+		td_verror(td, ret, "posix_memalign");
+		return NULL;
+	}
+
+	mem->mem_ptr = mem_ptr;
+	mem->size_mmap = 0;
+
+	return mem_ptr;
+}
+
+char *librpma_fio_allocate_pmem(struct thread_data *td, const char *filename,
+		size_t size, struct librpma_fio_mem *mem)
+{
+	size_t size_mmap = 0;
+	char *mem_ptr = NULL;
+	int is_pmem = 0;
+	size_t ws_offset;
+
+	if (size % page_size) {
+		log_err("fio: size (%zu) is not aligned to page size (%zu)\n",
+			size, page_size);
+		return NULL;
+	}
+
+	ws_offset = (td->thread_number - 1) * size;
+
+	if (!filename) {
+		log_err("fio: filename is not set\n");
+		return NULL;
+	}
+
+	/* map the file */
+	mem_ptr = pmem_map_file(filename, 0 /* len */, 0 /* flags */,
+			0 /* mode */, &size_mmap, &is_pmem);
+	if (mem_ptr == NULL) {
+		log_err("fio: pmem_map_file(%s) failed\n", filename);
+		/* pmem_map_file() sets errno on failure */
+		td_verror(td, errno, "pmem_map_file");
+		return NULL;
+	}
+
+	/* pmem is expected */
+	if (!is_pmem) {
+		log_err("fio: %s is not located in persistent memory\n",
+			filename);
+		goto err_unmap;
+	}
+
+	/* check size of allocated persistent memory */
+	if (size_mmap < ws_offset + size) {
+		log_err(
+			"fio: %s is too small to handle so many threads (%zu < %zu)\n",
+			filename, size_mmap, ws_offset + size);
+		goto err_unmap;
+	}
+
+	log_info("fio: size of memory mapped from the file %s: %zu\n",
+		filename, size_mmap);
+
+	mem->mem_ptr = mem_ptr;
+	mem->size_mmap = size_mmap;
+
+	return mem_ptr + ws_offset;
+
+err_unmap:
+	(void) pmem_unmap(mem_ptr, size_mmap);
+	return NULL;
+}
+
+void librpma_fio_free(struct librpma_fio_mem *mem)
+{
+	if (mem->size_mmap)
+		(void) pmem_unmap(mem->mem_ptr, mem->size_mmap);
+	else
+		free(mem->mem_ptr);
+}
+
+#define LIBRPMA_FIO_RETRY_MAX_NO	10
+#define LIBRPMA_FIO_RETRY_DELAY_S	5
+
+int librpma_fio_client_init(struct thread_data *td,
+		struct rpma_conn_cfg *cfg)
+{
+	struct librpma_fio_client_data *ccd;
+	struct librpma_fio_options_values *o = td->eo;
+	struct ibv_context *dev = NULL;
+	char port_td[LIBRPMA_FIO_PORT_STR_LEN_MAX];
+	struct rpma_conn_req *req = NULL;
+	enum rpma_conn_event event;
+	struct rpma_conn_private_data pdata;
+	enum rpma_log_level log_level_aux = RPMA_LOG_LEVEL_WARNING;
+	int remote_flush_type;
+	int retry;
+	int ret;
+
+	/* --debug=net sets RPMA_LOG_THRESHOLD_AUX to RPMA_LOG_LEVEL_INFO */
+#ifdef FIO_INC_DEBUG
+	if ((1UL << FD_NET) & fio_debug)
+		log_level_aux = RPMA_LOG_LEVEL_INFO;
+#endif
+
+	/* configure logging thresholds to see more details */
+	rpma_log_set_threshold(RPMA_LOG_THRESHOLD, RPMA_LOG_LEVEL_INFO);
+	rpma_log_set_threshold(RPMA_LOG_THRESHOLD_AUX, log_level_aux);
+
+	/* obtain an IBV context for a remote IP address */
+	if ((ret = rpma_utils_get_ibv_context(o->server_ip,
+			RPMA_UTIL_IBV_CONTEXT_REMOTE, &dev))) {
+		librpma_td_verror(td, ret, "rpma_utils_get_ibv_context");
+		return -1;
+	}
+
+	/* allocate client's data */
+	ccd = calloc(1, sizeof(*ccd));
+	if (ccd == NULL) {
+		td_verror(td, errno, "calloc");
+		return -1;
+	}
+
+	/* allocate all in-memory queues */
+	ccd->io_us_queued = calloc(td->o.iodepth, sizeof(*ccd->io_us_queued));
+	if (ccd->io_us_queued == NULL) {
+		td_verror(td, errno, "calloc");
+		goto err_free_ccd;
+	}
+
+	ccd->io_us_flight = calloc(td->o.iodepth, sizeof(*ccd->io_us_flight));
+	if (ccd->io_us_flight == NULL) {
+		td_verror(td, errno, "calloc");
+		goto err_free_io_u_queues;
+	}
+
+	ccd->io_us_completed = calloc(td->o.iodepth,
+			sizeof(*ccd->io_us_completed));
+	if (ccd->io_us_completed == NULL) {
+		td_verror(td, errno, "calloc");
+		goto err_free_io_u_queues;
+	}
+
+	/* create a new peer object */
+	if ((ret = rpma_peer_new(dev, &ccd->peer))) {
+		librpma_td_verror(td, ret, "rpma_peer_new");
+		goto err_free_io_u_queues;
+	}
+
+	/* create a connection request */
+	if (librpma_fio_td_port(o->port, td, port_td))
+		goto err_peer_delete;
+
+	for (retry = 0; retry < LIBRPMA_FIO_RETRY_MAX_NO; retry++) {
+		if ((ret = rpma_conn_req_new(ccd->peer, o->server_ip, port_td,
+				cfg, &req))) {
+			librpma_td_verror(td, ret, "rpma_conn_req_new");
+			goto err_peer_delete;
+		}
+
+		/*
+		 * Connect the connection request
+		 * and obtain the connection object.
+		 */
+		if ((ret = rpma_conn_req_connect(&req, NULL, &ccd->conn))) {
+			librpma_td_verror(td, ret, "rpma_conn_req_connect");
+			goto err_req_delete;
+		}
+
+		/* wait for the connection to establish */
+		if ((ret = rpma_conn_next_event(ccd->conn, &event))) {
+			librpma_td_verror(td, ret, "rpma_conn_next_event");
+			goto err_conn_delete;
+		} else if (event == RPMA_CONN_ESTABLISHED) {
+			break;
+		} else if (event == RPMA_CONN_REJECTED) {
+			(void) rpma_conn_disconnect(ccd->conn);
+			(void) rpma_conn_delete(&ccd->conn);
+			if (retry < LIBRPMA_FIO_RETRY_MAX_NO - 1) {
+				log_err("Thread [%d]: Retrying (#%i) ...\n",
+					td->thread_number, retry + 1);
+				sleep(LIBRPMA_FIO_RETRY_DELAY_S);
+			} else {
+				log_err(
+					"Thread [%d]: The maximum number of retries exceeded. Closing.\n",
+					td->thread_number);
+			}
+		} else {
+			log_err(
+				"rpma_conn_next_event returned an unexptected event: (%s != RPMA_CONN_ESTABLISHED)\n",
+				rpma_utils_conn_event_2str(event));
+			goto err_conn_delete;
+		}
+	}
+
+	if (retry > 0)
+		log_err("Thread [%d]: Connected after retry #%i\n",
+			td->thread_number, retry);
+
+	if (ccd->conn == NULL)
+		goto err_peer_delete;
+
+	/* get the connection's private data sent from the server */
+	if ((ret = rpma_conn_get_private_data(ccd->conn, &pdata))) {
+		librpma_td_verror(td, ret, "rpma_conn_get_private_data");
+		goto err_conn_delete;
+	}
+
+	/* get the server's workspace representation */
+	ccd->ws = pdata.ptr;
+
+	/* create the server's memory representation */
+	if ((ret = rpma_mr_remote_from_descriptor(&ccd->ws->descriptor[0],
+			ccd->ws->mr_desc_size, &ccd->server_mr))) {
+		librpma_td_verror(td, ret, "rpma_mr_remote_from_descriptor");
+		goto err_conn_delete;
+	}
+
+	/* get the total size of the shared server memory */
+	if ((ret = rpma_mr_remote_get_size(ccd->server_mr, &ccd->ws_size))) {
+		librpma_td_verror(td, ret, "rpma_mr_remote_get_size");
+		goto err_conn_delete;
+	}
+
+	/* get flush type of the remote node */
+	if ((ret = rpma_mr_remote_get_flush_type(ccd->server_mr,
+			&remote_flush_type))) {
+		librpma_td_verror(td, ret, "rpma_mr_remote_get_flush_type");
+		goto err_conn_delete;
+	}
+
+	ccd->server_mr_flush_type =
+		(remote_flush_type & RPMA_MR_USAGE_FLUSH_TYPE_PERSISTENT) ?
+		RPMA_FLUSH_TYPE_PERSISTENT : RPMA_FLUSH_TYPE_VISIBILITY;
+
+	/*
+	 * Assure an io_us buffer allocation is page-size-aligned which is required
+	 * to register for RDMA. User-provided value is intentionally ignored.
+	 */
+	td->o.mem_align = page_size;
+
+	td->io_ops_data = ccd;
+
+	return 0;
+
+err_conn_delete:
+	(void) rpma_conn_disconnect(ccd->conn);
+	(void) rpma_conn_delete(&ccd->conn);
+
+err_req_delete:
+	(void) rpma_conn_req_delete(&req);
+
+err_peer_delete:
+	(void) rpma_peer_delete(&ccd->peer);
+
+err_free_io_u_queues:
+	free(ccd->io_us_queued);
+	free(ccd->io_us_flight);
+	free(ccd->io_us_completed);
+
+err_free_ccd:
+	free(ccd);
+
+	return -1;
+}
+
+void librpma_fio_client_cleanup(struct thread_data *td)
+{
+	struct librpma_fio_client_data *ccd = td->io_ops_data;
+	enum rpma_conn_event ev;
+	int ret;
+
+	if (ccd == NULL)
+		return;
+
+	/* delete the iou's memory registration */
+	if ((ret = rpma_mr_dereg(&ccd->orig_mr)))
+		librpma_td_verror(td, ret, "rpma_mr_dereg");
+	/* delete the iou's memory registration */
+	if ((ret = rpma_mr_remote_delete(&ccd->server_mr)))
+		librpma_td_verror(td, ret, "rpma_mr_remote_delete");
+	/* initiate disconnection */
+	if ((ret = rpma_conn_disconnect(ccd->conn)))
+		librpma_td_verror(td, ret, "rpma_conn_disconnect");
+	/* wait for disconnection to end up */
+	if ((ret = rpma_conn_next_event(ccd->conn, &ev))) {
+		librpma_td_verror(td, ret, "rpma_conn_next_event");
+	} else if (ev != RPMA_CONN_CLOSED) {
+		log_err(
+			"client_cleanup received an unexpected event (%s != RPMA_CONN_CLOSED)\n",
+			rpma_utils_conn_event_2str(ev));
+	}
+	/* delete the connection */
+	if ((ret = rpma_conn_delete(&ccd->conn)))
+		librpma_td_verror(td, ret, "rpma_conn_delete");
+	/* delete the peer */
+	if ((ret = rpma_peer_delete(&ccd->peer)))
+		librpma_td_verror(td, ret, "rpma_peer_delete");
+	/* free the software queues */
+	free(ccd->io_us_queued);
+	free(ccd->io_us_flight);
+	free(ccd->io_us_completed);
+	free(ccd);
+	td->io_ops_data = NULL; /* zero ccd */
+}
+
+int librpma_fio_file_nop(struct thread_data *td, struct fio_file *f)
+{
+	/* NOP */
+	return 0;
+}
+
+int librpma_fio_client_post_init(struct thread_data *td)
+{
+	struct librpma_fio_client_data *ccd =  td->io_ops_data;
+	size_t io_us_size;
+	int ret;
+
+	/*
+	 * td->orig_buffer is not aligned. The engine requires aligned io_us
+	 * so FIO alignes up the address using the formula below.
+	 */
+	ccd->orig_buffer_aligned = PTR_ALIGN(td->orig_buffer, page_mask) +
+			td->o.mem_align;
+
+	/*
+	 * td->orig_buffer_size beside the space really consumed by io_us
+	 * has paddings which can be omitted for the memory registration.
+	 */
+	io_us_size = (unsigned long long)td_max_bs(td) *
+			(unsigned long long)td->o.iodepth;
+
+	if ((ret = rpma_mr_reg(ccd->peer, ccd->orig_buffer_aligned, io_us_size,
+			RPMA_MR_USAGE_READ_DST | RPMA_MR_USAGE_READ_SRC |
+			RPMA_MR_USAGE_WRITE_DST | RPMA_MR_USAGE_WRITE_SRC |
+			RPMA_MR_USAGE_FLUSH_TYPE_PERSISTENT, &ccd->orig_mr)))
+		librpma_td_verror(td, ret, "rpma_mr_reg");
+	return ret;
+}
+
+int librpma_fio_client_get_file_size(struct thread_data *td,
+		struct fio_file *f)
+{
+	struct librpma_fio_client_data *ccd = td->io_ops_data;
+
+	f->real_file_size = ccd->ws_size;
+	fio_file_set_size_known(f);
+
+	return 0;
+}
+
+static enum fio_q_status client_queue_sync(struct thread_data *td,
+		struct io_u *io_u)
+{
+	struct librpma_fio_client_data *ccd = td->io_ops_data;
+	struct rpma_completion cmpl;
+	unsigned io_u_index;
+	int ret;
+
+	/* execute io_u */
+	if (io_u->ddir == DDIR_READ) {
+		/* post an RDMA read operation */
+		if (librpma_fio_client_io_read(td, io_u,
+				RPMA_F_COMPLETION_ALWAYS))
+			goto err;
+	} else if (io_u->ddir == DDIR_WRITE) {
+		/* post an RDMA write operation */
+		if (librpma_fio_client_io_write(td, io_u))
+			goto err;
+		if (ccd->flush(td, io_u, io_u, io_u->xfer_buflen))
+			goto err;
+	} else {
+		log_err("unsupported IO mode: %s\n", io_ddir_name(io_u->ddir));
+		goto err;
+	}
+
+	do {
+		/* get a completion */
+		ret = rpma_conn_completion_get(ccd->conn, &cmpl);
+		if (ret == RPMA_E_NO_COMPLETION) {
+			/* lack of completion is not an error */
+			continue;
+		} else if (ret != 0) {
+			/* an error occurred */
+			librpma_td_verror(td, ret, "rpma_conn_completion_get");
+			goto err;
+		}
+
+		/* if io_us has completed with an error */
+		if (cmpl.op_status != IBV_WC_SUCCESS)
+			goto err;
+
+		if (cmpl.op == RPMA_OP_SEND)
+			++ccd->op_send_completed;
+		else {
+			if (cmpl.op == RPMA_OP_RECV)
+				++ccd->op_recv_completed;
+
+			break;
+		}
+	} while (1);
+
+	if (ccd->get_io_u_index(&cmpl, &io_u_index) != 1)
+		goto err;
+
+	if (io_u->index != io_u_index) {
+		log_err(
+			"no matching io_u for received completion found (io_u_index=%u)\n",
+			io_u_index);
+		goto err;
+	}
+
+	/* make sure all SENDs are completed before exit - clean up SQ */
+	if (librpma_fio_client_io_complete_all_sends(td))
+		goto err;
+
+	return FIO_Q_COMPLETED;
+
+err:
+	io_u->error = -1;
+	return FIO_Q_COMPLETED;
+}
+
+enum fio_q_status librpma_fio_client_queue(struct thread_data *td,
+		struct io_u *io_u)
+{
+	struct librpma_fio_client_data *ccd = td->io_ops_data;
+
+	if (ccd->io_u_queued_nr == (int)td->o.iodepth)
+		return FIO_Q_BUSY;
+
+	if (td->o.sync_io)
+		return client_queue_sync(td, io_u);
+
+	/* io_u -> queued[] */
+	ccd->io_us_queued[ccd->io_u_queued_nr] = io_u;
+	ccd->io_u_queued_nr++;
+
+	return FIO_Q_QUEUED;
+}
+
+int librpma_fio_client_commit(struct thread_data *td)
+{
+	struct librpma_fio_client_data *ccd = td->io_ops_data;
+	int flags = RPMA_F_COMPLETION_ON_ERROR;
+	struct timespec now;
+	bool fill_time;
+	int i;
+	struct io_u *flush_first_io_u = NULL;
+	unsigned long long int flush_len = 0;
+
+	if (!ccd->io_us_queued)
+		return -1;
+
+	/* execute all io_us from queued[] */
+	for (i = 0; i < ccd->io_u_queued_nr; i++) {
+		struct io_u *io_u = ccd->io_us_queued[i];
+
+		if (io_u->ddir == DDIR_READ) {
+			if (i + 1 == ccd->io_u_queued_nr ||
+			    ccd->io_us_queued[i + 1]->ddir == DDIR_WRITE)
+				flags = RPMA_F_COMPLETION_ALWAYS;
+			/* post an RDMA read operation */
+			if (librpma_fio_client_io_read(td, io_u, flags))
+				return -1;
+		} else if (io_u->ddir == DDIR_WRITE) {
+			/* post an RDMA write operation */
+			if (librpma_fio_client_io_write(td, io_u))
+				return -1;
+
+			/* cache the first io_u in the sequence */
+			if (flush_first_io_u == NULL)
+				flush_first_io_u = io_u;
+
+			/*
+			 * the flush length is the sum of all io_u's creating
+			 * the sequence
+			 */
+			flush_len += io_u->xfer_buflen;
+
+			/*
+			 * if io_u's are random the rpma_flush is required
+			 * after each one of them
+			 */
+			if (!td_random(td)) {
+				/*
+				 * When the io_u's are sequential and
+				 * the current io_u is not the last one and
+				 * the next one is also a write operation
+				 * the flush can be postponed by one io_u and
+				 * cover all of them which build a continuous
+				 * sequence.
+				 */
+				if ((i + 1 < ccd->io_u_queued_nr) &&
+				    (ccd->io_us_queued[i + 1]->ddir == DDIR_WRITE))
+					continue;
+			}
+
+			/* flush all writes which build a continuous sequence */
+			if (ccd->flush(td, flush_first_io_u, io_u, flush_len))
+				return -1;
+
+			/*
+			 * reset the flush parameters in preparation for
+			 * the next one
+			 */
+			flush_first_io_u = NULL;
+			flush_len = 0;
+		} else {
+			log_err("unsupported IO mode: %s\n",
+				io_ddir_name(io_u->ddir));
+			return -1;
+		}
+	}
+
+	if ((fill_time = fio_fill_issue_time(td)))
+		fio_gettime(&now, NULL);
+
+	/* move executed io_us from queued[] to flight[] */
+	for (i = 0; i < ccd->io_u_queued_nr; i++) {
+		struct io_u *io_u = ccd->io_us_queued[i];
+
+		/* FIO does not do this if the engine is asynchronous */
+		if (fill_time)
+			memcpy(&io_u->issue_time, &now, sizeof(now));
+
+		/* move executed io_us from queued[] to flight[] */
+		ccd->io_us_flight[ccd->io_u_flight_nr] = io_u;
+		ccd->io_u_flight_nr++;
+
+		/*
+		 * FIO says:
+		 * If an engine has the commit hook
+		 * it has to call io_u_queued() itself.
+		 */
+		io_u_queued(td, io_u);
+	}
+
+	/* FIO does not do this if an engine has the commit hook. */
+	io_u_mark_submit(td, ccd->io_u_queued_nr);
+	ccd->io_u_queued_nr = 0;
+
+	return 0;
+}
+
+/*
+ * RETURN VALUE
+ * - > 0  - a number of completed io_us
+ * -   0  - when no complicitions received
+ * - (-1) - when an error occurred
+ */
+static int client_getevent_process(struct thread_data *td)
+{
+	struct librpma_fio_client_data *ccd = td->io_ops_data;
+	struct rpma_completion cmpl;
+	/* io_u->index of completed io_u (cmpl.op_context) */
+	unsigned int io_u_index;
+	/* # of completed io_us */
+	int cmpl_num = 0;
+	/* helpers */
+	struct io_u *io_u;
+	int i;
+	int ret;
+
+	/* get a completion */
+	if ((ret = rpma_conn_completion_get(ccd->conn, &cmpl))) {
+		/* lack of completion is not an error */
+		if (ret == RPMA_E_NO_COMPLETION) {
+			/* lack of completion is not an error */
+			return 0;
+		}
+
+		/* an error occurred */
+		librpma_td_verror(td, ret, "rpma_conn_completion_get");
+		return -1;
+	}
+
+	/* if io_us has completed with an error */
+	if (cmpl.op_status != IBV_WC_SUCCESS) {
+		td->error = cmpl.op_status;
+		return -1;
+	}
+
+	if (cmpl.op == RPMA_OP_SEND)
+		++ccd->op_send_completed;
+	else if (cmpl.op == RPMA_OP_RECV)
+		++ccd->op_recv_completed;
+
+	if ((ret = ccd->get_io_u_index(&cmpl, &io_u_index)) != 1)
+		return ret;
+
+	/* look for an io_u being completed */
+	for (i = 0; i < ccd->io_u_flight_nr; ++i) {
+		if (ccd->io_us_flight[i]->index == io_u_index) {
+			cmpl_num = i + 1;
+			break;
+		}
+	}
+
+	/* if no matching io_u has been found */
+	if (cmpl_num == 0) {
+		log_err(
+			"no matching io_u for received completion found (io_u_index=%u)\n",
+			io_u_index);
+		return -1;
+	}
+
+	/* move completed io_us to the completed in-memory queue */
+	for (i = 0; i < cmpl_num; ++i) {
+		/* get and prepare io_u */
+		io_u = ccd->io_us_flight[i];
+
+		/* append to the queue */
+		ccd->io_us_completed[ccd->io_u_completed_nr] = io_u;
+		ccd->io_u_completed_nr++;
+	}
+
+	/* remove completed io_us from the flight queue */
+	for (i = cmpl_num; i < ccd->io_u_flight_nr; ++i)
+		ccd->io_us_flight[i - cmpl_num] = ccd->io_us_flight[i];
+	ccd->io_u_flight_nr -= cmpl_num;
+
+	return cmpl_num;
+}
+
+int librpma_fio_client_getevents(struct thread_data *td, unsigned int min,
+		unsigned int max, const struct timespec *t)
+{
+	struct librpma_fio_client_data *ccd = td->io_ops_data;
+	/* total # of completed io_us */
+	int cmpl_num_total = 0;
+	/* # of completed io_us from a single event */
+	int cmpl_num;
+
+	do {
+		cmpl_num = client_getevent_process(td);
+		if (cmpl_num > 0) {
+			/* new completions collected */
+			cmpl_num_total += cmpl_num;
+		} else if (cmpl_num == 0) {
+			/*
+			 * It is required to make sure that CQEs for SENDs
+			 * will flow at least at the same pace as CQEs for RECVs.
+			 */
+			if (cmpl_num_total >= min &&
+			    ccd->op_send_completed >= ccd->op_recv_completed)
+				break;
+
+			/*
+			 * To reduce CPU consumption one can use
+			 * the rpma_conn_completion_wait() function.
+			 * Note this greatly increase the latency
+			 * and make the results less stable.
+			 * The bandwidth stays more or less the same.
+			 */
+		} else {
+			/* an error occurred */
+			return -1;
+		}
+
+		/*
+		 * The expected max can be exceeded if CQEs for RECVs will come up
+		 * faster than CQEs for SENDs. But it is required to make sure CQEs for
+		 * SENDs will flow at least at the same pace as CQEs for RECVs.
+		 */
+	} while (cmpl_num_total < max ||
+			ccd->op_send_completed < ccd->op_recv_completed);
+
+	/*
+	 * All posted SENDs are completed and RECVs for them (responses) are
+	 * completed. This is the initial situation so the counters are reset.
+	 */
+	if (ccd->op_send_posted == ccd->op_send_completed &&
+			ccd->op_send_completed == ccd->op_recv_completed) {
+		ccd->op_send_posted = 0;
+		ccd->op_send_completed = 0;
+		ccd->op_recv_completed = 0;
+	}
+
+	return cmpl_num_total;
+}
+
+struct io_u *librpma_fio_client_event(struct thread_data *td, int event)
+{
+	struct librpma_fio_client_data *ccd = td->io_ops_data;
+	struct io_u *io_u;
+	int i;
+
+	/* get the first io_u from the queue */
+	io_u = ccd->io_us_completed[0];
+
+	/* remove the first io_u from the queue */
+	for (i = 1; i < ccd->io_u_completed_nr; ++i)
+		ccd->io_us_completed[i - 1] = ccd->io_us_completed[i];
+	ccd->io_u_completed_nr--;
+
+	dprint_io_u(io_u, "client_event");
+
+	return io_u;
+}
+
+char *librpma_fio_client_errdetails(struct io_u *io_u)
+{
+	/* get the string representation of an error */
+	enum ibv_wc_status status = io_u->error;
+	const char *status_str = ibv_wc_status_str(status);
+
+	char *details = strdup(status_str);
+	if (details == NULL) {
+		fprintf(stderr, "Error: %s\n", status_str);
+		fprintf(stderr, "Fatal error: out of memory. Aborting.\n");
+		abort();
+	}
+
+	/* FIO frees the returned string when it becomes obsolete */
+	return details;
+}
+
+int librpma_fio_server_init(struct thread_data *td)
+{
+	struct librpma_fio_options_values *o = td->eo;
+	struct librpma_fio_server_data *csd;
+	struct ibv_context *dev = NULL;
+	enum rpma_log_level log_level_aux = RPMA_LOG_LEVEL_WARNING;
+	int ret = -1;
+
+	/* --debug=net sets RPMA_LOG_THRESHOLD_AUX to RPMA_LOG_LEVEL_INFO */
+#ifdef FIO_INC_DEBUG
+	if ((1UL << FD_NET) & fio_debug)
+		log_level_aux = RPMA_LOG_LEVEL_INFO;
+#endif
+
+	/* configure logging thresholds to see more details */
+	rpma_log_set_threshold(RPMA_LOG_THRESHOLD, RPMA_LOG_LEVEL_INFO);
+	rpma_log_set_threshold(RPMA_LOG_THRESHOLD_AUX, log_level_aux);
+
+
+	/* obtain an IBV context for a remote IP address */
+	if ((ret = rpma_utils_get_ibv_context(o->server_ip,
+			RPMA_UTIL_IBV_CONTEXT_LOCAL, &dev))) {
+		librpma_td_verror(td, ret, "rpma_utils_get_ibv_context");
+		return -1;
+	}
+
+	/* allocate server's data */
+	csd = calloc(1, sizeof(*csd));
+	if (csd == NULL) {
+		td_verror(td, errno, "calloc");
+		return -1;
+	}
+
+	/* create a new peer object */
+	if ((ret = rpma_peer_new(dev, &csd->peer))) {
+		librpma_td_verror(td, ret, "rpma_peer_new");
+		goto err_free_csd;
+	}
+
+	td->io_ops_data = csd;
+
+	return 0;
+
+err_free_csd:
+	free(csd);
+
+	return -1;
+}
+
+void librpma_fio_server_cleanup(struct thread_data *td)
+{
+	struct librpma_fio_server_data *csd =  td->io_ops_data;
+	int ret;
+
+	if (csd == NULL)
+		return;
+
+	/* free the peer */
+	if ((ret = rpma_peer_delete(&csd->peer)))
+		librpma_td_verror(td, ret, "rpma_peer_delete");
+
+	free(csd);
+}
+
+int librpma_fio_server_open_file(struct thread_data *td, struct fio_file *f,
+		struct rpma_conn_cfg *cfg)
+{
+	struct librpma_fio_server_data *csd = td->io_ops_data;
+	struct librpma_fio_options_values *o = td->eo;
+	enum rpma_conn_event conn_event = RPMA_CONN_UNDEFINED;
+	struct librpma_fio_workspace ws = {0};
+	struct rpma_conn_private_data pdata;
+	uint32_t max_msg_num;
+	struct rpma_conn_req *conn_req;
+	struct rpma_conn *conn;
+	struct rpma_mr_local *mr;
+	char port_td[LIBRPMA_FIO_PORT_STR_LEN_MAX];
+	struct rpma_ep *ep;
+	size_t mem_size = td->o.size;
+	size_t mr_desc_size;
+	void *ws_ptr;
+	int usage_mem_type;
+	int ret;
+
+	if (!f->file_name) {
+		log_err("fio: filename is not set\n");
+		return -1;
+	}
+
+	/* start a listening endpoint at addr:port */
+	if (librpma_fio_td_port(o->port, td, port_td))
+		return -1;
+
+	if ((ret = rpma_ep_listen(csd->peer, o->server_ip, port_td, &ep))) {
+		librpma_td_verror(td, ret, "rpma_ep_listen");
+		return -1;
+	}
+
+	if (strcmp(f->file_name, "malloc") == 0) {
+		/* allocation from DRAM using posix_memalign() */
+		ws_ptr = librpma_fio_allocate_dram(td, mem_size, &csd->mem);
+		usage_mem_type = RPMA_MR_USAGE_FLUSH_TYPE_VISIBILITY;
+	} else {
+		/* allocation from PMEM using pmem_map_file() */
+		ws_ptr = librpma_fio_allocate_pmem(td, f->file_name,
+				mem_size, &csd->mem);
+		usage_mem_type = RPMA_MR_USAGE_FLUSH_TYPE_PERSISTENT;
+	}
+
+	if (ws_ptr == NULL)
+		goto err_ep_shutdown;
+
+	f->real_file_size = mem_size;
+
+	if ((ret = rpma_mr_reg(csd->peer, ws_ptr, mem_size,
+			RPMA_MR_USAGE_READ_DST | RPMA_MR_USAGE_READ_SRC |
+			RPMA_MR_USAGE_WRITE_DST | RPMA_MR_USAGE_WRITE_SRC |
+			usage_mem_type, &mr))) {
+		librpma_td_verror(td, ret, "rpma_mr_reg");
+		goto err_free;
+	}
+
+	/* get size of the memory region's descriptor */
+	if ((ret = rpma_mr_get_descriptor_size(mr, &mr_desc_size))) {
+		librpma_td_verror(td, ret, "rpma_mr_get_descriptor_size");
+		goto err_mr_dereg;
+	}
+
+	/* verify size of the memory region's descriptor */
+	if (mr_desc_size > LIBRPMA_FIO_DESCRIPTOR_MAX_SIZE) {
+		log_err(
+			"size of the memory region's descriptor is too big (max=%i)\n",
+			LIBRPMA_FIO_DESCRIPTOR_MAX_SIZE);
+		goto err_mr_dereg;
+	}
+
+	/* get the memory region's descriptor */
+	if ((ret = rpma_mr_get_descriptor(mr, &ws.descriptor[0]))) {
+		librpma_td_verror(td, ret, "rpma_mr_get_descriptor");
+		goto err_mr_dereg;
+	}
+
+	if (cfg != NULL) {
+		if ((ret = rpma_conn_cfg_get_rq_size(cfg, &max_msg_num))) {
+			librpma_td_verror(td, ret, "rpma_conn_cfg_get_rq_size");
+			goto err_mr_dereg;
+		}
+
+		/* verify whether iodepth fits into uint16_t */
+		if (max_msg_num > UINT16_MAX) {
+			log_err("fio: iodepth too big (%u > %u)\n",
+				max_msg_num, UINT16_MAX);
+			return -1;
+		}
+
+		ws.max_msg_num = max_msg_num;
+	}
+
+	/* prepare a workspace description */
+	ws.direct_write_to_pmem = o->direct_write_to_pmem;
+	ws.mr_desc_size = mr_desc_size;
+	pdata.ptr = &ws;
+	pdata.len = sizeof(ws);
+
+	/* receive an incoming connection request */
+	if ((ret = rpma_ep_next_conn_req(ep, cfg, &conn_req))) {
+		librpma_td_verror(td, ret, "rpma_ep_next_conn_req");
+		goto err_mr_dereg;
+	}
+
+	if (csd->prepare_connection && csd->prepare_connection(td, conn_req))
+		goto err_req_delete;
+
+	/* accept the connection request and obtain the connection object */
+	if ((ret = rpma_conn_req_connect(&conn_req, &pdata, &conn))) {
+		librpma_td_verror(td, ret, "rpma_conn_req_connect");
+		goto err_req_delete;
+	}
+
+	/* wait for the connection to be established */
+	if ((ret = rpma_conn_next_event(conn, &conn_event))) {
+		librpma_td_verror(td, ret, "rpma_conn_next_event");
+		goto err_conn_delete;
+	} else if (conn_event != RPMA_CONN_ESTABLISHED) {
+		log_err("rpma_conn_next_event returned an unexptected event\n");
+		goto err_conn_delete;
+	}
+
+	/* end-point is no longer needed */
+	(void) rpma_ep_shutdown(&ep);
+
+	csd->ws_mr = mr;
+	csd->ws_ptr = ws_ptr;
+	csd->conn = conn;
+
+	return 0;
+
+err_conn_delete:
+	(void) rpma_conn_delete(&conn);
+
+err_req_delete:
+	(void) rpma_conn_req_delete(&conn_req);
+
+err_mr_dereg:
+	(void) rpma_mr_dereg(&mr);
+
+err_free:
+	librpma_fio_free(&csd->mem);
+
+err_ep_shutdown:
+	(void) rpma_ep_shutdown(&ep);
+
+	return -1;
+}
+
+int librpma_fio_server_close_file(struct thread_data *td, struct fio_file *f)
+{
+	struct librpma_fio_server_data *csd = td->io_ops_data;
+	enum rpma_conn_event conn_event = RPMA_CONN_UNDEFINED;
+	int rv = 0;
+	int ret;
+
+	/* wait for the connection to be closed */
+	ret = rpma_conn_next_event(csd->conn, &conn_event);
+	if (!ret && conn_event != RPMA_CONN_CLOSED) {
+		log_err("rpma_conn_next_event returned an unexptected event\n");
+		rv = -1;
+	}
+
+	if ((ret = rpma_conn_disconnect(csd->conn))) {
+		librpma_td_verror(td, ret, "rpma_conn_disconnect");
+		rv = -1;
+	}
+
+	if ((ret = rpma_conn_delete(&csd->conn))) {
+		librpma_td_verror(td, ret, "rpma_conn_delete");
+		rv = -1;
+	}
+
+	if ((ret = rpma_mr_dereg(&csd->ws_mr))) {
+		librpma_td_verror(td, ret, "rpma_mr_dereg");
+		rv = -1;
+	}
+
+	librpma_fio_free(&csd->mem);
+
+	return rv;
+}
diff --git a/engines/librpma_fio.h b/engines/librpma_fio.h
new file mode 100644
index 00000000..8cfb2e2d
--- /dev/null
+++ b/engines/librpma_fio.h
@@ -0,0 +1,273 @@
+/*
+ * librpma_fio: librpma_apm and librpma_gpspm engines' common header.
+ *
+ * Copyright 2021, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License,
+ * version 2 as published by the Free Software Foundation..
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef LIBRPMA_FIO_H
+#define LIBRPMA_FIO_H 1
+
+#include "../fio.h"
+#include "../optgroup.h"
+
+#include <librpma.h>
+
+/* servers' and clients' common */
+
+#define librpma_td_verror(td, err, func) \
+	td_vmsg((td), (err), rpma_err_2str(err), (func))
+
+/* ceil(a / b) = (a + b - 1) / b */
+#define LIBRPMA_FIO_CEIL(a, b) (((a) + (b) - 1) / (b))
+
+/* common option structure for server and client */
+struct librpma_fio_options_values {
+	/*
+	 * FIO considers .off1 == 0 absent so the first meaningful field has to
+	 * have padding ahead of it.
+	 */
+	void *pad;
+	char *server_ip;
+	/* base server listening port */
+	char *port;
+	/* Direct Write to PMem is possible */
+	unsigned int direct_write_to_pmem;
+};
+
+extern struct fio_option librpma_fio_options[];
+
+/*
+ * Limited by the maximum length of the private data
+ * for rdma_connect() in case of RDMA_PS_TCP (28 bytes).
+ */
+#define LIBRPMA_FIO_DESCRIPTOR_MAX_SIZE 24
+
+struct librpma_fio_workspace {
+	uint16_t max_msg_num;	/* # of RQ slots */
+	uint8_t direct_write_to_pmem; /* Direct Write to PMem is possible */
+	uint8_t mr_desc_size;	/* size of mr_desc in descriptor[] */
+	/* buffer containing mr_desc */
+	char descriptor[LIBRPMA_FIO_DESCRIPTOR_MAX_SIZE];
+};
+
+#define LIBRPMA_FIO_PORT_STR_LEN_MAX 12
+
+int librpma_fio_td_port(const char *port_base_str, struct thread_data *td,
+		char *port_out);
+
+struct librpma_fio_mem {
+	/* memory buffer */
+	char *mem_ptr;
+
+	/* size of the mapped persistent memory */
+	size_t size_mmap;
+};
+
+char *librpma_fio_allocate_dram(struct thread_data *td, size_t size,
+		struct librpma_fio_mem *mem);
+
+char *librpma_fio_allocate_pmem(struct thread_data *td, const char *filename,
+		size_t size, struct librpma_fio_mem *mem);
+
+void librpma_fio_free(struct librpma_fio_mem *mem);
+
+/* clients' common */
+
+typedef int (*librpma_fio_flush_t)(struct thread_data *td,
+		struct io_u *first_io_u, struct io_u *last_io_u,
+		unsigned long long int len);
+
+/*
+ * RETURN VALUE
+ * - ( 1) - on success
+ * - ( 0) - skip
+ * - (-1) - on error
+ */
+typedef int (*librpma_fio_get_io_u_index_t)(struct rpma_completion *cmpl,
+		unsigned int *io_u_index);
+
+struct librpma_fio_client_data {
+	struct rpma_peer *peer;
+	struct rpma_conn *conn;
+
+	/* aligned td->orig_buffer */
+	char *orig_buffer_aligned;
+
+	/* ious's base address memory registration (cd->orig_buffer_aligned) */
+	struct rpma_mr_local *orig_mr;
+
+	struct librpma_fio_workspace *ws;
+
+	/* a server's memory representation */
+	struct rpma_mr_remote *server_mr;
+	enum rpma_flush_type server_mr_flush_type;
+
+	/* remote workspace description */
+	size_t ws_size;
+
+	/* in-memory queues */
+	struct io_u **io_us_queued;
+	int io_u_queued_nr;
+	struct io_u **io_us_flight;
+	int io_u_flight_nr;
+	struct io_u **io_us_completed;
+	int io_u_completed_nr;
+
+	/* SQ control. Note: all of them have to be kept in sync. */
+	uint32_t op_send_posted;
+	uint32_t op_send_completed;
+	uint32_t op_recv_completed;
+
+	librpma_fio_flush_t flush;
+	librpma_fio_get_io_u_index_t get_io_u_index;
+
+	/* engine-specific client data */
+	void *client_data;
+};
+
+int librpma_fio_client_init(struct thread_data *td,
+		struct rpma_conn_cfg *cfg);
+void librpma_fio_client_cleanup(struct thread_data *td);
+
+int librpma_fio_file_nop(struct thread_data *td, struct fio_file *f);
+int librpma_fio_client_get_file_size(struct thread_data *td,
+		struct fio_file *f);
+
+int librpma_fio_client_post_init(struct thread_data *td);
+
+enum fio_q_status librpma_fio_client_queue(struct thread_data *td,
+		struct io_u *io_u);
+
+int librpma_fio_client_commit(struct thread_data *td);
+
+int librpma_fio_client_getevents(struct thread_data *td, unsigned int min,
+		unsigned int max, const struct timespec *t);
+
+struct io_u *librpma_fio_client_event(struct thread_data *td, int event);
+
+char *librpma_fio_client_errdetails(struct io_u *io_u);
+
+static inline int librpma_fio_client_io_read(struct thread_data *td,
+		struct io_u *io_u, int flags)
+{
+	struct librpma_fio_client_data *ccd = td->io_ops_data;
+	size_t dst_offset = (char *)(io_u->xfer_buf) - ccd->orig_buffer_aligned;
+	size_t src_offset = io_u->offset;
+	int ret;
+
+	if ((ret = rpma_read(ccd->conn, ccd->orig_mr, dst_offset,
+			ccd->server_mr, src_offset, io_u->xfer_buflen,
+			flags, (void *)(uintptr_t)io_u->index))) {
+		librpma_td_verror(td, ret, "rpma_read");
+		return -1;
+	}
+
+	return 0;
+}
+
+static inline int librpma_fio_client_io_write(struct thread_data *td,
+		struct io_u *io_u)
+{
+	struct librpma_fio_client_data *ccd = td->io_ops_data;
+	size_t src_offset = (char *)(io_u->xfer_buf) - ccd->orig_buffer_aligned;
+	size_t dst_offset = io_u->offset;
+	int ret;
+
+	if ((ret = rpma_write(ccd->conn, ccd->server_mr, dst_offset,
+			ccd->orig_mr, src_offset, io_u->xfer_buflen,
+			RPMA_F_COMPLETION_ON_ERROR,
+			(void *)(uintptr_t)io_u->index))) {
+		librpma_td_verror(td, ret, "rpma_write");
+		return -1;
+	}
+
+	return 0;
+}
+
+static inline int librpma_fio_client_io_complete_all_sends(
+		struct thread_data *td)
+{
+	struct librpma_fio_client_data *ccd = td->io_ops_data;
+	struct rpma_completion cmpl;
+	int ret;
+
+	while (ccd->op_send_posted != ccd->op_send_completed) {
+		/* get a completion */
+		ret = rpma_conn_completion_get(ccd->conn, &cmpl);
+		if (ret == RPMA_E_NO_COMPLETION) {
+			/* lack of completion is not an error */
+			continue;
+		} else if (ret != 0) {
+			/* an error occurred */
+			librpma_td_verror(td, ret, "rpma_conn_completion_get");
+			break;
+		}
+
+		if (cmpl.op_status != IBV_WC_SUCCESS)
+			return -1;
+
+		if (cmpl.op == RPMA_OP_SEND)
+			++ccd->op_send_completed;
+		else {
+			log_err(
+				"A completion other than RPMA_OP_SEND got during cleaning up the CQ from SENDs\n");
+			return -1;
+		}
+	}
+
+	/*
+	 * All posted SENDs are completed and RECVs for them (responses) are
+	 * completed. This is the initial situation so the counters are reset.
+	 */
+	if (ccd->op_send_posted == ccd->op_send_completed &&
+			ccd->op_send_completed == ccd->op_recv_completed) {
+		ccd->op_send_posted = 0;
+		ccd->op_send_completed = 0;
+		ccd->op_recv_completed = 0;
+	}
+
+	return 0;
+}
+
+/* servers' common */
+
+typedef int (*librpma_fio_prepare_connection_t)(
+		struct thread_data *td,
+		struct rpma_conn_req *conn_req);
+
+struct librpma_fio_server_data {
+	struct rpma_peer *peer;
+
+	/* resources of an incoming connection */
+	struct rpma_conn *conn;
+
+	char *ws_ptr;
+	struct rpma_mr_local *ws_mr;
+	struct librpma_fio_mem mem;
+
+	/* engine-specific server data */
+	void *server_data;
+
+	librpma_fio_prepare_connection_t prepare_connection;
+};
+
+int librpma_fio_server_init(struct thread_data *td);
+
+void librpma_fio_server_cleanup(struct thread_data *td);
+
+int librpma_fio_server_open_file(struct thread_data *td,
+		struct fio_file *f, struct rpma_conn_cfg *cfg);
+
+int librpma_fio_server_close_file(struct thread_data *td,
+		struct fio_file *f);
+
+#endif /* LIBRPMA_FIO_H */
diff --git a/engines/librpma_gpspm.c b/engines/librpma_gpspm.c
new file mode 100644
index 00000000..ac614f46
--- /dev/null
+++ b/engines/librpma_gpspm.c
@@ -0,0 +1,755 @@
+/*
+ * librpma_gpspm: IO engine that uses PMDK librpma to write data,
+ *		based on General Purpose Server Persistency Method
+ *
+ * Copyright 2020-2021, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License,
+ * version 2 as published by the Free Software Foundation..
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include "librpma_fio.h"
+
+#include <libpmem.h>
+
+/* Generated by the protocol buffer compiler from: librpma_gpspm_flush.proto */
+#include "librpma_gpspm_flush.pb-c.h"
+
+#define MAX_MSG_SIZE (512)
+#define IO_U_BUF_LEN (2 * MAX_MSG_SIZE)
+#define SEND_OFFSET (0)
+#define RECV_OFFSET (SEND_OFFSET + MAX_MSG_SIZE)
+
+#define GPSPM_FLUSH_REQUEST__LAST \
+	{ PROTOBUF_C_MESSAGE_INIT(&gpspm_flush_request__descriptor), 0, 0, 0 }
+
+/*
+ * 'Flush_req_last' is the last flush request
+ * the client has to send to server to indicate
+ * that the client is done.
+ */
+static const GPSPMFlushRequest Flush_req_last = GPSPM_FLUSH_REQUEST__LAST;
+
+#define IS_NOT_THE_LAST_MESSAGE(flush_req) \
+	(flush_req->length != Flush_req_last.length || \
+	flush_req->offset != Flush_req_last.offset)
+
+/* client side implementation */
+
+/* get next io_u message buffer in the round-robin fashion */
+#define IO_U_NEXT_BUF_OFF_CLIENT(cd) \
+	(IO_U_BUF_LEN * ((cd->msg_curr++) % cd->msg_num))
+
+struct client_data {
+	/* memory for sending and receiving buffered */
+	char *io_us_msgs;
+
+	/* resources for messaging buffer */
+	uint32_t msg_num;
+	uint32_t msg_curr;
+	struct rpma_mr_local *msg_mr;
+};
+
+static inline int client_io_flush(struct thread_data *td,
+		struct io_u *first_io_u, struct io_u *last_io_u,
+		unsigned long long int len);
+
+static int client_get_io_u_index(struct rpma_completion *cmpl,
+		unsigned int *io_u_index);
+
+static int client_init(struct thread_data *td)
+{
+	struct librpma_fio_client_data *ccd;
+	struct client_data *cd;
+	uint32_t write_num;
+	struct rpma_conn_cfg *cfg = NULL;
+	int ret;
+
+	/*
+	 * not supported:
+	 * - readwrite = read / trim / randread / randtrim /
+	 *               / rw / randrw / trimwrite
+	 */
+	if (td_read(td) || td_trim(td)) {
+		td_verror(td, EINVAL, "Not supported mode.");
+		return -1;
+	}
+
+	/* allocate client's data */
+	cd = calloc(1, sizeof(*cd));
+	if (cd == NULL) {
+		td_verror(td, errno, "calloc");
+		return -1;
+	}
+
+	/*
+	 * Calculate the required number of WRITEs and FLUSHes.
+	 *
+	 * Note: Each flush is a request (SEND) and response (RECV) pair.
+	 */
+	if (td_random(td)) {
+		write_num = td->o.iodepth; /* WRITE * N */
+		cd->msg_num = td->o.iodepth; /* FLUSH * N */
+	} else {
+		if (td->o.sync_io) {
+			write_num = 1; /* WRITE */
+			cd->msg_num = 1; /* FLUSH */
+		} else {
+			write_num = td->o.iodepth; /* WRITE * N */
+			/*
+			 * FLUSH * B where:
+			 * - B == ceil(iodepth / iodepth_batch)
+			 *   which is the number of batches for N writes
+			 */
+			cd->msg_num = LIBRPMA_FIO_CEIL(td->o.iodepth,
+					td->o.iodepth_batch);
+		}
+	}
+
+	/* create a connection configuration object */
+	if ((ret = rpma_conn_cfg_new(&cfg))) {
+		librpma_td_verror(td, ret, "rpma_conn_cfg_new");
+		goto err_free_cd;
+	}
+
+	/*
+	 * Calculate the required queue sizes where:
+	 * - the send queue (SQ) has to be big enough to accommodate
+	 *   all io_us (WRITEs) and all flush requests (SENDs)
+	 * - the receive queue (RQ) has to be big enough to accommodate
+	 *   all flush responses (RECVs)
+	 * - the completion queue (CQ) has to be big enough to accommodate all
+	 *   success and error completions (sq_size + rq_size)
+	 */
+	if ((ret = rpma_conn_cfg_set_sq_size(cfg, write_num + cd->msg_num))) {
+		librpma_td_verror(td, ret, "rpma_conn_cfg_set_sq_size");
+		goto err_cfg_delete;
+	}
+	if ((ret = rpma_conn_cfg_set_rq_size(cfg, cd->msg_num))) {
+		librpma_td_verror(td, ret, "rpma_conn_cfg_set_rq_size");
+		goto err_cfg_delete;
+	}
+	if ((ret = rpma_conn_cfg_set_cq_size(cfg, write_num + cd->msg_num * 2))) {
+		librpma_td_verror(td, ret, "rpma_conn_cfg_set_cq_size");
+		goto err_cfg_delete;
+	}
+
+	if (librpma_fio_client_init(td, cfg))
+		goto err_cfg_delete;
+
+	ccd = td->io_ops_data;
+
+	if (ccd->ws->direct_write_to_pmem &&
+	    ccd->server_mr_flush_type == RPMA_FLUSH_TYPE_PERSISTENT &&
+	    td->thread_number == 1) {
+		/* XXX log_info mixes with the JSON output */
+		log_err(
+			"Note: The server side supports Direct Write to PMem and it is equipped with PMem (direct_write_to_pmem).\n"
+			"You can use librpma_client and librpma_server engines for better performance instead of GPSPM.\n");
+	}
+
+	/* validate the server's RQ capacity */
+	if (cd->msg_num > ccd->ws->max_msg_num) {
+		log_err(
+			"server's RQ size (iodepth) too small to handle the client's workspace requirements (%u < %u)\n",
+			ccd->ws->max_msg_num, cd->msg_num);
+		goto err_cleanup_common;
+	}
+
+	if ((ret = rpma_conn_cfg_delete(&cfg))) {
+		librpma_td_verror(td, ret, "rpma_conn_cfg_delete");
+		/* non fatal error - continue */
+	}
+
+	ccd->flush = client_io_flush;
+	ccd->get_io_u_index = client_get_io_u_index;
+	ccd->client_data = cd;
+
+	return 0;
+
+err_cleanup_common:
+	librpma_fio_client_cleanup(td);
+
+err_cfg_delete:
+	(void) rpma_conn_cfg_delete(&cfg);
+
+err_free_cd:
+	free(cd);
+
+	return -1;
+}
+
+static int client_post_init(struct thread_data *td)
+{
+	struct librpma_fio_client_data *ccd = td->io_ops_data;
+	struct client_data *cd = ccd->client_data;
+	unsigned int io_us_msgs_size;
+	int ret;
+
+	/* message buffers initialization and registration */
+	io_us_msgs_size = cd->msg_num * IO_U_BUF_LEN;
+	if ((ret = posix_memalign((void **)&cd->io_us_msgs, page_size,
+			io_us_msgs_size))) {
+		td_verror(td, ret, "posix_memalign");
+		return ret;
+	}
+	if ((ret = rpma_mr_reg(ccd->peer, cd->io_us_msgs, io_us_msgs_size,
+			RPMA_MR_USAGE_SEND | RPMA_MR_USAGE_RECV,
+			&cd->msg_mr))) {
+		librpma_td_verror(td, ret, "rpma_mr_reg");
+		return ret;
+	}
+
+	return librpma_fio_client_post_init(td);
+}
+
+static void client_cleanup(struct thread_data *td)
+{
+	struct librpma_fio_client_data *ccd = td->io_ops_data;
+	struct client_data *cd;
+	size_t flush_req_size;
+	size_t io_u_buf_off;
+	size_t send_offset;
+	void *send_ptr;
+	int ret;
+
+	if (ccd == NULL)
+		return;
+
+	cd = ccd->client_data;
+	if (cd == NULL) {
+		librpma_fio_client_cleanup(td);
+		return;
+	}
+
+	/*
+	 * Make sure all SEND completions are collected ergo there are free
+	 * slots in the SQ for the last SEND message.
+	 *
+	 * Note: If any operation will fail we still can send the termination
+	 * notice.
+	 */
+	(void) librpma_fio_client_io_complete_all_sends(td);
+
+	/* prepare the last flush message and pack it to the send buffer */
+	flush_req_size = gpspm_flush_request__get_packed_size(&Flush_req_last);
+	if (flush_req_size > MAX_MSG_SIZE) {
+		log_err(
+			"Packed flush request size is bigger than available send buffer space (%zu > %d\n",
+			flush_req_size, MAX_MSG_SIZE);
+	} else {
+		io_u_buf_off = IO_U_NEXT_BUF_OFF_CLIENT(cd);
+		send_offset = io_u_buf_off + SEND_OFFSET;
+		send_ptr = cd->io_us_msgs + send_offset;
+		(void) gpspm_flush_request__pack(&Flush_req_last, send_ptr);
+
+		/* send the flush message */
+		if ((ret = rpma_send(ccd->conn, cd->msg_mr, send_offset,
+				flush_req_size, RPMA_F_COMPLETION_ALWAYS,
+				NULL)))
+			librpma_td_verror(td, ret, "rpma_send");
+
+		++ccd->op_send_posted;
+
+		/* Wait for the SEND to complete */
+		(void) librpma_fio_client_io_complete_all_sends(td);
+	}
+
+	/* deregister the messaging buffer memory */
+	if ((ret = rpma_mr_dereg(&cd->msg_mr)))
+		librpma_td_verror(td, ret, "rpma_mr_dereg");
+
+	free(ccd->client_data);
+
+	librpma_fio_client_cleanup(td);
+}
+
+static inline int client_io_flush(struct thread_data *td,
+		struct io_u *first_io_u, struct io_u *last_io_u,
+		unsigned long long int len)
+{
+	struct librpma_fio_client_data *ccd = td->io_ops_data;
+	struct client_data *cd = ccd->client_data;
+	size_t io_u_buf_off = IO_U_NEXT_BUF_OFF_CLIENT(cd);
+	size_t send_offset = io_u_buf_off + SEND_OFFSET;
+	size_t recv_offset = io_u_buf_off + RECV_OFFSET;
+	void *send_ptr = cd->io_us_msgs + send_offset;
+	void *recv_ptr = cd->io_us_msgs + recv_offset;
+	GPSPMFlushRequest flush_req = GPSPM_FLUSH_REQUEST__INIT;
+	size_t flush_req_size = 0;
+	int ret;
+
+	/* prepare a response buffer */
+	if ((ret = rpma_recv(ccd->conn, cd->msg_mr, recv_offset, MAX_MSG_SIZE,
+			recv_ptr))) {
+		librpma_td_verror(td, ret, "rpma_recv");
+		return -1;
+	}
+
+	/* prepare a flush message and pack it to a send buffer */
+	flush_req.offset = first_io_u->offset;
+	flush_req.length = len;
+	flush_req.op_context = last_io_u->index;
+	flush_req_size = gpspm_flush_request__get_packed_size(&flush_req);
+	if (flush_req_size > MAX_MSG_SIZE) {
+		log_err(
+			"Packed flush request size is bigger than available send buffer space (%"
+			PRIu64 " > %d\n", flush_req_size, MAX_MSG_SIZE);
+		return -1;
+	}
+	(void) gpspm_flush_request__pack(&flush_req, send_ptr);
+
+	/* send the flush message */
+	if ((ret = rpma_send(ccd->conn, cd->msg_mr, send_offset, flush_req_size,
+			RPMA_F_COMPLETION_ALWAYS, NULL))) {
+		librpma_td_verror(td, ret, "rpma_send");
+		return -1;
+	}
+
+	++ccd->op_send_posted;
+
+	return 0;
+}
+
+static int client_get_io_u_index(struct rpma_completion *cmpl,
+		unsigned int *io_u_index)
+{
+	GPSPMFlushResponse *flush_resp;
+
+	if (cmpl->op != RPMA_OP_RECV)
+		return 0;
+
+	/* unpack a response from the received buffer */
+	flush_resp = gpspm_flush_response__unpack(NULL,
+			cmpl->byte_len, cmpl->op_context);
+	if (flush_resp == NULL) {
+		log_err("Cannot unpack the flush response buffer\n");
+		return -1;
+	}
+
+	memcpy(io_u_index, &flush_resp->op_context, sizeof(*io_u_index));
+
+	gpspm_flush_response__free_unpacked(flush_resp, NULL);
+
+	return 1;
+}
+
+FIO_STATIC struct ioengine_ops ioengine_client = {
+	.name			= "librpma_gpspm_client",
+	.version		= FIO_IOOPS_VERSION,
+	.init			= client_init,
+	.post_init		= client_post_init,
+	.get_file_size		= librpma_fio_client_get_file_size,
+	.open_file		= librpma_fio_file_nop,
+	.queue			= librpma_fio_client_queue,
+	.commit			= librpma_fio_client_commit,
+	.getevents		= librpma_fio_client_getevents,
+	.event			= librpma_fio_client_event,
+	.errdetails		= librpma_fio_client_errdetails,
+	.close_file		= librpma_fio_file_nop,
+	.cleanup		= client_cleanup,
+	.flags			= FIO_DISKLESSIO,
+	.options		= librpma_fio_options,
+	.option_struct_size	= sizeof(struct librpma_fio_options_values),
+};
+
+/* server side implementation */
+
+#define IO_U_BUFF_OFF_SERVER(i) (i * IO_U_BUF_LEN)
+
+struct server_data {
+	/* aligned td->orig_buffer */
+	char *orig_buffer_aligned;
+
+	/* resources for messaging buffer from DRAM allocated by fio */
+	struct rpma_mr_local *msg_mr;
+
+	uint32_t msg_sqe_available; /* # of free SQ slots */
+
+	/* in-memory queues */
+	struct rpma_completion *msgs_queued;
+	uint32_t msg_queued_nr;
+};
+
+static int server_init(struct thread_data *td)
+{
+	struct librpma_fio_server_data *csd;
+	struct server_data *sd;
+	int ret = -1;
+
+	if ((ret = librpma_fio_server_init(td)))
+		return ret;
+
+	csd = td->io_ops_data;
+
+	/* allocate server's data */
+	sd = calloc(1, sizeof(*sd));
+	if (sd == NULL) {
+		td_verror(td, errno, "calloc");
+		goto err_server_cleanup;
+	}
+
+	/* allocate in-memory queue */
+	sd->msgs_queued = calloc(td->o.iodepth, sizeof(*sd->msgs_queued));
+	if (sd->msgs_queued == NULL) {
+		td_verror(td, errno, "calloc");
+		goto err_free_sd;
+	}
+
+	/*
+	 * Assure a single io_u buffer can store both SEND and RECV messages and
+	 * an io_us buffer allocation is page-size-aligned which is required
+	 * to register for RDMA. User-provided values are intentionally ignored.
+	 */
+	td->o.max_bs[DDIR_READ] = IO_U_BUF_LEN;
+	td->o.mem_align = page_size;
+
+	csd->server_data = sd;
+
+	return 0;
+
+err_free_sd:
+	free(sd);
+
+err_server_cleanup:
+	librpma_fio_server_cleanup(td);
+
+	return -1;
+}
+
+static int server_post_init(struct thread_data *td)
+{
+	struct librpma_fio_server_data *csd = td->io_ops_data;
+	struct server_data *sd = csd->server_data;
+	size_t io_us_size;
+	size_t io_u_buflen;
+	int ret;
+
+	/*
+	 * td->orig_buffer is not aligned. The engine requires aligned io_us
+	 * so FIO alignes up the address using the formula below.
+	 */
+	sd->orig_buffer_aligned = PTR_ALIGN(td->orig_buffer, page_mask) +
+			td->o.mem_align;
+
+	/*
+	 * XXX
+	 * Each io_u message buffer contains recv and send messages.
+	 * Aligning each of those buffers may potentially give
+	 * some performance benefits.
+	 */
+	io_u_buflen = td_max_bs(td);
+
+	/* check whether io_u buffer is big enough */
+	if (io_u_buflen < IO_U_BUF_LEN) {
+		log_err(
+			"blocksize too small to accommodate assumed maximal request/response pair size (%" PRIu64 " < %d)\n",
+			io_u_buflen, IO_U_BUF_LEN);
+		return -1;
+	}
+
+	/*
+	 * td->orig_buffer_size beside the space really consumed by io_us
+	 * has paddings which can be omitted for the memory registration.
+	 */
+	io_us_size = (unsigned long long)io_u_buflen *
+			(unsigned long long)td->o.iodepth;
+
+	if ((ret = rpma_mr_reg(csd->peer, sd->orig_buffer_aligned, io_us_size,
+			RPMA_MR_USAGE_SEND | RPMA_MR_USAGE_RECV,
+			&sd->msg_mr))) {
+		librpma_td_verror(td, ret, "rpma_mr_reg");
+		return -1;
+	}
+
+	return 0;
+}
+
+static void server_cleanup(struct thread_data *td)
+{
+	struct librpma_fio_server_data *csd = td->io_ops_data;
+	struct server_data *sd;
+	int ret;
+
+	if (csd == NULL)
+		return;
+
+	sd = csd->server_data;
+
+	if (sd != NULL) {
+		/* rpma_mr_dereg(messaging buffer from DRAM) */
+		if ((ret = rpma_mr_dereg(&sd->msg_mr)))
+			librpma_td_verror(td, ret, "rpma_mr_dereg");
+
+		free(sd->msgs_queued);
+		free(sd);
+	}
+
+	librpma_fio_server_cleanup(td);
+}
+
+static int prepare_connection(struct thread_data *td,
+		struct rpma_conn_req *conn_req)
+{
+	struct librpma_fio_server_data *csd = td->io_ops_data;
+	struct server_data *sd = csd->server_data;
+	int ret;
+	int i;
+
+	/* prepare buffers for a flush requests */
+	sd->msg_sqe_available = td->o.iodepth;
+	for (i = 0; i < td->o.iodepth; i++) {
+		size_t offset_recv_msg = IO_U_BUFF_OFF_SERVER(i) + RECV_OFFSET;
+		if ((ret = rpma_conn_req_recv(conn_req, sd->msg_mr,
+				offset_recv_msg, MAX_MSG_SIZE,
+				(const void *)(uintptr_t)i))) {
+			librpma_td_verror(td, ret, "rpma_conn_req_recv");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int server_open_file(struct thread_data *td, struct fio_file *f)
+{
+	struct librpma_fio_server_data *csd = td->io_ops_data;
+	struct rpma_conn_cfg *cfg = NULL;
+	uint16_t max_msg_num = td->o.iodepth;
+	int ret;
+
+	csd->prepare_connection = prepare_connection;
+
+	/* create a connection configuration object */
+	if ((ret = rpma_conn_cfg_new(&cfg))) {
+		librpma_td_verror(td, ret, "rpma_conn_cfg_new");
+		return -1;
+	}
+
+	/*
+	 * Calculate the required queue sizes where:
+	 * - the send queue (SQ) has to be big enough to accommodate
+	 *   all possible flush requests (SENDs)
+	 * - the receive queue (RQ) has to be big enough to accommodate
+	 *   all flush responses (RECVs)
+	 * - the completion queue (CQ) has to be big enough to accommodate
+	 *   all success and error completions (sq_size + rq_size)
+	 */
+	if ((ret = rpma_conn_cfg_set_sq_size(cfg, max_msg_num))) {
+		librpma_td_verror(td, ret, "rpma_conn_cfg_set_sq_size");
+		goto err_cfg_delete;
+	}
+	if ((ret = rpma_conn_cfg_set_rq_size(cfg, max_msg_num))) {
+		librpma_td_verror(td, ret, "rpma_conn_cfg_set_rq_size");
+		goto err_cfg_delete;
+	}
+	if ((ret = rpma_conn_cfg_set_cq_size(cfg, max_msg_num * 2))) {
+		librpma_td_verror(td, ret, "rpma_conn_cfg_set_cq_size");
+		goto err_cfg_delete;
+	}
+
+	ret = librpma_fio_server_open_file(td, f, cfg);
+
+err_cfg_delete:
+	(void) rpma_conn_cfg_delete(&cfg);
+
+	return ret;
+}
+
+static int server_qe_process(struct thread_data *td,
+		struct rpma_completion *cmpl)
+{
+	struct librpma_fio_server_data *csd = td->io_ops_data;
+	struct server_data *sd = csd->server_data;
+	GPSPMFlushRequest *flush_req;
+	GPSPMFlushResponse flush_resp = GPSPM_FLUSH_RESPONSE__INIT;
+	size_t flush_resp_size = 0;
+	size_t send_buff_offset;
+	size_t recv_buff_offset;
+	size_t io_u_buff_offset;
+	void *send_buff_ptr;
+	void *recv_buff_ptr;
+	void *op_ptr;
+	int msg_index;
+	int ret;
+
+	/* calculate SEND/RECV pair parameters */
+	msg_index = (int)(uintptr_t)cmpl->op_context;
+	io_u_buff_offset = IO_U_BUFF_OFF_SERVER(msg_index);
+	send_buff_offset = io_u_buff_offset + SEND_OFFSET;
+	recv_buff_offset = io_u_buff_offset + RECV_OFFSET;
+	send_buff_ptr = sd->orig_buffer_aligned + send_buff_offset;
+	recv_buff_ptr = sd->orig_buffer_aligned + recv_buff_offset;
+
+	/* unpack a flush request from the received buffer */
+	flush_req = gpspm_flush_request__unpack(NULL, cmpl->byte_len,
+			recv_buff_ptr);
+	if (flush_req == NULL) {
+		log_err("cannot unpack the flush request buffer\n");
+		goto err_terminate;
+	}
+
+	if (IS_NOT_THE_LAST_MESSAGE(flush_req)) {
+		op_ptr = csd->ws_ptr + flush_req->offset;
+		pmem_persist(op_ptr, flush_req->length);
+	} else {
+		/*
+		 * This is the last message - the client is done.
+		 */
+		gpspm_flush_request__free_unpacked(flush_req, NULL);
+		td->done = true;
+		return 0;
+	}
+
+	/* initiate the next receive operation */
+	if ((ret = rpma_recv(csd->conn, sd->msg_mr, recv_buff_offset,
+			MAX_MSG_SIZE,
+			(const void *)(uintptr_t)msg_index))) {
+		librpma_td_verror(td, ret, "rpma_recv");
+		goto err_free_unpacked;
+	}
+
+	/* prepare a flush response and pack it to a send buffer */
+	flush_resp.op_context = flush_req->op_context;
+	flush_resp_size = gpspm_flush_response__get_packed_size(&flush_resp);
+	if (flush_resp_size > MAX_MSG_SIZE) {
+		log_err(
+			"Size of the packed flush response is bigger than the available space of the send buffer (%"
+			PRIu64 " > %i\n", flush_resp_size, MAX_MSG_SIZE);
+		goto err_free_unpacked;
+	}
+
+	(void) gpspm_flush_response__pack(&flush_resp, send_buff_ptr);
+
+	/* send the flush response */
+	if ((ret = rpma_send(csd->conn, sd->msg_mr, send_buff_offset,
+			flush_resp_size, RPMA_F_COMPLETION_ALWAYS, NULL))) {
+		librpma_td_verror(td, ret, "rpma_send");
+		goto err_free_unpacked;
+	}
+	--sd->msg_sqe_available;
+
+	gpspm_flush_request__free_unpacked(flush_req, NULL);
+
+	return 0;
+
+err_free_unpacked:
+	gpspm_flush_request__free_unpacked(flush_req, NULL);
+
+err_terminate:
+	td->terminate = true;
+
+	return -1;
+}
+
+static inline int server_queue_process(struct thread_data *td)
+{
+	struct librpma_fio_server_data *csd = td->io_ops_data;
+	struct server_data *sd = csd->server_data;
+	int ret;
+	int i;
+
+	/* min(# of queue entries, # of SQ entries available) */
+	uint32_t qes_to_process = min(sd->msg_queued_nr, sd->msg_sqe_available);
+	if (qes_to_process == 0)
+		return 0;
+
+	/* process queued completions */
+	for (i = 0; i < qes_to_process; ++i) {
+		if ((ret = server_qe_process(td, &sd->msgs_queued[i])))
+			return ret;
+	}
+
+	/* progress the queue */
+	for (i = 0; i < sd->msg_queued_nr - qes_to_process; ++i) {
+		memcpy(&sd->msgs_queued[i],
+			&sd->msgs_queued[qes_to_process + i],
+			sizeof(sd->msgs_queued[i]));
+	}
+
+	sd->msg_queued_nr -= qes_to_process;
+
+	return 0;
+}
+
+static int server_cmpl_process(struct thread_data *td)
+{
+	struct librpma_fio_server_data *csd = td->io_ops_data;
+	struct server_data *sd = csd->server_data;
+	struct rpma_completion *cmpl = &sd->msgs_queued[sd->msg_queued_nr];
+	int ret;
+
+	ret = rpma_conn_completion_get(csd->conn, cmpl);
+	if (ret == RPMA_E_NO_COMPLETION) {
+		/* lack of completion is not an error */
+		return 0;
+	} else if (ret != 0) {
+		librpma_td_verror(td, ret, "rpma_conn_completion_get");
+		goto err_terminate;
+	}
+
+	/* validate the completion */
+	if (cmpl->op_status != IBV_WC_SUCCESS)
+		goto err_terminate;
+
+	if (cmpl->op == RPMA_OP_RECV)
+		++sd->msg_queued_nr;
+	else if (cmpl->op == RPMA_OP_SEND)
+		++sd->msg_sqe_available;
+
+	return 0;
+
+err_terminate:
+	td->terminate = true;
+
+	return -1;
+}
+
+static enum fio_q_status server_queue(struct thread_data *td, struct io_u *io_u)
+{
+	do {
+		if (server_cmpl_process(td))
+			return FIO_Q_BUSY;
+
+		if (server_queue_process(td))
+			return FIO_Q_BUSY;
+
+	} while (!td->done);
+
+	return FIO_Q_COMPLETED;
+}
+
+FIO_STATIC struct ioengine_ops ioengine_server = {
+	.name			= "librpma_gpspm_server",
+	.version		= FIO_IOOPS_VERSION,
+	.init			= server_init,
+	.post_init		= server_post_init,
+	.open_file		= server_open_file,
+	.close_file		= librpma_fio_server_close_file,
+	.queue			= server_queue,
+	.invalidate		= librpma_fio_file_nop,
+	.cleanup		= server_cleanup,
+	.flags			= FIO_SYNCIO,
+	.options		= librpma_fio_options,
+	.option_struct_size	= sizeof(struct librpma_fio_options_values),
+};
+
+/* register both engines */
+
+static void fio_init fio_librpma_gpspm_register(void)
+{
+	register_ioengine(&ioengine_client);
+	register_ioengine(&ioengine_server);
+}
+
+static void fio_exit fio_librpma_gpspm_unregister(void)
+{
+	unregister_ioengine(&ioengine_client);
+	unregister_ioengine(&ioengine_server);
+}
diff --git a/engines/librpma_gpspm_flush.pb-c.c b/engines/librpma_gpspm_flush.pb-c.c
new file mode 100644
index 00000000..3ff24756
--- /dev/null
+++ b/engines/librpma_gpspm_flush.pb-c.c
@@ -0,0 +1,214 @@
+/*
+ * Copyright 2020, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License,
+ * version 2 as published by the Free Software Foundation..
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+/* Generated by the protocol buffer compiler. DO NOT EDIT! */
+/* Generated from: librpma_gpspm_flush.proto */
+
+/* Do not generate deprecated warnings for self */
+#ifndef PROTOBUF_C__NO_DEPRECATED
+#define PROTOBUF_C__NO_DEPRECATED
+#endif
+
+#include "librpma_gpspm_flush.pb-c.h"
+void   gpspm_flush_request__init
+                     (GPSPMFlushRequest         *message)
+{
+  static const GPSPMFlushRequest init_value = GPSPM_FLUSH_REQUEST__INIT;
+  *message = init_value;
+}
+size_t gpspm_flush_request__get_packed_size
+                     (const GPSPMFlushRequest *message)
+{
+  assert(message->base.descriptor == &gpspm_flush_request__descriptor);
+  return protobuf_c_message_get_packed_size ((const ProtobufCMessage*)(message));
+}
+size_t gpspm_flush_request__pack
+                     (const GPSPMFlushRequest *message,
+                      uint8_t       *out)
+{
+  assert(message->base.descriptor == &gpspm_flush_request__descriptor);
+  return protobuf_c_message_pack ((const ProtobufCMessage*)message, out);
+}
+size_t gpspm_flush_request__pack_to_buffer
+                     (const GPSPMFlushRequest *message,
+                      ProtobufCBuffer *buffer)
+{
+  assert(message->base.descriptor == &gpspm_flush_request__descriptor);
+  return protobuf_c_message_pack_to_buffer ((const ProtobufCMessage*)message, buffer);
+}
+GPSPMFlushRequest *
+       gpspm_flush_request__unpack
+                     (ProtobufCAllocator  *allocator,
+                      size_t               len,
+                      const uint8_t       *data)
+{
+  return (GPSPMFlushRequest *)
+     protobuf_c_message_unpack (&gpspm_flush_request__descriptor,
+                                allocator, len, data);
+}
+void   gpspm_flush_request__free_unpacked
+                     (GPSPMFlushRequest *message,
+                      ProtobufCAllocator *allocator)
+{
+  if(!message)
+    return;
+  assert(message->base.descriptor == &gpspm_flush_request__descriptor);
+  protobuf_c_message_free_unpacked ((ProtobufCMessage*)message, allocator);
+}
+void   gpspm_flush_response__init
+                     (GPSPMFlushResponse         *message)
+{
+  static const GPSPMFlushResponse init_value = GPSPM_FLUSH_RESPONSE__INIT;
+  *message = init_value;
+}
+size_t gpspm_flush_response__get_packed_size
+                     (const GPSPMFlushResponse *message)
+{
+  assert(message->base.descriptor == &gpspm_flush_response__descriptor);
+  return protobuf_c_message_get_packed_size ((const ProtobufCMessage*)(message));
+}
+size_t gpspm_flush_response__pack
+                     (const GPSPMFlushResponse *message,
+                      uint8_t       *out)
+{
+  assert(message->base.descriptor == &gpspm_flush_response__descriptor);
+  return protobuf_c_message_pack ((const ProtobufCMessage*)message, out);
+}
+size_t gpspm_flush_response__pack_to_buffer
+                     (const GPSPMFlushResponse *message,
+                      ProtobufCBuffer *buffer)
+{
+  assert(message->base.descriptor == &gpspm_flush_response__descriptor);
+  return protobuf_c_message_pack_to_buffer ((const ProtobufCMessage*)message, buffer);
+}
+GPSPMFlushResponse *
+       gpspm_flush_response__unpack
+                     (ProtobufCAllocator  *allocator,
+                      size_t               len,
+                      const uint8_t       *data)
+{
+  return (GPSPMFlushResponse *)
+     protobuf_c_message_unpack (&gpspm_flush_response__descriptor,
+                                allocator, len, data);
+}
+void   gpspm_flush_response__free_unpacked
+                     (GPSPMFlushResponse *message,
+                      ProtobufCAllocator *allocator)
+{
+  if(!message)
+    return;
+  assert(message->base.descriptor == &gpspm_flush_response__descriptor);
+  protobuf_c_message_free_unpacked ((ProtobufCMessage*)message, allocator);
+}
+static const ProtobufCFieldDescriptor gpspm_flush_request__field_descriptors[3] =
+{
+  {
+    "offset",
+    1,
+    PROTOBUF_C_LABEL_REQUIRED,
+    PROTOBUF_C_TYPE_FIXED64,
+    0,   /* quantifier_offset */
+    offsetof(GPSPMFlushRequest, offset),
+    NULL,
+    NULL,
+    0,             /* flags */
+    0,NULL,NULL    /* reserved1,reserved2, etc */
+  },
+  {
+    "length",
+    2,
+    PROTOBUF_C_LABEL_REQUIRED,
+    PROTOBUF_C_TYPE_FIXED64,
+    0,   /* quantifier_offset */
+    offsetof(GPSPMFlushRequest, length),
+    NULL,
+    NULL,
+    0,             /* flags */
+    0,NULL,NULL    /* reserved1,reserved2, etc */
+  },
+  {
+    "op_context",
+    3,
+    PROTOBUF_C_LABEL_REQUIRED,
+    PROTOBUF_C_TYPE_FIXED64,
+    0,   /* quantifier_offset */
+    offsetof(GPSPMFlushRequest, op_context),
+    NULL,
+    NULL,
+    0,             /* flags */
+    0,NULL,NULL    /* reserved1,reserved2, etc */
+  },
+};
+static const unsigned gpspm_flush_request__field_indices_by_name[] = {
+  1,   /* field[1] = length */
+  0,   /* field[0] = offset */
+  2,   /* field[2] = op_context */
+};
+static const ProtobufCIntRange gpspm_flush_request__number_ranges[1 + 1] =
+{
+  { 1, 0 },
+  { 0, 3 }
+};
+const ProtobufCMessageDescriptor gpspm_flush_request__descriptor =
+{
+  PROTOBUF_C__MESSAGE_DESCRIPTOR_MAGIC,
+  "GPSPM_flush_request",
+  "GPSPMFlushRequest",
+  "GPSPMFlushRequest",
+  "",
+  sizeof(GPSPMFlushRequest),
+  3,
+  gpspm_flush_request__field_descriptors,
+  gpspm_flush_request__field_indices_by_name,
+  1,  gpspm_flush_request__number_ranges,
+  (ProtobufCMessageInit) gpspm_flush_request__init,
+  NULL,NULL,NULL    /* reserved[123] */
+};
+static const ProtobufCFieldDescriptor gpspm_flush_response__field_descriptors[1] =
+{
+  {
+    "op_context",
+    1,
+    PROTOBUF_C_LABEL_REQUIRED,
+    PROTOBUF_C_TYPE_FIXED64,
+    0,   /* quantifier_offset */
+    offsetof(GPSPMFlushResponse, op_context),
+    NULL,
+    NULL,
+    0,             /* flags */
+    0,NULL,NULL    /* reserved1,reserved2, etc */
+  },
+};
+static const unsigned gpspm_flush_response__field_indices_by_name[] = {
+  0,   /* field[0] = op_context */
+};
+static const ProtobufCIntRange gpspm_flush_response__number_ranges[1 + 1] =
+{
+  { 1, 0 },
+  { 0, 1 }
+};
+const ProtobufCMessageDescriptor gpspm_flush_response__descriptor =
+{
+  PROTOBUF_C__MESSAGE_DESCRIPTOR_MAGIC,
+  "GPSPM_flush_response",
+  "GPSPMFlushResponse",
+  "GPSPMFlushResponse",
+  "",
+  sizeof(GPSPMFlushResponse),
+  1,
+  gpspm_flush_response__field_descriptors,
+  gpspm_flush_response__field_indices_by_name,
+  1,  gpspm_flush_response__number_ranges,
+  (ProtobufCMessageInit) gpspm_flush_response__init,
+  NULL,NULL,NULL    /* reserved[123] */
+};
diff --git a/engines/librpma_gpspm_flush.pb-c.h b/engines/librpma_gpspm_flush.pb-c.h
new file mode 100644
index 00000000..ad475a95
--- /dev/null
+++ b/engines/librpma_gpspm_flush.pb-c.h
@@ -0,0 +1,120 @@
+/*
+ * Copyright 2020, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License,
+ * version 2 as published by the Free Software Foundation..
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+/* Generated by the protocol buffer compiler. DO NOT EDIT! */
+/* Generated from: librpma_gpspm_flush.proto */
+
+#ifndef PROTOBUF_C_GPSPM_5fflush_2eproto__INCLUDED
+#define PROTOBUF_C_GPSPM_5fflush_2eproto__INCLUDED
+
+#include <protobuf-c/protobuf-c.h>
+
+PROTOBUF_C__BEGIN_DECLS
+
+#if PROTOBUF_C_VERSION_NUMBER < 1000000
+# error This file was generated by a newer version of protoc-c which is incompatible with your libprotobuf-c headers. Please update your headers.
+#elif 1003003 < PROTOBUF_C_MIN_COMPILER_VERSION
+# error This file was generated by an older version of protoc-c which is incompatible with your libprotobuf-c headers. Please regenerate this file with a newer version of protoc-c.
+#endif
+
+
+typedef struct _GPSPMFlushRequest GPSPMFlushRequest;
+typedef struct _GPSPMFlushResponse GPSPMFlushResponse;
+
+
+/* --- enums --- */
+
+
+/* --- messages --- */
+
+struct  _GPSPMFlushRequest
+{
+  ProtobufCMessage base;
+  uint64_t offset;
+  uint64_t length;
+  uint64_t op_context;
+};
+#define GPSPM_FLUSH_REQUEST__INIT \
+ { PROTOBUF_C_MESSAGE_INIT (&gpspm_flush_request__descriptor) \
+    , 0, 0, 0 }
+
+
+struct  _GPSPMFlushResponse
+{
+  ProtobufCMessage base;
+  uint64_t op_context;
+};
+#define GPSPM_FLUSH_RESPONSE__INIT \
+ { PROTOBUF_C_MESSAGE_INIT (&gpspm_flush_response__descriptor) \
+    , 0 }
+
+
+/* GPSPMFlushRequest methods */
+void   gpspm_flush_request__init
+                     (GPSPMFlushRequest         *message);
+size_t gpspm_flush_request__get_packed_size
+                     (const GPSPMFlushRequest   *message);
+size_t gpspm_flush_request__pack
+                     (const GPSPMFlushRequest   *message,
+                      uint8_t             *out);
+size_t gpspm_flush_request__pack_to_buffer
+                     (const GPSPMFlushRequest   *message,
+                      ProtobufCBuffer     *buffer);
+GPSPMFlushRequest *
+       gpspm_flush_request__unpack
+                     (ProtobufCAllocator  *allocator,
+                      size_t               len,
+                      const uint8_t       *data);
+void   gpspm_flush_request__free_unpacked
+                     (GPSPMFlushRequest *message,
+                      ProtobufCAllocator *allocator);
+/* GPSPMFlushResponse methods */
+void   gpspm_flush_response__init
+                     (GPSPMFlushResponse         *message);
+size_t gpspm_flush_response__get_packed_size
+                     (const GPSPMFlushResponse   *message);
+size_t gpspm_flush_response__pack
+                     (const GPSPMFlushResponse   *message,
+                      uint8_t             *out);
+size_t gpspm_flush_response__pack_to_buffer
+                     (const GPSPMFlushResponse   *message,
+                      ProtobufCBuffer     *buffer);
+GPSPMFlushResponse *
+       gpspm_flush_response__unpack
+                     (ProtobufCAllocator  *allocator,
+                      size_t               len,
+                      const uint8_t       *data);
+void   gpspm_flush_response__free_unpacked
+                     (GPSPMFlushResponse *message,
+                      ProtobufCAllocator *allocator);
+/* --- per-message closures --- */
+
+typedef void (*GPSPMFlushRequest_Closure)
+                 (const GPSPMFlushRequest *message,
+                  void *closure_data);
+typedef void (*GPSPMFlushResponse_Closure)
+                 (const GPSPMFlushResponse *message,
+                  void *closure_data);
+
+/* --- services --- */
+
+
+/* --- descriptors --- */
+
+extern const ProtobufCMessageDescriptor gpspm_flush_request__descriptor;
+extern const ProtobufCMessageDescriptor gpspm_flush_response__descriptor;
+
+PROTOBUF_C__END_DECLS
+
+
+#endif  /* PROTOBUF_C_GPSPM_5fflush_2eproto__INCLUDED */
diff --git a/engines/librpma_gpspm_flush.proto b/engines/librpma_gpspm_flush.proto
new file mode 100644
index 00000000..91765a7f
--- /dev/null
+++ b/engines/librpma_gpspm_flush.proto
@@ -0,0 +1,15 @@
+syntax = "proto2";
+
+message GPSPM_flush_request {
+    /* an offset of a region to be flushed within its memory registration */
+    required fixed64 offset = 1;
+    /* a length of a region to be flushed */
+    required fixed64 length = 2;
+    /* a user-defined operation context */
+    required fixed64 op_context = 3;
+}
+
+message GPSPM_flush_response {
+    /* the operation context of a completed request */
+    required fixed64 op_context = 1;
+}
diff --git a/eta.c b/eta.c
index 97843012..db13cb18 100644
--- a/eta.c
+++ b/eta.c
@@ -331,7 +331,7 @@ static void calc_rate(int unified_rw_rep, unsigned long mtime,
 		else
 			this_rate = 0;
 
-		if (unified_rw_rep) {
+		if (unified_rw_rep == UNIFIED_MIXED) {
 			rate[i] = 0;
 			rate[0] += this_rate;
 		} else
@@ -356,7 +356,7 @@ static void calc_iops(int unified_rw_rep, unsigned long mtime,
 		else
 			this_iops = 0;
 
-		if (unified_rw_rep) {
+		if (unified_rw_rep == UNIFIED_MIXED) {
 			iops[i] = 0;
 			iops[0] += this_iops;
 		} else
diff --git a/examples/librpma_apm-client.fio b/examples/librpma_apm-client.fio
new file mode 100644
index 00000000..82a5d20c
--- /dev/null
+++ b/examples/librpma_apm-client.fio
@@ -0,0 +1,24 @@
+# Example of the librpma_apm_client job
+
+[global]
+ioengine=librpma_apm_client
+create_serialize=0 # (required) forces specific initiation sequence
+serverip=[serverip] #IP address the server is listening on
+port=7204 # port(s) the server will listen on, <port; port + numjobs - 1> will be used
+thread
+
+# The client will get a remote memory region description after establishing
+# a connection.
+
+[client]
+numjobs=1 # number of parallel connections
+group_reporting=1
+sync=1 # 1 is the best for latency measurements, 0 for bandwidth
+iodepth=2 # total number of ious
+iodepth_batch_submit=1 # number of ious to be submitted at once
+rw=write # read/write/randread/randwrite/readwrite/rw
+rwmixread=70 # % of a mixed workload that should be reads
+blocksize=4KiB
+ramp_time=15s # gives some time to stabilize the workload
+time_based
+runtime=60s # run the workload for the specified period of time
diff --git a/examples/librpma_apm-server.fio b/examples/librpma_apm-server.fio
new file mode 100644
index 00000000..062b5215
--- /dev/null
+++ b/examples/librpma_apm-server.fio
@@ -0,0 +1,26 @@
+# Example of the librpma_apm_server job
+
+[global]
+ioengine=librpma_apm_server
+create_serialize=0 # (required) forces specific initiation sequence
+kb_base=1000 # turn on the straight units handling (non-compatibility mode)
+serverip=[serverip] # IP address to listen on
+port=7204 # port(s) the server jobs will listen on, ports <port; port + numjobs - 1> will be used
+thread
+
+# The server side spawns one thread for each expected connection from
+# the client-side, opens and registers the range dedicated for this thread
+# (a workspace) from the provided memory.
+# Each of the server threads accepts a connection on the dedicated port
+# (different for each and every working thread) and waits for it to end up,
+# and closes itself.
+
+[server]
+# set to 1 (true) ONLY when Direct Write to PMem from the remote host is possible
+# (https://pmem.io/rpma/documentation/basic-direct-write-to-pmem.html)
+direct_write_to_pmem=0
+
+numjobs=1 # number of expected incomming connections
+size=100MiB # size of workspace for a single connection
+filename=malloc # device dax or an existing fsdax file or "malloc" for allocation from DRAM
+# filename=/dev/dax1.0
diff --git a/examples/librpma_gpspm-client.fio b/examples/librpma_gpspm-client.fio
new file mode 100644
index 00000000..843382df
--- /dev/null
+++ b/examples/librpma_gpspm-client.fio
@@ -0,0 +1,23 @@
+# Example of the librpma_gpspm_client job
+
+[global]
+ioengine=librpma_gpspm_client
+create_serialize=0 # (required) forces specific initiation sequence
+serverip=[serverip] #IP address the server is listening on
+port=7204 # port(s) the server will listen on, <port; port + numjobs - 1> will be used
+thread
+
+# The client will get a remote memory region description after establishing
+# a connection.
+
+[client]
+numjobs=1 # number of parallel connections
+group_reporting=1
+sync=1 # 1 is the best for latency measurements, 0 for bandwidth
+iodepth=2 # total number of ious
+iodepth_batch_submit=1 # number of ious to be submitted at once
+rw=write # write/randwrite
+blocksize=4KiB
+ramp_time=15s # gives some time to stabilize the workload
+time_based
+runtime=60s # run the workload for the specified period of time
diff --git a/examples/librpma_gpspm-server.fio b/examples/librpma_gpspm-server.fio
new file mode 100644
index 00000000..d618f2db
--- /dev/null
+++ b/examples/librpma_gpspm-server.fio
@@ -0,0 +1,31 @@
+# Example of the librpma_gpspm_server job
+
+[global]
+ioengine=librpma_gpspm_server
+create_serialize=0 # (required) forces specific initiation sequence
+kb_base=1000 # turn on the straight units handling (non-compatibility mode)
+serverip=[serverip] #IP address to listen on
+port=7204 # port(s) the server jobs will listen on, ports <port; port + numjobs - 1> will be used
+thread
+
+# The server side spawns one thread for each expected connection from
+# the client-side, opens and registers the range dedicated for this thread
+# (a workspace) from the provided memory.
+# Each of the server threads accepts a connection on the dedicated port
+# (different for each and every working thread), accepts and executes flush
+# requests, and sends back a flush response for each of the requests.
+# When the client is done it sends the termination notice to the server's thread.
+
+[server]
+# set to 1 (true) ONLY when Direct Write to PMem from the remote host is possible
+# (https://pmem.io/rpma/documentation/basic-direct-write-to-pmem.html)
+direct_write_to_pmem=0
+numjobs=1 # number of expected incomming connections
+iodepth=2 # number of parallel GPSPM requests
+size=100MiB # size of workspace for a single connection
+filename=malloc # device dax or an existing fsdax file or "malloc" for allocation from DRAM
+# filename=/dev/dax1.0
+
+# The client will terminate the server when the client will end up its job.
+time_based
+runtime=365d
diff --git a/fio.1 b/fio.1
index 27cf2f15..ad4a662b 100644
--- a/fio.1
+++ b/fio.1
@@ -924,10 +924,32 @@ behaves in a similar fashion, except it sends the same offset 8 number of
 times before generating a new offset.
 .RE
 .TP
-.BI unified_rw_reporting \fR=\fPbool
+.BI unified_rw_reporting \fR=\fPstr
 Fio normally reports statistics on a per data direction basis, meaning that
-reads, writes, and trims are accounted and reported separately. If this
-option is set fio sums the results and report them as "mixed" instead.
+reads, writes, and trims are accounted and reported separately. This option
+determines whether fio reports the results normally, summed together, or as
+both options.
+Accepted values are:
+.RS
+.TP
+.B none
+Normal statistics reporting.
+.TP
+.B mixed
+Statistics are summed per data direction and reported together.
+.TP
+.B both
+Statistics are reported normally, followed by the mixed statistics.
+.TP
+.B 0
+Backward-compatible alias for \fBnone\fR.
+.TP
+.B 1
+Backward-compatible alias for \fBmixed\fR.
+.TP
+.B 2
+Alias for \fBboth\fR.
+.RE
 .TP
 .BI randrepeat \fR=\fPbool
 Seed the random number generator used for random I/O patterns in a
@@ -1956,7 +1978,7 @@ The TCP or UDP port to bind to or connect to. If this is used with
 this will be the starting port number since fio will use a range of
 ports.
 .TP
-.BI (rdma)port
+.BI (rdma, librpma_*)port
 The port to use for RDMA-CM communication. This should be the same
 value on the client and the server side.
 .TP
@@ -1965,6 +1987,12 @@ The hostname or IP address to use for TCP, UDP or RDMA-CM based I/O.
 If the job is a TCP listener or UDP reader, the hostname is not used
 and must be omitted unless it is a valid UDP multicast address.
 .TP
+.BI (librpma_*)serverip \fR=\fPstr
+The IP address to be used for RDMA-CM based I/O.
+.TP
+.BI (librpma_*_server)direct_write_to_pmem \fR=\fPbool
+Set to 1 only when Direct Write to PMem from the remote host is possible. Otherwise, set to 0.
+.TP
 .BI (netsplice,net)interface \fR=\fPstr
 The IP address of the network interface used to send or receive UDP
 multicast.
diff --git a/optgroup.c b/optgroup.c
index 4cdea71f..15a16229 100644
--- a/optgroup.c
+++ b/optgroup.c
@@ -141,6 +141,10 @@ static const struct opt_group fio_opt_cat_groups[] = {
 		.name	= "RDMA I/O engine", /* rdma */
 		.mask	= FIO_OPT_G_RDMA,
 	},
+	{
+		.name	= "librpma I/O engines", /* librpma_apm && librpma_gpspm */
+		.mask	= FIO_OPT_G_LIBRPMA,
+	},
 	{
 		.name	= "libaio I/O engine", /* libaio */
 		.mask	= FIO_OPT_G_LIBAIO,
diff --git a/optgroup.h b/optgroup.h
index 25b7fec1..ff748629 100644
--- a/optgroup.h
+++ b/optgroup.h
@@ -52,6 +52,7 @@ enum opt_category_group {
 	__FIO_OPT_G_E4DEFRAG,
 	__FIO_OPT_G_NETIO,
 	__FIO_OPT_G_RDMA,
+	__FIO_OPT_G_LIBRPMA,
 	__FIO_OPT_G_LIBAIO,
 	__FIO_OPT_G_ACT,
 	__FIO_OPT_G_LATPROF,
@@ -95,6 +96,7 @@ enum opt_category_group {
 	FIO_OPT_G_E4DEFRAG	= (1ULL << __FIO_OPT_G_E4DEFRAG),
 	FIO_OPT_G_NETIO		= (1ULL << __FIO_OPT_G_NETIO),
 	FIO_OPT_G_RDMA		= (1ULL << __FIO_OPT_G_RDMA),
+	FIO_OPT_G_LIBRPMA	= (1ULL << __FIO_OPT_G_LIBRPMA),
 	FIO_OPT_G_LIBAIO	= (1ULL << __FIO_OPT_G_LIBAIO),
 	FIO_OPT_G_ACT		= (1ULL << __FIO_OPT_G_ACT),
 	FIO_OPT_G_LATPROF	= (1ULL << __FIO_OPT_G_LATPROF),
diff --git a/options.c b/options.c
index 151e7a7e..ddabaa82 100644
--- a/options.c
+++ b/options.c
@@ -1945,6 +1945,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "RDMA IO engine",
 			  },
 #endif
+#ifdef CONFIG_LIBRPMA_APM
+			  { .ival = "librpma_apm",
+			    .help = "librpma IO engine in APM mode",
+			  },
+#endif
+#ifdef CONFIG_LIBRPMA_GPSPM
+			  { .ival = "librpma_gpspm",
+			    .help = "librpma IO engine in GPSPM mode",
+			  },
+#endif
 #ifdef CONFIG_LINUX_EXT4_MOVE_EXTENT
 			  { .ival = "e4defrag",
 			    .help = "ext4 defrag engine",
@@ -4623,12 +4633,39 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "unified_rw_reporting",
 		.lname	= "Unified RW Reporting",
-		.type	= FIO_OPT_BOOL,
+		.type	= FIO_OPT_STR,
 		.off1	= offsetof(struct thread_options, unified_rw_rep),
 		.help	= "Unify reporting across data direction",
-		.def	= "0",
+		.def	= "none",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_INVALID,
+		.posval	= {
+			  { .ival = "none",
+			    .oval = UNIFIED_SPLIT,
+			    .help = "Normal statistics reporting",
+			  },
+			  { .ival = "mixed",
+			    .oval = UNIFIED_MIXED,
+			    .help = "Statistics are summed per data direction and reported together",
+			  },
+			  { .ival = "both",
+			    .oval = UNIFIED_BOTH,
+			    .help = "Statistics are reported normally, followed by the mixed statistics"
+			  },
+			  /* Compatibility with former boolean values */
+			  { .ival = "0",
+			    .oval = UNIFIED_SPLIT,
+			    .help = "Alias for 'none'",
+			  },
+			  { .ival = "1",
+			    .oval = UNIFIED_MIXED,
+			    .help = "Alias for 'mixed'",
+			  },
+			  { .ival = "2",
+			    .oval = UNIFIED_BOTH,
+			    .help = "Alias for 'both'",
+			  },
+		},
 	},
 	{
 		.name	= "continue_on_error",
diff --git a/stat.c b/stat.c
index b7237953..b7222f46 100644
--- a/stat.c
+++ b/stat.c
@@ -282,6 +282,46 @@ bool calc_lat(struct io_stat *is, unsigned long long *min,
 	return true;
 }
 
+void show_mixed_group_stats(struct group_run_stats *rs, struct buf_output *out) 
+{
+	char *io, *agg, *min, *max;
+	char *ioalt, *aggalt, *minalt, *maxalt;
+	uint64_t io_mix = 0, agg_mix = 0, min_mix = -1, max_mix = 0, min_run = -1, max_run = 0;
+	int i;
+	const int i2p = is_power_of_2(rs->kb_base);
+
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		if (!rs->max_run[i])
+			continue;
+		io_mix += rs->iobytes[i];
+		agg_mix += rs->agg[i];
+		min_mix = min_mix < rs->min_bw[i] ? min_mix : rs->min_bw[i];
+		max_mix = max_mix > rs->max_bw[i] ? max_mix : rs->max_bw[i];
+		min_run = min_run < rs->min_run[i] ? min_run : rs->min_run[i];
+		max_run = max_run > rs->max_run[i] ? max_run : rs->max_run[i];
+	}
+	io = num2str(io_mix, rs->sig_figs, 1, i2p, N2S_BYTE);
+	ioalt = num2str(io_mix, rs->sig_figs, 1, !i2p, N2S_BYTE);
+	agg = num2str(agg_mix, rs->sig_figs, 1, i2p, rs->unit_base);
+	aggalt = num2str(agg_mix, rs->sig_figs, 1, !i2p, rs->unit_base);
+	min = num2str(min_mix, rs->sig_figs, 1, i2p, rs->unit_base);
+	minalt = num2str(min_mix, rs->sig_figs, 1, !i2p, rs->unit_base);
+	max = num2str(max_mix, rs->sig_figs, 1, i2p, rs->unit_base);
+	maxalt = num2str(max_mix, rs->sig_figs, 1, !i2p, rs->unit_base);
+	log_buf(out, "  MIXED: bw=%s (%s), %s-%s (%s-%s), io=%s (%s), run=%llu-%llumsec\n",
+			agg, aggalt, min, max, minalt, maxalt, io, ioalt,
+			(unsigned long long) min_run,
+			(unsigned long long) max_run);
+	free(io);
+	free(agg);
+	free(min);
+	free(max);
+	free(ioalt);
+	free(aggalt);
+	free(minalt);
+	free(maxalt);
+}
+
 void show_group_stats(struct group_run_stats *rs, struct buf_output *out)
 {
 	char *io, *agg, *min, *max;
@@ -306,7 +346,7 @@ void show_group_stats(struct group_run_stats *rs, struct buf_output *out)
 		max = num2str(rs->max_bw[i], rs->sig_figs, 1, i2p, rs->unit_base);
 		maxalt = num2str(rs->max_bw[i], rs->sig_figs, 1, !i2p, rs->unit_base);
 		log_buf(out, "%s: bw=%s (%s), %s-%s (%s-%s), io=%s (%s), run=%llu-%llumsec\n",
-				rs->unified_rw_rep ? "  MIXED" : str[i],
+				(rs->unified_rw_rep == UNIFIED_MIXED) ? "  MIXED" : str[i],
 				agg, aggalt, min, max, minalt, maxalt, io, ioalt,
 				(unsigned long long) rs->min_run[i],
 				(unsigned long long) rs->max_run[i]);
@@ -320,6 +360,10 @@ void show_group_stats(struct group_run_stats *rs, struct buf_output *out)
 		free(minalt);
 		free(maxalt);
 	}
+	
+	/* Need to aggregate statisitics to show mixed values */
+	if (rs->unified_rw_rep == UNIFIED_BOTH) 
+		show_mixed_group_stats(rs, out);
 }
 
 void stat_calc_dist(uint64_t *map, unsigned long total, double *io_u_dist)
@@ -426,6 +470,168 @@ static double convert_agg_kbytes_percent(struct group_run_stats *rs, int ddir, i
 	return p_of_agg;
 }
 
+static void show_mixed_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
+			     struct buf_output *out)
+{
+	unsigned long runt;
+	unsigned long long min, max, bw, iops;
+	double mean, dev;
+	char *io_p, *bw_p, *bw_p_alt, *iops_p, *post_st = NULL;
+	struct thread_stat *ts_lcl;
+
+	int i2p;
+	int ddir = 0, i;
+
+	/* Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and Trims (ddir = 2) */
+	ts_lcl = malloc(sizeof(struct thread_stat));
+	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
+	ts_lcl->unified_rw_rep = UNIFIED_MIXED;               /* calculate mixed stats  */
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		ts_lcl->clat_stat[i].min_val = ULONG_MAX;
+		ts_lcl->slat_stat[i].min_val = ULONG_MAX;
+		ts_lcl->lat_stat[i].min_val = ULONG_MAX;
+		ts_lcl->bw_stat[i].min_val = ULONG_MAX;
+		ts_lcl->iops_stat[i].min_val = ULONG_MAX;
+		ts_lcl->clat_high_prio_stat[i].min_val = ULONG_MAX;
+		ts_lcl->clat_low_prio_stat[i].min_val = ULONG_MAX;
+	}
+	ts_lcl->sync_stat.min_val = ULONG_MAX;
+
+	sum_thread_stats(ts_lcl, ts, 1);
+
+	assert(ddir_rw(ddir));
+
+	if (!ts_lcl->runtime[ddir])
+		return;
+
+	i2p = is_power_of_2(rs->kb_base);
+	runt = ts_lcl->runtime[ddir];
+
+	bw = (1000 * ts_lcl->io_bytes[ddir]) / runt;
+	io_p = num2str(ts_lcl->io_bytes[ddir], ts->sig_figs, 1, i2p, N2S_BYTE);
+	bw_p = num2str(bw, ts->sig_figs, 1, i2p, ts->unit_base);
+	bw_p_alt = num2str(bw, ts->sig_figs, 1, !i2p, ts->unit_base);
+
+	iops = (1000 * ts_lcl->total_io_u[ddir]) / runt;
+	iops_p = num2str(iops, ts->sig_figs, 1, 0, N2S_NONE);
+
+	log_buf(out, "  mixed: IOPS=%s, BW=%s (%s)(%s/%llumsec)%s\n",
+			iops_p, bw_p, bw_p_alt, io_p,
+			(unsigned long long) ts_lcl->runtime[ddir],
+			post_st ? : "");
+
+	free(post_st);
+	free(io_p);
+	free(bw_p);
+	free(bw_p_alt);
+	free(iops_p);
+
+	if (calc_lat(&ts_lcl->slat_stat[ddir], &min, &max, &mean, &dev))
+		display_lat("slat", min, max, mean, dev, out);
+	if (calc_lat(&ts_lcl->clat_stat[ddir], &min, &max, &mean, &dev))
+		display_lat("clat", min, max, mean, dev, out);
+	if (calc_lat(&ts_lcl->lat_stat[ddir], &min, &max, &mean, &dev))
+		display_lat(" lat", min, max, mean, dev, out);
+	if (calc_lat(&ts_lcl->clat_high_prio_stat[ddir], &min, &max, &mean, &dev)) {
+		display_lat(ts_lcl->lat_percentiles ? "high prio_lat" : "high prio_clat",
+				min, max, mean, dev, out);
+		if (calc_lat(&ts_lcl->clat_low_prio_stat[ddir], &min, &max, &mean, &dev))
+			display_lat(ts_lcl->lat_percentiles ? "low prio_lat" : "low prio_clat",
+					min, max, mean, dev, out);
+	}
+
+	if (ts->slat_percentiles && ts_lcl->slat_stat[ddir].samples > 0)
+		show_clat_percentiles(ts_lcl->io_u_plat[FIO_SLAT][ddir],
+				ts_lcl->slat_stat[ddir].samples,
+				ts->percentile_list,
+				ts->percentile_precision, "slat", out);
+	if (ts->clat_percentiles && ts_lcl->clat_stat[ddir].samples > 0)
+		show_clat_percentiles(ts_lcl->io_u_plat[FIO_CLAT][ddir],
+				ts_lcl->clat_stat[ddir].samples,
+				ts->percentile_list,
+				ts->percentile_precision, "clat", out);
+	if (ts->lat_percentiles && ts_lcl->lat_stat[ddir].samples > 0)
+		show_clat_percentiles(ts_lcl->io_u_plat[FIO_LAT][ddir],
+				ts_lcl->lat_stat[ddir].samples,
+				ts->percentile_list,
+				ts->percentile_precision, "lat", out);
+
+	if (ts->clat_percentiles || ts->lat_percentiles) {
+		const char *name = ts->lat_percentiles ? "lat" : "clat";
+		char prio_name[32];
+		uint64_t samples;
+
+		if (ts->lat_percentiles)
+			samples = ts_lcl->lat_stat[ddir].samples;
+		else
+			samples = ts_lcl->clat_stat[ddir].samples;
+
+		/* Only print this if some high and low priority stats were collected */
+		if (ts_lcl->clat_high_prio_stat[ddir].samples > 0 &&
+				ts_lcl->clat_low_prio_stat[ddir].samples > 0)
+		{
+			sprintf(prio_name, "high prio (%.2f%%) %s",
+					100. * (double) ts_lcl->clat_high_prio_stat[ddir].samples / (double) samples,
+					name);
+			show_clat_percentiles(ts_lcl->io_u_plat_high_prio[ddir],
+					ts_lcl->clat_high_prio_stat[ddir].samples,
+					ts->percentile_list,
+					ts->percentile_precision, prio_name, out);
+
+			sprintf(prio_name, "low prio (%.2f%%) %s",
+					100. * (double) ts_lcl->clat_low_prio_stat[ddir].samples / (double) samples,
+					name);
+			show_clat_percentiles(ts_lcl->io_u_plat_low_prio[ddir],
+					ts_lcl->clat_low_prio_stat[ddir].samples,
+					ts->percentile_list,
+					ts->percentile_precision, prio_name, out);
+		}
+	}
+
+	if (calc_lat(&ts_lcl->bw_stat[ddir], &min, &max, &mean, &dev)) {
+		double p_of_agg = 100.0, fkb_base = (double)rs->kb_base;
+		const char *bw_str;
+
+		if ((rs->unit_base == 1) && i2p)
+			bw_str = "Kibit";
+		else if (rs->unit_base == 1)
+			bw_str = "kbit";
+		else if (i2p)
+			bw_str = "KiB";
+		else
+			bw_str = "kB";
+
+		p_of_agg = convert_agg_kbytes_percent(rs, ddir, mean);
+
+		if (rs->unit_base == 1) {
+			min *= 8.0;
+			max *= 8.0;
+			mean *= 8.0;
+			dev *= 8.0;
+		}
+
+		if (mean > fkb_base * fkb_base) {
+			min /= fkb_base;
+			max /= fkb_base;
+			mean /= fkb_base;
+			dev /= fkb_base;
+			bw_str = (rs->unit_base == 1 ? "Mibit" : "MiB");
+		}
+
+		log_buf(out, "   bw (%5s/s): min=%5llu, max=%5llu, per=%3.2f%%, "
+			"avg=%5.02f, stdev=%5.02f, samples=%" PRIu64 "\n",
+			bw_str, min, max, p_of_agg, mean, dev,
+			(&ts_lcl->bw_stat[ddir])->samples);
+	}
+	if (calc_lat(&ts_lcl->iops_stat[ddir], &min, &max, &mean, &dev)) {
+		log_buf(out, "   iops        : min=%5llu, max=%5llu, "
+			"avg=%5.02f, stdev=%5.02f, samples=%" PRIu64 "\n",
+			min, max, mean, dev, (&ts_lcl->iops_stat[ddir])->samples);
+	}
+
+	free(ts_lcl);
+}
+
 static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 			     int ddir, struct buf_output *out)
 {
@@ -477,7 +683,7 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	}
 
 	log_buf(out, "  %s: IOPS=%s, BW=%s (%s)(%s/%llumsec)%s\n",
-			rs->unified_rw_rep ? "mixed" : io_ddir_name(ddir),
+			(ts->unified_rw_rep == UNIFIED_MIXED) ? "mixed" : io_ddir_name(ddir),
 			iops_p, bw_p, bw_p_alt, io_p,
 			(unsigned long long) ts->runtime[ddir],
 			post_st ? : "");
@@ -1083,6 +1289,9 @@ static void show_thread_status_normal(struct thread_stat *ts,
 			show_ddir_status(rs, ts, ddir, out);
 	}
 
+	if (ts->unified_rw_rep == UNIFIED_BOTH)
+		show_mixed_ddir_status(rs, ts, out);
+
 	show_latencies(ts, out);
 
 	if (ts->sync_stat.samples)
@@ -1205,7 +1414,7 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 					&minv);
 	else
 		len = 0;
-
+	
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++) {
 		if (i >= len) {
 			log_buf(out, ";0%%=0");
@@ -1249,6 +1458,40 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 	}
 }
 
+static void show_mixed_ddir_status_terse(struct thread_stat *ts,
+				   struct group_run_stats *rs,
+				   int ver, struct buf_output *out)
+{
+	struct thread_stat *ts_lcl;
+	int i;
+
+	/* Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and Trims (ddir = 2) */
+	ts_lcl = malloc(sizeof(struct thread_stat));
+	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
+	ts_lcl->unified_rw_rep = UNIFIED_MIXED;               /* calculate mixed stats  */
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		ts_lcl->clat_stat[i].min_val = ULONG_MAX;
+		ts_lcl->slat_stat[i].min_val = ULONG_MAX;
+		ts_lcl->lat_stat[i].min_val = ULONG_MAX;
+		ts_lcl->bw_stat[i].min_val = ULONG_MAX;
+		ts_lcl->iops_stat[i].min_val = ULONG_MAX;
+		ts_lcl->clat_high_prio_stat[i].min_val = ULONG_MAX;
+		ts_lcl->clat_low_prio_stat[i].min_val = ULONG_MAX;
+	}
+	ts_lcl->sync_stat.min_val = ULONG_MAX;
+	ts_lcl->lat_percentiles = ts->lat_percentiles;
+	ts_lcl->clat_percentiles = ts->clat_percentiles;
+	ts_lcl->slat_percentiles = ts->slat_percentiles;
+	ts_lcl->percentile_precision = ts->percentile_precision;		
+	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentile_list));
+	
+	sum_thread_stats(ts_lcl, ts, 1);
+
+	/* add the aggregated stats to json parent */
+	show_ddir_status_terse(ts_lcl, rs, DDIR_READ, ver, out);
+	free(ts_lcl);
+}
+
 static struct json_object *add_ddir_lat_json(struct thread_stat *ts, uint32_t percentiles,
 		struct io_stat *lat_stat, uint64_t *io_u_plat)
 {
@@ -1310,12 +1553,12 @@ static void add_ddir_status_json(struct thread_stat *ts,
 
 	assert(ddir_rw(ddir) || ddir_sync(ddir));
 
-	if (ts->unified_rw_rep && ddir != DDIR_READ)
+	if ((ts->unified_rw_rep == UNIFIED_MIXED) && ddir != DDIR_READ)
 		return;
 
 	dir_object = json_create_object();
 	json_object_add_value_object(parent,
-		ts->unified_rw_rep ? "mixed" : io_ddir_name(ddir), dir_object);
+		(ts->unified_rw_rep == UNIFIED_MIXED) ? "mixed" : io_ddir_name(ddir), dir_object);
 
 	if (ddir_rw(ddir)) {
 		bw_bytes = 0;
@@ -1418,6 +1661,39 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	}
 }
 
+static void add_mixed_ddir_status_json(struct thread_stat *ts,
+		struct group_run_stats *rs, struct json_object *parent)
+{
+	struct thread_stat *ts_lcl;
+	int i;
+
+	/* Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and Trims (ddir = 2) */
+	ts_lcl = malloc(sizeof(struct thread_stat));
+	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
+	ts_lcl->unified_rw_rep = UNIFIED_MIXED;               /* calculate mixed stats  */
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		ts_lcl->clat_stat[i].min_val = ULONG_MAX;
+		ts_lcl->slat_stat[i].min_val = ULONG_MAX;
+		ts_lcl->lat_stat[i].min_val = ULONG_MAX;
+		ts_lcl->bw_stat[i].min_val = ULONG_MAX;
+		ts_lcl->iops_stat[i].min_val = ULONG_MAX;
+		ts_lcl->clat_high_prio_stat[i].min_val = ULONG_MAX;
+		ts_lcl->clat_low_prio_stat[i].min_val = ULONG_MAX;
+	}
+	ts_lcl->sync_stat.min_val = ULONG_MAX;
+	ts_lcl->lat_percentiles = ts->lat_percentiles;
+	ts_lcl->clat_percentiles = ts->clat_percentiles;
+	ts_lcl->slat_percentiles = ts->slat_percentiles;
+	ts_lcl->percentile_precision = ts->percentile_precision;		
+	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentile_list));
+
+	sum_thread_stats(ts_lcl, ts, 1);
+
+	/* add the aggregated stats to json parent */
+	add_ddir_status_json(ts_lcl, rs, DDIR_READ, parent);
+	free(ts_lcl);
+}
+
 static void show_thread_status_terse_all(struct thread_stat *ts,
 					 struct group_run_stats *rs, int ver,
 					 struct buf_output *out)
@@ -1435,14 +1711,17 @@ static void show_thread_status_terse_all(struct thread_stat *ts,
 		log_buf(out, "%d;%s;%s;%d;%d", ver, fio_version_string,
 			ts->name, ts->groupid, ts->error);
 
-	/* Log Read Status */
+	/* Log Read Status, or mixed if unified_rw_rep = 1 */
 	show_ddir_status_terse(ts, rs, DDIR_READ, ver, out);
-	/* Log Write Status */
-	show_ddir_status_terse(ts, rs, DDIR_WRITE, ver, out);
-	/* Log Trim Status */
-	if (ver == 2 || ver == 4 || ver == 5)
-		show_ddir_status_terse(ts, rs, DDIR_TRIM, ver, out);
-
+	if (ts->unified_rw_rep != UNIFIED_MIXED) {
+		/* Log Write Status */
+		show_ddir_status_terse(ts, rs, DDIR_WRITE, ver, out);
+		/* Log Trim Status */
+		if (ver == 2 || ver == 4 || ver == 5)
+			show_ddir_status_terse(ts, rs, DDIR_TRIM, ver, out);
+	}
+	if (ts->unified_rw_rep == UNIFIED_BOTH)
+		show_mixed_ddir_status_terse(ts, rs, ver, out);
 	/* CPU Usage */
 	if (ts->total_run_time) {
 		double runt = (double) ts->total_run_time;
@@ -1547,6 +1826,9 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 	add_ddir_status_json(ts, rs, DDIR_TRIM, root);
 	add_ddir_status_json(ts, rs, DDIR_SYNC, root);
 
+	if (ts->unified_rw_rep == UNIFIED_BOTH)
+		add_mixed_ddir_status_json(ts, rs, root);
+
 	/* CPU Usage */
 	if (ts->total_run_time) {
 		double runt = (double) ts->total_run_time;
@@ -1875,7 +2157,7 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 	int k, l, m;
 
 	for (l = 0; l < DDIR_RWDIR_CNT; l++) {
-		if (!dst->unified_rw_rep) {
+		if (!(dst->unified_rw_rep == UNIFIED_MIXED)) {
 			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], first, false);
 			sum_stat(&dst->clat_high_prio_stat[l], &src->clat_high_prio_stat[l], first, false);
 			sum_stat(&dst->clat_low_prio_stat[l], &src->clat_low_prio_stat[l], first, false);
@@ -1931,7 +2213,7 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 		dst->io_u_lat_m[k] += src->io_u_lat_m[k];
 
 	for (k = 0; k < DDIR_RWDIR_CNT; k++) {
-		if (!dst->unified_rw_rep) {
+		if (!(dst->unified_rw_rep == UNIFIED_MIXED)) {
 			dst->total_io_u[k] += src->total_io_u[k];
 			dst->short_io_u[k] += src->short_io_u[k];
 			dst->drop_io_u[k] += src->drop_io_u[k];
@@ -1947,7 +2229,7 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 	for (k = 0; k < FIO_LAT_CNT; k++)
 		for (l = 0; l < DDIR_RWDIR_CNT; l++)
 			for (m = 0; m < FIO_IO_U_PLAT_NR; m++)
-				if (!dst->unified_rw_rep)
+				if (!(dst->unified_rw_rep == UNIFIED_MIXED))
 					dst->io_u_plat[k][l][m] += src->io_u_plat[k][l][m];
 				else
 					dst->io_u_plat[k][0][m] += src->io_u_plat[k][l][m];
@@ -1957,7 +2239,7 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 
 	for (k = 0; k < DDIR_RWDIR_CNT; k++) {
 		for (m = 0; m < FIO_IO_U_PLAT_NR; m++) {
-			if (!dst->unified_rw_rep) {
+			if (!(dst->unified_rw_rep == UNIFIED_MIXED)) {
 				dst->io_u_plat_high_prio[k][m] += src->io_u_plat_high_prio[k][m];
 				dst->io_u_plat_low_prio[k][m] += src->io_u_plat_low_prio[k][m];
 			} else {
@@ -2166,7 +2448,7 @@ void __show_run_stats(void)
 		rs->kb_base = ts->kb_base;
 		rs->unit_base = ts->unit_base;
 		rs->sig_figs = ts->sig_figs;
-		rs->unified_rw_rep += ts->unified_rw_rep;
+		rs->unified_rw_rep |= ts->unified_rw_rep;
 
 		for (j = 0; j < DDIR_RWDIR_CNT; j++) {
 			if (!ts->runtime[j])
diff --git a/stat.h b/stat.h
index 6dd5ef74..d08d4dc0 100644
--- a/stat.h
+++ b/stat.h
@@ -146,6 +146,9 @@ enum block_info_state {
 #define FIO_JOBNAME_SIZE	128
 #define FIO_JOBDESC_SIZE	256
 #define FIO_VERROR_SIZE		128
+#define UNIFIED_SPLIT		0
+#define UNIFIED_MIXED		1
+#define UNIFIED_BOTH		2
 
 enum fio_lat {
 	FIO_SLAT = 0,

