Return-Path: <fio-owner@vger.kernel.org>
Received: from nm23-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.153]:25892 "EHLO
	nm23-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753152Ab3KTCQD convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 19 Nov 2013 21:16:03 -0500
References: <1384903429.33093.YahooMailNeo@web120804.mail.ne1.yahoo.com> <1384903569.45715.YahooMailNeo@web120806.mail.ne1.yahoo.com> <528BF8BD.4080208@nellans.org>
Message-ID: <1384913761.82415.YahooMailNeo@web120803.mail.ne1.yahoo.com>
Date: Tue, 19 Nov 2013 18:16:01 -0800 (PST)
From: "K.R Kishore" <krkishore@yahoo.com>
Reply-To: "K.R Kishore" <krkishore@yahoo.com>
Subject: Re: fio results show sequential reads and writes better for network block device than local block device?
In-Reply-To: <528BF8BD.4080208@nellans.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: David Nellans <david@nellans.org>, "fio@vger.kernel.org" <fio@vger.kernel.org>



David
Thanks for the response..



> 278MB/s read bandwidth to a locally attached samsung 840 pro on 1M=20
> sequential reads is very low unless you have it accidentally plugged=20
> into a SATA 3Gb/s port instead of a 6Gb/s.=EF=BF=BD I'd sort out why you'=
re not=20
> seeing 500 MB+ on this as starting point for your investigation.

I thought this was a good catch..so I tried=EF=BF=BD
hdparm -I /dev/sdb|egrep -i "Model|speed" and I get the same on both machin=
es..


[root@lab-sj1-141 uc]# hdparm -I /dev/sdb|egrep -i "Model|speed"
=EF=BF=BD =EF=BF=BD Model Number: =EF=BF=BD =EF=BF=BD =EF=BF=BD Samsung SSD=
 840 PRO Series =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 =EF=BF=BD
=EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD* =EF=BF=BD =EF=
=BF=BDGen1 signaling speed (1.5Gb/s)
=EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD* =EF=BF=BD =EF=
=BF=BDGen2 signaling speed (3.0Gb/s)
[root@lab-sj1-141 uc]#=EF=BF=BD

Does this imply they are running @3.0Gb/s with a peak rate of 300MB/s?
I am using Dell Precision workstation T3600 and according to the specs it h=
as 6G SAS ports which is where these drives are connected. I am not sure if=
 this needs to be enabled some way. I rebooted and went through BIOS settin=
g and did not see anything in the drives/storage sections.

I ran the test on both machines and both got ~279MB/s for sequential reads.=
 This does not explain why fio gives a higher number when one of the drives=
 is exported over the network?!

> Also, Sequential performance probably isn't what you want to look at for =

> a long latency block device (as opposed to without the network in the=20
> way) as io merging could become the dominant factor for performance even =

> when using large block sizes to start.

Your point noted. I ran all combinations of tests (read,write,readwrite,ran=
dread,randwrite,randrw) and did so with 1M and 512. I was looking for some =
consistency and trying to quantify the effect of latency on performance.=EF=
=BF=BD


> your latency data from the runs looks funny too - with the NBD latency=20
> being lower than the locally attached on writes, but not for reads.=20
> that would seem to indicate there is some buffering going on in the=20
> system that you're not aware of that is making your results noisy (and=20
> confusing)


I agree that the latency number is confusing. I am trying to understand how=
 fio is measuring the latency for a NBD and maybe that will help sort this =
out.

thx,
Kishore

