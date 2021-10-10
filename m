Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 605D1C433F5
	for <fio@archiver.kernel.org>; Sun, 10 Oct 2021 12:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4539060555
	for <fio@archiver.kernel.org>; Sun, 10 Oct 2021 12:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhJJMCk (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 10 Oct 2021 08:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbhJJMCk (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 10 Oct 2021 08:02:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1E9C061570
        for <fio@vger.kernel.org>; Sun, 10 Oct 2021 05:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=xs41FO87oz8pAbZUzcWQi7u838zPZFpK7wS797eX7bQ=; b=SI/s0IOv5Ed4vXwItbp+Nv0JTW
        wxif7jxk/KNbn+EH5Hpnk+zWqzZwNT1XLPkeDrgScsf5PeznzAWgE0QxYam7eSzQvn6iLwplf+UC+
        VyWxFEHa7gsJbLtFWW8mMacJwqXlicl3gJgtxtN+t4OATXTEUwdU9TA19pgobdKWTmuBq3Zcd+g0g
        5ouzXOxTHCsYJsCHGwuxlv77lFp0HJVGxpQMbP2jGKKpCzAEA4kPSyF48S73nhW0UYf6qQFq+piPc
        yKYmOvTA7rJg+/d5vmKwXL/SIGNPy+qIS7y/5x6dypDER+bEJMfEEwNjfP/BFHoymEJ2OK1RrrMmU
        idfk8dJQ==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mZXUs-004mv7-4A
        for fio@vger.kernel.org; Sun, 10 Oct 2021 12:00:16 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 218D51BC013F; Sun, 10 Oct 2021 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211010120002.218D51BC013F@kernel.dk>
Date:   Sun, 10 Oct 2021 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit b1ebcbce6499fed58f87d1bcbfd50899c508d3ab:

  Merge branch 'evelu-ocp' of https://github.com/ErwanAliasr1/fio (2021-10-07 06:18:21 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d4af2ecea2930138bbaf58fe84debef8e84761c6:

  t/io_uring: fix latency stats for depth == 1 (2021-10-09 12:56:11 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      t/io_uring: fix latency stats for depth == 1

 t/io_uring.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index 2c9fd08c..cdd15986 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -531,8 +531,8 @@ static int reap_events_uring(struct submitter *s)
 					stat_nr = 0;
 				}
 				last_idx = clock_index;
-			} else if (clock_index)
-				stat_nr++;
+			}
+			stat_nr++;
 		}
 		reaped++;
 		head++;
@@ -562,6 +562,8 @@ static int submitter_init(struct submitter *s)
 
 	if (stats) {
 		nr_batch = roundup_pow2(depth / batch_submit);
+		if (nr_batch < 2)
+			nr_batch = 2;
 		s->clock_batch = calloc(nr_batch, sizeof(unsigned long));
 		s->clock_index = 1;
 
@@ -637,8 +639,8 @@ static int reap_events_aio(struct submitter *s, struct io_event *events, int evs
 					stat_nr = 0;
 				}
 				last_idx = clock_index;
-			} else if (clock_index)
-				stat_nr++;
+			}
+			stat_nr++;
 		}
 		reaped++;
 		evs--;
