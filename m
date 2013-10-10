Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:36404 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab3JJT0X (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 Oct 2013 15:26:23 -0400
Received: by mail-vc0-f176.google.com with SMTP id ik5so4644vcb.35
        for <fio@vger.kernel.org>; Thu, 10 Oct 2013 12:26:21 -0700 (PDT)
MIME-Version: 1.0
From: Akash Verma <akashv@google.com>
Date: Thu, 10 Oct 2013 12:26:01 -0700
Message-ID: <CAFFT=Unr67MfrDke4hrRztw5qZFBxkaV8HWOf+aTsCW5iWEsxw@mail.gmail.com>
Subject: [PATCH] arch-ppc.h: Fix typo in header guard
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>
Cc: Maria Skidanova <skidam@google.com>, Craig Fuget <cfuget@google.com>

Signed-off-by: Akash Verma <akashv@google.com>
---
 arch/arch-ppc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arch-ppc.h b/arch/arch-ppc.h
index 6c1029c..8313331 100644
--- a/arch/arch-ppc.h
+++ b/arch/arch-ppc.h
@@ -1,5 +1,5 @@
 #ifndef ARCH_PPC_H
-#define ARCH_PPH_H
+#define ARCH_PPC_H

 #include <unistd.h>
 #include <stdlib.h>
-- 
1.8.4
