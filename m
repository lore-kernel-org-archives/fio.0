Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4314BE6E
	for <fio@vger.kernel.org>; Thu, 25 Jan 2024 06:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706165236; cv=none; b=VCOBFOi9aQU7iLdJnwuvt/mtYuJTUzMgVzz0ndXG9ywdXDNECc+PEvb30ncRSxK9RO7Azs5NNI34jkQpn7uYEgFmJw5W+Wns9dbbH8GUpIBB1rqoZjY/JqjBiixsLHkNkYKfbNihcJkkf0Xels2UnsYYumFp/dUMhXYm+uxolZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706165236; c=relaxed/simple;
	bh=PpUu0rVJufznDoVV14dr4s5Yhb1IaP+re5pk22Fk9Cw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=D46os2R1b9zh5yn6hrcWwLutOLKQaC9hzX8/5j5CdzpA5wwTcIdLLXuiqVF7rlhgaYuP/hyfOlAygAPtrld7VebhX3vdvR3KPTRiHZwlpdpeAag7a3+SNjKJh+9rM+2/FmIEshOZhZ5RXt675+v7a2SHOgpazljuDbRJaoO1TyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=hNDDKFEU; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hNDDKFEU"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240125064710epoutp04062c8a7ff60db79c8a9bef0100ce311d~thDzMW0jG0351603516epoutp04p
	for <fio@vger.kernel.org>; Thu, 25 Jan 2024 06:47:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240125064710epoutp04062c8a7ff60db79c8a9bef0100ce311d~thDzMW0jG0351603516epoutp04p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706165230;
	bh=xBzM39eDbaNOHommfaVNQhan1vfp9Q6U3gz7QQ5PmYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNDDKFEUB8uR09QhR3N9JVHDBwTR+RxcSrcPKh9quq8UT4RkbofJUxqmKd6xIZGvp
	 BtHvl7QdDazzJzdre7fZsrCQVPUCLc/TM+W6LhReLrtfANY4b/yPHjWYiRonazFRyk
	 +s+8Vv1vI+KsfwC2/blZREX7WqGn1DnolzDqsYsw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240125064710epcas5p3a1fa304eae21edf577e041c5e8c8196c~thDy1oTLk2867028670epcas5p3G;
	Thu, 25 Jan 2024 06:47:10 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4TLBFm1l3Rz4x9Q3; Thu, 25 Jan
	2024 06:47:08 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2C.93.09634.7E302B56; Thu, 25 Jan 2024 15:47:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240125054351epcas5p3d0cd3a76619116d48afa73da0d88e38d~tgMhCK0L71757417574epcas5p3K;
	Thu, 25 Jan 2024 05:43:51 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240125054351epsmtrp295817631d64320e25cd594fbf8ebaef3~tgMhBhrCo2330323303epsmtrp2V;
	Thu, 25 Jan 2024 05:43:51 +0000 (GMT)
X-AuditID: b6c32a49-159fd700000025a2-0b-65b203e782f0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	75.5E.08817.715F1B56; Thu, 25 Jan 2024 14:43:51 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240125054350epsmtip10ba6a4cf3a688e239ef3b27929b824ac~tgMgEOS_92745027450epsmtip1A;
	Thu, 25 Jan 2024 05:43:50 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v3 1/2] stat: log out both average and max over the window
Date: Thu, 25 Jan 2024 16:31:23 +0530
Message-Id: <20240125110124.55137-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240125110124.55137-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7bCmuu5z5k2pBjsm6FqsufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASlW2TkZqYklqkkJqXnJ+SmZduq+Qd
	HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RQSaEsMacUKBSQWFyspG9nU5RfWpKqkJFf
	XGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBgZApUmJCdMffkWtaCkxEVz24+Ympg3OXaxcjJ
	ISFgInH+aj8ziC0ksJtRYvlVGQj7E6PE+tb8LkYuIPsbo8TxRefYYBpezrrMApHYyyjxYe8s
	Vgink0mi69tVRpAqNgFtiVdvbwCN5eAQEdCQWHM3FSTMLGAncfXwSzaQsLCAl8SmZTEgYRYB
	VYlXa26BdfIK2Eh0HJvCDLFLXmLmpe/sIDangK3E+/7/7BA1ghInZz5hgRgpL9G8dTYzyAkS
	AqfYJZY9f88I0ewi8XrlOqijhSVeHd/CDmFLSXx+txcqni2x6eFPJgi7QOLIi16oxfYSraf6
	wc5nFtCUWL9LHyIsKzH11DomiL18Er2/n0C18krsmAdjq0r8vXebBcKWlrj57iqU7SGx9tQb
	aLhNYJQ4ueQM0wRGhVlI/pmF5J9ZCKsXMDKvYpRMLSjOTU8tNi0wzEsth0dxcn7uJkZwCtTy
	3MF498EHvUOMTByMhxglOJiVRHhNTDemCvGmJFZWpRblxxeV5qQWH2I0BQb4RGYp0eR8YBLO
	K4k3NLE0MDEzMzOxNDYzVBLnfd06N0VIID2xJDU7NbUgtQimj4mDU6qBadtZd+f1DxVePVzC
	M9nw5ifTnKJnCsezdq27+M999gGGB8fLlD8v73q7b6/Rqelf/R1zhT80XGWTsldrUVXznWm7
	+ozmSe0VC5i935nIT/CX2t6cEjjN+tN5liXv4lWmOGR8XbFC+fRVc3bfGIl0w7Tvn+7/+usy
	58sfVf/7tu+6rumwTpm1vLk9ZWlx2eG4qid+ckVv3/xMXpb/qWLX6jO2U31sFuw0CNI9W5m2
	fO+V31cOeE5YsyGg90rVgce8ndvcDL83vfnDbOJsn8PRFlV2dF7nomwNf9OyoHspOc8/Cxyp
	udV2YvfemX6FDQ3X7MODHzHNO756SQF7z6Epy3heV5T0PllqkH6kvEktKlmJpTgj0VCLuag4
	EQBH2iiOCgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsWy7bCSnK74142pBl9Xi1isufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJUx9+Ra1oKT
	ERXPbj5iamDc5drFyMkhIWAi8XLWZRYQW0hgN6PExcNFXYwcQHFpiYXrEyFKhCVW/nvO3sXI
	BVTSziRx5fFHJpAEm4C2xKu3N5hBbBEBLYlj65rYQGxmAQeJf7u2sIHMERbwkti0LAYkzCKg
	KvFqzS1GEJtXwEai49gUZoj58hIzL31nB7E5BWwl3vf/Z4c4x0ai+ctPNoh6QYmTM5+wQIyX
	l2jeOpt5AqPALCSpWUhSCxiZVjFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBAepltYO
	xj2rPugdYmTiYDzEKMHBrCTCa2K6MVWINyWxsiq1KD++qDQntfgQozQHi5I477fXvSlCAumJ
	JanZqakFqUUwWSYOTqkGprKllX+8RJJffy2+rXlqnvCvQHPvS5rfLNY6yCSJqcmf8eU1uWv3
	Oe7Y2puP0z5YxoWzep0Oe2C57ONpTXMT6ztXeb+JxdZNDOYWZ3cTZAk1OfWrKsMjXIJBz7U2
	+Z5d2bTWPStTsm8mqZWI+Tp84dx3Yub5RkmRkEMRq1/pZhWrKefsF06cIa90tT+oZqs+77zQ
	B1Z3q3zvpMu+dzeb9L/2qux86WetEay2J3JFOJ5tce98YhxzhmMeh0FYiITLh4R2MzfnH+wa
	Z880ftn5cv78myu3SR3WUX43TeDUkqDrX57vFZgVH+Sz/uCtkj/7U/TdPjQs11t96eqX1hsz
	db7kv/EPWOv05uPrguN6SizFGYmGWsxFxYkAM8krfcECAAA=
X-CMS-MailID: 20240125054351epcas5p3d0cd3a76619116d48afa73da0d88e38d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240125054351epcas5p3d0cd3a76619116d48afa73da0d88e38d
References: <20240125110124.55137-1-ankit.kumar@samsung.com>
	<CGME20240125054351epcas5p3d0cd3a76619116d48afa73da0d88e38d@epcas5p3.samsung.com>

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

