Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FD63203A0
	for <fio@vger.kernel.org>; Fri, 19 Dec 2025 13:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766151802; cv=none; b=rDon2GXKtK9uFouLPo+Q0l1dCezQHl1EjhgDvef5HTAwWi/pxq+WhPIXceUO41/gWK/aXh1noP2M4TcLr5dPR+JkW170aoXpXRF/pZabPFtLJgtQPxrRy2HDapgKNlJlsppgtg6F9R2k7YjMyO8DR0WNFxnxC0koVCqJpHkkjG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766151802; c=relaxed/simple;
	bh=Ir+Ma514mF2UXaeXp0K/CWX2zRq+UBlYJ0O7x1wHHX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gi6i5F5BJ5TvCtFK8+3DKZfPJ8G+aPx22pye9WvFgi7+4kOX3Sk4GwDyO4wCLz7SE7E+DtPcZrhzOp4NDKkteq81OXrrvHbPVvs2Bx2HGjBjpUKWKynC220PRnDD/2ylDyX42GPi8hZ8WJQduWMiDa1m++JnWIwdcOHSR85+O1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Z7JReLNv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bZGd1GfW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=E6hvwgLo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=V4YtqeYk; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Z7JReLNv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bZGd1GfW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="E6hvwgLo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="V4YtqeYk"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7E4D333789;
	Fri, 19 Dec 2025 13:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766151784; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xKksyLeQsYGYsw7WF390/UIk3Od/0U6yD6VAhaQ6nus=;
	b=Z7JReLNv6U2nDHu7JtZSOXVREtQWXb/lspwjxOx80SWH+6etoVuIlQaIHeAPnQrys4s8Q9
	03sp53JNCLoqwcMyuFyrciuDC502tfGuG0JZuxH6Qb4IGV7paAXb7Ohn9+dTb+seb9F3vb
	72VhJodGuBkJTR8mQiA2iAUTN/RTYtU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766151784;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xKksyLeQsYGYsw7WF390/UIk3Od/0U6yD6VAhaQ6nus=;
	b=bZGd1GfWc5Nzc+Vs2Ef2QEluMSxnjx7j1uINP4XiVsiFywx2FY0ZBSDgWuB8IdrIfpTnho
	xL4gANzOSuuFyFDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E6hvwgLo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V4YtqeYk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766151783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xKksyLeQsYGYsw7WF390/UIk3Od/0U6yD6VAhaQ6nus=;
	b=E6hvwgLoe/wVYZHJrTLbc98Qj04SF5ytWw/poRarFkRLanMCityJDlxBIKGlfp00v9FN6p
	CdFR1sTw91DsDa5zYNzRxkfEdAoEzCI6EDZ3Qthed9+DoZdTRxn3A/QU9sWol7VcsZLTWz
	X7OSKkkbl95lfgbi5mch47FEIf5XNkM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766151783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xKksyLeQsYGYsw7WF390/UIk3Od/0U6yD6VAhaQ6nus=;
	b=V4YtqeYka58rGU5ehwynNX2HMJ+VUejGRuP/lYeYTPdq+s1PPuz/dfdtukQW6RvAIPwgVv
	5XtNrVKDpN/gFcAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6DB933EA69;
	Fri, 19 Dec 2025 13:43:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id m7feGmdWRWmvMQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 19 Dec 2025 13:43:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0ED8DA0A30; Fri, 19 Dec 2025 14:42:48 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: Vincent Fu <vincentfu@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	fio@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH v2 5/5] Add option to specify ramp period by amount of IO
Date: Fri, 19 Dec 2025 14:42:39 +0100
Message-ID: <20251219134247.14195-5-jack@suse.cz>
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
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim,suse.cz:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	DKIM_TRACE(0.00)[suse.cz:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Queue-Id: 7E4D333789
X-Spam-Flag: NO
X-Spam-Score: -3.01

In some cases the ramp up period is not easy to define by amount of
time. This is for example a case of buffered writes measurement where we
want to start measuring only once dirty throttling kicks in. The time
until dirty throttling kicks in depends on dirty limit (easy to figure
out) and speed of writes to the page cache (difficult to know in
advance). Add option ramp_size which determines the ramp up period by
the amount of IO written (either by each job or by each group when group
reporting is enabled).

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 HOWTO.rst        | 10 ++++++++
 cconv.c          |  2 ++
 fio.1            |  9 +++++++
 fio_time.h       |  2 +-
 init.c           |  5 ++--
 options.c        | 10 ++++++++
 server.h         |  2 +-
 thread_options.h |  2 ++
 time.c           | 65 +++++++++++++++++++++++++++++++++++++++++++++---
 9 files changed, 100 insertions(+), 7 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 9f55a73bde05..af01f8f626f3 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -715,6 +715,16 @@ Time related parameters
 	:option:`runtime` is specified.  When the unit is omitted, the value is
 	given in seconds.
 
+.. option:: ramp_size=size
+
+	If set, fio will wait until the job does given amount of IO before
+	logging any performance numbers. When ``group_reporting`` is enabled,
+	the logging starts when all jobs in the group together perform given
+	amount of IO. Similarly to ``ramp_time`` this is useful for letting
+	performance to settle before logging results and will increase the total
+	runtime if a special timeout or :option:`runtime` is specified. When
+	the unit is omitted, the value is given in bytes.
+
 .. option:: clocksource=str
 
 	Use the given clocksource as the base of timing. The supported options are:
diff --git a/cconv.c b/cconv.c
index e7bbfc53bc64..0c4a3f2d21e6 100644
--- a/cconv.c
+++ b/cconv.c
@@ -258,6 +258,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->start_delay_high = le64_to_cpu(top->start_delay_high);
 	o->timeout = le64_to_cpu(top->timeout);
 	o->ramp_time = le64_to_cpu(top->ramp_time);
+	o->ramp_size = le64_to_cpu(top->ramp_size);
 	o->ss_dur = le64_to_cpu(top->ss_dur);
 	o->ss_ramp_time = le64_to_cpu(top->ss_ramp_time);
 	o->ss_state = le32_to_cpu(top->ss_state);
@@ -636,6 +637,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->start_delay_high = __cpu_to_le64(o->start_delay_high);
 	top->timeout = __cpu_to_le64(o->timeout);
 	top->ramp_time = __cpu_to_le64(o->ramp_time);
+	top->ramp_size = __cpu_to_le64(o->ramp_size);
 	top->ss_dur = __cpu_to_le64(top->ss_dur);
 	top->ss_ramp_time = __cpu_to_le64(top->ss_ramp_time);
 	top->ss_state = cpu_to_le32(top->ss_state);
diff --git a/fio.1 b/fio.1
index 9c4ff08c86ad..3ee154ed98f1 100644
--- a/fio.1
+++ b/fio.1
@@ -497,6 +497,15 @@ thus it will increase the total runtime if a special timeout or
 \fBruntime\fR is specified. When the unit is omitted, the value is
 given in seconds.
 .TP
+.BI ramp_size \fR=\fPsize
+If set, fio will wait until the job does given amount of IO before
+logging any performance numbers. When \fBgroup_reporting\fR is enabled,
+the logging starts when all jobs in the group together perform given
+amount of IO. Similarly to \fBramp_time\fR this is useful for letting
+performance to settle before logging results and will increase the total
+runtime if a special timeout or \fBruntime\fR is specified. When
+the unit is omitted, the value is given in bytes.
+.TP
 .BI clocksource \fR=\fPstr
 Use the given clocksource as the base of timing. The supported options are:
 .RS
diff --git a/fio_time.h b/fio_time.h
index 54dad8c7812e..ef107c50dc50 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -34,7 +34,7 @@ extern void set_genesis_time(void);
 extern int ramp_period_check(void);
 extern bool ramp_period_over(struct thread_data *);
 extern bool in_ramp_period(struct thread_data *);
-extern void td_ramp_period_init(struct thread_data *);
+extern int td_ramp_period_init(struct thread_data *);
 extern void fio_time_init(void);
 extern void timespec_add_msec(struct timespec *, unsigned int);
 extern void set_epoch_time(struct thread_data *, clockid_t, clockid_t);
diff --git a/init.c b/init.c
index 8b7728907c7f..7c5124fc9a6c 100644
--- a/init.c
+++ b/init.c
@@ -1676,8 +1676,6 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 
 	init_thread_stat_min_vals(&td->ts);
 
-	td_ramp_period_init(td);
-
 	/*
 	 * td->>ddir_seq_nr needs to be initialized to 1, NOT o->ddir_seq_nr,
 	 * so that get_next_offset gets a new random offset the first time it
@@ -1705,6 +1703,9 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	if (setup_rate(td))
 		goto err;
 
+	if (td_ramp_period_init(td))
+		goto err;
+
 	if (o->write_lat_log) {
 		struct log_params p = {
 			.td = td,
diff --git a/options.c b/options.c
index 8e3de528bbbb..62beb69266f0 100644
--- a/options.c
+++ b/options.c
@@ -3093,6 +3093,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
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
+		.category = FIO_OPT_C_GENERAL,
+		.group	= FIO_OPT_G_RUNTIME,
+	},
 	{
 		.name	= "clocksource",
 		.lname	= "Clock source",
diff --git a/server.h b/server.h
index 139f84b1c319..09e6663e4dde 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 114,
+	FIO_SERVER_VER			= 116,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
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
index 2709d5b9784a..386c76fc31d0 100644
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
+				 * done.
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
@@ -173,14 +219,27 @@ bool ramp_period_over(struct thread_data *td)
 	return true;
 }
 
-void td_ramp_period_init(struct thread_data *td)
+int td_ramp_period_init(struct thread_data *td)
 {
-	if (td->o.ramp_time) {
+	if (td->o.ramp_time || td->o.ramp_size) {
+		if (td->o.ramp_time && td->o.ramp_size) {
+			td_verror(td, EINVAL, "job rejected: cannot specify both ramp_time and ramp_size");
+			return 1;
+		}
+		/* Make sure options are consistent within reporting group */
+		for_each_td(td2) {
+			if (td->groupid == td2->groupid &&
+			    td->o.ramp_size != td2->o.ramp_size) {
+				td_verror(td, EINVAL, "job rejected: inconsistent ramp_size within reporting group");
+				return 1;
+			}
+		} end_for_each();
 		td->ramp_period_state = RAMP_RUNNING;
 		ramp_period_enabled = true;
 	} else {
 		td->ramp_period_state = RAMP_DONE;
 	}
+	return 0;
 }
 
 void fio_time_init(void)
-- 
2.51.0

