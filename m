Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41AF3C433FE
	for <fio@archiver.kernel.org>; Sat, 22 Oct 2022 12:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJVMAS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 22 Oct 2022 08:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiJVMAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 22 Oct 2022 08:00:15 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5916AA878D
        for <fio@vger.kernel.org>; Sat, 22 Oct 2022 05:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=yyfEdpzrmsAyQbbS91UjPJeuwjDURfX9UfiQtEArV0E=; b=dpuMAA1g8aQEiKgfs+kF2FPzH5
        BnVbBH2BUNnjotRD7tX3XaVIr4ALHHccGO0veyDb81cT0TjMz4E7pxBg98dIxEy1bebWHK1rjwvpl
        XomL6fhhthFLHoGaXFR3z473AWh2s0tA48QJACqtDrAOCY9izPjuV1s4z5nj4q+b9bNuP1qeAWUjg
        aufx+H4kXHczYGn4BBFkhPxW4C1m8PPJ5M9H38VO8YyoB/75lLkJSSYcGGYiNQuNQdEH3jmlyAZ8w
        bXzbS4wdRlYqWX5ovb9TP9dQ7+bKBM4cOsE8cLS55kcHpQratCMK227gxt+cNUIj1VgszxabRFSJk
        KiARPQLw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1omDAa-005XpB-6v
        for fio@vger.kernel.org; Sat, 22 Oct 2022 12:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 364141BC0142; Sat, 22 Oct 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221022120002.364141BC0142@kernel.dk>
Date:   Sat, 22 Oct 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 548f1269e3772c666cac4148453d9c63bdfa65c4:

  Merge branch 'issue-1213' of https://github.com/SystemFabricWorks/fio (2022-10-19 12:04:50 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d72244761b2230fbb2d6eaec59cdedd3ea651d4f:

  stat: fix segfault with fio option --bandwidth-log (2022-10-21 13:23:41 -0400)

----------------------------------------------------------------
Ankit Kumar (1):
      stat: fix segfault with fio option --bandwidth-log

 stat.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index 949af5ed..b963973a 100644
--- a/stat.c
+++ b/stat.c
@@ -2870,7 +2870,10 @@ static struct io_logs *get_new_log(struct io_log *iolog)
 	 * forever
 	 */
 	if (!iolog->cur_log_max) {
-		new_samples = iolog->td->o.log_entries;
+		if (iolog->td)
+			new_samples = iolog->td->o.log_entries;
+		else
+			new_samples = DEF_LOG_ENTRIES;
 	} else {
 		new_samples = iolog->cur_log_max * 2;
 		if (new_samples > MAX_LOG_ENTRIES)
