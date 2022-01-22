Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B57BC433F5
	for <fio@archiver.kernel.org>; Sat, 22 Jan 2022 13:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbiAVNAI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 22 Jan 2022 08:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiAVNAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 22 Jan 2022 08:00:07 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCFFC06173B
        for <fio@vger.kernel.org>; Sat, 22 Jan 2022 05:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=uowhrxKWhyWO/jjtmpwR4zR8kZp6QMi3UFOoPmOgehE=; b=qnhFyCDAdeYQBlVFU0KoNhQYuK
        h/aBBxV5lFkj22SgkJWAFCHaDLtdqVtNguJBFI90ZN8GpZo04rBjhDNM/ujUtkXIHlrLI9iUCRzOP
        fVFtBFQbxkuLauSMO6Ejh9ZbFfwKJKMpfUPXkBikEA3cTJCM9xmlW6xPd5Nwr3ftp8fhjJsY9upex
        j9jguVWdr6rWICCx0hmCy9+zKba/F09msjbaWz0pNv8VaQTwu+Vlt+8qkNuxz6qYi8kzpug9rJ4JR
        UyY+jUSwy4BpsLHSW0BtVAwRdcZKDTpDkscv03iHWJS2qdCF5PBUQxMX6qVZpkGT+C0a6WEU1Iuw5
        jaxmL42g==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nBFzw-00GNmG-Kz
        for fio@vger.kernel.org; Sat, 22 Jan 2022 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id E84781BC0165; Sat, 22 Jan 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220122130001.E84781BC0165@kernel.dk>
Date:   Sat, 22 Jan 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 3a3e5c6e7606e727df1788a73d04db56d77ba00d:

  iolog.c: Fix memory leak for blkparse case (2022-01-20 11:40:42 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2f0b54419a6ab039c677e41008391b8c53ae2e6b:

  Merge branch 'master' of https://github.com/ben-ihelputech/fio (2022-01-21 10:46:26 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'master' of https://github.com/ben-ihelputech/fio

ben-ihelputech (1):
      Update README to markdown format

 README => README.md | 78 ++++++++++++++++++++++++++---------------------------
 1 file changed, 38 insertions(+), 40 deletions(-)
 rename README => README.md (94%)

---

Diff of recent changes:

diff --git a/README b/README.md
similarity index 94%
rename from README
rename to README.md
index d566fae3..b10b1688 100644
--- a/README
+++ b/README.md
@@ -1,5 +1,5 @@
-Overview and history
---------------------
+# Fio README
+## Overview and history
 
 Fio was originally written to save me the hassle of writing special test case
 programs when I wanted to test a specific workload, either for performance
@@ -22,14 +22,13 @@ that setting is given.  The typical use of fio is to write a job file matching
 the I/O load one wants to simulate.
 
 
-Source
-------
+## Source
 
 Fio resides in a git repo, the canonical place is:
 
 	git://git.kernel.dk/fio.git
 
-When inside a corporate firewall, git:// URL sometimes does not work.
+When inside a corporate firewall, `git://` URL sometimes does not work.
 If git:// does not work, use the http protocol instead:
 
 	http://git.kernel.dk/fio.git
@@ -55,8 +54,8 @@ or
 	https://github.com/axboe/fio.git
 
 
-Mailing list
-------------
+## Mailing list
+
 
 The fio project mailing list is meant for anything related to fio including
 general discussion, bug reporting, questions, and development. For bug reporting,
@@ -81,8 +80,8 @@ and archives for the old list can be found here:
 	http://maillist.kernel.dk/fio-devel/
 
 
-Author
-------
+## Author
+
 
 Fio was written by Jens Axboe <axboe@kernel.dk> to enable flexible testing of
 the Linux I/O subsystem and schedulers. He got tired of writing specific test
@@ -92,56 +91,55 @@ benchmark/test tools out there weren't flexible enough to do what he wanted.
 Jens Axboe <axboe@kernel.dk> 20060905
 
 
-Binary packages
----------------
+## Binary packages
 
-Debian:
+**Debian:**
 	Starting with Debian "Squeeze", fio packages are part of the official
 	Debian repository. http://packages.debian.org/search?keywords=fio .
 
-Ubuntu:
+**Ubuntu:**
 	Starting with Ubuntu 10.04 LTS (aka "Lucid Lynx"), fio packages are part
 	of the Ubuntu "universe" repository.
 	http://packages.ubuntu.com/search?keywords=fio .
 
-Red Hat, Fedora, CentOS & Co:
+**Red Hat, Fedora, CentOS & Co:**
 	Starting with Fedora 9/Extra Packages for Enterprise Linux 4, fio
 	packages are part of the Fedora/EPEL repositories.
 	https://apps.fedoraproject.org/packages/fio .
 
-Mandriva:
+**Mandriva:**
 	Mandriva has integrated fio into their package repository, so installing
 	on that distro should be as easy as typing ``urpmi fio``.
 
-Arch Linux:
+**Arch Linux:**
         An Arch Linux package is provided under the Community sub-repository:
         https://www.archlinux.org/packages/?sort=&q=fio
 
-Solaris:
+**Solaris:**
 	Packages for Solaris are available from OpenCSW. Install their pkgutil
 	tool (http://www.opencsw.org/get-it/pkgutil/) and then install fio via
 	``pkgutil -i fio``.
 
-Windows:
+**Windows:**
 	Rebecca Cran <rebecca@bsdio.com> has fio packages for Windows at
 	https://bsdio.com/fio/ . The latest builds for Windows can also
 	be grabbed from https://ci.appveyor.com/project/axboe/fio by clicking
 	the latest x86 or x64 build, then selecting the ARTIFACTS tab.
 
-BSDs:
+**BSDs:**
 	Packages for BSDs may be available from their binary package repositories.
 	Look for a package "fio" using their binary package managers.
 
 
-Building
---------
-
-Just type::
+## Building
 
- $ ./configure
- $ make
- $ make install
 
+Just type::
+```
+./configure
+make
+make install
+```
 Note that GNU make is required. On BSDs it's available from devel/gmake within
 ports directory; on Solaris it's in the SUNWgmake package.  On platforms where
 GNU make isn't the default, type ``gmake`` instead of ``make``.
@@ -155,18 +153,18 @@ to be installed.  gfio isn't built automatically and can be enabled with a
 ``--enable-gfio`` option to configure.
 
 To build fio with a cross-compiler::
-
- $ make clean
- $ make CROSS_COMPILE=/path/to/toolchain/prefix
-
+```
+make clean
+make CROSS_COMPILE=/path/to/toolchain/prefix
+```
 Configure will attempt to determine the target platform automatically.
 
 It's possible to build fio for ESX as well, use the ``--esx`` switch to
 configure.
 
 
-Windows
-~~~~~~~
+## Windows
+
 
 The minimum versions of Windows for building/runing fio are Windows 7/Windows
 Server 2008 R2. On Windows, Cygwin (https://www.cygwin.com/) is required in
@@ -174,7 +172,7 @@ order to build fio. To create an MSI installer package install WiX from
 https://wixtoolset.org and run :file:`dobuild.cmd` from the :file:`os/windows`
 directory.
 
-How to compile fio on 64-bit Windows:
+### How to compile fio on 64-bit Windows:
 
  1. Install Cygwin (http://www.cygwin.com/). Install **make** and all
     packages starting with **mingw64-x86_64**. Ensure
@@ -196,21 +194,21 @@ https://github.com/mintty/mintty/wiki/Tips#inputoutput-interaction-with-alien-pr
 for details).
 
 
-Documentation
-~~~~~~~~~~~~~
+## Documentation
+
 
 Fio uses Sphinx_ to generate documentation from the reStructuredText_ files.
 To build HTML formatted documentation run ``make -C doc html`` and direct your
 browser to :file:`./doc/output/html/index.html`.  To build manual page run
 ``make -C doc man`` and then ``man doc/output/man/fio.1``.  To see what other
 output formats are supported run ``make -C doc help``.
-
+```
 .. _reStructuredText: http://www.sphinx-doc.org/rest.html
 .. _Sphinx: http://www.sphinx-doc.org
+```
 
+## Platforms
 
-Platforms
----------
 
 Fio works on (at least) Linux, Solaris, AIX, HP-UX, OSX, NetBSD, OpenBSD,
 Windows, FreeBSD, and DragonFly. Some features and/or options may only be
@@ -252,8 +250,8 @@ POSIX aio should work now. To make the change permanent::
         posix_aio0 changed
 
 
-Running fio
------------
+## Running fio
+
 
 Running fio is normally the easiest part - you just give it the job file
 (or job files) as parameters::
