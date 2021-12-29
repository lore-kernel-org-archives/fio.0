Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9717C433EF
	for <fio@archiver.kernel.org>; Wed, 29 Dec 2021 14:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240170AbhL2Om4 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 29 Dec 2021 09:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236856AbhL2Om4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 29 Dec 2021 09:42:56 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2EEC061574
        for <fio@vger.kernel.org>; Wed, 29 Dec 2021 06:42:55 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id z29so87066309edl.7
        for <fio@vger.kernel.org>; Wed, 29 Dec 2021 06:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=wnY6YvsYkInGi3gexnDMp+ZlHp78bXrhNRfdFlad9ks=;
        b=C9cByoEqE91hVFuB0XoX1K/k6tFcDZDvfIV7zLaWxtgTKEzLpApnZtGO7FONeR1jmE
         eeC2DEd2N2tSpJeX6mH+XZ5H+sl3gMtgV0Jh+OpqOFdkK2jBWiNaI6CAV5vRcqUB3Jtj
         H0Typxu/zIq8G+G125cXt66ZVXidNqmLzs3btku2nQcOke5fbfUugW+BtYU+tx//3Cjc
         Xq6HktGlHSfC+UotiJmnNZG8SMhhBXYDvYNtd8pt7jTozX/0ABDe6njyS4r1Nxcza4X4
         SRU3tix4X39LnkCWOzc4/3RK4yIVKMCS8V7lrMRY31QeJz5DpCLNRiJmmjcqrvCrkuUm
         pJxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=wnY6YvsYkInGi3gexnDMp+ZlHp78bXrhNRfdFlad9ks=;
        b=i95bkB7qmNV+noApTE/TJ9ZzIbDU7qx2g/f6GKzJe3IvAQABIXqJ57OuWaT59aiIn4
         VXrQo5tZjbbo3yAXzEDleUxdsgfsEWHi/xroA9qoiDr5u5wW9kEfG/mHcBTvkKiV6CST
         FSWF3BSlgJzWb7RSHafAm/4mDzqx273iI4QOvNL2RBrP13g/oCCYWSKwJ+CVvqbLXcS2
         NqEGZ3MydRcRkOLAeS4hSrWP1mmaeq8aiEKfayqc438akUoaxPJt6Lbv2L51fGd/o2oy
         aKVWRFetL2LXdx19OdNF6xBR2b/Ga0L52kOzTZcycL3raccN3f4TcTq1hMITpTlPZjkp
         kaKw==
X-Gm-Message-State: AOAM533M62h6EmdrlaJn5eJo5HCt3Sw3omwHW1qcBt91wsEdvaIzQ834
        1Kf69q16xgUtsvRK46wr7lU+yCbDsA==
X-Google-Smtp-Source: ABdhPJwVV7FWUvVWbHbGlAOeV+ySPDTw+5N9B8pg/Z+IVwx2YpKlNUowou8GwHfuNhbtO72VoXQ9fg==
X-Received: by 2002:a17:907:7b87:: with SMTP id ne7mr20710561ejc.573.1640788973724;
        Wed, 29 Dec 2021 06:42:53 -0800 (PST)
Received: from localhost.localdomain ([46.53.252.249])
        by smtp.gmail.com with ESMTPSA id ds1sm6933786ejc.97.2021.12.29.06.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 06:42:53 -0800 (PST)
Date:   Wed, 29 Dec 2021 17:42:51 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org
Subject: [PATCH] fio: allow arbitraty rwmixread:rwmixwrite ratio
Message-ID: <Ycxz67DUk6UiulbJ@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The restriction that rwmixread and rwmixwrite must add to 100% is
arbitrary, it doesn't cost anything to remove it.

Patch make it easier to create fio job files just by looking at PRDs.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
---

 cconv.c          |    2 ++
 eta.c            |   15 +++++----------
 fio.1            |   11 +++++------
 io_u.c           |   14 +++++++++-----
 options.c        |   34 ++++++++++++++++++++++++++--------
 thread_options.h |    2 ++
 6 files changed, 49 insertions(+), 29 deletions(-)

--- a/cconv.c
+++ b/cconv.c
@@ -111,6 +111,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->start_offset_align = le64_to_cpu(top->start_offset_align);
 	o->start_offset_percent = le32_to_cpu(top->start_offset_percent);
 
+	o->rwmix_sum = 0;
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		o->bs[i] = le64_to_cpu(top->bs[i]);
 		o->ba[i] = le64_to_cpu(top->ba[i]);
@@ -137,6 +138,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 		}
 
 		o->rwmix[i] = le32_to_cpu(top->rwmix[i]);
+		o->rwmix_sum += o->rwmix[i];
 		o->rate[i] = le64_to_cpu(top->rate[i]);
 		o->ratemin[i] = le64_to_cpu(top->ratemin[i]);
 		o->rate_iops[i] = le32_to_cpu(top->rate_iops[i]);
--- a/eta.c
+++ b/eta.c
@@ -58,16 +58,16 @@ static void check_str_update(struct thread_data *td)
 	case TD_RUNNING:
 		if (td_rw(td)) {
 			if (td_random(td)) {
-				if (td->o.rwmix[DDIR_READ] == 100)
+				if (td->o.rwmix[DDIR_READ] == td->o.rwmix_sum)
 					c = 'r';
-				else if (td->o.rwmix[DDIR_WRITE] == 100)
+				else if (td->o.rwmix[DDIR_WRITE] == td->o.rwmix_sum)
 					c = 'w';
 				else
 					c = 'm';
 			} else {
-				if (td->o.rwmix[DDIR_READ] == 100)
+				if (td->o.rwmix[DDIR_READ] == td->o.rwmix_sum)
 					c = 'R';
-				else if (td->o.rwmix[DDIR_WRITE] == 100)
+				else if (td->o.rwmix[DDIR_WRITE] == td->o.rwmix_sum)
 					c = 'W';
 				else
 					c = 'M';
@@ -208,12 +208,7 @@ static unsigned long thread_eta(struct thread_data *td)
 	 */
 	if (td->o.do_verify && td->o.verify && td_write(td)) {
 		if (td_rw(td)) {
-			unsigned int perc = 50;
-
-			if (td->o.rwmix[DDIR_WRITE])
-				perc = td->o.rwmix[DDIR_WRITE];
-
-			bytes_total += (bytes_total * perc) / 100;
+			bytes_total += (bytes_total * td->o.rwmix[DDIR_WRITE]) / td->o.rwmix_sum;
 		} else
 			bytes_total <<= 1;
 	}
--- a/fio.1
+++ b/fio.1
@@ -1169,15 +1169,14 @@ from \fBend_fsync\fR in that it will happen on every file close, not
 just at the end of the job. Default: false.
 .TP
 .BI rwmixread \fR=\fPint
-Percentage of a mixed workload that should be reads. Default: 50.
+Iops read ratio of a mixed workload. Default: 50:50.
 .TP
 .BI rwmixwrite \fR=\fPint
-Percentage of a mixed workload that should be writes. If both
-\fBrwmixread\fR and \fBrwmixwrite\fR is given and the values do not
-add up to 100%, the latter of the two will be used to override the
-first. This may interfere with a given rate setting, if fio is asked to
+Iops write ratio of a mixed workload. Default: 50:50.
+
+rwmix options may interfere with a given rate setting, if fio is asked to
 limit reads or writes to a certain rate. If that is the case, then the
-distribution may be skewed. Default: 50.
+distribution may be skewed.
 .TP
 .BI random_distribution \fR=\fPstr:float[:float][,str:float][,str:float]
 By default, fio will use a completely uniform random distribution when asked
--- a/io_u.c
+++ b/io_u.c
@@ -596,14 +596,18 @@ static void set_rwmix_bytes(struct thread_data *td)
 
 static inline enum fio_ddir get_rand_ddir(struct thread_data *td)
 {
+	unsigned int rwmix_sum = 0;
 	unsigned int v;
 
-	v = rand_between(&td->rwmix_state, 1, 100);
+	v = rand_between(&td->rwmix_state, 1, td->o.rwmix_sum);
 
-	if (v <= td->o.rwmix[DDIR_READ])
-		return DDIR_READ;
-
-	return DDIR_WRITE;
+	for_each_rw_ddir(ddir) {
+		rwmix_sum += td->o.rwmix[ddir];
+		if (v <= rwmix_sum) {
+			return ddir;
+		}
+	}
+	assert(0);
 }
 
 int io_u_quiesce(struct thread_data *td)
--- a/options.c
+++ b/options.c
@@ -482,7 +482,7 @@ static int str_rwmix_read_cb(void *data, unsigned long long *val)
 	struct thread_data *td = cb_data_to_td(data);
 
 	td->o.rwmix[DDIR_READ] = *val;
-	td->o.rwmix[DDIR_WRITE] = 100 - *val;
+	td->o.rwmix_set[DDIR_READ] = true;
 	return 0;
 }
 
@@ -491,7 +491,7 @@ static int str_rwmix_write_cb(void *data, unsigned long long *val)
 	struct thread_data *td = cb_data_to_td(data);
 
 	td->o.rwmix[DDIR_WRITE] = *val;
-	td->o.rwmix[DDIR_READ] = 100 - *val;
+	td->o.rwmix_set[DDIR_WRITE] = true;
 	return 0;
 }
 
@@ -3535,10 +3535,8 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.type	= FIO_OPT_INT,
 		.cb	= str_rwmix_read_cb,
 		.off1	= offsetof(struct thread_options, rwmix[DDIR_READ]),
-		.maxval	= 100,
 		.help	= "Percentage of mixed workload that is reads",
-		.def	= "50",
-		.interval = 5,
+		.interval = 1,
 		.inverse = "rwmixwrite",
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_RWMIX,
@@ -3549,10 +3547,8 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.type	= FIO_OPT_INT,
 		.cb	= str_rwmix_write_cb,
 		.off1	= offsetof(struct thread_options, rwmix[DDIR_WRITE]),
-		.maxval	= 100,
 		.help	= "Percentage of mixed workload that is writes",
-		.def	= "50",
-		.interval = 5,
+		.interval = 1,
 		.inverse = "rwmixread",
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_RWMIX,
@@ -5358,6 +5354,24 @@ static void show_closest_option(const char *opt)
 	free(name);
 }
 
+/* Restore invariants if necessary. */
+static void fio_options_post_parse(struct thread_data *td)
+{
+	/* Backwards compatibility: rwmixread=N */
+	if (td->o.rwmix_set[DDIR_READ] && td->o.rwmix[DDIR_READ] <= 100 &&
+	    !td->o.rwmix_set[DDIR_WRITE]) {
+		td->o.rwmix[DDIR_WRITE] = 100 - td->o.rwmix[DDIR_READ];
+	}
+
+	/* Backwards compatibility: rwmixwrite=N */
+	if (td->o.rwmix_set[DDIR_WRITE] && td->o.rwmix[DDIR_WRITE] <= 100 &&
+	    !td->o.rwmix_set[DDIR_READ]) {
+		td->o.rwmix[DDIR_READ] = 100 - td->o.rwmix[DDIR_WRITE];
+	}
+
+	td->o.rwmix_sum = td->o.rwmix[DDIR_READ] + td->o.rwmix[DDIR_WRITE];
+}
+
 int fio_options_parse(struct thread_data *td, char **opts, int num_opts)
 {
 	int i, ret, unknown;
@@ -5414,6 +5428,10 @@ int fio_options_parse(struct thread_data *td, char **opts, int num_opts)
 		}
 	}
 
+	if (ret == 0) {
+		fio_options_post_parse(td);
+	}
+
 	free(opts_copy);
 	return ret;
 }
--- a/thread_options.h
+++ b/thread_options.h
@@ -237,6 +237,8 @@ struct thread_options {
 	unsigned int iolog;
 	unsigned int rwmixcycle;
 	unsigned int rwmix[DDIR_RWDIR_CNT];
+	bool rwmix_set[DDIR_RWDIR_CNT];
+	unsigned int rwmix_sum;
 	unsigned int nice;
 	unsigned int ioprio;
 	unsigned int ioprio_class;
