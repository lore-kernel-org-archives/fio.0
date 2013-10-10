Return-Path: <juergen.salk@uni-ulm.de>
Date: Thu, 10 Oct 2013 07:47:13 +0200
From: Juergen Salk <juergen.salk@uni-ulm.de>
Subject: Re: Amount of data read with mixed workload sequential/random with
 percentage_random set
Message-ID: <20131010054713.GA32463@highx.de>
References: <20130918145830.GA24714@wattwurm.rz.uni-ulm.de>
 <20130924195508.GB13483@highx.de>
 <52434212.6050404@kernel.dk>
 <20130925205817.GD20577@highx.de>
 <52434F2D.1030801@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52434F2D.1030801@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

* Jens Axboe <axboe@kernel.dk> [130925 15:01]:

> >>> --- snip ---
> >>> [global]
> >>> ioengine=sync
> >>> direct=0
> >>> bssplit=19k/25:177k/15:350k/60
> >>> size=100m
> >>> numjobs=4
> >>> directory=/tmp
> >>>
> >>> [work]
> >>> rw=randread
> >>> --- snip ---
> >>>
> >>> $ fio jobfile.fio >fio.out
> >>> $ grep io= fio.out
> >>>   read : io=199968KB, bw=4892.6KB/s, iops=27, runt= 40872msec
> >>>   read : io=200062KB, bw=5083.5KB/s, iops=28, runt= 39359msec
> >>>   read : io=200156KB, bw=4989.1KB/s, iops=27, runt= 40112msec
> >>>   read : io=199940KB, bw=4492.4KB/s, iops=24, runt= 44507msec
> >>>    READ: io=800126KB, aggrb=17977KB/s, minb=4492KB/s, maxb=5083KB/s, mint=39359msec, maxt=44507msec
> >>>
> >>> [...]
> >>>
> >>> I am probably missing something obvious, but why does the job file 
> >>> above result in 200 MB read by every process?
> >>
> >> It should not, that's definitely a bug. I'm guessing it's triggered by
> >> the strange block sizes being used. Can you see if adding:
> >>
> >> random_generator=lfsr
> >>
> >> helps?
> > 
> > Thanks for your response, Jens. Yes it does. It's a bit confusing
> > though, as the man page says "LFSR only works with single block
> > sizes, not with workloads that use multiple block sizes. If used
> > with such a workload, fio may read or write some blocks multiple
> > times." Shouldn't this be read as "Don't use LFSR with mixed
> > block sizes."?
> 
> That is correct, my suspicion is just that the current logic around when
> to decide to run another loop is wrong. Right now we just look to see if
> the remainder is smaller than the max block size, but that doesn't mean
> that we necessarily have that big of a free chunk available. I suspect
> you are hitting this because of the odd block sizes.
> 
> > I am sorry to keep on harping on the matter, but I am planning to
> > use fio for simulating file sizes where total runtime will
> > become a serious issue. And these simulations will definitely
> > involve strange mixed block sizes ...
> 
> No worries, it's definitely a bug. Checking for a fix right now...

Just out of curiosity: Is there any news on that issue? 

Regards,

Juergen



