Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D5EC433EF
	for <fio@archiver.kernel.org>; Thu, 25 Nov 2021 13:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343993AbhKYNLz (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 Nov 2021 08:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353300AbhKYNJw (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Nov 2021 08:09:52 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5676CC061370
        for <fio@vger.kernel.org>; Thu, 25 Nov 2021 05:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=6trIXQ5ftcQKRIWag+sfIu1Jks51iNAXx1beeqCWXPY=; b=pG3gTVn52zsNA1rVhExOEHQsDs
        AtmzoXuXe5NnvHHTP5MnVtM1wk9rI3nmljJjiBH3NoWPegNt0stX5AYOJIK5LCf8GCoA+HRt+kvd1
        8GlMzt85rTqhnG4OfasVRWoOTfONafkWmXjK32Dj86si4CUViHQqMjsBosFHqKBGXosP5Ch89J3b3
        sHTjWxenYS7unZfbiYMOqXCZD+Me6gUWU++KnRA1nTWZ3/thP2Uu7SkWhSP+HdPblA/6FiDyuoOBc
        MwDHsU3yK6p9twP3cCiMOB9/lAfn6cvLWeuipnZt9L5NridQ4Rq9i40+CFojgYn3TBmJbgqZH2U5t
        ygeiJ5qg==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mqEM8-000SH9-HO
        for fio@vger.kernel.org; Thu, 25 Nov 2021 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id CEA711BC0130; Thu, 25 Nov 2021 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211125130001.CEA711BC0130@kernel.dk>
Date:   Thu, 25 Nov 2021 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 1d08bfb018e600cc47f122fb78c02bf74b84dee8:

  t/dedupe: style fixups (2021-11-21 06:51:11 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2b00ac1c82d54795911343c9b3b3f4ef64c92d92:

  Merge branch 'fix-parse-sync-file-range' of https://github.com/oleglatin/fio (2021-11-24 10:27:20 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fix-parse-sync-file-range' of https://github.com/oleglatin/fio

Oleg Latin (1):
      parse: handle comma-separated options

 parse.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/parse.c b/parse.c
index 45f4f2d3..d086ee48 100644
--- a/parse.c
+++ b/parse.c
@@ -477,13 +477,17 @@ static int check_int(const char *p, int *val)
 
 static size_t opt_len(const char *str)
 {
+	char delimiter[] = {',', ':'};
 	char *postfix;
+	unsigned int i;
 
-	postfix = strchr(str, ':');
-	if (!postfix)
-		return strlen(str);
+	for (i = 0; i < FIO_ARRAY_SIZE(delimiter); i++) {
+		postfix = strchr(str, delimiter[i]);
+		if (postfix)
+			return (int)(postfix - str);
+	}
 
-	return (int)(postfix - str);
+	return strlen(str);
 }
 
 static int str_match_len(const struct value_pair *vp, const char *str)
