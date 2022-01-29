Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2118C433F5
	for <fio@archiver.kernel.org>; Sat, 29 Jan 2022 13:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiA2NAH (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 29 Jan 2022 08:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiA2NAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 29 Jan 2022 08:00:06 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FF4C061714
        for <fio@vger.kernel.org>; Sat, 29 Jan 2022 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=T5SoJ/0Cng/MfJqhkczXgeHZfxFpij6O4dn6DY0G3lw=; b=jcmDgoIX4530mG1I1N07sKa2zK
        VgrRaw31nfYVHFvR8X2Z7av5V+MUTawvFG3gdR08zTz0BCRY9wyPlFmFUxW/gdoL2gl/oNBe7FRnG
        kw2ImmKIK87UVR1jD4XwLzY7WyeFb4Vs3YvbCzifJEBL6rXciSnM6E/ygcKxfuNFuWBP4OBwGiYAy
        UmfpGuBpzX1vZ2ZWHkD7FFum0FNTE7qpPSUSGgkI3zkIDwuLEXjohFoKsXoJOjDAMU+J2YNtb/YbR
        3qAQk/OHGAIlEWpYxKcgECsDtaTPtAv0/uOtYRCk+hYCI60l3nSeo4GfJ/EbQda/UAPlPbxtOHmbl
        z7HWBjfA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nDnKl-004qn6-ST
        for fio@vger.kernel.org; Sat, 29 Jan 2022 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 9992A1BC0141; Sat, 29 Jan 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220129130001.9992A1BC0141@kernel.dk>
Date:   Sat, 29 Jan 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 2b3d4a6a924e0aa82654d3b96fb134085af7a98a:

  fio: use LDFLAGS when linking dynamic engines (2022-01-26 13:12:14 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 52a0b9ed71c3e929461e64b39059281948107071:

  Merge branch 'patch-1' of https://github.com/Nikratio/fio (2022-01-28 14:50:51 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'docs' of https://github.com/vincentkfu/fio
      Merge branch 'patch-1' of https://github.com/Nikratio/fio

Nikolaus Rath (1):
      I/O size: fix description of filesize

Vincent Fu (4):
      Revert "Update README to markdown format"
      docs: rename README to README.rst
      docs: update fio docs to pull from README.rst
      Makefile: build t/fio-dedupe only if zlib support is found

 HOWTO                   | 11 +++----
 Makefile                |  4 +++
 README.md => README.rst | 78 +++++++++++++++++++++++++------------------------
 doc/fio_doc.rst         |  2 +-
 doc/fio_man.rst         |  2 +-
 fio.1                   |  8 ++---
 6 files changed, 56 insertions(+), 49 deletions(-)
 rename README.md => README.rst (94%)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index f9e7c857..c72ec8cd 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1886,11 +1886,12 @@ I/O size
 
 .. option:: filesize=irange(int)
 
-	Individual file sizes. May be a range, in which case fio will select sizes
-	for files at random within the given range and limited to :option:`size` in
-	total (if that is given). If not given, each created file is the same size.
-	This option overrides :option:`size` in terms of file size, which means
-	this value is used as a fixed size or possible range of each file.
+	Individual file sizes. May be a range, in which case fio will select sizes for
+	files at random within the given range. If not given, each created file is the
+	same size. This option overrides :option:`size` in terms of file size, i.e. if
+	:option:`filesize` is specified then :option:`size` becomes merely the default
+	for :option:`io_size` and has no effect at all if :option:`io_size` is set
+	explicitly.
 
 .. option:: file_append=bool
 
diff --git a/Makefile b/Makefile
index 00e79539..2432f519 100644
--- a/Makefile
+++ b/Makefile
@@ -430,7 +430,9 @@ T_TEST_PROGS += $(T_AXMAP_PROGS)
 T_TEST_PROGS += $(T_LFSR_TEST_PROGS)
 T_TEST_PROGS += $(T_GEN_RAND_PROGS)
 T_PROGS += $(T_BTRACE_FIO_PROGS)
+ifdef CONFIG_ZLIB
 T_PROGS += $(T_DEDUPE_PROGS)
+endif
 T_PROGS += $(T_VS_PROGS)
 T_TEST_PROGS += $(T_MEMLOCK_PROGS)
 ifdef CONFIG_PREAD
@@ -618,8 +620,10 @@ t/fio-btrace2fio: $(T_BTRACE_FIO_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(T_BTRACE_FIO_OBJS) $(LIBS)
 endif
 
+ifdef CONFIG_ZLIB
 t/fio-dedupe: $(T_DEDUPE_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(T_DEDUPE_OBJS) $(LIBS)
+endif
 
 t/fio-verify-state: $(T_VS_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(T_VS_OBJS) $(LIBS)
diff --git a/README.md b/README.rst
similarity index 94%
rename from README.md
rename to README.rst
index b10b1688..d566fae3 100644
--- a/README.md
+++ b/README.rst
@@ -1,5 +1,5 @@
-# Fio README
-## Overview and history
+Overview and history
+--------------------
 
 Fio was originally written to save me the hassle of writing special test case
 programs when I wanted to test a specific workload, either for performance
@@ -22,13 +22,14 @@ that setting is given.  The typical use of fio is to write a job file matching
 the I/O load one wants to simulate.
 
 
-## Source
+Source
+------
 
 Fio resides in a git repo, the canonical place is:
 
 	git://git.kernel.dk/fio.git
 
-When inside a corporate firewall, `git://` URL sometimes does not work.
+When inside a corporate firewall, git:// URL sometimes does not work.
 If git:// does not work, use the http protocol instead:
 
 	http://git.kernel.dk/fio.git
@@ -54,8 +55,8 @@ or
 	https://github.com/axboe/fio.git
 
 
-## Mailing list
-
+Mailing list
+------------
 
 The fio project mailing list is meant for anything related to fio including
 general discussion, bug reporting, questions, and development. For bug reporting,
@@ -80,8 +81,8 @@ and archives for the old list can be found here:
 	http://maillist.kernel.dk/fio-devel/
 
 
-## Author
-
+Author
+------
 
 Fio was written by Jens Axboe <axboe@kernel.dk> to enable flexible testing of
 the Linux I/O subsystem and schedulers. He got tired of writing specific test
@@ -91,55 +92,56 @@ benchmark/test tools out there weren't flexible enough to do what he wanted.
 Jens Axboe <axboe@kernel.dk> 20060905
 
 
-## Binary packages
+Binary packages
+---------------
 
-**Debian:**
+Debian:
 	Starting with Debian "Squeeze", fio packages are part of the official
 	Debian repository. http://packages.debian.org/search?keywords=fio .
 
-**Ubuntu:**
+Ubuntu:
 	Starting with Ubuntu 10.04 LTS (aka "Lucid Lynx"), fio packages are part
 	of the Ubuntu "universe" repository.
 	http://packages.ubuntu.com/search?keywords=fio .
 
-**Red Hat, Fedora, CentOS & Co:**
+Red Hat, Fedora, CentOS & Co:
 	Starting with Fedora 9/Extra Packages for Enterprise Linux 4, fio
 	packages are part of the Fedora/EPEL repositories.
 	https://apps.fedoraproject.org/packages/fio .
 
-**Mandriva:**
+Mandriva:
 	Mandriva has integrated fio into their package repository, so installing
 	on that distro should be as easy as typing ``urpmi fio``.
 
-**Arch Linux:**
+Arch Linux:
         An Arch Linux package is provided under the Community sub-repository:
         https://www.archlinux.org/packages/?sort=&q=fio
 
-**Solaris:**
+Solaris:
 	Packages for Solaris are available from OpenCSW. Install their pkgutil
 	tool (http://www.opencsw.org/get-it/pkgutil/) and then install fio via
 	``pkgutil -i fio``.
 
-**Windows:**
+Windows:
 	Rebecca Cran <rebecca@bsdio.com> has fio packages for Windows at
 	https://bsdio.com/fio/ . The latest builds for Windows can also
 	be grabbed from https://ci.appveyor.com/project/axboe/fio by clicking
 	the latest x86 or x64 build, then selecting the ARTIFACTS tab.
 
-**BSDs:**
+BSDs:
 	Packages for BSDs may be available from their binary package repositories.
 	Look for a package "fio" using their binary package managers.
 
 
-## Building
-
+Building
+--------
 
 Just type::
-```
-./configure
-make
-make install
-```
+
+ $ ./configure
+ $ make
+ $ make install
+
 Note that GNU make is required. On BSDs it's available from devel/gmake within
 ports directory; on Solaris it's in the SUNWgmake package.  On platforms where
 GNU make isn't the default, type ``gmake`` instead of ``make``.
@@ -153,18 +155,18 @@ to be installed.  gfio isn't built automatically and can be enabled with a
 ``--enable-gfio`` option to configure.
 
 To build fio with a cross-compiler::
-```
-make clean
-make CROSS_COMPILE=/path/to/toolchain/prefix
-```
+
+ $ make clean
+ $ make CROSS_COMPILE=/path/to/toolchain/prefix
+
 Configure will attempt to determine the target platform automatically.
 
 It's possible to build fio for ESX as well, use the ``--esx`` switch to
 configure.
 
 
-## Windows
-
+Windows
+~~~~~~~
 
 The minimum versions of Windows for building/runing fio are Windows 7/Windows
 Server 2008 R2. On Windows, Cygwin (https://www.cygwin.com/) is required in
@@ -172,7 +174,7 @@ order to build fio. To create an MSI installer package install WiX from
 https://wixtoolset.org and run :file:`dobuild.cmd` from the :file:`os/windows`
 directory.
 
-### How to compile fio on 64-bit Windows:
+How to compile fio on 64-bit Windows:
 
  1. Install Cygwin (http://www.cygwin.com/). Install **make** and all
     packages starting with **mingw64-x86_64**. Ensure
@@ -194,21 +196,21 @@ https://github.com/mintty/mintty/wiki/Tips#inputoutput-interaction-with-alien-pr
 for details).
 
 
-## Documentation
-
+Documentation
+~~~~~~~~~~~~~
 
 Fio uses Sphinx_ to generate documentation from the reStructuredText_ files.
 To build HTML formatted documentation run ``make -C doc html`` and direct your
 browser to :file:`./doc/output/html/index.html`.  To build manual page run
 ``make -C doc man`` and then ``man doc/output/man/fio.1``.  To see what other
 output formats are supported run ``make -C doc help``.
-```
+
 .. _reStructuredText: http://www.sphinx-doc.org/rest.html
 .. _Sphinx: http://www.sphinx-doc.org
-```
 
-## Platforms
 
+Platforms
+---------
 
 Fio works on (at least) Linux, Solaris, AIX, HP-UX, OSX, NetBSD, OpenBSD,
 Windows, FreeBSD, and DragonFly. Some features and/or options may only be
@@ -250,8 +252,8 @@ POSIX aio should work now. To make the change permanent::
         posix_aio0 changed
 
 
-## Running fio
-
+Running fio
+-----------
 
 Running fio is normally the easiest part - you just give it the job file
 (or job files) as parameters::
diff --git a/doc/fio_doc.rst b/doc/fio_doc.rst
index b5987b52..8e1216f0 100644
--- a/doc/fio_doc.rst
+++ b/doc/fio_doc.rst
@@ -2,7 +2,7 @@ fio - Flexible I/O tester rev. |version|
 ========================================
 
 
-.. include:: ../README
+.. include:: ../README.rst
 
 
 .. include:: ../HOWTO
diff --git a/doc/fio_man.rst b/doc/fio_man.rst
index c6a6438f..44312f16 100644
--- a/doc/fio_man.rst
+++ b/doc/fio_man.rst
@@ -6,7 +6,7 @@ Fio Manpage
 (rev. |release|)
 
 
-.. include:: ../README
+.. include:: ../README.rst
 
 
 .. include:: ../HOWTO
diff --git a/fio.1 b/fio.1
index 34aa874d..b87d2309 100644
--- a/fio.1
+++ b/fio.1
@@ -1686,10 +1686,10 @@ also be set as number of zones using 'z'.
 .TP
 .BI filesize \fR=\fPirange(int)
 Individual file sizes. May be a range, in which case fio will select sizes
-for files at random within the given range and limited to \fBsize\fR in
-total (if that is given). If not given, each created file is the same size.
-This option overrides \fBsize\fR in terms of file size, which means
-this value is used as a fixed size or possible range of each file.
+for files at random within the given range. If not given, each created file
+is the same size. This option overrides \fBsize\fR in terms of file size, 
+i.e. \fBsize\fR becomes merely the default for \fBio_size\fR (and
+has no effect it all if \fBio_size\fR is set explicitly).
 .TP
 .BI file_append \fR=\fPbool
 Perform I/O after the end of the file. Normally fio will operate within the
