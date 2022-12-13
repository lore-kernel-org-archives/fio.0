Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6114CC4332F
	for <fio@archiver.kernel.org>; Tue, 13 Dec 2022 13:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbiLMNAJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 13 Dec 2022 08:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbiLMNAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Dec 2022 08:00:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0217FE0F9
        for <fio@vger.kernel.org>; Tue, 13 Dec 2022 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=s99vZTD5RkcuDM8A2gbaPJ7yUKMAc3JPfubiFdluyOo=; b=hWUdtZhaVExIdqm2Fs7y0PuKMo
        W0T9VYQ/YdcG03rqsnjVP/6EkZD0EKp42W8PueLza8yeVJKvI8o9DnBQvULsEnvp3Lnoh3tQrKVpb
        pGcOp0eelaY73kDIcgRudve5hlKPji9fTsBC6CXeVlW712jL/0357mXe8zS16Lhq4wPG50yufotAq
        xhkgNgsv9dreMXWvvuGvXTXLh3VTn4YMUb9IDjrgnYeTy6sOsSN/74XAf9bLKe3MSnDQJSp7XNhXH
        f0xAOKV84Hll0jRHyJtDy2o3tuQ2g6gyI0h3NsjZYR2YJteX2Ze/iUVexZkhyCKC6lq07tdwUV//J
        7mMxKYdQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p54tJ-00CERD-PH
        for fio@vger.kernel.org; Tue, 13 Dec 2022 13:00:14 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 4BCFF1BC014D; Tue, 13 Dec 2022 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221213130002.4BCFF1BC014D@kernel.dk>
Date:   Tue, 13 Dec 2022 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 3afc2d8ac30c58372a1b7ccabaea0f3eae4ddaba:

  engines/libblkio: Share a single blkio instance among threads in same process (2022-12-02 16:24:03 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 70eb71e682b90078db6f361936933b88f71ad5fd:

  t/io_uring: adjust IORING_REGISTER_MAP_BUFFERS value (2022-12-12 16:58:32 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      t/io_uring: adjust IORING_REGISTER_MAP_BUFFERS value

 t/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index edbacee3..1ea0a9da 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -156,7 +156,7 @@ static float plist[] = { 1.0, 5.0, 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0,
 static int plist_len = 17;
 
 #ifndef IORING_REGISTER_MAP_BUFFERS
-#define IORING_REGISTER_MAP_BUFFERS	22
+#define IORING_REGISTER_MAP_BUFFERS	26
 struct io_uring_map_buffers {
 	__s32	fd;
 	__u32	buf_start;
