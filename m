Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06DD2C433FE
	for <fio@archiver.kernel.org>; Wed, 16 Feb 2022 13:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbiBPNAV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 16 Feb 2022 08:00:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbiBPNAU (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 16 Feb 2022 08:00:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229852A7942
        for <fio@vger.kernel.org>; Wed, 16 Feb 2022 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=OtbjbDWxPt9e8DsP/jmf+SThNqX64PO5w0qoiRVFUXg=; b=DgfDuhw8QGPW8ElwL+ZP10jb6p
        zZdZdyZ3SrPX6qIg0IWkVEPHFSzkFxPrCwmY3GulERbA8n5Ot9Z/xuIXaWD3OWt3qyW58du1Q6NKe
        aRw0DFRVle7xtvlyuZMixO3/2y7pJYvc86FkndEwgRXmdFTBigL+IiiPN4Nyx/V00SHXGx0O+/9ji
        hlKG+faLPbj9foW38PBvAzNekzzrfQ8xwqXD2LWngg/bgKshozn1urfx7cn9nvC0rhQUvcauy2PlM
        SFzo6EVtNOO2ihLm33S+xshBLjDeyLLAZ98+jLPqzaUpTkxEWqIBK5TOOkfrZIQk+ZEyKLYh8veHS
        0EcvZLdw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nKJue-00Eiyk-Uz
        for fio@vger.kernel.org; Wed, 16 Feb 2022 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 079081BC016E; Wed, 16 Feb 2022 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220216130002.079081BC016E@kernel.dk>
Date:   Wed, 16 Feb 2022 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit a1db4528a59a99c5e2aa66091c505fb60e3a70ca:

  Merge branch 'fio-docs-ci' of https://github.com/vincentkfu/fio (2022-02-11 16:29:44 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6a16e9e9531a5f746c4e2fe43873de1db434b4fc:

  diskutil: include limits.h for PATH_MAX (2022-02-15 17:17:30 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      Merge branch 'fix_bytesrate_eta' of https://github.com/PCPartPicker/fio
      Merge branch 'rand_nr_bugfix' of https://github.com/PCPartPicker/fio
      Merge branch 'check_min_rate_cleanup' of https://github.com/PCPartPicker/fio
      diskutil: include limits.h for PATH_MAX

Vincent Fu (1):
      ci: detect Windows installer build failures

aggieNick02 (3):
      Cleanup __check_min_rate
      Fix ETA display when rate and/or rate_min are specified
      Fix :<nr> suffix with random read/write causing 0 initial offset

 .appveyor.yml |  1 +
 backend.c     | 81 ++++++++++++++++++++---------------------------------------
 diskutil.h    |  2 ++
 eta.c         |  5 ++--
 fio.h         |  6 ++---
 init.c        |  9 ++++++-
 libfio.c      |  4 +--
 7 files changed, 46 insertions(+), 62 deletions(-)

---

Diff of recent changes:

diff --git a/.appveyor.yml b/.appveyor.yml
index 42b79958..b94eefe3 100644
--- a/.appveyor.yml
+++ b/.appveyor.yml
@@ -44,6 +44,7 @@ after_build:
   - file.exe fio.exe
   - make.exe test
   - 'cd os\windows && dobuild.cmd %ARCHITECTURE% && cd ..'
+  - ls.exe ./os/windows/*.msi
   - ps: Get-ChildItem .\os\windows\*.msi | % { Push-AppveyorArtifact $_.FullName -FileName $_.Name -DeploymentName fio.msi }
 
 test_script:
diff --git a/backend.c b/backend.c
index c035baed..a21dfef6 100644
--- a/backend.c
+++ b/backend.c
@@ -136,13 +136,10 @@ static void set_sig_handlers(void)
 static bool __check_min_rate(struct thread_data *td, struct timespec *now,
 			     enum fio_ddir ddir)
 {
-	unsigned long long bytes = 0;
-	unsigned long iops = 0;
-	unsigned long spent;
-	unsigned long long rate;
-	unsigned long long ratemin = 0;
-	unsigned int rate_iops = 0;
-	unsigned int rate_iops_min = 0;
+	unsigned long long current_rate_check_bytes = td->this_io_bytes[ddir];
+	unsigned long current_rate_check_blocks = td->this_io_blocks[ddir];
+	unsigned long long option_rate_bytes_min = td->o.ratemin[ddir];
+	unsigned int option_rate_iops_min = td->o.rate_iops_min[ddir];
 
 	assert(ddir_rw(ddir));
 
@@ -155,68 +152,44 @@ static bool __check_min_rate(struct thread_data *td, struct timespec *now,
 	if (mtime_since(&td->start, now) < 2000)
 		return false;
 
-	iops += td->this_io_blocks[ddir];
-	bytes += td->this_io_bytes[ddir];
-	ratemin += td->o.ratemin[ddir];
-	rate_iops += td->o.rate_iops[ddir];
-	rate_iops_min += td->o.rate_iops_min[ddir];
-
 	/*
-	 * if rate blocks is set, sample is running
+	 * if last_rate_check_blocks or last_rate_check_bytes is set,
+	 * we can compute a rate per ratecycle
 	 */
-	if (td->rate_bytes[ddir] || td->rate_blocks[ddir]) {
-		spent = mtime_since(&td->lastrate[ddir], now);
-		if (spent < td->o.ratecycle)
+	if (td->last_rate_check_bytes[ddir] || td->last_rate_check_blocks[ddir]) {
+		unsigned long spent = mtime_since(&td->last_rate_check_time[ddir], now);
+		if (spent < td->o.ratecycle || spent==0)
 			return false;
 
-		if (td->o.rate[ddir] || td->o.ratemin[ddir]) {
+		if (td->o.ratemin[ddir]) {
 			/*
 			 * check bandwidth specified rate
 			 */
-			if (bytes < td->rate_bytes[ddir]) {
-				log_err("%s: rate_min=%lluB/s not met, only transferred %lluB\n",
-					td->o.name, ratemin, bytes);
+			unsigned long long current_rate_bytes =
+				((current_rate_check_bytes - td->last_rate_check_bytes[ddir]) * 1000) / spent;
+			if (current_rate_bytes < option_rate_bytes_min) {
+				log_err("%s: rate_min=%lluB/s not met, got %lluB/s\n",
+					td->o.name, option_rate_bytes_min, current_rate_bytes);
 				return true;
-			} else {
-				if (spent)
-					rate = ((bytes - td->rate_bytes[ddir]) * 1000) / spent;
-				else
-					rate = 0;
-
-				if (rate < ratemin ||
-				    bytes < td->rate_bytes[ddir]) {
-					log_err("%s: rate_min=%lluB/s not met, got %lluB/s\n",
-						td->o.name, ratemin, rate);
-					return true;
-				}
 			}
 		} else {
 			/*
 			 * checks iops specified rate
 			 */
-			if (iops < rate_iops) {
-				log_err("%s: rate_iops_min=%u not met, only performed %lu IOs\n",
-						td->o.name, rate_iops, iops);
+			unsigned long long current_rate_iops =
+				((current_rate_check_blocks - td->last_rate_check_blocks[ddir]) * 1000) / spent;
+
+			if (current_rate_iops < option_rate_iops_min) {
+				log_err("%s: rate_iops_min=%u not met, got %llu IOPS\n",
+					td->o.name, option_rate_iops_min, current_rate_iops);
 				return true;
-			} else {
-				if (spent)
-					rate = ((iops - td->rate_blocks[ddir]) * 1000) / spent;
-				else
-					rate = 0;
-
-				if (rate < rate_iops_min ||
-				    iops < td->rate_blocks[ddir]) {
-					log_err("%s: rate_iops_min=%u not met, got %llu IOPS\n",
-						td->o.name, rate_iops_min, rate);
-					return true;
-				}
 			}
 		}
 	}
 
-	td->rate_bytes[ddir] = bytes;
-	td->rate_blocks[ddir] = iops;
-	memcpy(&td->lastrate[ddir], now, sizeof(*now));
+	td->last_rate_check_bytes[ddir] = current_rate_check_bytes;
+	td->last_rate_check_blocks[ddir] = current_rate_check_blocks;
+	memcpy(&td->last_rate_check_time[ddir], now, sizeof(*now));
 	return false;
 }
 
@@ -1845,11 +1818,11 @@ static void *thread_main(void *data)
 
 	if (o->ratemin[DDIR_READ] || o->ratemin[DDIR_WRITE] ||
 			o->ratemin[DDIR_TRIM]) {
-	        memcpy(&td->lastrate[DDIR_READ], &td->bw_sample_time,
+	        memcpy(&td->last_rate_check_time[DDIR_READ], &td->bw_sample_time,
 					sizeof(td->bw_sample_time));
-	        memcpy(&td->lastrate[DDIR_WRITE], &td->bw_sample_time,
+	        memcpy(&td->last_rate_check_time[DDIR_WRITE], &td->bw_sample_time,
 					sizeof(td->bw_sample_time));
-	        memcpy(&td->lastrate[DDIR_TRIM], &td->bw_sample_time,
+	        memcpy(&td->last_rate_check_time[DDIR_TRIM], &td->bw_sample_time,
 					sizeof(td->bw_sample_time));
 	}
 
diff --git a/diskutil.h b/diskutil.h
index 83bcbf89..7d7ef802 100644
--- a/diskutil.h
+++ b/diskutil.h
@@ -2,6 +2,8 @@
 #define FIO_DISKUTIL_H
 #define FIO_DU_NAME_SZ		64
 
+#include <limits.h>
+
 #include "helper_thread.h"
 #include "fio_sem.h"
 
diff --git a/eta.c b/eta.c
index ea1781f3..17970c78 100644
--- a/eta.c
+++ b/eta.c
@@ -420,6 +420,7 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 		if (is_power_of_2(td->o.kb_base))
 			je->is_pow2 = 1;
 		je->unit_base = td->o.unit_base;
+		je->sig_figs = td->o.sig_figs;
 		if (td->o.bw_avg_time < bw_avg_time)
 			bw_avg_time = td->o.bw_avg_time;
 		if (td->runstate == TD_RUNNING || td->runstate == TD_VERIFYING
@@ -600,9 +601,9 @@ void display_thread_status(struct jobs_eta *je)
 		char *tr, *mr;
 
 		mr = num2str(je->m_rate[0] + je->m_rate[1] + je->m_rate[2],
-				je->sig_figs, 0, je->is_pow2, N2S_BYTEPERSEC);
+				je->sig_figs, 1, je->is_pow2, N2S_BYTEPERSEC);
 		tr = num2str(je->t_rate[0] + je->t_rate[1] + je->t_rate[2],
-				je->sig_figs, 0, je->is_pow2, N2S_BYTEPERSEC);
+				je->sig_figs, 1, je->is_pow2, N2S_BYTEPERSEC);
 
 		p += sprintf(p, ", %s-%s", mr, tr);
 		free(tr);
diff --git a/fio.h b/fio.h
index 7b0ca843..88df117d 100644
--- a/fio.h
+++ b/fio.h
@@ -335,10 +335,10 @@ struct thread_data {
 	 */
 	uint64_t rate_bps[DDIR_RWDIR_CNT];
 	uint64_t rate_next_io_time[DDIR_RWDIR_CNT];
-	unsigned long long rate_bytes[DDIR_RWDIR_CNT];
-	unsigned long rate_blocks[DDIR_RWDIR_CNT];
+	unsigned long long last_rate_check_bytes[DDIR_RWDIR_CNT];
+	unsigned long last_rate_check_blocks[DDIR_RWDIR_CNT];
 	unsigned long long rate_io_issue_bytes[DDIR_RWDIR_CNT];
-	struct timespec lastrate[DDIR_RWDIR_CNT];
+	struct timespec last_rate_check_time[DDIR_RWDIR_CNT];
 	int64_t last_usec[DDIR_RWDIR_CNT];
 	struct frand_state poisson_state[DDIR_RWDIR_CNT];
 
diff --git a/init.c b/init.c
index 13935152..81c30f8c 100644
--- a/init.c
+++ b/init.c
@@ -1576,7 +1576,14 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	td->ts.sig_figs = o->sig_figs;
 
 	init_thread_stat_min_vals(&td->ts);
-	td->ddir_seq_nr = o->ddir_seq_nr;
+
+	/*
+	 * td->>ddir_seq_nr needs to be initialized to 1, NOT o->ddir_seq_nr,
+	 * so that get_next_offset gets a new random offset the first time it
+	 * is called, instead of keeping an initial offset of 0 for the first
+	 * nr-1 calls
+	 */
+	td->ddir_seq_nr = 1;
 
 	if ((o->stonewall || o->new_group) && prev_group_jobs) {
 		prev_group_jobs = 0;
diff --git a/libfio.c b/libfio.c
index 01fa7452..1a891776 100644
--- a/libfio.c
+++ b/libfio.c
@@ -87,8 +87,8 @@ static void reset_io_counters(struct thread_data *td, int all)
 			td->this_io_bytes[ddir] = 0;
 			td->stat_io_blocks[ddir] = 0;
 			td->this_io_blocks[ddir] = 0;
-			td->rate_bytes[ddir] = 0;
-			td->rate_blocks[ddir] = 0;
+			td->last_rate_check_bytes[ddir] = 0;
+			td->last_rate_check_blocks[ddir] = 0;
 			td->bytes_done[ddir] = 0;
 			td->rate_io_issue_bytes[ddir] = 0;
 			td->rate_next_io_time[ddir] = 0;
