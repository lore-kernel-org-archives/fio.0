Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C6CC433F5
	for <fio@archiver.kernel.org>; Fri, 15 Oct 2021 12:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ED5460C51
	for <fio@archiver.kernel.org>; Fri, 15 Oct 2021 12:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235393AbhJOMDY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 15 Oct 2021 08:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235290AbhJOMDW (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 15 Oct 2021 08:03:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C263C061570
        for <fio@vger.kernel.org>; Fri, 15 Oct 2021 05:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=gM8R0FvDeGPw5sTvy1egiDkZWM2Ori0+bndj6s1UQVc=; b=Hih83M6WaDoXj6fhAsYTGr95/h
        LDcb3xy/qUJ8j8DWNGWXCnMLOMCYC/MvUt3OVOLHmg7YRQOLCM8MGC0MnIOVTI9QC8OakdQfCBSsI
        7p0sRYaOxUtQhGuexPEeP2clNnp221RQnVO6/1+g7SoD/b9rL4wakN+Gb2AlhNaONiHyfvr4GVN/V
        pge7xH49AT3pCHY6/t6UxYzcP3dSZaZ86oCQgqEGn3PDOwfGLGe5IZiRPAc9on/5ZMF+JQ+GQRLgB
        AWX1uHaOqUd9D8g17Aw71yXCANqXM1sBAQ9Bu8Tyts6KxhIEcTQei4uifChQ+ul88GlcFzbCPxC2S
        PsiEG9ig==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mbLsZ-00901Q-Fd
        for fio@vger.kernel.org; Fri, 15 Oct 2021 12:00:18 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id B74DC1BC016C; Fri, 15 Oct 2021 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211015120001.B74DC1BC016C@kernel.dk>
Date:   Fri, 15 Oct 2021 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 53b5fa1ea4f821899440637ab632ce0e1687c916:

  t/io_uring: don't append 'K' to IOPS if we don't divide by 1000 (2021-10-13 06:17:44 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 246054544cc74b56b063640ecb538893ea613936:

  Merge branch 'evelu-typo' of https://github.com/ErwanAliasr1/fio (2021-10-14 15:01:30 -0600)

----------------------------------------------------------------
Erwan Velu (1):
      t/io_uring: Fixing typo

Jens Axboe (2):
      t/io_uring: include a maximum IOPS seen when exiting
      Merge branch 'evelu-typo' of https://github.com/ErwanAliasr1/fio

 t/io_uring.c | 6 ++++++
 1 file changed, 6 insertions(+)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index 1b729ebf..5a80e074 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -103,6 +103,7 @@ struct submitter {
 static struct submitter *submitter;
 static volatile int finish;
 static int stats_running;
+static unsigned long max_iops;
 
 static int depth = DEPTH;
 static int batch_submit = BATCH_SUBMIT;
@@ -882,6 +883,10 @@ static void do_finish(const char *reason)
 		struct submitter *s = get_submitter(j);
 		s->finish = 1;
 	}
+	if (max_iops > 100000)
+		printf("Maximum IOPS=%luK\n", max_iops / 1000);
+	else if (max_iops)
+		printf("Maximum IOPS=%lu\n", max_iops);
 	finish = 1;
 }
 
@@ -1362,6 +1367,7 @@ int main(int argc, char *argv[])
 			printf("IOPS=%luK, ", iops / 1000);
 		else
 			printf("IOPS=%lu, ", iops);
+		max_iops = max(max_iops, iops);
 		if (!do_nop)
 			printf("BW=%luMiB/s, ", bw);
 		printf("IOS/call=%ld/%ld, inflight=(%s)\n", rpc, ipc, fdepths);
