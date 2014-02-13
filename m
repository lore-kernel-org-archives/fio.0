Return-Path: <fio-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:48652 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaBMGHy (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 13 Feb 2014 01:07:54 -0500
Received: from sits by silver.sucs.swan.ac.uk with local (Exim 4.80)
	(envelope-from <sits@sucs.org>)
	id 1WDpSi-0000d6-T3
	for fio@vger.kernel.org; Thu, 13 Feb 2014 06:07:52 +0000
Date: Thu, 13 Feb 2014 06:07:52 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: [PATCH] cpuid: Null terminate x86 CPU string.
Message-ID: <20140213060742.GA1847@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>
---
 arch/arch-x86-common.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arch-x86-common.h b/arch/arch-x86-common.h
index 179572d..26a14a8 100644
--- a/arch/arch-x86-common.h
+++ b/arch/arch-x86-common.h
@@ -60,6 +60,7 @@ static inline int arch_init(char *envp[])
 			 (unsigned int *) &str[8],
 			 (unsigned int *) &str[4]);
 
+	str[11] = '\0';
 	if (!strcmp(str, "GenuineIntel"))
 		tsc_reliable = arch_init_intel(level);
 	else if (!strcmp(str, "AuthenticAMD"))
-- 
1.8.5.3

-- 
Sitsofe | http://sucs.org/~sits/
