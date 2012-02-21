Return-Path: <fio-owner@vger.kernel.org>
Received: from xyratex197.xyratex.com ([194.131.166.197]:29378 "EHLO
	XY01EX21.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752945Ab2BUUcp convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 21 Feb 2012 15:32:45 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: zone skipping and graphing  question
Date: Tue, 21 Feb 2012 12:32:41 -0800
Message-ID: <0FEAAA2D70C89D49A62173478A6C4A5D02CFB39E@XYUS-EX22.xyus.xyratex.com>
From: "Roger Sibert" <Roger_Sibert@us.xyratex.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello Everyone,

I was going through the documentation to try and chase down a specific use =
case for a performance tool.=EF=BF=BD Historically speaking when you deal w=
ith a disk that has spindles etc ... the performance drops off as you get f=
urther out the disk.=20

In looking at the disk/zone profile provided with the fio source we use a z=
one size of 256m and then a zoneskip of 2G.=EF=BF=BD If I read the man page=
 correctly that could be taken to mean we aren't actually testing on the 2G=
 boundaries but rather 256M+2G=3D2.25G+256M+2G=3D4.5G etc ... =EF=BF=BD=EF=
=BF=BDSo any help in clarifying this would be great.=EF=BF=BD=20

No matter how you look at or interpret that if you try and compare the resu=
lts and graph them against an increasing iodepth or block size you tend to =
find that the time of the run changes which makes doing an apples to apples=
 comparison rather difficult.=EF=BF=BD To get around that the runtime optio=
n looks like what you would want to run, well that and time_based.=EF=BF=BD=
=20

What I am trying to understand or figure out is if there is a way to define=
 the following behavior using the currently available options (fio 2.0)
Starting at boundary W spend X# of seconds exercising a Y size zone =EF=BF=
=BDthen skip to the next boundary and do it all over again.=EF=BF=BD=20

Ideally that gives you graphs you can map against each other and have a rel=
atively good chance of the total run lengths (time) being the same.

Thanks,
Roger

