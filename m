Return-Path: <fio-owner@vger.kernel.org>
Received: from out.roosit.eu ([212.26.193.44]:39892 "EHLO out.roosit.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgI0OI3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 27 Sep 2020 10:08:29 -0400
Received: from sx.f1-outsourcing.eu (host-213.189.39.136.telnetsolutions.pl [213.189.39.136])
        by out.roosit.eu (8.14.7/8.14.7) with ESMTP id 08RDn2IK028079
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <fio@vger.kernel.org>; Sun, 27 Sep 2020 15:49:04 +0200
Received: from sx.f1-outsourcing.eu (localhost.localdomain [127.0.0.1])
        by sx.f1-outsourcing.eu (8.13.8/8.13.8) with ESMTP id 08RDn2Pg014202
        for <fio@vger.kernel.org>; Sun, 27 Sep 2020 15:49:02 +0200
Date: Sun, 27 Sep 2020 15:49:02 +0200
From: "Marc Roos" <M.Roos@f1-outsourcing.eu>
Message-ID: <"H00000710017dda2.1601214542.sx.f1-outsourcing.eu*"@MHS>
Subject: Advice getting fio data/output for charts
MIME-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>


I wanted to compare fio results from before and after using dmcrypt and 
add the cpu utilization. 

Currently I have such a fio config[1] running generating a default 
outputfile[2]. What would be the advised way to generate output with 
timestamps that I can eg. insert into a time series db so I can view the 
fio and load in some grafana chart. 

Are there maybe modules that output data every 10s to influx or 
prometheus?


[1]
[global]
ioengine=libaio
#ioengine=posixaio
invalidate=1
ramp_time=30
iodepth=1
runtime=180
time_based
direct=1
filename=/dev/sdl
#filename=/mnt/cephfs/ssd/fio-bench.img

[write-4k-seq]
stonewall
bs=4k
rw=write

[randwrite-4k-seq]
stonewall
bs=4k
rw=randwrite
fsync=1

[randwrite-4k-d32-seq]
stonewall
bs=4k
..
..
..

[2]
randread-4096k-seq: (g=26): rw=randread, bs=(R) 4096KiB-4096KiB, (W) 
4096KiB-4096KiB, (T) 4096KiB-4096KiB, ioengine=libaio, iodepth=1
rw-4096k-seq: (g=27): rw=rw, bs=(R) 4096KiB-4096KiB, (W) 
4096KiB-4096KiB, (T) 4096KiB-4096KiB, ioengine=libaio, iodepth=1
randrw-4096k-seq: (g=28): rw=randrw, bs=(R) 4096KiB-4096KiB, (W) 
4096KiB-4096KiB, (T) 4096KiB-4096KiB, ioengine=libaio, iodepth=1
fio-3.7
Starting 29 processes

write-4k-seq: (groupid=0, jobs=1): err= 0: pid=171549: Thu Sep 24 
12:34:24 2020
  write: IOPS=18.4k, BW=71.8MiB/s (75.3MB/s)(12.6GiB/180001msec)
    slat (usec): min=4, max=140, avg= 5.11, stdev= 1.77
    clat (usec): min=4, max=572, avg=47.67, stdev= 6.22
     lat (usec): min=47, max=577, avg=52.98, stdev= 7.24
    clat percentiles (usec):
     |  1.00th=[   45],  5.00th=[   46], 10.00th=[   46], 20.00th=[   
46],
     | 30.00th=[   46], 40.00th=[   47], 50.00th=[   47], 60.00th=[   
47],
     | 70.00th=[   47], 80.00th=[   48], 90.00th=[   49], 95.00th=[   
54],
     | 99.00th=[   76], 99.50th=[   84], 99.90th=[  115], 99.95th=[  
147],
     | 99.99th=[  188]
   bw (  KiB/s): min=39871, max=76384, per=69.12%, avg=50852.50, 
stdev=4901.54, samples=359
   iops        : min= 9967, max=19096, avg=12712.76, stdev=1225.41, 
samples=359
  lat (usec)   : 10=0.01%, 50=93.11%, 100=6.78%, 250=0.10%, 500=0.01%
  lat (usec)   : 750=0.01%
  cpu          : usr=7.38%, sys=14.15%, ctx=3310912, majf=0, minf=58
  IO depths    : 1=117.1%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%









