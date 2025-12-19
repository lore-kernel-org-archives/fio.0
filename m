Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F92A322520
	for <fio@vger.kernel.org>; Fri, 19 Dec 2025 13:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766151790; cv=none; b=b6NUuQ5RFWoqbSUiBRg8tIkvqEuMTuWkiBeSmzf5OWUScFXD+dBdPFKGyyDdmCbj8DMM128lNf6Nmn17RvgSYB4JCbf8TWGG/MHiujTXTxyM1xz0nb9Wz/wljQGvsPRhdiPMwPmCgUZVZ3P+PTgbMIRNhmIacUVMZns/PxWxbK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766151790; c=relaxed/simple;
	bh=SlyELyJsgtTDDJ1aJYiUwQZQdiet/CPzIrGwBnvndzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkI/sFrFlzOpBxqSNjaMi5PVxTEaFSq7egOpvQVU3cTTtEoFf1HfJMXb33Xn0PBuoc3/x6Y7uorc+GDV0RJtQFK5quubHSRLsse8DnG6w+4VSCOpA0dpaO4sZBUn5uPBdkzxA1wB7NekHD+CZrFU0qeivICq/V4sXm7ldwTHi80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=q7oZPKju; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hNDj8YqD; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=q7oZPKju; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hNDj8YqD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="q7oZPKju";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hNDj8YqD";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="q7oZPKju";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hNDj8YqD"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5132F5BD46;
	Fri, 19 Dec 2025 13:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766151783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yQOLtm83klE6PUVHUJlQY+f/MtGitbMTS15uQF+PB2A=;
	b=q7oZPKjuXHnAkBz+WC4rT7FLy1YlGgh9rODELAau1SFbcqH9+gIzG5wCWXJhfFIsH5a77b
	7ELZkiU6KdFWhBnQ630qiQV+TMzPFm+bKpixCDLFZziBQwvGa7vYe4SxMnXdeIsDdhPOcu
	3Ynqp0gruojPNvgqUOG3h/WM7Ba5VhU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766151783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yQOLtm83klE6PUVHUJlQY+f/MtGitbMTS15uQF+PB2A=;
	b=hNDj8YqDypGkJ8a7HnHwdRb2KDfU7mkOAZBDMCcD0UHxU3l+ZUz1SF7A5K/TUpfXdr2Ddg
	8tKZGG8JwkUCaNAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766151783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yQOLtm83klE6PUVHUJlQY+f/MtGitbMTS15uQF+PB2A=;
	b=q7oZPKjuXHnAkBz+WC4rT7FLy1YlGgh9rODELAau1SFbcqH9+gIzG5wCWXJhfFIsH5a77b
	7ELZkiU6KdFWhBnQ630qiQV+TMzPFm+bKpixCDLFZziBQwvGa7vYe4SxMnXdeIsDdhPOcu
	3Ynqp0gruojPNvgqUOG3h/WM7Ba5VhU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766151783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yQOLtm83klE6PUVHUJlQY+f/MtGitbMTS15uQF+PB2A=;
	b=hNDj8YqDypGkJ8a7HnHwdRb2KDfU7mkOAZBDMCcD0UHxU3l+ZUz1SF7A5K/TUpfXdr2Ddg
	8tKZGG8JwkUCaNAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 37FDF3EA65;
	Fri, 19 Dec 2025 13:43:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zOaqDWdWRWmfMQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 19 Dec 2025 13:43:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EEF7DA0951; Fri, 19 Dec 2025 14:42:47 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: Vincent Fu <vincentfu@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	fio@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH v2 2/5] td: Initialize ramp_period_over based on options
Date: Fri, 19 Dec 2025 14:42:36 +0100
Message-ID: <20251219134247.14195-2-jack@suse.cz>
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
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid,suse.cz:email];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -2.80

Instead of checking whether ramp_time is specified each time we need to
check whether we are in the ramp period, initialize ramp_period_over
based on the ramp_time option. This will simplify things more
significantly later when ramp up period can be defined in a different
way.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fio_time.h |  1 +
 init.c     |  2 ++
 time.c     | 10 ++++++++--
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fio_time.h b/fio_time.h
index 30de7aca4fb1..c67c9450f484 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -29,6 +29,7 @@ extern void fill_start_time(struct timespec *);
 extern void set_genesis_time(void);
 extern bool ramp_period_over(struct thread_data *);
 extern bool in_ramp_period(struct thread_data *);
+extern void td_ramp_period_init(struct thread_data *);
 extern void fio_time_init(void);
 extern void timespec_add_msec(struct timespec *, unsigned int);
 extern void set_epoch_time(struct thread_data *, clockid_t, clockid_t);
diff --git a/init.c b/init.c
index cf66ac2c51f1..8b7728907c7f 100644
--- a/init.c
+++ b/init.c
@@ -1676,6 +1676,8 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 
 	init_thread_stat_min_vals(&td->ts);
 
+	td_ramp_period_init(td);
+
 	/*
 	 * td->>ddir_seq_nr needs to be initialized to 1, NOT o->ddir_seq_nr,
 	 * so that get_next_offset gets a new random offset the first time it
diff --git a/time.c b/time.c
index 9625e8cd92af..f90f2d9044fc 100644
--- a/time.c
+++ b/time.c
@@ -112,7 +112,7 @@ uint64_t utime_since_genesis(void)
 
 bool in_ramp_period(struct thread_data *td)
 {
-	return td->o.ramp_time && !td->ramp_period_over;
+	return !td->ramp_period_over;
 }
 
 static bool parent_update_ramp(struct thread_data *td)
@@ -130,7 +130,7 @@ static bool parent_update_ramp(struct thread_data *td)
 
 bool ramp_period_over(struct thread_data *td)
 {
-	if (!td->o.ramp_time || td->ramp_period_over)
+	if (td->ramp_period_over)
 		return true;
 
 	if (utime_since_now(&td->epoch) >= td->o.ramp_time) {
@@ -153,6 +153,12 @@ bool ramp_period_over(struct thread_data *td)
 	return false;
 }
 
+void td_ramp_period_init(struct thread_data *td)
+{
+	if (!td->o.ramp_time)
+		td->ramp_period_over = true;
+}
+
 void fio_time_init(void)
 {
 	int i;
-- 
2.51.0

