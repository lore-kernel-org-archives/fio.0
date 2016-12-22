Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:60067 "EHLO
        g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754899AbcLVGHa (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Dec 2016 01:07:30 -0500
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com [15.241.140.73])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g9t1613g.houston.hpe.com (Postfix) with ESMTPS id AC3FE60538
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 06:07:29 +0000 (UTC)
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g4t3427.houston.hpe.com (Postfix) with ESMTP id 6F1BA7E
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 06:06:30 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH 05/12] Fix unit_base kb_base mixup in thread option conversion functions
Date: Thu, 22 Dec 2016 00:08:46 -0600
Message-Id: <20161222060853.64104-6-elliott@hpe.com>
In-Reply-To: <20161222060853.64104-1-elliott@hpe.com>
References: <20161222060853.64104-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

Don't set unit_base, which is 1 or 8, to kb_base, which is 1000
or 1024, during the convert functions used by the initial cconv test.
---
 cconv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cconv.c b/cconv.c
index 336805b..0c11629 100644
--- a/cconv.c
+++ b/cconv.c
@@ -88,7 +88,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->td_ddir = le32_to_cpu(top->td_ddir);
 	o->rw_seq = le32_to_cpu(top->rw_seq);
 	o->kb_base = le32_to_cpu(top->kb_base);
-	o->unit_base = le32_to_cpu(top->kb_base);
+	o->unit_base = le32_to_cpu(top->unit_base);
 	o->ddir_seq_nr = le32_to_cpu(top->ddir_seq_nr);
 	o->ddir_seq_add = le64_to_cpu(top->ddir_seq_add);
 	o->iodepth = le32_to_cpu(top->iodepth);
@@ -336,7 +336,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->td_ddir = cpu_to_le32(o->td_ddir);
 	top->rw_seq = cpu_to_le32(o->rw_seq);
 	top->kb_base = cpu_to_le32(o->kb_base);
-	top->unit_base = cpu_to_le32(o->kb_base);
+	top->unit_base = cpu_to_le32(o->unit_base);
 	top->ddir_seq_nr = cpu_to_le32(o->ddir_seq_nr);
 	top->iodepth = cpu_to_le32(o->iodepth);
 	top->iodepth_low = cpu_to_le32(o->iodepth_low);
-- 
2.9.3

