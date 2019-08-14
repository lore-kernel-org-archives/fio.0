Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 5/7] Verify the absence of holes in struct jobs_eta at compile time
Date: Wed, 14 Aug 2019 13:10:10 -0700
Message-Id: <20190814201012.253060-6-bvanassche@acm.org>
In-Reply-To: <20190814201012.253060-1-bvanassche@acm.org>
References: <20190814201012.253060-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

This patch verifies the correctness of the previous patch.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 eta.c  |  3 +++
 stat.h | 55 +++++++++++++++++++++++++++++--------------------------
 2 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/eta.c b/eta.c
index 647a1bdd8eed..5900bc0fd919 100644
--- a/eta.c
+++ b/eta.c
@@ -736,6 +736,9 @@ void print_thread_status(void)
 
 void print_status_init(int thr_number)
 {
+	compiletime_assert(sizeof(struct jobs_eta) ==
+			   sizeof(struct jobs_eta_packed), "jobs_eta");
+
 	DRD_IGNORE_VAR(__run_str);
 	__run_str[thr_number] = 'P';
 	update_condensed_str(__run_str, run_str);
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
2.22.0.rc1


