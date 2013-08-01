Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48161 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3HAR36 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 1 Aug 2013 13:29:58 -0400
Message-ID: <51FA9AF2.6060202@kernel.dk>
Date: Thu, 01 Aug 2013 11:29:22 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: How can we report being OOM kiiled ?
References: <51FA311A.7010608@enovance.com>
In-Reply-To: <51FA311A.7010608@enovance.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 08/01/2013 03:57 AM, Erwan Velu wrote:
> Hi,
> 
> I'm currently facing a weird issue with fio 2.0.8.
> 
> I'm running the following job that is supposed to write and last at
> least 300 seconds.
> It just exit almost immediately. After a short search, I saw that I got
> OOM killed.
> [1732289.080181] Killed process 3175 (fio) total-vm:225292kB,
> anon-rss:131440kB, file-rss:0kB
> 
> My first though was, oh... fio did something wrong while it was just
> killed in the head. Is there any way to report that we got killed ? That
> would be very valuable to know that fio got stopped too early and result
> are incomplete.
> 
> cheers,
> 
> [global]
> ioengine=libaio
> invalidate=1
> ramp_time=5
> iodepth=32
> runtime=300
> time_based
> direct=1
> 
> [write-vdb-4m-para]
> bs=4m
> stonewall
> filename=/dev/vdb
> rw=write
> write_bw_log=vm1-1-4m-vdb-write-para.results
> write_iops_log=vm1-1-4m-vdb-write-para.results
> 
> 
> I'm used to run it but since a few, it does perform like :
> 
> [root@host] fio vm1-1-4m-parallel-write-vdb.fio
> write-vdb-4m-para: (g=0): rw=write, bs=4M-4M/4M-4M, ioengine=libaio,
> iodepth=32
> 2.0.8
> Starting 1 process
> fio: pid=3147, got signal=9
> 
> write-vdb-4m-para: (groupid=0, jobs=1): err= 0: pid=3147
>   cpu          : usr=0.00%, sys=0.00%, ctx=0, majf=0, minf=0
>   IO depths    : 1=2.2%, 2=4.3%, 4=8.7%, 8=17.4%, 16=34.8%, 32=32.6%,
>>=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>=64=0.0%
>      issued    : total=r=0/w=46/d=0, short=r=0/w=0/d=0
> 
> Run status group 0 (all jobs):
> 
> Disk stats (read/write):
>   vdb: ios=0/376, merge=0/0, ticks=0/24204, in_queue=24204, util=33.25%
> fio: file hash not empty on exit

It's the iops and bw logging. Fio doesn't flush these until the job is
done, so if you are tight on memory, then I'm sure that would make the
OOM killer consider fio an ever growing monster.

At some point I had a patch to cap the number of entries and flush them
out periodically. Fio doesn't do this right now to avoid perturbing the
workload. But, arguably, using too much memory is even worse. So if you
feel up to it, it would not hurt to add this logic to the log handling.

Right now setup_log() sets up the initial log and allocates a stack of
entries. __add_log_sample() will increase the size of the log as needed
when adding entries. finish_log() flushes it out, that's done when the
job has completed.

-- 
Jens Axboe

