Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.thomas-krenn.com ([217.7.54.186]:36726 "EHLO
	mail.thomas-krenn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab2KSRxw (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 19 Nov 2012 12:53:52 -0500
Received: from iris.tks.local (iris.tks.local [192.168.10.63])
	by mail.thomas-krenn.com (Postfix) with ESMTP id 3B9A8DFE4E
	for <fio@vger.kernel.org>; Mon, 19 Nov 2012 18:46:23 +0100 (CET)
Received: from zimbra.thomas-krenn.com (hercules.tks.local [192.168.110.28])
	by iris.tks.local (Postfix) with ESMTP id DB13D3FC4B
	for <fio@vger.kernel.org>; Mon, 19 Nov 2012 18:46:22 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.thomas-krenn.com (Postfix) with ESMTP id D71DA6FC0CD
	for <fio@vger.kernel.org>; Mon, 19 Nov 2012 18:46:22 +0100 (CET)
Received: from zimbra.thomas-krenn.com ([127.0.0.1])
	by localhost (zimbra.thomas-krenn.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YTSgZeLoFfUn for <fio@vger.kernel.org>;
	Mon, 19 Nov 2012 18:46:22 +0100 (CET)
Received: from zimbra.thomas-krenn.com (zimbra.thomas-krenn.com [127.0.1.1])
	by zimbra.thomas-krenn.com (Postfix) with ESMTP id 7DD236FC0D1
	for <fio@vger.kernel.org>; Mon, 19 Nov 2012 18:46:22 +0100 (CET)
Date: Mon, 19 Nov 2012 18:46:22 +0100 (CET)
From: Georg =?utf-8?Q?Sch=C3=B6nberger?= 
	<gschoenberger@thomas-krenn.com>
Message-ID: <46391624.39675.1353347182440.JavaMail.root@thomas-krenn.com>
In-Reply-To: <1364943454.39595.1353345861273.JavaMail.root@thomas-krenn.com>
Subject: io_u error using offsets
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I am trying to divide a 4TB hard disk into 128 equal parts. Therefore I divide the disk size (in Bytes) with 128 - this is my increment size. Then I start several fio job rounds with the offset increasing every round by the increment. Unfortunately I get an error for the first offset not equal to 0.
I suppose this is an issue with the offsets not being correctly aligned.
Here is my call to fio:
$ sudo /usr/local/bin/fio --rw=randrw --name=wd --offset=31256148672 --direct=1 --bs=64k --filename=/dev/sdi --rwmixread=100 --numjobs=1 --ioengine=libaio --runtime=60 --iodepth=16 --size=31256148672 --group_reporting --debug=all

Here is the error message and the debug output:
[...]
random   18174 off rand 2400737531
random   18174 free: b=266586, idx=4165, bit=26
random   18174 free: b=266586, idx=4165, bit=26
io       18174 fill_io_u: io_u 0x16ed510: off=48727128768/len=65536/ddir=0//dev/sdi
io       18174 prep: io_u 0x16ed510: off=48727128768/len=65536/ddir=0//dev/sdi
io       18174 ->prep(0x16ed510)=0
io       18174 queue: io_u 0x16ed510: off=48727128768/len=65536/ddir=0//dev/sdi
io       18174 calling ->commit(), depth 16
io       18174 io_u_queued_completed: min=1
io       18174 getevents: 1
io       18174 io complete: io_u 0x16eff80: off=33141291712/len=65536/ddir=0//dev/sdi
fio: io_u error on file /dev/sdi: Invalid argument
     read offset=33141291712, buflen=65536
file     18174 put file /dev/sdi, ref=17
io       18174 io_u_queued_completed: min=0
io       18174 getevents: 1
io       18174 io complete: io_u 0x16efcb0: off=54394616512/len=65536/ddir=0//dev/sdi
fio: io_u error on file /dev/sdi: Invalid argument
     read offset=54394616512, buflen=65536
file     18174 put file /dev/sdi, ref=16
fio: pid=18174, err=22/file:io_u.c:1305, func=io_u error, error=Invalid argument
file     18174 close files
file     18174 put file /dev/sdi, ref=15

I am happy with any suggestions =)
Best regards Georg
