Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3C61FAC34
	for <fio@vger.kernel.org>; Fri, 23 May 2025 00:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747961724; cv=none; b=uVM9A/aMjNuZC9c6wB+XHJduirDrg9b8O3h9uL6S+zLg1n/n8EUK/n8qnkAueOFY8ZX9PtUDzv0FTumd6Fo35DzUZvsIZKe7M7lskfIBCizrgYIElw3j0vijmTrfnnxHrIrbcRmmxYuoDtNMVNVYhOG6ZEy4b/B2x0ZAgLHFOU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747961724; c=relaxed/simple;
	bh=6WMtw1NDP/BQODkyEYKNUQkg9ES+r8gjctkLBEzUbG8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kaPJBEGTLpEJ1wB1fn/aXrS7oM9cySOV473E5TkjcKdbhkQuoxaYkxjoR3fn6SEIxnNthrm59XVg0wHiLYmqQUaKIuGdZa0hlZfIw4EHrqDsEC7PgsMH8olst9dBpIH5KG++Ip6k3qrrpZMfnyRUUcJnUqG9aSF9232rv7p6iEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1747961713-086e236cb99fe30001-eg1xC3
Received: from ZXSHMBX3.zhaoxin.com (ZXSHMBX3.zhaoxin.com [10.28.252.165]) by mx1.zhaoxin.com with ESMTP id hP2Nj4sgSHoo7KU1 (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Fri, 23 May 2025 08:55:13 +0800 (CST)
X-Barracuda-Envelope-From: RunaGuo-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX3.zhaoxin.com
 (10.28.252.165) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Fri, 23 May
 2025 08:55:12 +0800
Received: from ZXSHMBX1.zhaoxin.com ([::1]) by ZXSHMBX1.zhaoxin.com
 ([fe80::2c07:394e:4919:4dc1%7]) with mapi id 15.01.2507.044; Fri, 23 May 2025
 08:55:12 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from runaguo-ubuntu-18-04.Zhaoxin.com (10.29.8.38) by
 zxbjmbx1.zhaoxin.com (10.29.252.163) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 22 May 2025 18:40:32 +0800
From: Runa Guo-oc <RunaGuo-oc@zhaoxin.com>
To: <fio@vger.kernel.org>, <axboe@kernel.dk>, <vincentfu@gmail.com>
CC: <cobechen@zhaoxin.com>, <tonywwang@zhaoxin.com>, <xanderchen@zhaoxin.com>,
	<louisqi@zhaoxin.com>, <runaguo@zhaoxin.com>, <leoliu@zhaoxin.com>
Subject: [PATCH] Add Zhaoxin support to enable tsc_reliable and arch_random features
Date: Thu, 22 May 2025 18:40:32 +0800
X-ASG-Orig-Subj: [PATCH] Add Zhaoxin support to enable tsc_reliable and arch_random features
Message-ID: <20250522104032.17519-1-RunaGuo-oc@zhaoxin.com>
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
X-Moderation-Data: 5/23/2025 8:55:11 AM
X-Barracuda-Connect: ZXSHMBX3.zhaoxin.com[10.28.252.165]
X-Barracuda-Start-Time: 1747961713
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.35:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 692
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -1.21
X-Barracuda-Spam-Status: No, SCORE=-1.21 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=DATE_IN_PAST_12_24, DATE_IN_PAST_12_24_2
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.141781
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.01 DATE_IN_PAST_12_24     Date: is 12 to 24 hours before Received: date
	0.80 DATE_IN_PAST_12_24_2   DATE_IN_PAST_12_24_2

Signed-off-by: Runa Guo-oc <RunaGuo-oc@zhaoxin.com>
---
 arch/arch-x86-common.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arch-x86-common.h b/arch/arch-x86-common.h
index f32835cc..ac26126a 100644
--- a/arch/arch-x86-common.h
+++ b/arch/arch-x86-common.h
@@ -68,7 +68,8 @@ static inline void arch_init(char *envp[])
 			 (unsigned int *) &str[4]);
 
 	str[12] = '\0';
-	if (!strcmp(str, "GenuineIntel"))
+	if (!strcmp(str, "GenuineIntel") || !strcmp(str, "  Shanghai  ") ||
+	    !strcmp(str, "CentaurHauls"))
 		arch_init_intel();
 	else if (!strcmp(str, "AuthenticAMD") || !strcmp(str, "HygonGenuine"))
 		arch_init_amd();
-- 
2.17.1

