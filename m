Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C37B9C00144
	for <fio@archiver.kernel.org>; Fri, 29 Jul 2022 12:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbiG2MAM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 29 Jul 2022 08:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbiG2MAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 29 Jul 2022 08:00:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C9339E
        for <fio@vger.kernel.org>; Fri, 29 Jul 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=xCuJY8JFz/MPwfeRorN9yYPyOQg2PSEji8UNVcPm8iM=; b=NUGDLJM51ha6uhUucHqQRWMXNm
        nc3+E7lHxQ3HrbqJGJOt/zahchiyATV3IqzBD+m2e/BeLDCYQaiy5j/c0avGcgQ3ZKkddWNFXD7r4
        zlwa7kppUuEGYPwbk8awurZopDnNPSlmQ7Ev/0JJcPU6+5NCM/PXpXjTOZWvbrzv70ue5MV2GNZ9e
        zuKk46IgCODp/RGbJCW6li+mA9r0TuI/v0RgR8OB/XiLlWqAsJp/hQfBQWT0XOJOH6W20dCWaM7IQ
        syV1r2FaFjPmj/32Xv1i/jdsv4xJ3BSTsRls4FXLoeUqiHWZiuum0D3aY8kvGAXnST12/dMz6vFyr
        lZgW4jxA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oHOey-004hNv-Fq
        for fio@vger.kernel.org; Fri, 29 Jul 2022 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id E48CF1BC0178; Fri, 29 Jul 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220729120001.E48CF1BC0178@kernel.dk>
Date:   Fri, 29 Jul 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 5b99196735a245224ec9321f796a9da30654ae6c:

  README: add maintainer section (2022-07-27 21:04:31 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3e1d3f2fc4a5f09174f0d6d70d036285d69f17c2:

  .github: add pull request template (2022-07-28 11:00:04 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      .github: add pull request template

 .github/PULL_REQUEST_TEMPLATE.md | 8 ++++++++
 1 file changed, 8 insertions(+)
 create mode 100644 .github/PULL_REQUEST_TEMPLATE.md

---

Diff of recent changes:

diff --git a/.github/PULL_REQUEST_TEMPLATE.md b/.github/PULL_REQUEST_TEMPLATE.md
new file mode 100644
index 00000000..4d98a694
--- /dev/null
+++ b/.github/PULL_REQUEST_TEMPLATE.md
@@ -0,0 +1,8 @@
+Please confirm that your commit message(s) follow these guidelines:
+
+1. First line is a commit title, a descriptive one-liner for the change
+2. Empty second line
+3. Commit message body that explains why the change is useful. Break lines that
+   aren't something like a URL at 72-74 chars.
+4. Empty line
+5. Signed-off-by: Real Name <real@email.com>
