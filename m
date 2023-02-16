Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1EB5C636CC
	for <fio@archiver.kernel.org>; Thu, 16 Feb 2023 13:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjBPNAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 16 Feb 2023 08:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjBPNAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 16 Feb 2023 08:00:09 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38583D90B
        for <fio@vger.kernel.org>; Thu, 16 Feb 2023 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=p90eheqKpSnYZ5Y+mlSsjmAGdElIuFnac7ePfUVTJEw=; b=nn0EEwsbY48IjM+k+3TnutUOHu
        DNtgQ3O3ap/XFFvumujaVDMewaOH2x2XbImW8PlqAvFJ0gHqIYSLH7WYJPusd2KHLmiaNCJ1tp/5V
        I8sDg7bLM8HQnhXJw2nQ5n/xmtAMIkt2BTz1Vdx7kmaVx+v19g2zBoglDOqkOL4PuZUY6aZANRT1u
        GweA3s4Vuo6DcCMTeG+Z8zqNws3LkWS+3uk5cwHIBJ2Culjo26iCAEzRIN1ppXdmsx3ybEkN/YyYx
        yVoEMzY2OqvOdcyCqQbIg1xf9dvkKfir2yIpUt5eXxEfLvvq0cICPgcnW25l5+62wK3FGHXAqpSST
        Kz13oMXQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pSdro-008QU3-9z
        for fio@vger.kernel.org; Thu, 16 Feb 2023 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 5C1791BC016B; Thu, 16 Feb 2023 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230216130002.5C1791BC016B@kernel.dk>
Date:   Thu, 16 Feb 2023 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 1bd16cf9c113fcf9d49cae07da50e8a5c7a784ee:

  examples: update nbd.fio fiograph diagram (2023-02-14 10:47:50 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ded6cce8274ccf6f3820fb19ab46fd6d2aed0311:

  Merge branch 'Read_Stats_Not_Reported_For_Timed_Backlog_Verifies' of github.com:horshack-dpreview/fio (2023-02-15 12:49:31 -0500)

----------------------------------------------------------------
Horshack (1):
      Read stats for backlog verifies not reported for time-expired workloads

Vincent Fu (1):
      Merge branch 'Read_Stats_Not_Reported_For_Timed_Backlog_Verifies' of github.com:horshack-dpreview/fio

 backend.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index ffd34b36..0ccc7c2b 100644
--- a/backend.c
+++ b/backend.c
@@ -1919,7 +1919,8 @@ static void *thread_main(void *data)
 			}
 		} while (1);
 
-		if (td_read(td) && td->io_bytes[DDIR_READ])
+		if (td->io_bytes[DDIR_READ] && (td_read(td) ||
+			((td->flags & TD_F_VER_BACKLOG) && td_write(td))))
 			update_runtime(td, elapsed_us, DDIR_READ);
 		if (td_write(td) && td->io_bytes[DDIR_WRITE])
 			update_runtime(td, elapsed_us, DDIR_WRITE);
