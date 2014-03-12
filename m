Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:56460 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaCLMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 12 Mar 2014 08:00:04 -0400
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WNhpL-000861-Tt
	for fio@vger.kernel.org; Wed, 12 Mar 2014 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140312120003.7D97941F3F@strynoevaenget.dk>
Date: Wed, 12 Mar 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b24f59ab5ac96a67a016dc921687b0feae9bbf94:

  Detect Windows operating system in ./configure (2014-03-06 14:31:57 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3939fe853fd146378811a05b78731d7f20d0152f:

  Add exceeds_number_ios() helper (2014-03-11 20:16:38 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Try a little harder to honor number_ios more accurately
      Add exceeds_number_ios() helper

S��bastien Bouchex Bellomi�� (1):
      Fix pointer alignment bug causing SIGBUS on Sparc64

 backend.c        |   17 ++++++++++++++++-
 io_u.c           |    3 ---
 os/os.h          |   18 ++++++------------
 thread_options.h |    2 +-
 4 files changed, 23 insertions(+), 17 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 992033c..1ff8b3f 100644
--- a/backend.c
+++ b/backend.c
@@ -623,6 +623,19 @@ reap:
 	dprint(FD_VERIFY, "exiting loop\n");
 }
 
+static unsigned int exceeds_number_ios(struct thread_data *td)
+{
+	unsigned long long number_ios;
+
+	if (!td->o.number_ios)
+		return 0;
+
+	number_ios = ddir_rw_sum(td->this_io_blocks);
+	number_ios += td->io_u_queued + td->io_u_in_flight;
+
+	return number_ios >= td->o.number_ios;
+}
+
 static int io_bytes_exceeded(struct thread_data *td)
 {
 	unsigned long long bytes;
@@ -636,7 +649,7 @@ static int io_bytes_exceeded(struct thread_data *td)
 	else
 		bytes = td->this_io_bytes[DDIR_TRIM];
 
-	return bytes >= td->o.size;
+	return bytes >= td->o.size || exceeds_number_ios(td);
 }
 
 /*
@@ -1127,6 +1140,8 @@ static int keep_running(struct thread_data *td)
 		td->o.loops--;
 		return 1;
 	}
+	if (exceeds_number_ios(td))
+		return 0;
 
 	if (td->o.size != -1ULL && ddir_rw_sum(td->io_bytes) < td->o.size) {
 		uint64_t diff;
diff --git a/io_u.c b/io_u.c
index 8e27708..0b86d9f 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1595,9 +1595,6 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 
 	if (!gtod_reduce(td))
 		add_iops_sample(td, idx, bytes, &icd->time);
-
-	if (td->o.number_ios && !--td->o.number_ios)
-		td->done = 1;
 }
 
 static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
diff --git a/os/os.h b/os/os.h
index 7f92d1b..2f2d069 100644
--- a/os/os.h
+++ b/os/os.h
@@ -201,28 +201,22 @@ static inline uint64_t fio_swap64(uint64_t val)
 #endif /* FIO_HAVE_BYTEORDER_FUNCS */
 
 #define le16_to_cpu(val) ({			\
-	uint16_t *__val = &(val);		\
-	__le16_to_cpu(*__val);			\
+	__le16_to_cpu(val);			\
 })
 #define le32_to_cpu(val) ({			\
-	uint32_t *__val = &(val);		\
-	__le32_to_cpu(*__val);			\
+	__le32_to_cpu(val);			\
 })
 #define le64_to_cpu(val) ({			\
-	uint64_t *__val = &(val);		\
-	__le64_to_cpu(*__val);			\
+	__le64_to_cpu(val);				\
 })
 #define cpu_to_le16(val) ({			\
-	uint16_t *__val = &(val);		\
-	__cpu_to_le16(*__val);			\
+	__cpu_to_le16(val);			\
 })
 #define cpu_to_le32(val) ({			\
-	uint32_t *__val = &(val);		\
-	__cpu_to_le32(*__val);			\
+	__cpu_to_le32(val);			\
 })
 #define cpu_to_le64(val) ({			\
-	uint64_t *__val = &(val);		\
-	__cpu_to_le64(*__val);			\
+	__cpu_to_le64(val);			\
 })
 
 #ifndef FIO_HAVE_BLKTRACE
diff --git a/thread_options.h b/thread_options.h
index 4ea6ebd..bacd86b 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -45,7 +45,7 @@ struct thread_options {
 	unsigned int kb_base;
 	unsigned int unit_base;
 	unsigned int ddir_seq_nr;
-	long ddir_seq_add;
+	long long ddir_seq_add;
 	unsigned int iodepth;
 	unsigned int iodepth_low;
 	unsigned int iodepth_batch;
