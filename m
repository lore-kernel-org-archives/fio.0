Return-Path: <fio-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49511 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab0IBG4j (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 2 Sep 2010 02:56:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19583.17886.845282.76401@debian.frec.bull.fr>
Date: Thu, 2 Sep 2010 08:36:14 +0200
Subject: How to measure IOPS
In-Reply-To: <1283377594.1781.42.camel@wfischer-t410-ubuntu>
References: <1283377594.1781.42.camel@wfischer-t410-ubuntu>
From: Solofo.Ramangalahy@bull.net
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Werner Fischer <devlists@wefi.net>
Cc: fio@vger.kernel.org

Hi,

 > Can you give me a hint what fio parameters you would suggest to measure IOPS?

I would put your workload in a parameterized file and use the iodepth
as a parameter (or other ones like bs).

For example like this:

iodepth=${IODEPTH} (in the job file)

Then a script:

for i in `seq 1 10` # Repeat runs to observe variation.
do
 for depth in 1 2 4 8 16 32 # Increase iodepth
 do
  IODEPTH=$depth fio <job file>
 done
done
  

I also would use options like write_lat_log to visualize what is
happening.

The goal would be to obtain, not a single iops number, but maximum,
minimum, average and their variation depending on the chosen
parameter and see what seems to be a stable result.

There are probably other useful things to do (I am new to fio, too).

 > Are the 140 IOPS too high for a 7.200k drive like the one I have?

I would have a look at reviews of similar disks for similar tests.
For example http://www.storagereview.com performance database for
IOMeter tests.
There is an example fio job (iometer-file-access-server) which
mimics this test.

Some remarks:

 > [root@iotest ~]# dd if=/dev/zero of=/dev/sdd bs=512 count=1000 oflag=direct

I have observed variability in dd tests, you may want to do such tests
in a loop.  There are several others dd in sg3_utils, you may want to
try some and see if you get similar results.

 >   sdd: ios=0/1467, merge=0/1, ticks=0/651445, in_queue=651760, util=99.16%

I would use a test which drives util to 100%
 
-- 
solofo

