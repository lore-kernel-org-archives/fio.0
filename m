Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA517C77B7F
	for <fio@archiver.kernel.org>; Fri, 19 May 2023 12:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjESMAO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 19 May 2023 08:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjESMAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 19 May 2023 08:00:13 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7199DE50
        for <fio@vger.kernel.org>; Fri, 19 May 2023 05:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=wmJZlpqo7G5FmbAi0lxuuaHcDFVWOayWMwe+zkrJkAU=; b=nubIHoRB9WN7wmu+30K7VCIltO
        F5RPINhgwhni/nO9vZ7G4KRsXtAGn8M8ejNG8Mgp9h9IWoiMbWjZs6Reej6AzSmLCJFt7AHwd9P43
        2llOkIATemcXjsIvUgr+jvxi38c6QLQxgAJD2NPQG/3gyKfVO/3q8z+exBJ2OYjEqn8dwGDkBA6CK
        r1OxI4dJNZ2s1nA9KXSn7vvE2tmcjopaS3poNjV67t4KPmYN3ovyXPBk315UeL9nN6pzhvM1vkgmZ
        E8hHzM37ov4uNBW0SMr+E8T6phtKoogXDtQjaz2ksvXI+6WZjDQ/Ot+GeQpGdkCETPG+84NK0ws+l
        EFqXOr/A==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pzymH-00Ft68-2H
        for fio@vger.kernel.org;
        Fri, 19 May 2023 12:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 688A71BC0167; Fri, 19 May 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230519120001.688A71BC0167@kernel.dk>
Date:   Fri, 19 May 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit a64fd9c7994b51039b2fde851579c2453ddb35c0:

  docs: document no_completion_thread (2023-05-17 14:44:49 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5cedafafeeb9dde862455342cd24c860d84f4f07:

  ci: fix ups for 32-bit GitHub Actions Linux builds (2023-05-18 14:29:10 -0400)

----------------------------------------------------------------
Vincent Fu (2):
      Revert "ci: stop testing Linux 32-bit builds"
      ci: fix ups for 32-bit GitHub Actions Linux builds

 .github/workflows/ci.yml | 4 ++++
 ci/actions-install.sh    | 2 ++
 2 files changed, 6 insertions(+)

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index 8325a3d9..dd2997f0 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -14,6 +14,7 @@ jobs:
         - linux-gcc
         - linux-clang
         - macos
+        - linux-i686-gcc
         - android
         - windows-cygwin-64
         - windows-cygwin-32
@@ -27,6 +28,9 @@ jobs:
           cc: clang
         - build: macos
           os: macos-12
+        - build: linux-i686-gcc
+          os: ubuntu-22.04
+          arch: i686
         - build: android
           os: ubuntu-22.04
           arch: aarch64-linux-android32
diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index 0d73ac97..95241e78 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -35,6 +35,8 @@ DPKGCFG
                 gcc-multilib
                 pkg-config:i386
                 zlib1g-dev:i386
+                libc6:i386
+                libgcc-s1:i386
             )
             ;;
         "x86_64")
