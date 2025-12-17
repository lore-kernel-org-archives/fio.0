Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B72D30FF33
	for <fio@vger.kernel.org>; Wed, 17 Dec 2025 16:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765988254; cv=none; b=M3AA7EX2S+pWu216BaK9QUgsY+Hs8SQEDksQLhtFV/PhXABDYPXOWxMs3v+iudWYZEKBBEvbfJs5/WgOkwQEQ9XMq1XJRAM0cJ5qCjS3COCR49aH6dANjuEbck6UCTnZfmqrg8yX3TnYED/MY2CsYMNC6y0nQvEMyEkUcnEUvoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765988254; c=relaxed/simple;
	bh=UlrqpX6kE1R8oEY0l0steyKE4HGJocUPet7ijuzI9P4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gx2JGsezvB1s0Pd988xxqkCi3Cxgu7SyZmNKJtCtDjv9+ooj1rVzriBa9xYEtV/E+5NFBMFHX7F9fKPjF7r0b1EguFTAdrjc4t2IsEnCMuSqFQRyKbQ5SdUOSf5f/1+E3pM7WEE5UN4p8UTovIa1YzsjfcnDMyp1j+MSTMdqYSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=E1gKsrKP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mncA5WnS; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YWRRV3ri; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bL7xs6Ba; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="E1gKsrKP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mncA5WnS";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YWRRV3ri";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bL7xs6Ba"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D4272336B6;
	Wed, 17 Dec 2025 16:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765988247; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B3q9MavBVYEFFfASvyLsOPccI0iL/r5rJHuBPU29GuA=;
	b=E1gKsrKPgABHwfouWdg8gJKXFgLRXE9RxI/nTiYf8ybmmS5YTZgEQ5vhUb09AouEbeislZ
	Zo5nTWrVQrnWHGkoui941u2+IDWkjkyK5U/CePD7lPpmf6/ev+lfkaBajrbh14bLcw2Bb/
	ifgnud6WTE8rdpWMdWZDE2BmJxPqtTs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765988247;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B3q9MavBVYEFFfASvyLsOPccI0iL/r5rJHuBPU29GuA=;
	b=mncA5WnSfOBsQ3HCDRBexKeFGICwQX0NSpn/z21Q+WxchrG7byclaykVoFoyeck/1CH1UQ
	l1Wa3tsul1NBBmAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765988246; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B3q9MavBVYEFFfASvyLsOPccI0iL/r5rJHuBPU29GuA=;
	b=YWRRV3rimMdyd4qjJTJoGyze7RYoFLVSZ4utKhD1sf84kUtTma2TgtR+atHXt0qhJEU+ED
	C0/LFKZ9cZMRDwylopZIqD37ke7pXT6QwxXQyMzXT599W0eV9jeXoehdMddylUsZqgGtTn
	JiZ9tPO7IODJc8uj1YpFNDUZdDsexJs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765988246;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B3q9MavBVYEFFfASvyLsOPccI0iL/r5rJHuBPU29GuA=;
	b=bL7xs6BanUFsW4yJs9GYhIZkFU7pyP7mg9B1W/KgWRvmGBftoeT7wLmTk8BxSzAraJkWQ4
	EsojEL6sAtcYp1BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C10F73EA67;
	Wed, 17 Dec 2025 16:17:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id G/JvLpbXQmnxcAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 17 Dec 2025 16:17:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 287E1A08CC; Wed, 17 Dec 2025 17:17:22 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 1/5] time: rename in_ramp_time() and ramp_time_over()
Date: Wed, 17 Dec 2025 17:17:11 +0100
Message-ID: <20251217161722.6357-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251217160217.15533-1-jack@suse.cz>
References: <20251217160217.15533-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com,suse.cz];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

Rename in_ramp_time() and ramp_time_over() to in_ramp_period() and
ramp_period_over() respectively. We will be adding other not time-based
methods for determining whether the load is ramping up so the old names
would be confusing.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 backend.c  | 12 ++++++------
 eta.c      |  6 +++---
 fio.h      |  2 +-
 fio_time.h |  4 ++--
 io_u.c     |  4 ++--
 stat.c     |  2 +-
 time.c     | 14 +++++++-------
 7 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/backend.c b/backend.c
index 13c77552a1ed..1e4c4a38369c 100644
--- a/backend.c
+++ b/backend.c
@@ -298,7 +298,7 @@ static inline void update_ts_cache(struct thread_data *td)
 
 static inline bool runtime_exceeded(struct thread_data *td, struct timespec *t)
 {
-	if (in_ramp_time(td))
+	if (in_ramp_period(td))
 		return false;
 	if (!td->o.timeout)
 		return false;
@@ -1031,7 +1031,7 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 	for (i = 0; i < DDIR_RWDIR_CNT; i++)
 		bytes_done[i] = td->bytes_done[i];
 
-	if (in_ramp_time(td))
+	if (in_ramp_period(td))
 		td_set_runstate(td, TD_RAMP);
 	else
 		td_set_runstate(td, TD_RUNNING);
@@ -1162,7 +1162,7 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 			else
 				io_u->end_io = verify_io_u;
 			td_set_runstate(td, TD_VERIFYING);
-		} else if (in_ramp_time(td))
+		} else if (in_ramp_period(td))
 			td_set_runstate(td, TD_RAMP);
 		else
 			td_set_runstate(td, TD_RUNNING);
@@ -1232,7 +1232,7 @@ reap:
 		    !td_ioengine_flagged(td, FIO_NOIO))
 			continue;
 
-		if (!in_ramp_time(td) && should_check_rate(td)) {
+		if (!in_ramp_period(td) && should_check_rate(td)) {
 			if (check_min_rate(td, &comp_time)) {
 				if (exitall_on_terminate || td->o.exitall_error)
 					fio_terminate_threads(td->groupid, td->o.exit_what);
@@ -1240,7 +1240,7 @@ reap:
 				break;
 			}
 		}
-		if (!in_ramp_time(td) && td->o.latency_target)
+		if (!in_ramp_period(td) && td->o.latency_target)
 			lat_target_check(td);
 	}
 
@@ -2673,7 +2673,7 @@ reap:
 			if (td->runstate != TD_INITIALIZED)
 				continue;
 
-			if (in_ramp_time(td))
+			if (in_ramp_period(td))
 				td_set_runstate(td, TD_RAMP);
 			else
 				td_set_runstate(td, TD_RUNNING);
diff --git a/eta.c b/eta.c
index 16109510067b..947752b9dc17 100644
--- a/eta.c
+++ b/eta.c
@@ -274,12 +274,12 @@ static unsigned long thread_eta(struct thread_data *td)
 			uint64_t ramp_time = td->o.ramp_time;
 
 			t_eta = __timeout + start_delay;
-			if (!td->ramp_time_over) {
+			if (!td->ramp_period_over) {
 				t_eta += ramp_time;
 			}
 			t_eta /= 1000000ULL;
 
-			if ((td->runstate == TD_RAMP) && in_ramp_time(td)) {
+			if ((td->runstate == TD_RAMP) && in_ramp_period(td)) {
 				unsigned long ramp_left;
 
 				ramp_left = mtime_since_now(&td->epoch);
@@ -522,7 +522,7 @@ static bool calc_thread_status(struct jobs_eta *je, int force)
 
 	any_td_in_ramp = false;
 	for_each_td(td) {
-		any_td_in_ramp |= in_ramp_time(td);
+		any_td_in_ramp |= in_ramp_period(td);
 	} end_for_each();
 	if (write_bw_log && rate_time > bw_avg_time && !any_td_in_ramp) {
 		calc_rate(unified_rw_rep, rate_time, io_bytes, rate_io_bytes,
diff --git a/fio.h b/fio.h
index 037678d182b8..87c20803a929 100644
--- a/fio.h
+++ b/fio.h
@@ -417,7 +417,7 @@ struct thread_data {
 	struct timespec terminate_time;
 	unsigned int ts_cache_nr;
 	unsigned int ts_cache_mask;
-	bool ramp_time_over;
+	bool ramp_period_over;
 
 	/*
 	 * Time since last latency_window was started
diff --git a/fio_time.h b/fio_time.h
index 969ad68d5b9c..30de7aca4fb1 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -27,8 +27,8 @@ extern uint64_t usec_spin(unsigned int);
 extern uint64_t usec_sleep(struct thread_data *, unsigned long);
 extern void fill_start_time(struct timespec *);
 extern void set_genesis_time(void);
-extern bool ramp_time_over(struct thread_data *);
-extern bool in_ramp_time(struct thread_data *);
+extern bool ramp_period_over(struct thread_data *);
+extern bool in_ramp_period(struct thread_data *);
 extern void fio_time_init(void);
 extern void timespec_add_msec(struct timespec *, unsigned int);
 extern void set_epoch_time(struct thread_data *, clockid_t, clockid_t);
diff --git a/io_u.c b/io_u.c
index ec3f668cae49..be0a0555098f 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2106,7 +2106,7 @@ static void file_log_write_comp(const struct thread_data *td, struct fio_file *f
 
 static bool should_account(struct thread_data *td)
 {
-	return ramp_time_over(td) && (td->runstate == TD_RUNNING ||
+	return ramp_period_over(td) && (td->runstate == TD_RUNNING ||
 					   td->runstate == TD_VERIFYING);
 }
 
@@ -2333,7 +2333,7 @@ int io_u_queued_complete(struct thread_data *td, int min_evts)
  */
 void io_u_queued(struct thread_data *td, struct io_u *io_u)
 {
-	if (!td->o.disable_slat && ramp_time_over(td) && td->o.stats) {
+	if (!td->o.disable_slat && ramp_period_over(td) && td->o.stats) {
 		if (td->parent)
 			td = td->parent;
 		add_slat_sample(td, io_u);
diff --git a/stat.c b/stat.c
index a67d35514d1a..c7c0f2f4a3ef 100644
--- a/stat.c
+++ b/stat.c
@@ -3626,7 +3626,7 @@ static int add_iops_samples(struct thread_data *td, struct timespec *t)
 
 static bool td_in_logging_state(struct thread_data *td)
 {
-	if (in_ramp_time(td))
+	if (in_ramp_period(td))
 		return false;
 
 	switch(td->runstate) {
diff --git a/time.c b/time.c
index 7f85c8de3bcb..9625e8cd92af 100644
--- a/time.c
+++ b/time.c
@@ -110,31 +110,31 @@ uint64_t utime_since_genesis(void)
 	return utime_since_now(&genesis);
 }
 
-bool in_ramp_time(struct thread_data *td)
+bool in_ramp_period(struct thread_data *td)
 {
-	return td->o.ramp_time && !td->ramp_time_over;
+	return td->o.ramp_time && !td->ramp_period_over;
 }
 
 static bool parent_update_ramp(struct thread_data *td)
 {
 	struct thread_data *parent = td->parent;
 
-	if (!parent || parent->ramp_time_over)
+	if (!parent || parent->ramp_period_over)
 		return false;
 
 	reset_all_stats(parent);
-	parent->ramp_time_over = true;
+	parent->ramp_period_over = true;
 	td_set_runstate(parent, TD_RAMP);
 	return true;
 }
 
-bool ramp_time_over(struct thread_data *td)
+bool ramp_period_over(struct thread_data *td)
 {
-	if (!td->o.ramp_time || td->ramp_time_over)
+	if (!td->o.ramp_time || td->ramp_period_over)
 		return true;
 
 	if (utime_since_now(&td->epoch) >= td->o.ramp_time) {
-		td->ramp_time_over = true;
+		td->ramp_period_over = true;
 		reset_all_stats(td);
 		reset_io_stats(td);
 		td_set_runstate(td, TD_RAMP);
-- 
2.51.0

