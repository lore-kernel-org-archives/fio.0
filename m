Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053E1C433FE
	for <fio@archiver.kernel.org>; Sat, 15 Oct 2022 12:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiJOMAN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 15 Oct 2022 08:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiJOMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 15 Oct 2022 08:00:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5E62BB25
        for <fio@vger.kernel.org>; Sat, 15 Oct 2022 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=NgIpMlyGXEZgDJGPgI4Fvgw9cPU8iDs1IXnZaEWV7K8=; b=XEFTYYyc8j7lMbs20tn5vvt/08
        IGa0qKRdSX/QuxF0tOKVqOwhU+ytv4CEvDFi1MNAOlxgY/xSw+NWsJK7LKGVZo8LhR4PUraTb4U3s
        cA4Jfnj7y8H+kuLstVN3zhfR4NzHGpXbi3Db2OxMu6HkB3A5l9vJ7RV1+4Fv5zie0kSqFaqWozH1p
        NmhHx56i70n6AGrdXlWtS08yAmSf8MysosoPaaxDnAVovsnrgRfvw74GUIIB8JJEXgXo3J4IL77DM
        ul+Wroer6785ky3WC/O0eocIkvudr8vMsiwzsNznwKyw1GIE1kagL6/ZvFVRUxTPF/so77EAZbzus
        oEFJDE4g==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ojfpq-008MMn-3u
        for fio@vger.kernel.org; Sat, 15 Oct 2022 12:00:10 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 42AA11BC016F; Sat, 15 Oct 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221015120002.42AA11BC016F@kernel.dk>
Date:   Sat, 15 Oct 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit b19c5ee1357ffb74f4de57b1617364bbbaacf1a0:

  examples: uring-cmd-zoned: expand the reasoning behind QD1 (2022-10-07 09:50:37 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 07f78c37833730594778fb5684ac6ec40d0289f8:

  engines/io_uring: set coop taskrun, single issuer and defer taskrun (2022-10-12 07:19:35 -0600)

----------------------------------------------------------------
Ankit Kumar (1):
      engines/io_uring: set coop taskrun, single issuer and defer taskrun

 engines/io_uring.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index c679177f..6906e0a4 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -889,9 +889,30 @@ static int fio_ioring_cmd_queue_init(struct thread_data *td)
 	p.flags |= IORING_SETUP_CQSIZE;
 	p.cq_entries = depth;
 
+	/*
+	 * Setup COOP_TASKRUN as we don't need to get IPI interrupted for
+	 * completing IO operations.
+	 */
+	p.flags |= IORING_SETUP_COOP_TASKRUN;
+
+	/*
+	 * io_uring is always a single issuer, and we can defer task_work
+	 * runs until we reap events.
+	 */
+	p.flags |= IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN;
+
 retry:
 	ret = syscall(__NR_io_uring_setup, depth, &p);
 	if (ret < 0) {
+		if (errno == EINVAL && p.flags & IORING_SETUP_DEFER_TASKRUN) {
+			p.flags &= ~IORING_SETUP_DEFER_TASKRUN;
+			p.flags &= ~IORING_SETUP_SINGLE_ISSUER;
+			goto retry;
+		}
+		if (errno == EINVAL && p.flags & IORING_SETUP_COOP_TASKRUN) {
+			p.flags &= ~IORING_SETUP_COOP_TASKRUN;
+			goto retry;
+		}
 		if (errno == EINVAL && p.flags & IORING_SETUP_CQSIZE) {
 			p.flags &= ~IORING_SETUP_CQSIZE;
 			goto retry;
