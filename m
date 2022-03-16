Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACBBCC433F5
	for <fio@archiver.kernel.org>; Wed, 16 Mar 2022 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348461AbiCPMBX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 16 Mar 2022 08:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345168AbiCPMBX (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 16 Mar 2022 08:01:23 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6570A63BF6
        for <fio@vger.kernel.org>; Wed, 16 Mar 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=b5YayuXgN22CXV2oTCANt0mL6CqmNsH/SI/6mefAUBs=; b=eK75/oBr6PNdMOqgOoLjjZCdtD
        ta69LjfJiZK53+AWPWmoI8uBMBBXaC1mGG7TJlkC+dWlhx6WNv9J9IHFNsZkUgLAdmQTrAxBRt8sf
        6/Z0GlI+B+kFc+cZRQYFu3nMjUafcH3owQXTUcNqoENgsZdHT95oFegxXk67pvffZfVH4GeBbs3bv
        Iv/X586gjlMCiQuo/lvGISqDV1iByoZmq7Ye8t2UvuJ+ze6MotvZNBJvuW4Yj8FANN1wyxqKKm7/Q
        JrZw/fqU4wCWu/XSmvJ7jer5ZTfs+anhX5vkyyYXKrtN8VVi49G3YtS3RfYPuzGylsbOn8asUmBne
        Uqt95caw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nUSJw-001XG6-IA
        for fio@vger.kernel.org; Wed, 16 Mar 2022 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 0D5881BC0175; Wed, 16 Mar 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220316120002.0D5881BC0175@kernel.dk>
Date:   Wed, 16 Mar 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 1fe261a24794f60bf374cd1852e09ec56997a20a:

  t/dedupe: ensure that 'ret' is initialized (2022-03-11 06:15:53 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1953e1adb5a28ed21370e85991d7f5c3cdc699f3:

  Merge branch 'flags-fix' of https://github.com/albertofaria/fio (2022-03-15 17:21:41 -0600)

----------------------------------------------------------------
Alberto Faria (1):
      Properly encode engine flags in thread_data::flags

Jens Axboe (1):
      Merge branch 'flags-fix' of https://github.com/albertofaria/fio

 fio.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/fio.h b/fio.h
index c314f0a8..776fb51f 100644
--- a/fio.h
+++ b/fio.h
@@ -184,7 +184,7 @@ struct zone_split_index {
  */
 struct thread_data {
 	struct flist_head opt_list;
-	unsigned long flags;
+	unsigned long long flags;
 	struct thread_options o;
 	void *eo;
 	pthread_t thread;
@@ -681,12 +681,12 @@ enum {
 };
 
 #define TD_ENG_FLAG_SHIFT	18
-#define TD_ENG_FLAG_MASK	((1U << 18) - 1)
+#define TD_ENG_FLAG_MASK	((1ULL << 18) - 1)
 
 static inline void td_set_ioengine_flags(struct thread_data *td)
 {
 	td->flags = (~(TD_ENG_FLAG_MASK << TD_ENG_FLAG_SHIFT) & td->flags) |
-		    (td->io_ops->flags << TD_ENG_FLAG_SHIFT);
+		    ((unsigned long long)td->io_ops->flags << TD_ENG_FLAG_SHIFT);
 }
 
 static inline bool td_ioengine_flagged(struct thread_data *td,
