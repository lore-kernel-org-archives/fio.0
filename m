Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:36410 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbcFAHE7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 1 Jun 2016 03:04:59 -0400
Received: by mail-pf0-f170.google.com with SMTP id f144so9412281pfa.3
        for <fio@vger.kernel.org>; Wed, 01 Jun 2016 00:04:58 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH] Fix iodepth_batch=0
Date: Wed,  1 Jun 2016 00:04:48 -0700
Message-Id: <7d9e503153a511700809a945521613b3c03389f5.1464764641.git.osandov@fb.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: kernel-team@fb.com, Omar Sandoval <osandov@fb.com>

From: Omar Sandoval <osandov@fb.com>

The man page claims that iodepth_batch=0 falls back to whatever was
specified for iodepth, but the enforced minimum of 1 means that 0 is not
actually valid.

Fixes: a2e6f8ac56a9 ("Make iodepth_batch=1 by default")
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 options.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/options.c b/options.c
index 3360784a02b6..d157185b086c 100644
--- a/options.c
+++ b/options.c
@@ -1678,7 +1678,6 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.help	= "Number of IO buffers to submit in one go",
 		.parent	= "iodepth",
 		.hide	= 1,
-		.minval	= 1,
 		.interval = 1,
 		.def	= "1",
 		.category = FIO_OPT_C_IO,
-- 
2.8.3

