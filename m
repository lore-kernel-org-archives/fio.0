Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbhBKNAu (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 11 Feb 2021 08:00:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A63EC061574
        for <fio@vger.kernel.org>; Thu, 11 Feb 2021 05:00:06 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lABZj-00AFiO-KO
        for fio@vger.kernel.org; Thu, 11 Feb 2021 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210211130001.7A7F01BC0159@kernel.dk>
Date: Thu, 11 Feb 2021 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2ef3c1b02473a14bf7b8b52e28d0cdded9c5cc9a:

  zbd: relocate Coverity annotation (2021-01-29 22:06:49 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b02c5eda07966d2e1c41870f64b741413b67a9aa:

  Merge branch 'taras/clientuid' of https://github.com/tarasglek/fio-1 (2021-02-10 13:22:04 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'taras/clientuid' of https://github.com/tarasglek/fio-1

Taras Glek (1):
      $clientuid keyword to differentiate clients in client/server mode.

 HOWTO  |  2 ++
 fio.1  |  3 +++
 init.c | 19 ++++++++++++++++++-
 3 files changed, 23 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index b6d1b58a..52812cc7 100644
--- a/HOWTO
+++ b/HOWTO
@@ -809,6 +809,8 @@ Target file/device
 
 		**$jobname**
 				The name of the worker thread or process.
+		**$clientuid**
+				IP of the fio process when using client/server mode.
 		**$jobnum**
 				The incremental number of the worker thread or process.
 		**$filenum**
diff --git a/fio.1 b/fio.1
index aa248a3b..accc6a32 100644
--- a/fio.1
+++ b/fio.1
@@ -584,6 +584,9 @@ string:
 .B $jobname
 The name of the worker thread or process.
 .TP
+.B $clientuid
+IP of the fio process when using client/server mode.
+.TP
 .B $jobnum
 The incremental number of the worker thread or process.
 .TP
diff --git a/init.c b/init.c
index d6dbaf7c..eea6e546 100644
--- a/init.c
+++ b/init.c
@@ -1238,7 +1238,8 @@ enum {
 	FPRE_NONE = 0,
 	FPRE_JOBNAME,
 	FPRE_JOBNUM,
-	FPRE_FILENUM
+	FPRE_FILENUM,
+	FPRE_CLIENTUID
 };
 
 static struct fpre_keyword {
@@ -1249,6 +1250,7 @@ static struct fpre_keyword {
 	{ .keyword = "$jobname",	.key = FPRE_JOBNAME, },
 	{ .keyword = "$jobnum",		.key = FPRE_JOBNUM, },
 	{ .keyword = "$filenum",	.key = FPRE_FILENUM, },
+	{ .keyword = "$clientuid",	.key = FPRE_CLIENTUID, },
 	{ .keyword = NULL, },
 	};
 
@@ -1338,6 +1340,21 @@ static char *make_filename(char *buf, size_t buf_size,struct thread_options *o,
 				}
 				break;
 				}
+			case FPRE_CLIENTUID: {
+				int ret;
+				ret = snprintf(dst, dst_left, "%s", client_sockaddr_str);
+				if (ret < 0)
+					break;
+				else if (ret > dst_left) {
+					log_err("fio: truncated filename\n");
+					dst += dst_left;
+					dst_left = 0;
+				} else {
+					dst += ret;
+					dst_left -= ret;
+				}
+				break;
+				}
 			default:
 				assert(0);
 				break;

