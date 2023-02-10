Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC65C636CD
	for <fio@archiver.kernel.org>; Fri, 10 Feb 2023 13:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjBJNAL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Feb 2023 08:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbjBJNAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Feb 2023 08:00:10 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F5B93FF
        for <fio@vger.kernel.org>; Fri, 10 Feb 2023 05:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=+jEY9WlZYn6o4WDRaArOq+zKk31KarO37fiPOs016Xg=; b=SsgZDtFBglUQilq5GOqbkYtSfx
        n3biojQQUQTfa/eM8tWiZFCf2bH2ObqRPvPnfnEhIuWWEuZ41VjevdTSlJjuYs3t/349m8MiZwC7y
        372N+u+7Y58LWylssQf120Rgs3LX6LnapKEhP3HIMZ9a2KEnZuNx0Fmv69MbUaUmDIZtur/2M4gOI
        xGhADXOikGUaCSGI6U0qH+FRG6SkfJYW9ysPxKi2kPwtcH5ftexKW+VHTlmu6PLH6fDTh2rJlflBj
        DDaxqxacbMZAEuaB6TKpFqwveuVMt4wkcIQvmpkAk7E7TisZJ2TgJJst0z4GVN/Rhi1hvBnSG4uMp
        9fJDeHAg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pQSzu-008Cuw-1T
        for fio@vger.kernel.org;
        Fri, 10 Feb 2023 12:59:27 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 0F8781BC0174; Fri, 10 Feb 2023 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230210130002.0F8781BC0174@kernel.dk>
Date:   Fri, 10 Feb 2023 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit f0c8ab1c36369d8d6aa214fba572dacefa3a8677:

  ioengines: clarify FIO_RO_NEEDS_RW_OPEN flag (2023-02-07 10:44:00 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0f85dc841d9220f3a0b45d0b104d5277ea962199:

  Merge branch 'Offload_Segfault_Write_Log' of https://github.com/horshack-dpreview/fio (2023-02-09 09:34:32 -0700)

----------------------------------------------------------------
Horshack (1):
      SIGSEGV / Exit 139 when write_iolog used with io_submit_mode=offload

Jens Axboe (1):
      Merge branch 'Offload_Segfault_Write_Log' of https://github.com/horshack-dpreview/fio

 rate-submit.c | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/rate-submit.c b/rate-submit.c
index 2fe768c0..3cc17eaa 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -154,6 +154,7 @@ static int io_workqueue_init_worker_fn(struct submit_worker *sw)
 	dup_files(td, parent);
 	td->eo = parent->eo;
 	fio_options_mem_dupe(td);
+	td->iolog_f = parent->iolog_f;
 
 	if (ioengine_load(td))
 		goto err;
