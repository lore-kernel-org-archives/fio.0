Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E94320CA8
	for <fio@vger.kernel.org>; Fri, 19 Dec 2025 13:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766151797; cv=none; b=gAMofPIQke/PYwOGXzrwwx02qa1khoYtNSgBI63UUri8zK6u3HZp2xTJEpbZ1iXfjeZBQcBJqYRgl01OW/Jlqf6P4WpS0+o9VCrl47qZ1AtbXc3ZLiUVhsf8K7HfqQkLWlpPLPFVTdDcu9hULC7fSpoFVarReJzDzXBoHKADFco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766151797; c=relaxed/simple;
	bh=GABBJrjvj/BOYCAl2lKX5DRVajAoBBws+gfY9SiG6G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGgBejVlsLASBU6hlVVAoLYBH6ilJwHuUqvKhixLoDj2AZES5l8EK3C0WVikGvKcb0xICb3YmZ/5xAQgyqByJQI+Ke5iyAAU37bOYW/3iJaQpabBMr3NDgy8JrM0C/XmR5U+VsrybnGn07lV4NV/I1/StKgj6pTe/jhCdfcmNL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Fl/F20+I; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bdw9W6aN; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Fl/F20+I; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bdw9W6aN; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Fl/F20+I";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bdw9W6aN";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Fl/F20+I";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bdw9W6aN"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4C8945BD3A;
	Fri, 19 Dec 2025 13:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766151783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UPpJA45NJSM0ZJxxB16u24rOoBXzQdd+QiG83INwCYY=;
	b=Fl/F20+I0m8U54TFbD7PFNNlmguko4C0FzYxLL1o34eS1sIy+9u+BRRDLBhfXRBioXBU0Q
	lkiGv1yoYvQcjaYiZvbDOfq23ThwCCU9Vt73si43lrhrNXaSUS9HGZTPd9tSB62fQu0xGd
	omdrQQ5NUmv4BO2YMrnTyGmmTTL5AXQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766151783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UPpJA45NJSM0ZJxxB16u24rOoBXzQdd+QiG83INwCYY=;
	b=bdw9W6aN2ARQ5OARWcsyWYXJJrqlEeKJScj6Z7sH07GjFoLfcUWtABNZ4m7qg0+MjOYolo
	ZMmwEhHCPYGgbfDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766151783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UPpJA45NJSM0ZJxxB16u24rOoBXzQdd+QiG83INwCYY=;
	b=Fl/F20+I0m8U54TFbD7PFNNlmguko4C0FzYxLL1o34eS1sIy+9u+BRRDLBhfXRBioXBU0Q
	lkiGv1yoYvQcjaYiZvbDOfq23ThwCCU9Vt73si43lrhrNXaSUS9HGZTPd9tSB62fQu0xGd
	omdrQQ5NUmv4BO2YMrnTyGmmTTL5AXQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766151783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UPpJA45NJSM0ZJxxB16u24rOoBXzQdd+QiG83INwCYY=;
	b=bdw9W6aN2ARQ5OARWcsyWYXJJrqlEeKJScj6Z7sH07GjFoLfcUWtABNZ4m7qg0+MjOYolo
	ZMmwEhHCPYGgbfDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3BB013EA66;
	Fri, 19 Dec 2025 13:43:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QKBFDmdWRWmiMQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 19 Dec 2025 13:43:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E8F81A0918; Fri, 19 Dec 2025 14:42:47 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: Vincent Fu <vincentfu@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	fio@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH v2 1/5] time: rename in_ramp_time() and ramp_time_over()
Date: Fri, 19 Dec 2025 14:42:35 +0100
Message-ID: <20251219134247.14195-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251219133853.8548-1-jack@suse.cz>
References: <20251219133853.8548-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

Rename in_ramp_time() and ramp_time_over() to in_ramp_period() and
ramp_period_over() respectively. We will be adding other not time-based
methods for determining whether the load is ramping up so the old names
would be confusing.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
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

