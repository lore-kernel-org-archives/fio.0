Return-Path: <axboe@kernel.dk>
Message-ID: <54EE3535.8060606@kernel.dk>
Date: Wed, 25 Feb 2015 13:48:53 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: REPORT: High CPU utilization since 2.2.5
References: <D10CFEF2.19AB0%andrey.o.kudryavtsev@intel.com>
In-Reply-To: <D10CFEF2.19AB0%andrey.o.kudryavtsev@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: "Kudryavtsev, Andrey O" <andrey.o.kudryavtsev@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 02/20/2015 04:10 PM, Kudryavtsev, Andrey O wrote:
> Hi Jens,
> I’m running NVMe SSD benchmarks which are using multi-job configurations in the most common scenarios.
> I have noticed that since 2.2.5 release FIO has 3-4 times higher CPU utilization on the same workload, same system, same kernel 3.18.
> In fact I’m not able to achieve 450k IOPS on latest Core-i7 CPU due to 100% utilization.
> I tracked down the changes back, 2.1.14 is the most stable for me. Release had 2.2.0 the reporting issues, which were fixed in 2.2.5 but introduced high CPU utilization instead.
> Did anyone notice that too?
> 
> Configuration details are bellow:
> 
> [global]
> name=4k random read 4 ios in the queue in 32 queues
> filename=/dev/nvme0n1
> ioengine=libaio
> direct=1
> bs=4k
> rw=randread
> iodepth=4
> numjobs=32
> buffered=0
> size=100%
> runtime=0
> randrepeat=0
> norandommap
> refill_buffers
> [job1]

Can you try and bisect the issue?

-- 
Jens Axboe


