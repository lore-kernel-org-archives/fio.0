Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bn1bon0098.outbound.protection.outlook.com ([157.56.111.98]:32746
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752679AbbKCVhH convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 3 Nov 2015 16:37:07 -0500
From: Todd Lawall <tlawall@nexgenstorage.com>
Subject: Trying to understand a weird timeout when using fio and multipath IO
Date: Tue, 3 Nov 2015 21:22:10 +0000
Message-ID: <BN3PR1001MB11371E8F71C42CBCAD5EEC7FBC2B0@BN3PR1001MB1137.namprd10.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello,

I'm trying to understand a behavior, and I am hoping to further my
understanding of what Fio is doing.  In the specific case in question,
I'm seeing a seven minute wait in resuming IO after a failover.  In other
 variations on this job file, the seven minute wait disappears, and it
 drops back down to the 40 second wait that I see with usual IO
loads that are run.

The setup:
- I have one Windows 2012 R2 host, with two NICs.
- I have one storage array, with 2 controllers A and B, with 2 10GbE ports
   for each side, making 4 ports, with failover capability between the two
   sides.
- I have iSCSI and MPIO setup so that there is one login from each NIC to
   each side, so four sessions total for each volume.   The map looks 
   something like this:

           nic1                 nic2
           /  \                 /  \
          /    \               /    \
     side A   side B       side A  side B
     port 0   port 0       port 1  port 1

- I have the fio job below.  It is basically 256k blocks, 1 iodepth, one
   worker with 48 drives.

[global]
do_verify=0
ioengine=windowsaio
numjobs=1
iodepth=1
offset=0
direct=1
thread

[fio-0]
blocksize=256k
readwrite=rw
filename=\\.\PHYSICALDRIVE19
filename=\\.\PHYSICALDRIVE20
<snipped out the other 44 drives>
filename=\\.\PHYSICALDRIVE13
filename=\\.\PHYSICALDRIVE14
size=100%

If I alter the job in any of the following ways, IO keeps going after the
 failover period which is about 40 seconds.  To summarize:

Doesn't work:
 - multiple disks, single job, 1 iodepth

Works:
 - Single disk, one job, 1 iodepth
 - multiple disks, one job with all disks, same iodepth as # of disks (e.g.
   if there's 48 disks, iodepth is set to 48)
 - multiple disks, one job per disk, 1 iodepth

Would anyone have any idea why that one arrangement causes a
significant delay before IO is resumed?

Thanks in advance,
Todd
