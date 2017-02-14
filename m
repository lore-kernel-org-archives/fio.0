Return-Path: <fio-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48192 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbdBNEQn (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Feb 2017 23:16:43 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcsf-fio@m.gmane.org>)
        id 1cdUXZ-0004Vl-1J
        for fio@vger.kernel.org; Tue, 14 Feb 2017 05:16:33 +0100
From: Slow bucks <frankwhitebe@gmail.com>
Subject: basic verify - output shows start with read then write?
Date: Mon, 13 Feb 2017 22:16:29 -0600
Message-ID: <o7u0an$eg4$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
        format=flowed
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Strange but during a verify job the output shows that it executed the 
verify/read operation first then write:

randw/verify: (groupid=0, jobs=1): err= 0: pid=1647: Tue Feb 14 04:08:08 2017
  read : io=10240MB, bw=64801KB/s, iops=63, runt=161816msec
    slat (usec): min=48, max=16277, avg=423.53, stdev=2263.87
    clat (msec): min=18, max=860, avg=488.46, stdev=34.60
     lat (msec): min=18, max=860, avg=488.88, stdev=34.65
    clat percentiles (msec):
     |  1.00th=[  461],  5.00th=[  461], 10.00th=[  465], 20.00th=[  478],
     | 30.00th=[  482], 40.00th=[  482], 50.00th=[  482], 60.00th=[  482],
     | 70.00th=[  498], 80.00th=[  498], 90.00th=[  498], 95.00th=[  519],
     | 99.00th=[  619], 99.50th=[  701], 99.90th=[  783], 99.95th=[  824],
     | 99.99th=[  840]
  write: io=10240MB, bw=54791KB/s, iops=53, runt=191378msec
    slat (usec): min=29, max=16341, avg=548.59, stdev=2596.46
    clat (msec): min=17, max=1238, avg=578.37, stdev=61.50
     lat (msec): min=17, max=1239, avg=578.92, stdev=61.52
    clat percentiles (msec):
     |  1.00th=[  478],  5.00th=[  502], 10.00th=[  519], 20.00th=[  523],
     | 30.00th=[  537], 40.00th=[  603], 50.00th=[  603], 60.00th=[  603],
     | 70.00th=[  603], 80.00th=[  619], 90.00th=[  619], 95.00th=[  627],
     | 99.00th=[  742], 99.50th=[  873], 99.90th=[ 1057], 99.95th=[ 1106],
     | 99.99th=[ 1237]
    bw (KB  /s): min= 1549, max=69493, per=99.92%, avg=54747.92, stdev=5798.57
    lat (msec) : 20=0.01%, 50=0.01%, 100=0.05%, 250=0.12%, 500=48.41%
    lat (msec) : 750=50.80%, 1000=0.48%, 2000=0.11%

I used the example from here:

https://github.com/axboe/fio/blob/master/examples/basic-verify.fio

Isn't the results suppose to show the write activity first then the 
verify/read?


