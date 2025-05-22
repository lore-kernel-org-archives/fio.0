Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC5E1A5B99
	for <fio@vger.kernel.org>; Thu, 22 May 2025 05:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747893340; cv=none; b=hVjPD5x7W5AbW+2wstcnxfujaNfXESV8917Yon6KaTpErQRpfXtgNSuRs2bnZ5ExjeUELd0xLoo2xV+shANGtiSohYTgVs4qQmBoc+01T80cq4ogA7btqO42ik1g/ylq2tZD5xBUVWrhmcM3qi8XN6evAyeF2hCzZTQxqb5uFhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747893340; c=relaxed/simple;
	bh=h62rr09PS636e+8Rr0iJjyyiyW7zlFuOlV7uhxp4Vb4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AcwekHhln8ArSCfCLXM37t/OwhjlWxNNzgpDCsMp0rFu1xNjF8ue6GlaJbVi0SK8ri1i90xqlkwsQjc6JQYzhKZBpueTLRWCRKuKrcUC+iTSgoIdyyLV0La1sVQyasehUxolfPuEk612bSRr7USdQXBj1Di6lS8FkuKl2vQEg3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1747893325-086e2367bdee2b0001-eg1xC3
Received: from ZXSHMBX2.zhaoxin.com (ZXSHMBX2.zhaoxin.com [10.28.252.164]) by mx1.zhaoxin.com with ESMTP id kIs2MZAWYeKcsbeg (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Thu, 22 May 2025 13:55:25 +0800 (CST)
X-Barracuda-Envelope-From: RunaGuo-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX2.zhaoxin.com
 (10.28.252.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Thu, 22 May
 2025 13:55:25 +0800
Received: from ZXSHMBX1.zhaoxin.com ([::1]) by ZXSHMBX1.zhaoxin.com
 ([fe80::2c07:394e:4919:4dc1%7]) with mapi id 15.01.2507.044; Thu, 22 May 2025
 13:55:25 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from runaguo-ubuntu-18-04.Zhaoxin.com (10.29.8.38) by
 zxbjmbx1.zhaoxin.com (10.29.252.163) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 22 May 2025 12:37:03 +0800
From: Runa Guo-oc <RunaGuo-oc@zhaoxin.com>
To: <fio@vger.kernel.org>, <axboe@kernel.dk>, <vincentfu@gmail.com>
CC: <cobechen@zhaoxin.com>, <tonywwang@zhaoxin.com>, <xanderchen@zhaoxin.com>,
	<louisqi@zhaoxin.com>, <runaguo@zhaoxin.com>, <leoliu@zhaoxin.com>
Subject: [PATCH] Add Zhaoxin support to enable tsc_reliable and arch_random features
Date: Thu, 22 May 2025 12:37:03 +0800
X-ASG-Orig-Subj: [PATCH] Add Zhaoxin support to enable tsc_reliable and arch_random features
Message-ID: <20250522043703.8458-1-RunaGuo-oc@zhaoxin.com>
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
X-Moderation-Data: 5/22/2025 1:55:23 PM
X-Barracuda-Connect: ZXSHMBX2.zhaoxin.com[10.28.252.164]
X-Barracuda-Start-Time: 1747893325
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.35:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 694
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.141743
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

Signed-off-by: Runa Guo-oc <RunaGuo-oc@zhaoxin.com>
---
 arch/arch-x86-common.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arch-x86-common.h b/arch/arch-x86-common.h
index f32835cc..bd329c32 100644
--- a/arch/arch-x86-common.h
+++ b/arch/arch-x86-common.h
@@ -68,7 +68,8 @@ static inline void arch_init(char *envp[])
 			 (unsigned int *) &str[4]);
 
 	str[12] = '\0';
-	if (!strcmp(str, "GenuineIntel"))
+	if (!strcmp(str, "GenuineIntel")) || (!strcmp(str, "  Shanghai  ") ||
+	    !strcmp(str, "CentaurHauls"))
 		arch_init_intel();
 	else if (!strcmp(str, "AuthenticAMD") || !strcmp(str, "HygonGenuine"))
 		arch_init_amd();
-- 
2.17.1

