Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:41337 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab3INBEd (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 13 Sep 2013 21:04:33 -0400
Received: by mail-lb0-f172.google.com with SMTP id x18so2619145lbi.17
        for <fio@vger.kernel.org>; Fri, 13 Sep 2013 18:04:31 -0700 (PDT)
MIME-Version: 1.0
From: "Brian L." <brianclam@gmail.com>
Date: Fri, 13 Sep 2013 18:04:11 -0700
Message-ID: <CAAAK+WVk9ch4PNrfUb8LHwp800T-qTXbH7tr_Tj9GvZh8a0J1A@mail.gmail.com>
Subject: output mutating on me
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Just want to seek some advice as this is driving me crazy and I have a
deadline fast approaching so I am not sure if I can completely change
course at this point.

So here's the situation - it looks like different run of fio is giving
me different output.  The outputs are mutating (reproducible) on me so
it broken my parser and more importantly, my data because I depend on
"Completion latency" ('clat') for my calculation.  Ugh.  Maybe if I
use '--minimal' during the run, it might be better but I am too commit
to change at this point.

Note below: the 'clat (usec): min=...' line is missing from the first run.

Here's are run examples:


(1st run example)
===
 {mydisk}- {myrw}- {myiodepth}- {myblocksize}
/dev/sdb-randrw-32-1024K
===
mytest: (g=0): rw=randrw, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=32
fio-2.1
Starting 1 process

mytest: (groupid=0, jobs=1): err= 0: pid=24678: Thu Sep 12 18:24:13 2013
  read : io=1058.0MB, bw=169095KB/s, iops=165, runt=  6407msec
    slat (usec): min=83, max=327, avg=122.89, stdev=12.20 <-- (### My
comment ###) - What happened to 'clat' and 'lat' after this line?  See
2nd run example where the lines are there.
    clat percentiles (usec):
     |  1.00th=[    0],  5.00th=[    0], 10.00th=[    0], 20.00th=[    0],


(2nd run example)
===
 {mydisk}- {myrw}- {myiodepth}- {myblocksize}
/dev/sdb-randrw-32-64K
===
mytest: (g=0): rw=randrw, bs=64K-64K/64K-64K/64K-64K, ioengine=libaio,
iodepth=32
fio-2.1
Starting 1 process

mytest: (groupid=0, jobs=1): err= 0: pid=24344: Thu Sep 12 18:19:41 2013
  read : io=1308.9MB, bw=76522KB/s, iops=1194, runt= 17515msec
    slat (usec): min=10, max=205, avg=13.91, stdev= 2.69
    clat (usec): min=867, max=31655, avg=14835.72, stdev=3382.80 <--
(### My comment ###) - This line is missing from above
     lat (usec): min=887, max=31671, avg=14849.32, stdev=3382.55 <--
(### My comment ###) - This line is missing from above
    clat percentiles (usec):
     |  1.00th=[ 8384],  5.00th=[ 9664], 10.00th=[10560], 20.00th=[11712],


Keeping everything constant, the different is different on higher
blocksize - this is reproducible.  Any suggestion / advice here?


Here's my fio template - I am looping thru different values for $myrw,
$mydisk, $myblocksize:

[mytest]
rw=${myrw}
filename=${mydisk}
size=2G
iodepth=${myiodepth}
bs=${myblocksize}
ioengine=libaio
ramp_time=10s
direct=1
end_fsync=0
invalidate=1

Brian L.
