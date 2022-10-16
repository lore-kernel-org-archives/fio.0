Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04CCDC433FE
	for <fio@archiver.kernel.org>; Sun, 16 Oct 2022 12:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJPMAL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 16 Oct 2022 08:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiJPMAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 16 Oct 2022 08:00:10 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACC9275D2
        for <fio@vger.kernel.org>; Sun, 16 Oct 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=CoBaGLqn/adF1eIAiCsXYmwbERUkO3gCDpt08oOIs8o=; b=WkEEVhFZ9bFZtIEbvTVJ9Vskfn
        4prm1O6EFU5ljbHPpMNgZxk4j+D4eavJSjVOG0WTTnZleH5DNWFogbEuB3VWMNSZvCO8QQ07uce+2
        i5oa03Hi5xx1QXohmeHv2hitipYbjmkcYjFbUVcAHJ4Gitm7Z0/0972EY6qqrjdI8uxhLkjXwSKxK
        wQrIQlQMiBRB5uN73J4k+IagURnCX2JDF3pWDwqvmWqqaasbm8reAuTfRKgyo3RbTI7FnBAdTcpXd
        U1XKtUSfHWXvwJcNi8Hf4Fw9IrKS5nB8vKUw/XUC8GWNGKHa4G2Hz71QwOM/LTCFnkywwITvQMZv5
        MuUKm3LQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ok2JJ-003vQM-5Z
        for fio@vger.kernel.org; Sun, 16 Oct 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 6708F1BC0127; Sun, 16 Oct 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221016120002.6708F1BC0127@kernel.dk>
Date:   Sun, 16 Oct 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 07f78c37833730594778fb5684ac6ec40d0289f8:

  engines/io_uring: set coop taskrun, single issuer and defer taskrun (2022-10-12 07:19:35 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8a63e7a32fcb6b7b131c4678ba95b81a9f2f8bca:

  Merge branch 'readme-update' of https://github.com/nikoandpiko/fio (2022-10-15 09:05:32 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'readme-update' of https://github.com/nikoandpiko/fio

Nicholas Roma (1):
      Update to README

 README.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/README.rst b/README.rst
index 79582dea..bcd08ec9 100644
--- a/README.rst
+++ b/README.rst
@@ -150,7 +150,7 @@ GNU make isn't the default, type ``gmake`` instead of ``make``.
 
 Configure will print the enabled options. Note that on Linux based platforms,
 the libaio development packages must be installed to use the libaio
-engine. Depending on distro, it is usually called libaio-devel or libaio-dev.
+engine. Depending on the distro, it is usually called libaio-devel or libaio-dev.
 
 For gfio, gtk 2.18 (or newer), associated glib threads, and cairo are required
 to be installed.  gfio isn't built automatically and can be enabled with a
@@ -170,7 +170,7 @@ configure.
 Windows
 ~~~~~~~
 
-The minimum versions of Windows for building/runing fio are Windows 7/Windows
+The minimum versions of Windows for building/running fio are Windows 7/Windows
 Server 2008 R2. On Windows, Cygwin (https://www.cygwin.com/) is required in
 order to build fio. To create an MSI installer package install WiX from
 https://wixtoolset.org and run :file:`dobuild.cmd` from the :file:`os/windows`
@@ -224,7 +224,7 @@ implemented, I'd be happy to take patches for that. An example of that is disk
 utility statistics and (I think) huge page support, support for that does exist
 in FreeBSD/Solaris.
 
-Fio uses pthread mutexes for signalling and locking and some platforms do not
+Fio uses pthread mutexes for signaling and locking and some platforms do not
 support process shared pthread mutexes. As a result, on such platforms only
 threads are supported. This could be fixed with sysv ipc locking or other
 locking alternatives.
