Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6B014A0B7
	for <fio@vger.kernel.org>; Tue, 27 Aug 2024 07:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724742543; cv=none; b=UpRfK/NKMToNNlXEpePnBrZhPCH3oU9hSyR5htujhfkk5rv9YA4EjwSHlN4YUudN1F6Urj9l3cYVBzx+kbSHbbMNS0FzTFVFZsS/O9Rb93Se89YWtgz2zZ5OfufE9G4EZX2BmNhXuL3GvbbHDpc+gmg3w7GG0vFjdyaBPTDEhmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724742543; c=relaxed/simple;
	bh=GF7tT8rnJRQOzXfigTlCQwDYBre5ArV+8EyBpgGwios=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XU9yI688ZqV5H5XPwS3K8nteHw8iKJBgpfZR7I5WK6AWmxs+7RXGSjsZjzmsS9zQHpBZtKTL3ErqlEGfQgJ/A9jo5C2c+0f8I4FY+ZMco/q/QP79UeTnYTid/uMyHfiL608b5ArNxNM4FpTyOuWbe4+ZOyTziLM8jWLck6pBqSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=HY9SQ/12; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HY9SQ/12"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724742541; x=1756278541;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GF7tT8rnJRQOzXfigTlCQwDYBre5ArV+8EyBpgGwios=;
  b=HY9SQ/12D2QlXsZT2S66QVMgTMxoEr+X1Mnfw5lsGG51OOdQ+ki53zt/
   xn1aNofUrDjpiJQR41jtV61gJhC+Y2PCUIVZpTEY2gjTGQg+pivFdUwrw
   M8km8CcTU/b2km3emE2j97kAtgrMO2oz65d7FiJWFAak1ShER5KlXt/CE
   nyVNlq5sOORxaQGWWveF8TN82HEXUugfADw0rSdXmByX3Ycuac1FFpIkp
   xXw3JA41GuFI25JQOotFERkFrwTaySwo0AiiFwBG1Vh4UPsW9RsVaJSNi
   BADzKSNXAvzDjU7fE92YUbRTDhk+fBS7gkAhfb5qAmcp4e0UV5RyCIcck
   g==;
X-CSE-ConnectionGUID: VLIPKBHmTbWwv23LxormUQ==
X-CSE-MsgGUID: gHHmoOnCQ+2B1XYS5kbVpQ==
X-IronPort-AV: E=Sophos;i="6.10,179,1719849600"; 
   d="scan'208";a="25297870"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Aug 2024 15:08:55 +0800
IronPort-SDR: 66cd6ec8_nw63vXpstvrHwnqFE5UVu9H1MsOTWcttlge8yDN3j1RP0Ep
 RAH4xmBaLKm1+7hkhYcV7YWkNBlInqhlONjfLYg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Aug 2024 23:14:33 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 27 Aug 2024 00:08:54 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 3/9] iolog: refactor flush_samples()
Date: Tue, 27 Aug 2024 16:08:44 +0900
Message-ID: <20240827070850.947037-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
References: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

flush_samples() controls the log file format depending on the options
log_avg_msec, log_window_value, log_offset and log_prio. It has deeply
nested branches to check the options. These nested branches make it
difficult to add more fields to the log file format. For ease of the log
file format improvements, refactor the function. Instead of checking all
conditions at once, check each condition one by one, generate small
strings for each field and add them to the final string to output. For
this purpose, introduce the new function print_sample_fields() which
generates each field string.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 iolog.c | 131 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 67 insertions(+), 64 deletions(-)

diff --git a/iolog.c b/iolog.c
index f727c97f..06b51ea0 100644
--- a/iolog.c
+++ b/iolog.c
@@ -1009,13 +1009,42 @@ static void flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
 	}
 }
 
+static int print_sample_fields(char **p, size_t *left, const char *fmt, ...) {
+	va_list ap;
+	int ret;
+
+	va_start(ap, fmt);
+	ret = vsnprintf(*p, *left, fmt, ap);
+	if (ret < 0 || ret >= *left) {
+		log_err("sample file write failed: %d\n", ret);
+		return -1;
+	}
+	va_end(ap);
+
+	*p += ret;
+	*left -= ret;
+
+	return 0;
+}
+
+/*
+ * flush_samples - Generate output for log samples
+ * Each sample output is built using a temporary buffer. This buffer size
+ * assumptions are:
+ * - Each sample has less than 10 fields
+ * - Each sample field fits in 25 characters (20 digits for 64 bit number
+ *   and a few bytes delimiter)
+ */
 void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 {
 	struct io_sample *s;
-	int log_offset, log_prio, log_avg_max;
+	struct io_sample_offset *sa;
+	bool log_offset, log_prio, log_avg_max;
 	uint64_t i, nr_samples;
-	unsigned int prio_val;
-	const char *fmt;
+	char buf[256];
+	char *p;
+	size_t left;
+	int ret;
 
 	if (!sample_size)
 		return;
@@ -1025,75 +1054,49 @@ void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 	log_prio = (s->__ddir & LOG_PRIO_SAMPLE_BIT) != 0;
 	log_avg_max = (s->__ddir & LOG_AVG_MAX_SAMPLE_BIT) != 0;
 
-	if (log_offset) {
-		if (log_prio) {
-			if (log_avg_max)
-				fmt = "%" PRIu64 ", %" PRId64 ", %" PRId64 ", %u, %llu, %llu, 0x%04x\n";
-			else
-				fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %llu, 0x%04x\n";
-		} else {
-			if (log_avg_max)
-				fmt = "%" PRIu64 ", %" PRId64 ", %" PRId64 ", %u, %llu, %llu, %u\n";
-			else
-				fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %llu, %u\n";
-		}
-	} else {
-		if (log_prio) {
-			if (log_avg_max)
-				fmt = "%" PRIu64 ", %" PRId64 ", %" PRId64 ", %u, %llu, 0x%04x\n";
-			else
-				fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, 0x%04x\n";
-		} else {
-			if (log_avg_max)
-				fmt = "%" PRIu64 ", %" PRId64 ", %" PRId64 ", %u, %llu, %u\n";
-			else
-				fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %u\n";
-		}
-	}
-
 	nr_samples = sample_size / __log_entry_sz(log_offset);
 
 	for (i = 0; i < nr_samples; i++) {
 		s = __get_sample(samples, log_offset, i);
+		sa = (void *) s;
+		p = buf;
+		left = sizeof(buf);
+
+		ret = print_sample_fields(&p, &left, "%" PRIu64 ", %" PRId64,
+					  s->time, s->data.val.val0);
+		if (ret)
+			return;
+
+		if (log_avg_max) {
+			ret = print_sample_fields(&p, &left, ", %" PRId64,
+						  s->data.val.val1);
+			if (ret)
+				return;
+		}
+
+		ret = print_sample_fields(&p, &left, ", %u, %llu",
+					  io_sample_ddir(s),
+					  (unsigned long long) s->bs);
+		if (ret)
+			return;
+
+		if (log_offset) {
+			ret = print_sample_fields(&p, &left, ", %llu",
+						  (unsigned long long) sa->offset);
+			if (ret)
+				return;
+		}
 
 		if (log_prio)
-			prio_val = s->priority;
+			ret = print_sample_fields(&p, &left, ", 0x%04x",
+						  s->priority);
 		else
-			prio_val = ioprio_value_is_class_rt(s->priority);
+			ret = print_sample_fields(&p, &left, ", %u",
+						  ioprio_value_is_class_rt(s->priority));
+		if (ret)
+			return;
 
-		if (!log_offset) {
-			if (log_avg_max)
-				fprintf(f, fmt,
-					s->time,
-					s->data.val.val0,
-					s->data.val.val1,
-					io_sample_ddir(s), (unsigned long long) s->bs,
-					prio_val);
-			else
-				fprintf(f, fmt,
-					s->time,
-					s->data.val.val0,
-					io_sample_ddir(s), (unsigned long long) s->bs,
-					prio_val);
-		} else {
-			struct io_sample_offset *so = (void *) s;
-
-			if (log_avg_max)
-				fprintf(f, fmt,
-					s->time,
-					s->data.val.val0,
-					s->data.val.val1,
-					io_sample_ddir(s), (unsigned long long) s->bs,
-					(unsigned long long) so->offset,
-					prio_val);
-			else
-				fprintf(f, fmt,
-					s->time,
-					s->data.val.val0,
-					io_sample_ddir(s), (unsigned long long) s->bs,
-					(unsigned long long) so->offset,
-					prio_val);
-		}
+		fprintf(f, "%s\n", buf);
 	}
 }
 
-- 
2.45.2

