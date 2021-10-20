Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39B4C433EF
	for <fio@archiver.kernel.org>; Wed, 20 Oct 2021 12:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F16C61212
	for <fio@archiver.kernel.org>; Wed, 20 Oct 2021 12:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhJTMDh (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 20 Oct 2021 08:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhJTMDh (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 20 Oct 2021 08:03:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CDDC06161C
        for <fio@vger.kernel.org>; Wed, 20 Oct 2021 05:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Nm85dsBvNb+kgvuocrjwzcEqZmYqtdrOXkqZcbze7EE=; b=uUvI9AaA6SDCl3Y5/qIo1xdwJz
        nTveXvrqbsWmUJ+n5RnEoMcZqYTbf0fLOPd4BdUy/EraMKGjy67bjqhymILyGF4VxINtoyPr0dBkD
        Q/Jubs9SPcOOr0LW7cGwriyZst/38W9Cuhmijlq2P/odtvw4Yhja1RncQawGamJLhf1u1Qma2BzSz
        v5DNKT1MFGIaZzHp65pR8b/vkTX0edDv+C+sofFZUUXPCC+tyZawCKW8g2jaR4J0hxIc7cfkV4+Jo
        HSEuXi/GwzSNayoidPe5ylL26K0HW3/JvllTCxRKRBIEsnEqXcVRKi6kyTp05Uh7rT+NIxaAEN3WR
        fXj9sq1Q==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mdAGK-00CSxU-M0
        for fio@vger.kernel.org; Wed, 20 Oct 2021 12:00:18 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 7C9E51BC0175; Wed, 20 Oct 2021 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211020120001.7C9E51BC0175@kernel.dk>
Date:   Wed, 20 Oct 2021 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit a7194b2d3d427e7e5678c55a128639df9caf4a48:

  Merge branch 'fixes_1290' of https://github.com/rthardin/fio (2021-10-18 19:29:46 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 09d0a62931df0bb7ed4ae92b83a245e35d04100a:

  Merge branch 'patch-1' of https://github.com/sweettea/fio (2021-10-19 16:09:21 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'patch-1' of https://github.com/sweettea/fio

Sweet Tea Dorminy (1):
      t/fuzz: Clean up generated dependency makefiles

 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index c3feb53f..f28c130a 100644
--- a/Makefile
+++ b/Makefile
@@ -626,7 +626,7 @@ unittests/unittest: $(UT_OBJS) $(UT_TARGET_OBJS)
 endif
 
 clean: FORCE
-	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(UT_OBJS) $(PROGS) $(T_PROGS) $(T_TEST_PROGS) core.* core gfio unittests/unittest FIO-VERSION-FILE *.[do] lib/*.d oslib/*.[do] crc/*.d engines/*.[do] engines/*.so profiles/*.[do] t/*.[do] unittests/*.[do] unittests/*/*.[do] config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do] lexer.h
+	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(UT_OBJS) $(PROGS) $(T_PROGS) $(T_TEST_PROGS) core.* core gfio unittests/unittest FIO-VERSION-FILE *.[do] lib/*.d oslib/*.[do] crc/*.d engines/*.[do] engines/*.so profiles/*.[do] t/*.[do] t/*/*.[do] unittests/*.[do] unittests/*/*.[do] config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do] lexer.h
 	@rm -f t/fio-btrace2fio t/io_uring t/read-to-pipe-async
 	@rm -rf  doc/output
 
