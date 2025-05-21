Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562CB4430
	for <fio@vger.kernel.org>; Wed, 21 May 2025 02:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747794076; cv=none; b=VSq0ydam1VUxyrG+tJPktS7y08ja+iIlziuE9SYc5dPDLnnYka7YFmNswNT1pfb01IkJKUIBT2hyFT31FdC7C7MDcwxnrQGJlk9YZmDb0o+oC82KuTNkHB0gmvARxHED2363BJL0FR+2q1jxX/tUCbvyaXLWdifYkBYwUEfSopI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747794076; c=relaxed/simple;
	bh=OXtMkWw0VHrWj6Wtte2rxRb4FhC2Sb6cJdAPn5SwtAI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FXQ/HI2RdinUQPs70/w4/TwaFVhSif7DTvfV7hRtJ5RBzXa/M/WnvbMt/gM06CyAg7PDOG1tAM+Zt+n+WpPaSTg9HkZqVPL3GBGeso8QFGcFLbNkNCJ++q0w+Olg22Jnk87Mxccrsc7NHYAvcAQ5QeIoZQDlKQvzukXz98w1fA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1747793129-086e230c4132c30001-eg1xC3
Received: from ZXSHMBX3.zhaoxin.com (ZXSHMBX3.zhaoxin.com [10.28.252.165]) by mx1.zhaoxin.com with ESMTP id EcPdn5cDp95yAMHa (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Wed, 21 May 2025 10:05:29 +0800 (CST)
X-Barracuda-Envelope-From: RunaGuo-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX3.zhaoxin.com
 (10.28.252.165) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Wed, 21 May
 2025 10:05:29 +0800
Received: from ZXSHMBX1.zhaoxin.com ([::1]) by ZXSHMBX1.zhaoxin.com
 ([fe80::2c07:394e:4919:4dc1%7]) with mapi id 15.01.2507.044; Wed, 21 May 2025
 10:05:29 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from runaguo-ubuntu-18-04.Zhaoxin.com (10.29.8.38) by
 zxbjmbx1.zhaoxin.com (10.29.252.163) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 21 May 2025 10:04:21 +0800
From: Runa Guo-oc <RunaGuo-oc@zhaoxin.com>
To: <fio@vger.kernel.org>, <axboe@kernel.dk>, <vincentfu@gmail.com>
CC: <cobechen@zhaoxin.com>, <tonywwang@zhaoxin.com>, <xanderchen@zhaoxin.com>,
	<louisqi@zhaoxin.com>, <runaguo@zhaoxin.com>, <leoliu@zhaoxin.com>
Subject: [PATCH] Add Zhaoxin support to enable tsc_reliable and arch_random features
Date: Wed, 21 May 2025 10:04:21 +0800
X-ASG-Orig-Subj: [PATCH] Add Zhaoxin support to enable tsc_reliable and arch_random features
Message-ID: <20250521020421.6862-1-RunaGuo-oc@zhaoxin.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Moderation-Data: 5/21/2025 10:05:28 AM
X-Barracuda-Connect: ZXSHMBX3.zhaoxin.com[10.28.252.165]
X-Barracuda-Start-Time: 1747793129
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.35:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 1328
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.141690
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

Signed-off-by: Runa Guo-oc <RunaGuo-oc@zhaoxin.com>
---
 arch/arch-x86-common.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arch-x86-common.h b/arch/arch-x86-common.h
index f32835cc..fbbbd62e 100644
--- a/arch/arch-x86-common.h
+++ b/arch/arch-x86-common.h
@@ -56,6 +56,33 @@ static inline void arch_init_amd(void)
 	tsc_reliable = (edx & (1U << 8)) != 0;
 }
 
+static inline void arch_init_zhaoxin(void)
+{
+	unsigned int eax, ebx, ecx = 0, edx;
+
+	/*
+	 * Check for TSC
+	 */
+	eax = 1;
+	do_cpuid(&eax, &ebx, &ecx, &edx);
+	if (!(edx & (1U << 4)))
+		return;
+
+	/*
+	 * Check for constant rate and synced (across cores) TSC
+	 */
+	eax = 0x80000007;
+	do_cpuid(&eax, &ebx, &ecx, &edx);
+	tsc_reliable = (edx & (1U << 8)) != 0;
+
+	/*
+	 * Check for FDRAND
+	 */
+	eax = 0x1;
+	do_cpuid(&eax, &ebx, &ecx, &edx);
+	arch_random = (ecx & (1U << 30)) != 0;
+}
+
 static inline void arch_init(char *envp[])
 {
 	unsigned int level;
@@ -72,6 +99,8 @@ static inline void arch_init(char *envp[])
 		arch_init_intel();
 	else if (!strcmp(str, "AuthenticAMD") || !strcmp(str, "HygonGenuine"))
 		arch_init_amd();
+	else if (!strcmp(str, "  Shanghai  ") || !strcmp(str, "CentaurHauls"))
+		arch_init_zhaoxin();
 }
 
 #endif
-- 
2.17.1

