Return-Path: <gwendal@google.com>
Return-Path: <gwendal@google.com>
From: Gwendal Grignou <gwendal@chromium.org>
Subject: [PATCH v5] fio: Fix padding properly
Date: Mon, 27 Oct 2014 09:50:35 -0700
Message-Id: <1414428635-1598-1-git-send-email-gwendal@chromium.org>
In-Reply-To: <544ABB51.1040107@kernel.dk>
References: <544ABB51.1040107@kernel.dk>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, vapier@chromium.org, puthik@chromium.org, Gwendal Grignou <gwendal@chromium.org>
List-ID: <fio@vger.kernel.org>

Completely fix padding:
- use anonymous union for padding
- remove remaining padding in thread_stat.

Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
---
 libfio.c | 2 ++
 stat.h   | 9 ++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/libfio.c b/libfio.c
index b823bd4..1abf39a 100644
--- a/libfio.c
+++ b/libfio.c
@@ -305,6 +305,8 @@ int initialize_fio(char *envp[])
 	 * access (ARM).
 	 */
 	compiletime_assert((offsetof(struct thread_stat, percentile_list) % 8) == 0, "stat percentile_list");
+	compiletime_assert((offsetof(struct thread_stat, total_run_time) % 8) == 0, "total_run_time");
+	compiletime_assert((offsetof(struct thread_stat, total_err_count) % 8) == 0, "total_err_count");
 	compiletime_assert((offsetof(struct thread_stat, latency_percentile) % 8) == 0, "stat latency_percentile");
 	compiletime_assert((offsetof(struct thread_options_pack, zipf_theta) % 8) == 0, "zipf_theta");
 	compiletime_assert((offsetof(struct thread_options_pack, pareto_h) % 8) == 0, "pareto_h");
diff --git a/stat.h b/stat.h
index 16b3d1a..7a0dd55 100644
--- a/stat.h
+++ b/stat.h
@@ -158,6 +158,8 @@ struct thread_stat {
 	uint32_t io_u_lat_u[FIO_IO_U_LAT_U_NR];
 	uint32_t io_u_lat_m[FIO_IO_U_LAT_M_NR];
 	uint32_t io_u_plat[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR];
+	uint32_t pad1;
+
 	uint64_t total_io_u[3];
 	uint64_t short_io_u[3];
 	uint64_t drop_io_u[3];
@@ -171,8 +173,10 @@ struct thread_stat {
 	/*
 	 * IO Error related stats
 	 */
-	uint16_t continue_on_error;
-	uint16_t filler[3];
+	union {
+		uint16_t continue_on_error;
+		uint64_t pad2;
+	};
 	uint64_t total_err_count;
 	uint32_t first_error;
 
@@ -181,7 +185,6 @@ struct thread_stat {
 
 	uint32_t latency_depth;
 	uint64_t latency_target;
-	uint32_t pad;
 	fio_fp64_t latency_percentile;
 	uint64_t latency_window;
 } __attribute__((packed));
-- 
2.1.0.rc2.206.gedb03e5


