Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0804C433EF
	for <fio@archiver.kernel.org>; Thu, 26 May 2022 12:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbiEZMAJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 26 May 2022 08:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242491AbiEZMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 26 May 2022 08:00:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E701C8BEA
        for <fio@vger.kernel.org>; Thu, 26 May 2022 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=AZNJge3ed3r/y3nQzj4t6XODC+MHa5A3hVbEQPHGi2g=; b=u0E7K1rge0tUaKNixLjG20+Gvu
        USfuM9UAvuPayADoreEt+jIcWM9NPczjLbTFZDXagqsvqHd7gf9K2VaAK/Z19FNW5xiQzuWW1tMIB
        3CdDWlZ/RTnN0iMrFEzQK3M9SnF3FrGWlohoAT+rrv9T2NrhBKCB1qLfdz1XF36Z84rd6yxveNx5I
        hAN80EFGjOjlMVphI1HyIwHAv+eRLqI3tbXopHaAuMI/u8Ke+TbIGJiIA7v2H/MX/V7CMXoXbrSbS
        nbhhHS4zAaSp1yPNf75td/eLUzs3ZZTDxGOpEgVNOpIaJA6n2fsJFKFJCHPvcNnihMlArFL06gbsf
        bJ3VPxYw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nuC9s-001Dnu-OB
        for fio@vger.kernel.org; Thu, 26 May 2022 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 43D391BC017B; Thu, 26 May 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220526120002.43D391BC017B@kernel.dk>
Date:   Thu, 26 May 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 6f1a24593c227a4f392f454698aca20e95f0006c:

  Makefile: Suppress `-Wimplicit-fallthrough` when compiling `lex.yy` (2022-05-12 11:02:55 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a2840331c3cae5b2b0a13f99e58ae18375e2e40d:

  Merge branch 'master' of https://github.com/guoanwu/fio (2022-05-25 06:30:06 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'master' of https://github.com/guoanwu/fio

dennis.wu (1):
      pmemblk.c: fix one logic bug - read always with write

 engines/pmemblk.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/engines/pmemblk.c b/engines/pmemblk.c
index fc6358e8..849d8a15 100644
--- a/engines/pmemblk.c
+++ b/engines/pmemblk.c
@@ -375,10 +375,11 @@ static enum fio_q_status fio_pmemblk_queue(struct thread_data *td,
 		off /= pmb->pmb_bsize;
 		len /= pmb->pmb_bsize;
 		while (0 < len) {
-			if (io_u->ddir == DDIR_READ &&
-			   0 != pmemblk_read(pmb->pmb_pool, buf, off)) {
-				io_u->error = errno;
-				break;
+			if (io_u->ddir == DDIR_READ) {
+				if (0 != pmemblk_read(pmb->pmb_pool, buf, off)) {
+					io_u->error = errno;
+					break;
+				}
 			} else if (0 != pmemblk_write(pmb->pmb_pool, buf, off)) {
 				io_u->error = errno;
 				break;
