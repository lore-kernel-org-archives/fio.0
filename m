Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:35636 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab3JHXZ1 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 8 Oct 2013 19:25:27 -0400
Received: by mail-pb0-f53.google.com with SMTP id up15so19115pbc.26
        for <fio@vger.kernel.org>; Tue, 08 Oct 2013 16:25:26 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] fix way of setting ioengine specific parameter
Date: Wed,  9 Oct 2013 08:25:11 +0900
Message-Id: <1381274711-4263-1-git-send-email-akinobu.mita@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>

When I tried to specify userspace_reap parameter which is libaio
ioengine specific, it caused segfault because thread_data.o.description
was unexpectedly set to 1.

The problem is in a way of setting ioengine specific parameter which
doesn't correctly set the value at corresponding offset in thread_data.eo,
but it unexpectedly sets the value in the same offset in thread_data.o
instead.

This fixes it by providing a correct pointer when setting the ioengine
specific parameters.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/options.c b/options.c
index 4b91f52..f26ff77 100644
--- a/options.c
+++ b/options.c
@@ -3603,7 +3603,7 @@ int fio_cmd_option_parse(struct thread_data *td, const char *opt, char *val)
 int fio_cmd_ioengine_option_parse(struct thread_data *td, const char *opt,
 				char *val)
 {
-	return parse_cmd_option(opt, val, td->io_ops->options, td);
+	return parse_cmd_option(opt, val, td->io_ops->options, td->eo);
 }
 
 void fio_fill_default_options(struct thread_data *td)
-- 
1.8.3.1

