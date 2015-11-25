Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:33716 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbbKYTga convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 25 Nov 2015 14:36:30 -0500
Received: from mail.micron.com (bowex36-d.micron.com [137.201.85.144])
	by mailout.micron.com (8.14.4/8.14.6) with ESMTP id tAPJaTb2022340
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL)
	for <fio@vger.kernel.org>; Wed, 25 Nov 2015 12:36:29 -0700
From: "Deyoung Hong (dhong)" <dhong@micron.com>
Subject: Bug using ramp_time shows cpu over 100%
Date: Wed, 25 Nov 2015 19:36:29 +0000
Message-ID: <ed17d1a2eea2407cb00badb46a05a386@BOWEX36-B.micron.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I think this is an fio bug.

Description:   When specifying ramp_time, cpu may show over 100% (when using a polling mode driver).
If ramp_time is not specified, cpu values appear to be correct.  
You normally don't see this problem because most drivers don't utilize high CPU usage. 
You will have to use some custom driver that does polling, for example (something like http://www.dpdk.org/).

OS:  Any (but tested on Linux CentOS 6.6)

---------
Job file:

[global]
thread=1
group_reporting=1
direct=1
ioengine=libaio
time_based=1
ramp_time=10
runtime=10
bs=4096
filename=/dev/polling

[test]
rw=read
numjobs=1
iodepth=1

-------------
Fio output:

test: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1
fio-2.2.12
Starting 1 thread

test: (groupid=0, jobs=1): err= 0: pid=27094: Wed Nov 25 11:23:07 2015
  read : io=486652KB, bw=48660KB/s, iops=12165, runt= 10001msec
    slat (usec): min=0, max=16, avg= 2.15, stdev= 0.60
    clat (usec): min=34, max=2323, avg=79.77, stdev=20.54
     lat (usec): min=36, max=2325, avg=81.79, stdev=20.54
    clat percentiles (usec):
     |  1.00th=[   58],  5.00th=[   66], 10.00th=[   69], 20.00th=[   73],
     | 30.00th=[   74], 40.00th=[   74], 50.00th=[   76], 60.00th=[   85],
     | 70.00th=[   88], 80.00th=[   89], 90.00th=[   90], 95.00th=[   91],
     | 99.00th=[   92], 99.50th=[   93], 99.90th=[   94], 99.95th=[  121],
     | 99.99th=[ 1048]
    bw (KB  /s): min=    0, max=48904, per=95.03%, avg=46242.40, stdev=10885.36
    lat (usec) : 50=0.92%, 100=99.01%, 250=0.05%, 500=0.01%, 750=0.01%
    lat (usec) : 1000=0.01%
    lat (msec) : 2=0.01%, 4=0.01%
  cpu          : usr=164.11%, sys=4.55%, ctx=27, majf=0, minf=3013
  IO depths    : 1=163.5%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=121663/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: io=486652KB, aggrb=48660KB/s, minb=48660KB/s, maxb=48660KB/s, mint=1000
1msec, maxt=10001msec

