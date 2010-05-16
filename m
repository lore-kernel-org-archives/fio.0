Return-Path: <fio-owner@vger.kernel.org>
Received: from anduin.net ([213.225.74.230]:16213 "EHLO anduin.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab0EPAtE (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 15 May 2010 20:49:04 -0400
Received: from localhost ([127.0.0.1])
	by anduin.net with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.71 (FreeBSD))
	(envelope-from <knan-fio@anduin.net>)
	id 1ODS2M-000JIv-KA
	for fio@vger.kernel.org; Sun, 16 May 2010 02:48:58 +0200
Date: Sun, 16 May 2010 02:48:58 +0200 (CEST)
From: =?UTF-8?Q?Erik_Inge_Bols=C3=B8?= <knan-fio@anduin.net>
Subject: eta broken at numjobs=1024
Message-ID: <alpine.BSF.2.00.1005160231090.68302@anduin.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Or rather, eta is broken while fio is busy forking processes, which takes 
some time at numjobs=1024. And while they are shutting down at the end a 
run. (fio 1.38)

Early in the run:

[139M/15217K /s] [35K/3715 iops] [eta 1158035696d:06h:32m:18s]


At the end:

Jobs: 8 (f=8): 
[___________________________________________________________________________________________________________________________________________________________________________________________________________________m___m__________________________________mmmmmm] 
[0.5% done] [91226K/10174K /s] [22K/2484 iops] [eta 02h:04m:00s]

Hopefully just a cosmetic issue...



Using this job file:

[global]
direct=1
rw=randrw
rwmixread=90
rwmixwrite=10
bs=4k
size=10G
numjobs=1024
runtime=30
time_based
group_reporting

[rw-iops]
filename=/dev/fioa2


Btw, what's the intended replacement for rwmixcycle, since that is marked 
deprecated in the source and on use?

--
-erik	http://useofwords.blogspot.com/
