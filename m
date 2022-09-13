Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 942F8C6FA82
	for <fio@archiver.kernel.org>; Tue, 13 Sep 2022 12:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiIMMAN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 13 Sep 2022 08:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiIMMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Sep 2022 08:00:12 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E822C15A23
        for <fio@vger.kernel.org>; Tue, 13 Sep 2022 05:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=UkGsC2wqJKyB0nIGoHoYLG8+p4hjBWUy95BZiYW44zY=; b=GcEeWSS+sbnBS0feluwo7K0oTo
        dI9lSVsjnSygjRFQwdH754zdz8fCa2tJIzOvLgcx7cWp8Ze8seMlnW16WLiNfvKT6x6jGy9pNT4Df
        qG5jjTSEy5s53eKJHBfI9aPwRTYXm0yRlnozosGZyOsuQifS0SxEHUUWGjtiVza2OQv0j/pTHSI5+
        H5LbYwu4W0D95E4h3kp/iwM4mHLgkVNzx7OFK1zdFkNJfoUP6OEclqij2sSOSVipdnY+iHA29CWN8
        dlZ6QVsVLKyLnVshGR9JaAOYznLY5UpB1Ed3hGzknNaGO6qj+VqG2kbJne2rHEcN+d1FucVan7Lyp
        RM6isknQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oY4aC-00C4Jl-Sc
        for fio@vger.kernel.org; Tue, 13 Sep 2022 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id D01531BC0147; Tue, 13 Sep 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220913120001.D01531BC0147@kernel.dk>
Date:   Tue, 13 Sep 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 10fc06dc4166ef7c69a6c06cb3a318878048f6be:

  Merge branch 'rpma-add-support-for-libpmem2-to-the-librpma-engine' of https://github.com/ldorau/fio (2022-09-06 06:58:48 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 53c82bb879532b994451c6abc7be80c94241d03b:

  stat: fix comment about memory consumption (2022-09-12 10:45:56 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      stat: fix comment about memory consumption

 stat.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/stat.h b/stat.h
index eb7845af..4c3bf71f 100644
--- a/stat.h
+++ b/stat.h
@@ -51,7 +51,7 @@ struct group_run_stats {
  *
  * FIO_IO_U_PLAT_GROUP_NR and FIO_IO_U_PLAT_BITS determine the memory
  * requirement of storing those aggregate counts. The memory used will
- * be (FIO_IO_U_PLAT_GROUP_NR * 2^FIO_IO_U_PLAT_BITS) * sizeof(int)
+ * be (FIO_IO_U_PLAT_GROUP_NR * 2^FIO_IO_U_PLAT_BITS) * sizeof(uint64_t)
  * bytes.
  *
  * FIO_IO_U_PLAT_NR is the total number of buckets.
