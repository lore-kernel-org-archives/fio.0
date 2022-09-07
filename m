Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A1EC38145
	for <fio@archiver.kernel.org>; Wed,  7 Sep 2022 12:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiIGMAM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 7 Sep 2022 08:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiIGMAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Sep 2022 08:00:10 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2564621C
        for <fio@vger.kernel.org>; Wed,  7 Sep 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=U67o/2qCrk01gO+E/EuIXjbw60Qnw2aB04WfwJ9DsF8=; b=WQIUxXY5Oa80wBJLKPnJ8HHd7w
        a7l+TkY87bjB5/WeJQkZXbcLJzzysnTVgMupQcO8FeeRkJKgNnVHycpQOaOKrwFBYcHmUaBQiO3R5
        CmzzLeCLJd4ktFX85vrUo3JrnY6i8JFaliIj2X/MN1WcrU9IC68TtsM7nQgScIBw4aNkWwTW4e2Wc
        8iy//STdMD1OSVTBGxkvGsLUNKdNy/dfKxYEwv7LICX58Izods/8qXglhF+mS26APjtJe/NzZB48V
        WQKjQl5GgdVNf3cMr4SSnSdqpay+pBG1b21FOe+uVxKC/zYTBAM6TogVW3t+ky7aTDK9d/Mg8e2SA
        hbMJKeBg==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oVtiu-00AQw3-Ih
        for fio@vger.kernel.org; Wed, 07 Sep 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 540B01BC0106; Wed,  7 Sep 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220907120002.540B01BC0106@kernel.dk>
Date:   Wed,  7 Sep 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 021ce718f5ae4bfd5f4e42290993578adb7c7bd5:

  t/io_uring: enable support for registered buffers for passthrough (2022-09-03 11:04:06 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 10fc06dc4166ef7c69a6c06cb3a318878048f6be:

  Merge branch 'rpma-add-support-for-libpmem2-to-the-librpma-engine' of https://github.com/ldorau/fio (2022-09-06 06:58:48 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'ci-build-the-librpma-fio-engine' of https://github.com/ldorau/fio
      Merge branch 'rpma-add-support-for-libpmem2-to-the-librpma-engine' of https://github.com/ldorau/fio

Kacper Stefanski (2):
      rpma: add support for libpmem2 to librpma engine in APM mode
      rpma: add support for libpmem2 to librpma engine in GPSPM mode

Lukasz Dorau (3):
      rpma: simplify server_cmpl_process()
      ci: build the librpma fio engine
      ci: remove the unused travis-install-pmdk.sh file

 Makefile                                           | 12 ++-
 ...stall-librpma.sh => actions-install-librpma.sh} |  3 +-
 ci/actions-install.sh                              |  6 ++
 ci/travis-install-pmdk.sh                          | 29 -------
 configure                                          | 29 ++++++-
 engines/librpma_fio.c                              | 52 ++++---------
 engines/librpma_fio.h                              |  7 +-
 engines/librpma_fio_pmem.h                         | 67 ++++++++++++++++
 engines/librpma_fio_pmem2.h                        | 91 ++++++++++++++++++++++
 engines/librpma_gpspm.c                            | 59 ++++++++------
 10 files changed, 257 insertions(+), 98 deletions(-)
 rename ci/{travis-install-librpma.sh => actions-install-librpma.sh} (74%)
 delete mode 100755 ci/travis-install-pmdk.sh
 create mode 100644 engines/librpma_fio_pmem.h
 create mode 100644 engines/librpma_fio_pmem2.h

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 634d2c93..f947f11c 100644
--- a/Makefile
+++ b/Makefile
@@ -111,13 +111,21 @@ endif
 ifdef CONFIG_LIBRPMA_APM
   librpma_apm_SRCS = engines/librpma_apm.c
   librpma_fio_SRCS = engines/librpma_fio.c
-  librpma_apm_LIBS = -lrpma -lpmem
+  ifdef CONFIG_LIBPMEM2_INSTALLED
+    librpma_apm_LIBS = -lrpma -lpmem2
+  else
+    librpma_apm_LIBS = -lrpma -lpmem
+  endif
   ENGINES += librpma_apm
 endif
 ifdef CONFIG_LIBRPMA_GPSPM
   librpma_gpspm_SRCS = engines/librpma_gpspm.c engines/librpma_gpspm_flush.pb-c.c
   librpma_fio_SRCS = engines/librpma_fio.c
-  librpma_gpspm_LIBS = -lrpma -lpmem -lprotobuf-c
+  ifdef CONFIG_LIBPMEM2_INSTALLED
+    librpma_gpspm_LIBS = -lrpma -lpmem2 -lprotobuf-c
+  else
+    librpma_gpspm_LIBS = -lrpma -lpmem -lprotobuf-c
+  endif
   ENGINES += librpma_gpspm
 endif
 ifdef librpma_fio_SRCS
diff --git a/ci/travis-install-librpma.sh b/ci/actions-install-librpma.sh
similarity index 74%
rename from ci/travis-install-librpma.sh
rename to ci/actions-install-librpma.sh
index 4e5ed21d..31f9f712 100755
--- a/ci/travis-install-librpma.sh
+++ b/ci/actions-install-librpma.sh
@@ -1,7 +1,6 @@
 #!/bin/bash -e
 
-# 11.02.2021 Merge pull request #866 from ldorau/rpma-mmap-memory-for-rpma_mr_reg-in-rpma_flush_apm_new
-LIBRPMA_VERSION=fbac593917e98f3f26abf14f4fad5a832b330f5c
+LIBRPMA_VERSION="1.0.0"
 ZIP_FILE=rpma.zip
 
 WORKDIR=$(pwd)
diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index c209a089..82e14d2a 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -44,7 +44,9 @@ DPKGCFG
                 libiscsi-dev
                 libnbd-dev
                 libpmem-dev
+                libpmem2-dev
                 libpmemblk-dev
+                libprotobuf-c-dev
                 librbd-dev
                 libtcmalloc-minimal4
                 nvidia-cuda-dev
@@ -67,6 +69,10 @@ DPKGCFG
     sudo apt-get -qq update
     echo "Installing packages... ${pkgs[@]}"
     sudo apt-get install -o APT::Immediate-Configure=false --no-install-recommends -qq -y "${pkgs[@]}"
+    if [ "${CI_TARGET_ARCH}" == "x86_64" ]; then
+        # install librpma from sources
+        ci/actions-install-librpma.sh
+    fi
 }
 
 install_linux() {
diff --git a/ci/travis-install-pmdk.sh b/ci/travis-install-pmdk.sh
deleted file mode 100755
index 7bde9fd0..00000000
--- a/ci/travis-install-pmdk.sh
+++ /dev/null
@@ -1,29 +0,0 @@
-#!/bin/bash -e
-
-# pmdk v1.9.1 release
-PMDK_VERSION=1.9.1
-
-WORKDIR=$(pwd)
-
-#
-# The '/bin/sh' shell used by PMDK's 'make install'
-# does not know the exact localization of clang
-# and fails with:
-#    /bin/sh: 1: clang: not found
-# if CC is not set to the full path of clang.
-#
-CC=$(type -P "$CC")
-export CC
-
-# Install PMDK libraries, because PMDK's libpmem
-# is a dependency of the librpma fio engine.
-# Install it from a release package
-# with already generated documentation,
-# in order to not install 'pandoc'.
-wget https://github.com/pmem/pmdk/releases/download/${PMDK_VERSION}/pmdk-${PMDK_VERSION}.tar.gz
-tar -xzf pmdk-${PMDK_VERSION}.tar.gz
-cd pmdk-${PMDK_VERSION}
-make -j"$(nproc)" NDCTL_ENABLE=n
-sudo make -j"$(nproc)" install prefix=/usr NDCTL_ENABLE=n
-cd "$WORKDIR"
-rm -rf pmdk-${PMDK_VERSION}
diff --git a/configure b/configure
index a2b9bd4c..7741ef4f 100755
--- a/configure
+++ b/configure
@@ -2201,6 +2201,26 @@ EOF
 fi
 print_config "libpmem1_5" "$libpmem1_5"
 
+##########################################
+# Check whether we have libpmem2
+if test "$libpmem2" != "yes" ; then
+  libpmem2="no"
+fi
+cat > $TMPC << EOF
+#include <libpmem2.h>
+int main(int argc, char **argv)
+{
+  struct pmem2_config *cfg;
+  pmem2_config_new(&cfg);
+  pmem2_config_delete(&cfg);
+  return 0;
+}
+EOF
+if compile_prog "" "-lpmem2" "libpmem2"; then
+  libpmem2="yes"
+fi
+print_config "libpmem2" "$libpmem2"
+
 ##########################################
 # Check whether we have libpmemblk
 # libpmem is a prerequisite
@@ -2990,11 +3010,13 @@ if test "$libverbs" = "yes" -a "$rdmacm" = "yes" ; then
 fi
 # librpma is supported on the 'x86_64' architecture for now
 if test "$cpu" = "x86_64" -a "$libverbs" = "yes" -a "$rdmacm" = "yes" \
-    -a "$librpma" = "yes" -a "$libpmem" = "yes" ; then
+    -a "$librpma" = "yes" \
+    && test "$libpmem" = "yes" -o "$libpmem2" = "yes" ; then
   output_sym "CONFIG_LIBRPMA_APM"
 fi
 if test "$cpu" = "x86_64" -a "$libverbs" = "yes" -a "$rdmacm" = "yes" \
-    -a "$librpma" = "yes" -a "$libpmem" = "yes" -a "$libprotobuf_c" = "yes" ; then
+    -a "$librpma" = "yes" -a "$libprotobuf_c" = "yes" \
+    && test "$libpmem" = "yes" -o "$libpmem2" = "yes" ; then
   output_sym "CONFIG_LIBRPMA_GPSPM"
 fi
 if test "$clock_gettime" = "yes" ; then
@@ -3138,6 +3160,9 @@ fi
 if test "$pmem" = "yes" ; then
   output_sym "CONFIG_LIBPMEM"
 fi
+if test "$libpmem2" = "yes" ; then
+  output_sym "CONFIG_LIBPMEM2_INSTALLED"
+fi
 if test "$libime" = "yes" ; then
   output_sym "CONFIG_IME"
 fi
diff --git a/engines/librpma_fio.c b/engines/librpma_fio.c
index a78a1e57..42d6163e 100644
--- a/engines/librpma_fio.c
+++ b/engines/librpma_fio.c
@@ -1,7 +1,7 @@
 /*
  * librpma_fio: librpma_apm and librpma_gpspm engines' common part.
  *
- * Copyright 2021, Intel Corporation
+ * Copyright 2021-2022, Intel Corporation
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License,
@@ -13,9 +13,11 @@
  * GNU General Public License for more details.
  */
 
-#include "librpma_fio.h"
-
-#include <libpmem.h>
+#ifdef CONFIG_LIBPMEM2_INSTALLED
+#include "librpma_fio_pmem2.h"
+#else
+#include "librpma_fio_pmem.h"
+#endif /* CONFIG_LIBPMEM2_INSTALLED */
 
 struct fio_option librpma_fio_options[] = {
 	{
@@ -111,10 +113,8 @@ char *librpma_fio_allocate_dram(struct thread_data *td, size_t size,
 char *librpma_fio_allocate_pmem(struct thread_data *td, struct fio_file *f,
 		size_t size, struct librpma_fio_mem *mem)
 {
-	size_t size_mmap = 0;
-	char *mem_ptr = NULL;
-	int is_pmem = 0;
 	size_t ws_offset;
+	mem->mem_ptr = NULL;
 
 	if (size % page_size) {
 		log_err("fio: size (%zu) is not aligned to page size (%zu)\n",
@@ -135,48 +135,24 @@ char *librpma_fio_allocate_pmem(struct thread_data *td, struct fio_file *f,
 		return NULL;
 	}
 
-	/* map the file */
-	mem_ptr = pmem_map_file(f->file_name, 0 /* len */, 0 /* flags */,
-			0 /* mode */, &size_mmap, &is_pmem);
-	if (mem_ptr == NULL) {
-		log_err("fio: pmem_map_file(%s) failed\n", f->file_name);
-		/* pmem_map_file() sets errno on failure */
-		td_verror(td, errno, "pmem_map_file");
-		return NULL;
-	}
-
-	/* pmem is expected */
-	if (!is_pmem) {
-		log_err("fio: %s is not located in persistent memory\n",
+	if (librpma_fio_pmem_map_file(f, size, mem, ws_offset)) {
+		log_err("fio: librpma_fio_pmem_map_file(%s) failed\n",
 			f->file_name);
-		goto err_unmap;
-	}
-
-	/* check size of allocated persistent memory */
-	if (size_mmap < ws_offset + size) {
-		log_err(
-			"fio: %s is too small to handle so many threads (%zu < %zu)\n",
-			f->file_name, size_mmap, ws_offset + size);
-		goto err_unmap;
+		return NULL;
 	}
 
 	log_info("fio: size of memory mapped from the file %s: %zu\n",
-		f->file_name, size_mmap);
-
-	mem->mem_ptr = mem_ptr;
-	mem->size_mmap = size_mmap;
+		f->file_name, mem->size_mmap);
 
-	return mem_ptr + ws_offset;
+	log_info("fio: library used to map PMem from file: %s\n", RPMA_PMEM_USED);
 
-err_unmap:
-	(void) pmem_unmap(mem_ptr, size_mmap);
-	return NULL;
+	return mem->mem_ptr ? mem->mem_ptr + ws_offset : NULL;
 }
 
 void librpma_fio_free(struct librpma_fio_mem *mem)
 {
 	if (mem->size_mmap)
-		(void) pmem_unmap(mem->mem_ptr, mem->size_mmap);
+		librpma_fio_unmap(mem);
 	else
 		free(mem->mem_ptr);
 }
diff --git a/engines/librpma_fio.h b/engines/librpma_fio.h
index 91290235..480ded1b 100644
--- a/engines/librpma_fio.h
+++ b/engines/librpma_fio.h
@@ -1,7 +1,7 @@
 /*
  * librpma_fio: librpma_apm and librpma_gpspm engines' common header.
  *
- * Copyright 2021, Intel Corporation
+ * Copyright 2021-2022, Intel Corporation
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License,
@@ -72,6 +72,11 @@ struct librpma_fio_mem {
 
 	/* size of the mapped persistent memory */
 	size_t size_mmap;
+
+#ifdef CONFIG_LIBPMEM2_INSTALLED
+	/* libpmem2 structure used for mapping PMem */
+	struct pmem2_map *map;
+#endif
 };
 
 char *librpma_fio_allocate_dram(struct thread_data *td, size_t size,
diff --git a/engines/librpma_fio_pmem.h b/engines/librpma_fio_pmem.h
new file mode 100644
index 00000000..4854292c
--- /dev/null
+++ b/engines/librpma_fio_pmem.h
@@ -0,0 +1,67 @@
+/*
+ * librpma_fio_pmem: allocates pmem using libpmem.
+ *
+ * Copyright 2022, Intel Corporation
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
+#include <libpmem.h>
+#include "librpma_fio.h"
+
+#define RPMA_PMEM_USED "libpmem"
+
+static int librpma_fio_pmem_map_file(struct fio_file *f, size_t size,
+		struct librpma_fio_mem *mem, size_t ws_offset)
+{
+	int is_pmem = 0;
+	size_t size_mmap = 0;
+
+	/* map the file */
+	mem->mem_ptr = pmem_map_file(f->file_name, 0 /* len */, 0 /* flags */,
+			0 /* mode */, &size_mmap, &is_pmem);
+	if (mem->mem_ptr == NULL) {
+		/* pmem_map_file() sets errno on failure */
+		log_err("fio: pmem_map_file(%s) failed: %s (errno %i)\n",
+			f->file_name, strerror(errno), errno);
+		return -1;
+	}
+
+	/* pmem is expected */
+	if (!is_pmem) {
+		log_err("fio: %s is not located in persistent memory\n",
+			f->file_name);
+		goto err_unmap;
+	}
+
+	/* check size of allocated persistent memory */
+	if (size_mmap < ws_offset + size) {
+		log_err(
+			"fio: %s is too small to handle so many threads (%zu < %zu)\n",
+			f->file_name, size_mmap, ws_offset + size);
+		goto err_unmap;
+	}
+
+	log_info("fio: size of memory mapped from the file %s: %zu\n",
+		f->file_name, size_mmap);
+
+	mem->size_mmap = size_mmap;
+
+	return 0;
+
+err_unmap:
+	(void) pmem_unmap(mem->mem_ptr, size_mmap);
+	return -1;
+}
+
+static inline void librpma_fio_unmap(struct librpma_fio_mem *mem)
+{
+	(void) pmem_unmap(mem->mem_ptr, mem->size_mmap);
+}
diff --git a/engines/librpma_fio_pmem2.h b/engines/librpma_fio_pmem2.h
new file mode 100644
index 00000000..09a51f5f
--- /dev/null
+++ b/engines/librpma_fio_pmem2.h
@@ -0,0 +1,91 @@
+/*
+ * librpma_fio_pmem2: allocates pmem using libpmem2.
+ *
+ * Copyright 2022, Intel Corporation
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
+#include <libpmem2.h>
+#include "librpma_fio.h"
+
+#define RPMA_PMEM_USED "libpmem2"
+
+static int librpma_fio_pmem_map_file(struct fio_file *f, size_t size,
+		struct librpma_fio_mem *mem, size_t ws_offset)
+{
+	int fd;
+	struct pmem2_config *cfg = NULL;
+	struct pmem2_map *map = NULL;
+	struct pmem2_source *src = NULL;
+
+	size_t size_mmap;
+
+	if((fd = open(f->file_name, O_RDWR)) < 0) {
+		log_err("fio: cannot open fio file\n");
+		return -1;
+	}
+
+	if (pmem2_source_from_fd(&src, fd) != 0) {
+		log_err("fio: pmem2_source_from_fd() failed\n");
+		goto err_close;
+	}
+
+	if (pmem2_config_new(&cfg) != 0) {
+		log_err("fio: pmem2_config_new() failed\n");
+		goto err_source_delete;
+	}
+
+	if (pmem2_config_set_required_store_granularity(cfg,
+					PMEM2_GRANULARITY_CACHE_LINE) != 0) {
+		log_err("fio: pmem2_config_set_required_store_granularity() failed: %s\n", pmem2_errormsg());
+		goto err_config_delete;
+	}
+
+	if (pmem2_map_new(&map, cfg, src) != 0) {
+		log_err("fio: pmem2_map_new(%s) failed: %s\n", f->file_name, pmem2_errormsg());
+		goto err_config_delete;
+	}
+
+	size_mmap = pmem2_map_get_size(map);
+
+	/* check size of allocated persistent memory */
+	if (size_mmap < ws_offset + size) {
+		log_err(
+			"fio: %s is too small to handle so many threads (%zu < %zu)\n",
+			f->file_name, size_mmap, ws_offset + size);
+		goto err_map_delete;
+	}
+
+	mem->mem_ptr = pmem2_map_get_address(map);
+	mem->size_mmap = size_mmap;
+	mem->map = map;
+	pmem2_config_delete(&cfg);
+	pmem2_source_delete(&src);
+	close(fd);
+
+	return 0;
+
+err_map_delete:
+	pmem2_map_delete(&map);
+err_config_delete:
+	pmem2_config_delete(&cfg);
+err_source_delete:
+	pmem2_source_delete(&src);
+err_close:
+	close(fd);
+
+	return -1;
+}
+
+static inline void librpma_fio_unmap(struct librpma_fio_mem *mem)
+{
+	(void) pmem2_map_delete(&mem->map);
+}
diff --git a/engines/librpma_gpspm.c b/engines/librpma_gpspm.c
index f00717a7..70116d0d 100644
--- a/engines/librpma_gpspm.c
+++ b/engines/librpma_gpspm.c
@@ -2,7 +2,7 @@
  * librpma_gpspm: IO engine that uses PMDK librpma to write data,
  *		based on General Purpose Server Persistency Method
  *
- * Copyright 2020-2021, Intel Corporation
+ * Copyright 2020-2022, Intel Corporation
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License,
@@ -16,7 +16,11 @@
 
 #include "librpma_fio.h"
 
+#ifdef CONFIG_LIBPMEM2_INSTALLED
+#include <libpmem2.h>
+#else
 #include <libpmem.h>
+#endif
 
 /* Generated by the protocol buffer compiler from: librpma_gpspm_flush.proto */
 #include "librpma_gpspm_flush.pb-c.h"
@@ -361,6 +365,8 @@ FIO_STATIC struct ioengine_ops ioengine_client = {
 
 #define IO_U_BUFF_OFF_SERVER(i) (i * IO_U_BUF_LEN)
 
+typedef void (*librpma_fio_persist_fn)(const void *ptr, size_t size);
+
 struct server_data {
 	/* aligned td->orig_buffer */
 	char *orig_buffer_aligned;
@@ -373,6 +379,8 @@ struct server_data {
 	/* in-memory queues */
 	struct ibv_wc *msgs_queued;
 	uint32_t msg_queued_nr;
+
+	librpma_fio_persist_fn persist;
 };
 
 static int server_init(struct thread_data *td)
@@ -400,6 +408,13 @@ static int server_init(struct thread_data *td)
 		goto err_free_sd;
 	}
 
+#ifdef CONFIG_LIBPMEM2_INSTALLED
+	/* get libpmem2 persist function from pmem2_map */
+	sd->persist = pmem2_get_persist_fn(csd->mem.map);
+#else
+	sd->persist = pmem_persist;
+#endif
+
 	/*
 	 * Assure a single io_u buffer can store both SEND and RECV messages and
 	 * an io_us buffer allocation is page-size-aligned which is required
@@ -594,7 +609,7 @@ static int server_qe_process(struct thread_data *td, struct ibv_wc *wc)
 
 	if (IS_NOT_THE_LAST_MESSAGE(flush_req)) {
 		op_ptr = csd->ws_ptr + flush_req->offset;
-		pmem_persist(op_ptr, flush_req->length);
+		sd->persist(op_ptr, flush_req->length);
 	} else {
 		/*
 		 * This is the last message - the client is done.
@@ -685,29 +700,25 @@ static int server_cmpl_process(struct thread_data *td)
 
 	ret = rpma_cq_get_wc(csd->cq, 1, wc, NULL);
 	if (ret == RPMA_E_NO_COMPLETION) {
-		if (o->busy_wait_polling == 0) {
-			ret = rpma_cq_wait(csd->cq);
-			if (ret == RPMA_E_NO_COMPLETION) {
-				/* lack of completion is not an error */
-				return 0;
-			} else if (ret != 0) {
-				librpma_td_verror(td, ret, "rpma_cq_wait");
-				goto err_terminate;
-			}
-
-			ret = rpma_cq_get_wc(csd->cq, 1, wc, NULL);
-			if (ret == RPMA_E_NO_COMPLETION) {
-				/* lack of completion is not an error */
-				return 0;
-			} else if (ret != 0) {
-				librpma_td_verror(td, ret, "rpma_cq_get_wc");
-				goto err_terminate;
-			}
-		} else {
-			/* lack of completion is not an error */
-			return 0;
+		if (o->busy_wait_polling)
+			return 0; /* lack of completion is not an error */
+
+		ret = rpma_cq_wait(csd->cq);
+		if (ret == RPMA_E_NO_COMPLETION)
+			return 0; /* lack of completion is not an error */
+		if (ret) {
+			librpma_td_verror(td, ret, "rpma_cq_wait");
+			goto err_terminate;
+		}
+
+		ret = rpma_cq_get_wc(csd->cq, 1, wc, NULL);
+		if (ret == RPMA_E_NO_COMPLETION)
+			return 0; /* lack of completion is not an error */
+		if (ret) {
+			librpma_td_verror(td, ret, "rpma_cq_get_wc");
+			goto err_terminate;
 		}
-	} else if (ret != 0) {
+	} else if (ret) {
 		librpma_td_verror(td, ret, "rpma_cq_get_wc");
 		goto err_terminate;
 	}
