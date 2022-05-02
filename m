Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4169FC433EF
	for <fio@archiver.kernel.org>; Mon,  2 May 2022 12:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351579AbiEBMDi (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 2 May 2022 08:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbiEBMDi (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 2 May 2022 08:03:38 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E848D1B796
        for <fio@vger.kernel.org>; Mon,  2 May 2022 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=1enf5CpdOequEt5xjT0/MIAkeEJWoOj2XzoIG6FTSyo=; b=h4a6M0zfcMAtYUI5zeGrqH92ZN
        WG1EJCYGeq/Ppy+L2BadxBNITzPLVHTdh5R/TYk3NllGnvlEsDur16e91kfdGuDWxj0RWWAJJvOB7
        GhUE3mRU0OPxgQbiSx/ggmyEr04QiSfrOP4u1G9evcJVuK/vDBtDtMvgEOkKGL8ZrwZEUWARGr6lA
        8Mj3066CN7ESLSfb9uyFNou3isuZCSsU/sASB9NhqJaE6SN1Nhw2nLwwF/QDCEVCh8NXbEtnReoeA
        BVdt3VC0KIQsKb27JBcKoRDyZZNDLlFufu13uFopZB9b9DbC8ei90KhVvijCmV5TqXBIlkt0pEKI8
        +Z8qa9Hw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nlUik-00ARxP-Ff
        for fio@vger.kernel.org; Mon, 02 May 2022 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 49F431BC0132; Mon,  2 May 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220502120002.49F431BC0132@kernel.dk>
Date:   Mon,  2 May 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 6e594a2fa8388892dffb2ffc9b865689e2d67833:

  Merge branch 'global_dedup' of https://github.com/bardavid/fio (2022-04-29 16:30:50 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 12db6deb8b767ac89dd73e34dbc6f06905441e07:

  Merge branch 'patch-1' of https://github.com/ferdnyc/fio (2022-05-01 07:29:05 -0600)

----------------------------------------------------------------
Frank Dana (1):
      README: Update Fedora pkg URL

Jens Axboe (1):
      Merge branch 'patch-1' of https://github.com/ferdnyc/fio

 README.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/README.rst b/README.rst
index d566fae3..527f33ab 100644
--- a/README.rst
+++ b/README.rst
@@ -107,7 +107,7 @@ Ubuntu:
 Red Hat, Fedora, CentOS & Co:
 	Starting with Fedora 9/Extra Packages for Enterprise Linux 4, fio
 	packages are part of the Fedora/EPEL repositories.
-	https://apps.fedoraproject.org/packages/fio .
+	https://packages.fedoraproject.org/pkgs/fio/ .
 
 Mandriva:
 	Mandriva has integrated fio into their package repository, so installing
