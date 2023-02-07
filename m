Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B6D4C636D6
	for <fio@archiver.kernel.org>; Tue,  7 Feb 2023 13:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbjBGNAu (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 08:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbjBGNAj (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 08:00:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DA639CF5
        for <fio@vger.kernel.org>; Tue,  7 Feb 2023 05:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=VXaDo74DkY2pbr1+LJmHdekr4UChKZLtAi6SOkkMCUM=; b=YkfP7xgpYx2ByyqC3rqjRh5Bp0
        akw8pHHxZwUUP4hvjAfVTLtPisRYuibgeJJmov3LNvikHB1Gr+mIXe480CyW1sV8aqnAalw+7YCGg
        Vwh4Olp3FHsqRAGwTnZhh4JwpHhrOLT/spM3Cw/5emhjew8NBz1EkQiQRbIBafx+hXMuaVNgD9O9i
        jarnjgr1/iL+LEOylWeSBE3+u4NbJf4jDhr0SF3kS53DiKcRGpCDPXjRCrQ53F5AoqkD68kg17CHb
        9jwQQijwfnWHte0XMo2OR2rTWeRUQnU7HQVUU87MILk3mlBMM+RzWzyzKCtrtB4RMIRhkbD9aNjLY
        TBRMLosQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pPNZx-000FHl-72
        for fio@vger.kernel.org; Tue, 07 Feb 2023 13:00:10 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 63D171BC015D; Tue,  7 Feb 2023 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230207130002.63D171BC015D@kernel.dk>
Date:   Tue,  7 Feb 2023 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit d72b10e3ca2f7e3b7ef4e54ea98e4e964a67192d:

  fio: add FIO_RO_NEEDS_RW_OPEN ioengine flag (2023-02-03 13:26:32 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6d7f8d9a31f9ecdeab0eed8f23c63b9a94ec61f6:

  engines/libzbc: set FIO_RO_NEEDS_RW_OPEN engine flag (2023-02-06 12:36:37 -0700)

----------------------------------------------------------------
Horshack (1):
      Improve IOPs 50% by avoiding clock sampling when rate options not used

Jens Axboe (2):
      Merge branch 'perf-Avoid_Clock_Check_For_No_Rate_Check' of https://github.com/horshack-dpreview/fio
      engines/libzbc: set FIO_RO_NEEDS_RW_OPEN engine flag

 engines/libzbc.c |  3 ++-
 io_u.c           | 10 +++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/engines/libzbc.c b/engines/libzbc.c
index 2b63ef1a..dae4fe16 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -469,7 +469,8 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.get_max_open_zones	= libzbc_get_max_open_zones,
 	.finish_zone		= libzbc_finish_zone,
 	.queue			= libzbc_queue,
-	.flags			= FIO_SYNCIO | FIO_NOEXTEND | FIO_RAWIO,
+	.flags			= FIO_SYNCIO | FIO_NOEXTEND | FIO_RAWIO |
+				  FIO_RO_NEEDS_RW_OPEN,
 };
 
 static void fio_init fio_libzbc_register(void)
diff --git a/io_u.c b/io_u.c
index 8035f4b7..eb617e64 100644
--- a/io_u.c
+++ b/io_u.c
@@ -785,7 +785,15 @@ static enum fio_ddir get_rw_ddir(struct thread_data *td)
 	else
 		ddir = DDIR_INVAL;
 
-	td->rwmix_ddir = rate_ddir(td, ddir);
+	if (!should_check_rate(td)) {
+		/*
+		 * avoid time-consuming call to utime_since_now() if rate checking
+		 * isn't being used. this imrpoves IOPs 50%. See:
+		 * https://github.com/axboe/fio/issues/1501#issuecomment-1418327049
+		 */
+		td->rwmix_ddir = ddir;
+	} else
+		td->rwmix_ddir = rate_ddir(td, ddir);
 	return td->rwmix_ddir;
 }
 
