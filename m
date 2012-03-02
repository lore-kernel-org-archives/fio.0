Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51350 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab2CBSqW (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 2 Mar 2012 13:46:22 -0500
Message-ID: <4F51157B.4020509@kernel.dk>
Date: Fri, 02 Mar 2012 19:46:19 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Re-2: verify seems not to take place on iSCSI-Target writing
References: <DIIE.00000BAC0002E649@192.168.0.5>
In-Reply-To: <DIIE.00000BAC0002E649@192.168.0.5>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?B?U3RlZmFuIEjDvGJuZXI=?= <shu@xtivate.de>
Cc: fio@vger.kernel.org

On 2012-03-02 18:06, Stefan Hübner wrote:
> Dear Jens,
> 
> this is the output.  I added some supplementary details in the hope it's useful ...
> 
> UltraBitch ~ # ISCSI_DEVICE=/dev/sdb SECONDS=$((20*3600)) fio iscsi-stress.fio 
> iSCSI: (g=0): rw=randwrite, bs=4K-4M/4K-4M, ioengine=libaio, iodepth=16
> fio 2.0.3
> Starting 1 process
> Jobs: 1 (f=1): [w] [17.3% done] [0K/113.2M /s] [0 /71  iops] [eta 03d:23h:28m:21s]
> iSCSI: (groupid=0, jobs=1): err= 0: pid=18184
>   write: io=7740.2GB, bw=112723KB/s, iops=63 , runt=72000222msec
>     bw (KB/s)  : min= 3669, max=593424, per=100.00%, avg=113561.25, stdev=26868.27
>   cpu          : usr=4.18%, sys=1.28%, ctx=4760480, majf=0, minf=106912
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=0/w=4560578/d=0, short=r=0/w=0/d=0
> 
> Run status group 0 (all jobs):
>   WRITE: io=7740.2GB, aggrb=112723KB/s, minb=115428KB/s, maxb=115428KB/s, mint=72000222msec, maxt=72000222msec

No reads happened - quick guess, you had the timeout hit before the
write phase has finished. Hence it'll exit, and don't do verifies.

The reads you saw in the stats must be from other processes. Fio didn't
do any.

-- 
Jens Axboe

