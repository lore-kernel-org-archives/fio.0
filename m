Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH] thread_options: drop fadvise_stream from thread_options
Date: Fri,  1 Dec 2017 16:52:08 -0500
Message-Id: <1512165128-5577-1-git-send-email-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

ae8e559e got rid of the fadvise_stream option but did
not remove the corresponding member from thread_options
---
 server.h         | 2 +-
 thread_options.h | 3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/server.h b/server.h
index dbd5c27..438a6c3 100644
--- a/server.h
+++ b/server.h
@@ -49,7 +49,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 67,
+	FIO_SERVER_VER			= 68,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index a9c3bee..793df8a 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -218,7 +218,6 @@ struct thread_options {
 	unsigned int group_reporting;
 	unsigned int stats;
 	unsigned int fadvise_hint;
-	unsigned int fadvise_stream;
 	enum fio_fallocate_mode fallocate_mode;
 	unsigned int zero_buffers;
 	unsigned int refill_buffers;
@@ -494,7 +493,6 @@ struct thread_options_pack {
 	uint32_t group_reporting;
 	uint32_t stats;
 	uint32_t fadvise_hint;
-	uint32_t fadvise_stream;
 	uint32_t fallocate_mode;
 	uint32_t zero_buffers;
 	uint32_t refill_buffers;
@@ -520,7 +518,6 @@ struct thread_options_pack {
 	uint64_t trim_backlog;
 	uint32_t clat_percentiles;
 	uint32_t percentile_precision;
-	uint32_t pad;
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
-- 
2.7.4


