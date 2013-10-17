Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:38058 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861Ab3JQSgL (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 17 Oct 2013 14:36:11 -0400
Received: by mail-lb0-f177.google.com with SMTP id w7so2247484lbi.36
        for <fio@vger.kernel.org>; Thu, 17 Oct 2013 11:36:09 -0700 (PDT)
MIME-Version: 1.0
From: "Brian L." <brianclam@gmail.com>
Date: Thu, 17 Oct 2013 11:35:49 -0700
Message-ID: <CAAAK+WU-XC-aqAU4iCPLnKLLgAwtKmXMe2NKzGjFRvL34PcsjQ@mail.gmail.com>
Subject: running FIO w/ 2 parallel processes on the same disk
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello there,

I would like to simulate the following workload - 2 process total that
is contenting for read / write IO on the same disk:

1 process is doing a sequential writes
1 process is down random reads

This is my FIO job file:

## job file start ##

[global]
filename=${mydisk}
size=5G
iodepth=${myiodepth}
bs=${myblocksize}
ioengine=libaio
ramp_time=10s
norandommap=1
randrepeat=0
refill_buffers
group_reporting=1
direct=1
end_fsync=0
invalidate=1
nice=0
prio=0
prioclass=1

[process_1_seq_write]
rw=write
write_bw_log=process_1_seq_write.${mydisksub}

[process_2_rand_read]
rw=randread
write_bw_log=process_2_rand_read.${mydiskzub}

## job file end ##

I have ran it and it looks right but just want to check with someone
else to valid that it is correct.

Brian L.
