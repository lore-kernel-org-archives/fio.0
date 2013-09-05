Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59205 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab3IETiy (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 5 Sep 2013 15:38:54 -0400
Message-ID: <5228DDC8.9070201@kernel.dk>
Date: Thu, 05 Sep 2013 13:38:48 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Invalid argument error (EINVAL) on Lustre filesystem with ioengine=libaio
 enabled
References: <20130905151559.GG32553@wattwurm.rz.uni-ulm.de>
In-Reply-To: <20130905151559.GG32553@wattwurm.rz.uni-ulm.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Juergen Salk <juergen.salk@uni-ulm.de>
Cc: fio@vger.kernel.org

On 09/05/2013 09:15 AM, Juergen Salk wrote:
> Hi,
> 
> I tried to run fio on a Lustre filesystem with ioengine=libaio enabled:
> 
> $ ../tools/fio/2.1.2/bin/fio seqwrite.fio 
> sequential_write: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=32
> fio-2.1.2
> Starting 1 process
> fio: pid=31956, err=22/file:ioengines.c:381, func=io commit, error=Invalid argument
> 
> sequential_write: (groupid=0, jobs=1): err=22 (file:ioengines.c:381, func=io commit, error=Invalid argument): pid=31956: Thu Sep  5 16:43:56 2013
>   cpu          : usr=0.00%, sys=100.00%, ctx=23, majf=0, minf=49
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=100.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=0/w=1/d=0, short=r=0/w=0/d=0
> 
> Run status group 0 (all jobs):
> 
> This is the content of the job file:
> 
> --- snip ---
> 
> [global]
> ioengine=libaio
> # ioengine=sync
> iodepth=32
> direct=1
> invalidate=1
> filename_format=file.$jobnum
> group_reporting
> bs=1024k
> size=1g
> numjobs=1
> directory=/scratch1/ws/jsalk-bench-0
> 
> [sequential_write]
> rw=write
> 
> --- snip ---
> 
> It works with ioengine=sync, though. It also works on the same machine
> with ioengine=libaio enabled but with the work directory located on a
> locally attached disk (with ext3 file system).
> 
> An strace log is attached. Are there any ideas of what might be
> causing this problem on Lustre?

I'm guessing that lustre doesn't support async IO, though I have never
tried it myself. From the error out of fio and the strace, io_submit()
is returning EINVAL. The context id is valid, fio is submitting 1 iocb,
and the opcode is a read operation on fd 3 - all of which are good.

-- 
Jens Axboe

