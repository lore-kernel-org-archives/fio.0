Return-Path: <fio-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42166 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725939AbgAaTTN (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 Jan 2020 14:19:13 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFB1A800D5B
        for <fio@vger.kernel.org>; Fri, 31 Jan 2020 19:19:07 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C51A27792F
        for <fio@vger.kernel.org>; Fri, 31 Jan 2020 19:19:07 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] fio: remove duplicate global definition of tsc_reliable
Message-ID: <30587810-2ca6-2a7f-f89b-a4f820b28a11@redhat.com>
Date: Fri, 31 Jan 2020 13:19:07 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

Newer gcc v10 complains about globals being defined twice due to
a new default -fno-common flag. This causes build failures:

  LINK t/fio-dedupe
/usr/bin/ld: t/arch.o:(.bss+0x4): multiple definition of `tsc_reliable'; gettime.o:(.bss+0x4): first defined here
collect2: error: ld returned 1 exit status
make: *** [Makefile:499: t/fio-dedupe] Error 1

Each of the tests which call arch_init() to initialize tsc_reliable:

  File          Function       Line
1 t/dedupe.c    main           536 arch_init(argv);
2 t/lfsr-test.c main            37 arch_init(argv);
3 t/stest.c     main            86 arch_init(argv);

already link with gettime.o which defines tsc_reliable,
so there is no need to provide it from t/arch.c

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I can't really tell if this is the right fix across all arches, but
maybe someone smarter than me can sort it out? :)

diff --git a/t/arch.c b/t/arch.c
index bd28a848..a72cef3a 100644
--- a/t/arch.c
+++ b/t/arch.c
@@ -1,5 +1,4 @@
 #include "../arch/arch.h"
 
 unsigned long arch_flags = 0;
-bool tsc_reliable;
 int arch_random;


