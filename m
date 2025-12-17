Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CB722F77E
	for <fio@vger.kernel.org>; Wed, 17 Dec 2025 16:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765988263; cv=none; b=gP9ZSKMptKyQ5k/Tr28tJO8fq58XjIcLjHJdw5FmAB+XhuMe2BavVAtFBOfbvLuGZDaRc+/5Bw2y/aVn4J8h/0pxTGcWRmMqL3tXNC8m/pj2ePKenbD4TQH/ojBwkavH0tuMDPikZvsUyI4Sj7aOfZ77+Y/D+fQnRjvZqswpBrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765988263; c=relaxed/simple;
	bh=rGPo7VZeEjFJ59viEID+FSgG74IwhjUsX2TEpsCz4/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsRalrOuP9QNO1n5vjxc3zRvjhq5/Eq73pLzlP5duxRkhderRIaYe6UC+h01t72AbBZCgc+9+fwEJzoJP86c9Wzmq3emEuuJKXlxdw0GuIGRQ4f1vMy/74tXr69dYNbrgwwmepfSipOD41MX8evckzCoN98fvjziKN//rpxucRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DE50A5BD03;
	Wed, 17 Dec 2025 16:17:26 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CC3353EA69;
	Wed, 17 Dec 2025 16:17:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id C37ZMZbXQmn5cAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 17 Dec 2025 16:17:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3DF4CA09DA; Wed, 17 Dec 2025 17:17:22 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 4/5] time: Evaluate ramp up condition once per second
Date: Wed, 17 Dec 2025 17:17:14 +0100
Message-ID: <20251217161722.6357-4-jack@suse.cz>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: DE50A5BD03
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

Instead of evaluating whether ramp up period has finished on each IO
submission and completion evaluate it once per second and set
appropriate state variable in thread_data. Later when ramp up period end
condition will be more complex and would involve stat data from all
threads, it would unnecessarily slow down IO.

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

