Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E913DC00140
	for <fio@archiver.kernel.org>; Wed, 10 Aug 2022 12:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiHJMAN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 10 Aug 2022 08:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiHJMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 10 Aug 2022 08:00:12 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D6483F06
        for <fio@vger.kernel.org>; Wed, 10 Aug 2022 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=0DqwcgF9dT15yP83PEFERimNJduUJ90h4oSypZ5XwcY=; b=HBp05bJ14pDKGPGhSEqLMYbXBw
        WyXCvesOfMsUWTOUPOOKtHJytWVs+A4vxdUWJkFS6suu0htU7O41qWrgAXbhtOrDd+796XSLsK4jS
        GFuPZhZP64DzxspJ2pXPAtWw1QGiGudYz9bjGonvwqLQr44HcKcNabQ59/b+B44DVZPlOpCzLNMgF
        zu5Ylzd0TjVYHBJBi+3+O7WScVp/aMjJ9EDmTH99l+lwBJQpW452K489vbUnhmqjvM3JK1x+vZjJp
        O3w3sydwgwteCM+WHbqYS2uLR42eCDDdaHRiu4izH4M+yrx+NFHrOiQXbFTSjhFC2MdntVxKBzLWA
        E8VPTmww==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oLkNZ-000prY-5Z
        for fio@vger.kernel.org; Wed, 10 Aug 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 5B5641BC016A; Wed, 10 Aug 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220810120002.5B5641BC016A@kernel.dk>
Date:   Wed, 10 Aug 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit de31fe9ab3dd6115cd0d5c77354f67f06595570d:

  testing: add test for slat + clat = tlat (2022-08-07 12:27:55 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6cafe8445fd1e04e5f7d67bbc73029a538d1b253:

  Fio 3.31 (2022-08-09 14:41:25 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'master' of ssh://git.kernel.dk/data/git/fio
      Fio 3.31

Vincent Fu (2):
      ci: upload tagged AppVeyor installers as GitHub releases
      ci: drop master branch requirement for AppVeyor releases

 .appveyor.yml   | 12 ++++++++++++
 FIO-VERSION-GEN |  2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/.appveyor.yml b/.appveyor.yml
index b94eefe3..92301ca9 100644
--- a/.appveyor.yml
+++ b/.appveyor.yml
@@ -50,5 +50,17 @@ after_build:
 test_script:
   - python.exe t/run-fio-tests.py --artifact-root test-artifacts --debug
 
+deploy:
+  - provider: GitHub
+    description: fio Windows installer
+    auth_token:                      # encrypted token from GitHub
+      secure: Tjj+xRQEV25P6dQgboUblTCKx/LtUOUav2bvzSCtwMhHMAxrrn2adod6nlTf0ItV
+    artifact: fio.msi                # upload installer to release assets
+    draft: false
+    prerelease: false
+    on:
+      APPVEYOR_REPO_TAG: true        # deploy on tag push only
+      DISTRO: cygwin
+
 on_finish:
   - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && [ -d test-artifacts ] && 7z a -t7z test-artifacts.7z test-artifacts -xr!foo.0.0 -xr!latency.?.0 -xr!fio_jsonplus_clat2csv.test && appveyor PushArtifact test-artifacts.7z'
diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index fa64f50f..72630dd0 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.30
+DEF_VER=fio-3.31
 
 LF='
 '
