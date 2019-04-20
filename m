Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f45.google.com ([209.85.222.45]:34229 "EHLO
        mail-ua1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbfDTI7e (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 20 Apr 2019 04:59:34 -0400
Received: by mail-ua1-f45.google.com with SMTP id c6so2339597uan.1
        for <fio@vger.kernel.org>; Sat, 20 Apr 2019 01:59:34 -0700 (PDT)
MIME-Version: 1.0
From: Left Right <olegsivokon@gmail.com>
Date: Sat, 20 Apr 2019 08:59:21 +0300
Message-ID: <CAJQBtg=eBdodQUD8f=b7qmZrHM-0NZKzDLcp9tPGduJncF9zCg@mail.gmail.com>
Subject: The test screams DI, but the data seems OK
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello list!

I'm writing tests for a product that is essentially an iSCSI server. I
had the test below written without time limit at first, but since that
would make the test very long, I decided to add the limit. Once that
happened, the test suggests that there is a data integrity problem.
Surprisingly, the byte it complains about always has the same value.
I.e. not only the DI error happens all the time, it is always
incorrect in the same way, and it's not some default value you would
normally expect (like, say, all unset bits)... All of this leads me to
question whether the test is at fault, and whether the test, as
written, makes sense:


[global]
ioengine=libaio
direct=1
loops=1
size=16G
numjobs=1
verify=crc32c
log_avg_msec=1
filename=/dev/sdc

[4k-depth-1-prep]
bs=128k
iodepth=32
rw=write
do_verify=0
stonewall=1

[4k-depth-1]
bs=4k
runtime=30M
rw=randread
iodepth=1
stonewall=1
do_verify=1
write_lat_log=read-4k-depth1-lat
write_bw_log=read-4k-depth1-bw
write_iops_log=read-4k-depth1-iops

My other worry is the different block sizes in the write and read
phases as well as iodepth. The parameters for write workload are this
way to speed it up (the product works better with higher concurrency
and bigger block sizes), but I need to test reading with different
block sizes.

Thanks!

Oleg

