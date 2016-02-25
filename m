Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:60297 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760089AbcBYNAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 25 Feb 2016 08:00:05 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1aYvWW-0003ge-3p
	for fio@vger.kernel.org; Thu, 25 Feb 2016 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160225130001.72E282C1369@kernel.dk>
Date: Thu, 25 Feb 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c0821a08db2fd3e37e16db73c3c4c9c7ff601e88:

  Allow for the include file specification to be relative. (2016-02-13 12:31:00 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a6cb85e25b31553aab043fe763ce4c999197dcff:

  Allow IO engine driven allocations of IO structures (2016-02-24 16:29:08 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Allow IO engine driven allocations of IO structures

 ioengine.h |  4 +++-
 memory.c   | 17 +++++++++++++++--
 2 files changed, 18 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/ioengine.h b/ioengine.h
index 6734c7b..161acf5 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -16,7 +16,7 @@
 #include <guasi.h>
 #endif
 
-#define FIO_IOOPS_VERSION	22
+#define FIO_IOOPS_VERSION	23
 
 enum {
 	IO_U_F_FREE		= 1 << 0,
@@ -157,6 +157,8 @@ struct ioengine_ops {
 	int (*unlink_file)(struct thread_data *, struct fio_file *);
 	int (*get_file_size)(struct thread_data *, struct fio_file *);
 	void (*terminate)(struct thread_data *);
+	int (*iomem_alloc)(struct thread_data *, size_t);
+	void (*iomem_free)(struct thread_data *);
 	int (*io_u_init)(struct thread_data *, struct io_u *);
 	void (*io_u_free)(struct thread_data *, struct io_u *);
 	int option_struct_size;
diff --git a/memory.c b/memory.c
index 5060223..c04d7df 100644
--- a/memory.c
+++ b/memory.c
@@ -229,7 +229,17 @@ int allocate_io_mem(struct thread_data *td)
 
 	dprint(FD_MEM, "Alloc %llu for buffers\n", (unsigned long long) total_mem);
 
-	if (td->o.mem_type == MEM_MALLOC)
+	/*
+	 * If the IO engine has hooks to allocate/free memory, use those. But
+	 * error out if the user explicitly asked for something else.
+	 */
+	if (td->io_ops->iomem_alloc) {
+		if (fio_option_is_set(&td->o, mem_type)) {
+			log_err("fio: option 'mem/iomem' conflicts with specified IO engine\n");
+			ret = 1;
+		} else
+			ret = td->io_ops->iomem_alloc(td, total_mem);
+	} else if (td->o.mem_type == MEM_MALLOC)
 		ret = alloc_mem_malloc(td, total_mem);
 	else if (td->o.mem_type == MEM_SHM || td->o.mem_type == MEM_SHMHUGE)
 		ret = alloc_mem_shm(td, total_mem);
@@ -255,7 +265,10 @@ void free_io_mem(struct thread_data *td)
 	if (td->o.odirect || td->o.oatomic)
 		total_mem += page_mask;
 
-	if (td->o.mem_type == MEM_MALLOC)
+	if (td->io_ops->iomem_alloc) {
+		if (td->io_ops->iomem_free)
+			td->io_ops->iomem_free(td);
+	} else if (td->o.mem_type == MEM_MALLOC)
 		free_mem_malloc(td);
 	else if (td->o.mem_type == MEM_SHM || td->o.mem_type == MEM_SHMHUGE)
 		free_mem_shm(td);
