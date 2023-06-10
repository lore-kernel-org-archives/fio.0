Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A42C7EE2E
	for <fio@archiver.kernel.org>; Sat, 10 Jun 2023 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjFJMAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 10 Jun 2023 08:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjFJMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 10 Jun 2023 08:00:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3909826B2
        for <fio@vger.kernel.org>; Sat, 10 Jun 2023 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=RfEHlgTtlnmhlbFU2Mpwcg34XuNqS/VznM8LNOFVNJc=; b=BH8bErdwaW9qngJqGjNk1ZSFeq
        y7ho/7Smgn+cn6taQvoPcL6xP/bnyZTiQn4AxeX2+SAffb/BxxJwvqVxgh9xVQF+juuvNJsYKGJ9U
        zQNrtESaWM8JeZgpqIOeSIuIYjEtHi6iQ/3zgMlmXHX8bVo9XoHDUwECAMTYvGvl6naVF4C2hMD20
        EXNBjoCQoBsJDtZKv4LFF5f28PFr6H9C2oNaYRrEq0MYf10DAjnIuZu2EQZ9NWRR2Dypl258n17uL
        m1G8utM7bTi2TJasvKFbxc7CReGXqxkukqt0rJr/2ehM2Pi8xZobYdmZSo7aBmkrFrR4Wswijb5ln
        Qmjhk4bQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1q7xGG-000Dvb-Bl
        for fio@vger.kernel.org; Sat, 10 Jun 2023 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id D826A1BC0155; Sat, 10 Jun 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230610120001.D826A1BC0155@kernel.dk>
Date:   Sat, 10 Jun 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit edaee5b96fd87c3c5fe7f64ec917a175cd9237fc:

  t/zbd: test write zone accounting of trim workload (2023-06-08 14:39:07 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 62ac66490f5077e5fca1bd5b49165147cafc5a0d:

  zbd: avoid Coverity defect report (2023-06-09 18:04:45 -0600)

----------------------------------------------------------------
Shin'ichiro Kawasaki (1):
      zbd: avoid Coverity defect report

 zbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/zbd.c b/zbd.c
index 9455140a..7fcf1ec4 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1547,11 +1547,11 @@ retry:
 		dprint(FD_ZBD,
 		       "%s(%s): wait zone write and retry write target zone selection\n",
 		       __func__, f->file_name);
+		should_retry = in_flight;
 		pthread_mutex_unlock(&zbdi->mutex);
 		zone_unlock(z);
 		io_u_quiesce(td);
 		zone_lock(td, f, z);
-		should_retry = in_flight;
 		goto retry;
 	}
 
