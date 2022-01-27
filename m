Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 233A6C433EF
	for <fio@archiver.kernel.org>; Thu, 27 Jan 2022 13:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241421AbiA0NAH (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Jan 2022 08:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241435AbiA0NAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Jan 2022 08:00:07 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BFDC061714
        for <fio@vger.kernel.org>; Thu, 27 Jan 2022 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=E+J6s8Dlo9Oftq34dm2fpxshByOnTPl6vGT7Na+tHxo=; b=QzR+66UnnsRuv7DGEddBgVCYDN
        gEedhmLh3MlZfAB8MovA0PAxjQyAlVnQEfkBV+SI9/Ltc3v7cV9T0w0YrbxsE8lrp/C7i2DKo3ape
        65g6NyXEhI/OWnEpZZa7wMEx+tmbFiv6LCiOt/NMNLGnR8Ox0E8j1x1nNQ8bSWfWm7oPhwQ/MGt32
        zZLACPxGhsZvHs+qKndgmv91kN1JAPHwa/xFACbcCdIjozxB+Xg+CdPBBth35hypTesRyXVu6VaHi
        mDRK3Xuoexm57leybYjwJaO5BPhkz5mUhGihSDCjVTPn3MTC1F1FxUFhYMvPlNiMyjLW4OBYIUk+y
        NCXXmWdQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nD4Ng-005F7Z-Q5
        for fio@vger.kernel.org; Thu, 27 Jan 2022 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 72D071BC0130; Thu, 27 Jan 2022 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220127130002.72D071BC0130@kernel.dk>
Date:   Thu, 27 Jan 2022 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 2f0b54419a6ab039c677e41008391b8c53ae2e6b:

  Merge branch 'master' of https://github.com/ben-ihelputech/fio (2022-01-21 10:46:26 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2b3d4a6a924e0aa82654d3b96fb134085af7a98a:

  fio: use LDFLAGS when linking dynamic engines (2022-01-26 13:12:14 -0700)

----------------------------------------------------------------
Eric Sandeen (2):
      t/io_uring: link with libaio when necessary
      fio: use LDFLAGS when linking dynamic engines

Jens Axboe (1):
      Merge branch 'rpma-add-support-for-File-System-DAX' of https://github.com/ldorau/fio

Lukasz Dorau (1):
      rpma: RPMA engine requires librpma>=v0.10.0 with rpma_mr_advise()

Wang, Long (1):
      rpma: add support for File System DAX

 Makefile              |  3 ++-
 configure             |  9 ++++-----
 engines/librpma_fio.c | 44 +++++++++++++++++++++++++++++++++-----------
 engines/librpma_fio.h |  2 +-
 4 files changed, 40 insertions(+), 18 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 5d17bcab..00e79539 100644
--- a/Makefile
+++ b/Makefile
@@ -99,6 +99,7 @@ endif
 ifdef CONFIG_LIBAIO
   libaio_SRCS = engines/libaio.c
   cmdprio_SRCS = engines/cmdprio.c
+  LIBS += -laio
   libaio_LIBS = -laio
   ENGINES += libaio
 endif
@@ -294,7 +295,7 @@ define engine_template =
 $(1)_OBJS := $$($(1)_SRCS:.c=.o)
 $$($(1)_OBJS): CFLAGS := -fPIC $$($(1)_CFLAGS) $(CFLAGS)
 engines/fio-$(1).so: $$($(1)_OBJS)
-	$$(QUIET_LINK)$(CC) -shared -rdynamic -fPIC -Wl,-soname,fio-$(1).so.1 -o $$@ $$< $$($(1)_LIBS)
+	$$(QUIET_LINK)$(CC) $(DYNAMIC) -shared -rdynamic -fPIC -Wl,-soname,fio-$(1).so.1 -o $$@ $$< $$($(1)_LIBS)
 ENGS_OBJS += engines/fio-$(1).so
 endef
 else # !CONFIG_DYNAMIC_ENGINES
diff --git a/configure b/configure
index 84ccce04..0efde7d6 100755
--- a/configure
+++ b/configure
@@ -955,17 +955,16 @@ print_config "rdmacm" "$rdmacm"
 
 ##########################################
 # librpma probe
+# The librpma engine requires librpma>=v0.10.0 with rpma_mr_advise().
 if test "$librpma" != "yes" ; then
   librpma="no"
 fi
 cat > $TMPC << EOF
-#include <stdio.h>
 #include <librpma.h>
-int main(int argc, char **argv)
+int main(void)
 {
-  enum rpma_conn_event event = RPMA_CONN_REJECTED;
-  (void) event; /* unused */
-  rpma_log_set_threshold(RPMA_LOG_THRESHOLD, RPMA_LOG_LEVEL_INFO);
+  void *ptr = rpma_mr_advise;
+  (void) ptr; /* unused */
   return 0;
 }
 EOF
diff --git a/engines/librpma_fio.c b/engines/librpma_fio.c
index 3d605ed6..9d6ebf38 100644
--- a/engines/librpma_fio.c
+++ b/engines/librpma_fio.c
@@ -108,7 +108,7 @@ char *librpma_fio_allocate_dram(struct thread_data *td, size_t size,
 	return mem_ptr;
 }
 
-char *librpma_fio_allocate_pmem(struct thread_data *td, const char *filename,
+char *librpma_fio_allocate_pmem(struct thread_data *td, struct fio_file *f,
 		size_t size, struct librpma_fio_mem *mem)
 {
 	size_t size_mmap = 0;
@@ -122,18 +122,24 @@ char *librpma_fio_allocate_pmem(struct thread_data *td, const char *filename,
 		return NULL;
 	}
 
-	ws_offset = (td->thread_number - 1) * size;
+	if (f->filetype == FIO_TYPE_CHAR) {
+		/* Each thread uses a separate offset within DeviceDAX. */
+		ws_offset = (td->thread_number - 1) * size;
+	} else {
+		/* Each thread uses a separate FileSystemDAX file. No offset is needed. */
+		ws_offset = 0;
+	}
 
-	if (!filename) {
+	if (!f->file_name) {
 		log_err("fio: filename is not set\n");
 		return NULL;
 	}
 
 	/* map the file */
-	mem_ptr = pmem_map_file(filename, 0 /* len */, 0 /* flags */,
+	mem_ptr = pmem_map_file(f->file_name, 0 /* len */, 0 /* flags */,
 			0 /* mode */, &size_mmap, &is_pmem);
 	if (mem_ptr == NULL) {
-		log_err("fio: pmem_map_file(%s) failed\n", filename);
+		log_err("fio: pmem_map_file(%s) failed\n", f->file_name);
 		/* pmem_map_file() sets errno on failure */
 		td_verror(td, errno, "pmem_map_file");
 		return NULL;
@@ -142,7 +148,7 @@ char *librpma_fio_allocate_pmem(struct thread_data *td, const char *filename,
 	/* pmem is expected */
 	if (!is_pmem) {
 		log_err("fio: %s is not located in persistent memory\n",
-			filename);
+			f->file_name);
 		goto err_unmap;
 	}
 
@@ -150,12 +156,12 @@ char *librpma_fio_allocate_pmem(struct thread_data *td, const char *filename,
 	if (size_mmap < ws_offset + size) {
 		log_err(
 			"fio: %s is too small to handle so many threads (%zu < %zu)\n",
-			filename, size_mmap, ws_offset + size);
+			f->file_name, size_mmap, ws_offset + size);
 		goto err_unmap;
 	}
 
 	log_info("fio: size of memory mapped from the file %s: %zu\n",
-		filename, size_mmap);
+		f->file_name, size_mmap);
 
 	mem->mem_ptr = mem_ptr;
 	mem->size_mmap = size_mmap;
@@ -893,6 +899,7 @@ int librpma_fio_server_open_file(struct thread_data *td, struct fio_file *f,
 	size_t mem_size = td->o.size;
 	size_t mr_desc_size;
 	void *ws_ptr;
+	bool is_dram;
 	int usage_mem_type;
 	int ret;
 
@@ -910,14 +917,14 @@ int librpma_fio_server_open_file(struct thread_data *td, struct fio_file *f,
 		return -1;
 	}
 
-	if (strcmp(f->file_name, "malloc") == 0) {
+	is_dram = !strcmp(f->file_name, "malloc");
+	if (is_dram) {
 		/* allocation from DRAM using posix_memalign() */
 		ws_ptr = librpma_fio_allocate_dram(td, mem_size, &csd->mem);
 		usage_mem_type = RPMA_MR_USAGE_FLUSH_TYPE_VISIBILITY;
 	} else {
 		/* allocation from PMEM using pmem_map_file() */
-		ws_ptr = librpma_fio_allocate_pmem(td, f->file_name,
-				mem_size, &csd->mem);
+		ws_ptr = librpma_fio_allocate_pmem(td, f, mem_size, &csd->mem);
 		usage_mem_type = RPMA_MR_USAGE_FLUSH_TYPE_PERSISTENT;
 	}
 
@@ -934,6 +941,21 @@ int librpma_fio_server_open_file(struct thread_data *td, struct fio_file *f,
 		goto err_free;
 	}
 
+	if (!is_dram && f->filetype == FIO_TYPE_FILE) {
+		ret = rpma_mr_advise(mr, 0, mem_size,
+				IBV_ADVISE_MR_ADVICE_PREFETCH_WRITE,
+				IBV_ADVISE_MR_FLAG_FLUSH);
+		if (ret) {
+			librpma_td_verror(td, ret, "rpma_mr_advise");
+			/* an invalid argument is an error */
+			if (ret == RPMA_E_INVAL)
+				goto err_mr_dereg;
+
+			/* log_err used instead of log_info to avoid corruption of the JSON output */
+			log_err("Note: having rpma_mr_advise(3) failed because of RPMA_E_NOSUPP or RPMA_E_PROVIDER may come with a performance penalty, but it is not a blocker for running the benchmark.\n");
+		}
+	}
+
 	/* get size of the memory region's descriptor */
 	if ((ret = rpma_mr_get_descriptor_size(mr, &mr_desc_size))) {
 		librpma_td_verror(td, ret, "rpma_mr_get_descriptor_size");
diff --git a/engines/librpma_fio.h b/engines/librpma_fio.h
index fb89d99d..2c507e9c 100644
--- a/engines/librpma_fio.h
+++ b/engines/librpma_fio.h
@@ -77,7 +77,7 @@ struct librpma_fio_mem {
 char *librpma_fio_allocate_dram(struct thread_data *td, size_t size,
 		struct librpma_fio_mem *mem);
 
-char *librpma_fio_allocate_pmem(struct thread_data *td, const char *filename,
+char *librpma_fio_allocate_pmem(struct thread_data *td, struct fio_file *f,
 		size_t size, struct librpma_fio_mem *mem);
 
 void librpma_fio_free(struct librpma_fio_mem *mem);
