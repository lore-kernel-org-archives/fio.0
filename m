Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB9A288509
	for <fio@vger.kernel.org>; Thu,  8 May 2025 18:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746730766; cv=none; b=XLt5XPuImOBL/8DGj2PrbLAOkcP81ezxX7PuNsbrtrVMWN29l/eAu5DHlfGRP0c5FuU0A2Zi8GnXnc/Ox+xs8c+rZSMmCWtbg38OsHYpGu6F83o5w1V9niUg1vjYCB+coyaVGpmMzmGX0dsGZqVl4P6GQ5ka5+bvDcKyW76fVz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746730766; c=relaxed/simple;
	bh=EQUSle/KLCD332MdVJVgjTGGwyy8roYF4kKS7MyNsx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGyzk+wen7j2cI8K/lX7vpaT7DcieZEFXr7RcAjc1wflTl5LtgbQtcbLSSuwGpLeRDBGB3pxIkIJyoxxKfyFz91YhCi0zne3AHiFTq9DLyQgYYkqmXqkOxfnuJvoElp8pfszHpuuI4f+D4eQfUabxP2Rqg2zHmi2f/IvXr4X2fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KjxfQqzs; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KjxfQqzs"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7399a2dc13fso1882035b3a.2
        for <fio@vger.kernel.org>; Thu, 08 May 2025 11:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746730763; x=1747335563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fPC6GDnQ/JVzo5asXC0JPyqAtFaqo20GF6T6d3vINls=;
        b=KjxfQqzsoanKJInd/fLYlFLskbK5yHqDkT3T7atWSibH2ZpGUWNThpN4wYgF80yYHO
         cx3gfoTB8p+7CIqX0xTn7p2mVg5JJWwqaOVSzjr5IJ4MrfnP0Fr4peO3oSr0/z6ysbcQ
         AKKb9Mq6HnKQtm6fR30R1f5dQAFguK/Pl+yXEru4J0NYDTAjo0w8fI3n41jANjBZUvlG
         8InV+jTzGGCpU02PbqHHZxxnnFE5Xr2kY3qQDC1kM4x8cdToAYiMOJS8k6hlEjFrL83z
         CHvG4+DnpebZRvo0kE/KxdrvTh8XlTo7UQ3TpB4r+Cte+ME26mctv7Q+x+zF5/tN0Tgb
         xH/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746730763; x=1747335563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fPC6GDnQ/JVzo5asXC0JPyqAtFaqo20GF6T6d3vINls=;
        b=iFjfudc1tAGRj3jspa5VvbmEBki8BthVa3Wft4jcT8rqNhcJlmrTxKcnVd0DmEaIds
         1RdLfva4atBW+CJmUpaKzCt+pf6fNYN/Ag30TqFtihYlHIu+z+j1Ux3g7FGjWizG4goc
         906WQiG/xW2kO7lLIHcYngp9ed+lKxVPUn1rTA95DMj3XCcBvSgsKD73CFCX5UaJIwV9
         fYIj44TaEkWMOMKZzu/0lfQWSufWP2DNGRlhQNJBIe7J4M6dUSymJIRZ5f4TvAk8v1ui
         y8ZpQDC+0+xZkrA6YSosRbTQYwr72o1Z+FFY3/9zrL3jDGqXruhkEhAd7iOT1tpXjIsC
         UP3w==
X-Gm-Message-State: AOJu0Yy2aGU6RCCBYosaiNlo2S5NMcv4S4jOeeTrFYhHQPVmdtXdXevD
	80s5k0Wtdky7S3RmCv6YKbTJinWrK4rLjrbfXf24oyEF7QnWFqH+et5h7wfI
X-Gm-Gg: ASbGncuRY7PvClPKyuLnCewnAUjYml8SJJfD416RT6KJAs3E9gxoLVmVuHrko74h/b0
	vPHRS4VfZaC8ATzIaqNLBHWNFC0b0kmRmFMNWJRdwPK2j/rvXihjNu5nIOfWSmVwq3qkceu5x9F
	4j9t6bjhAzv4JkFwbWNIQdMb6z+ySqyJ8Cs4OJoD3y1wJcyVMYCFXIRAvRcsHqUfx+8GzikEfQG
	X0PCww3q24P4zLMMdOtSDHGDR7P8sfeXDmZOVheqfYjOEnw+V9ZWBrDAItUvtZQIhE1W2yKT0a1
	itQQgTi4vj8FtLm8mA6nw3G6kMRzji7cL5NPIOGX6w0PuqvtB38oDcny/ceusamyL++iPDq5UYM
	OxJi/hbxCaBGih8cNES7C02ZYLOLv3g==
X-Google-Smtp-Source: AGHT+IEAMYV3lRSI1KpIJDD2JdQcqBlFNrrgkUDgdgTOehTwKljfLUfqdPB/XuSUzmCuV6dYgOC4/Q==
X-Received: by 2002:a05:620a:4713:b0:7c7:827b:46bf with SMTP id af79cd13be357-7cd01157860mr120672085a.39.1746730752569;
        Thu, 08 May 2025 11:59:12 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7cd00fdc59csm26611785a.77.2025.05.08.11.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 11:59:11 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.dk
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 09/11] t/verify: test cases for running pattern and pattern_hdr
Date: Thu,  8 May 2025 14:58:17 -0400
Message-ID: <20250508185832.3702-10-vincent.fu@samsung.com>
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

Add test cases for the recently added verify_pattern_interval and
verify=pattern_hdr options to our pre-existing sets of tests.

In some cases verify failures do not produce non-zero return values
unless verify_fatal is set. Add verify_fatal=1 to affected test cases.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 t/verify.py | 45 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/t/verify.py b/t/verify.py
index e48bad28..8f0cb1ef 100755
--- a/t/verify.py
+++ b/t/verify.py
@@ -55,7 +55,9 @@ VERIFY_OPT_LIST = [
     'verify_async',
     'verify_async_cpus',
     'verify_pattern',
+    'verify_pattern_interval',
     'verify_only',
+    'verify_fatal',
 ]
 
 class VerifyTest(FioJobCmdTest):
@@ -281,6 +283,7 @@ TEST_LIST_CSUM = [
             "bs": 4096,
             "rw": "write",
             "output-format": "json",
+            "verify_fatal": 1,
             },
         "test_class": VerifyCSUMTest,
         "success": SUCCESS_NONZERO,
@@ -294,6 +297,7 @@ TEST_LIST_CSUM = [
             "bs": 4096,
             "rw": "randwrite",
             "output-format": "json",
+            "verify_fatal": 1,
             },
         "test_class": VerifyCSUMTest,
         "success": SUCCESS_NONZERO,
@@ -309,6 +313,7 @@ TEST_LIST_CSUM = [
             "bs": 4096,
             "rw": "write",
             "output-format": "json",
+            "verify_fatal": 1,
             },
         "test_class": VerifyCSUMTest,
         "success": SUCCESS_NONZERO,
@@ -324,6 +329,7 @@ TEST_LIST_CSUM = [
             "bs": 4096,
             "rw": "randwrite",
             "output-format": "json",
+            "verify_fatal": 1,
             },
         "test_class": VerifyCSUMTest,
         "success": SUCCESS_NONZERO,
@@ -508,10 +514,20 @@ def verify_test_header(test_env, args, csum, mode, sequence):
             test['force_skip'] = False
 
         test['fio_opts']['verify'] = csum
-        if csum == 'pattern':
+        if csum in ('pattern', 'pattern_hdr'):
             test['fio_opts']['verify_pattern'] = '"abcd"-120xdeadface'
+            test['fio_opts'].pop('verify_pattern_interval', None)
+        elif csum == 'pattern_interval':
+            test['fio_opts']['verify'] = "pattern_hdr"
+            test['fio_opts']['verify_pattern'] = '%o'
+            test['fio_opts']['verify_pattern_interval'] = 512
+        elif csum == 'pattern_interval_nohdr':
+            test['fio_opts']['verify'] = "pattern"
+            test['fio_opts']['verify_pattern'] = '%o'
+            test['fio_opts']['verify_pattern_interval'] = 512
         else:
             test['fio_opts'].pop('verify_pattern', None)
+            test['fio_opts'].pop('verify_pattern_interval', None)
 
         if 'norandommap' in sequence:
             test['fio_opts']['norandommap'] = 1
@@ -579,10 +595,20 @@ def verify_test_csum(test_env, args, mbs, csum):
         test['force_skip'] = False
         test['fio_opts']['verify'] = csum
 
-        if csum == 'pattern':
+        if csum in ('pattern', 'pattern_hdr'):
             test['fio_opts']['verify_pattern'] = '"abcd"-120xdeadface'
+            test['fio_opts'].pop('verify_pattern_interval', None)
+        elif csum == 'pattern_interval':
+            test['fio_opts']['verify'] = "pattern_hdr"
+            test['fio_opts']['verify_pattern'] = '%o'
+            test['fio_opts']['verify_pattern_interval'] = 512
+        elif csum == 'pattern_interval_nohdr':
+            test['fio_opts']['verify'] = "pattern"
+            test['fio_opts']['verify_pattern'] = '%o'
+            test['fio_opts']['verify_pattern_interval'] = 512
         else:
             test['fio_opts'].pop('verify_pattern', None)
+            test['fio_opts'].pop('verify_pattern_interval', None)
 
         if mbs == MANGLE_JOB_BS:
             test['fio_opts']['mangle_bs'] = test['fio_opts']['bs']
@@ -610,10 +636,20 @@ def verify_test(test_env, args, ddir, csum):
         test['fio_opts']['rw'] = ddir
         test['fio_opts']['verify'] = csum
 
-        if csum == 'pattern':
+        if csum in ('pattern', 'pattern_hdr'):
             test['fio_opts']['verify_pattern'] = '"abcd"-120xdeadface'
+            test['fio_opts'].pop('verify_pattern_interval', None)
+        elif csum == 'pattern_interval':
+            test['fio_opts']['verify'] = "pattern_hdr"
+            test['fio_opts']['verify_pattern'] = '%o'
+            test['fio_opts']['verify_pattern_interval'] = 512
+        elif csum == 'pattern_interval_nohdr':
+            test['fio_opts']['verify'] = "pattern"
+            test['fio_opts']['verify_pattern'] = '%o'
+            test['fio_opts']['verify_pattern_interval'] = 512
         else:
             test['fio_opts'].pop('verify_pattern', None)
+            test['fio_opts'].pop('verify_pattern_interval', None)
 
         # For 100% read data directions we need the write file that was written with
         # verify enabled. Use a previous test case for this by telling fio to
@@ -664,6 +700,9 @@ CSUM_LIST2 = [
         'sha3-384',
         'sha3-512',
         'pattern',
+        'pattern_hdr',
+        'pattern_interval',
+        'pattern_interval_nohdr',
         'null',
              ]
 
-- 
2.47.2

