Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:40535 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3FFNpO (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 6 Jun 2013 09:45:14 -0400
Received: by mail-oa0-f47.google.com with SMTP id m1so146530oag.6
        for <fio@vger.kernel.org>; Thu, 06 Jun 2013 06:45:13 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 6 Jun 2013 19:15:13 +0530
Message-ID: <CAJqT0ize7SPQroMxqucSL4npfWTKOjxYFBf0XsOO2QLLNGwr-A@mail.gmail.com>
Subject: Seeing Incorrect values in FIO output
From: sampath rapaka <sampath.rapaka@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

hi

i am seeing a bit weird results some times when i run fio. I am
running with below config. Below are recent log excerpt

Write jobs=7 Read jobs 3
size 1G
Depth 16
direct=1

In the Below output average max and other values seems to be correct
but clat percentile values have gone wrong.

 write1: (groupid=0, jobs=1): err= 0: pid=27689: Thu Jun 6 22:19:40 2013
 write: io=1024.0MB, bw=3222.5KB/s, iops=805 , runt=325442msec
 slat (usec): min=29 , max=27288 , avg=145.14, stdev=436.12
 clat (usec): min=229 , max=158951 , avg=19709.84, stdev=17546.34
 lat (usec): min=403 , max=159018 , avg=19856.27, stdev=17552.85
 clat percentiles (msec):
 | 1.00th=[ 5], 5.00th=[ 9], 10.00th=[ 11], 20.00th=[ 13],
 | 30.00th=[ 14], 40.00th=[ 15], 50.00th=[ 15], 60.00th=[ 16],
 | 70.00th=[ 17], 80.00th=[ 19], 90.00th=[ 31], 95.00th=[ 63],
 | 99.00th=[ 101], 99.50th=[ 111], 99.90th=[ 127], 99.95th=[ 133],
 | 99.99th=[ 143]
 bw (KB/s) : min= 1053, max= 5381, per=14.32%, avg=3225.63, stdev=1514.08
 lat (usec) : 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.02%
 lat (msec) : 2=0.16%, 4=0.75%, 10=7.12%, 20=77.54%, 50=7.74%
 lat (msec) : 100=5.62%, 250=1.04%



In Below Output clat percentiles are fine but min and max and average
values of clat have gone wrong.(This result is from different fio run)

97 write2: (groupid=0, jobs=1): err= 0: pid=17907: Thu Jun 6 20:03:48 2013
98 write: io=1024.0MB, bw=4020.6KB/s, iops=1005 , runt=260805msec
99 slat (usec): min=28 , max=16232 , avg=187.05, stdev=343.91
100 clat (msec): min=1 , max=80 , avg=15.72, stdev= 5.53
101 lat (msec): min=1 , max=80 , avg=15.91, stdev= 5.52
102 clat percentiles (usec):
103 | 1.00th=[ 5728], 5.00th=[ 8512], 10.00th=[10304], 20.00th=[12352],
104 | 30.00th=[13376], 40.00th=[14016], 50.00th=[14656], 60.00th=[15296],
105 | 70.00th=[16768], 80.00th=[18816], 90.00th=[22400], 95.00th=[25472],
106 | 99.00th=[36608], 99.50th=[42240], 99.90th=[50944], 99.95th=[53504],
107 | 99.99th=[60160]
108 bw (KB/s) : min= 2602, max= 5056, per=14.30%, avg=4022.99, stdev=404.28
109 lat (msec) : 2=0.01%, 4=0.18%, 10=8.85%, 20=75.11%, 50=15.74%
110 lat (msec) : 100=0.12%
111 cpu : usr=0.53%, sys=15.97%, ctx=306225, majf=0, minf=4750
112 IO depths : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
113 submit : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
114 complete : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
115 issued : total=r=0/w=262144/d=0, short=r=0/w=0/d=0


The above behavior is seen intermittently.  What could be the possible
reasons for this behavior?

regards
sampath
