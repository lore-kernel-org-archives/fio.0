Return-Path: <fio-owner@vger.kernel.org>
Received: from postman.teamix.net ([194.150.191.120]:56289 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934503Ab1JEMMO (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 5 Oct 2011 08:12:14 -0400
Received: from zimbra.of.teamix.net (unknown [172.21.242.23])
	by rproxy.teamix.net (Postfix) with ESMTP id 32C377FB2
	for <fio@vger.kernel.org>; Wed,  5 Oct 2011 14:12:13 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.of.teamix.net (Postfix) with ESMTP id 2546E123AD9
	for <fio@vger.kernel.org>; Wed,  5 Oct 2011 14:12:13 +0200 (CEST)
Received: from zimbra.of.teamix.net ([127.0.0.1])
	by localhost (zimbra.of.teamix.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f-UI5-hLkU6l for <fio@vger.kernel.org>;
	Wed,  5 Oct 2011 14:12:12 +0200 (CEST)
Received: from mango.localnet (mango.of.teamix.net [172.21.123.1])
	by zimbra.of.teamix.net (Postfix) with ESMTPSA id C5E5D123AD8
	for <fio@vger.kernel.org>; Wed,  5 Oct 2011 14:12:12 +0200 (CEST)
From: Martin Steigerwald <ms@teamix.de>
Subject: fio debian package inclusive automated backports
Date: Wed, 5 Oct 2011 14:12:10 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110051412.11085.ms@teamix.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

in case you want an updated fio version for sid before it is uploaded to the 
official debian archive or an unofficial automatically build backport to lenny, 
squeeze, wheezy, you can use:

# cat >> /etc/apt/sources.list.d/oss.teamix.org.list <<EOF
deb http://oss.teamix.org/debian/ wheezy main
deb-src http://oss.teamix.org/debian/ wheezy main
EOF

# apt-get install teamix-archive-keyring


You may consider pinning as the autobuilder currently uses +b1 for Squeeze, 
+b2 for wheezy, +b3 for sid as version suffix which is higher than the official 
version for sid. Such as

Explaination: Unofficial debian packages from Teamix
Package: *
Pin: release o=Teamix
Pin-Priority: 200

in /etc/apt/preferences.

No warranties of course.

Thanks,
-- 
Martin Steigerwald - teamix GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
