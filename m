Return-Path: <axboe@kernel.dk>
Message-ID: <53B462A3.8050402@kernel.dk>
Date: Wed, 02 Jul 2014 13:50:59 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: multiple block devices question
References: <CANyhEAuqB4Q2XphsGpn3FcGFhr02D2etUZBaD7j9w20Y44JXVg@mail.gmail.com>
In-Reply-To: <CANyhEAuqB4Q2XphsGpn3FcGFhr02D2etUZBaD7j9w20Y44JXVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "Yuyang (Alex) Wang" <yyalex.wang@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 07/02/2014 01:42 PM, Yuyang (Alex) Wang wrote:
> hi all,
> 
> I am using FIO (2.1.7) to profile block level performance of multiple
> RAID devices. (see config file below). The test is done on a capable
> 16-core server. With a sigle raid device, I am getting roughly
> 1.4GB/s, with two devices in place, I am still getting around 1.4GB/s,
> which is weird. Another in-house developed benchmark tool, running
> SINGLE-thread suggested we can almost double. I could get double the
> performance through FIO by configuring two jobs, with each job
> handling one device only. However, it still puzzles me as to why a
> single process FIO can't drive the performance of two devices. Did I
> do anything wrong as to the configure file?
> 
> Thanks
> 
> Alex.
> 
> 
> [globals]
> 
> rw=write
> ioengine=libaio
> iodepth=16
> direct=1
> blocksize=1m
> runtime=30
> 
> [devices]
> filename=/dev/mapper/raid-0
> filename=/dev/mapper/raid-1

You are overwriting filename here, hence running with just one device.

-- 
Jens Axboe


