Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D073C433EF
	for <fio@archiver.kernel.org>; Fri, 25 Mar 2022 12:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245628AbiCYMBo (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 25 Mar 2022 08:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346373AbiCYMBn (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 25 Mar 2022 08:01:43 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4388532ED5
        for <fio@vger.kernel.org>; Fri, 25 Mar 2022 05:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=kLjdXBu9nS4xber+hG8wXDEbWZJHeQTveGSWJJXEddg=; b=H6JgXrQ8a+jfZ0smr4vVhf6F5y
        gdI+nTK5Qp4ufaYqWsH0+P1yA5wvx2QidWkTX5MSsEef9VyLTIfKEuiUUkPXIT1U1z4x4/Ke/lxjk
        V4639MxzCFi/VyrLbKvcMCw+D+4Ayo+zi71m+Diq/wV3aIOWZl1+UwL4q/0hWDmFkv2Ue8z4eGq1O
        xnSCwLyjx3lELAdeccQ2rEHU1dwcrCukD4rWyw0rHOrTYWO69Z5vLBoiPX9RJFgt0sLy3kca/KEkN
        BQvQAjv6Yrx6xzgYXgALyqrdcgBTC6tsGNNEeXnR3c/UcURTXaOW2EfVx9Qx5NZw069Yx8z0VFEl8
        pz7XXInw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nXibt-004Mew-Kk
        for fio@vger.kernel.org; Fri, 25 Mar 2022 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 3D9311BC0130; Fri, 25 Mar 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220325120002.3D9311BC0130@kernel.dk>
Date:   Fri, 25 Mar 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit c822572d68e326384ce179b9484de0e4abf3d514:

  engines/null: use correct -include (2022-03-20 09:31:20 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e3de2e7fe2889942d46699e72ac06b96eab09e27:

  Merge branch 'github-1372' of https://github.com/vincentkfu/fio (2022-03-24 10:11:34 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'github-1372' of https://github.com/vincentkfu/fio

Vincent Fu (1):
      io_u: produce bad offsets for some time_based jobs

 io_u.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index 806ceb77..50197a4b 100644
--- a/io_u.c
+++ b/io_u.c
@@ -355,7 +355,7 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 	 * and invalidate the cache, if we need to.
 	 */
 	if (f->last_pos[ddir] >= f->io_size + get_start_offset(td, f) &&
-	    o->time_based) {
+	    o->time_based && o->nr_files == 1) {
 		f->last_pos[ddir] = f->file_offset;
 		loop_cache_invalidate(td, f);
 	}
