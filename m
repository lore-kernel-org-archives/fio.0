Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:27744 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbbLHVpF convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 8 Dec 2015 16:45:05 -0500
Received: from mail.micron.com (bowex36-b.micron.com [137.201.85.142])
	by mailout.micron.com (8.14.4/8.14.6) with ESMTP id tB8Lj15l031237
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL)
	for <fio@vger.kernel.org>; Tue, 8 Dec 2015 14:45:02 -0700
From: "Deyoung Hong (dhong)" <dhong@micron.com>
Subject: RE: Bug using ramp_time shows cpu over 100%
Date: Tue, 8 Dec 2015 21:45:00 +0000
Message-ID: <3ccceea7625d474b8afd2a6f6a7ab0ef@BOWEX36-B.micron.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I saw the response on http://www.spinics.net/lists/fio/msg04392.html (didn't get the email), so I'm pasting it here.

I git pulled the latest fio code and observed the specified changes.  I compiled and ran the latest code but still seeing the same problem:

===============
test: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1
fio-2.2.12-50-g5261
Starting 1 thread

test: (groupid=0, jobs=1): err= 0: pid=10726: Tue Dec  8 13:40:21 2015
  read : io=799740KB, bw=79966KB/s, iops=19991, runt= 10001msec
    slat (usec): min=0, max=11, avg= 0.10, stdev= 0.30
    clat (usec): min=26, max=2624, avg=49.03, stdev=34.07
     lat (usec): min=35, max=2624, avg=49.12, stdev=34.07
    clat percentiles (usec):
     |  1.00th=[   36],  5.00th=[   36], 10.00th=[   36], 20.00th=[   37],
     | 30.00th=[   37], 40.00th=[   38], 50.00th=[   38], 60.00th=[   39],
     | 70.00th=[   40], 80.00th=[   70], 90.00th=[   79], 95.00th=[   87],
     | 99.00th=[   92], 99.50th=[   94], 99.90th=[  225], 99.95th=[  298],
     | 99.99th=[ 2128]
    bw (KB  /s): min=    0, max=81072, per=95.01%, avg=75974.80, stdev=17896.56
    lat (usec) : 50=71.32%, 100=28.42%, 250=0.19%, 500=0.04%, 750=0.01%
    lat (usec) : 1000=0.01%
    lat (msec) : 2=0.01%, 4=0.01%
  cpu          : usr=99.99%, sys=0.00%, ctx=8, majf=0, minf=0
  IO depths    : 1=157.5%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=199935/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: io=799740KB, aggrb=79966KB/s, minb=79966KB/s, maxb=79966KB/s, mint=10001msec, maxt=10001msec


===============
Jens Axboe wrote:

On 11/25/2015 12:36 PM, Deyoung Hong (dhong) wrote:
> I think this is an fio bug.
> 
> Description:   When specifying ramp_time, cpu may show over 100% (when using a polling mode driver).
> If ramp_time is not specified, cpu values appear to be correct.
> You normally don't see this problem because most drivers don't utilize high CPU usage.
> You will have to use some custom driver that does polling, for example (something like http://www.dpdk.org/).
> 
> OS:  Any (but tested on Linux CentOS 6.6)

This should fix it:

http://git.kernel.dk/cgit/fio/commit/?id=210dd0fc66b8956065e098bb9314febe8993e849

Try current -git and hopefully it'll behave better.

--
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@xxxxxxxxxxxxxxx
More majordomo info at  http://vger.kernel.org/majordomo-info.html


