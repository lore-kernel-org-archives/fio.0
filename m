Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B56E7CDB482
	for <fio@archiver.kernel.org>; Tue, 17 Oct 2023 12:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbjJQMAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 17 Oct 2023 08:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234605AbjJQMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 17 Oct 2023 08:00:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB35EA
        for <fio@vger.kernel.org>; Tue, 17 Oct 2023 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=6zTTOpYH6zbyChw1zy7CZ40d/nZTG4v8RxzO4Kip4ik=; b=S8vdmweopss7cPWqpTCm9HD3z4
        oNnIvQakay2xslLeUmmkkvz0TGB9TB5rJ8ey++TQki9hAOcHyNdwxr0oFCg6KxUcTjJyc7vuhd9eu
        uEyaVCRYxPZZsobdaxazN7gDFqCIBUOoPF+swwIgHKZfLcSnEBdZo455tBSg9PMJb/gU6EMMKln+D
        OfyNs12spVzWAGLqkltud8Lwye1FWIY6yabyl9Y/dya/rTgS2juBA4g5TtxfW2mmaEduho/2BqFjT
        OzQRHVvdiIkhLWvlR0VQPEzIXgMq2XL62cMC9kdq1uas4emabxKkzvB8TGP7CDbnG4beNzMLVZjuM
        IUkuhRDw==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qsik1-00CAVM-Mo
        for fio@vger.kernel.org; Tue, 17 Oct 2023 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 487FA1BC0140; Tue, 17 Oct 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20231017120001.487FA1BC0140@kernel.dk>
Date:   Tue, 17 Oct 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 50b94305b08a746c21a2c644ffb3cb56915d86ee:

  t/zbd: avoid test case 45 failure (2023-10-13 17:31:47 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c5d8ce3fc736210ded83b126c71e3225c7ffd7c9:

  ci: explicitly install pygments and certifi on macos (2023-10-16 10:54:21 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      ci: explicitly install pygments and certifi on macos

 ci/actions-install.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index 95241e78..76335fbc 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -86,7 +86,7 @@ install_macos() {
     #echo "Updating homebrew..."
     #brew update >/dev/null 2>&1
     echo "Installing packages..."
-    HOMEBREW_NO_AUTO_UPDATE=1 brew install cunit libnfs sphinx-doc
+    HOMEBREW_NO_AUTO_UPDATE=1 brew install cunit libnfs sphinx-doc pygments python-certifi
     brew link sphinx-doc --force
     pip3 install scipy six statsmodels
 }
