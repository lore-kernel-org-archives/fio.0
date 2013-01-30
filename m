Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:42240 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab3A3LI6 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 30 Jan 2013 06:08:58 -0500
Date: Wed, 30 Jan 2013 12:08:03 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Group reporting with latency and IOPS
Message-ID: <20130130110803.GS8800@kernel.dk>
References: <20130129203239.GJ8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D496C@SACEXCMBX02-PRD.hq.netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <843E15216120C047928F6879B0E2D9240F6D496C@SACEXCMBX02-PRD.hq.netapp.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Wed, Jan 30 2013, Neto, Antonio Jose Rodrigues wrote:
> On 1/29/13 3:32 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
> 
> >On Tue, Jan 29 2013, Neto, Antonio Jose Rodrigues wrote:
> >> Jens, sorry to bother you again, but I am trying to apply the I've got
> >>this=
> >>  error. Could you please help me how to fix it?
> >
> >I forgot to push a previous change out. Pull again and try applying,
> >should apply without fuzz.
> >
> >-- 
> >Jens Axboe
> >
> 
> Hi Jens,
> 
> This is neto from Brazil
> 
> How are you?
> 
> I applied the patch and everything is working. Here is one example:
> 
> Thank you very much
> 
> neto
> 
> -- Output file
> 
> workload: (groupid=0, jobs=20): err= 0: pid=2348: Tue Jan 29 22:51:43 2013
>   mixed: io=879352KB, bw=168902KB/s, iops=21112 , runt= 30039msec
>     slat (usec): min=3 , max=2296 , avg= 6.81, stdev= 4.62
>     clat (usec): min=138 , max=248843 , avg=3619.87, stdev=7906.03
>      lat (usec): min=145 , max=248863 , avg=3626.68, stdev=7905.91
>     clat percentiles (usec):
>      |  1.00th=[  350],  5.00th=[  454], 10.00th=[  516], 20.00th=[  724],
>      | 30.00th=[  780], 40.00th=[  820], 50.00th=[  868], 60.00th=[  924],
>      | 70.00th=[ 1048], 80.00th=[ 3760], 90.00th=[11584], 95.00th=[18304],
>      | 99.00th=[39680], 99.50th=[50432], 99.90th=[76288], 99.95th=[90624],
>      | 99.99th=[123392]
>     bw (KB/s)  : min=  864, max= 9088, per=2.43%, avg=4100.05,
> stdev=2630.65
>     lat (usec) : 250=0.56%, 500=7.90%, 750=14.84%, 1000=44.16%
>     lat (msec) : 2=9.40%, 4=3.46%, 10=7.59%, 20=7.80%, 50=3.77%
>     lat (msec) : 100=0.48%, 250=0.03%
>   cpu          : usr=0.00%, sys=0.00%, ctx=0, majf=0, minf=0
>   IO depths    : 1=0.1%, 2=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%,
> >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
> >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
> >=64=0.0%
>      issued    : total=r=634207/w=0/d=0, short=r=0/w=0/d=0
> 
> Run status group 0 (all jobs):
>   MIXED: io=4954.8MB, aggrb=168902KB/s, minb=168902KB/s, maxb=168902KB/s,
> mint=3
> 0039msec, maxt=30039msec

Excellent. Just need to check whether all cases are handled, then I will
get it committed.

-- 
Jens Axboe

