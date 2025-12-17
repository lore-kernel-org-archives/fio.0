Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9345E3A1E67
	for <fio@vger.kernel.org>; Wed, 17 Dec 2025 16:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765988280; cv=none; b=LeIr4AWp8XyCLMEUg4Nbkb32rl5bVr1sTsv2wSQ/BVM2bnINbsRiyJzjgShkn0CETZTItJbt4ASVryGXKnpfGjkrW2PPybhQLBXCQqE2F0shnMoEe9CdOhASsZcyGuzAKUv7zFRJcLB2CIST75dhqs/8vh+Noekbtd/n11ysYyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765988280; c=relaxed/simple;
	bh=1jEh+A04vEve22PzSJM4qwokUPcqYFjG0yuJ2yJot/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LuPQ2yQNpqY7WBC7a/+NrW1rs8uJvAwCPxyM+7YmWekw2PslxpiqMhGCq7Qb5kXE+X3gd11teubq8hPOL6wRjR5VpX9HsoFgkjSDMvaAUswK0VqyJ/iKcP0qR9Dm+KdH+u6vhJG2FU1AEZnad2DFfCN/eL4WFZPrQ4n6SOqCTPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MmYLOftQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=h1ohiPOk; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RwZgy0Ir; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=GElMUggW; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MmYLOftQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="h1ohiPOk";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RwZgy0Ir";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="GElMUggW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D952B5BD00;
	Wed, 17 Dec 2025 16:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765988247; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oBxBiZA4ktnAHHmm+FgszbEqaUl9JaWMAiptVjn/mfU=;
	b=MmYLOftQwDmZF+bN/R18pzkCcm3V3jAW+ccpYs86BwkIXvr4UFuHRAI7S3vCrws2jTcYZz
	Z6NO2u+6JRPcfIaqiGr9a+lm8sHCbmDgesSRFk/N742XDi3vLOjYP+Z2vrfs5V3oQPfCAm
	uhE6u4JXpiNrbdmuiVCxEgcZOtHOfUw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765988247;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oBxBiZA4ktnAHHmm+FgszbEqaUl9JaWMAiptVjn/mfU=;
	b=h1ohiPOkDnYeIqfS4CKgmhglXYI1qPPpiyI/qwnd+rACJ+JFkc5K/AM/A5PZXt5AYu5sth
	HCzz5OrgQP1/yCDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765988246; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oBxBiZA4ktnAHHmm+FgszbEqaUl9JaWMAiptVjn/mfU=;
	b=RwZgy0IrZq0mqUdo2VLwStnS0gpR/i0fAoFRZAcgI3quwa3dkdbbT3ATpiMbwZCxyT/lrt
	79RLeGN2PZGZT9nPHXGqjmlyg5oIqMmSyALOxHko/4UZNsQUJbAmdBU2Xe/zbPAGexVtA3
	/OFzGU4oTiXd/esTlYaJHhnp3MR8cFI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765988246;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oBxBiZA4ktnAHHmm+FgszbEqaUl9JaWMAiptVjn/mfU=;
	b=GElMUggWkVjYhynRzoljOovN/4WCmvdj0X5bShUjNMYvIBiCZbaHhc5n0Lq8sJCkTbbIj1
	Mi3qMLbmvWJdczCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C63483EA68;
	Wed, 17 Dec 2025 16:17:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aaBCMJbXQmn2cAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 17 Dec 2025 16:17:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2EF34A0927; Wed, 17 Dec 2025 17:17:22 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 2/5] td: Initialize ramp_period_over based on options
Date: Wed, 17 Dec 2025 17:17:12 +0100
Message-ID: <20251217161722.6357-2-jack@suse.cz>
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
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -6.80

Instead of checking whether ramp_time is specified each time we need to
check whether we are in the ramp period, initialize ramp_period_over
based on the ramp_time option. This will simplify things more
significantly later when ramp up period can be defined in a different
way.

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

