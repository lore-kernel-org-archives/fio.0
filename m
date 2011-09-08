Return-Path: <fio-owner@vger.kernel.org>
Received: from myspam1.stec-inc.com ([210.19.18.169]:54852 "EHLO
	myspam1-dmz.my.stec-inc.ad" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758189Ab1IHKNb convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>); Thu, 8 Sep 2011 06:13:31 -0400
Received: from mycas01.MY.STEC-INC.AD (mycas01.my.stec-inc.ad [172.30.0.57])
	by myspam1-dmz.my.stec-inc.ad (8.13.8/8.13.8) with ESMTP id p889ix5b004049
	for <fio@vger.kernel.org>; Thu, 8 Sep 2011 17:44:59 +0800
	(envelope-from sphansalkar@stec-inc.com)
From: Shrirang Phansalkar <sphansalkar@stec-inc.com>
Date: Thu, 8 Sep 2011 17:55:32 +0800
Subject: problem while executing fio on multiple disks
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B02CF0A@MYMBX.MY.STEC-INC.AD>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Prasad Joshi <pjoshi@stec-inc.com>

Hi,

I was trying to execute fio with the following job file, but I have some issues with it.

[globals]
rw=randrw
size=10M
ioengine=sync
blocksize=4k
numjobs=16
direct=1
iodepth=32
thread

[thread1]
filename=/dev/sdb
stonewall

[thread2]
filename=/dev/sdc
stonewall

[thread3]
filename=/dev/sdd
stonewall


After its completion in Disk stats I got util as :

sdb: util=99.64%
sdc: util=51.72%
sdd: util=34.76%

where as expected util for all 3 disks should be somewhat similar ( all 3 disks are of same size)

But if I run fio using separate jobfile for every disk, then I am getting almost similar disk util for each disk (around util=98% for each disk).

Pl let me know that if there is some problem with the fio or there is something wrong with my jobfile.

Thanks and regards,
Shrirang.
