Return-Path: <axboe@kernel.dk>
Subject: Re: io_uring on CentOS8?
References: <6d57985d-b784-f9a5-68d0-3a0c3857b4a4@menzel-it.net>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <99539c2d-15e0-db7c-d7bc-e1624bd1e43f@kernel.dk>
Date: Sun, 14 Feb 2021 09:49:59 -0700
MIME-Version: 1.0
In-Reply-To: <6d57985d-b784-f9a5-68d0-3a0c3857b4a4@menzel-it.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: Daniel Menzel <daniel.menzel@menzel-it.net>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2/14/21 8:17 AM, Daniel Menzel wrote:
> /Somehow it seems as if I'm receiving messages from the mailing list - but mine do not seem to get through. So I'm trying again./
> 
> Hi,
> 
> currently I started testing fairly fast NVMe-drives and I for the first time I dealt with the question whether the io engine is sufficient (up till now I just the default /libaio/). I found some information on io_uring online and now tried to switch to that engine:
> 
> fio --bs=1M --rw=randwrite --numjobs=1 --iodepth=1  --size=10000M --filename=/dev/nvme0n1 --name=mylittletest --direct=1 --fsync=1  --refill_buffers --ioengine=io_uring --group_reporting --fallocate=none --runtime=60 --time_based --hipri
> 
> But it crashes with the following information: fio: pid=2490, err=38/file:engines/io_uring.c:699, func=io_queue_init, error=Function not implemented
> 
> My system:
> 
>  1. fio-3.25
>  2. CentOS8 (Kernel 4.18.0-240.1.1.el8_3.x86_64)
>  3. I have installed the packes liburing and liburing-devel
> 
> Am I doing something wrong?

You are not, but since you get -ENOSYS from the system call, that means that
the kernel doesn't support io_uring. It was officially added with the 5.1
kernel, so 4.18 predates that.


-- 
Jens Axboe


