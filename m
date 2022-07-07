Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 802F6C433EF
	for <fio@archiver.kernel.org>; Thu,  7 Jul 2022 12:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbiGGMAn (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 7 Jul 2022 08:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235537AbiGGMA0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 7 Jul 2022 08:00:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F79564E7
        for <fio@vger.kernel.org>; Thu,  7 Jul 2022 05:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=+8rBlAAOlXPX4SJPnyhZnURg0FYRtV8ipEwVSXmGxxM=; b=M6+24wVWGQN8vGdYEM9faImMXk
        XkLV/hB8qhNZF5et6uTjA3+5BLfyGsMWlF05Wp9QUE4P/DrRWHU6BxDx8sUfOyEf49a6+ntdgJn3w
        Dy5MXFxnmE7q05jIxRdBrF88Ysk1qBTW/7g931OIcMo5X+4ANMjeKsCctisVgdyXtf93kDNY8AkQb
        uXY4yLBMhSBuqG3qUcEL2Pdt3yADjwZwTI2rW+R8b73/FPbJ7HcIsGmSz39rjZcQp7yU3non06eKB
        fPVXyr/Q9xkDggJb+mMI/OZjNSstaAT5/48U318+v7Y+ODCSoKY74/KHFYQjnkNMK2Zr0pBDszR/0
        G2ph2jTg==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o9QAw-002Y7G-Pb
        for fio@vger.kernel.org; Thu, 07 Jul 2022 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 7CCB01BC0124; Thu,  7 Jul 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220707120002.7CCB01BC0124@kernel.dk>
Date:   Thu,  7 Jul 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 1eb5ca76ee17ff80dd06a0c2d22498ab720ec76f:

  configure: revert NFS configure change (2022-07-05 07:19:39 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1f43cc2e7b2f3ac7461f8ea66bb9b32cb03075c3:

  Merge branch 'server-hist-le64' of https://github.com/tuan-hoang1/fio (2022-07-06 16:38:07 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'server-hist-le64' of https://github.com/tuan-hoang1/fio

Tuan Hoang (1):
      server: only do cpu_to_le64() on io_sample_data member if iolog is histogram

 server.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/server.c b/server.c
index 4c71bd44..b453be5f 100644
--- a/server.c
+++ b/server.c
@@ -2284,7 +2284,8 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 			struct io_sample *s = get_sample(log, cur_log, i);
 
 			s->time		= cpu_to_le64(s->time);
-			s->data.val	= cpu_to_le64(s->data.val);
+			if (log->log_type != IO_LOG_TYPE_HIST)
+				s->data.val	= cpu_to_le64(s->data.val);
 			s->__ddir	= __cpu_to_le32(s->__ddir);
 			s->bs		= cpu_to_le64(s->bs);
 
