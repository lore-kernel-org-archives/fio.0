Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.cse.ucdavis.edu ([128.120.246.11]:42657 "EHLO
	mail.cse.ucdavis.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab0DMIZk (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 13 Apr 2010 04:25:40 -0400
Received: from [192.168.1.117] (adsl-69-229-120-220.dsl.scrm01.pacbell.net [69.229.120.220])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: bill@broadley.org)
	by mail.cse.ucdavis.edu (Postfix) with ESMTPSA id 317213DE9B
	for <fio@vger.kernel.org>; Tue, 13 Apr 2010 01:16:03 -0700 (PDT)
Message-ID: <4BC42842.7000304@broadley.org>
Date: Tue, 13 Apr 2010 01:16:02 -0700
From: Bill Broadley <bill@broadley.org>
MIME-Version: 1.0
Subject: --blocksize bug?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org


I downloaded 1.38, and then the 
http://brick.kernel.dk/snaps/fio-git-latest.tar.gz.  Both exhibited 
identical behavior.

Both built with no problems on a centos-5.4 x86-64 box.

REPORTING-BUGS mentioned cat .git/HEAD, so I'll report it:
ref: refs/heads/master

Goal:
   To benchmark randomly accessing a 1GB file with different blocksizes
   to see how blocksize effects bandwidth.

rand.fio:
[random-read]
rw=randread
size=128m # just enough to get the numbers
filesize=1G # make sure the seek distance is randomly over 1GB file
directory=/mnt/tmp
blocksize=1024k

BTW, the fio.1 page says:
   blocksize=int[,int], bs=int[,int]
      Block size for I/O units.  Default: 4k.  Values  for  reads  and
      writes  can  be  specified  seperately in the format read,write,
      either of which may be empty to leave that value at its default.

BTW, that should be separately not "seperately"

So since I wanted to vary the blocksize I figured I'd do it on the 
command line so I said:
./fio --showcmd ~/rand.fio
fio --name=random-read --rw=randread --size=128m --filesize=1G 
--directory=/mnt/tmp --blocksize=1024k

To I tried to run it:
./fio --name=random-read --rw=randread --size=128m --filesize=1G 
--directory=/mnt/tmp --blocksize=1024k
./fio: unrecognized option `--blocksize=1024k'

I tried to use the config file except for the blocksize.  I deleted the 
blocksize= line from rand.fio and:
./fio --blocksize=1m  ~/rand.fio
./fio: unrecognized option `--blocksize=1m'

Potential fixes:
1) fix showcmd to report a different flag for setting --blocksize
2) fix fio to accept --blocksize

Expected behavior:
I expected ./fio ~/rand.fio to work exactly like the arguments reported 
by ./fio --showcmd.









