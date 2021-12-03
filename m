Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB360C433F5
	for <fio@archiver.kernel.org>; Fri,  3 Dec 2021 13:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357508AbhLCNDa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 3 Dec 2021 08:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238868AbhLCNDa (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Dec 2021 08:03:30 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C141C06173E
        for <fio@vger.kernel.org>; Fri,  3 Dec 2021 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=2RNPhx2VlpR3SnruD+pviMZNJ7vXpMlBs5hRC5fO6Ag=; b=SqyiRF5r8GK/oOzyF0/LBv7r+I
        H9euH8Q5CCW7Co2MFxQG6Oc08FIadRLS13qDdO9EdQCCUWtsZjXlIqgm27Y0WnE2JLOaQkvyWuL6W
        6PU+12M9Oqg+h9RPxGo6GhBen4evsA1JvkIg8eVUJcY8irrpoYpgHjyDMdAqSgNoy3pdw0D4wxWM5
        eNeAs/54D0pY2HjIfjS30OdstK0pAHH5L3gX/47zytkKt6osSX6XCzjkjo0VOwk0j8+id4JxgzWnV
        zJTxeZROjuu/sn4zQwsm6WMN8Hf+ayqKPdGtkpHaTkjFGrcuFcT8DOnAuXIMlio39KcdBPS3M9dvW
        rbUc/EBA==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mt8AV-008hN8-TS
        for fio@vger.kernel.org; Fri, 03 Dec 2021 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 9561A1BC011B; Fri,  3 Dec 2021 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211203130001.9561A1BC011B@kernel.dk>
Date:   Fri,  3 Dec 2021 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit ed7f3a07363d62c6d6147b0c568f87f079d241a8:

  stat: make add lat percentile functions inline (2021-11-25 09:03:10 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fd1d8e0ab3dc852193037a3acebcf8b8bdbcd9c5:

  filesetup: create zbd_info before jumping to done label (2021-12-02 17:54:15 -0700)

----------------------------------------------------------------
Niklas Cassel (1):
      filesetup: create zbd_info before jumping to done label

 filesetup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index 228e4fff..fb556d84 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1119,9 +1119,6 @@ int setup_files(struct thread_data *td)
 	if (err)
 		goto err_out;
 
-	if (o->read_iolog_file)
-		goto done;
-
 	if (td->o.zone_mode == ZONE_MODE_ZBD) {
 		err = zbd_init_files(td);
 		if (err)
@@ -1129,6 +1126,9 @@ int setup_files(struct thread_data *td)
 	}
 	zbd_recalc_options_with_zone_granularity(td);
 
+	if (o->read_iolog_file)
+		goto done;
+
 	/*
 	 * check sizes. if the files/devices do not exist and the size
 	 * isn't passed to fio, abort.
