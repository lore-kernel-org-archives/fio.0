Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EDE2836BD
	for <fio@vger.kernel.org>; Thu,  8 May 2025 18:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746730746; cv=none; b=DD/jAbwrkwVff1DochIG3u/OVaZUpBOGOodMTe2DtxZk6+EhzJZolmPDohJE2S6XmtAi5h040sAuQE15uV8BIsmZ9Hgs16jzUipagXiDEhx0XRrQIWbpZGT/Dr1yUnO4ZC/P6vC4yv2Xe8KsHWNJJKiw2LV8UFUTP+BrM1yPcAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746730746; c=relaxed/simple;
	bh=h4w4763CnDqwdwVQuPGySycgGVBsRdhXubA+cP7S3sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8v7gWr1VjVHK+1I1dgrWEEr2ocrP1lx+wZgfIlEKp8FlLMhlSfjjwCge1GPSHZzTREz9lPsOGQtWoNe7aQvXQulrTWKSprhAvKRE5YkatbMc7aTLHgbytelpeHlymBeNjlHf34H83K4FigkagLfBGVXOJ3BA0f9uCZfKpVgUE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XVd0omwk; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XVd0omwk"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7c5568355ffso133323885a.0
        for <fio@vger.kernel.org>; Thu, 08 May 2025 11:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746730743; x=1747335543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sTyPkcGXhkLigy+KcRJjEF0hcSs5HcV9fMVsA230RLQ=;
        b=XVd0omwk24sSPMcIQTGlPZdJSLJyBUu7nhXQefwz1QnY2OlfUsw9HnLo3uJpoWFrdj
         NF78rIJerw0pD5864XBYhnpDvUznvmnvcE+qcNauzj4g7DftPINT+9m+nW31mk2lBr7L
         Iq8kA0QEWNpm5wh92ZhhFi0UhnRqmYCNTDmFqgYQTwoxA+vlKN4j6g6omtHUaY7Og4On
         Bu4QfyF1QcvLNxWXNPwUAbCyi2BgL98JlIqMPLtQIGgIxqoShJYDVqrqh4HIeG2rSi/X
         boX6qQi/sSRm9hqYu/hEsrJs4ZbQiJet6auCMyXBE/JS+n0IE/pXX4RQSs7Bk39YsPWK
         qC3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746730743; x=1747335543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sTyPkcGXhkLigy+KcRJjEF0hcSs5HcV9fMVsA230RLQ=;
        b=EAPeSyZJHWE/wGZCKHxIBI9RIJa5v9MKTYzNpfCYaTSTUj2VpE1YqJLoiTfexObVCS
         EZohGdBgFbM460ztMJQX6kpyzORnX8Smemp50QDfvNQCPRjZPKVOPSitPE9OminiDJJt
         D0eg5NGAH7YAsWAXP5ecwurcNar1COb8r9OziFzGrqCjdyKZexY2IR/CCUlFysEe035h
         pxbqsXr7xrHv64fEeDkxxB3Hn/FV2HLoBxixi4b5HTLFxLcdXG/tw7dQ6YEVtMim6RG2
         x+lHHt10MJsjgwWDqnmvUBh+N4K0mbg+RUf8pK6q5dVo0inVwl6JZicjzwl5T3twIYhw
         T6ZA==
X-Gm-Message-State: AOJu0Ywn7Jtd4wkmNpXU1MyyVGBy/A3ztdlKYzRYZEZo4vP4CPAPt1iY
	5jlQkpsO2yQdZU+yNk7u3k7br9aa0L4SfUT04jrbJCkvl6I9dnfY0Wfapljp
X-Gm-Gg: ASbGnctQ2YCGWTDwWBS7HyJDMPI2YNZ+P6gLRxOaUkU9qO6xZxjET3hnPjRMRwPuWlf
	BB91GCWUbVSI3y2Kun8D+7UF/kPVMwD+U08VsMsY5e4nb4mwDFbmuaifzXg8Wr9GQtK0yceGzkO
	ba0IkWYCa1VVXQz2vXcjco381zr47rez+TEnfXrkSrzC4vP9Swclwdbdr1TB8tQ/nj0X8Wn9++Q
	UG/YHnyuNy2fCn/3r9Xr2ElU3NKLpP9LZtgMgUqAuchkI7zcD+ot4/R97F0y0MKJxd/Y4QH12jO
	cKwMMj6qdwiShORMuRYJdHX9Yju85GKIjpm9bl1JDxEObj2zcSZ5qsTK+bhy36TPbjnLbwv9s6l
	sErWs+9Hfw9sJgzXIUwtEH7WJV4yV/w==
X-Google-Smtp-Source: AGHT+IG8VbuSFY8luSlaFTy55OU6j4INH3g09ZpP+Ml5sj8osA3gko9j8qjeeFQtp+tXN0rfVEUMMw==
X-Received: by 2002:a05:620a:2407:b0:7c5:4949:23f9 with SMTP id af79cd13be357-7cd011052c7mr112952385a.18.1746730742532;
        Thu, 08 May 2025 11:59:02 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7cd00fdc59csm26611785a.77.2025.05.08.11.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 11:59:01 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.dk
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 02/11] verify: fix verify_offset when used with pattern_hdr
Date: Thu,  8 May 2025 14:58:10 -0400
Message-ID: <20250508185832.3702-3-vincent.fu@samsung.com>
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

When using verify=pattern_hdr with verify_offset, we cannot reuse the
data already in a buffer because some of the pattern bytes have been
swapped with the verify header. Trying to reuse the buffer contents just
results in the header being swapped back and forth between the
verify_offset location and the beginning of the verify_interval.

Fix this by avoiding reuse of buffer contents.

Failing test case example:
root@localhost:~/fio-dev/fio-canonical# ./fio --name=verify --filesize=8192 --verify_offset=1024 --verify_pattern=1 --rw=write
verify: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=1
fio-3.39-38-gf18c
Starting 1 process
fio: got pattern 'ca', wanted '01'. Bad bits 5
fio: bad pattern block offset 1024
pattern: verify failed at file verify.0.0 offset 4096, length 4096 (requested block: offset=4096, length=4096, flags=88)
fio: pid=3624903, err=84/file:io_u.c:2258, func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide character

verify: (groupid=0, jobs=1): err=84 (file:io_u.c:2258, func=io_u_sync_complete, error=Invalid or incomplete multibyte or wide character): pid=3624903: Fri Apr 11 22:56:01 2025
  read: IOPS=2000, BW=8000KiB/s (8192kB/s)(8192B/1msec)
    clat (nsec): min=2185, max=15807, avg=8996.00, stdev=9632.21
     lat (nsec): min=2280, max=16120, avg=9200.00, stdev=9786.36
    clat percentiles (nsec):
     |  1.00th=[ 2192],  5.00th=[ 2192], 10.00th=[ 2192], 20.00th=[ 2192],
     | 30.00th=[ 2192], 40.00th=[ 2192], 50.00th=[ 2192], 60.00th=[15808],
     | 70.00th=[15808], 80.00th=[15808], 90.00th=[15808], 95.00th=[15808],
     | 99.00th=[15808], 99.50th=[15808], 99.90th=[15808], 99.95th=[15808],
     | 99.99th=[15808]
  write: IOPS=2000, BW=8000KiB/s (8192kB/s)(8192B/1msec); 0 zone resets
    clat (nsec): min=7910, max=82940, avg=45425.00, stdev=53054.22
     lat (usec): min=9, max=100, avg=55.03, stdev=64.49
    clat percentiles (nsec):
     |  1.00th=[ 7904],  5.00th=[ 7904], 10.00th=[ 7904], 20.00th=[ 7904],
     | 30.00th=[ 7904], 40.00th=[ 7904], 50.00th=[ 7904], 60.00th=[82432],
     | 70.00th=[82432], 80.00th=[82432], 90.00th=[82432], 95.00th=[82432],
     | 99.00th=[82432], 99.50th=[82432], 99.90th=[82432], 99.95th=[82432],
     | 99.99th=[82432]
  lat (usec)   : 4=25.00%, 10=25.00%, 20=25.00%, 100=25.00%
  cpu          : usr=0.00%, sys=0.00%, ctx=0, majf=0, minf=19
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=20.0%, 4=80.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=2,2,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=8000KiB/s (8192kB/s), 8000KiB/s-8000KiB/s (8192kB/s-8192kB/s), io=8192B (8192B), run=1-1msec
  WRITE: bw=8000KiB/s (8192kB/s), 8000KiB/s-8000KiB/s (8192kB/s-8192kB/s), io=8192B (8192B), run=1-1msec

Disk stats (read/write):
  sda: ios=0/0, sectors=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 verify.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/verify.c b/verify.c
index 928bdd54..e7e619d3 100644
--- a/verify.c
+++ b/verify.c
@@ -65,9 +65,10 @@ void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
 		return;
 	}
 
-	/* Skip if we were here and we do not need to patch pattern
-	 * with format */
-	if (!td->o.verify_fmt_sz && io_u->buf_filled_len >= len) {
+	/* Skip if we were here and we do not need to patch pattern with
+	 * format. However, we cannot skip if verify_offset is set because we
+	 * have swapped the header with pattern bytes */
+	if (!td->o.verify_fmt_sz && io_u->buf_filled_len >= len && !td->o.verify_offset) {
 		dprint(FD_VERIFY, "using already filled verify pattern b=%d len=%u\n",
 			o->verify_pattern_bytes, len);
 		return;
-- 
2.47.2

