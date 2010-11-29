Return-Path: <fio-owner@vger.kernel.org>
Received: from vserver01.sebastiankayser.de ([85.88.7.146]:40805 "EHLO
	vserver01.sebastiankayser.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422Ab0K2RWK (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 29 Nov 2010 12:22:10 -0500
Date: Mon, 29 Nov 2010 18:12:00 +0100
From: Sebastian Kayser <sebastian@skayser.de>
Subject: fio packages for Solaris via opencsw.org
Message-ID: <20101129171159.GN28050@sebastiankayser.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

in case anyone here is using fio on Solaris, there are now precompiled
binary packages available via opencsw.org (Solaris 9/10, both x86 and
SPARC) [1]. With Solaris 10 installation is as easy as:

# pkgadd -d http://mirror.opencsw.org/opencsw/pkgutil-`uname -p`.pkg
# pkgutil -i fio

For Solaris 9 installation instructions and more details about pkgutil
please see the pkgutil quick start page [2].

Sebastian

[1] http://www.opencsw.org/packages/fio/
[2] http://www.opencsw.org/get-it/pkgutil/

P.S.: Jens, would you mind adding the package reference to README?
