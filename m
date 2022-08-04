Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19899C19F2B
	for <fio@archiver.kernel.org>; Thu,  4 Aug 2022 12:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239562AbiHDMAJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 4 Aug 2022 08:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234188AbiHDMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 4 Aug 2022 08:00:08 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BA130579
        for <fio@vger.kernel.org>; Thu,  4 Aug 2022 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=j8X4CWuH61o7p3wPGUK4zYm1nsg+AoEqcc2fwviei10=; b=I0FKDRhBoPJ69JwKV/pcew3hKM
        Qenef5wmhJuEO7KgG9gwhOLyeRtItUWuOUL8v2HVYEGFRNVShntG+C2UvF2HSz9ZEUXMvSS8jryWv
        BfRP3tx8kFrcwQpaXPo4C0xrSqkjAlcl6H5Lx/Af0EGV3WlygRB1QPgnoCIkah0wTQm9+4e+FxCoi
        xkvcxYN9IbHmcS5uUJhxuFXbJdqmlhF2gLG++Y9kD9TXJt7xCj1BzHpqwEnUKYHLdliUIUZw5wuvk
        QUkaYRy11V5CVC+9tRQbqhBKxEDL11r8mOp6NlPu0cn0Jg2dkEwZY08aqmNP502R+117kNzE4VD5h
        WXC+yVEw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oJZWG-002zrE-KS
        for fio@vger.kernel.org; Thu, 04 Aug 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 4C6B21BC0138; Thu,  4 Aug 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220804120002.4C6B21BC0138@kernel.dk>
Date:   Thu,  4 Aug 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 7006d70c7c8b9a39cf3dfdd839d1975295c10527:

  Merge branch 'io_uring-numa' (2022-08-02 10:20:31 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c08f9533042e909d4b4b12fdb8d14f1bc8e23dff:

  filesetup: use correct random seed for non-uniform distributions (2022-08-03 16:18:53 -0400)

----------------------------------------------------------------
Vincent Fu (3):
      examples: fix ioengine in zbd-rand-write.fio
      engines/null: fill issue_time during commit
      filesetup: use correct random seed for non-uniform distributions

 engines/null.c              | 19 +++++++++++++++++++
 examples/zbd-rand-write.fio |  2 +-
 filesetup.c                 |  2 +-
 3 files changed, 21 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/engines/null.c b/engines/null.c
index 8dcd1b21..2df56718 100644
--- a/engines/null.c
+++ b/engines/null.c
@@ -44,9 +44,28 @@ static int null_getevents(struct null_data *nd, unsigned int min_events,
 	return ret;
 }
 
+static void null_queued(struct thread_data *td, struct null_data *nd)
+{
+	struct timespec now;
+
+	if (!fio_fill_issue_time(td))
+		return;
+
+	fio_gettime(&now, NULL);
+
+	for (int i = 0; i < nd->queued; i++) {
+		struct io_u *io_u = nd->io_us[i];
+
+		memcpy(&io_u->issue_time, &now, sizeof(now));
+		io_u_queued(td, io_u);
+	}
+}
+
 static int null_commit(struct thread_data *td, struct null_data *nd)
 {
 	if (!nd->events) {
+		null_queued(td, nd);
+
 #ifndef FIO_EXTERNAL_ENGINE
 		io_u_mark_submit(td, nd->queued);
 #endif
diff --git a/examples/zbd-rand-write.fio b/examples/zbd-rand-write.fio
index 46cddd06..9494a583 100644
--- a/examples/zbd-rand-write.fio
+++ b/examples/zbd-rand-write.fio
@@ -1,4 +1,4 @@
-; Using the libaio ioengine, random write to a (zoned) block device,
+; Using the psync ioengine, random write to a (zoned) block device,
 ; writing at most 32 zones at a time. Target zones are chosen randomly
 ; and writes directed at the write pointer of the chosen zones
 
diff --git a/filesetup.c b/filesetup.c
index e0592209..3e2ccf9b 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1495,7 +1495,7 @@ static void __init_rand_distribution(struct thread_data *td, struct fio_file *f)
 
 	seed = jhash(f->file_name, strlen(f->file_name), 0) * td->thread_number;
 	if (!td->o.rand_repeatable)
-		seed = td->rand_seeds[4];
+		seed = td->rand_seeds[FIO_RAND_BLOCK_OFF];
 
 	if (td->o.random_distribution == FIO_RAND_DIST_ZIPF)
 		zipf_init(&f->zipf, nranges, td->o.zipf_theta.u.f, td->o.random_center.u.f, seed);
