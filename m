Return-Path: <axboe@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [io_uring] Problems using io_uring engine
References: <4f70c99f-e5c8-08f7-ebe9-1bbdea73305d@eafit.edu.co>
 <f552027a-25bd-d953-9b19-58e5e44121c6@kernel.dk>
 <ed949243-f657-5f41-79f2-dc8a34459f27@eafit.edu.co>
Message-ID: <931cfc02-d662-f154-c453-276553e19a1e@kernel.dk>
Date: Mon, 25 May 2020 22:17:16 -0600
MIME-Version: 1.0
In-Reply-To: <ed949243-f657-5f41-79f2-dc8a34459f27@eafit.edu.co>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Hamilton Tobon Mosquera <htobonm@eafit.edu.co>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 5/25/20 4:38 PM, Hamilton Tobon Mosquera wrote:
> Thank you for your answer.
> 
> I'm using ext4. I guess it supports polling because I could get sub 10 
> microseconds latency with an Intel Optane SSDPED1D280GA 260GB and 
> pvsync2. If it helps here's how I'm running it:
> 
> fio global.fio --size=50G --ioengine=io_uring --hipri --direct=1 
> --rw=randwrite --iodepth=256 --bs=4K --numjobs=4 --offset_increment=25%
> 
> The global.fio has:
> 
> ioengine=io_uring
> hipri
> direct=1
> thread=1
> buffered=0
> size=100%
> randrepeat=0
> time_based
> ramp_time=0
> norandommap
> refill_buffers
> log_max_value=1
> log_avg_msec=1000
> group_reporting
> percentile_list=50:60:70:80:90:95:99
> 
> Your help is highly appreciated, thank you.

I almost guarantee you that you are NOT using polling. Check with
vmstat 1 and look at the interrupt rate. If it's about your IOPS
rate, then you're doing IRQ based completions. If it's closer to 0,
you're doing polled.

If your fs supports it, then you likely did not allocate poll
queues for NVMe. If nvme is builtin to the kernel, use nvme.poll_queues=N
to allocate N poll queues, or use poll_queues=N as a module parameter
if nvme is modular.

Ideally you want N to be equal to the number of CPUs in the system.
NVMe will report that it used at load time, here's an example from
my laptop:

[    2.396978] nvme nvme0: 1/8/8 default/read/poll queues

You can check this right now by looking at dmesg. If you don't
have any poll queues, preadv2 with IOCB_HIPRI will be IRQ based,
not polled. io_uring just tells you this up front with -EOPNOTSUPP.

-- 
Jens Axboe


