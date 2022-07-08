Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F36A6C433EF
	for <fio@archiver.kernel.org>; Fri,  8 Jul 2022 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237670AbiGHMAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 8 Jul 2022 08:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237612AbiGHMAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 8 Jul 2022 08:00:10 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E639A6B5
        for <fio@vger.kernel.org>; Fri,  8 Jul 2022 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=RShNJsRsGYoiJsPWPngs5Tsdsgp4ciTQ7vPYAmccAhA=; b=h2NyLduMh1iY4b9KUcjb7sWHNj
        2ftlXjQF9/o97u/LbTtwMPT0i970p+7Zu7LMa/yEeD/aJlXMSObl5HeJry+EJ/cuGlQMx0xQ/3nVL
        kV3uEYYwELkSGoZTI3OssBxLFKHIYZGIGptOvZwU/YjgEtRDZ3nsWIR9hYsHg4xk0qvW7uSBMmycM
        NAS4NdRrJ/vlVwIpndeCuLy2f6Bly29spGtpjdBy1SBHCVzbRk7SiC9TydDOAmU4ctGJvt5AHIJxo
        16i9WNCLM6us2FGbnRVdbJHizuoNJE0XGEEWq7jLGALaQEj+OOZbPpPo2XD5bovp8NF14eJQdLfPS
        U21mI8TQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o9meS-001iNe-O9
        for fio@vger.kernel.org; Fri, 08 Jul 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id C42AD1BC017F; Fri,  8 Jul 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220708120001.C42AD1BC017F@kernel.dk>
Date:   Fri,  8 Jul 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 1f43cc2e7b2f3ac7461f8ea66bb9b32cb03075c3:

  Merge branch 'server-hist-le64' of https://github.com/tuan-hoang1/fio (2022-07-06 16:38:07 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 30568e0ed9366a810dfcf90a903ecfbff1a6196c:

  Merge branch 'client-hist-le64' of https://github.com/tuan-hoang1/fio (2022-07-07 06:33:25 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'client-hist-le64' of https://github.com/tuan-hoang1/fio

Tuan Hoang (1):
      client: only do le64_to_cpu() on io_sample_data member if iolog is histogram

 client.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index 605a3ce5..37da74bc 100644
--- a/client.c
+++ b/client.c
@@ -1702,7 +1702,8 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 			s = (struct io_sample *)((char *)s + sizeof(struct io_u_plat_entry) * i);
 
 		s->time		= le64_to_cpu(s->time);
-		s->data.val	= le64_to_cpu(s->data.val);
+		if (ret->log_type != IO_LOG_TYPE_HIST)
+			s->data.val	= le64_to_cpu(s->data.val);
 		s->__ddir	= __le32_to_cpu(s->__ddir);
 		s->bs		= le64_to_cpu(s->bs);
 		s->priority	= le16_to_cpu(s->priority);
