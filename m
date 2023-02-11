Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47767C636CC
	for <fio@archiver.kernel.org>; Sat, 11 Feb 2023 13:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjBKNAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 11 Feb 2023 08:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBKNAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 11 Feb 2023 08:00:09 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F41A199D8
        for <fio@vger.kernel.org>; Sat, 11 Feb 2023 05:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=20MrAbKbvsJue7+BCcYisKE90jBMSD1HhIqO/GSJC+E=; b=mEz5R8Iv76RTpN5bbVgJLclx03
        iBFMHtpXUs2RYBXlUUn+j0G2CxbjwhfVP33LoxD6PNChr3dCNLp3CiDNAFJ4rhmOGXqh1LTTO8iGN
        II0ZWTvKF5pRIKYSFpXGBfvM0Eikhteq94yrU4Y829Y7GCuM0bN07XsVUTU6Fd9h+nWObBnf3q+UF
        gdkTOCRTqcPQjQsgrRDmOsdrIyrFNxXH+LqW9CQ2/Zg9P2Nf9B8o6UNwzw1WnYh74E+NXFsA7t96w
        TwMh1VMXluQ0837aLYKQGoS1mfezCLEYni+d4Qktu0T/2AOBZ0Cl6RI0/byhyQJkrYiLWDLO3+r6V
        yhzUgKpQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pQpTQ-008ZQn-1V
        for fio@vger.kernel.org;
        Sat, 11 Feb 2023 12:59:25 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id DD1571BC0183; Sat, 11 Feb 2023 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230211130001.DD1571BC0183@kernel.dk>
Date:   Sat, 11 Feb 2023 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 0f85dc841d9220f3a0b45d0b104d5277ea962199:

  Merge branch 'Offload_Segfault_Write_Log' of https://github.com/horshack-dpreview/fio (2023-02-09 09:34:32 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b65023f3c8849e122b2a223838ae9fdaed994e84:

  Merge branch 'msg-Modify_QD_Sync_Warning_For_offload' of https://github.com/horshack-dpreview/fio (2023-02-10 11:49:46 -0500)

----------------------------------------------------------------
Horshack (1):
      Suppress sync engine QD > 1 warning if io_submit_mode is offload

Vincent Fu (1):
      Merge branch 'msg-Modify_QD_Sync_Warning_For_offload' of https://github.com/horshack-dpreview/fio

 backend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 928e524a..ffd34b36 100644
--- a/backend.c
+++ b/backend.c
@@ -1796,7 +1796,7 @@ static void *thread_main(void *data)
 	if (td_io_init(td))
 		goto err;
 
-	if (td_ioengine_flagged(td, FIO_SYNCIO) && td->o.iodepth > 1) {
+	if (td_ioengine_flagged(td, FIO_SYNCIO) && td->o.iodepth > 1 && td->o.io_submit_mode != IO_MODE_OFFLOAD) {
 		log_info("note: both iodepth >= 1 and synchronous I/O engine "
 			 "are selected, queue depth will be capped at 1\n");
 	}
