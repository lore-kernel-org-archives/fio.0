Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:36657 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbbAUNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 21 Jan 2015 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YDutB-0004Zt-7y
	for fio@vger.kernel.org; Wed, 21 Jan 2015 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150121130003.99DD640129@lyth.info>
Date: Wed, 21 Jan 2015 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ae703cdf31532e337cc18c259c883bf5314aa43a:

  net: don't record/verify UDP sequence numbers if buffer is too small (2015-01-16 18:26:37 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 91e475290c03db58f856a62f763d29e964934114:

  shm: disable iomem=shm* for shm disabled (2015-01-20 18:38:11 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      configure: add --disable-shm to disable use of shm
      shm: disable iomem=shm* for shm disabled

 configure |    2 ++
 memory.c  |    7 +++++++
 2 files changed, 9 insertions(+)

---

Diff of recent changes:

diff --git a/configure b/configure
index 172b235..6e1376f 100755
--- a/configure
+++ b/configure
@@ -165,6 +165,8 @@ for opt do
   ;;
   --enable-libhdfs) libhdfs="yes"
   ;;
+  --disable-shm) output_sym "CONFIG_NO_SHM"
+  ;;
   --help)
     show_help="yes"
     ;;
diff --git a/memory.c b/memory.c
index f81c2dd..23a0d94 100644
--- a/memory.c
+++ b/memory.c
@@ -63,6 +63,7 @@ int fio_pin_memory(struct thread_data *td)
 
 static int alloc_mem_shm(struct thread_data *td, unsigned int total_mem)
 {
+#ifndef CONFIG_NO_SHM
 	int flags = IPC_CREAT | S_IRUSR | S_IWUSR;
 
 	if (td->o.mem_type == MEM_SHMHUGE) {
@@ -104,15 +105,21 @@ static int alloc_mem_shm(struct thread_data *td, unsigned int total_mem)
 	}
 
 	return 0;
+#else
+	log_err("fio: shm not supported\n");
+	return 1;
+#endif
 }
 
 static void free_mem_shm(struct thread_data *td)
 {
+#ifndef CONFIG_NO_SHM
 	struct shmid_ds sbuf;
 
 	dprint(FD_MEM, "shmdt/ctl %d %p\n", td->shm_id, td->orig_buffer);
 	shmdt(td->orig_buffer);
 	shmctl(td->shm_id, IPC_RMID, &sbuf);
+#endif
 }
 
 static int alloc_mem_mmap(struct thread_data *td, size_t total_mem)
