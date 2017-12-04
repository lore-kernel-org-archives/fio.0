Return-Path: <fio-owner@vger.kernel.org>
Received: from g2t1383g.austin.hpe.com ([15.233.16.89]:22753 "EHLO
        g2t1383g.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752197AbdLDUxU (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 4 Dec 2017 15:53:20 -0500
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g2t1383g.austin.hpe.com (Postfix) with ESMTPS id D5A18210E
        for <fio@vger.kernel.org>; Mon,  4 Dec 2017 20:53:19 +0000 (UTC)
Received: from g4t3433.houston.hpecorp.net (g4t3433.houston.hpecorp.net [16.208.49.245])
        by g9t5008.houston.hpe.com (Postfix) with ESMTP id 1B92575
        for <fio@vger.kernel.org>; Mon,  4 Dec 2017 20:53:19 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH] .gitignore: ignore tags files and additional output binaries
Date: Mon,  4 Dec 2017 14:53:16 -0600
Message-Id: <20171204205316.23312-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

From: Robert Elliott <elliott@hpe.com>

Ignore tags files used by emacs and ctags/vim.

Ignore the additional output binaries alongside fio, such as gfio
and all the programs in t/.
---
 .gitignore | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/.gitignore b/.gitignore
index 463b53a7..0c8cb7c3 100644
--- a/.gitignore
+++ b/.gitignore
@@ -8,7 +8,19 @@
 /config.log
 /cscope.out
 /fio
+/gfio
+/t/axmap
+/t/fio-btrace2fio
+/t/fio-dedupe
+/t/fio-genzipf
+/t/fio-verify-state
+/t/gen-rand
+/t/ieee754
+/t/lfsr-test
+/t/stest
 y.tab.*
 lex.yy.c
 *.un~
 doc/output
+/tags
+/TAGS
-- 
2.14.3

