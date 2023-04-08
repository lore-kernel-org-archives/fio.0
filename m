Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C48C7619A
	for <fio@archiver.kernel.org>; Sat,  8 Apr 2023 12:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjDHMAI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 8 Apr 2023 08:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjDHMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 8 Apr 2023 08:00:08 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559DBD524
        for <fio@vger.kernel.org>; Sat,  8 Apr 2023 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=eUzdDMcDRP23xpU60O0Dryi6ouQ3mSaLHWWzNurGCCY=; b=ZkuQenUflOaOXoYvZfKUjeMpH1
        RHWKPOZ9oONIhnW5IU+yfep7Otg5nQEOQW5D97bJ56v9TP3O+AvRL9wulNSeNLHVZoq9dmNdZyAB4
        keUdhN9I+UuJIoVu/LOwm3/kzEjIdqBrC75C2wsNT12qgBtXOjOQYyxNr3AhKHSlUiJcsbytLCuR5
        hI6TcchXBMbkzJRleb7WO2h/8siqNQOimCKJBKVqYGYO3R7ZOg3hRGuJGes8rvWqWY1rGL760rUgO
        LpYk8+Y34uUnTIl9LSnkCFHnwZROVTrIe7E0NNAy30w1b/+UrHwJYxTUIpi+6GT3ieojKu01JznEV
        fEA2Ie0w==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pl7Eh-00BPaS-3D
        for fio@vger.kernel.org;
        Sat, 08 Apr 2023 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id CAD4F1BC0155; Sat,  8 Apr 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230408120001.CAD4F1BC0155@kernel.dk>
Date:   Sat,  8 Apr 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 2d8c2709dc067aabdeab8bc1eea1992d9d802375:

  io_u: fix bad style (2023-04-04 09:49:19 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2bb86015831c3ef3f8a077f417ad79ed6998ed48:

  Merge branch 'libaio-hang' of https://github.com/lrumancik/fio (2023-04-07 16:42:07 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'libaio-hang' of https://github.com/lrumancik/fio

Leah Rumancik (1):
      engines/libaio: fix io_getevents min/max events arguments

 engines/libaio.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/engines/libaio.c b/engines/libaio.c
index 33b8c12f..1b82c90b 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -288,14 +288,16 @@ static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
 		    && actual_min == 0
 		    && ((struct aio_ring *)(ld->aio_ctx))->magic
 				== AIO_RING_MAGIC) {
-			r = user_io_getevents(ld->aio_ctx, max,
+			r = user_io_getevents(ld->aio_ctx, max - events,
 				ld->aio_events + events);
 		} else {
 			r = io_getevents(ld->aio_ctx, actual_min,
-				max, ld->aio_events + events, lt);
+				max - events, ld->aio_events + events, lt);
 		}
-		if (r > 0)
+		if (r > 0) {
 			events += r;
+			actual_min = actual_min > events ? actual_min - events : 0;
+		}
 		else if ((min && r == 0) || r == -EAGAIN) {
 			fio_libaio_commit(td);
 			if (actual_min)
