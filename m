Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6990AC4332F
	for <fio@archiver.kernel.org>; Tue, 18 Oct 2022 04:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiJRERb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Oct 2022 00:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiJRER3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Oct 2022 00:17:29 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA2F97D65
        for <fio@vger.kernel.org>; Mon, 17 Oct 2022 21:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666066648; x=1697602648;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jz4cWKM+Udf2vHS87L1Kj2tiJXTm/Mf6QIIrm+jb4ig=;
  b=ooh5FPwlaWS3ObUJxtSy3mtjOg072g95qNUmN4PaVXaJeK7jfmXxIb0U
   a0zn3njuWjGz7ipFuiG8iQJlDIoWwuDhiL1RpKi2FAL+V6LKH+YFwv0YG
   rjY37hR4Uh/JqVrRZWyVqk1z8JZtJPiPxZY6DVGmXddb1Q/UVNVA2+Gd9
   vk/pemOib3BIl8/sYpV03+kNDlXzd8+KwxIoPlbfhf6udlzOELr+uzvAr
   bQAELtttg1SUUgcM2S1jAtYOJSwREWKlZD0hOV/aeTT0gk5jsQ5pNUew4
   VD0KzKA3y+C56csL92Yrg8xl4ylmbTgJ/PJD267gwxs3CGaECN9wYF2c5
   A==;
X-IronPort-AV: E=Sophos;i="5.95,193,1661788800"; 
   d="scan'208";a="214084025"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Oct 2022 12:17:28 +0800
IronPort-SDR: BMzYrdKXYrAnCJk+dBEfl7cKtUeuIKt51ffmvr3+y4gOwj05fk9SN4xAPZ7QkOVGnzg5TqabRd
 iwbBt7I2FTIJGggaEZif4/QNZeTyyHyewPlGQMuDEEZFOlcgj7CFcZBaMbD23xg73cK9xFvSfW
 rStq5OS7ptQp8XWJaa6x1fPV6eCk5Imxj7rzVsPxPBH2IyAlv/3fqyC/JUc4ERoCvH9hEvplSY
 Oy5PymOnv2UYMh9Hb451lfz7Jwq0yPi48xjsY5d7UelGyxrWEX65q7eoFqX0rD5Cl4rPqIEhBa
 G2l525xdPy+0eWe1NE4R1ueg
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Oct 2022 20:37:00 -0700
IronPort-SDR: itfvZURdThvhVYNhexCurnV864K6Em7M7ovTdTs5BVLdjQTfm9pUan2GrIQRt7DsBNhGJowiL3
 F9db5hn15OChxiekDxToB0oCibhTGgHtgds9OTZ+93GAEK5g5MiHST7IdcM64RcT0zZPz/2rb5
 iADCqbAy+KQs8UFX0gB0is340WJ0+V9+QNMUKd8Wz6hFVdQururghLDOpF9JPqeC6rIzQ0miZ2
 g6qqNb8Vq101NuXZRFBjyVNm03QMdobsCk4wfGzezyM1uyVye9eYFKvK2UuqOAIOToahZuYsdm
 L10=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 17 Oct 2022 21:17:27 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/4] verify: fix bytes_done accounting of experimental verify
Date:   Tue, 18 Oct 2022 13:17:22 +0900
Message-Id: <20221018041725.807940-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221018041725.807940-1-shinichiro.kawasaki@wdc.com>
References: <20221018041725.807940-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The commit 55312f9f5572 ("Add ->bytes_done[] to struct thread_data")
moved bytes_done[] on stack to struct thread_data. However, this unified
two bytes_done[] in do_io() and do_verify() stacks into single
td->bytes_done[]. This caused wrong condition check in do_verify() in
experimental verify path since td->bytes_done[] holds values for do_io()
not for do_verify(). This caused unexpected loop break in do_verify()
and verify read skip when experimental_verify=1 option is specified.

To fix this, add bytes_verified to struct thread_data for do_verify() in
same manner as bytes_done[] for do_io(). Introduce a helper function
io_u_update_bytes_done() to factor out same code for bytes_done[] and
bytes_verified[].

Fixes: 55312f9f5572 ("Add ->bytes_done[] to struct thread_data")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 backend.c     |  2 +-
 fio.h         |  1 +
 io_u.c        | 23 +++++++++++++++++------
 libfio.c      |  1 +
 rate-submit.c |  2 ++
 5 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/backend.c b/backend.c
index d8f4f2a5..15c6e0b3 100644
--- a/backend.c
+++ b/backend.c
@@ -682,7 +682,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 				break;
 			}
 		} else {
-			if (ddir_rw_sum(td->bytes_done) + td->o.rw_min_bs > verify_bytes)
+			if (td->bytes_verified + td->o.rw_min_bs > verify_bytes)
 				break;
 
 			while ((io_u = get_io_u(td)) != NULL) {
diff --git a/fio.h b/fio.h
index de7eca79..0592a4c3 100644
--- a/fio.h
+++ b/fio.h
@@ -370,6 +370,7 @@ struct thread_data {
 	uint64_t zone_bytes;
 	struct fio_sem *sem;
 	uint64_t bytes_done[DDIR_RWDIR_CNT];
+	uint64_t bytes_verified;
 
 	uint64_t *thinktime_blocks_counter;
 	struct timespec last_thinktime;
diff --git a/io_u.c b/io_u.c
index 91f1a358..8035f4b7 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2121,13 +2121,26 @@ static void ios_completed(struct thread_data *td,
 	}
 }
 
+static void io_u_update_bytes_done(struct thread_data *td,
+				   struct io_completion_data *icd)
+{
+	int ddir;
+
+	if (td->runstate == TD_VERIFYING) {
+		td->bytes_verified += icd->bytes_done[DDIR_READ];
+		return;
+	}
+
+	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
+		td->bytes_done[ddir] += icd->bytes_done[ddir];
+}
+
 /*
  * Complete a single io_u for the sync engines.
  */
 int io_u_sync_complete(struct thread_data *td, struct io_u *io_u)
 {
 	struct io_completion_data icd;
-	int ddir;
 
 	init_icd(td, &icd, 1);
 	io_completed(td, &io_u, &icd);
@@ -2140,8 +2153,7 @@ int io_u_sync_complete(struct thread_data *td, struct io_u *io_u)
 		return -1;
 	}
 
-	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
-		td->bytes_done[ddir] += icd.bytes_done[ddir];
+	io_u_update_bytes_done(td, &icd);
 
 	return 0;
 }
@@ -2153,7 +2165,7 @@ int io_u_queued_complete(struct thread_data *td, int min_evts)
 {
 	struct io_completion_data icd;
 	struct timespec *tvp = NULL;
-	int ret, ddir;
+	int ret;
 	struct timespec ts = { .tv_sec = 0, .tv_nsec = 0, };
 
 	dprint(FD_IO, "io_u_queued_complete: min=%d\n", min_evts);
@@ -2179,8 +2191,7 @@ int io_u_queued_complete(struct thread_data *td, int min_evts)
 		return -1;
 	}
 
-	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
-		td->bytes_done[ddir] += icd.bytes_done[ddir];
+	io_u_update_bytes_done(td, &icd);
 
 	return ret;
 }
diff --git a/libfio.c b/libfio.c
index 1a891776..ac521974 100644
--- a/libfio.c
+++ b/libfio.c
@@ -94,6 +94,7 @@ static void reset_io_counters(struct thread_data *td, int all)
 			td->rate_next_io_time[ddir] = 0;
 			td->last_usec[ddir] = 0;
 		}
+		td->bytes_verified = 0;
 	}
 
 	td->zone_bytes = 0;
diff --git a/rate-submit.c b/rate-submit.c
index 268356d1..2fe768c0 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -263,6 +263,8 @@ static void sum_ddir(struct thread_data *dst, struct thread_data *src,
 	sum_val(&dst->this_io_blocks[ddir], &src->this_io_blocks[ddir]);
 	sum_val(&dst->this_io_bytes[ddir], &src->this_io_bytes[ddir]);
 	sum_val(&dst->bytes_done[ddir], &src->bytes_done[ddir]);
+	if (ddir == DDIR_READ)
+		sum_val(&dst->bytes_verified, &src->bytes_verified);
 
 	pthread_double_unlock(&dst->io_wq.stat_lock, &src->io_wq.stat_lock);
 }
-- 
2.37.1

