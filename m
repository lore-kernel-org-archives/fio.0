Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A01B288518
	for <fio@vger.kernel.org>; Thu,  8 May 2025 18:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746730759; cv=none; b=TTcqklpEEcpI4B2xj+SBvSo+QRsjSyY8VwFvEqYxDhv47EUhE331e5MLXRlTRS4dMZ/Mo3loe42HtXo4Q2kkhovTbzJIu20aGr37cwEyfSs+t8BOD6zMugS8Zp3YgPvtiz2EhqHvf6GKUAF6e/nhKmysmA8zdult7xEEm9R7Of0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746730759; c=relaxed/simple;
	bh=e5jbaMWYszb4mCaDezsyOl7n3Rpu+L5e77e1oLCX+Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPthmlu9XKHT1bVHxmKEHTwiR7vtpcl9/oA641u2MOtpLyFksAjrUEFZbbhR9RnFIAexngDJwz1hUlA8MMM/ioSwo3CGrLc06mDjsby0pT66mnZAToD5LwMfVWzTRXyGAC6r8O2JF6R6M0nXwp/s4ZL9ELTIG5aodWv0VwZtaqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QNU9lGtR; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QNU9lGtR"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7cadd46eb07so142522985a.3
        for <fio@vger.kernel.org>; Thu, 08 May 2025 11:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746730755; x=1747335555; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4tg8RziZ85Ufo5wdTPgNn8SfiloI2zA65Ht7l8W4e24=;
        b=QNU9lGtR0O+Hp8LNMNBT2m1U8vNGFguB6GVZKf6iER0Fqz4TP9j2JCZjqjKGUF4ntH
         SEioHimuNKRR+u/z2n8j9FYiLgom3nLY0Ik54yYIfDCcOmd6w5inaBEgMPbM3VTBKxVM
         bNgTcABd1pYRZhkcceF54NoJ634iK0VcftM23wdg9oOJ/IeMONfodfWVkiaE6U63acDR
         9yu6nuvOw+kniyWb8F2SEyyUA8DNujOQT+p5b1300/I+rYANddfgilb3oRETalzXRBS8
         69zhYmp8VB9IDsa+dTZPYMcaSuwKYH4pqdHDmew9box0Ahtwll2SwLZgouqpi6jjqDJW
         I9vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746730755; x=1747335555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4tg8RziZ85Ufo5wdTPgNn8SfiloI2zA65Ht7l8W4e24=;
        b=eTYF9Wdp+wozm/hNK0UJBAogJw5u6m3uI0GTbaxwFxiAfSo1SHBtwk8eMrGfplgNRa
         4bp0gG9IMT7aBAHHMivbXeOYuoJimvEVWdf/B9ICpK0TVVFLHB/vW3COfJ+VCCZHiDBU
         sFYhOpraQdFI/yqpkDG2/zJPN24YIlZlT8STm4v8T065ghQbAc9knxr80nOc3lhCFVsN
         c2mJ0rgH4AO4nBNy6qyOCIQT8L/PEXLP6WrdridnIoGBQJSNO3Gy7Ex1DaBYwFDmiSNg
         VxXYb1ppnRJtLFWkEggoaKHa0lMTvb6h1mWkCOV6oIBQMAX4CobTTfF//O4MFOz+oje4
         N8bw==
X-Gm-Message-State: AOJu0YxRtJizpw6w1SHJ2lrflVsSjrzWbhdKpCz7CcGi5BvN3q2h467z
	nW/EHs1Ov33o3wwW7AXnOnPLw5NuRe0hrsOVw3gCJx4wRfIqIlq7uf0zC+zy
X-Gm-Gg: ASbGnct53pLRHeQVrwNBetFAQ1CmaP6PMbCBDBVOa8wwD/V6oYCXck0hjb3Iz/YLCMR
	UqzAK2uFvLGM+MWk9Ne6leQb5GCVfcm9agOo7yapWa306OBuS015VTztUjFHO+UzheGlzNTYRoh
	EJ5RCNIqXPMBQd5aL0koFKAb+vOqOrN5qxSatbxgDTqTB8vau9EOFfG+ooiTRZjc3KOFwVFlCMZ
	VhHZVAl+kLpo/MEq04t8MCN5MTBk6JtL21kMMnZr8PYo9lUIbXfQy+mU5e83dIW0f9J5G7RTWAD
	SWWxTH6RXgYM2DJA0eGM6i9mOJbgGX3s0xwoOOZXx454KU+gF0wgkwMYv6CTfkoizCDiWf70pCI
	cgKNDA+eAXNeC0ZWZLbgWhIHKRth/Ag==
X-Google-Smtp-Source: AGHT+IEqbPQxOeIqCXddGhJUarA3MSoK3jy4RkDMqsne6bLZVG5statq+uOjWsYCSK7LrB8N6Fa5jw==
X-Received: by 2002:a05:620a:4482:b0:7c0:be39:1a34 with SMTP id af79cd13be357-7cd01157c8bmr108296885a.43.1746730755139;
        Thu, 08 May 2025 11:59:15 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7cd00fdc59csm26611785a.77.2025.05.08.11.59.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 11:59:13 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.dk
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 11/11] t/verify: add tests to exercise verify_pattern_interval
Date: Thu,  8 May 2025 14:58:19 -0400
Message-ID: <20250508185832.3702-12-vincent.fu@samsung.com>
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

Add some more tests with oddball intervals and patterns to
validate the verify_pattern_interval option.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 t/verify.py | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/t/verify.py b/t/verify.py
index 99ed61dc..58bf327d 100755
--- a/t/verify.py
+++ b/t/verify.py
@@ -209,6 +209,41 @@ class VerifyCSUMTest(FioJobCmdTest):
             logging.debug("stderr: %s", contents)
 
 
+#
+# These tests exercise fio's verify_pattern_interval option.
+#
+TEST_LIST_VPI = [
+    {
+        # Basic test verify=pattern
+        "test_id": 3000,
+        "fio_opts": {
+            "ioengine": "psync",
+            "rw": "write",
+            "verify": "pattern",
+            "filesize": "1M",
+            "bs": 4096,
+            "output-format": "json",
+            },
+        "test_class": VerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+    {
+        # Basic test verify=pattern_hdr
+        "test_id": 3001,
+        "fio_opts": {
+            "ioengine": "psync",
+            "rw": "write",
+            "verify": "pattern_hdr",
+            "filesize": "1M",
+            "bs": 4096,
+            "output-format": "json",
+            },
+        "test_class": VerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
+]
+
+
 #
 # These tests exercise fio's decisions about verifying the sequence number and
 # random seed in the verify header.
@@ -625,6 +660,25 @@ def verify_test_csum(test_env, args, mbs, csum):
     return run_fio_tests(TEST_LIST_CSUM, test_env, args)
 
 
+def verify_test_vpi(test_env, args, pattern, vpi, vi):
+    """
+    Adjust test arguments based on values of ddir and csum.  Then run
+    the tests.
+    """
+    for test in TEST_LIST_VPI:
+        test['force_skip'] = False
+
+        test['fio_opts']['verify_pattern'] = pattern
+        test['fio_opts']['verify_interval'] = vi
+        test['fio_opts']['verify_pattern_interval'] = vpi
+
+        for key in ['verify_interval', 'verify_pattern_interval']:
+            if not test['fio_opts'][key]:
+                test['fio_opts'].pop(key, None)
+
+    return run_fio_tests(TEST_LIST_VPI, test_env, args)
+
+
 def verify_test(test_env, args, ddir, csum):
     """
     Adjust test arguments based on values of ddir and csum.  Then run
@@ -769,6 +823,11 @@ def main():
             test['fio_opts']['ioengine'] = aio
         if 'sync' in test['fio_opts']['ioengine']:
             test['fio_opts']['ioengine'] = sync
+    for test in TEST_LIST_VPI:
+        if 'aio' in test['fio_opts']['ioengine']:
+            test['fio_opts']['ioengine'] = aio
+        if 'sync' in test['fio_opts']['ioengine']:
+            test['fio_opts']['ioengine'] = sync
 
     total = { 'passed':  0, 'failed': 0, 'skipped': 0 }
 
@@ -830,6 +889,23 @@ def main():
             total['failed'] += failed
             total['skipped'] += skipped
 
+        # The loop below is for verify_pattern_interval tests
+        pattern_list = ['%o', '"abcde"', '1%o',]
+        vpi_list = [10, 129, 512, 4089, None]
+        verify_interval_list = [512, 1024, 2222, 3791, None]
+        for pattern, vpi, vi in itertools.product(pattern_list, vpi_list, verify_interval_list):
+            print(f"\npattern: {pattern}, verify_pattern_interval: {vpi}, verify_interval: {vi}")
+
+            test_env['artifact_root'] = os.path.join(artifact_root,
+                f"pattern_{pattern}_vpi_{vpi}_vi_{vi}").replace('"', '').replace("%", 'pct')
+            os.mkdir(test_env['artifact_root'])
+
+            passed, failed, skipped = verify_test_vpi(test_env, args, pattern, vpi, vi)
+
+            total['passed'] += passed
+            total['failed'] += failed
+            total['skipped'] += skipped
+
     except KeyboardInterrupt:
         pass
 
-- 
2.47.2

