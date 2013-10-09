Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:55912 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab3JIO63 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 9 Oct 2013 10:58:29 -0400
Received: by mail-pa0-f45.google.com with SMTP id rd3so1157824pab.32
        for <fio@vger.kernel.org>; Wed, 09 Oct 2013 07:58:29 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2] make ioengine specific command line options work
Date: Wed,  9 Oct 2013 23:58:16 +0900
Message-Id: <1381330696-11143-1-git-send-email-akinobu.mita@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>

If the ioengine specific parameter is given on the command line,
unrelated value in thread_data.o will be corrupted unexpectedly.
Specifically, if libaio specific parameter userspace_reap is given
on the command line, thread_data.o.description will be set to 1.

This fixes it by passing the correct pointer of ioengine specific
options to the command line parser.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v2
- Update commit log to clarify that this problem only happens with the
  command line options.

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

