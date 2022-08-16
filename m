Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98554C3F6B0
	for <fio@archiver.kernel.org>; Tue, 16 Aug 2022 12:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbiHPMIm (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 16 Aug 2022 08:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235430AbiHPMIB (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 16 Aug 2022 08:08:01 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E11EAB
        for <fio@vger.kernel.org>; Tue, 16 Aug 2022 05:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=58TQI3dRCp6ETPEcoE3iGNyXKl/3+Ffu7PsZMOoDUSY=; b=hNnb1oybBfqMw8DWcofVM8mdzt
        6HNERPG0CwUimmkeFGb65CiGNY9cY5ZOCmsGEvaAUtjU8Mzqfkgfas5HsA20eSQ/yZopv+rKuQt/r
        KU68chpDStGshrvA4J498cPdWBRFk8RHAzwr2NdFZFFCHvLW/zZbE2w4nro7ZZieV96GmyP4/mi2h
        324s9eIDTDOb0qz/6diSDTBIthDwxvXhA+qf6809Jv9UEgAYVrpUVBNi6jopAfcnqOPDRPYrWx1ep
        Nh+Kw0+cOoPEDcmxiSTn62iy6prCG/u1pw8pQqDHJxjI2EI5oOcfbHPCjo+AitiE9cF4pJBxWMFrc
        Y85qRTVw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oNvEr-002wzu-I9
        for fio@vger.kernel.org; Tue, 16 Aug 2022 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 68B021BC0158; Tue, 16 Aug 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220816120002.68B021BC0158@kernel.dk>
Date:   Tue, 16 Aug 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 7a7bcae0610d872951bc22dc310105c7ec1157af:

  Merge branch 's3_crypto' of github.com:hualongfeng/fio (2022-08-11 15:39:02 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to eeb302f9bfa4bbe121cae2a12a679c888164fc93:

  README: link to GitHub releases for Windows (2022-08-15 10:37:57 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      README: link to GitHub releases for Windows

 README.rst | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/README.rst b/README.rst
index 67420903..79582dea 100644
--- a/README.rst
+++ b/README.rst
@@ -123,10 +123,12 @@ Solaris:
 	``pkgutil -i fio``.
 
 Windows:
-	Rebecca Cran <rebecca@bsdio.com> has fio packages for Windows at
-	https://bsdio.com/fio/ . The latest builds for Windows can also
-	be grabbed from https://ci.appveyor.com/project/axboe/fio by clicking
-	the latest x86 or x64 build, then selecting the ARTIFACTS tab.
+        Beginning with fio 3.31 Windows installers are available on GitHub at
+        https://github.com/axboe/fio/releases.  Rebecca Cran
+        <rebecca@bsdio.com> has fio packages for Windows at
+        https://bsdio.com/fio/ . The latest builds for Windows can also be
+        grabbed from https://ci.appveyor.com/project/axboe/fio by clicking the
+        latest x86 or x64 build and then selecting the Artifacts tab.
 
 BSDs:
 	Packages for BSDs may be available from their binary package repositories.
