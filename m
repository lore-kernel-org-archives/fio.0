Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36901 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753183AbdCXRj0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 24 Mar 2017 13:39:26 -0400
Received: by mail-wm0-f50.google.com with SMTP id n11so8033591wma.0
        for <fio@vger.kernel.org>; Fri, 24 Mar 2017 10:39:25 -0700 (PDT)
MIME-Version: 1.0
From: Tarek <cashew250@gmail.com>
Date: Fri, 24 Mar 2017 12:39:24 -0500
Message-ID: <CAOHuL9g1C3ust1x-ksye=EHtwh93MU29QdY=Box2CJsv=49DNw@mail.gmail.com>
Subject: Clat min zero on Randread?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Clat min is zero on a random read, how is that possible when NAND tR
spec is 20-60uS? Also isn't lat = slat + clat,  1 + 0 != 84

fio-2.15
Starting 80 threads

random-100r-0w_4k_qd1_jobs_16: (groupid=0, jobs=16): err= 0:
pid=22233: Tue Feb 21 15:41:33 2017
  Description  : [Random R/W 100/0 QD1 BLK 4k Jobs 16]
  read : io=1045.5GB, bw=609017KB/s, iops=152254, runt=1800001msec
    slat (usec): min=1, max=6583, avg= 2.06, stdev= 1.01
    clat (usec): min=0, max=8728, avg=102.38, stdev=21.43
     lat (usec): min=84, max=8730, avg=104.52, stdev=21.45
    clat percentiles (usec):
     |  1.00th=[   85],  5.00th=[   86], 10.00th=[   87], 20.00th=[   89],
     | 30.00th=[   91], 40.00th=[   98], 50.00th=[  101], 60.00th=[  102],
     | 70.00th=[  104], 80.00th=[  106], 90.00th=[  116], 95.00th=[  143],
     | 99.00th=[  175], 99.50th=[  185], 99.90th=[  225], 99.95th=[  239],
     | 99.99th=[  270]


Fio Config:
thread
bs=4k
ioengine=libaio
direct=1
buffered=0
log_avg_msec=1000
group_reporting=1
rw=randread
numjobs=16
iodepth=1
time_based
runtime=1800
refill_buffers
norandommap
filename=/dev/nvme0n1
