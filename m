Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yb0-f177.google.com ([209.85.213.177]:42609 "EHLO
        mail-yb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbeHXOYa (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 24 Aug 2018 10:24:30 -0400
Received: by mail-yb0-f177.google.com with SMTP id z12-v6so3311000ybg.9
        for <fio@vger.kernel.org>; Fri, 24 Aug 2018 03:50:24 -0700 (PDT)
MIME-Version: 1.0
From: Mohanraj B <bmohanraj91@gmail.com>
Date: Fri, 24 Aug 2018 16:20:23 +0530
Message-ID: <CAFF4W0Xhk_UArnwAMdj_GY_ZRxEtZG+5tE-0yn+5_qdHGQgftg@mail.gmail.com>
Subject: Understaning direct option in fio for rw=read and rw=randread.
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I have few query on fio direct=0/1 option.

fio version: fio-3.8-88-ge971
linux version: Ubuntu 18.04 4.15.0-29-generic

Below are the job files that I am testing and its output snippet.

Job file1: read_bypass_cache.fio

[read_bypass_cache]
rw=read
ioengine=sync
size=10MB
filename=read_file

Output snippet of multiple runs:
           read issued = 2560
Run1:  sda: ios=8/0, merge=0/0, ticks=820/0, in_queue=1040, util=86.14%
Run2:  sda: ios=39/0, merge=0/0, ticks=240/0, in_queue=268, util=57.38%
Run3:  sda: ios=39/0, merge=0/0, ticks=248/0, in_queue=276, util=59.02%

Above job files seems working fine, io hits the cache and not the file
for read operation.


Job file2: randread_bypass_cache.fio

[randread_bypass_cache]
rw=randread
ioengine=sync
size=10MB
filename=randread_file

Output snippet of multiple runs:
read issued: 2560
 sda: ios=2227/0, merge=0/0, ticks=2500/0, in_queue=2500, util=88.97%
 sda: ios=2148/7, merge=0/3, ticks=1200/76, in_queue=1276, util=80.64%
 sda: ios=2137/0, merge=0/0, ticks=1196/0, in_queue=1196, util=80.16%

Why when rw=randread and direct=0(by default) is set, io still hitting
file for read operation instead of cache?
As 2560-2227= 333 only accessed from cache.


set direct=1 option in below file.
Job file3: randread_bypass_cache_direct.fio

[randread_bypass_cache]
rw=randread
direct=1
ioengine=sync
size=10MB
filename=randread_file_direct

Output snippet of multiple runs:
  read issued: 2560
  sda: ios=2343/0, merge=0/0, ticks=3692/0, in_queue=3692, util=92.65%
  sda: ios=2334/0, merge=0/0, ticks=1896/0, in_queue=1896, util=84.57%
  sda: ios=2365/0, merge=0/0, ticks=1940/0, in_queue=1940, util=86.57%

Actually there is not much difference in sda ios when direct =0 and
direct=1 is set rw=randread.
Is it how io randread suppose to work?

Thanks and Regards,
Mohan

