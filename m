Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.skyera.com ([12.226.156.243]:36670 "EHLO bmx.skyera.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751341AbaEFSj4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 6 May 2014 14:39:56 -0400
Received: from mail.skyera.com (windowshome.storcloudinc.local [10.1.1.5]) by bmx.skyera.com with ESMTP id XqrVY4XpEHDrz3n2 for <fio@vger.kernel.org>; Tue, 06 May 2014 11:25:02 -0700 (PDT)
Message-ID: <536928FE.6020109@skyera.com>
Date: Tue, 6 May 2014 11:25:02 -0700
From: Stoo Davies <sdavies@skyera.com>
MIME-Version: 1.0
Subject: Meta verification regression starting with fio 2.1.5
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm doing some powerfail recovery testing on a storage array over iSCSI.
Host is RHEL 6.4 kernel 2.6.32-358.el6.x86_64.

With fio 2.1.2 -> 2.1.4 the job file below rides through the disks going 
away, and continues I/O after they come back, without reporting any errors.
With fio 2.1.5 -> 2.1.8 when the disks come back fio immediately reports 
a meta verification error.

I captured a trace with an finisar analyzer, and can see that after the 
disks come back and the host logs back in, a read is issued for an lba 
which was never written to.
Since I don't see verification errors outside of the powerfail testing, 
I suspect fio isn't correctly handling failed writes during the time the 
disks are unavailable.

The trace file is rather large, but I can make it available if you need 
to see it.

[whee]
bs=8k
thread=4
time_based=1
runtime=864000
readwrite=randrw
direct=1
iodepth=128
ioengine=libaio
size=100%
verify=meta
do_verify=1
verify_fatal=1
verify_dump=1
verify_backlog=8192
buffer_compress_percentage=95
ignore_error=ENODEV:EIO,ENODEV:EIO,ENODEV:EIO
filename=/dev/mapper/lun0
.
.
filename=/dev/mapper/lun9

