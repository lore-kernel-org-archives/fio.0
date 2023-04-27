Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645DAC77B7C
	for <fio@archiver.kernel.org>; Thu, 27 Apr 2023 12:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243453AbjD0MAJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Apr 2023 08:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243296AbjD0MAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Apr 2023 08:00:08 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771AA4C3D
        for <fio@vger.kernel.org>; Thu, 27 Apr 2023 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=JrHfrMqMAxjr32KWE9mFo+tpYMAgExzv+eQAuue2JYU=; b=HcYfzGU6YaohAa42kpzIArgMPi
        lfzSXf6D9K9Q7IkeYpkjx09yqkRlCaQy1F/cDej/3nD4hBcBNhWfUH3v2jZEvDnd7RbTrylhTxmdo
        VTeVEJTzz8SpCGtP/pgXr/bDLLhleoi5rUNBlkEKWWMx7XumSmErkK7/5nRd7Age0OxlLIrh3STWq
        X/6Bdr8NW0iq63HV/7X8dCLMnHOrhpf7ysaa5MaBiRfBrbAN5G+8eKEMOWCurgBURuvq2C1nwVhq0
        dkr4SKHWLCLNntTvKXJCw8bfwDZ6gehKnIa4lKKMYZiUy0+ZrGOxucVNIrHloGe9cZtdKlV3nvI3A
        N/WgCpUw==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1ps0I8-00CNRd-0l
        for fio@vger.kernel.org;
        Thu, 27 Apr 2023 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id C73621BC0181; Thu, 27 Apr 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230427120001.C73621BC0181@kernel.dk>
Date:   Thu, 27 Apr 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 073974b24aac23610e9e13e3eb56438ad108ab31:

  filesetup: better handle non-uniform distributions (2023-04-20 15:24:39 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9724b4f5ebf0841087c5a56c1d83efe0f4aeb6d7:

  Revert "zbd: Report the zone capacity" (2023-04-27 05:08:29 -0600)

----------------------------------------------------------------
Niklas Cassel (1):
      Revert "zbd: Report the zone capacity"

 zbd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/zbd.c b/zbd.c
index f5fb923a..351b3971 100644
--- a/zbd.c
+++ b/zbd.c
@@ -804,8 +804,8 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 		goto out;
 	}
 
-	dprint(FD_ZBD, "Device %s has %d zones of size %"PRIu64" KB and capacity %"PRIu64" KB\n",
-	       f->file_name, nr_zones, zone_size / 1024, zones[0].capacity / 1024);
+	dprint(FD_ZBD, "Device %s has %d zones of size %"PRIu64" KB\n",
+	       f->file_name, nr_zones, zone_size / 1024);
 
 	zbd_info = scalloc(1, sizeof(*zbd_info) +
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
