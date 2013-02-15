Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:42856 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759774Ab3BOAmL (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 14 Feb 2013 19:42:11 -0500
Received: by mail-vc0-f173.google.com with SMTP id fy7so1905049vcb.32
        for <fio@vger.kernel.org>; Thu, 14 Feb 2013 16:42:10 -0800 (PST)
MIME-Version: 1.0
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Thu, 14 Feb 2013 18:41:30 -0600
Message-ID: <CAB-428mYVHp-e__Dn6C6TKWp_brhfqK6ioZE=vUhpgZY3u_88Q@mail.gmail.com>
Subject: Error in reporting progress
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello

I am using fio to test very slow device over the network and for some
reason fio report wrong progress numbers like this continuesly, I was
wondering if it is fio issue or my test environment issue :

Jobs: 1 (f=1): [W] [5000.0% done] [0K/0K /s] [0/0 iops] [eta 1158050441d:06h:59m
Jobs: 1 (f=1): [W] [2550.0% done] [0K/0K /s] [0/0 iops] [eta 1158050441d:06h:59m
Jobs: 1 (f=1): [W] [2550.0% done] [0K/0K /s] [0/0 iops] [eta 1158050441d:06h:59m
Jobs: 1 (f=1): [W] [2550.0% done] [0K/0K /s] [0/0 iops] [eta 1158050441d:06h:59m
Jobs: 1 (f=1): [W] [5100.0% done] [0K/0K /s] [0/0 iops] [eta 1158050441d:06h:59m
Jobs: 1 (f=1): [W] [2600.0% done] [0K/0K /s] [0/0 iops] [eta 1158050441d:06h:59m
Jobs: 1 (f=1): [W] [2600.0% done] [0K/0K /s] [0/0 iops] [eta 1158050441d:06h:59m
Jobs: 1 (f=1): [W] [2600.0% done] [0K/0K /s] [0/0 iops] [eta 1158050441d:06h:59m
Jobs: 1 (f=1): [W] [5200.0% done] [0K/0K /s] [0/0 iops] [eta 1158050441d:06h:59m
Jobs: 1 (f=1): [W] [2650.0% done] [0K/0K /s] [0/0 iops] [eta 1158050441d:06h:


This is the final stats :



job1: (groupid=0, jobs=1): err= 0: pid=31327
  write: io=131072KB, bw=1002KB/s, iops=7, runt=130783msec
    slat (usec): min=19, max=154249, avg=123499.18, stdev=26192.54
    clat (msec): min=4302, max=130782, avg=69341.64, stdev=37581.22
    bw (KB/s) : min=    0, max=    0, per=0.00%, avg= 0.00, stdev= 0.00
  cpu          : usr=0.01%, sys=0.05%, ctx=1025, majf=0, minf=30
  IO depths    : 1=0.1%, 2=0.2%, 4=0.4%, 8=0.8%, 16=1.6%, 32=3.1%, >=64=93.8%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=100.0%
     issued r/w: total=0/1024, short=0/0

     lat (msec): >=2000=100.00%

Run status group 0 (all jobs):
  WRITE: io=131072KB, aggrb=1002KB/s, minb=1026KB/s, maxb=1026KB/s, mint=130783m
sec, maxt=130783msec

Disk stats (read/write):
  sde: ios=0/31702, merge=0/0, ticks=0/129341750, in_queue=131420800, util=98.79



This is my job file :
      1 ; -- start job file --
      2 [global]
      3 rw=write
      4 size=128M
      5
      6 [job1]
      7 ioengine=libaio
      8 iodepth=8192
      9 bs=128k
     10 direct=1
     11 numjobs=1
     12 filename=/dev/sde
     13 ; -- end job file --
