Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF43815444B
	for <fio@vger.kernel.org>; Mon, 22 Apr 2024 17:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713808548; cv=none; b=jGiOeqxAkTkLo8I1OHeECuyDEkgr+ZteZr2dUj3dAhyhseMixozNHQCUXblU6032jO3MPsfcULL95sUxvJW2UNl+Ljtz61G8rhfeljrBeducrLSedSBGucISfvNEqnuOA8foPOtodIBLC9BumUNiFV7e9bN5+gk87DDr2xDAgFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713808548; c=relaxed/simple;
	bh=yLQvTZkJoAxTAl1YVy8i3P9ABQ5gdTJEpbPaFItV57M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWIp+WUzcbPp3mk6s6ehWOH98bwrvr2ugeU/9kRSiMqmfw4VK0WnM2SYZXtbJ3bCA9T+SkSnCcwHqlfVF/rkQ4mYCM8FD/EvIaQNYQsGEUff4YOBSJGMWFmN2TQieFWUW9qBoiHXIHPGGIT6hko23K0F4OdZwxnFhKErB5iLbUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bwR7mf5U; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bwR7mf5U"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6a06b12027cso22686496d6.0
        for <fio@vger.kernel.org>; Mon, 22 Apr 2024 10:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713808546; x=1714413346; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YxqRjj8fiwpjUGE7zJcjfY9eYovRhY+ISx26f0sYdno=;
        b=bwR7mf5UNgH9OR98nBnF6ccRsEsi8TiSs3tAX0LDZ+yK5uvMzIQrIQrwAYNIU8YJay
         D6e88AekNOWGbLp3VJjlKoxnSQlFPhmG4LrDv8N0xepE6KiQ5JoUx32OcUuMedpcc+Ww
         ldZCsY/Bj1OFjlN2dw+M1FAgAvP3DteJ+TjqUTTO4BK2JdTnGhgN1sgXdzOLKuLVfPX4
         SEPBxpu+to5S+Opiu1owf18o+8FZSXfmKJHvi7PyC71c70xsc7MuJEVxB/mRSXzeCwNa
         ytB8DollZwksCVDnRrZlB5fVEUjxMu70JWcW9oIvHqlgFz2DAf2B++3NWrIyyO5rENcM
         JtKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713808546; x=1714413346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YxqRjj8fiwpjUGE7zJcjfY9eYovRhY+ISx26f0sYdno=;
        b=uLc6xspniTsx9iyzgn1ZI1SSzucUKjcafQgPD4fIs7hzo1tVtXisUx3njJd9AkKL1+
         zBnUuSK3Dvu6EhBJP3uZQl3xrx3dCNypiLzK678eW3dFc77IC4XPS/dBlx0J6S9lt6q4
         FMRkAJeRQKlU+gXwSsdCwU3q29x0ebKH7ikRamy6ho3mte87gO7gFPuImI983F5tQi2a
         t31wixgKawYR4JCPIQP3A6FtkFfd4U/pn5sbQKIVTZs9zDCr7C7pDh4NTtntL48ozPJr
         YNIkQW49D6vDP75Jiah5m8fOS8TN50FDyEdFnJON/+ulbfjks0XV7/xlQJAC65zn82zI
         1gHg==
X-Forwarded-Encrypted: i=1; AJvYcCXXnVXGIK1ign0HmnBpJQD+B0JYULZ60D2bK9QrYcoZ2bu7ouhrq7qj4DVsSFWy34niblDO53GRCaLClj5XkItOxM48
X-Gm-Message-State: AOJu0YwvFJMKbGfgg96EAMoL95YgHKMWK3IRaJlp822314xUdVs73bvK
	MF3C0RrfBvcCm4IDR4Vt3To62ydZwpo1CEbCVy2gLMdQdTO7/9mOCZqQXw==
X-Google-Smtp-Source: AGHT+IG/0Fg4eZEHZlGlxsePpvIFOpOX+ObppuENMLwSgum9uBsr6qzjzr7K0YjNiSS5lBHUgivOfw==
X-Received: by 2002:ad4:4eab:0:b0:69c:b384:1ebb with SMTP id ed11-20020ad44eab000000b0069cb3841ebbmr762653qvb.22.1713808545645;
        Mon, 22 Apr 2024 10:55:45 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id a7-20020a0cca87000000b0069b82585f7bsm4392727qvk.21.2024.04.22.10.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Apr 2024 10:55:45 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: axboe@kernel.dk,
	ankit.kumar@samsung.com,
	kbusch@kernel.org,
	fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 2/9] fio: create over-arching data placement option
Date: Mon, 22 Apr 2024 13:49:48 -0400
Message-ID: <20240422175522.4614-3-vincent.fu@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240422175522.4614-1-vincent.fu@samsung.com>
References: <20240422175522.4614-1-vincent.fu@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since FDP and streams are similar, we should have an over-arching data
placement option that encompasses both of these frameworks instead of
having separate sets of similar options for FDP and streams.

With a common set of options, users will be able to select the data
placement strategy (fdp or streams), the placement identifiers to use,
and the algorithm for selecting from the list of placement identifiers.

The original set of FDP options is retained for backward compatibility.

No functional change.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 cconv.c          | 18 +++++++++-------
 dataplacement.c  | 14 ++++++-------
 dataplacement.h  | 11 ++++++++--
 filesetup.c      |  2 +-
 init.c           | 10 ++++++++-
 io_u.c           |  2 +-
 options.c        | 54 +++++++++++++++++++++++++++++++++++-------------
 server.h         |  2 +-
 thread_options.h | 15 +++++++-------
 9 files changed, 86 insertions(+), 42 deletions(-)

diff --git a/cconv.c b/cconv.c
index ead47248..16112248 100644
--- a/cconv.c
+++ b/cconv.c
@@ -354,10 +354,11 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 		o->merge_blktrace_iters[i].u.f = fio_uint64_to_double(le64_to_cpu(top->merge_blktrace_iters[i].u.i));
 
 	o->fdp = le32_to_cpu(top->fdp);
-	o->fdp_pli_select = le32_to_cpu(top->fdp_pli_select);
-	o->fdp_nrpli = le32_to_cpu(top->fdp_nrpli);
-	for (i = 0; i < o->fdp_nrpli; i++)
-		o->fdp_plis[i] = le32_to_cpu(top->fdp_plis[i]);
+	o->dp_type = le32_to_cpu(top->dp_type);
+	o->dp_id_select = le32_to_cpu(top->dp_id_select);
+	o->dp_nr_ids = le32_to_cpu(top->dp_nr_ids);
+	for (i = 0; i < o->dp_nr_ids; i++)
+		o->dp_ids[i] = le32_to_cpu(top->dp_ids[i]);
 #if 0
 	uint8_t cpumask[FIO_TOP_STR_MAX];
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
@@ -652,10 +653,11 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 		top->merge_blktrace_iters[i].u.i = __cpu_to_le64(fio_double_to_uint64(o->merge_blktrace_iters[i].u.f));
 
 	top->fdp = cpu_to_le32(o->fdp);
-	top->fdp_pli_select = cpu_to_le32(o->fdp_pli_select);
-	top->fdp_nrpli = cpu_to_le32(o->fdp_nrpli);
-	for (i = 0; i < o->fdp_nrpli; i++)
-		top->fdp_plis[i] = cpu_to_le32(o->fdp_plis[i]);
+	top->dp_type = cpu_to_le32(o->dp_type);
+	top->dp_id_select = cpu_to_le32(o->dp_id_select);
+	top->dp_nr_ids = cpu_to_le32(o->dp_nr_ids);
+	for (i = 0; i < o->dp_nr_ids; i++)
+		top->dp_ids[i] = cpu_to_le32(o->dp_ids[i]);
 #if 0
 	uint8_t cpumask[FIO_TOP_STR_MAX];
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
diff --git a/dataplacement.c b/dataplacement.c
index 7518d193..a7170863 100644
--- a/dataplacement.c
+++ b/dataplacement.c
@@ -59,13 +59,13 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 	if (ruhs->nr_ruhs > FDP_MAX_RUHS)
 		ruhs->nr_ruhs = FDP_MAX_RUHS;
 
-	if (td->o.fdp_nrpli == 0) {
+	if (td->o.dp_nr_ids == 0) {
 		f->ruhs_info = ruhs;
 		return 0;
 	}
 
-	for (i = 0; i < td->o.fdp_nrpli; i++) {
-		if (td->o.fdp_plis[i] >= ruhs->nr_ruhs) {
+	for (i = 0; i < td->o.dp_nr_ids; i++) {
+		if (td->o.dp_ids[i] >= ruhs->nr_ruhs) {
 			ret = -EINVAL;
 			goto out;
 		}
@@ -77,9 +77,9 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 		goto out;
 	}
 
-	tmp->nr_ruhs = td->o.fdp_nrpli;
-	for (i = 0; i < td->o.fdp_nrpli; i++)
-		tmp->plis[i] = ruhs->plis[td->o.fdp_plis[i]];
+	tmp->nr_ruhs = td->o.dp_nr_ids;
+	for (i = 0; i < td->o.dp_nr_ids; i++)
+		tmp->plis[i] = ruhs->plis[td->o.dp_ids[i]];
 	f->ruhs_info = tmp;
 out:
 	sfree(ruhs);
@@ -119,7 +119,7 @@ void dp_fill_dspec_data(struct thread_data *td, struct io_u *io_u)
 		return;
 	}
 
-	if (td->o.fdp_pli_select == FIO_FDP_RR) {
+	if (td->o.dp_id_select == FIO_DP_RR) {
 		if (ruhs->pli_loc >= ruhs->nr_ruhs)
 			ruhs->pli_loc = 0;
 
diff --git a/dataplacement.h b/dataplacement.h
index 72bd4c08..b6ceb5bc 100644
--- a/dataplacement.h
+++ b/dataplacement.h
@@ -5,15 +5,22 @@
 
 #define FDP_DIR_DTYPE	2
 #define FDP_MAX_RUHS	128
+#define FIO_MAX_DP_IDS 	16
 
 /*
  * How fio chooses what placement identifier to use next. Choice of
  * uniformly random, or roundrobin.
  */
+enum {
+	FIO_DP_RANDOM	= 0x1,
+	FIO_DP_RR	= 0x2,
+};
+
 
 enum {
-	FIO_FDP_RANDOM	= 0x1,
-	FIO_FDP_RR	= 0x2,
+	FIO_DP_NONE	= 0x0,
+	FIO_DP_FDP	= 0x1,
+	FIO_DP_STREAMS	= 0x2,
 };
 
 struct fio_ruhs_info {
diff --git a/filesetup.c b/filesetup.c
index 8923f2b3..6fbfced5 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1411,7 +1411,7 @@ done:
 
 	td_restore_runstate(td, old_state);
 
-	if (td->o.fdp) {
+	if (td->o.dp_type == FIO_DP_FDP) {
 		err = dp_init(td);
 		if (err)
 			goto err_out;
diff --git a/init.c b/init.c
index 7a0b14a3..ff3e9a90 100644
--- a/init.c
+++ b/init.c
@@ -1015,7 +1015,15 @@ static int fixup_options(struct thread_data *td)
 		ret |= 1;
 	}
 
-
+	if (td->o.fdp) {
+		if (fio_option_is_set(&td->o, dp_type) &&
+			(td->o.dp_type == FIO_DP_STREAMS || td->o.dp_type == FIO_DP_NONE)) {
+			log_err("fio: fdp=1 is not compatible with dataplacement={streams, none}\n");
+			ret |= 1;
+		} else {
+			td->o.dp_type = FIO_DP_FDP;
+		}
+	}
 	return ret;
 }
 
diff --git a/io_u.c b/io_u.c
index 735d9005..e9b94c48 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1065,7 +1065,7 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 		}
 	}
 
-	if (td->o.fdp)
+	if (td->o.dp_type == FIO_DP_FDP)
 		dp_fill_dspec_data(td, io_u);
 
 	if (io_u->offset + io_u->buflen > io_u->file->real_file_size) {
diff --git a/options.c b/options.c
index de935efc..09a24652 100644
--- a/options.c
+++ b/options.c
@@ -270,12 +270,12 @@ static int str_fdp_pli_cb(void *data, const char *input)
 	strip_blank_front(&str);
 	strip_blank_end(str);
 
-	while ((v = strsep(&str, ",")) != NULL && i < FIO_MAX_PLIS)
-		td->o.fdp_plis[i++] = strtoll(v, NULL, 0);
+	while ((v = strsep(&str, ",")) != NULL && i < FIO_MAX_DP_IDS)
+		td->o.dp_ids[i++] = strtoll(v, NULL, 0);
 	free(p);
 
-	qsort(td->o.fdp_plis, i, sizeof(*td->o.fdp_plis), fio_fdp_cmp);
-	td->o.fdp_nrpli = i;
+	qsort(td->o.dp_ids, i, sizeof(*td->o.dp_ids), fio_fdp_cmp);
+	td->o.dp_nr_ids = i;
 
 	return 0;
 }
@@ -3710,32 +3710,58 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group  = FIO_OPT_G_INVALID,
 	},
 	{
-		.name	= "fdp_pli_select",
-		.lname	= "FDP Placement ID select",
+		.name	= "dataplacement",
+		.lname	= "Data Placement interface",
 		.type	= FIO_OPT_STR,
-		.off1	= offsetof(struct thread_options, fdp_pli_select),
-		.help	= "Select which FDP placement ID to use next",
+		.off1	= offsetof(struct thread_options, dp_type),
+		.help	= "Data Placement interface to use",
+		.def	= "none",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+		.posval	= {
+			  { .ival = "none",
+			    .oval = FIO_DP_NONE,
+			    .help = "Do not specify a data placement interface",
+			  },
+			  { .ival = "fdp",
+			    .oval = FIO_DP_FDP,
+			    .help = "Use Flexible Data Placement interface",
+			  },
+			  { .ival = "streams",
+			    .oval = FIO_DP_STREAMS,
+			    .help = "Use Streams interface",
+			  },
+		},
+	},
+	{
+		.name	= "plid_select",
+		.alias	= "fdp_pli_select",
+		.lname	= "Data Placement ID selection strategy",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct thread_options, dp_id_select),
+		.help	= "Strategy for selecting next Data Placement ID",
 		.def	= "roundrobin",
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
 		.posval	= {
 			  { .ival = "random",
-			    .oval = FIO_FDP_RANDOM,
+			    .oval = FIO_DP_RANDOM,
 			    .help = "Choose a Placement ID at random (uniform)",
 			  },
 			  { .ival = "roundrobin",
-			    .oval = FIO_FDP_RR,
+			    .oval = FIO_DP_RR,
 			    .help = "Round robin select Placement IDs",
 			  },
 		},
 	},
 	{
-		.name	= "fdp_pli",
-		.lname	= "FDP Placement ID indicies",
+		.name	= "plids",
+		.alias	= "fdp_pli",
+		.lname	= "Stream IDs/Data Placement ID indices",
 		.type	= FIO_OPT_STR,
 		.cb	= str_fdp_pli_cb,
-		.off1	= offsetof(struct thread_options, fdp_plis),
-		.help	= "Sets which placement ids to use (defaults to all)",
+		.off1	= offsetof(struct thread_options, dp_ids),
+		.help	= "Sets which Data Placement ids to use (defaults to all for FDP)",
 		.hide	= 1,
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
diff --git a/server.h b/server.h
index 6d2659b0..83ce449b 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 103,
+	FIO_SERVER_VER			= 104,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index c2e71518..a36b7909 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -391,11 +391,11 @@ struct thread_options {
 	fio_fp64_t zrt;
 	fio_fp64_t zrf;
 
-#define FIO_MAX_PLIS 16
 	unsigned int fdp;
-	unsigned int fdp_pli_select;
-	unsigned int fdp_plis[FIO_MAX_PLIS];
-	unsigned int fdp_nrpli;
+	unsigned int dp_type;
+	unsigned int dp_id_select;
+	unsigned int dp_ids[FIO_MAX_DP_IDS];
+	unsigned int dp_nr_ids;
 
 	unsigned int log_entries;
 	unsigned int log_prio;
@@ -709,9 +709,10 @@ struct thread_options_pack {
 	uint32_t log_prio;
 
 	uint32_t fdp;
-	uint32_t fdp_pli_select;
-	uint32_t fdp_plis[FIO_MAX_PLIS];
-	uint32_t fdp_nrpli;
+	uint32_t dp_type;
+	uint32_t dp_id_select;
+	uint32_t dp_ids[FIO_MAX_DP_IDS];
+	uint32_t dp_nr_ids;
 
 	uint32_t num_range;
 	/*
-- 
2.43.0

