Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35106 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751745AbdGFJCh (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Jul 2017 05:02:37 -0400
Received: by mail-pg0-f65.google.com with SMTP id d193so2082971pgc.2
        for <fio@vger.kernel.org>; Thu, 06 Jul 2017 02:02:31 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH] arch/ppc: Fix get_cpu_clock asm clobber list
Date: Thu,  6 Jul 2017 19:02:14 +1000
Message-Id: <20170706090214.26270-1-oohall@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Oliver O'Halloran <oohall@gmail.com>

Mark condition register 0 (cr0) as being clobbered by the inline asm in
get_cpu_clock(). Not doing this results in strange behaviour due to GCC
optimising away some checking. For example e.g:

  $ ./fio examples/null.fio --output-format=json
  time     5500  cycles_start=8085227422910      <--- bad!
  {
    "fio version" : "fio-2.21-89-gb034",
    <snip>

The extra output is due to the flag checking in dprint being removed
at higher optimisation levels.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 arch/arch-ppc.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arch-ppc.h b/arch/arch-ppc.h
index ba452b15b1ff..804d596aecc6 100644
--- a/arch/arch-ppc.h
+++ b/arch/arch-ppc.h
@@ -62,7 +62,8 @@ static inline unsigned long long get_cpu_clock(void)
 		"	cmpwi %0,0;\n"
 		"	beq-  90b;\n"
 	: "=r" (rval)
-	: "i" (SPRN_TBRL));
+	: "i" (SPRN_TBRL)
+	: "cr0");
 
 	return rval;
 }
-- 
2.9.4

