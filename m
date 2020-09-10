Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728289AbgIJMAu (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 10 Sep 2020 08:00:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8F6C061756
        for <fio@vger.kernel.org>; Thu, 10 Sep 2020 05:00:06 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kGLFE-0005Yu-C7
        for fio@vger.kernel.org; Thu, 10 Sep 2020 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200910120002.307931BC0125@kernel.dk>
Date: Thu, 10 Sep 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ca8ff0968cec7ee47ca7fe5b40f592c2b332b062:

  Merge branch 'zbd' of https://github.com/bvanassche/fio into master (2020-09-08 10:25:48 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e55138eed3296b642229271b0dcec492ec776702:

  Merge branch 'evelu-enghelp' of https://github.com/ErwanAliasr1/fio into master (2020-09-09 10:48:27 -0600)

----------------------------------------------------------------
Erwan Velu (1):
      init: exiting with fio_show_ioengine_help return code

Jens Axboe (1):
      Merge branch 'evelu-enghelp' of https://github.com/ErwanAliasr1/fio into master

 init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 3cd0238b..7f64ce21 100644
--- a/init.c
+++ b/init.c
@@ -2543,7 +2543,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 		case 'i':
 			did_arg = true;
 			if (!cur_client) {
-				fio_show_ioengine_help(optarg);
+				exit_val = fio_show_ioengine_help(optarg);
 				do_exit++;
 			}
 			break;

