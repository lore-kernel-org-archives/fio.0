Return-Path: <axboe@kernel.dk>
Subject: Re: [RFC PATCH] error out if ENOSPC during file layout
References: <87d0088vxm.fsf@copper.locationd.net>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8898bb07-0929-1a79-ecc7-2fc3eae48b62@kernel.dk>
Date: Sun, 22 Nov 2020 09:55:10 -0700
MIME-Version: 1.0
In-Reply-To: <87d0088vxm.fsf@copper.locationd.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Kushal Kumaran <kushal@locationd.net>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 11/19/20 10:00 PM, Kushal Kumaran wrote:
> Hi,
> 
> When I run fio with --create_only=1 and it runs out of space, it still
> exits with status 0.  I could not figure out if this was intentional
> (except for the fill_device case, where this is obviously the expected
> behavior).
> 
> $ cat ~/fio 
> [global]
> ioengine=posixaio
> rw=readwrite
> size=2g
> directory=${HOME}/mounts/testdisk
> thread=1
> 
> [trivial-readwrite-1g]
> $ df -h .
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/loop6      976M  2.6M  907M   1% /home/kushal/mounts/testdisk
> $ fio ~/fio --create_only=1
> trivial-readwrite-1g: (g=0): rw=rw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=pos
> ixaio, iodepth=1                                                                                     
> fio-3.12
> Starting 1 thread
> trivial-readwrite-1g: Laying out IO file (1 file / 2048MiB)
> fio: ENOSPC on laying out file, stopping
> 
> 
> Run status group 0 (all jobs):
> 
> Disk stats (read/write):
>   loop6: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
> $ echo $?
> 0
> 
> A trivial patch for this gives me the behavior I expect.

That seems reasonable. Applied, thanks.

-- 
Jens Axboe


