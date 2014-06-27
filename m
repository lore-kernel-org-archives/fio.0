Return-Path: <fio-owner@vger.kernel.org>
Received: from mailsrv.s3group.com ([193.120.90.35]:49384 "EHLO
	mailsrv.s3group.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbaF0HAk (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 27 Jun 2014 03:00:40 -0400
Received: from avsrvd.s3group.com (avsrvd.s3group.com [193.120.90.37])
        by mailsrv.s3group.com  with ESMTP id s5R70WK6008313
        for <fio@vger.kernel.org>; Fri, 27 Jun 2014 08:00:32 +0100
Received: from avsrvd.s3group.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2A4FC15005D
	for <fio@vger.kernel.org>; Fri, 27 Jun 2014 08:00:32 +0100 (IST)
Received: from EXDUB2.dublin.ad.s3group.com (unknown [193.120.89.80])
	by avsrvd.s3group.com (Postfix) with ESMTP id 1BC64150052
	for <fio@vger.kernel.org>; Fri, 27 Jun 2014 08:00:32 +0100 (IST)
Message-ID: <53AD168F.3070403@s3group.com>
Date: Fri, 27 Jun 2014 08:00:31 +0100
From: "Frank D'Arcy" <frank.darcy@s3group.com>
MIME-Version: 1.0
Subject: using fio client on 64-bit machine with fio server on 32-bit machine
Content-Type: text/plain;
	charset="ISO-8859-1";
	format="flowed"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
I've been playing around with fio (which is really great thanks)
with a view to testing hard disks on set-top boxes (which I don't have yet)
and as prep for this I created a test environment consisting of
2 x virtual machines running 32-bit ubuntu (using "hashicorp/precise32" 
from vagrant cloud)
running on a 64-bit machine with ubuntu 12.04.

I started fio (v2.1.10) running in server mode on both virtual machines 
as follows
$ fio --server=,8880

and launched 2 fio (v2.1.10) instances in client mode on the host 64-bit 
machine,
$ fio --client=ip:127.0.0.1,8882 test.fio
$ fio --client=ip:127.0.0.1,8881 test.fio
where ports 8881 and 8882 are forwarded to port 8880 on each VM

The sample test.fio (below) runs for 25 seconds
but the values printed by the clients look garbled.
eg. runtime is a huge number ("runt= 107374182400000msec")

Same issue is seen when I switched to using latest fio from "git clone"
and the same issue is seen with all output formats (json, terse, normal)

I changed one of the virtual machines to 64-bit ubuntu (using 
"hashicorp/precise64" from vagrant cloud)
and the client talking to the fio server on that VM gave the correct 
results (eg. "runt= 25001msec")
while the client talking to the 32-bit ubuntu VM continued to show 
garbled values.

So it looks like support is not there for client-server setups on 
non-matching architectures ?
eg. 32-bit client to 64-bit server in this case,
and perhaps endianess differences would be a problem too? ( but I 
haven't tried that )

Apologies if I've missed this issue raised elsewhere, I did a quick 
search and found no mention of it.
It's not critical for us, as the simple workaround is to run fio 
standalone on each set-top box
outputting results to a file and pulling the file back to a central 
machine for parsing.
Just wanted to raise it if its unknown to you.

Thanks very much,
Frank





my test ....

[global]
;run for 25 seconds
runtime=25
time_based=1
;directory in which to create files
directory=.
size=1024k
log_avg_msec=500

[job1]
name=job1_stb1
description=Job1 Description
rw=read
blocksize=2
rate=1k
write_bw_log=job1_stb1
write_lat_log=job1_stb1
write_iops_log=job1_stb1


[job2]
name=job2_stb1
description=Job2 Description
rw=write
blocksize=2
rate=500
write_bw_log=job2_stb1
write_lat_log=job2_stb1
write_iops_log=job2_stb1





-- 
Frank D'Arcy
S3 Group Ltd.   South County Business Park, Leopardstown, Dublin 18, Ireland
Visit S3 website: www.s3group.com
-----

The information contained in this e-mail and in any attachments is confidential and is designated solely for the attention of the intended recipient(s). If you are not an intended recipient, you must not use, disclose, copy, distribute or retain this e-mail or any part thereof. If you have received this e-mail in error, please notify the sender by return e-mail and delete all copies of this e-mail from your computer system(s). Please direct any additional queries to: communications@s3group.com. Thank You. Silicon and Software Systems Limited (S3 Group). Registered in Ireland no. 378073. Registered Office: South County Business Park, Leopardstown, Dublin 18.

