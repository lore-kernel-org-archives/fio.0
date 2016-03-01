Return-Path: <fio-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:62394 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbcCAFRi (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 1 Mar 2016 00:17:38 -0500
Received: from [10.60.11.138] ([63.163.107.100]) by mrelayeu.kundenserver.de
 (mreue103) with ESMTPSA (Nemesis) id 0MH5lK-1afYd620sk-00Dmnt for
 <fio@vger.kernel.org>; Tue, 01 Mar 2016 06:17:30 +0100
Message-ID: <56D525E1.6010407@vlnb.net>
Date: Mon, 29 Feb 2016 21:17:21 -0800
From: Vladislav Bolkhovitin <vst@vlnb.net>
MIME-Version: 1.0
Subject: Fio high IOPS measurement mistake
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I'm currently looking at one NVRAM device, and during fio tests noticed that each fio
thread consumes 30% of user space CPU. I'm using ioengine=libaio, buffered=0, sync=0
and direct=1, so user space CPU consumption should be virtually zero.

That 30% user CPU consumption makes me suspect that this is overhead for internal fio
housekeeping, i.e., scientifically speaking, fio instrumental measurement mistake (I
hope, I'm using correct English terms).

Can anybody comment it and suggest how to decrease this user space CPU consumption?

Here is my full fio job:

[global]
ioengine=libaio
buffered=0
sync=0
direct=1
randrepeat=1
softrandommap=1
rw=randread
bs=4k
filename=./nvram (it's a link to a block device)
exitall=1
thread=1
disable_lat=1
disable_slat=1
disable_clat=1
loops=10
iodepth=16

[file1]

[file2]

I'm working on million+ IOPS range.

Thanks,
Vlad
