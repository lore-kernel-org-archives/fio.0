Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33216 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbcFFVlK (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 6 Jun 2016 17:41:10 -0400
Received: by mail-oi0-f50.google.com with SMTP id k23so247709882oih.0
        for <fio@vger.kernel.org>; Mon, 06 Jun 2016 14:41:10 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 7 Jun 2016 00:41:09 +0300
Message-ID: <CAKapHkMhGrnb1g=b9Pz_D_Frx8OSP65aiXBBM_KgVy5wpSz-kw@mail.gmail.com>
Subject: System IOPS vs. fio IOPS
From: Karan Singh <karan@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Guys need pointer on calculating disk IOPS at OS level ( using command
, such as iostat etc )

I am running a FIO job and at the same time monitoring bandwidth /
IOPS using iostat command. What i found is FIO reports total IOPS as
431 ( 215 read , 216 write, see below output ) , but iostat r/s and
w/s reports in the magnitude of a few thousands.
So my query is

#1  : Is r/s and w/s fields in iostat output corresponds to read and
write IOPS ? ( https://serverfault.com/questions/342273/disk-iops-count-in-gnu-linux
mentions r/s and w/s as IOPS)
#2  : If yes then why does they dont match with FIO IOPS results ?
#4  : Whats your favourite command / tool to monitor system IOPS ?


# fio --filename=/dev/nvme0n1 --name=rw-4M --rw=rw --ioengine=libaio
--bs=4M --numjobs=1 --direct=1 --randrepeat=0  --iodepth=1
--runtime=300 --ramp_time=5 --size=100G --group_reporting

read : io=46744MB, bw=882011KB/s, iops=215, runt= 54269msec

write: io=47028MB, bw=887370KB/s, iops=216, runt= 54269msec



# iostat -xk 3 /dev/nvme0n1



Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util

nvme0n1           0.00     0.00 6805.33 6973.67 871082.67 892629.33
256.00    17.67    1.28    1.67    0.90   0.07  98.33



avg-cpu:  %user   %nice %system %iowait  %steal   %idle

           0.04    0.00    0.29    0.00    0.00   99.67

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util

nvme0n1           0.00     0.00 6688.00 7051.00 856064.00 902528.00
256.00    17.90    1.30    1.72    0.91   0.07  98.30



avg-cpu:  %user   %nice %system %iowait  %steal   %idle

           0.05    0.00    0.23    0.00    0.00   99.72

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util

nvme0n1           0.00     0.00 6709.33 7136.00 858794.67 913408.00
256.00    17.90    1.29    1.71    0.90   0.07  97.90


avg-cpu:  %user   %nice %system %iowait  %steal   %idle

           0.04    0.00    0.32    0.00    0.00   99.64

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util

nvme0n1           0.00     0.00 6880.00 6851.33 880640.00 876970.67
256.00    17.92    1.31    1.71    0.90   0.07  98.47


Many thanks

Karan
