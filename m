Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8769568A
	for <fio@vger.kernel.org>; Mon, 22 Jan 2024 06:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705904046; cv=none; b=s9FEw1Qmp1c17ri7nxKAS73LdIZ+t5WMGnNvcrw8rBnpHys8ukNZrI+SVGKh54brt5IimdpthjC+4lx7UrWFw0Db9RVxRRB7gLS4mUN0HjHU9gZ0w31rsIJ0vglN/ZLKgTW2JvnF/Tek2wtPz8+FgB/aAh77lv2JetGEcGwp2Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705904046; c=relaxed/simple;
	bh=B8p5P7MXme7JPTBTKurv0apEo4JMbmk20/Pv0yixUjY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Z3+93Ncoi1B/kGDI4F7BO0JaF8eoT3jNlYIzDBjhY9qJRugHZ0B4pyMRKN6b7YWZBEuWbK41HsRDaS/2/fJfc5VYfnIMX7sSUqT9+PQshEjemTek47XLN3PCauHyIOfbZuf8aw/ZxQNzfJcSQVpq6Q31q/nqouHx79//2tQ66UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=UZr1MFBN; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="UZr1MFBN"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240122061356epoutp04676a0eeba16008b37fb57158eee2be25~slq64FL202710727107epoutp04N
	for <fio@vger.kernel.org>; Mon, 22 Jan 2024 06:13:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240122061356epoutp04676a0eeba16008b37fb57158eee2be25~slq64FL202710727107epoutp04N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1705904036;
	bh=IqusbaVmrFYEHeI7l2LUHoR1SiKXQQHM3FJfT+O3PcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZr1MFBN1cmy/fNUpVsVU6LMIOIC6GnJbMO3jzAnVrO4NAunRkeIE8GzPiLWEfxph
	 w3ZdcmJkGzDWy0YA1xq4cVx1i7pdaIG7JmMh4KVXPo1ScUFhf4xty9WxFfyYB8b50C
	 /GaMkETIkWXlv5VHVGm+ug5YHnAScB59xYLLXeK8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240122061355epcas5p35ac542cfc4a3a7b8eb44142e69655906~slq6aocWa1773417734epcas5p34;
	Mon, 22 Jan 2024 06:13:55 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4TJKfp2ZrJz4x9Q4; Mon, 22 Jan
	2024 06:13:54 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E4.1A.09634.2A70EA56; Mon, 22 Jan 2024 15:13:54 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240122060525epcas5p17d417303b27a454e1db288a61e0642fc~sljfa_z-42897428974epcas5p1K;
	Mon, 22 Jan 2024 06:05:25 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240122060525epsmtrp2eaa7fa0c5b556ee468ace59851764dc6~sljfabwqG2013020130epsmtrp2T;
	Mon, 22 Jan 2024 06:05:25 +0000 (GMT)
X-AuditID: b6c32a49-159fd700000025a2-1f-65ae07a211b2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0E.1B.08817.5A50EA56; Mon, 22 Jan 2024 15:05:25 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240122060524epsmtip17355b997344df09176c98f86814ffe88~sljeqVVay2308523085epsmtip12;
	Mon, 22 Jan 2024 06:05:24 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/2] stat: log out both average and max over the window
Date: Mon, 22 Jan 2024 16:52:59 +0530
Message-Id: <20240122112300.47805-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240122112300.47805-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsWy7bCmhu4i9nWpBu8+CFisufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASlW2TkZqYklqkkJqXnJ+SmZduq+Qd
	HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RQSaEsMacUKBSQWFyspG9nU5RfWpKqkJFf
	XGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBgZApUmJCdMb+riangSWBF15c3bA2Mbx26GDk5
	JARMJGZ07mXrYuTiEBLYzSjxf+JlJpCEkMAnRokj5xMh7G+MEuf+inQxcoA1rO8ygKjfyyjR
	teY4K4TTySRxa90tFpAGNgFtiVdvbzCDNIgIaEisuZsKEmYWsJO4evglG4gtLOAu0b/hEjuI
	zSKgKtG4aT/YXl4BG4nVS26zQRwnLzHz0newGk4BW4n7/14wQ9QISpyc+YQFYqa8RPPW2cwg
	N0gIHGOX2P10LhNEs4vEzzmN7BC2sMSr41ugbCmJz+/2Qi3Iltj08CdUfYHEkRe9zBC2vUTr
	qX6w+5kFNCXW79KHCMtKTD21jgliL59E7+8nUK28EjvmwdiqEn/v3WaBsKUlbr67ygIJNw+J
	YztFIUE1gVHiydLf7BMYFWYheWcWkndmIWxewMi8ilEytaA4Nz212LTAMC+1HB7Dyfm5mxjB
	CVDLcwfj3Qcf9A4xMnEwHmKU4GBWEuHlV12VKsSbklhZlVqUH19UmpNafIjRFBjeE5mlRJPz
	gSk4ryTe0MTSwMTMzMzE0tjMUEmc93Xr3BQhgfTEktTs1NSC1CKYPiYOTqkGphnLwnTrjjZe
	47wf9Vjl6g9NzWld7BxSK+PX3J6TwvxF9HPI7wm3JvdMVlir+b5wp1fgi41T4pUaDZ9vq5z/
	mq3TIqE44MVkzT/lDVaMU0xXu/BOjyoOlZjwi+EBq86lp/9VjU3rSxXY7uTazZVY5TlviujF
	fuPPcfPjRPd+vLWC5XLXn3fNN1XFZ5u8KsqM/nBgR9qiVKbrxor3T9xzYf+vf1GNa9EV5/QD
	pgsXKUpG8D1fuKes6/JOy/2fGmUeLn5mYLSrsmTjPoXIp8Le6vOn/zn3axlXSvllm75a06QH
	ryYkRl9193KuzfCZx84Wt2dDYF/D1MXe+atNmSR+5+sYd+dc+W78tj9oac/aSUosxRmJhlrM
	RcWJAMOEsWUJBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWy7bCSnO5S1nWpBuvXSVisufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJUxv6uJqeBJ
	YEXXlzdsDYxvHboYOTgkBEwk1ncZdDFycQgJ7GaUaLrXyw4Rl5ZYuD6xi5ETyBSWWPnvOTtE
	TTuTxMxd91lAEmwC2hKv3t5gBrFFBLQkjq1rYgOxmQUcJP7t2gJmCwu4S/RvuMQOYrMIqEo0
	btrPBGLzCthIrF5ymw1igbzEzEvfwWo4BWwl7v97ATZTCKjm9IZtzBD1ghInZz5hgZgvL9G8
	dTbzBEaBWUhSs5CkFjAyrWKUTC0ozk3PLTYsMMpLLdcrTswtLs1L10vOz93ECA5TLa0djHtW
	fdA7xMjEwXiIUYKDWUmEl191VaoQb0piZVVqUX58UWlOavEhRmkOFiVx3m+ve1OEBNITS1Kz
	U1MLUotgskwcnFINTI1FLNoVk5wz3Uz9dv5MPPFM9mZ22XxOJ48rYqqMHFvetYa6LVFgiH/D
	fWTf/+4qo/ar19Z9fMmxbtfaTy+u8/ZePxJ10LTzUeO8PTlHPbsXbY+xlGSo9Vr3atfO8oVq
	rElMZl+N2jNt3TdOytS3naOzvN5QO3xmvXTn14wEoaZPn20Pu3bcf3Fr0drXfYvZnrM7h1TZ
	iQh+ittUHiJyK1T32tQ+1q0iu19nb3G722doItkxM2+PbMbVOUv3ivoGivKdYX2+PkBrWezS
	TwEBXR9PPSqo81usuO7izY2PpmbFRcp6/drK0m/9TLlDMXP58ejFYhVbuIQ+8/rf1fP61CK+
	MLHQ7Nr7kyLdPl3flFiKMxINtZiLihMBMgAlf8ICAAA=
X-CMS-MailID: 20240122060525epcas5p17d417303b27a454e1db288a61e0642fc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240122060525epcas5p17d417303b27a454e1db288a61e0642fc
References: <20240122112300.47805-1-ankit.kumar@samsung.com>
	<CGME20240122060525epcas5p17d417303b27a454e1db288a61e0642fc@epcas5p1.samsung.com>

Modify option log_max_value to report average, max or both the values, by
setting it to 0, 1 or 2 respectively. There is no change to existing log
formats while reporting only average or max values.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 client.c  |  6 +++--
 iolog.c   | 74 ++++++++++++++++++++++++++++++++++++++++---------------
 iolog.h   | 21 +++++++++++++---
 options.c |  8 +++---
 server.c  |  6 +++--
 stat.c    | 32 ++++++++++++++----------
 6 files changed, 104 insertions(+), 43 deletions(-)

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
index 53df03de..55b7eeb9 100644
--- a/options.c
+++ b/options.c
@@ -4541,10 +4541,12 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 	{
 		.name	= "log_max_value",
-		.lname	= "Log maximum instead of average",
-		.type	= FIO_OPT_BOOL,
+		.lname	= "Log maximum, average or both values",
+		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct thread_options, log_max),
-		.help	= "Log max sample in a window instead of average",
+		.help	= "Log max, average of both sample in a window",
+		.minval	= IO_LOG_SAMPLE_AVG,
+		.maxval	= IO_LOG_SAMPLE_BOTH,
 		.def	= "0",
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
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

