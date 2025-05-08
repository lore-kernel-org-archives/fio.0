Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F482165E8
	for <fio@vger.kernel.org>; Thu,  8 May 2025 18:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746730746; cv=none; b=rEWGTng+zFmqqNnoPpcgLBiFSL/9gMA9DuFIIzcq2lntKPGrGfcY/UbOx2LTwpp+Fq52do4BokMUkqcFG4qgmdB4bX50t4ognoUTUx4yGcmjJeS8UOV9ROcnyMDzRLcdM9z7oGRp+3d94PaMyz7cnlsbrx8wRhnmARlzaCaIDc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746730746; c=relaxed/simple;
	bh=i6ut4iiAWRSVtT0qv+jgXt8dPH4uapDDMVhWjO40sAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eh2iAZA4RnFKava8XEqEq90hiJySB3n6blJY7ll1VO9/Ka4i+cUkgsNUVsekrlDH6mjTnG61Rk7KlOuQg0OZIu2EfJVIqqUehDmMbXwBFkVUB0RfyTDHJNy2PKRzdNcsq0/BzyYxRtwVvPZjIF++cmJkw+Yk8CGt7JMupV2NhXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YbJCzrhW; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YbJCzrhW"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7caea4bc9e9so228898285a.1
        for <fio@vger.kernel.org>; Thu, 08 May 2025 11:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746730742; x=1747335542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mRnRgPR3igodQst6OvqKjLaKVBxGgMeUntUE35V1WZk=;
        b=YbJCzrhW6I1IIun44HABv9I8wTX5jJWsFOmK6yq2qiVc4T+UIDWbrzYcv4H43WykR4
         coXDkFdEix8zySjWqwaIw5227xmKFuYRqoq4T3Zh3ZHn/WffvSm6B4gMOcfAQYI+33eI
         FVHmxbY51ZSsJoI3tFV/E0l+eew5NKdlLdjkcVuyfjpd3t5S1Vm0N3cASWq8k5ELCM3+
         wHDG9DAUSPPbSUaZiZsQ5m8iYjxliGjB+Z12yFzMtyd3+P2FhEbvEtb5kbE/X3JGuKSA
         vbNfuaLu4ahx2kqbHJgiLcj8e/ZF1KZNZ2yTIdSVWSl7OvSiRwoUc1mTq/hLP/FDtNXk
         YTXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746730742; x=1747335542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mRnRgPR3igodQst6OvqKjLaKVBxGgMeUntUE35V1WZk=;
        b=rCok4tqtuMtzXh3rTukghDuZRZLM6Wd03tgOaVY0blHzo59pAnX8D8+bnzXNkNPzAq
         o1k7doy/gB6GG9QlWN5dPa3p8b2+ZIdqUEqFa/yEO/0m/9VkBKC4bY5PJLv4tDM814Vu
         z+r0nFxCTHgDVYZg10OaBoSAYdWUTeQogB8iuDsLZLTa5TkA9pjFt9x8wKNruHlnA7en
         ANX+ltMgRMVdcSii8zQFBlJ4Qi8Vf7Ax0vvfTUqTHPRuPl+R0aIpAQ5ZqnXMJgxk0sUD
         Miv7l+n7hmLi8wMz+Rkf6FEmdVZtNKHeKOEd/XVbmLrLpOEhqLfDZTaZYiqgYiRr2Rok
         iLkQ==
X-Gm-Message-State: AOJu0YyB7YnuNvImqrC4OQ3kZmiiyQrrdYfj7pafX3LciLrbhtJxxPfx
	XThN9FzRevpZBZKLdKgNIHmi+wnSALs0fyvSjFAYzOfQI/PIiFiNFSfBMY2n
X-Gm-Gg: ASbGncvCJAHLczjGNRJUvBKsht7lG/u7dkYRhpZZs5yL0Yjk0q50pvcY6NpdjJjuqBH
	WCUiwj7MPLv1AF6QOJI74+ALYKBEb3dkp5GaKjPFsYwgwAZZzmF9nfk/3Pjilmuw/cAff6lNsSQ
	+beMAtvHUXcI+jY2PftWwborB9czdfTDKB4+WxOZLQlwROgC5qkdfAz1uEDRTe3tjq40Ra2wwJG
	o+qzJ0gy4xmpnzL6lVMPpYOjmASTngpmFhrmaJ7ZGiolLhr1I5zkmzr/zbBQ9hakPdx5NL7gM3U
	STw98jekbZ0/X/UfcOD39PhfTFa+RKh8tSb1NREy6uCPZw9SQwhS3F/SRdRxFzl3htjwKt4kiin
	dvSDkf61VPI0fUvqKk94bo26Y348vYg==
X-Google-Smtp-Source: AGHT+IHNUhD6VBP2H9H3W+Tg1Cvb8kNCF6beTRbGLgDfPObpAla29upbOvyuyunA9ItSkaSHSBAVOw==
X-Received: by 2002:a05:620a:269a:b0:7c5:5cd6:5cea with SMTP id af79cd13be357-7cd010f7076mr125691185a.15.1746730741642;
        Thu, 08 May 2025 11:59:01 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7cd00fdc59csm26611785a.77.2025.05.08.11.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 11:58:59 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.dk
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 01/11] verify: add verify mode for a pattern with header
Date: Thu,  8 May 2025 14:58:09 -0400
Message-ID: <20250508185832.3702-2-vincent.fu@samsung.com>
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

Add a verify=pattern_hdr option. Previously this was only available when
verify_pattern was set and verify= was omitted. Add a means to
explicitly select this verificaiton mode.

This is useful in the t/verify.py test script because it's troublesome
to have some jobs with a verify= option and omit this option in other
jobs when we want to test pattern verification with a header.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 HOWTO.rst | 3 +++
 fio.1     | 3 +++
 options.c | 4 ++++
 3 files changed, 10 insertions(+)

diff --git a/HOWTO.rst b/HOWTO.rst
index a5033d82..78a259ef 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3921,6 +3921,9 @@ Verification
 			basic information and checksumming, but if this option is set, only
 			the specific pattern set with :option:`verify_pattern` is verified.
 
+		**pattern_hdr**
+			Verify a pattern in conjunction with a header.
+
 		**null**
 			Only pretend to verify. Useful for testing internals with
 			:option:`ioengine`\=null, not for much else.
diff --git a/fio.1 b/fio.1
index 8476b681..d6ee4193 100644
--- a/fio.1
+++ b/fio.1
@@ -3641,6 +3641,9 @@ Verify a strict pattern. Normally fio includes a header with some
 basic information and checksumming, but if this option is set, only
 the specific pattern set with \fBverify_pattern\fR is verified.
 .TP
+.B pattern_hdr
+Verify a pattern in conjunction with a header.
+.TP
 .B null
 Only pretend to verify. Useful for testing internals with
 `ioengine=null', not for much else.
diff --git a/options.c b/options.c
index 71c97e9e..28ffc748 100644
--- a/options.c
+++ b/options.c
@@ -3217,6 +3217,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = VERIFY_PATTERN_NO_HDR,
 			    .help = "Verify strict pattern",
 			  },
+			  { .ival = "pattern_hdr",
+			    .oval = VERIFY_PATTERN,
+			    .help = "Verify pattern with header",
+			  },
 			  {
 			    .ival = "null",
 			    .oval = VERIFY_NULL,
-- 
2.47.2

