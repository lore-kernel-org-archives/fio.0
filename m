Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB232C00144
	for <fio@archiver.kernel.org>; Mon,  1 Aug 2022 12:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbiHAMUg (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 1 Aug 2022 08:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234740AbiHAMT6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 1 Aug 2022 08:19:58 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E9EE71
        for <fio@vger.kernel.org>; Mon,  1 Aug 2022 05:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=ibJyg9SQE92Gzms18k22RSqzZ7TkvfGfjIkc8P1zfRw=; b=godWN4oh+HlGUCTJnSws49zKEa
        hDRqGGJgkD1aS12CNxigk2AV+lIJfc/mt0XiJj2w5f2YgSmy5hgj2HkQ1DLIqrp0nNHu25uz+8kMH
        HCO3o3+84WXZ3qK1GuvkvdSXPIOLJhJT9o044Ni/7qGNKksM2J8nCJLBIjBeZl4e8Yi17o2mGd5od
        aH79JOoUMSxttkapQ6GM83LsXhuq7aNTh7+k7X6DBxhybB06DHgHngwRwlLBYB2xwLyKCMKqcxMXY
        EUVGaAMjCYhuWtZBcmjOn6HIMV8pbe0Mk7NM81FJ5ncaDQjKXjBL+B0zz1hv0oOp4DHyxdAgobkzr
        xQPpL0lw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oIU5d-002OSY-L6
        for fio@vger.kernel.org; Mon, 01 Aug 2022 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 515311BC0133; Mon,  1 Aug 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220801120002.515311BC0133@kernel.dk>
Date:   Mon,  1 Aug 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 3e1d3f2fc4a5f09174f0d6d70d036285d69f17c2:

  .github: add pull request template (2022-07-28 11:00:04 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 55037c4839c65612fa388ae937e63661d8192ed9:

  t/io_uring: switch to GiB/sec if numbers get large (2022-07-31 12:06:12 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      t/io_uring: switch to GiB/sec if numbers get large

 t/io_uring.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index 10035912..335a06ed 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -1546,8 +1546,15 @@ int main(int argc, char *argv[])
 		else
 			printf("IOPS=%lu, ", iops);
 		max_iops = max(max_iops, iops);
-		if (!do_nop)
-			printf("BW=%luMiB/s, ", bw);
+		if (!do_nop) {
+			if (bw > 2000) {
+				double bw_g = (double) bw / 1000.0;
+
+				printf("BW=%.2fGiB/s, ", bw_g);
+			} else {
+				printf("BW=%luMiB/s, ", bw);
+			}
+		}
 		printf("IOS/call=%ld/%ld, inflight=(%s)\n", rpc, ipc, fdepths);
 		done = this_done;
 		calls = this_call;
