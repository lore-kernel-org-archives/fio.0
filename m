Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E80B1468FE
	for <fio@vger.kernel.org>; Tue, 27 Feb 2024 15:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709049573; cv=none; b=J9hCXSbbmHWwEzLmRTm8kYc3O+28JFCGVGYj3tFtPorfHhB+EwbJI03xJI3qqyHj0RdPCtk3wCps27Gzn5Tq34lQ6qcjTJhUxQoVZVRzTDembzOiWb7udSdPqh5tImc64+6eKx6bgSaaXD2V2x/B8nb8Hs8v7N9/PQw8qBy2VZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709049573; c=relaxed/simple;
	bh=KkTspgIqXGLDxiCCfUptP8ueeHbRXVp1z9Sqen9J62I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M2EZVXKcgJFQoTPIGn+JkzJmcp20PfvqNpX+IzUZuai8dKZ6cKwqubXHNoucfSaKchH0aPgVlA75Dkc4tfUKVKZRD1Sa2aMruOH1eefCEYXOhId+Fs6FIjPC4UiF/OXCbAD81CLgn9H8v9JqHbvBYgtQrMhtvCu2Yd4NZPpeaTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b2gi4zHN; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b2gi4zHN"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-60925d20af0so9442807b3.2
        for <fio@vger.kernel.org>; Tue, 27 Feb 2024 07:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709049570; x=1709654370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mW2ur0prapa0YOUYfBgsbUdU8dBUv9iv56Rd9/2Ye9I=;
        b=b2gi4zHN/sKa+J3ZAu1LQMvL0xmzgnfAnF6y2k8U3cKJmlFeW9UGkksXRAd56zeimV
         LbMNVrU8c+MivizfeN85qsB7ZWJNFOLAbVDNBCXV7Z8h8If/nqMibPxDmhWw5FoVjID9
         9yBDOcMNxWlid5EWsGDDsIqP2ldVVb0QvOQtSRE/KUXJrHDw5S/4fDp28SmdzzLL98rD
         P3HAZzNIHLCiCRUqJ7V88Ewu8fGFblusAyDfsmb2njmBku8wNoHyEDgxFGSfc8X/pX0y
         6KdHp/OVH+R6KNI0iVxQEfuhaaUzhsEHYD1gB/kP61Nb5ooa5SR2mJAFq37tj/HRn6KY
         VH0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709049570; x=1709654370;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mW2ur0prapa0YOUYfBgsbUdU8dBUv9iv56Rd9/2Ye9I=;
        b=LDKJ9aLOUvMVtHlFV2DgFlwRDTPbPz2KyM+dPdGs7xGnSDbnEj0ZPH8p9748XNLVNo
         pW7klGAEMSrvzRetWEtZ1R8BDZcEMigdSKxnzs4+dGdrI9IFvJqGTRfaM7JC33h4YuBZ
         zDZsa+Rksn6Q5JVGHM9aiZnh7AR394uLlHM3nZl70WGGVpi0uXhuGoXYXPXBuU+KUxHJ
         0uyCPj0iMz19DkWlFFwh+65Ra5C/zDCVxT+d+MF+T4W9ULlWRe3PXXuJNb3bZWycDsiR
         NbTQJ/k+d1BXNj4iSknmFySw/go8caCeCcRyDsEentD/FuvWfxZUvTDqj4GDg+HOTn6H
         24qQ==
X-Forwarded-Encrypted: i=1; AJvYcCUoyjix5ZX4zbl/dG1Wc1jfqDEW0ly4kbhM0hlMPQ4CPCPpdHb5DmH04n0TNEIM4aEkKFwiFlf54ZNFUbWejhDCQKrk
X-Gm-Message-State: AOJu0Yw/AxyiI395y4I9Oo8m1LE78NrmGvYshijHjUYdaAUwLcJwyVh6
	s7Yiuh5z5j1FqcYXmOmJ2BuZpQLe1KXGKwoxZQoayrovH/fc3VvF
X-Google-Smtp-Source: AGHT+IF2tpJfJqNcmgB9NgvUaBl8twTQ+ZIp1ypqEVUxgjs3aQjCrReXlEXR/0977mGp8JtKIlue2A==
X-Received: by 2002:a81:9bd7:0:b0:608:c73e:cbaa with SMTP id s206-20020a819bd7000000b00608c73ecbaamr2447709ywg.6.1709049570475;
        Tue, 27 Feb 2024 07:59:30 -0800 (PST)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id b6-20020ac87546000000b0042dce775a4bsm3699572qtr.3.2024.02.27.07.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 07:59:29 -0800 (PST)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: axboe@kernel.dk,
	fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH] gettime: fix cpuclock-test on AMD platforms
Date: Tue, 27 Feb 2024 10:26:00 -0500
Message-ID: <20240227155856.5012-1-vincent.fu@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with gcc 11 __sync_synchronize() compiles to

lock or QWORD PTR [rsp], 0

on x86_64 platforms. Previously it compiled to an mfence instruction.

See line 47 of https://godbolt.org/z/xfE18K7b4 for an example.

On Intel platforms this change does not affect the result of fio's CPU
clock test. But on AMD platforms, this change causes fio's CPU clock
test to fail and fio to fall back to clock_gettime() instead of using
the CPU clock for timing.

This patch has fio explicitly use an mfence instruction instead of
__sync_synchornize() in the CPU clock test code on x86_64 platforms in
order to allow the CPU clock test to pass on AMD platforms.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 arch/arch-x86_64.h | 5 +++++
 arch/arch.h        | 7 +++++++
 gettime.c          | 2 +-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arch-x86_64.h b/arch/arch-x86_64.h
index 86ce1b7e..b402dc6d 100644
--- a/arch/arch-x86_64.h
+++ b/arch/arch-x86_64.h
@@ -26,6 +26,11 @@ static inline unsigned long arch_ffz(unsigned long bitmask)
 	return bitmask;
 }
 
+static inline void tsc_barrier(void)
+{
+	__asm__ __volatile__("mfence":::"memory");
+}
+
 static inline unsigned long long get_cpu_clock(void)
 {
 	unsigned int lo, hi;
diff --git a/arch/arch.h b/arch/arch.h
index 3ee9b053..7e294ddf 100644
--- a/arch/arch.h
+++ b/arch/arch.h
@@ -108,6 +108,13 @@ extern unsigned long arch_flags;
 #include "arch-generic.h"
 #endif
 
+#if !defined(__x86_64__) && defined(CONFIG_SYNC_SYNC)
+static inline void tsc_barrier(void)
+{
+	__sync_synchronize();
+}
+#endif
+
 #include "../lib/ffz.h"
 /* IWYU pragma: end_exports */
 
diff --git a/gettime.c b/gettime.c
index bc66a3ac..5ca31206 100644
--- a/gettime.c
+++ b/gettime.c
@@ -623,7 +623,7 @@ static void *clock_thread_fn(void *data)
 			seq = *t->seq;
 			if (seq == UINT_MAX)
 				break;
-			__sync_synchronize();
+			tsc_barrier();
 			tsc = get_cpu_clock();
 		} while (seq != atomic32_compare_and_swap(t->seq, seq, seq + 1));
 
-- 
2.43.0

