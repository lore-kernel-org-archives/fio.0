Return-Path: <fio-owner@vger.kernel.org>
Received: from vbox10706.hkn.net ([213.9.107.6]:45727 "EHLO vbox10706.hkn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320AbZKSKIg (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 19 Nov 2009 05:08:36 -0500
Received: from localhost (localhost [127.0.0.1])
	by vbox10706.hkn.net (Postfix) with ESMTP id AC6E3187E9D8
	for <fio@vger.kernel.org>; Thu, 19 Nov 2009 10:39:32 +0100 (CET)
Received: from vbox10706.hkn.net ([127.0.0.1])
	by localhost (vbox10706.hkn.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FRAwf1ycofNs for <fio@vger.kernel.org>;
	Thu, 19 Nov 2009 10:39:32 +0100 (CET)
Received: from webmail.s-itc.de (localhost [127.0.0.1])
	by vbox10706.hkn.net (Postfix) with ESMTP id 89907187E9D7
	for <fio@vger.kernel.org>; Thu, 19 Nov 2009 10:39:32 +0100 (CET)
Message-ID: <58349.194.113.141.20.1258623572.squirrel@webmail.s-itc.de>
Date: Thu, 19 Nov 2009 10:39:32 +0100 (CET)
Subject: Fio on solaris
From: "Tom" <4711@gnurz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello!

I've a problem to make that fio for solaris:

> gmake -f Makefile.solaris
gcc -o gettime.o -c -Wall -O2 -g -D_GNU_SOURCE -D_LARGEFILE_SOURCE
-D_FILE_OFFSET_BITS=64 -DFIO_INC_DEBUG gettime.c
In file included from gettime.c:11:
hash.h:27:2: #error Define GOLDEN_RATIO_PRIME for your wordsize.
In file included from gettime.c:11:
hash.h: In function `hash_long':
hash.h:51: error: `GOLDEN_RATIO_PRIME' undeclared (first use in this
function)
hash.h:51: error: (Each undeclared identifier is reported only once
hash.h:51: error: for each function it appears in.)
hash.h:55: error: `__WORDSIZE' undeclared (first use in this function)
gmake: *** [gettime.o] Error 1

I've no idea what that means, any help?

