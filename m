Return-Path: <fio-owner@vger.kernel.org>
Received: from vserver01.sebastiankayser.de ([85.88.7.146]:50739 "EHLO
	vserver01.sebastiankayser.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754728Ab0K3S1l (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 30 Nov 2010 13:27:41 -0500
Date: Tue, 30 Nov 2010 19:17:25 +0100
From: Sebastian Kayser <sebastian@skayser.de>
Subject: [PATCH] Add additional references to binary packages
Message-ID: <20101130181725.GA5823@sebastiankayser.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This adds a couple of references to binary fio packages for Linux distros as
well as for Solaris.
---
 README |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/README b/README
index f67a02b..0f91c66 100644
--- a/README
+++ b/README
@@ -23,18 +23,37 @@ well. You can download them here:
=20
 http://brick.kernel.dk/snaps/
=20
-Pascal Bleser <guru@unixtech.be> has fio RPMs in his repository for
-SUSE variants, you can find them here:
=20
+Binary packages
+---------------
+
+Debian:
+Starting with Debian "Squeeze", fio packages are part of the official
+Debian repository. http://packages.debian.org/search?keywords=3Dfio
+
+Ubuntu:
+Starting with Ubuntu 10.04 LTS (aka "Lucid Lynx"), fio packages are part
+of the Ubuntu "universe" repository.
+http://packages.ubuntu.com/search?keywords=3Dfio
+
+SUSE:
+Pascal Bleser <guru@unixtech.be> has fio RPMs in his repository for SUSE
+variants, you can find them here:
 http://linux01.gwdg.de/~pbleser/rpm-navigation.php?cat=3DSystem/fio
=20
+Red Hat, CentOS & Co:
 Dag Wie=C3=ABrs has RPMs for Red Hat related distros, find them here:
-
 http://dag.wieers.com/rpm/packages/fio/
=20
+Mandriva:
 Mandriva has integrated fio into their package repository, so installing
 on that distro should be as easy as typing 'urpmi fio'.
=20
+Solaris:
+Packages for Solaris are available from OpenCSW. Install their pkgutil
+tool (http://www.opencsw.org/get-it/pkgutil/) and then install fio via
+'pkgutil -i fio'.
+
=20
 Mailing list
 ------------
--=20
1.4.4.4


Sebastian
