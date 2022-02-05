Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A72B9C433F5
	for <fio@archiver.kernel.org>; Sat,  5 Feb 2022 13:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379933AbiBENAQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 5 Feb 2022 08:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355661AbiBENAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 5 Feb 2022 08:00:12 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE40C061346
        for <fio@vger.kernel.org>; Sat,  5 Feb 2022 05:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=FZ4A0meMIU5H0gzUEYx3a1FS50+J/S2ZFiD0RUCogAE=; b=Ic3H6BOdquIJlhAWAN/zO9tvn0
        nqW494uUZF2vo3o9Um1IoC1tGtOn/cQ6AvW5dw8WeatZc48DKHskWpf4bAbQ51nixXfZPSCu4Cc8M
        66daqn7RFLeOd9dK377xwWi8u8BgdvQjxj3oW81BJS5UM1imbCDXyw/CqnyqXOj8b8d2g2LkQDIS9
        dqF0RYYPZrjgeLN3DfR2bw4UXqEnc1adch7VS/UfzmvtRWWumr0tom6zT0DfPuIIa0rGOIoGSxUIN
        ToP37c9VFKg6WsSiiEVXdaHSDtUneCncXCecb8CVXlzES4dA/qPUjnzQsNTwTkNkhWsy2LrBQImuy
        JBiJ7/oQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nGKfd-00783J-85
        for fio@vger.kernel.org; Sat, 05 Feb 2022 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 46CB31BC017B; Sat,  5 Feb 2022 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220205130002.46CB31BC017B@kernel.dk>
Date:   Sat,  5 Feb 2022 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 62e9ece4d540ff2af865e4b43811f3150b8b846b:

  fio: use correct function declaration for set_epoch_time() (2022-02-03 16:06:59 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b65c1fc07d4794920224312c56c785de2f3f1692:

  t/io_uring: fix warnings for !ARCH_HAVE_CPU_CLOCK (2022-02-04 09:02:49 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      t/io_uring: fix warnings for !ARCH_HAVE_CPU_CLOCK

Niklas Cassel (1):
      stat: make free_clat_prio_stats() safe against NULL

 stat.c       |  3 +++
 t/io_uring.c | 11 ++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index 0876222a..1764eebc 100644
--- a/stat.c
+++ b/stat.c
@@ -2041,6 +2041,9 @@ void free_clat_prio_stats(struct thread_stat *ts)
 {
 	enum fio_ddir ddir;
 
+	if (!ts)
+		return;
+
 	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 		sfree(ts->clat_prio[ddir]);
 		ts->clat_prio[ddir] = NULL;
diff --git a/t/io_uring.c b/t/io_uring.c
index e8365a79..faf5978c 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -287,6 +287,7 @@ out:
 	free(ovals);
 }
 
+#ifdef ARCH_HAVE_CPU_CLOCK
 static unsigned int plat_val_to_idx(unsigned long val)
 {
 	unsigned int msb, error_bits, base, offset, idx;
@@ -322,6 +323,7 @@ static unsigned int plat_val_to_idx(unsigned long val)
 
 	return idx;
 }
+#endif
 
 static void add_stat(struct submitter *s, int clock_index, int nr)
 {
@@ -789,9 +791,12 @@ static void *submitter_uring_fn(void *data)
 {
 	struct submitter *s = data;
 	struct io_sq_ring *ring = &s->sq_ring;
-	int ret, prepped, nr_batch;
-
-	nr_batch = submitter_init(s);
+	int ret, prepped;
+#ifdef ARCH_HAVE_CPU_CLOCK
+	int nr_batch = submitter_init(s);
+#else
+	submitter_init(s);
+#endif
 
 	prepped = 0;
 	do {
