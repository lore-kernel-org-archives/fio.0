Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:36182 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbaDHPwv (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 8 Apr 2014 11:52:51 -0400
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@linux.vnet.ibm.com>;
	Tue, 8 Apr 2014 16:52:50 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id 4314B1B08040
	for <fio@vger.kernel.org>; Tue,  8 Apr 2014 16:52:47 +0100 (BST)
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s38FqbSp65536204
	for <fio@vger.kernel.org>; Tue, 8 Apr 2014 15:52:37 GMT
Received: from d06av03.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s38FqloR007814
	for <fio@vger.kernel.org>; Tue, 8 Apr 2014 09:52:47 -0600
Message-Id: <20140408155246.244233350@linux.vnet.ibm.com>
Date: Tue, 08 Apr 2014 17:52:01 +0200
From: ehrhardt@linux.vnet.ibm.com
Subject: [patch 2/2] [PATCH] fio: fix s390 nop
References: <20140408155159.696154675@linux.vnet.ibm.com>
Content-Disposition: inline; filename=fix-s390-nop.diff
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

When trying to run rate limited fio runs we encountered that the current
definition of a nop uses a privileged instruction which is not even a nop,
but a yield call to the hipervisor.
That leads to a SIGILL as it is privileged.

To solve that issue replace it with a nop, the assembler will take care
of it (likely to become a BCR 0,0)

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
---

[diffstat]
 arch/arch-s390.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

[diff]
--- a/arch/arch-s390.h
+++ b/arch/arch-s390.h
@@ -18,7 +18,7 @@
 #define __NR_sys_vmsplice	309
 #endif
 
-#define nop		asm volatile ("diag 0,0,68" : : : "memory")
+#define nop		asm volatile("nop" : : : "memory")
 #define read_barrier()	asm volatile("bcr 15,0" : : : "memory")
 #define write_barrier()	asm volatile("bcr 15,0" : : : "memory")
 

