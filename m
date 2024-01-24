Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F4214AB3
	for <fio@vger.kernel.org>; Wed, 24 Jan 2024 07:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706080431; cv=none; b=pdq12VnkoYpjlHiGuweMQqDScOpLeXKVyIotvHElTcQ1AYOnThOOVajJphMKGZWjMN/h/fHyAI5nJ0gfga7TmMsq1Dd+XDmNgbee1zqOZBdNwM0WatEBdKXiU+tSriqwKjh9hO5LFjmsEHHult7vrmnc0Zr5ZArwpj46gDY3mXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706080431; c=relaxed/simple;
	bh=PpUu0rVJufznDoVV14dr4s5Yhb1IaP+re5pk22Fk9Cw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=YmtRkq5PixgcMakZDjHN0qEO3RRAvTpLgpnBf+sSRLPK/Fu828KdkTu/ng5mn0hRZ5csYeLgMXveEZAigNF0v8R8uHXI/0x0oSnCwMn2MRG3IbFkvOvtqJgq0jVtKFYflMElUwibpxiEnzSAV6wmOkdNV19ylPeIx9KkD2RhjRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=JDAYNxn+; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JDAYNxn+"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240124071345epoutp013358a673d40f3f8757d2700408e5ca59~tNxufvDy_1091210912epoutp01B
	for <fio@vger.kernel.org>; Wed, 24 Jan 2024 07:13:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240124071345epoutp013358a673d40f3f8757d2700408e5ca59~tNxufvDy_1091210912epoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706080425;
	bh=xBzM39eDbaNOHommfaVNQhan1vfp9Q6U3gz7QQ5PmYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDAYNxn+P4BklMpZ7Al//Sl9yxqYNTT89aVd8CapIv4QZhNpN4RliGr5JoDaZ97a/
	 byI4lWQqRahc30KdTNS5VKBvPpX8wljwB/13mUj/m2zonVUJqOHaKQ5HaLArdVqw9X
	 nolMaOOT9u8L/yxgUk3M0OOIVVB3nhJaj23BkBCE=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240124071345epcas5p4e38e6f375899bc05ce887f842df93824~tNxt_CYBv2519425194epcas5p4-;
	Wed, 24 Jan 2024 07:13:45 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4TKZtv0pVHz4x9QK; Wed, 24 Jan
	2024 07:13:43 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	40.9B.10009.6A8B0B56; Wed, 24 Jan 2024 16:13:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240124061715epcas5p108a25af87c320ac6875e6353f245b58f~tNAZNoqvT2077420774epcas5p19;
	Wed, 24 Jan 2024 06:17:15 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240124061715epsmtrp18fb481429a98b8ae5e88bd5d5cb5c1be~tNAZM_4k20248502485epsmtrp1z;
	Wed, 24 Jan 2024 06:17:15 +0000 (GMT)
X-AuditID: b6c32a4a-261fd70000002719-b7-65b0b8a62395
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	52.76.08817.B6BA0B56; Wed, 24 Jan 2024 15:17:15 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240124061714epsmtip1d699830ddeeeadf60444f206a5f669f8~tNAYVOkd31272112721epsmtip1Z;
	Wed, 24 Jan 2024 06:17:14 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 1/2] stat: log out both average and max over the window
Date: Wed, 24 Jan 2024 17:04:12 +0530
Message-Id: <20240124113413.52550-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240124113413.52550-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsWy7bCmuu7yHRtSDU62MlqsufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASlW2TkZqYklqkkJqXnJ+SmZduq+Qd
	HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RQSaEsMacUKBSQWFyspG9nU5RfWpKqkJFf
	XGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBgZApUmJCdMffkWtaCkxEVz24+Ympg3OXaxcjJ
	ISFgIjGx+zdrFyMXh5DAbkaJj4ems4EkhAQ+MUocnVcCkfjGKLFw4hHmLkYOsI7Dv2Mh4nsZ
	JXq3PWKBaOhkkvj/RQ7EZhPQlnj19gZYvYiAhsSau6kgYWYBO4mrh1+CzRcW8JJYt+cXK0gJ
	i4CqRPOrYpAwr4CNxIQd29ghbpOXmHnpO5jNKWArsWXbMUaIGkGJkzOfsECMlJdo3jqbGeQc
	CYFT7BIzj15ghGh2kdjXC2MLS7w6vgVqqJTEy/42KDtbYtPDn0wQdoHEkRe9zBC2vUTrqX6w
	85kFNCXW79KHCMtKTD21jgliL59E7+8nUK28EjvmwdiqEn/v3WaBsKUlbr67CmV7SEyY/5Md
	EmwTGCUO/vvCNoFRYRaSf2Yh+WcWwuoFjMyrGCVTC4pz01OLTQuM8lLL4TGcnJ+7iRGcALW8
	djA+fPBB7xAjEwfjIUYJDmYlEd4bkutShXhTEiurUovy44tKc1KLDzGaAsN7IrOUaHI+MAXn
	lcQbmlgamJiZmZlYGpsZKonzvm6dmyIkkJ5YkpqdmlqQWgTTx8TBKdXAJF40X3HOu7D2Dyum
	nw49+nv6D34zoQanz2kuySce/VgwpT7INWKX+bu6vqORlvOeqPTG8NkG33n7ov1/3pddOnZl
	R75N+lV9VejOe52JsxRPJTBPibqzNe3WBvGExUnHLqveeRQtcCDqcdbdxhlNfwr3LYq8J2/y
	6RtXb+CHCxumJetJzrFsaNLUPWxn4zRh9vZclhlPHtyuK+Obc9DzcO5D1bnGBktmTX4z5/Xp
	Rku196Lz/1nkplao3Lyh+q3nqe6BRkWZuVb39oh62Fz163o+e/aXNx+NzC5/7aooOlQ35VDO
	ZOEZ+hN3fBQrb5P2n1w4Z4rFjK4CFX1NpWC1C3LO5yM/a/81+3bMd9Fcu3glluKMREMt5qLi
	RAC7DDT0CQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsWy7bCSnG726g2pBu+eiFusufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJUx9+Ra1oKT
	ERXPbj5iamDc5drFyMEhIWAicfh3bBcjF4eQwG5GiQnTZjFBxKUlFq5P7GLkBDKFJVb+e84O
	YgsJtDNJLNkkDWKzCWhLvHp7gxnEFhHQkji2rokNxGYWcJD4t2sLmC0s4CWxbs8vVpCRLAKq
	Es2vikHCvAI2EhN2bGOHGC8vMfPSdzCbU8BWYsu2Y4wQq2wkDm97wgRRLyhxcuYTFojx8hLN
	W2czT2AUmIUkNQtJagEj0ypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOAQ1dLawbhn
	1Qe9Q4xMHIyHGCU4mJVEeG9IrksV4k1JrKxKLcqPLyrNSS0+xCjNwaIkzvvtdW+KkEB6Yklq
	dmpqQWoRTJaJg1OqgUlwz1OmjvXvA2/VP39+8ftFm4XHLT9VTdme9e+OJZ/B0QWCksvibkTK
	2clsyPWbLLW74/Rynv18Gz42XYl2eDnFnU/Ka2nPZpEzc05ukFmYLCJSsWvt8yecxzg/5vwU
	dk1oKtlrk73WcG5I5dxJPpuE5wYqz3+Vc83t8sqFYm+OPuOq9fPsX/dH1vgFf3DxX7b1eu90
	Qg7U/yhne3A20k2z/7YRZ31HpF8H0+1zk/PPrU3qb35yRcUqxGr/c4k7asK6vRVpJ123Snel
	HVj36MAWRsMVe13kFR5mVNSms3ZFlhx1n3HgvMLj+hCz32cu3WO4tFT0v9e7a0eZ0uOzjFyj
	69yX5T5L2542eUGgUJwSS3FGoqEWc1FxIgCl82ihwAIAAA==
X-CMS-MailID: 20240124061715epcas5p108a25af87c320ac6875e6353f245b58f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240124061715epcas5p108a25af87c320ac6875e6353f245b58f
References: <20240124113413.52550-1-ankit.kumar@samsung.com>
	<CGME20240124061715epcas5p108a25af87c320ac6875e6353f245b58f@epcas5p1.samsung.com>

Add option log_window_value alias of log_max_value which reports
average, max or both the values. Retain backward compatibility by
allowing =0 and =1 values to specify avg and max values respectively.

There is no change to existing log formats while reporting only average
or max values.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 client.c  |  6 +++--
 iolog.c   | 74 ++++++++++++++++++++++++++++++++++++++++---------------
 iolog.h   | 21 +++++++++++++---
 options.c | 34 +++++++++++++++++++++----
 server.c  |  6 +++--
 stat.c    | 32 ++++++++++++++----------
 6 files changed, 128 insertions(+), 45 deletions(-)

diff --git a/client.c b/client.c
index 699a2e5b..4cb7dffe 100644
--- a/client.c
+++ b/client.c
@@ -1718,8 +1718,10 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 			s = (struct io_sample *)((char *)s + sizeof(struct io_u_plat_entry) * i);
 
 		s->time		= le64_to_cpu(s->time);
-		if (ret->log_type != IO_LOG_TYPE_HIST)
-			s->data.val	= le64_to_cpu(s->data.val);
+		if (ret->log_type != IO_LOG_TYPE_HIST) {
+			s->data.val.val0	= le64_to_cpu(s->data.val.val0);
+			s->data.val.val1	= le64_to_cpu(s->data.val.val1);
+		}
 		s->__ddir	= __le32_to_cpu(s->__ddir);
 		s->bs		= le64_to_cpu(s->bs);
 		s->priority	= le16_to_cpu(s->priority);
diff --git a/iolog.c b/iolog.c
index 5213c60f..b4c7a8f1 100644
--- a/iolog.c
+++ b/iolog.c
@@ -862,6 +862,8 @@ void setup_log(struct io_log **log, struct log_params *p,
 		l->log_ddir_mask = LOG_OFFSET_SAMPLE_BIT;
 	if (l->log_prio)
 		l->log_ddir_mask |= LOG_PRIO_SAMPLE_BIT;
+	if (l->td->o.log_max == IO_LOG_SAMPLE_BOTH)
+		l->log_ddir_mask |= LOG_AVG_MAX_SAMPLE_BIT;
 
 	INIT_FLIST_HEAD(&l->chunk_list);
 
@@ -988,7 +990,7 @@ static void flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
 void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 {
 	struct io_sample *s;
-	int log_offset, log_prio;
+	int log_offset, log_prio, log_avg_max;
 	uint64_t i, nr_samples;
 	unsigned int prio_val;
 	const char *fmt;
@@ -999,17 +1001,32 @@ void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 	s = __get_sample(samples, 0, 0);
 	log_offset = (s->__ddir & LOG_OFFSET_SAMPLE_BIT) != 0;
 	log_prio = (s->__ddir & LOG_PRIO_SAMPLE_BIT) != 0;
+	log_avg_max = (s->__ddir & LOG_AVG_MAX_SAMPLE_BIT) != 0;
 
 	if (log_offset) {
-		if (log_prio)
-			fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %llu, 0x%04x\n";
-		else
-			fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %llu, %u\n";
+		if (log_prio) {
+			if (log_avg_max)
+				fmt = "%" PRIu64 ", %" PRId64 ", %" PRId64 ", %u, %llu, %llu, 0x%04x\n";
+			else
+				fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %llu, 0x%04x\n";
+		} else {
+			if (log_avg_max)
+				fmt = "%" PRIu64 ", %" PRId64 ", %" PRId64 ", %u, %llu, %llu, %u\n";
+			else
+				fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %llu, %u\n";
+		}
 	} else {
-		if (log_prio)
-			fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, 0x%04x\n";
-		else
-			fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %u\n";
+		if (log_prio) {
+			if (log_avg_max)
+				fmt = "%" PRIu64 ", %" PRId64 ", %" PRId64 ", %u, %llu, 0x%04x\n";
+			else
+				fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, 0x%04x\n";
+		} else {
+			if (log_avg_max)
+				fmt = "%" PRIu64 ", %" PRId64 ", %" PRId64 ", %u, %llu, %u\n";
+			else
+				fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %u\n";
+		}
 	}
 
 	nr_samples = sample_size / __log_entry_sz(log_offset);
@@ -1023,20 +1040,37 @@ void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 			prio_val = ioprio_value_is_class_rt(s->priority);
 
 		if (!log_offset) {
-			fprintf(f, fmt,
-				s->time,
-				s->data.val,
-				io_sample_ddir(s), (unsigned long long) s->bs,
-				prio_val);
+			if (log_avg_max)
+				fprintf(f, fmt,
+					s->time,
+					s->data.val.val0,
+					s->data.val.val1,
+					io_sample_ddir(s), (unsigned long long) s->bs,
+					prio_val);
+			else
+				fprintf(f, fmt,
+					s->time,
+					s->data.val.val0,
+					io_sample_ddir(s), (unsigned long long) s->bs,
+					prio_val);
 		} else {
 			struct io_sample_offset *so = (void *) s;
 
-			fprintf(f, fmt,
-				s->time,
-				s->data.val,
-				io_sample_ddir(s), (unsigned long long) s->bs,
-				(unsigned long long) so->offset,
-				prio_val);
+			if (log_avg_max)
+				fprintf(f, fmt,
+					s->time,
+					s->data.val.val0,
+					s->data.val.val1,
+					io_sample_ddir(s), (unsigned long long) s->bs,
+					(unsigned long long) so->offset,
+					prio_val);
+			else
+				fprintf(f, fmt,
+					s->time,
+					s->data.val.val0,
+					io_sample_ddir(s), (unsigned long long) s->bs,
+					(unsigned long long) so->offset,
+					prio_val);
 		}
 	}
 }
diff --git a/iolog.h b/iolog.h
index 62cbd1b0..26dd5cca 100644
--- a/iolog.h
+++ b/iolog.h
@@ -26,13 +26,23 @@ struct io_hist {
 	struct flist_head list;
 };
 
+enum {
+	IO_LOG_SAMPLE_AVG = 0,
+	IO_LOG_SAMPLE_MAX,
+	IO_LOG_SAMPLE_BOTH,
+};
+
+struct io_sample_value {
+	uint64_t val0;
+	uint64_t val1;
+};
 
 union io_sample_data {
-	uint64_t val;
+	struct io_sample_value val;
 	struct io_u_plat_entry *plat_entry;
 };
 
-#define sample_val(value) ((union io_sample_data) { .val = value })
+#define sample_val(value) ((union io_sample_data) { .val.val0 = value })
 #define sample_plat(plat) ((union io_sample_data) { .plat_entry = plat })
 
 /*
@@ -154,8 +164,13 @@ struct io_log {
  * If the bit following the upper bit is set, then we have the priority
  */
 #define LOG_PRIO_SAMPLE_BIT	0x40000000U
+/*
+ * If the bit following prioity sample vit is set, we report both avg and max
+ */
+#define LOG_AVG_MAX_SAMPLE_BIT	0x20000000U
 
-#define LOG_SAMPLE_BITS		(LOG_OFFSET_SAMPLE_BIT | LOG_PRIO_SAMPLE_BIT)
+#define LOG_SAMPLE_BITS		(LOG_OFFSET_SAMPLE_BIT | LOG_PRIO_SAMPLE_BIT |\
+					LOG_AVG_MAX_SAMPLE_BIT)
 #define io_sample_ddir(io)	((io)->__ddir & ~LOG_SAMPLE_BITS)
 
 static inline void io_sample_set_ddir(struct io_log *log,
diff --git a/options.c b/options.c
index 53df03de..1da4de78 100644
--- a/options.c
+++ b/options.c
@@ -4540,14 +4540,38 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
-		.name	= "log_max_value",
-		.lname	= "Log maximum instead of average",
-		.type	= FIO_OPT_BOOL,
+		.name	= "log_window_value",
+		.alias  = "log_max_value",
+		.lname	= "Log maximum, average or both values",
+		.type	= FIO_OPT_STR,
 		.off1	= offsetof(struct thread_options, log_max),
-		.help	= "Log max sample in a window instead of average",
-		.def	= "0",
+		.help	= "Log max, average or both sample in a window",
+		.def	= "avg",
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
+		.posval	= {
+			  { .ival = "avg",
+			    .oval = IO_LOG_SAMPLE_AVG,
+			    .help = "Log average value over the window",
+			  },
+			  { .ival = "max",
+			    .oval = IO_LOG_SAMPLE_MAX,
+			    .help = "Log maximum value in the window",
+			  },
+			  { .ival = "both",
+			    .oval = IO_LOG_SAMPLE_BOTH,
+			    .help = "Log both average and maximum values over the window"
+			  },
+			  /* Compatibility with former boolean values */
+			  { .ival = "0",
+			    .oval = IO_LOG_SAMPLE_AVG,
+			    .help = "Alias for 'avg'",
+			  },
+			  { .ival = "1",
+			    .oval = IO_LOG_SAMPLE_MAX,
+			    .help = "Alias for 'max'",
+			  },
+		},
 	},
 	{
 		.name	= "log_offset",
diff --git a/server.c b/server.c
index b9f0e2ac..afaeb348 100644
--- a/server.c
+++ b/server.c
@@ -2288,8 +2288,10 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 			struct io_sample *s = get_sample(log, cur_log, i);
 
 			s->time		= cpu_to_le64(s->time);
-			if (log->log_type != IO_LOG_TYPE_HIST)
-				s->data.val	= cpu_to_le64(s->data.val);
+			if (log->log_type != IO_LOG_TYPE_HIST) {
+				s->data.val.val0	= cpu_to_le64(s->data.val.val0);
+				s->data.val.val1	= cpu_to_le64(s->data.val.val1);
+			}
 			s->__ddir	= __cpu_to_le32(s->__ddir);
 			s->bs		= cpu_to_le64(s->bs);
 
diff --git a/stat.c b/stat.c
index 7cf6bee1..11b58626 100644
--- a/stat.c
+++ b/stat.c
@@ -3149,7 +3149,7 @@ void reset_io_stats(struct thread_data *td)
 }
 
 static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
-			      unsigned long elapsed, bool log_max)
+			      unsigned long elapsed, int log_max)
 {
 	/*
 	 * Note an entry in the log. Use the mean from the logged samples,
@@ -3159,10 +3159,16 @@ static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
 	if (iolog->avg_window[ddir].samples) {
 		union io_sample_data data;
 
-		if (log_max)
-			data.val = iolog->avg_window[ddir].max_val;
-		else
-			data.val = iolog->avg_window[ddir].mean.u.f + 0.50;
+		if (log_max == IO_LOG_SAMPLE_AVG) {
+			data.val.val0 = iolog->avg_window[ddir].mean.u.f + 0.50;
+			data.val.val1 = 0;
+		} else if (log_max == IO_LOG_SAMPLE_MAX) {
+			data.val.val0 = iolog->avg_window[ddir].max_val;
+			data.val.val1 = 0;
+		} else {
+			data.val.val0 = iolog->avg_window[ddir].mean.u.f + 0.50;
+			data.val.val1 = iolog->avg_window[ddir].max_val;
+		}
 
 		__add_log_sample(iolog, data, ddir, 0, elapsed, 0, 0);
 	}
@@ -3171,7 +3177,7 @@ static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
 }
 
 static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed,
-			     bool log_max)
+			     int log_max)
 {
 	enum fio_ddir ddir;
 
@@ -3205,7 +3211,7 @@ static unsigned long add_log_sample(struct thread_data *td,
 	 * Add the sample. If the time period has passed, then
 	 * add that entry to the log and clear.
 	 */
-	add_stat_sample(&iolog->avg_window[ddir], data.val);
+	add_stat_sample(&iolog->avg_window[ddir], data.val.val0);
 
 	/*
 	 * If period hasn't passed, adding the above sample is all we
@@ -3221,7 +3227,7 @@ static unsigned long add_log_sample(struct thread_data *td,
 			return diff;
 	}
 
-	__add_stat_to_log(iolog, ddir, elapsed, td->o.log_max != 0);
+	__add_stat_to_log(iolog, ddir, elapsed, td->o.log_max);
 
 	iolog->avg_last[ddir] = elapsed - (elapsed % iolog->avg_msec);
 
@@ -3235,15 +3241,15 @@ void finalize_logs(struct thread_data *td, bool unit_logs)
 	elapsed = mtime_since_now(&td->epoch);
 
 	if (td->clat_log && unit_logs)
-		_add_stat_to_log(td->clat_log, elapsed, td->o.log_max != 0);
+		_add_stat_to_log(td->clat_log, elapsed, td->o.log_max);
 	if (td->slat_log && unit_logs)
-		_add_stat_to_log(td->slat_log, elapsed, td->o.log_max != 0);
+		_add_stat_to_log(td->slat_log, elapsed, td->o.log_max);
 	if (td->lat_log && unit_logs)
-		_add_stat_to_log(td->lat_log, elapsed, td->o.log_max != 0);
+		_add_stat_to_log(td->lat_log, elapsed, td->o.log_max);
 	if (td->bw_log && (unit_logs == per_unit_log(td->bw_log)))
-		_add_stat_to_log(td->bw_log, elapsed, td->o.log_max != 0);
+		_add_stat_to_log(td->bw_log, elapsed, td->o.log_max);
 	if (td->iops_log && (unit_logs == per_unit_log(td->iops_log)))
-		_add_stat_to_log(td->iops_log, elapsed, td->o.log_max != 0);
+		_add_stat_to_log(td->iops_log, elapsed, td->o.log_max);
 }
 
 void add_agg_sample(union io_sample_data data, enum fio_ddir ddir,
-- 
2.25.1

