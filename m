Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44845 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbfHMCBy (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 12 Aug 2019 22:01:54 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so50412073pgl.11
        for <fio@vger.kernel.org>; Mon, 12 Aug 2019 19:01:53 -0700 (PDT)
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 3/5] Refine packed annotations in stat.h
Date: Mon, 12 Aug 2019 19:01:34 -0700
Message-Id: <20190813020136.15798-4-bvanassche@acm.org>
In-Reply-To: <20190813020136.15798-1-bvanassche@acm.org>
References: <20190813020136.15798-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>

Instead of declaring the whole structure packed, only declare non-aligned
members packed. This patch is an alternative way to fix the following gcc 9
compiler warnings:

eta.c: In function 'calc_thread_status':
eta.c:510:7: error: taking address of packed member of 'struct jobs_eta' may result in an unaligned pointer value [-Werror=address-of-packed-member]
  510 |     je->rate);
      |     ~~^~~~~~
eta.c:522:66: error: taking address of packed member of 'struct jobs_eta' may result in an unaligned pointer value [-Werror=address-of-packed-member]
  522 |  calc_rate(unified_rw_rep, disp_time, io_bytes, disp_io_bytes, je->rate);
      |                                                                ~~^~~~~~
eta.c:523:64: error: taking address of packed member of 'struct jobs_eta' may result in an unaligned pointer value [-Werror=address-of-packed-member]
  523 |  calc_iops(unified_rw_rep, disp_time, io_iops, disp_io_iops, je->iops);
      |

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 stat.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/stat.h b/stat.h
index e9551381ce7b..c6353c70ae08 100644
--- a/stat.h
+++ b/stat.h
@@ -260,10 +260,11 @@ struct jobs_eta {
 
 	uint64_t m_rate[DDIR_RWDIR_CNT], t_rate[DDIR_RWDIR_CNT];
 	uint64_t rate[DDIR_RWDIR_CNT];
-	uint32_t m_iops[DDIR_RWDIR_CNT], t_iops[DDIR_RWDIR_CNT];
-	uint32_t iops[DDIR_RWDIR_CNT];
-	uint64_t elapsed_sec;
-	uint64_t eta_sec;
+	uint32_t m_iops[DDIR_RWDIR_CNT] __attribute__((packed));
+	uint32_t t_iops[DDIR_RWDIR_CNT] __attribute__((packed));
+	uint32_t iops[DDIR_RWDIR_CNT] __attribute__((packed));
+	uint64_t elapsed_sec __attribute__((packed));
+	uint64_t eta_sec __attribute__((packed));
 	uint32_t is_pow2;
 	uint32_t unit_base;
 
@@ -276,7 +277,7 @@ struct jobs_eta {
 	 */
 	uint32_t nr_threads;
 	uint8_t run_str[];
-} __attribute__((packed));
+};
 
 struct io_u_plat_entry {
 	struct flist_head list;
-- 
2.22.0


