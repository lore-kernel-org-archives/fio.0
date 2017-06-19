Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33388 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753845AbdFSMAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 19 Jun 2017 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dMvLe-0001y1-Mr
        for fio@vger.kernel.org; Mon, 19 Jun 2017 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170619120001.C7D352C016D@kernel.dk>
Date: Mon, 19 Jun 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e5aaf1e677d1413125ffaf7aae48b1e8f4ce9ebc:

  Fio 2.21 (2017-06-15 12:25:03 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 594f7abb0c3e5ea4174b1d450959305f827cbdfd:

  Merge branch 'dev/doc/pkg' of https://github.com/bobsaintcool/fio (2017-06-18 10:32:11 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'dev/doc/pkg' of https://github.com/bobsaintcool/fio

Quentin Bourgeois (1):
      <README/pkg: Add reference to Arch Linux package>

 README | 4 ++++
 1 file changed, 4 insertions(+)

---

Diff of recent changes:

diff --git a/README b/README
index 951550b..6bff82b 100644
--- a/README
+++ b/README
@@ -108,6 +108,10 @@ Mandriva:
 	Mandriva has integrated fio into their package repository, so installing
 	on that distro should be as easy as typing ``urpmi fio``.
 
+Arch Linux:
+        An Arch Linux package is provided under the Community sub-repository:
+        https://www.archlinux.org/packages/?sort=&q=fio
+
 Solaris:
 	Packages for Solaris are available from OpenCSW. Install their pkgutil
 	tool (http://www.opencsw.org/get-it/pkgutil/) and then install fio via
