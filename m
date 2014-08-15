Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.opengridcomputing.com ([72.48.136.20]:46037 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751105AbaHOOe6 (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 15 Aug 2014 10:34:58 -0400
Received: from cody (cody.ogc.int [10.10.0.240])
	by smtp.opengridcomputing.com (Postfix) with ESMTPS id 234F529E73
	for <fio@vger.kernel.org>; Fri, 15 Aug 2014 09:34:58 -0500 (CDT)
From: "Steve Wise" <swise@opengridcomputing.com>
References: <005e01cfb339$774e4640$65ead2c0$@opengridcomputing.com>
In-Reply-To: <005e01cfb339$774e4640$65ead2c0$@opengridcomputing.com>
Subject: RE: fio terse output for WRITE not working.
Date: Fri, 15 Aug 2014 09:35:02 -0500
Message-ID: <002d01cfb896$19657b40$4c3071c0$@opengridcomputing.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Any thoughts on this?

Thanks,

Steve.

> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Steve
> Wise
> Sent: Friday, August 08, 2014 1:49 PM
> To: fio@vger.kernel.org
> Subject: fio terse output for WRITE not working.
> 
> Hey,
> 
> I'm using fio-2.1.10, and trying to get the Total IO via the terse output.  It works for
> read but not for write.  Here is the output and the fio conf file I'm using.
> 
> Any thoughts?  Is this a known bug?
> 
> Thanks,
> 
> Steve.
> 
> -----
> 
> 
> Read works:
> 
> [root@hpc1 ~]# RW=randread fio --minimal fio-test.conf
>
3;fio-2.1.10;foo;0;0;80251;40105;40105;2001;4;85;8.170228;4.004539;65;805;189.872799;49.78
> 1808;1.000000%=122;5.000000%=133;10.000000%=139;20.000000%=149;30.000000%=159;40.
> 000000%=1
> 69;50.000000%=179;60.000000%=191;70.000000%=205;80.000000%=225;90.000000%=258;95.
> 000000%=2
> 86;99.000000%=354;99.500000%=386;99.900000%=450;99.950000%=486;99.990000%=596;0%
> =0;0%=0;0%
> =0;87;809;198.185493;49.501590;38468;42140;100.000000%;40262.666667;1837.395258;0;0;0;
> 0;0;
> 0;0.000000;0.000000;0;0;0.000000;0.000000;1.000000%=0;5.000000%=0;10.000000%=0;20.000
> 000%=
> 0;30.000000%=0;40.000000%=0;50.000000%=0;60.000000%=0;70.000000%=0;80.000000%=0;9
> 0.000000%
> =0;95.000000%=0;99.000000%=0;99.500000%=0;99.900000%=0;99.950000%=0;99.990000%=0;
> 0%=0;0%=0
> ;0%=0;0;0;0.000000;0.000000;0;0;0.000000%;0.000000;0.000000;7.750000%;41.150000%;31556
> ;0;9
> ;0.1%;0.1%;0.1%;100.0%;0.0%;0.0%;0.0%;0.00%;0.00%;0.00%;0.00%;0.00%;0.01%;88.31%;11.
> 64%;0.
> 04%;0.01%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%
> 
> Write shows zeros for Total IO:
> 
> [root@hpc1 ~]# RW=randwrite fio --minimal fio-test.conf
>
3;fio-2.1.10;foo;0;0;0;0;0;0;0;0;0.000000;0.000000;0;0;0.000000;0.000000;1.000000%=0;5.000
> 000%=0;10.000000%=0;20.000000%=0;30.000000%=0;40.000000%=0;50.000000%=0;60.00000
> 0%=0;70.00
> 0000%=0;80.000000%=0;90.000000%=0;95.000000%=0;99.000000%=0;99.500000%=0;99.9000
> 00%=0;99.9
> 50000%=0;99.990000%=0;0%=0;0%=0;0%=0;0;0;0.000000;0.000000;0;0;0.000000%;0.000000;0
> .000000
> ;5409;2697;2697;2005;6;51;18.330190;7.389300;81;10033;2939.422629;1572.743671;1.000000%
> =88
> 4;5.000000%=1144;10.000000%=1320;20.000000%=1560;30.000000%=1784;40.000000%=2096;
> 50.000000
> %=2448;60.000000%=3120;70.000000%=3664;80.000000%=4320;90.000000%=5216;95.000000
> %=5984;99.
> 000000%=7520;99.500000%=8032;99.900000%=9664;99.950000%=9792;99.990000%=10048;0
> %=0;0%=0;0%
> =0;89;10040;2957.946016;1571.794210;2572;2794;100.000000%;2701.000000;95.951377;2.8942
> 12%;
> 8.582834%;4987;0;8;0.1%;0.1%;0.1%;99.9%;0.0%;0.0%;0.0%;0.00%;0.00%;0.00%;0.00%;0.00%
> ;0.17%
> ;0.17%;0.02%;0.07%;2.02%;34.72%;36.75%;26.07%;0.02%;0.00%;0.00%;0.00%;0.00%;0.00%;0.
> 00%;0.
> 00%;0.00%
> 
> Without --minimal, we see Total IO WRITE numbers:
> 
> [root@hpc1 ~]# RW=randwrite fio fio-test.conf
> foo: (g=0): rw=randwrite, bs=1K-1K/1K-1K/1K-1K, ioengine=libaio, iodepth=8
> fio-2.1.10
> Starting 1 process
> Jobs: 1 (f=1): [w] [-.-% done] [0KB/1158KB/0KB /s] [0/1158/0 iops] [eta 00m:00s]
> foo: (groupid=0, jobs=1): err= 0: pid=4547: Fri Aug  8 11:45:00 2014
>   write: io=2334.0KB, bw=1162.1KB/s, iops=1162, runt=  2007msec
>     slat (usec): min=7, max=45, avg=19.02, stdev= 4.98
>     clat (usec): min=72, max=15679, avg=6849.86, stdev=3321.20
>      lat (usec): min=81, max=15699, avg=6869.15, stdev=3322.08
>     clat percentiles (usec):
>      |  1.00th=[ 1864],  5.00th=[ 2960], 10.00th=[ 3408], 20.00th=[ 3824],
>      | 30.00th=[ 4192], 40.00th=[ 4704], 50.00th=[ 5728], 60.00th=[ 7904],
>      | 70.00th=[ 9152], 80.00th=[10176], 90.00th=[11712], 95.00th=[12864],
>      | 99.00th=[13888], 99.50th=[14400], 99.90th=[15424], 99.95th=[15424],
>      | 99.99th=[15680]
>     bw (KB  /s): min= 1101, max= 1226, per=99.91%, avg=1161.00, stdev=60.88
>     lat (usec) : 100=0.30%, 250=0.43%
>     lat (msec) : 2=0.39%, 4=21.34%, 10=55.70%, 20=21.85%
>   cpu          : usr=1.60%, sys=4.34%, ctx=2304, majf=0, minf=8
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.2%, 8=99.7%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=0/w=2334/d=0, short=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=8
> 
> Run status group 0 (all jobs):
>   WRITE: io=2334KB, aggrb=1162KB/s, minb=1162KB/s, maxb=1162KB/s, mint=2007msec,
> maxt=2007msec
> 
> Disk stats (read/write):
>   sda: ios=0/2207, merge=0/0, ticks=0/15041, in_queue=15076, util=95.05%
> 
> 
> Here is the conf file:
> 
>  [root@hpc1 ~]# cat fio-test.conf
> [foo]
> rw=${RW}
> size=40m
> bs=1k
> directory=/tmp
> direct=1
> numjobs=1
> runtime=2
> time_based
> ioengine=libaio
> iodepth=8
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

