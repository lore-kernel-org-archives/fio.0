Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-db3lp0079.outbound.protection.outlook.com ([213.199.154.79]:30237
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756452AbaCDKfE convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 4 Mar 2014 05:35:04 -0500
From: =?iso-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= 
	<sbouchex@infovista.com>
Subject: json output issue on solaris sparc
Date: Tue, 4 Mar 2014 10:19:32 +0000
Message-ID: <48976ca93fb54c4182ec7189ffc533d1@DB4PR03MB572.eurprd03.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello,

I'm trying fio on solaris sparc and I'm having an strange issue : io_bytes, bw, iops, runtime values are 0 when json output is enabled but contains valid values when using text (or terse) output format.
I have tested on solaris x64 and everything is fine.

Output (text format) :
---
Starting 1 process
Jobs: 1 (f=1): [w] [-.-% done] [0KB/452.7MB/0KB /s] [0/14.5K/0 iops] [eta 00m:00s]
random_rw: (groupid=0, jobs=1): err= 0: pid=15677: Tue Mar  4 11:04:24 2014
  write: io=1024.0MB, bw=454126KB/s, iops=14191, runt=  2309msec
    slat (usec): min=7, max=1430, avg= 8.54, stdev= 7.97
    clat (usec): min=22, max=387, avg=59.75, stdev=10.36
     lat (usec): min=56, max=1817, avg=68.29, stdev=14.43
    clat percentiles (usec):
     |  1.00th=[   50],  5.00th=[   50], 10.00th=[   51], 20.00th=[   52],
     | 30.00th=[   56], 40.00th=[   57], 50.00th=[   59], 60.00th=[   60],
     | 70.00th=[   61], 80.00th=[   62], 90.00th=[   69], 95.00th=[   71],
     | 99.00th=[   98], 99.50th=[  123], 99.90th=[  165], 99.95th=[  171],
     | 99.99th=[  195]
    bw (KB  /s): min=426112, max=471552, per=99.26%, avg=450752.00, stdev=21035.79
    lat (usec) : 50=0.81%, 100=98.28%, 250=0.91%, 500=0.01%
  cpu          : usr=109.53%, sys=74.39%, ctx=32833, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=32768/d=0, short=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: io=1024.0MB, aggrb=454125KB/s, minb=454125KB/s, maxb=454125KB/s, mint=2309msec, maxt=2309msec
---

Output (json format):
---
{
  "fio version" : "fio-2.1.6",
  "jobs" : [
    {
      "jobname" : "random_rw",
      "groupid" : 0,
      "error" : 0,
      "read" : {
        "io_bytes" : 0,
        "bw" : 0,
        "iops" : 0,
        "runtime" : 0,
        "slat" : {
          "min" : 0,
          "max" : 0,
          "mean" : 0.00,
          "stddev" : 0.00
        },
        "clat" : {
          "min" : 0,
          "max" : 0,
          "mean" : 0.00,
          "stddev" : 0.00,
          "percentile" : {
            "1.000000" : 0,
            "5.000000" : 0,
            "10.000000" : 0,
            "20.000000" : 0,
            "30.000000" : 0,
            "40.000000" : 0,
            "50.000000" : 0,
            "60.000000" : 0,
            "70.000000" : 0,
            "80.000000" : 0,
            "90.000000" : 0,
            "95.000000" : 0,
            "99.000000" : 0,
            "99.500000" : 0,
            "99.900000" : 0,
            "99.950000" : 0,
            "99.990000" : 0,
            "0.00" : 0,
            "0.00" : 0,
            "0.00" : 0
          }
        },
        "lat" : {
          "min" : 0,
          "max" : 0,
          "mean" : 0.00,
          "stddev" : 0.00
        },
        "bw_min" : 0,
        "bw_max" : 0,
        "bw_agg" : 0.00,
        "bw_mean" : 0.00,
        "bw_dev" : 0.00
      },
      "write" : {
        "io_bytes" : 0,
        "bw" : 0,
        "iops" : 0,
        "runtime" : 0,
        "slat" : {
          "min" : 7,
          "max" : 888,
          "mean" : 9.37,
          "stddev" : 5.37
        },
        "clat" : {
          "min" : 42,
          "max" : 81326,
          "mean" : 103.08,
          "stddev" : 732.51,
          "percentile" : {
            "1.000000" : 50,
            "5.000000" : 52,
            "10.000000" : 53,
            "20.000000" : 58,
            "30.000000" : 60,
            "40.000000" : 62,
            "50.000000" : 66,
            "60.000000" : 70,
            "70.000000" : 73,
            "80.000000" : 107,
            "90.000000" : 205,
            "95.000000" : 213,
            "99.000000" : 318,
            "99.500000" : 490,
            "99.900000" : 548,
            "99.950000" : 596,
            "99.990000" : 46848,
            "0.00" : 0,
            "0.00" : 0,
            "0.00" : 0
          }
        },
        "lat" : {
          "min" : 50,
          "max" : 81335,
          "mean" : 112.45,
          "stddev" : 732.64
        },
        "bw_min" : 194880,
        "bw_max" : 375488,
        "bw_agg" : 270316.56,
        "bw_mean" : 270316.56,
        "bw_dev" : 60821.06
      },
      "trim" : {
        "io_bytes" : 0,
        "bw" : 0,
        "iops" : 0,
        "runtime" : 0,
        "slat" : {
          "min" : 0,
          "max" : 0,
          "mean" : 0.00,
          "stddev" : 0.00
        },
        "clat" : {
          "min" : 0,
          "max" : 0,
          "mean" : 0.00,
          "stddev" : 0.00,
          "percentile" : {
            "1.000000" : 0,
            "5.000000" : 0,
            "10.000000" : 0,
            "20.000000" : 0,
            "30.000000" : 0,
            "40.000000" : 0,
            "50.000000" : 0,
            "60.000000" : 0,
            "70.000000" : 0,
            "80.000000" : 0,
            "90.000000" : 0,
            "95.000000" : 0,
            "99.000000" : 0,
            "99.500000" : 0,
            "99.900000" : 0,
            "99.950000" : 0,
            "99.990000" : 0,
            "0.00" : 0,
            "0.00" : 0,
            "0.00" : 0
          }
        },
        "lat" : {
          "min" : 0,
          "max" : 0,
          "mean" : 0.00,
          "stddev" : 0.00
        },
        "bw_min" : 0,
        "bw_max" : 0,
        "bw_agg" : 0.00,
        "bw_mean" : 0.00,
        "bw_dev" : 0.00
      },
      "usr_cpu" : 105.77,
      "sys_cpu" : 79.71,
      "ctx" : 0,
      "majf" : 0,
      "minf" : 0,
      "iodepth_level" : {
        "1" : 100.00,
        "2" : 0.00,
        "4" : 0.00,
        "8" : 0.00,
        "16" : 0.00,
        "32" : 0.00,
        ">=64" : 0.00
      },
      "latency_us" : {
        "2" : 0.00,
        "4" : 0.00,
        "10" : 0.00,
        "20" : 0.00,
        "50" : 0.38,
        "100" : 78.60,
        "250" : 17.83,
        "500" : 2.83,
        "750" : 0.35,
        "1000" : 0.01
      },
      "latency_ms" : {
        "2" : 0.00,
        "4" : 0.00,
        "10" : 0.01,
        "20" : 0.01,
        "50" : 0.01,
        "100" : 0.01,
        "250" : 0.00,
        "500" : 0.00,
        "750" : 0.00,
        "1000" : 0.00,
        "2000" : 0.00,
        ">=2000" : 0.00
      },
      "latency_depth" : 1,
      "latency_target" : 0,
      "latency_percentile" : 100.00,
      "latency_window" : 0
    }
  ]
}
---

My profile file is :
---
[global]
ioengine=solarisaio

[random_rw]
rw=randwrite
size=1024m
directory=/data/fio
bs=32k
---

I'm using fio-2.1.6 rebuilt with gcc 4.8.0 with the default configure script.

Thanks
Seb

