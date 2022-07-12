Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1196EC433EF
	for <fio@archiver.kernel.org>; Tue, 12 Jul 2022 12:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbiGLMAo (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 12 Jul 2022 08:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233007AbiGLMA3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 12 Jul 2022 08:00:29 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DEE326C0
        for <fio@vger.kernel.org>; Tue, 12 Jul 2022 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=oN3XpjvLreFfIHya3f9EpAtv0irUnqAQD75hFINk+YI=; b=Nn1KsVzD6izsXizszHR8nPZWjO
        o4tnSpG+j0IPpUsiYnlt3Z0XMqPORsNXz38evkHrYhNHZUKap1SK+7nQmrP3FXsNPcd1zUKumjUGR
        mxRlMZY1jNXruimmvGoblude+sDjFZL+4Qw4eAh3ezXQo1wpWg92bDoj37YxnGkQVq5wZQ27kJxcB
        T/b5y2FKGGvMQXC53TapDdykU7XsvW3CuQ5f9RYmK299Y48u84+wQnknE1xTpUEE/HnOgW6vNKKRo
        kx2VfGf/v3zMHQNYeqfGiLDAk6ghgUiM+gujePKRbtLfnTFMDxYjj2e4TJmNwWwU3hXvZseNICk1p
        xZFCO+ew==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oBEYe-003F50-SY
        for fio@vger.kernel.org; Tue, 12 Jul 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id CFECB1BC0162; Tue, 12 Jul 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220712120001.CFECB1BC0162@kernel.dk>
Date:   Tue, 12 Jul 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 30568e0ed9366a810dfcf90a903ecfbff1a6196c:

  Merge branch 'client-hist-le64' of https://github.com/tuan-hoang1/fio (2022-07-07 06:33:25 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d6225c1550827077c0c0f9e1b8816b4f35cd5304:

  Update README.rst to specify secure protocols where possible (2022-07-11 07:53:29 -0600)

----------------------------------------------------------------
Rebecca Cran (1):
      Update README.rst to specify secure protocols where possible

 README.rst | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

---

Diff of recent changes:

diff --git a/README.rst b/README.rst
index 527f33ab..4d736eaf 100644
--- a/README.rst
+++ b/README.rst
@@ -27,31 +27,20 @@ Source
 
 Fio resides in a git repo, the canonical place is:
 
-	git://git.kernel.dk/fio.git
-
-When inside a corporate firewall, git:// URL sometimes does not work.
-If git:// does not work, use the http protocol instead:
-
-	http://git.kernel.dk/fio.git
+	https://git.kernel.dk/cgit/fio/
 
 Snapshots are frequently generated and :file:`fio-git-*.tar.gz` include the git
 meta data as well. Other tarballs are archives of official fio releases.
 Snapshots can download from:
 
-	http://brick.kernel.dk/snaps/
+	https://brick.kernel.dk/snaps/
 
 There are also two official mirrors. Both of these are automatically synced with
 the main repository, when changes are pushed. If the main repo is down for some
 reason, either one of these is safe to use as a backup:
 
-	git://git.kernel.org/pub/scm/linux/kernel/git/axboe/fio.git
-
 	https://git.kernel.org/pub/scm/linux/kernel/git/axboe/fio.git
 
-or
-
-	git://github.com/axboe/fio.git
-
 	https://github.com/axboe/fio.git
 
 
@@ -70,7 +59,7 @@ email to majordomo@vger.kernel.org with
 
 in the body of the email. Archives can be found here:
 
-	http://www.spinics.net/lists/fio/
+	https://www.spinics.net/lists/fio/
 
 or here:
 
@@ -97,12 +86,12 @@ Binary packages
 
 Debian:
 	Starting with Debian "Squeeze", fio packages are part of the official
-	Debian repository. http://packages.debian.org/search?keywords=fio .
+	Debian repository. https://packages.debian.org/search?keywords=fio .
 
 Ubuntu:
 	Starting with Ubuntu 10.04 LTS (aka "Lucid Lynx"), fio packages are part
 	of the Ubuntu "universe" repository.
-	http://packages.ubuntu.com/search?keywords=fio .
+	https://packages.ubuntu.com/search?keywords=fio .
 
 Red Hat, Fedora, CentOS & Co:
 	Starting with Fedora 9/Extra Packages for Enterprise Linux 4, fio
@@ -176,7 +165,7 @@ directory.
 
 How to compile fio on 64-bit Windows:
 
- 1. Install Cygwin (http://www.cygwin.com/). Install **make** and all
+ 1. Install Cygwin (https://www.cygwin.com/). Install **make** and all
     packages starting with **mingw64-x86_64**. Ensure
     **mingw64-x86_64-zlib** are installed if you wish
     to enable fio's log compression functionality.
@@ -205,8 +194,8 @@ browser to :file:`./doc/output/html/index.html`.  To build manual page run
 ``make -C doc man`` and then ``man doc/output/man/fio.1``.  To see what other
 output formats are supported run ``make -C doc help``.
 
-.. _reStructuredText: http://www.sphinx-doc.org/rest.html
-.. _Sphinx: http://www.sphinx-doc.org
+.. _reStructuredText: https://www.sphinx-doc.org/rest.html
+.. _Sphinx: https://www.sphinx-doc.org
 
 
 Platforms
