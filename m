Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B7B1A5B8B
	for <fio@vger.kernel.org>; Wed, 17 Dec 2025 16:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765988272; cv=none; b=Zdzck4Uyu2MSWlR29iPks0nPGYO8otj8tQCP7cDa6MKtz6qF5ucBNpzqrvZTV5mXmzgFh9gip3VuUK6VUDC6BdsWpgudYQ7CEGvwgcjU2BcEn3J6sruhezOlxFdMMOsAurZxBoVSgk1WOUCB0HwZwjinlH59NhINf0Mgt7yT660=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765988272; c=relaxed/simple;
	bh=zMUjDfTRIOzn4VBl1sp0d1FkOrN+x5HoCDXitE6ygcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koEW3Jy0doGPsssC3lORH2Jhrhrvsdvm7Dc1LTn7ppJy8bZ1ewRWjo4FuSkFzZLtZSLW6BUqXX4kPlinaytDpOv1p9fA3v1QrAlK/7iIjz9ZqHChqy9FBwuCD1W5N9VSaXO25HnpipaS0eegUGQfqjKKOrDf/qa8Hn2mYZC477s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6807D5BCF9;
	Wed, 17 Dec 2025 16:17:27 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 589D93EA65;
	Wed, 17 Dec 2025 16:17:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 35mXFZfXQmkBcQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 17 Dec 2025 16:17:27 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 45AA0A09E1; Wed, 17 Dec 2025 17:17:22 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5/5] Add option to specify ramp period by amount of IO
Date: Wed, 17 Dec 2025 17:17:15 +0100
Message-ID: <20251217161722.6357-5-jack@suse.cz>
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
X-Rspamd-Queue-Id: 6807D5BCF9
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Rspamd-Action: no action

In some cases the ramp up period is not easy to define by amount of
time. This is for example a case of buffered writes measurement where we
want to start measuring only once dirty throttling kicks in. The time
until dirty throttling kicks in depends on dirty limit (easy to figure
out) and speed of writes to the page cache (difficult to know in
advance). Add option ramp_size which determines the ramp up period by
the amount of IO written (either by each job or by each group when group
reporting is enabled).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 HOWTO.rst        |  7 +++++++
 fio.1            |  6 ++++++
 options.c        | 11 +++++++++++
 thread_options.h |  2 ++
 time.c           | 50 ++++++++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 9f55a73bde05..49ebae6275a6 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -715,6 +715,13 @@ Time related parameters
 	:option:`runtime` is specified.  When the unit is omitted, the value is
 	given in seconds.
 
+.. option:: ramp_size=size
+
+	If set, fio will wait until the workload does given amount of IO before
+	logging any performance numbers. Similar considerations apply as for
+	``ramp_time`` option. When the unit is omitted, the value is given in
+	megabytes.
+
 .. option:: clocksource=str
 
 	Use the given clocksource as the base of timing. The supported options are:
diff --git a/fio.1 b/fio.1
index 9c4ff08c86ad..88e97518f853 100644
--- a/fio.1
+++ b/fio.1
@@ -497,6 +497,12 @@ thus it will increase the total runtime if a special timeout or
 \fBruntime\fR is specified. When the unit is omitted, the value is
 given in seconds.
 .TP
+.BI ramp_size \fR=\fPsize
+If set, fio will wait until the workload does given amount of IO before
+logging any performance numbers. Similar considerations apply as for
+\fBramp_time\fR option. When the unit is omitted, the value is given in
+megabytes.
+.TP
 .BI clocksource \fR=\fPstr
 Use the given clocksource as the base of timing. The supported options are:
 .RS
diff --git a/options.c b/options.c
index 8e3de528bbbb..d050a1f6a417 100644
--- a/options.c
+++ b/options.c
@@ -3093,6 +3093,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_RUNTIME,
 	},
+	{
+		.name	= "ramp_size",
+		.lname	= "Ramp size",
+		.type	= FIO_OPT_STR_VAL,
+		.off1	= offsetof(struct thread_options, ramp_size),
+		.minval = 1,
+		.help	= "Amount of data transferred before measuring performance",
+		.interval = 1024 * 1024,
+		.category = FIO_OPT_C_GENERAL,
+		.group	= FIO_OPT_G_RUNTIME,
+	},
 	{
 		.name	= "clocksource",
 		.lname	= "Clock source",
diff --git a/thread_options.h b/thread_options.h
index 3abce7318ce2..b4dd8d7acd49 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -212,6 +212,7 @@ struct thread_options {
 	unsigned long long start_delay_high;
 	unsigned long long timeout;
 	unsigned long long ramp_time;
+	unsigned long long ramp_size;
 	unsigned int ss_state;
 	fio_fp64_t ss_limit;
 	unsigned long long ss_dur;
@@ -546,6 +547,7 @@ struct thread_options_pack {
 	uint64_t start_delay_high;
 	uint64_t timeout;
 	uint64_t ramp_time;
+	uint64_t ramp_size;
 	uint64_t ss_dur;
 	uint64_t ss_ramp_time;
 	uint32_t ss_state;
diff --git a/time.c b/time.c
index 2709d5b9784a..d2a201bb262c 100644
--- a/time.c
+++ b/time.c
@@ -125,11 +125,57 @@ bool ramp_period_enabled = false;
 
 int ramp_period_check(void)
 {
+	uint64_t group_bytes = 0;
+	int prev_groupid = -1;
+	bool group_ramp_period_over = false;
+
 	for_each_td(td) {
 		if (td->ramp_period_state != RAMP_RUNNING)
 			continue;
-		if (utime_since_now(&td->epoch) >= td->o.ramp_time)
+
+		if (td->o.ramp_time &&
+		    utime_since_now(&td->epoch) >= td->o.ramp_time) {
 			td->ramp_period_state = RAMP_FINISHING;
+			continue;
+		}
+
+		if (td->o.ramp_size) {
+			int ddir;
+			const bool needs_lock = td_async_processing(td);
+
+			if (!td->o.group_reporting ||
+			    (td->o.group_reporting &&
+			     td->groupid != prev_groupid)) {
+				group_bytes = 0;
+				prev_groupid = td->groupid;
+				group_ramp_period_over = false;
+			}
+
+			if (needs_lock)
+				__td_io_u_lock(td);
+
+			for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
+				group_bytes += td->io_bytes[ddir];
+
+			if (needs_lock)
+				__td_io_u_unlock(td);
+
+			if (group_bytes >= td->o.ramp_size) {
+				td->ramp_period_state = RAMP_FINISHING;
+				/*
+				 * Mark ramp up for all threads in the group as
+ 				 * done.
+				 */
+				if (td->o.group_reporting &&
+				    !group_ramp_period_over) {
+					group_ramp_period_over = true;
+					for_each_td(td2) {
+						if (td2->groupid == td->groupid)
+							 td2->ramp_period_state = RAMP_FINISHING;
+					} end_for_each();
+				}
+			}
+		}
 	} end_for_each();
 
 	return 0;
@@ -175,7 +221,7 @@ bool ramp_period_over(struct thread_data *td)
 
 void td_ramp_period_init(struct thread_data *td)
 {
-	if (td->o.ramp_time) {
+	if (td->o.ramp_time || td->o.ramp_size) {
 		td->ramp_period_state = RAMP_RUNNING;
 		ramp_period_enabled = true;
 	} else {
-- 
2.51.0

