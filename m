Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:53318 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3KSVcx (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 19 Nov 2013 16:32:53 -0500
Received: by mail-la0-f47.google.com with SMTP id ep20so6537960lab.20
        for <fio@vger.kernel.org>; Tue, 19 Nov 2013 13:32:52 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 19 Nov 2013 15:32:51 -0600
Message-ID: <CAEyTGCdhjZPXXbAmSdTarRMrR382AEWifMpg6d3gBwaPgCPLFw@mail.gmail.com>
Subject: FIO: Read_iolog replay doesn't start
From: Lakshmi <sendtold@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I ran the below job file and did a write_iolog to a .log file as shown below.

[Replay_Trace_Test]
rw=randread
ioengine=sync
bs=4k
iodepth=8
numjobs=1
filename=/dev/sda3:
runtime=600
write_iolog=/root/Trace_Logs/Write_Log1.log

The Write_Log1.log file looks something like this.

fio version 2 iolog
/dev/sda3 add
dev/sda3 open
/dev/sda3 read 23366979584 4096
/dev/sda3 read 286808244224 4096
/dev/sda3 read 326671769600 4096
/dev/sda3 read 182096228352 4096
/dev/sda3 read 155711512576 4096
/dev/sda3 read 325488222208 4096
/dev/sda3 read 147413901312 4096
/dev/sda3 read 136963395584 4096
/dev/sda3 read 353723068416 4096

When I try to replay this log using Read_iolog command in FIO , the
replay doesnt start and gets stuck at ,

Replay: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
fio-2.1.1
Starting 1 process


FIO version-2.1.2

I am just stuck since the console doesn't report any errors in this
case.Any pointers that would help , greatly appreciated.

Thanks,
lakshmi
