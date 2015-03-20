Return-Path: <axboe@kernel.dk>
Message-ID: <550C4CAE.7070905@kernel.dk>
Date: Fri, 20 Mar 2015 10:37:02 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Buggy behavior with zone, random IOs since specific commit
References: <CAFFT=U=vjqCZDoP5M31ifDWaLcG7LEhjgYHKzhdJ6mc6gDO0Sg@mail.gmail.com>
In-Reply-To: <CAFFT=U=vjqCZDoP5M31ifDWaLcG7LEhjgYHKzhdJ6mc6gDO0Sg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Akash Verma <akashv@google.com>, fio <fio@vger.kernel.org>
Cc: Brian Fulton <bfulton@google.com>
List-ID: <fio@vger.kernel.org>

On 03/18/2015 10:24 PM, Akash Verma wrote:
> This commit seems to have broken the behavior of random IOs with zone options:
>
> 4c8be5b1569f0aca8c7769803e57b79280d1f668
>
> Using this example job file:
> [zoned_out]
> rw=read
> bs=1k
> offset=510k
> ioengine=sync
> zonesize=1k
> zonerange=512k
> zoneskip=512k
> write_iolog=ios_meec.iolog
> filename=10MFile
>
> where 10M file was created as:
> dd if=/dev/zero of=./10MFile bs=1M count=10
>
> Prior to the above commit, FIO does one read per zone, and the job
> exits after the last zone. This is as expected.
>
> Post the above commit, FIO loops back to the first zone and may or may
> not succeed in finding a valid offset to seek to. With offset=510k, it
> fails on the first loop-back. With offset=100k, it fails on the
> second; with no offset, it did about a 100 loops. With --debug=random,
> I see messages like:
>
> file     1885  get file 10MFile, ref=1
> random   1885  off rand 1823528783
> io       1885  get_next_offset: offset 18446744073708827648 >= size 10485760
> io       1885  io_u 0x8c8e80, failed getting offset
>
> There should be no loop-back happening at all unless this is specified
> as desired (e.g. using runtime and time_based, or io_limit, or
> number_ios).

It might be more work, but yes, that I think is a good start. Care to 
send a patch to stop looping unless we're forced to? At least that will 
fix the case of buggy looping.

-- 
Jens Axboe


