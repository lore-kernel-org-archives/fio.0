Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D82479873
	for <fio@vger.kernel.org>; Sat, 12 Sep 2026 12:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214422; cv=none; b=BWlyBxdEK9VgrOBnIrV45wQW1htj0IUxykL42fgenRvW/pZzxyQxgBuMp9+4m0w/QNVysxGjDU5n9ddtFsowOueP+dOYGtTBLkjO0Y1Ras2xRNo/NqDRLITM93PtV4W1wQ21m/weZ5iVdWYvzjgeH34TiM+Haki0xE4zxR73V6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214422; c=relaxed/simple;
	bh=EMeF2UhDkW3s5VuA+Eppy+SMA4QVhuTYjgABmOH0iA8=;
	h=Subject:From:To:Date:Message-Id; b=iA05bda9I89ERjfZ6nzX3xqiZgDoZbY3IrOP50WVuARii30hLaXM2/v1iedn578HS3MtFwTTeUWgioM1kHncMGH+S1qwkDJgjX8MS6iyIEZwHexn8mdNqREW25/2GHJ955R9nr8JHDmN57GXkGZ8A8/j5y1jPPBdNOtOq5x8vvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ct18v7uH; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ct18v7uH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=8kgbddlKu9nmK18huSoQzxgBGEHYKdkZbliuEb710Pg=; b=Ct18v7uHDvKrzEHC4q7ODs/z+T
	i/uKM/6+24/Hnp79Xh/ACHiW/ogddmvTaJx9AKV21F1+P4MzjlVu/UslCIFT1CX5weuRsCg18LKTI
	9NRZG6702ui7ivOWquYvBkgHKbuWS2D6+2CQBPTZ1OtqIhSoAFQkvc1x/dQthBkQc2nUfvV9FlGeV
	wPn8HbMzcPnEsIBTxVImzq+ZIofXGgvbePvXezbqH+tuDyBgfwUsqpMaETfEIEk41+xA7FwXAg1bl
	v2KWweHHD7sghSZJreNpJq1u9yLLjLdaQeP87hbfu5SaH1HuL6ZxrX+myK+px9JRma51Z+7DdsBTn
	2Sj42KWQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x5MOr-00000004OLy-31kq
	for fio@vger.kernel.org;
	Sat, 12 Sep 2026 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 863711BC0154; Sat, 12 Sep 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Sat, 12 Sep 2026 06:00:01 -0600
Message-Id: <20260912120001.863711BC0154@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit ac6ae485e6003b2a9999540c4e3e65780f1e6660:

  Merge branch 'inconsistent_parameter_type_in_convert_agg_kbytes_percent' of https://github.com/dennischerchang/fio (2026-09-09 14:18:37 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6bc57a931f04fa3f50348d8c8f087187f050c6e1:

  eta: remove now unused done_secs (2026-09-11 14:41:56 -0400)

----------------------------------------------------------------
Keith Busch (4):
      eta: count a job that is setting up as running
      backend: don't mark a job as running before it has set up
      eta: cap the ETA at the job's own remaining runtime
      eta: remove now unused done_secs

 backend.c | 23 ++++++++++++++++-------
 eta.c     | 20 +++++++++++++++-----
 fio.h     |  1 -
 libfio.c  |  4 ++--
 4 files changed, 33 insertions(+), 15 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 2b419b12..88557f0b 100644
--- a/backend.c
+++ b/backend.c
@@ -71,7 +71,6 @@ unsigned int nr_segments = 0;
 unsigned int cur_segment = 0;
 unsigned int stat_number = 0;
 int temp_stall_ts;
-unsigned long done_secs = 0;
 #ifdef PTHREAD_ERRORCHECK_MUTEX_INITIALIZER_NP
 pthread_mutex_t overlap_check = PTHREAD_ERRORCHECK_MUTEX_INITIALIZER_NP;
 #else
@@ -2180,6 +2179,17 @@ static void *thread_main(void *data)
 		goto err;
 
 	set_epoch_time(td, o->log_alternate_epoch_clock_id, o->job_start_clock_id);
+
+	/*
+	 * Setup is done and the job now has an epoch to measure itself
+	 * against, so it is finally safe to call it running. Everything
+	 * above this point ran as TD_SETTING_UP.
+	 */
+	if (in_ramp_period(td))
+		td_set_runstate(td, TD_RAMP);
+	else
+		td_set_runstate(td, TD_RUNNING);
+
 	fio_getrusage(&td->ru_start);
 	memcpy(&td->bw_sample_time, &td->epoch, sizeof(td->epoch));
 	memcpy(&td->iops_sample_time, &td->epoch, sizeof(td->epoch));
@@ -2499,7 +2509,6 @@ reaped:
 		if (td->error)
 			exit_value++;
 
-		done_secs += mtime_since_now(&td->epoch) / 1000;
 		profile_td_exit(td);
 		flow_exit_job(td);
 	} end_for_each();
@@ -2893,16 +2902,16 @@ reap:
 		}
 
 		/*
-		 * start created threads (TD_INITIALIZED -> TD_RUNNING).
+		 * start created threads (TD_INITIALIZED -> TD_SETTING_UP).
+		 * The job has plenty of setup left to do before it issues any
+		 * IO, so it promotes itself to TD_RAMP or TD_RUNNING once that
+		 * is done and it has recorded its epoch.
 		 */
 		for_each_td(td) {
 			if (td->runstate != TD_INITIALIZED)
 				continue;
 
-			if (in_ramp_period(td))
-				td_set_runstate(td, TD_RAMP);
-			else
-				td_set_runstate(td, TD_RUNNING);
+			td_set_runstate(td, TD_SETTING_UP);
 			nr_running++;
 			nr_started--;
 			m_rate += ddir_rw_sum(td->o.ratemin);
diff --git a/eta.c b/eta.c
index c6e3cffb..d17b8c3f 100644
--- a/eta.c
+++ b/eta.c
@@ -253,9 +253,18 @@ static unsigned long thread_eta(struct thread_data *td)
 			eta_sec = (unsigned long) (elapsed * (1.0 / perc)) - elapsed;
 		}
 
-		if (td->o.timeout &&
-		    eta_sec > (timeout + done_secs - elapsed))
-			eta_sec = timeout + done_secs - elapsed;
+		/*
+		 * A job never runs for longer than its own timeout, which is
+		 * measured from its own epoch. Cap the estimate at whatever
+		 * time this job has left.
+		 */
+		if (td->o.timeout) {
+			unsigned long timeout_left;
+
+			timeout_left = timeout > elapsed ? timeout - elapsed : 0;
+			if (eta_sec > timeout_left)
+				eta_sec = timeout_left;
+		}
 	} else if (td->runstate == TD_NOT_CREATED || td->runstate == TD_CREATED
 			|| td->runstate == TD_INITIALIZED
 			|| td->runstate == TD_SETTING_UP
@@ -466,9 +475,10 @@ static bool calc_thread_status(struct jobs_eta *je, int force)
 		} else if (td->runstate == TD_RAMP) {
 			je->nr_running++;
 			je->nr_ramp++;
-		} else if (td->runstate == TD_SETTING_UP)
+		} else if (td->runstate == TD_SETTING_UP) {
+			je->nr_running++;
 			je->nr_setting_up++;
-		else if (td->runstate < TD_RUNNING)
+		} else if (td->runstate < TD_RUNNING)
 			je->nr_pending++;
 
 		if (je->elapsed_sec >= 3)
diff --git a/fio.h b/fio.h
index d96ad4d0..84d46414 100644
--- a/fio.h
+++ b/fio.h
@@ -598,7 +598,6 @@ extern bool read_only;
 extern int eta_print;
 extern int eta_new_line;
 extern unsigned int eta_interval_msec;
-extern unsigned long done_secs;
 extern int fio_gtod_offload;
 extern int fio_gtod_cpu;
 extern enum fio_cs fio_clock_source;
diff --git a/libfio.c b/libfio.c
index 37f2c749..aff131ff 100644
--- a/libfio.c
+++ b/libfio.c
@@ -188,7 +188,6 @@ void reset_fio_state(void)
 	for (i = 0; i < nr_segments; i++)
 		segments[i].nr_threads = 0;
 	stat_number = 0;
-	done_secs = 0;
 }
 
 const char *fio_get_os_string(int nr)
@@ -271,7 +270,8 @@ void fio_terminate_threads(unsigned int group_id, unsigned int terminate)
 	for_each_td(td) {
 		if ((terminate == TERMINATE_GROUP && group_id == TERMINATE_ALL) ||
 		    (terminate == TERMINATE_GROUP && group_id == td->groupid) ||
-		    (terminate == TERMINATE_STONEWALL && td->runstate >= TD_RUNNING) ||
+		    (terminate == TERMINATE_STONEWALL &&
+		     td->runstate >= TD_SETTING_UP) ||
 		    (terminate == TERMINATE_ALL)) {
 			dprint(FD_PROCESS, "setting terminate on %s/%d\n",
 						td->o.name, (int) td->pid);
