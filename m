Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 389AEC636CC
	for <fio@archiver.kernel.org>; Tue, 31 Jan 2023 13:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjAaNAP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 31 Jan 2023 08:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjAaNAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 31 Jan 2023 08:00:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD76F4C6D5
        for <fio@vger.kernel.org>; Tue, 31 Jan 2023 05:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=/0do4kFqNrSTiw4l+e8Yu13TK/cTOuTMht+FqGa1Wrs=; b=O4f6waGxKir9DSBvBcXxgQ4086
        /xSc51i1lkFqkH7/W3SYh3dfdZhN02q62J/DrlWOaeK93GTcem25pMeuviKS/9pU51TsVQK8iTnI4
        EsODNpeaOg1Z/ghum2ZFOJsG4/aVDn5rfwjTKaxfDKqYoYX5ACBj4IC5kRx9fLQTbd/rTvgqBfski
        wYOJHiJJZVuzRkYMggJNsLhfbPw/nfQH4zfJWeaQedcMxmW5dpzsjONXkBzU0HNUTZL1Rx4rx2wLd
        YoOb1JdI1TkLCfi07DR6+okSFloxrQVJPHZeQ60qAW2myYZDKp90lZS/NNZWCQx7U/09kVP29hyb+
        om9FHrGg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMqF2-00BJg8-CJ
        for fio@vger.kernel.org; Tue, 31 Jan 2023 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id AD53D1BC0161; Tue, 31 Jan 2023 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230131130001.AD53D1BC0161@kernel.dk>
Date:   Tue, 31 Jan 2023 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 1e8ec88fd5f3ab4b7bbd0119708d94fd64a4e7ad:

  Enable crc32c accelleration for arm64 on OSX (2023-01-25 08:01:30 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c6cade164bc7e35e95ba88f816be4f44475e4e23:

  lib/pattern: Fix seg fault when calculating pattern length (2023-01-30 10:46:22 -0500)

----------------------------------------------------------------
Vincent Fu (1):
      lib/pattern: Fix seg fault when calculating pattern length

 lib/pattern.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/lib/pattern.c b/lib/pattern.c
index 9be29af6..e31d4734 100644
--- a/lib/pattern.c
+++ b/lib/pattern.c
@@ -386,7 +386,8 @@ static int parse_and_fill_pattern(const char *in, unsigned int in_len,
 		assert(filled);
 		assert(filled <= out_len);
 		out_len -= filled;
-		out     += filled;
+		if (out)
+			out     += filled;
 		total   += filled;
 
 	} while (in_len);
