Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 5/7] Verify the absence of holes in struct jobs_eta at compile time
Date: Tue, 13 Aug 2019 19:20:36 -0700
Message-Id: <20190814022038.30941-6-bvanassche@acm.org>
In-Reply-To: <20190814022038.30941-1-bvanassche@acm.org>
References: <20190814022038.30941-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

This helps to verify the correctness of a later patch that will modify
this structure.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 eta.c  |  2 ++
 fio.h  |  2 ++
 stat.h | 55 +++++++++++++++++++++++++++++--------------------------
 3 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/eta.c b/eta.c
index 647a1bdd8eed..4095a257d206 100644
--- a/eta.c
+++ b/eta.c
@@ -736,6 +736,8 @@ void print_thread_status(void)
 
 void print_status_init(int thr_number)
 {
+	BUILD_BUG_ON(sizeof(struct jobs_eta) != sizeof(struct jobs_eta_packed));
+
 	DRD_IGNORE_VAR(__run_str);
 	__run_str[thr_number] = 'P';
 	update_condensed_str(__run_str, run_str);
diff --git a/fio.h b/fio.h
index 2094d30b863e..4bf96fc1cd62 100644
--- a/fio.h
+++ b/fio.h
@@ -66,6 +66,8 @@
 #include <cuda.h>
 #endif
 
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+
 struct fio_sem;
 
 /*
diff --git a/stat.h b/stat.h
index c6353c70ae08..c209ab6c7a96 100644
--- a/stat.h
+++ b/stat.h
@@ -251,33 +251,36 @@ struct thread_stat {
 	uint64_t cachemiss;
 } __attribute__((packed));
 
-struct jobs_eta {
-	uint32_t nr_running;
-	uint32_t nr_ramp;
-
-	uint32_t nr_pending;
-	uint32_t nr_setting_up;
-
-	uint64_t m_rate[DDIR_RWDIR_CNT], t_rate[DDIR_RWDIR_CNT];
-	uint64_t rate[DDIR_RWDIR_CNT];
-	uint32_t m_iops[DDIR_RWDIR_CNT] __attribute__((packed));
-	uint32_t t_iops[DDIR_RWDIR_CNT] __attribute__((packed));
-	uint32_t iops[DDIR_RWDIR_CNT] __attribute__((packed));
-	uint64_t elapsed_sec __attribute__((packed));
-	uint64_t eta_sec __attribute__((packed));
-	uint32_t is_pow2;
-	uint32_t unit_base;
-
-	uint32_t sig_figs;
-
-	uint32_t files_open;
+#define JOBS_ETA {							\
+	uint32_t nr_running;						\
+	uint32_t nr_ramp;						\
+									\
+	uint32_t nr_pending;						\
+	uint32_t nr_setting_up;						\
+									\
+	uint64_t m_rate[DDIR_RWDIR_CNT], t_rate[DDIR_RWDIR_CNT];	\
+	uint64_t rate[DDIR_RWDIR_CNT];					\
+	uint32_t m_iops[DDIR_RWDIR_CNT] __attribute__((packed));	\
+	uint32_t t_iops[DDIR_RWDIR_CNT] __attribute__((packed));	\
+	uint32_t iops[DDIR_RWDIR_CNT] __attribute__((packed));		\
+	uint64_t elapsed_sec __attribute__((packed));			\
+	uint64_t eta_sec __attribute__((packed));			\
+	uint32_t is_pow2;						\
+	uint32_t unit_base;						\
+									\
+	uint32_t sig_figs;						\
+									\
+	uint32_t files_open;						\
+									\
+	/*								\
+	 * Network 'copy' of run_str[]					\
+	 */								\
+	uint32_t nr_threads;						\
+	uint8_t run_str[];						\
+}
 
-	/*
-	 * Network 'copy' of run_str[]
-	 */
-	uint32_t nr_threads;
-	uint8_t run_str[];
-};
+struct jobs_eta JOBS_ETA;
+struct jobs_eta_packed JOBS_ETA __attribute__((packed));
 
 struct io_u_plat_entry {
 	struct flist_head list;
-- 
2.22.0


