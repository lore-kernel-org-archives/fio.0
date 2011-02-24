Return-Path: <fio-owner@vger.kernel.org>
Received: from mxout3.marklogic.com ([216.243.76.15]:54947 "EHLO
	Exchg-FE02.marklogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab1BXTNa convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 24 Feb 2011 14:13:30 -0500
From: Hsiao Su <Hsiao.Su@marklogic.com>
Date: Thu, 24 Feb 2011 11:13:28 -0800
Subject: using blktrace, blkparse, and fio
Message-ID: <E9E9B636B25C054B8E6B9131614B925A039043FE@EXCHG-BE.marklogic.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>


Hi,

I'm trying to use these 3 tools to capture the IO workload of an applicatio=
n.=EF=BF=BD This application uses several different IO libraries.=EF=BF=BD =
However, I'm not sure if I'm doing this right, so I've been trying to do th=
is on a much smaller scale.=EF=BF=BD For this small scale test, my workload=
 is simply to use the cp command to copy a large file onto the same filesys=
tem, then use blktrace/blkparse/fio to replay that.

Some questions:

1) Is using blkparse necessary?=EF=BF=BD I've actually found that you can s=
kip blkparse, and simply use the output of blktrace and input it into fio.=
=EF=BF=BD The result is that the replay is much much longer.=EF=BF=BD My cp=
 command took only 1.5 minutes, but if I skip blkparse, the replay via fio =
would take almost an hour.

2) Because of #1, I suspect that blkparse is a must.=EF=BF=BD So I've inclu=
ded the blkparse step.=EF=BF=BD But when I replay it via fio on the same de=
vice, it took about 4-5 minutes.=EF=BF=BD Does this sound about right?=EF=
=BF=BD Should I expect the fio replay to be 3-4 times longer than the origi=
nal workload?=EF=BF=BD I was expecting that their time should be the same.

3) I'm seeing so possible file system corruption now.=EF=BF=BD When I remov=
e a file, I get an Input/Output Error.=EF=BF=BD Is this possibly due to wha=
t I had done in #1 and #2?=EF=BF=BD In general, when using fio, what steps =
should I take to prevent a file system corruption?


---
Hsiao "Shao" Su
MarkLogic
Senior Performance Engineer
650 287 2545 (W)

