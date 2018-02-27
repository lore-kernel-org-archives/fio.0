Return-Path: <fio-owner@vger.kernel.org>
Received: from m50-133.163.com ([123.125.50.133]:51118 "EHLO m50-133.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752674AbeB0Kp4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 27 Feb 2018 05:45:56 -0500
From: "Vaughan" <cxt9401@163.com>
Subject: How to ensure split verification will generate the same configs as write phase?
Date: Tue, 27 Feb 2018 18:45:46 +0800
Message-ID: <000801d3afb8$1ffb6a10$5ff23e30$@163.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: zh-cn
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: cxt9401@163.com

Hi all,

I want fio to do an split verification for RAID as did in
https://github.com/axboe/fio/issues/468. Once written, the verification will
be repeat several times for raid recovery for each disk.

The example job file is as below:
----- write job -----
[global]
do_verify=0
iodepth=32
filename=/dev/nvme0n6
rw=randwrite
ioengine=libaio
verify=crc32c-intel
direct=1
verify_offset=100
bs=4096
[job_0]
size=209715200
offset=0

----- read job -----
[global]
do_verify=1
verify_state_load=1
iodepth=32
filename=/dev/nvme0n6
rw=read
ioengine=libaio
verify=crc32c-intel
direct=1
verify_offset=100
bs=4096

[job_0]
size=209715200
offset=0

I don't see it use the same randseed. Can it generate the same offset as
write phase without randseed= option set? 
If I use randbs= to also use an random write blocksizes, how can I ensure
the verification will do the same as write?
Can write_iolog ensure that? However, I suppose it may slow down the write
speed and randomness of test.


Regards,
Vaughan



