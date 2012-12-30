Return-Path: <fio-owner@vger.kernel.org>
Received: from smtpout1-ctsd.core.ignum.cz ([62.109.128.47]:54970 "EHLO
	smtpout1-ctsd.core.ignum.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755140Ab2L3Whi (ORCPT
	<rfc822;fio@vger.kernel.org>); Sun, 30 Dec 2012 17:37:38 -0500
Received: from freza3.core.ignum.cz (freza3.core.ignum.cz [217.31.49.154])
	by smtpout1.core.ignum.cz (Postfix) with ESMTP id EDFCD22405
	for <fio@vger.kernel.org>; Sun, 30 Dec 2012 23:31:17 +0100 (CET)
Received: from freza3.core.ignum.cz (localhost [127.0.0.1])
	by freza3.core.ignum.cz (Postfix) with ESMTP id A4389B3A6
	for <fio@vger.kernel.org>; Sun, 30 Dec 2012 23:11:51 +0100 (CET)
Received: from [192.168.160.10] (72.155.broadband6.iol.cz [88.101.155.72])
	(Authenticated sender: dan@danny.cz)
	by freza3.core.ignum.cz (Postfix) with ESMTPA id 759E9ACAA
	for <fio@vger.kernel.org>; Sun, 30 Dec 2012 23:11:51 +0100 (CET)
Message-ID: <1356905511.3343.24.camel@eagle.danny.cz>
Subject: fio-2.0.12.2 doesn't build with ARCH_HAVE_CPU_CLOCK not defined
From: Dan =?ISO-8859-1?Q?Hor=E1k?= <dan@danny.cz>
Date: Sun, 30 Dec 2012 23:11:51 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

fio stopped to build on architectures that don't define
ARCH_HAVE_CPU_CLOCK like s390/s390x (fixed in a patch I've already
sent :-))

cc -o gettime.o -c -std=gnu99 -Wwrite-strings -Wall -O3 -g -O2 -g -pipe
-Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector
--param=ssp-buffer-size=4 -m31 -march=z9-109 -mtune=z10
-DFIO_VERSION='"fio-2.0.12.2"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
-D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG gettime.c 
gettime.c: In function 'fio_clock_init':
gettime.c:317:6: error: 'tsc_reliable' undeclared (first use in this function)
gettime.c:317:6: note: each undeclared identifier is reported only once for each function it appears in
make: *** [gettime.o] Error 1

seems commit fa80feae51 added the tsc_reliable variable


	Thanks

		Dan


