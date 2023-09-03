Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9882CA0FE3
	for <fio@archiver.kernel.org>; Sun,  3 Sep 2023 12:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbjICMAU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 3 Sep 2023 08:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjICMAR (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 3 Sep 2023 08:00:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B7310B
        for <fio@vger.kernel.org>; Sun,  3 Sep 2023 05:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=dh+fqWmGJmYlwk3JAGGqBsLJNFJy/Tey7FrlGaVPXLQ=; b=Jg6KJG2TTZxK0Gz0Sd4UQV9kzb
        WHU4kqGhPiYT55oDODm+Ys1Ajy0mzHhVXVHg7MbcqrfRrMOxmT46BW0BMDyx4bWt/aSymN+W0RzV8
        texyloXJz6AqunlUMmecuFZ4jFLpUspZPIKraymPkJmsTRnI5EdcIxrcX1J48eKnJWpQHDLk7qJ8O
        r1FzFqkyfy0WTUTqZVBQT3lAQdXptBmxCDIKCOrVurDPKZNMt3M7Aux+yU1f0Q1vmkuB8GLA2m++1
        VcKO2ZfdUAfgniHoABoKuM+FQHz8GLBrnUrPJHJ1G6wx/cI1ldz6sudVFm3PcfD8EpML7MM0Fm5vO
        hXGuwaJQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qclly-005JPk-Ie
        for fio@vger.kernel.org; Sun, 03 Sep 2023 12:00:10 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 363EA1BC0127; Sun,  3 Sep 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230903120001.363EA1BC0127@kernel.dk>
Date:   Sun,  3 Sep 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 4a0c766c69ddfe5231d65f2676e97333ba89ab2b:

  Merge branch 'master' of https://github.com/michalbiesek/fio (2023-08-23 08:21:39 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 904ee91c2831615a054a8dea9b164e96ae00abb3:

  Merge branch 'pcpp_parse_nr_fix' of https://github.com/PCPartPicker/fio (2023-09-02 07:35:49 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'pcpp_parse_nr_fix' of https://github.com/PCPartPicker/fio

aggieNick02 (1):
      Add basic error checking to parsing nr from rw=randrw:<nr>, etc

 options.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/options.c b/options.c
index 48aa0d7b..65b2813c 100644
--- a/options.c
+++ b/options.c
@@ -596,9 +596,21 @@ static int str_rw_cb(void *data, const char *str)
 	if (!nr)
 		return 0;
 
-	if (td_random(td))
-		o->ddir_seq_nr = atoi(nr);
-	else {
+	if (td_random(td)) {
+		long long val;
+
+		if (str_to_decimal(nr, &val, 1, o, 0, 0)) {
+			log_err("fio: randrw postfix parsing failed\n");
+			free(nr);
+			return 1;
+		}
+		if ((val <= 0) || (val > UINT_MAX)) {
+			log_err("fio: randrw postfix parsing out of range\n");
+			free(nr);
+			return 1;
+		}
+		o->ddir_seq_nr = (unsigned int) val;
+	} else {
 		long long val;
 
 		if (str_to_decimal(nr, &val, 1, o, 0, 0)) {
