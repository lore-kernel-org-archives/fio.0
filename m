Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB20DC4332F
	for <fio@archiver.kernel.org>; Wed, 29 Sep 2021 12:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B02146141B
	for <fio@archiver.kernel.org>; Wed, 29 Sep 2021 12:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343625AbhI2MCj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 29 Sep 2021 08:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343601AbhI2MCg (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 29 Sep 2021 08:02:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8244C06161C
        for <fio@vger.kernel.org>; Wed, 29 Sep 2021 05:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=k2vpmfVcbJ1r1LyTWAxiwIai//PT6ELxrG1lSdrtH28=; b=WkX580qjuriun3H8G76a9Ofonu
        8g/Ti5hiBULza1brMZmlBUrzu0xpPgv5eyIVcfxbzTvH1nsUU184aDYiXQynqTg5I2nxSUQ5i0uXt
        P5nWsURrFWR2uQjE0K4e+f2bQnyZ3dkHwV1FY6s9McMPeOmbmAlg/FDhu/PpjKH9cy9KCNUYcB9ck
        U9lYNKS60i/npCoqB2U2v+kJu1LULOBuQ5/YVwKuLU3dBztEykHtiXgcJHKgqBWPW5xKFtht+Ektd
        4xjPBcbHkWstmPxBdPMdssTf3+kw8M5Y49oMAXvo2muw37iy6pN7VUN7D2QJwA4rPx9fY08LAeNwC
        iBlx1RfA==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVYFp-00BnyR-KL
        for fio@vger.kernel.org; Wed, 29 Sep 2021 12:00:21 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 452861BC0130; Wed, 29 Sep 2021 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20210929120002.452861BC0130@kernel.dk>
Date:   Wed, 29 Sep 2021 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 6e0ef20ffd975fc217aba4e7c125b420cd2fbd91:

  Merge branch 'onecore' of https://github.com/ByteHamster/fio (2021-09-26 16:32:32 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to cd312799e6a82557abbd742797b59f51e8c2c2e4:

  Merge branch 'sigbreak' of https://github.com/bjpaupor/fio (2021-09-28 13:28:18 -0600)

----------------------------------------------------------------
Brandon Paupore (1):
      add signal handlers for Windows SIGBREAK

Jens Axboe (1):
      Merge branch 'sigbreak' of https://github.com/bjpaupor/fio

 server.c     | 5 +++++
 t/io_uring.c | 5 +++++
 2 files changed, 10 insertions(+)

---

Diff of recent changes:

diff --git a/server.c b/server.c
index 859a401b..90c52e01 100644
--- a/server.c
+++ b/server.c
@@ -2457,6 +2457,11 @@ static void set_sig_handlers(void)
 	};
 
 	sigaction(SIGINT, &act, NULL);
+
+	/* Windows uses SIGBREAK as a quit signal from other applications */
+#ifdef WIN32
+	sigaction(SIGBREAK, &act, NULL);
+#endif
 }
 
 void fio_server_destroy_sk_key(void)
diff --git a/t/io_uring.c b/t/io_uring.c
index f22c504a..e5568aa2 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -684,6 +684,11 @@ static void arm_sig_int(void)
 	act.sa_handler = sig_int;
 	act.sa_flags = SA_RESTART;
 	sigaction(SIGINT, &act, NULL);
+
+	/* Windows uses SIGBREAK as a quit signal from other applications */
+#ifdef WIN32
+	sigaction(SIGBREAK, &act, NULL);
+#endif
 }
 
 static int setup_ring(struct submitter *s)
