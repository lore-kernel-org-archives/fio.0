Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C940A288530
	for <fio@vger.kernel.org>; Thu,  8 May 2025 18:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746730755; cv=none; b=dvAIg+D46LiCg46P8qFaiwoNMgpGZ/jfYG0HhSVuWj0C4KKhxxA7jOaDwfTURG+BHmJqwMfJsDTcM9RhAW7ZVJrvSLfwhrfsITRjC/vioLXhDFswSdu9Pav6xWLlBeYnf5fU2xNUifSbrYX27N4rcTjgZNX9tEFyJWSN/tbBukI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746730755; c=relaxed/simple;
	bh=ZLFPwVAUOXJzRnCKpdmT29W61x7tYtur9cJ1/dAZRIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amoDP4PWhwEh/j+M1qbkmodtHP9kbkxHaF2ucyIGyGArjBueqyHzRiapsaR6NB3NFdoou3oBMKaIB15U4NLSso4HoUISO89hh4WRtIcPfrgknyAl5qk9ID3lmw/QZmidH5J3L0++zvHBTptnvfp5ZT3T6K5vybjrO8NKloOQqDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qkh0JXy8; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qkh0JXy8"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7cadd46eb07so142517085a.3
        for <fio@vger.kernel.org>; Thu, 08 May 2025 11:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746730752; x=1747335552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EDCHjIegl9LEoem7c/iaEaUgBRnGZK9JLIIJ1MObHGw=;
        b=Qkh0JXy87vVteZt/6F+bX6q5kltdwvtpdeRs9RyTUbuyaThrB/yuLeNf8EZNmVik+p
         zlpopliI5O+ULmxuUuiaZXokvip1QlH4joslU8+VfdCpuVZzGvvJD2jsArJAO66HpbTo
         ECRLb+upUOEBavrBpJ53csR2byqme5zggAbzKfunbWqji7IitFOxUxI1vz2oGsAVhhow
         QaOEUQxTyFUNbR/KRtKRE0da0Mc0pDudqacbE9J41tqMFIRitSOhXLLum8NPIh8YLmrh
         io6n9bXxZQG7GeFcKJfb6qHENcuKO7fQqfD0yGpuaQlGjQONGSjWF9xcwe7erivG+3xf
         HHgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746730752; x=1747335552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EDCHjIegl9LEoem7c/iaEaUgBRnGZK9JLIIJ1MObHGw=;
        b=Q/80aDIcAaquu0MvGHWgwH6evLP7X9TXSgWpNHs1Kl6TpuVmx9BPXcgldMESSWelB4
         bfKtfPMhFy5Yq3CycWJ20pCaJRKoul4Clm9KBXLdBsg0cahIOdn6WmWSgvzra9MdIjbN
         YujVgyBvH3igir/Fz+oatrWC/Oz5aOrSswXV32DZjYFrwbW3b9z5luS2ffZRRGXtQKDT
         qxYDJ4JxgpDNvl5s8zPijR2wHCQxpmfO5+ODIeE5d+pn5zvFOClQM2yI2AocDWBRSqU+
         3VtoV0yZAEkZBAauWetT2cAmomtwcqn96f8P452JHk5mcw7LRFUuNkwBhsOGaWNA2wZS
         Mu8w==
X-Gm-Message-State: AOJu0YwKArdu9Kfp5Ou0xk6Q5MxhVN+LxA2cGxkPrVkkCD89SkCFUvGw
	/RjAXLl1uc3kC+Ml4U2ypxA9pPW0PFA7xdqRtefQ+SKFv7rOXGGfmw9IBbc7
X-Gm-Gg: ASbGnctvppKdcJGY43Dsi5hXy3CeESymg01VM+Mh5WDQat8J/nrlKAsffUHaHaobFW7
	XsEHZ6KFA2KI9XQv/D8RHOsxQu4DUKLKA4WIwzIYSg+4/KD9yVTxpjBCN0Ic9o7XU3GOx9FWd+J
	8Gvm1EK4joHe1BnZVKRv8RTHiWhsoYVZRtXbFf1Bf92lD2YL46t2uTUpftF9+l0WULM1zbZL+8f
	80pcC35oU5/WRVZLtekdjc8ZuH1g7mFLGelUAsOi6zbL6VvPwDwc8d5pksoyJ7cqqGQ7elkcTtZ
	oB+5ylDbFiPDK7lYzEltubt0YvYs4D8qBHR1bkMT4RFgHlLRsQmy6movtW+m55D837oBpyog0vm
	dQ4p7IEkKE+5vTC0pQ0CY3uifHGU/08KClTqTcagw
X-Google-Smtp-Source: AGHT+IE41nuG/6nXVVD1C4nUgTYsuHHn0RvQAIGtTifvVEgJxajlijdIO5uQPp9cOAGjrFxNRJBHqA==
X-Received: by 2002:a05:620a:2443:b0:7c7:b4ba:ebf9 with SMTP id af79cd13be357-7cd011053e0mr115550285a.22.1746730751599;
        Thu, 08 May 2025 11:59:11 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7cd00fdc59csm26611785a.77.2025.05.08.11.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 11:59:10 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.dk
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 08/11] verify: add verify_pattern_interval option
Date: Thu,  8 May 2025 14:58:16 -0400
Message-ID: <20250508185832.3702-9-vincent.fu@samsung.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250508185832.3702-1-vincent.fu@samsung.com>
References: <20250508185832.3702-1-vincent.fu@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It can be useful to fill a device by writing each LBA with its offset
using a verify_pattern value that includes the %o format specifier.
However, it is slow to do this 512B at a time for a large device. This
patch adds the verify_pattern_interval option to enable fio to write
such a data pattern using larger transfer sizes. With this option set,
fio will update the offset every verify_pattern_interval bytes. For a
4096-byte block with verify_pattern=%o the first 512 bytes will be 0,
the second 512 bytes will be 512, the third 512 bytes will be 1024, etc
when verify_pattern_interval=512.

When verify_pattern does not include %o the verify_pattern_interval
option will still re-start the verify pattern eveny N bytes.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 HOWTO.rst        |   8 +++
 cconv.c          |   2 +
 fio.1            |   7 +++
 options.c        |  12 +++++
 server.h         |   2 +-
 thread_options.h |   3 ++
 verify.c         | 125 ++++++++++++++++++++++++++++++++++++-----------
 7 files changed, 129 insertions(+), 30 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 78a259ef..f082158a 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3977,6 +3977,14 @@ Verification
 
 		verify_pattern=0xff%o"abcd"-12
 
+.. option:: verify_pattern_interval=bool
+
+        Recreate an instance of the :option:`verify_pattern` every
+        :option:`verify_pattern_interval` bytes. This is only useful when
+        :option:`verify_pattern` contains the %o format specifier and can be
+        used to speed up the process of writing each block on a device with its
+        offset. Default: 0 (disabled).
+
 .. option:: verify_fatal=bool
 
 	Normally fio will keep checking the entire contents before quitting on a
diff --git a/cconv.c b/cconv.c
index cc1a52c7..d2faf83e 100644
--- a/cconv.c
+++ b/cconv.c
@@ -186,6 +186,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->verify_header_seed = le32_to_cpu(top->verify_header_seed);
 
 	o->verify_pattern_bytes = le32_to_cpu(top->verify_pattern_bytes);
+	o->verify_pattern_interval = le32_to_cpu(top->verify_pattern_interval);
 	o->buffer_pattern_bytes = le32_to_cpu(top->buffer_pattern_bytes);
 	if (o->verify_pattern_bytes >= MAX_PATTERN_SIZE ||
 	    o->buffer_pattern_bytes >= MAX_PATTERN_SIZE ||
@@ -448,6 +449,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->verify_write_sequence = cpu_to_le32(o->verify_write_sequence);
 	top->verify_header_seed = cpu_to_le32(o->verify_header_seed);
 	top->verify_pattern_bytes = cpu_to_le32(o->verify_pattern_bytes);
+	top->verify_pattern_interval = cpu_to_le32(o->verify_pattern_interval);
 	top->verify_fatal = cpu_to_le32(o->verify_fatal);
 	top->verify_dump = cpu_to_le32(o->verify_dump);
 	top->verify_async = cpu_to_le32(o->verify_async);
diff --git a/fio.1 b/fio.1
index d6ee4193..f7141e75 100644
--- a/fio.1
+++ b/fio.1
@@ -3701,6 +3701,13 @@ verify_pattern=0xff%o"abcd"\-12
 .RE
 .RE
 .TP
+.BI verify_pattern_interval \fR=\fPbool
+Recreate an instance of the \fBverify_pattern\fR every
+\fBverify_pattern_interval\fR bytes. This is only useful when
+\fBverify_pattern\fR contains the %o format specifier and can be used to speed
+up the process of writing each block on a device with its offset. Default:
+0 (disabled).
+.TP
 .BI verify_fatal \fR=\fPbool
 Normally fio will keep checking the entire contents before quitting on a
 block verification failure. If this option is set, fio will exit the job on
diff --git a/options.c b/options.c
index 28ffc748..cfece3fe 100644
--- a/options.c
+++ b/options.c
@@ -3291,6 +3291,18 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_VERIFY,
 	},
+	{
+		.name	= "verify_pattern_interval",
+		.lname	= "Running verify pattern",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, verify_pattern_interval),
+		.def	= "0",
+		.help	= "Re-create verify pattern every N bytes",
+		.parent = "verify",
+		.hide	= 1,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_VERIFY,
+	},
 	{
 		.name	= "verify_fatal",
 		.lname	= "Verify fatal",
diff --git a/server.h b/server.h
index 0b93cd02..713fd8e4 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 110,
+	FIO_SERVER_VER			= 111,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index b0094651..6c9dd80a 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -146,6 +146,7 @@ struct thread_options {
 	unsigned int verify_offset;
 	char *verify_pattern;
 	unsigned int verify_pattern_bytes;
+	unsigned int verify_pattern_interval;
 	struct pattern_fmt verify_fmt[8];
 	unsigned int verify_fmt_sz;
 	unsigned int verify_fatal;
@@ -478,6 +479,7 @@ struct thread_options_pack {
 	uint32_t verify_interval;
 	uint32_t verify_offset;
 	uint32_t verify_pattern_bytes;
+	uint32_t verify_pattern_interval;
 	uint32_t verify_fatal;
 	uint32_t verify_dump;
 	uint32_t verify_async;
@@ -517,6 +519,7 @@ struct thread_options_pack {
 
 	struct zone_split zone_split[DDIR_RWDIR_CNT][ZONESPLIT_MAX];
 	uint32_t zone_split_nr[DDIR_RWDIR_CNT];
+	uint32_t pad2;
 
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
diff --git a/verify.c b/verify.c
index cffe5999..04718f30 100644
--- a/verify.c
+++ b/verify.c
@@ -51,6 +51,8 @@ void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
 			 struct io_u *io_u, uint64_t seed, int use_seed)
 {
 	struct thread_options *o = &td->o;
+	unsigned int interval = o->verify_pattern_interval;
+	unsigned long long offset = io_u->offset;
 
 	if (!o->verify_pattern_bytes) {
 		dprint(FD_VERIFY, "fill random bytes len=%u\n", len);
@@ -74,10 +76,24 @@ void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
 		return;
 	}
 
-	(void)paste_format(td->o.verify_pattern, td->o.verify_pattern_bytes,
-			   td->o.verify_fmt, td->o.verify_fmt_sz,
-			   p, len, io_u);
+	if (!interval)
+		interval = len;
+
+	io_u->offset += (p - io_u->buf) - (p - io_u->buf) % interval;
+	for (unsigned int bytes_done = 0, bytes_todo = 0; bytes_done < len;
+			bytes_done += bytes_todo, p += bytes_todo, io_u->offset += interval) {
+		bytes_todo = (p - io_u->buf) % interval;
+		if (!bytes_todo)
+			bytes_todo = interval;
+		bytes_todo = min(bytes_todo, len - bytes_done);
+
+		(void)paste_format(td->o.verify_pattern, td->o.verify_pattern_bytes,
+				   td->o.verify_fmt, td->o.verify_fmt_sz,
+				   p, bytes_todo, io_u);
+	}
+
 	io_u->buf_filled_len = len;
+	io_u->offset = offset;
 }
 
 static unsigned int get_hdr_inc(struct thread_data *td, struct io_u *io_u)
@@ -373,6 +389,40 @@ static inline void *io_u_verify_off(struct verify_header *hdr, struct vcont *vc)
 	return vc->io_u->buf + vc->hdr_num * hdr->len + hdr_size(vc->td, hdr);
 }
 
+static int check_pattern(char *buf, unsigned int len, unsigned int mod,
+		unsigned int pattern_size, char *pattern, unsigned int header_size)
+{
+	unsigned int i;
+	int rc;
+
+	rc = cmp_pattern(pattern, pattern_size, mod, buf, len);
+	if (!rc)
+		goto done;
+
+	/* Slow path, compare each byte */
+	for (i = 0; i < len; i++) {
+		if (buf[i] != pattern[mod]) {
+			unsigned int bits;
+
+			bits = hweight8(buf[i] ^ pattern[mod]);
+			log_err("fio: got pattern '%02x', wanted '%02x'. Bad bits %d\n",
+				(unsigned char)buf[i],
+				(unsigned char)pattern[mod],
+				bits);
+			log_err("fio: bad pattern block offset %u\n",
+				i + header_size);
+			rc = EILSEQ;
+			goto done;
+		}
+		mod++;
+		if (mod == pattern_size)
+			mod = 0;
+	}
+
+done:
+	return rc;
+}
+
 /*
  *  The current thread will need its own buffer if there are multiple threads
  *  and the pattern contains the offset. Fio currently only has one pattern
@@ -386,15 +436,15 @@ static inline bool pattern_need_buffer(struct thread_data *td)
 		td->o.verify_fmt[0].desc->paste == paste_blockoff;
 }
 
-
 static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
 {
 	struct thread_data *td = vc->td;
 	struct io_u *io_u = vc->io_u;
 	char *buf, *pattern;
 	unsigned int header_size = __hdr_size(td->o.verify);
-	unsigned int len, mod, i, pattern_size;
+	unsigned int len, mod, pattern_size, pattern_interval_mod, bytes_done = 0, bytes_todo;
 	int rc;
+	unsigned long long offset = io_u->offset;
 
 	pattern = td->o.verify_pattern;
 	pattern_size = td->o.verify_pattern_bytes;
@@ -410,40 +460,57 @@ static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
 		memcpy(pattern, td->o.verify_pattern, pattern_size);
 	}
 
-	(void)paste_format_inplace(pattern, pattern_size,
-				   td->o.verify_fmt, td->o.verify_fmt_sz, io_u);
+	if (!td->o.verify_pattern_interval) {
+		(void)paste_format_inplace(pattern, pattern_size,
+					   td->o.verify_fmt, td->o.verify_fmt_sz, io_u);
+	}
+
+	/*
+	 * We have 3 cases here:
+	 * 1. Compare the entire buffer if (1) verify_interval is not set and
+	 * (2) verify_pattern_interval is not set
+	 * 2. Compare the entire *verify_interval* if (1) verify_interval *is*
+	 * set and (2) verify_pattern_interval is not set
+	 * 3. Compare *verify_pattern_interval* segments or subsets thereof if
+	 * (2) verify_pattern_interval is set
+	 */
 
 	buf = (char *) hdr + header_size;
 	len = get_hdr_inc(td, io_u) - header_size;
-	mod = (get_hdr_inc(td, io_u) * vc->hdr_num + header_size) % pattern_size;
-
-	rc = cmp_pattern(pattern, pattern_size, mod, buf, len);
-	if (!rc)
-		goto done;
+	if (td->o.verify_pattern_interval) {
+		unsigned int extent = get_hdr_inc(td, io_u) * vc->hdr_num + header_size;
+		pattern_interval_mod = extent % td->o.verify_pattern_interval;
+		mod = pattern_interval_mod % pattern_size;
+		bytes_todo = min(len, td->o.verify_pattern_interval - pattern_interval_mod);
+		io_u->offset += extent / td->o.verify_pattern_interval * td->o.verify_pattern_interval;
+	} else {
+		mod = (get_hdr_inc(td, io_u) * vc->hdr_num + header_size) % pattern_size;
+		bytes_todo = len;
+		pattern_interval_mod = 0;
+	}
 
-	/* Slow path, compare each byte */
-	for (i = 0; i < len; i++) {
-		if (buf[i] != pattern[mod]) {
-			unsigned int bits;
+	while (bytes_done < len) {
+		if (td->o.verify_pattern_interval) {
+			(void)paste_format_inplace(pattern, pattern_size,
+					td->o.verify_fmt, td->o.verify_fmt_sz,
+					io_u);
+		}
 
-			bits = hweight8(buf[i] ^ pattern[mod]);
-			log_err("fio: got pattern '%02x', wanted '%02x'. Bad bits %d\n",
-				(unsigned char)buf[i],
-				(unsigned char)pattern[mod],
-				bits);
-			log_err("fio: bad pattern block offset %u\n",
-				i + header_size);
+		rc = check_pattern(buf, bytes_todo, mod, pattern_size, pattern, header_size);
+		if (rc) {
 			vc->name = "pattern";
 			log_verify_failure(hdr, vc);
-			rc = EILSEQ;
-			goto done;
+			break;
 		}
-		mod++;
-		if (mod == td->o.verify_pattern_bytes)
-			mod = 0;
+
+		mod = 0;
+		bytes_done += bytes_todo;
+		buf += bytes_todo;
+		io_u->offset += td->o.verify_pattern_interval;
+		bytes_todo = min(len - bytes_done, td->o.verify_pattern_interval);
 	}
 
-done:
+	io_u->offset = offset;
 	if (pattern_need_buffer(td))
 		free(pattern);
 	return rc;
-- 
2.47.2

