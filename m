Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9F6C433F5
	for <fio@archiver.kernel.org>; Tue, 29 Mar 2022 12:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbiC2MCA (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 29 Mar 2022 08:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236174AbiC2MB7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 29 Mar 2022 08:01:59 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1718A66E3
        for <fio@vger.kernel.org>; Tue, 29 Mar 2022 05:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=fFYIWWvx6kL0w36JBkvL/2pS5hH0F7EV1Z+Rljg4GtE=; b=OItKYVqOXei4x9sQTA0O77MUS/
        HgR3jzH98rHnHrsmcKPentiehaLyoWQQNhfECi/8aSvhW9zlXrpuH/VXxcvK/avVSQXb87n4zrep5
        n0faQ4fgF1TK8fKKtolaTzyLMc/nOmJGQ/oIbkMDhbEYpimKZHX3vZSrS/nL+w47NjzoPNsnZyhM5
        Kk7jUkMXTpYXM1TAJoL1DRicjm4qg8M5gcBuxbdQtoWqnA4Nl2xU3Nkwki3dkhR3Xh8tSqXGzv6/q
        yLOXiwJ9IW2m9XIiQ/TnvVLlBlE+pKyy5whzRFs4+COZ4ZqF8MaxQBfVuS26awMR6goil8tVrTOE0
        l9xY9kuw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nZAWB-005pnS-QJ
        for fio@vger.kernel.org; Tue, 29 Mar 2022 12:00:12 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id B04521BC013A; Tue, 29 Mar 2022 06:00:08 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220329120008.B04521BC013A@kernel.dk>
Date:   Tue, 29 Mar 2022 06:00:08 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit e3de2e7fe2889942d46699e72ac06b96eab09e27:

  Merge branch 'github-1372' of https://github.com/vincentkfu/fio (2022-03-24 10:11:34 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a57d3fdce796f1bb516c74db95d016bb6db170c1:

  Merge branch 'master' of https://github.com/cccheng/fio (2022-03-28 06:43:56 -0600)

----------------------------------------------------------------
Chung-Chiang Cheng (1):
      Fix compile error of GCC 4

Jens Axboe (1):
      Merge branch 'master' of https://github.com/cccheng/fio

 compiler/compiler.h | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/compiler/compiler.h b/compiler/compiler.h
index 44fa87b9..3fd0822f 100644
--- a/compiler/compiler.h
+++ b/compiler/compiler.h
@@ -67,6 +67,7 @@
 #endif
 
 #ifndef __has_attribute
+#define __has_attribute(x) __GCC4_has_attribute_##x
 #define __GCC4_has_attribute___fallthrough__	0
 #endif
 
