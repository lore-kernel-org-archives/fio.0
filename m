Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81CC7E77372
	for <fio@archiver.kernel.org>; Sat, 30 Sep 2023 12:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjI3MAS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 30 Sep 2023 08:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233862AbjI3MAS (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 30 Sep 2023 08:00:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE4A136
        for <fio@vger.kernel.org>; Sat, 30 Sep 2023 05:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=o5dqPNo6HreRoje+aFirZhnB8MYvjrOl9cc3lcNl9HA=; b=Q1Vt5tFKoPnYeNywJtgnm/508c
        MOfP6o9nljOaYWX8yrI0PxMJ53ABOHGpaRJvPOcfbYRF8Fk9v9mAMA6AGv7rhGGnO4701OgrclQjk
        wHJtW7h3yidSCTc/0fSQyWA+enPg7GdmGrVfSjber44k9w0m4MWBBIqm2Sd5rcIN5WX1Cl/8LE4i7
        yH6G8InnNmqVh1C4kz29ww7gghNBMFUJ4fjjj67MGVBiqJn+7Ruosoy7+uWJNSPRTRXgd3v44LYCm
        Uf2F3VNTIExeZb2dZ4Sgn+pxx24NFWf3GU6WM+Z1FJ31YZLlUcX/SpKT/s0uYUn1vC0QynBdi3yco
        rw7FUDAQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qmYdm-00EiSk-RO
        for fio@vger.kernel.org; Sat, 30 Sep 2023 12:00:11 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 428DE1BC0151; Sat, 30 Sep 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230930120001.428DE1BC0151@kernel.dk>
Date:   Sat, 30 Sep 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 06812a4f0e4ff4847076e742557ab406a0e96848:

  Merge branch 'fix_verify_block_offset' of https://github.com/ipylypiv/fio (2023-09-29 00:05:10 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c95b52caacc8ef5c1235fb3754186e981b109bdb:

  ci: switch macos runs from macos-12 to macos-13 (2023-09-29 11:51:10 -0400)

----------------------------------------------------------------
Vincent Fu (2):
      workqueue: handle nice better
      ci: switch macos runs from macos-12 to macos-13

 .github/workflows/ci.yml | 2 +-
 workqueue.c              | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index 69fedf77..b8000024 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -27,7 +27,7 @@ jobs:
           os: ubuntu-22.04
           cc: clang
         - build: macos
-          os: macos-12
+          os: macos-13
         - build: linux-i686-gcc
           os: ubuntu-22.04
           arch: i686
diff --git a/workqueue.c b/workqueue.c
index 9e6c41ff..3636bc3a 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -136,7 +136,8 @@ static void *worker_thread(void *data)
 	sk_out_assign(sw->sk_out);
 
 	if (wq->ops.nice) {
-		if (nice(wq->ops.nice) < 0) {
+		errno = 0;
+		if (nice(wq->ops.nice) == -1 && errno != 0) {
 			log_err("workqueue: nice %s\n", strerror(errno));
 			ret = 1;
 		}
