Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0378C433EF
	for <fio@archiver.kernel.org>; Tue, 12 Oct 2021 12:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD41461074
	for <fio@archiver.kernel.org>; Tue, 12 Oct 2021 12:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236288AbhJLMDY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 12 Oct 2021 08:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbhJLMDX (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 12 Oct 2021 08:03:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F77C061570
        for <fio@vger.kernel.org>; Tue, 12 Oct 2021 05:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=0kFVdwuC6zzZ5+JGmu8eb0H4IGPlPhmzhAnxpJve/gE=; b=Und1LIp68BqcQhyZHzORVohO1R
        YZeQnHROXD3YQlUXmSFe0Ipx/9JH/rmCCP7KGjZ2i/Tm4xZH7izYP5ilfdT11T92qxg8CKCar7JkC
        QjMCjKACPR1QqHLL1QWEQm5vTzNPjQ570eVatneJhxtWV40ZA6ZJQbIGY2y7xr31xWzEE3V7iMZEL
        DxDZvDdKgVkuT1S665eh3f7RKkcAhV8LUZm7cwc97DyDZ3m0wIxrky/fUbto56EllDC9szBFo9yVE
        PUIJWBCeJeEfxGld2GAtIx2BQ+o5Fl9GQbY8xpXljF2T1x8QRMYWn4/+ZV2hgDN+uQTsmD4I5lGU6
        OzNLUNYA==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1maGRx-006TdZ-75
        for fio@vger.kernel.org; Tue, 12 Oct 2021 12:00:25 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 59C1F1BC0119; Tue, 12 Oct 2021 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211012120002.59C1F1BC0119@kernel.dk>
Date:   Tue, 12 Oct 2021 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit d4af2ecea2930138bbaf58fe84debef8e84761c6:

  t/io_uring: fix latency stats for depth == 1 (2021-10-09 12:56:11 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c4cb947e8f92c10835164b67deed06828cfc01be:

  io_u: don't attempt to requeue for full residual (2021-10-11 09:49:21 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      io_u: don't attempt to requeue for full residual

 io_u.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index 5289b5d1..586a4bef 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2004,7 +2004,7 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 		 * Make sure we notice short IO from here, and requeue them
 		 * appropriately!
 		 */
-		if (io_u->resid) {
+		if (bytes && io_u->resid) {
 			io_u->xfer_buflen = io_u->resid;
 			io_u->xfer_buf += bytes;
 			io_u->offset += bytes;
