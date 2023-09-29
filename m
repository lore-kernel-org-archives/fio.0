Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF85E810D5
	for <fio@archiver.kernel.org>; Fri, 29 Sep 2023 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbjI2MAJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 29 Sep 2023 08:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbjI2MAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 29 Sep 2023 08:00:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE521B7
        for <fio@vger.kernel.org>; Fri, 29 Sep 2023 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=gUBc+20kiDOLoJvirk/k5eMLZAOqacWL0gD+WQv36xI=; b=Iv93hMvaYdYzngIO2bSTlwRCZ3
        S1UhQAID/qVxKnpOKouPxroFUSmvgoSQEWxKQP5744WkFZrdt5eeQH1RtFZnZ5YqiUJVkG3LT4fFP
        V0LAXtxAhPfw3iHVAnlTsPxl83QSgiob13U5LtpJwctT1RXgOjF7Sn2XIQIRar9eAMX5SUpIO/jgt
        7FvrZOvGxDRMxZCdfsvLSz2cZQM1cLGq85kOFlyVh9poKbDY7oEdZpXY9N/ZWtbt6WiE+8YtP27aN
        DVRZVg6d8Sgz2W2pChj8IhHeVVCxhtKGLRsM17GOyYjdk/VV4xJIYzidhto43xEfF2jJRpY/g6tnI
        J5fDb4ng==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qmCA8-008bRk-Pn
        for fio@vger.kernel.org; Fri, 29 Sep 2023 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id C39881BC0146; Fri, 29 Sep 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230929120001.C39881BC0146@kernel.dk>
Date:   Fri, 29 Sep 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 996ac91f54844e63ef43092472fc1f7610567b67:

  t/zbd: set mq-deadline scheduler to device-mapper destination devices (2023-09-26 09:00:13 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 06812a4f0e4ff4847076e742557ab406a0e96848:

  Merge branch 'fix_verify_block_offset' of https://github.com/ipylypiv/fio (2023-09-29 00:05:10 -0600)

----------------------------------------------------------------
Igor Pylypiv (1):
      verify: Fix the bad pattern block offset value

Jens Axboe (1):
      Merge branch 'fix_verify_block_offset' of https://github.com/ipylypiv/fio

 verify.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/verify.c b/verify.c
index f7355f30..78f333e6 100644
--- a/verify.c
+++ b/verify.c
@@ -398,7 +398,8 @@ static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
 				(unsigned char)buf[i],
 				(unsigned char)pattern[mod],
 				bits);
-			log_err("fio: bad pattern block offset %u\n", i);
+			log_err("fio: bad pattern block offset %u\n",
+				i + header_size);
 			vc->name = "pattern";
 			log_verify_failure(hdr, vc);
 			return EILSEQ;
