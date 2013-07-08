Return-Path: <fio-owner@vger.kernel.org>
Received: from postman.teamix.net ([194.150.191.120]:38637 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751213Ab3GHNQq convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 8 Jul 2013 09:16:46 -0400
Received: from zimbra.of.teamix.net (unknown [172.21.242.23])
	by rproxy.teamix.net (Postfix) with ESMTP id C01907A084
	for <fio@vger.kernel.org>; Mon,  8 Jul 2013 15:06:17 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.of.teamix.net (Postfix) with ESMTP id A3DD9146C54
	for <fio@vger.kernel.org>; Mon,  8 Jul 2013 15:06:17 +0200 (CEST)
Received: from zimbra.of.teamix.net ([127.0.0.1])
	by localhost (zimbra.of.teamix.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yvUsaSMagfj0 for <fio@vger.kernel.org>;
	Mon,  8 Jul 2013 15:06:17 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.of.teamix.net (Postfix) with ESMTP id 4A003146C55
	for <fio@vger.kernel.org>; Mon,  8 Jul 2013 15:06:17 +0200 (CEST)
Received: from zimbra.of.teamix.net ([127.0.0.1])
	by localhost (zimbra.of.teamix.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id tFFBwflwnzpg for <fio@vger.kernel.org>;
	Mon,  8 Jul 2013 15:06:16 +0200 (CEST)
Received: from mango.localnet (mango.of.teamix.net [172.21.123.1])
	by zimbra.of.teamix.net (Postfix) with ESMTPSA id E98CA146C54
	for <fio@vger.kernel.org>; Mon,  8 Jul 2013 15:06:16 +0200 (CEST)
From: Martin Steigerwald <ms@teamix.de>
Subject: [RFC] packaging fio 2.1.1 for Debian: make clean does not remove all generated files
Date: Mon, 8 Jul 2013 15:06:16 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201307081506.16476.ms@teamix.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens!

I am in the process of upgrading Debian packaging of fio to current version
2.1.1, but run into this error:

dpkg-source: info: using source format `3.0 (quilt)'
dpkg-source: info: building fio using existing ./fio_2.1.1.orig.tar.gz
dpkg-source: info: local changes detected, the modified files are:
 fio/config.log
 fio/crc/crc16.d
 fio/crc/crc32.d
[…]
 fio/engines/binject.d
 fio/engines/cpu.d
[…]
 fio/lib/axmap.d
 fio/lib/flist_sort.d
[…]
 fio/profiles/act.d
 fio/profiles/tiobench.d
dpkg-source: info: you can integrate the local changes with dpkg-source --commit
dpkg-source: error: aborting due to unexpected upstream changes, see /tmp/fio_2.1.1-1.diff.eLtKfe
dpkg-buildpackage: error: dpkg-source -b fio gave error exit status 2



I added the following patch to debian package which fixes it:

Description: Delete config log and .d-files on clean.
  Makefile of fio 2.1.1 leaves them which prevents repeated builds
  with dpkg-buildpackage due to:
  dpkg-source: info: local changes detected, …
Author: Martin Steigerwald <ms@teamix.de>

---
--- a/Makefile
+++ b/Makefile
@@ -265,7 +265,7 @@
        $(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_LFSR_TEST_OBJS) $(LIBS) $(LDFLAGS)
 
 clean: FORCE
-       -rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) core.* core gfio FIO-VERSION-FILE *.d 
config-host.mak config-host.h
+       -rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) core.* core gfio FIO-VERSION-FILE *.d */*.d 
config.log config-host.mak config-host.h
 
 distclean: clean FORCE
        @rm -f cscope.out




Any other suggestion? If thats good to go, maybe makes sense to apply
upstream?

Ciao,
-- 
Martin Steigerwald - teamix GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
