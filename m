Return-Path: <fio-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:34135 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbfHRXBp (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 18 Aug 2019 19:01:45 -0400
Received: from [10.132.208.18] ([107.92.58.20]) by mrelay.perfora.net
 (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id 1MhTl1-1iUOoJ0F1P-00egW0
 for <fio@vger.kernel.org>; Mon, 19 Aug 2019 00:56:44 +0200
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
        charset=us-ascii
From: Eliezer Nebab <eliezer@integritech.solutions>
Mime-Version: 1.0 (1.0)
Subject: Total latency (lat) of a workload test
Message-Id: <A6EB8C9D-45E9-4BB4-8F69-3FFFBD326B47@integritech.solutions>
Date: Sun, 18 Aug 2019 17:56:42 -0500
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I have the following workload:

fio --randrepeat=1 --ioengine=libaio --direct=1 --sync=1 --name=test --filename=random_readwrite_test.fio --overwrite=1 --iodepth=64 --size=5GB --readwrite=randrw --rwmixread=50 --rwmixwrite=50 --bs=32k --runtime=60 --time_based --ramp_time=15

With the following result:

read : io=1949.4MB, bw=33249KB/s, iops=1038 , runt= 60035msec
    slat (usec): min=4 , max=30100 , avg=23.92, stdev=240.73
    clat (msec): min=1 , max=80 , avg=31.59, stdev= 8.94
     lat (msec): min=1 , max=80 , avg=31.61, stdev= 8.94

 write: io=1830.3MB, bw=31219KB/s, iops=975 , runt= 60035msec
    slat (usec): min=5 , max=30150 , avg=35.61, stdev=293.88
    clat (msec): min=1 , max=80 , avg=31.91, stdev= 8.82
     lat (msec): min=1 , max=80 , avg=31.95, stdev= 8.81

This is a 2000 iops iscsi. The read operation shows a 31.61 (msec) lat and the write operation at 31.95 (msec).  What is the correct way to interpret the total latency of this fio workload?  Do you add the read lat (31.61) plus write lat (31.95) to get the overall latency for this workload?

Thanks in advance for your input.

Eliezer

