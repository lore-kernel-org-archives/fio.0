Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055B5288527
	for <fio@vger.kernel.org>; Thu,  8 May 2025 18:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746730748; cv=none; b=UdRyRva5RK/D2XAg8QsITlILn6SI19s5eYbReKwCjlYCfv9+gERAORzpb+vUKD/ZbnP5hb3cY9m1r2ynWV1AKf0BBdcu7f2cSMHa3/FRSx2wrlxTlwvS3jV1ABGRbyJP9Z4pTTtSZ4gIpfkhNd3yXOIKvG9oWigDB7rCgkwqsO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746730748; c=relaxed/simple;
	bh=p+BFRP60uOnBPbgH8EKghSZQ1Cw3BQlcZxqLBPLSGxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHHwnhokQzA6O2PkcOeSZr/L5OkH4Ddtzc2EqZovTg0LYohNmGGU0bMCaQRRRwYguEHIlBHc+lSUQthDX4IbE2ViuSEsRSsARm4okCnPxUAkbZ0aJu5FGAu8ijvfdOopOABOFgZaWZrXK0mp8iLCUVkfJ40qu9KHWqmoDFMQSqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dze2bDG8; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dze2bDG8"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7c560c55bc1so164493285a.1
        for <fio@vger.kernel.org>; Thu, 08 May 2025 11:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746730745; x=1747335545; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bBmVd6Zby64yWu64SS7C2oCQSq9HUZQGyl7hZJGEA+Y=;
        b=Dze2bDG8PvSA6u8E7F/bzuTBb1kdDnwybBagsfLQ5XyRMxmWWDZ2ZcYQAmd3Dpix2m
         Jk+yB1pZI0yKT0qp59Q1PT/9gwQckb/EXrcS8dTIEBBlb2ci7njVdRLf/kcvrL/dhJ1g
         Q11+lNhaEVFEimBNCqEObJ5DGNiI6Zofmhqy/bBFzcZ25xjZ2rFzo8+CYzX6EIGMpb9G
         se4VWDSH+9LF5xixaIcuL2M3hDlB8PcxgUjFCKWsD+VvOU9gI13lMMZz2KCriXSQNdBi
         nhid8bAlgaEZXKQfKaaxL21Ou0afhbbZD9yJDFXrEEPERlzMAADxkSHROsSL0L/AqW87
         BGYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746730745; x=1747335545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bBmVd6Zby64yWu64SS7C2oCQSq9HUZQGyl7hZJGEA+Y=;
        b=HsaSpUavU6LfYWTRKanZzYw29iXAaFoV9OK34ZiU+f76MmXPStAZ3TLzjohLk19CRO
         C58Mn9LtiTkvBJ1F64K90LQt884DPW99VS8nbHTNyzyKwNkljxouOdLe+2IkLYHlZ05u
         SdvSTbB487NvKrT0y5buXMS2Kk5/rHAlyI8/C2m353FwnLR3cNxPsuscQqAHx+d15cPB
         LbigyTr6uii3pSgD66WvMblVNxDptP/6tuhC3Muyt3FWpUnWKkykZJGSFu4V1CUKr9xT
         I6CSf9ytsCL+zxUOlIbAD3dK2JYkTTB2DSGXjm5xLxLZ33rDsUGl00glVj9cBHy/1Sbf
         noUA==
X-Gm-Message-State: AOJu0YyHuggO84aAN0XwAYeZ3wejFbymnNO0x6pYfy8nJIE5JzOq6xOV
	sKD9aU6eJ/2NUGsT+qipgRRzetk0QlJayMzL/MH8Iss+peju8NcSIoB0k0dc
X-Gm-Gg: ASbGnctKWYligTm2nQ8FK7Qhp1S53aL2pkjt70WAcMMfbGMKmSTccXNXDiTKsgphPbU
	l8gI9wLF3fZxPDgG8k8UxibriwgiUhsHEkri6s6LA0Pvd+7k5B1gOHnNt3tO7off5Y/zsmPh8ME
	MdcAyN7HgdV2sKQscM4/1tt6eloyroUWlJ3Bmi22naEeBGQ3B6RmJvvry0wfd8E++vlWh+my2yR
	w8CxMbf0fOF6bdkeRwHHHEUCKU+wtD1yzzupobY4FQ1a9G0BV/k2wHzxhREyXmLm2kBUXhrAR3e
	DiZHTo189NOUL6LYMMQL45T7htuBucrkbI0y5nNqEmmuMi1BmseJdgj9rihcrk0H44WpPu7gq8M
	+RuBoE3guPM09oHocfDZDax5kydnrCg==
X-Google-Smtp-Source: AGHT+IFPCt+6Qgq/Oz7YGln76Y51E+Ux7RTLnwmFzs3qBYAgh2Cxg552+t8fcJqpO1606PFuiTbedA==
X-Received: by 2002:a05:620a:1a86:b0:7c5:4b18:c4c3 with SMTP id af79cd13be357-7cd011188e4mr106579985a.30.1746730744640;
        Thu, 08 May 2025 11:59:04 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7cd00fdc59csm26611785a.77.2025.05.08.11.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 11:59:02 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.dk
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 03/11] verify: make verify_pattern=%o thread safe
Date: Thu,  8 May 2025 14:58:11 -0400
Message-ID: <20250508185832.3702-4-vincent.fu@samsung.com>
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

When verify_async is set, multiple threads create instances of
the verify_pattern in the same buffer. This is not a problem if the
pattern is a constant value. However, if the pattern depends on the
offset then pattern verification will produce false failures.

This patch changes verify_io_u_pattern() to allocate brand new
buffers to instantiate the verify_pattern when verify_pattern contains
the %o format specifier and verify_async is set. With each thread having
its own pattern buffer they will no longer interfere with each other.

Failing use case example:

root@localhost:~/fio-dev/fio-canonical# ./fio --name=test --ioengine=io_uring --iodepth=32 --filesize=256k --verify_pattern=%o --verify_async=2 --rw=write
test: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=32
fio-3.39-44-g19d9
Starting 1 process
fio: got pattern '10', wanted '70'. Bad bits 2
fio: bad pattern block offset 41
pattern: verify failed at file test.0.0 offset 200704, length 4096 (requested block: offset=200704, length=4096, flags=84)

test: (groupid=0, jobs=1): err= 0: pid=3972816: Tue Apr 22 16:59:55 2025
  read: IOPS=21.3k, BW=83.3MiB/s (87.4MB/s)(256KiB/3msec)
    slat (nsec): min=3989, max=35487, avg=5319.23, stdev=4033.94
    clat (usec): min=43, max=2008, avg=1058.31, stdev=513.19
     lat (usec): min=47, max=2012, avg=1063.63, stdev=512.36
    clat percentiles (usec):
     |  1.00th=[   44],  5.00th=[  178], 10.00th=[  347], 20.00th=[  570],
     | 30.00th=[  775], 40.00th=[  930], 50.00th=[ 1074], 60.00th=[ 1237],
     | 70.00th=[ 1385], 80.00th=[ 1532], 90.00th=[ 1729], 95.00th=[ 1811],
     | 99.00th=[ 2008], 99.50th=[ 2008], 99.90th=[ 2008], 99.95th=[ 2008],
     | 99.99th=[ 2008]
  write: IOPS=32.0k, BW=125MiB/s (131MB/s)(256KiB/2msec); 0 zone resets
    slat (usec): min=2, max=328, avg= 9.50, stdev=40.93
    clat (usec): min=250, max=585, avg=382.74, stdev=86.17
     lat (usec): min=262, max=588, avg=392.24, stdev=88.98
    clat percentiles (usec):
     |  1.00th=[  251],  5.00th=[  262], 10.00th=[  293], 20.00th=[  306],
     | 30.00th=[  330], 40.00th=[  334], 50.00th=[  359], 60.00th=[  404],
     | 70.00th=[  416], 80.00th=[  474], 90.00th=[  494], 95.00th=[  545],
     | 99.00th=[  586], 99.50th=[  586], 99.90th=[  586], 99.95th=[  586],
     | 99.99th=[  586]
  lat (usec)   : 50=0.78%, 100=0.78%, 250=2.34%, 500=50.78%, 750=9.38%
  lat (usec)   : 1000=8.59%
  lat (msec)   : 2=26.56%, 4=0.78%
  cpu          : usr=0.00%, sys=50.00%, ctx=54, majf=0, minf=15
  IO depths    : 1=1.6%, 2=3.1%, 4=6.2%, 8=12.5%, 16=25.0%, 32=51.6%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=97.1%, 8=0.0%, 16=0.0%, 32=2.9%, 64=0.0%, >=64=0.0%
     issued rwts: total=64,64,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=32

Run status group 0 (all jobs):
   READ: bw=83.3MiB/s (87.4MB/s), 83.3MiB/s-83.3MiB/s (87.4MB/s-87.4MB/s), io=256KiB (262kB), run=3-3msec
  WRITE: bw=125MiB/s (131MB/s), 125MiB/s-125MiB/s (131MB/s-131MB/s), io=256KiB (262kB), run=2-2msec

Disk stats (read/write):
  sda: ios=0/0, sectors=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 verify.c | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/verify.c b/verify.c
index e7e619d3..c90c008c 100644
--- a/verify.c
+++ b/verify.c
@@ -373,6 +373,20 @@ static inline void *io_u_verify_off(struct verify_header *hdr, struct vcont *vc)
 	return vc->io_u->buf + vc->hdr_num * hdr->len + hdr_size(vc->td, hdr);
 }
 
+/*
+ *  The current thread will need its own buffer if there are multiple threads
+ *  and the pattern contains the offset. Fio currently only has one pattern
+ *  format specifier so we only need to check that one, but this may need to be
+ *  changed if fio ever gains more pattern format specifiers.
+ */
+static inline bool pattern_need_buffer(struct thread_data *td)
+{
+	return td->o.verify_async &&
+		td->o.verify_fmt_sz &&
+		td->o.verify_fmt[0].desc->paste == paste_blockoff;
+}
+
+
 static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
 {
 	struct thread_data *td = vc->td;
@@ -386,6 +400,16 @@ static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
 	pattern_size = td->o.verify_pattern_bytes;
 	assert(pattern_size != 0);
 
+	/*
+	 * Make this thread safe when verify_async is set and the verify
+	 * pattern includes the offset.
+	 */
+	if (pattern_need_buffer(td)) {
+		pattern = malloc(pattern_size);
+		assert(pattern);
+		memcpy(pattern, td->o.verify_pattern, pattern_size);
+	}
+
 	(void)paste_format_inplace(pattern, pattern_size,
 				   td->o.verify_fmt, td->o.verify_fmt_sz, io_u);
 
@@ -395,7 +419,7 @@ static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
 
 	rc = cmp_pattern(pattern, pattern_size, mod, buf, len);
 	if (!rc)
-		return 0;
+		goto done;
 
 	/* Slow path, compare each byte */
 	for (i = 0; i < len; i++) {
@@ -411,16 +435,18 @@ static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
 				i + header_size);
 			vc->name = "pattern";
 			log_verify_failure(hdr, vc);
-			return EILSEQ;
+			rc = EILSEQ;
+			goto done;
 		}
 		mod++;
 		if (mod == td->o.verify_pattern_bytes)
 			mod = 0;
 	}
 
-	/* Unreachable line */
-	assert(0);
-	return EILSEQ;
+done:
+	if (pattern_need_buffer(td))
+		free(pattern);
+	return rc;
 }
 
 static int verify_io_u_xxhash(struct verify_header *hdr, struct vcont *vc)
-- 
2.47.2

