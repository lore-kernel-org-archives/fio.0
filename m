Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AAA2FB97A
	for <fio@vger.kernel.org>; Fri, 19 Dec 2025 13:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766151788; cv=none; b=OblDJ1JwTryB3xGnfbampWGpEngWRo1Ozcipgr0l5Tp4u5f6+tfs7ETE8jl+4rRKXXTggE7pC1sykawJQqBaG7siyt7mz9cWokELws7Rz9DcUXQIm4LOtfvhtYC68RRxuIC6mSqxT76GDtj9x7MwsiC9rPpy95nsvaRvAL28ulw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766151788; c=relaxed/simple;
	bh=z7Iva171OM4yJygDM+ubdC+VOeezOh2UNNnXXc/IpIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvSahaytnnyYVEB35K1EuNdJua2K3SQJ/0jOTHDtqa5rw9yedmZbcYIgX9KhSjImIOa3lZ0i74a50EbPzncvDWwUJqIoJ8f3hqLNQNr41LL6IOVwSE7JT/xmPX4CLyOHsVZkw7JuWJTYurygRdgESzKSRgUFw9FBDdxPnbNIiJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DqklQJpD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=36ckuiX0; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FPv59a/5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vSjaKBwY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DqklQJpD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="36ckuiX0";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FPv59a/5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vSjaKBwY"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 52C4233729;
	Fri, 19 Dec 2025 13:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766151784; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WfDqFPKtnMRuKxBK6Miqz7KuWoi0kx57ejoOydNpxOE=;
	b=DqklQJpD1jBx/XvgUXjLTTDoqiYd5HJ8VSk4/j/Vc8MX2CtdxvqVtWDdrvEw3Db+Mh/DlU
	gqzvfeepygSU5lAQ0S1C9cMFRrq++5FPtyCKUGBMDm1MVAm+nqvDVg2lF6eULaqH1MZkY1
	wAe8PmwDpE+6OCFwEe2R1QvmXg0Ls48=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766151784;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WfDqFPKtnMRuKxBK6Miqz7KuWoi0kx57ejoOydNpxOE=;
	b=36ckuiX0PCf5l67q8oN1g+GgA0linHdZi3NH/A5yMJ508BCulxTyTqBJJDD18HaO+Frcv5
	8erbMSBeVcS4JyAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="FPv59a/5";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vSjaKBwY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766151783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WfDqFPKtnMRuKxBK6Miqz7KuWoi0kx57ejoOydNpxOE=;
	b=FPv59a/5hxpUncmlBqmlg7LM0fFyTRXH3NOnCKvEEvS5oQFOevF2wFrPBc+oKdvZjKtvVr
	0mSwvXXQgbEpvS64r8mNIaoXjONIMBsKkd1wOyjrpVgE/FjvIRRoXJUXN0oNAC75XInutP
	gDkBy2fEfwIvEALFQ9WXvipmQTtDLoA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766151783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WfDqFPKtnMRuKxBK6Miqz7KuWoi0kx57ejoOydNpxOE=;
	b=vSjaKBwYolwn9jTHuCOm7c/WjHdKuEc+hjsqeWiK234iw/ynCJkBZG5g+ZfLUUoM/Rupvg
	3+Pvj5gFYMTtxCCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 478E93EA68;
	Fri, 19 Dec 2025 13:43:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Yv14EWdWRWmpMQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 19 Dec 2025 13:43:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 07D8DA0A1B; Fri, 19 Dec 2025 14:42:48 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: Vincent Fu <vincentfu@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	fio@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH v2 4/5] time: Evaluate ramp up condition once per second
Date: Fri, 19 Dec 2025 14:42:38 +0100
Message-ID: <20251219134247.14195-4-jack@suse.cz>
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
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 52C4233729
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:mid,suse.cz:dkim,suse.cz:email];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

Instead of evaluating whether ramp up period has finished on each IO
submission and completion evaluate it once per second and set
appropriate state variable in thread_data. Later when ramp up period end
condition will be more complex and would involve stat data from all
threads, it would unnecessarily slow down IO.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fio.h           |  2 +-
 fio_time.h      |  5 ++++
 helper_thread.c |  8 +++++-
 time.c          | 66 +++++++++++++++++++++++++++++++++----------------
 4 files changed, 58 insertions(+), 23 deletions(-)

diff --git a/fio.h b/fio.h
index 87c20803a929..fdd36fa49c95 100644
--- a/fio.h
+++ b/fio.h
@@ -417,7 +417,7 @@ struct thread_data {
 	struct timespec terminate_time;
 	unsigned int ts_cache_nr;
 	unsigned int ts_cache_mask;
-	bool ramp_period_over;
+	unsigned int ramp_period_state;
 
 	/*
 	 * Time since last latency_window was started
diff --git a/fio_time.h b/fio_time.h
index c67c9450f484..54dad8c7812e 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -8,6 +8,10 @@
 /* IWYU pragma: end_exports */
 #include "lib/types.h"
 
+#define RAMP_PERIOD_CHECK_MSEC 1000
+
+extern bool ramp_period_enabled;
+
 struct thread_data;
 extern uint64_t ntime_since(const struct timespec *, const struct timespec *);
 extern uint64_t ntime_since_now(const struct timespec *);
@@ -27,6 +31,7 @@ extern uint64_t usec_spin(unsigned int);
 extern uint64_t usec_sleep(struct thread_data *, unsigned long);
 extern void fill_start_time(struct timespec *);
 extern void set_genesis_time(void);
+extern int ramp_period_check(void);
 extern bool ramp_period_over(struct thread_data *);
 extern bool in_ramp_period(struct thread_data *);
 extern void td_ramp_period_init(struct thread_data *);
diff --git a/helper_thread.c b/helper_thread.c
index fed21d1d61e7..88614e58e5a8 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -290,7 +290,13 @@ static void *helper_thread_main(void *data)
 			.interval_ms = steadystate_enabled ? ss_check_interval :
 				0,
 			.func = steadystate_check,
-		}
+		},
+		{
+			.name = "ramp_period",
+			.interval_ms = ramp_period_enabled ?
+				RAMP_PERIOD_CHECK_MSEC : 0,
+			.func = ramp_period_check,
+		},
 	};
 	struct timespec ts;
 	long clk_tck;
diff --git a/time.c b/time.c
index f90f2d9044fc..2709d5b9784a 100644
--- a/time.c
+++ b/time.c
@@ -6,6 +6,12 @@
 static struct timespec genesis;
 static unsigned long ns_granularity;
 
+enum ramp_period_states {
+	RAMP_RUNNING,
+	RAMP_FINISHING,
+	RAMP_DONE
+};
+
 void timespec_add_msec(struct timespec *ts, unsigned int msec)
 {
 	uint64_t adj_nsec = 1000000ULL * msec;
@@ -112,51 +118,69 @@ uint64_t utime_since_genesis(void)
 
 bool in_ramp_period(struct thread_data *td)
 {
-	return !td->ramp_period_over;
+	return td->ramp_period_state != RAMP_DONE;
+}
+
+bool ramp_period_enabled = false;
+
+int ramp_period_check(void)
+{
+	for_each_td(td) {
+		if (td->ramp_period_state != RAMP_RUNNING)
+			continue;
+		if (utime_since_now(&td->epoch) >= td->o.ramp_time)
+			td->ramp_period_state = RAMP_FINISHING;
+	} end_for_each();
+
+	return 0;
 }
 
 static bool parent_update_ramp(struct thread_data *td)
 {
 	struct thread_data *parent = td->parent;
 
-	if (!parent || parent->ramp_period_over)
+	if (!parent || parent->ramp_period_state == RAMP_DONE)
 		return false;
 
 	reset_all_stats(parent);
-	parent->ramp_period_over = true;
+	parent->ramp_period_state = RAMP_DONE;
 	td_set_runstate(parent, TD_RAMP);
 	return true;
 }
 
+
 bool ramp_period_over(struct thread_data *td)
 {
-	if (td->ramp_period_over)
+	if (td->ramp_period_state == RAMP_DONE)
 		return true;
 
-	if (utime_since_now(&td->epoch) >= td->o.ramp_time) {
-		td->ramp_period_over = true;
-		reset_all_stats(td);
-		reset_io_stats(td);
-		td_set_runstate(td, TD_RAMP);
+	if (td->ramp_period_state == RAMP_RUNNING)
+		return false;
 
-		/*
-		 * If we have a parent, the parent isn't doing IO. Hence
-		 * the parent never enters do_io(), which will switch us
-		 * from RAMP -> RUNNING. Do this manually here.
-		 */
-		if (parent_update_ramp(td))
-			td_set_runstate(td, TD_RUNNING);
+	td->ramp_period_state = RAMP_DONE;
+	reset_all_stats(td);
+	reset_io_stats(td);
+	td_set_runstate(td, TD_RAMP);
 
-		return true;
-	}
+	/*
+	 * If we have a parent, the parent isn't doing IO. Hence
+	 * the parent never enters do_io(), which will switch us
+	 * from RAMP -> RUNNING. Do this manually here.
+	 */
+	if (parent_update_ramp(td))
+		td_set_runstate(td, TD_RUNNING);
 
-	return false;
+	return true;
 }
 
 void td_ramp_period_init(struct thread_data *td)
 {
-	if (!td->o.ramp_time)
-		td->ramp_period_over = true;
+	if (td->o.ramp_time) {
+		td->ramp_period_state = RAMP_RUNNING;
+		ramp_period_enabled = true;
+	} else {
+		td->ramp_period_state = RAMP_DONE;
+	}
 }
 
 void fio_time_init(void)
-- 
2.51.0

