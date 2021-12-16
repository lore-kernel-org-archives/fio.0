Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7298C433F5
	for <fio@archiver.kernel.org>; Thu, 16 Dec 2021 13:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhLPNAJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 16 Dec 2021 08:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbhLPNAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 16 Dec 2021 08:00:09 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C69C061574
        for <fio@vger.kernel.org>; Thu, 16 Dec 2021 05:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=JB1jt2oOtX48DfjTepj87uLHXfxm9Ckh9AteB3BYbFM=; b=TTcAzAPPJNq1RRQCnsUCrcwlIZ
        2P2How7mdhLYIFq+Ig29FA8VKe8I4TDU1G+53CRbsDabDGR8ynXtoeDqqX2gnVn48nauadFdMndNK
        dwHhwYznMjdeUijqNE/zc0+XYNBmsX1OBdLEZYaAPtlF9oc9Jt9eSaeyHrjbe+r9hkIo5qBypLGZE
        k4sDLEruG4yut0R3LutO/XkSRlSfKrCMOVCy3aWcNp9osfook24STyf1DrJ7quvI2H9tlvv9lpjd+
        2f/8ee95L3YbCpPKc7keLqxJzim4kzpc/YAyArBrQzsgGZlwC4A1e7T0/PceILfL9bXHjv8qsvPWT
        md7Yznfw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxqMf-001hES-QE
        for fio@vger.kernel.org; Thu, 16 Dec 2021 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 3E5EB1BC0130; Thu, 16 Dec 2021 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211216130002.3E5EB1BC0130@kernel.dk>
Date:   Thu, 16 Dec 2021 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 9ffe433d729101a34d9709030d7d4dd2444347ef:

  t/zbd: Avoid inappropriate blkzone command call in zone_cap_bs (2021-12-14 06:48:14 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e86afa536b175a90546e20d7d19f2418ee1bca78:

  stat: sum sync_stat before reassigning bool first (2021-12-15 08:45:32 -0700)

----------------------------------------------------------------
Niklas Cassel (1):
      stat: sum sync_stat before reassigning bool first

 stat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index 7e84058d..ec44c79e 100644
--- a/stat.c
+++ b/stat.c
@@ -2130,6 +2130,8 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 {
 	int k, l, m;
 
+	sum_stat(&dst->sync_stat, &src->sync_stat, first, false);
+
 	for (l = 0; l < DDIR_RWDIR_CNT; l++) {
 		if (!(dst->unified_rw_rep == UNIFIED_MIXED)) {
 			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], first, false);
@@ -2166,7 +2168,6 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 		}
 	}
 
-	sum_stat(&dst->sync_stat, &src->sync_stat, first, false);
 	dst->usr_time += src->usr_time;
 	dst->sys_time += src->sys_time;
 	dst->ctx += src->ctx;
