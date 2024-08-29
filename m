Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B712018C344
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 08:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724921914; cv=none; b=h1weWw2lD04L1qDrM8omGJ0d7bNNpaeMBrS/dvjcpbLDSunEKXonP/HkGybJGsU4ybVwQ7XqPGU0FfT95SBwj2Q1l44iEYWkW0nRDJvuavo5o9NTScRuwUI+VdvVKn+PKOkxORY8tkOMlUg4z4tCee+OFffkjWGlbdTSDbYNIrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724921914; c=relaxed/simple;
	bh=cnmPP2gQ/xFFIEX4gPohC/JvoFrj1/FJ4mRIWZ8h+gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5gN0j5gsyUYZWcNjuttVE0e23d2xLz9TVMCsrgR+Nd5q8xONUzOYQ9Atqrirn6LkSj78PNJgKFBuzL5WmDSe+ya1/NFtaiibfBkISs4csYXSR+Exg06405WSo/mg6HfZ2rk6Emg59jkRISORb9D+aAq1qFvN9g8BeqtzcArYxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KwWF4jOn; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KwWF4jOn"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724921912; x=1756457912;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cnmPP2gQ/xFFIEX4gPohC/JvoFrj1/FJ4mRIWZ8h+gE=;
  b=KwWF4jOn0kfOhik143qTpcKw7L0Ba1KePMytjeLKy9Mpwvrj9oKdNNy/
   g/toME2DIvPFMl8/dbEty5wmYhvfSgb3G74VHPJiowDabvSufxm9Xq0cv
   lp4V9ZiPBbqFJ60HfkLD14LPxtP6DvJiEQBt9PjY6uw82FapdpgQAcKZ0
   EKYTF+2dLxVs+Et1+pfUBXYHNEyTaHFLXb4cOfsRK5ytDZ3kU+7Palxfm
   8rxNzl9adOEyB5bgH9Br9RUo4BpNJ9GmSJu5lZ+ZzvNNZ/VehxENDrHSY
   Oyk26ZCnnsQqN3/5T5vOeHA2tT6nQD6p7hry/gSpJ9g/ps2XTAVguceyb
   w==;
X-CSE-ConnectionGUID: v5XVuhGhQfatWeiJKCMjWA==
X-CSE-MsgGUID: sSetgLIoSBa6k2eh3r6Utg==
X-IronPort-AV: E=Sophos;i="6.10,185,1719849600"; 
   d="scan'208";a="24854824"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 29 Aug 2024 16:58:32 +0800
IronPort-SDR: 66d02a23_zKQBmSvo+GqQiBqLuBTmh0cRAKPHBLvi0KGQLWNR154O8bs
 OhK6dxV+YBLxwgVUgwujayZHz7qd8RVlJgLlfOw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Aug 2024 00:58:27 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 29 Aug 2024 01:58:31 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Nick Neumann <nick@pcpartpicker.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 4/9] iolog: drop struct io_sample_offset
Date: Thu, 29 Aug 2024 17:58:21 +0900
Message-ID: <20240829085826.999859-5-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240829085826.999859-1-shinichiro.kawasaki@wdc.com>
References: <20240829085826.999859-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fio uses the struct io_sample to log attributes of each IO. When the
log_offset option is set, fio uses the struct io_sample_offset instead
which has the additional field dedicated to the offset data. Fio chooses
one of these two structs by the log_offset option to minimize memory
usage for IO sampling. However, the dedicated struct io_sample_offset is
not flexible and makes it difficult to add new sampling items.

To allow adding new sampling items, drop the struct io_sample_offset.
Instead, introduce the variable length array "uint64_t aux[]" at the
end of the struct io_sample which holds any auxiliary sampling data.
At this moment, it holds only one item "offset" as the first array
element. The following patch will add a new item.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 client.c |  8 +++-----
 iolog.c  |  4 +---
 iolog.h  | 19 ++++++++++++-------
 server.c |  8 +++-----
 stat.c   |  7 ++-----
 5 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/client.c b/client.c
index 4cb7dffe..0b6044dd 100644
--- a/client.c
+++ b/client.c
@@ -1726,11 +1726,9 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 		s->bs		= le64_to_cpu(s->bs);
 		s->priority	= le16_to_cpu(s->priority);
 
-		if (ret->log_offset) {
-			struct io_sample_offset *so = (void *) s;
-
-			so->offset = le64_to_cpu(so->offset);
-		}
+		if (ret->log_offset)
+			s->aux[IOS_AUX_OFFSET_INDEX] =
+				le64_to_cpu(s->aux[IOS_AUX_OFFSET_INDEX]);
 
 		if (ret->log_type == IO_LOG_TYPE_HIST) {
 			s->data.plat_entry = (struct io_u_plat_entry *)(((char *)s) + sizeof(*s));
diff --git a/iolog.c b/iolog.c
index 06b51ea0..bb1ade86 100644
--- a/iolog.c
+++ b/iolog.c
@@ -1038,7 +1038,6 @@ static int print_sample_fields(char **p, size_t *left, const char *fmt, ...) {
 void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 {
 	struct io_sample *s;
-	struct io_sample_offset *sa;
 	bool log_offset, log_prio, log_avg_max;
 	uint64_t i, nr_samples;
 	char buf[256];
@@ -1058,7 +1057,6 @@ void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 
 	for (i = 0; i < nr_samples; i++) {
 		s = __get_sample(samples, log_offset, i);
-		sa = (void *) s;
 		p = buf;
 		left = sizeof(buf);
 
@@ -1082,7 +1080,7 @@ void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 
 		if (log_offset) {
 			ret = print_sample_fields(&p, &left, ", %llu",
-						  (unsigned long long) sa->offset);
+						  (unsigned long long) s->aux[IOS_AUX_OFFSET_INDEX]);
 			if (ret)
 				return;
 		}
diff --git a/iolog.h b/iolog.h
index 26dd5cca..d868921b 100644
--- a/iolog.h
+++ b/iolog.h
@@ -54,11 +54,14 @@ struct io_sample {
 	uint32_t __ddir;
 	uint16_t priority;
 	uint64_t bs;
+	uint64_t aux[];
 };
 
-struct io_sample_offset {
-	struct io_sample s;
-	uint64_t offset;
+/*
+ * Enumerate indexes of auxiliary log data in struct io_sample aux[] array
+ */
+enum {
+	IOS_AUX_OFFSET_INDEX,
 };
 
 enum {
@@ -180,12 +183,14 @@ static inline void io_sample_set_ddir(struct io_log *log,
 	io->__ddir = ddir | log->log_ddir_mask;
 }
 
-static inline size_t __log_entry_sz(int log_offset)
+static inline size_t __log_entry_sz(bool log_offset)
 {
+	size_t ret = sizeof(struct io_sample);
+
 	if (log_offset)
-		return sizeof(struct io_sample_offset);
-	else
-		return sizeof(struct io_sample);
+		ret += sizeof(uint64_t);
+
+	return ret;
 }
 
 static inline size_t log_entry_sz(struct io_log *log)
diff --git a/server.c b/server.c
index afaeb348..dbb9eb5e 100644
--- a/server.c
+++ b/server.c
@@ -2295,11 +2295,9 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 			s->__ddir	= __cpu_to_le32(s->__ddir);
 			s->bs		= cpu_to_le64(s->bs);
 
-			if (log->log_offset) {
-				struct io_sample_offset *so = (void *) s;
-
-				so->offset = cpu_to_le64(so->offset);
-			}
+			if (log->log_offset)
+				s->aux[IOS_AUX_OFFSET_INDEX] =
+					cpu_to_le64(s->aux[IOS_AUX_OFFSET_INDEX]);
 		}
 	}
 
diff --git a/stat.c b/stat.c
index 03681b9d..56d04e7a 100644
--- a/stat.c
+++ b/stat.c
@@ -3063,11 +3063,8 @@ static void __add_log_sample(struct io_log *iolog, unsigned long t,
 		s->bs = sample->bs;
 		s->priority = sample->priority;
 
-		if (iolog->log_offset) {
-			struct io_sample_offset *so = (void *) s;
-
-			so->offset = sample->offset;
-		}
+		if (iolog->log_offset)
+			s->aux[IOS_AUX_OFFSET_INDEX] = sample->offset;
 
 		cur_log->nr_samples++;
 		return;
-- 
2.45.2

