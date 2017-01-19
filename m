Return-Path: <fio-owner@vger.kernel.org>
Received: from imslp-west.kjsl.com ([65.50.211.133]:54312 "EHLO
        bombadil.infradead.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752434AbdASNTQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 19 Jan 2017 08:19:16 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cUCJx-0006SL-JT
        for fio@vger.kernel.org; Thu, 19 Jan 2017 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170119130001.BE20D2C02A3@kernel.dk>
Date: Thu, 19 Jan 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d7ea5a89fa2745f5bd743187b62bd05120c44c30:

  Fio 2.17 (2017-01-17 08:51:31 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 54441e7b5f44d3786ee12b3fede90c4bb2c2c260:

  init: fix double free of pid_file (2017-01-18 08:18:28 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      init: fix double free of pid_file

 init.c | 3 ---
 1 file changed, 3 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index ae20d61..324dc7b 100644
--- a/init.c
+++ b/init.c
@@ -2717,9 +2717,6 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 	}
 
 out_free:
-	if (pid_file)
-		free(pid_file);
-
 	return ini_idx;
 }
 
