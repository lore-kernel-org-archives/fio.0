Return-Path: <chamarthy.raju@gmail.com>
MIME-Version: 1.0
In-Reply-To: <553A71CD.1080505@kernel.dk>
References: <CABtFm2Wh07GiQ4HAeOKzDHTNpPRpq+u=CU7xLnwej+HaESzn_w@mail.gmail.com>
	<553A6D62.5070803@kernel.dk>
	<553A71CD.1080505@kernel.dk>
Date: Sat, 25 Apr 2015 16:26:56 +0800
Message-ID: <CABtFm2Uxh_2FP9U3-PL8Wm7=MmhyxnNtraFZMb2eixA3X+wcEA@mail.gmail.com>
Subject: Re: crash reports while running IO on raid0 btrfs
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Thanks. :) Oh yeah... i did not see i gave a wrong max bs. typo ...
oops... sometimes doing something wrong wakes up some issues :)

I tried the provided patch and it worked well. I also tried with the
right max bs and it all works well now.

Thanks for the great support.

On Sat, Apr 25, 2015 at 12:39 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 04/24/2015 10:20 AM, Jens Axboe wrote:
>>
>> On 04/17/2015 03:13 AM, Srinivasa Chamarthy wrote:
>>>
>>> Received the following crash reports:
>>>
>>> fio: pid=2847, got signal=6
>>> Jobs: 3 (f=101), CR=1200MB/0B KB/s: [K(1),W(1),K(1),W(2),K(1)] [80.1%
>>> done] [0KB/118.1MB/0KB /s] [0/1814/0 iopJobs: 3 (f=97), CR=1200MB/0B
>>> KB/s: [K(1),W(1),K(1),W(2),K(1)] [80.2% done] [0KB/40312KB/0KB /s]
>>> [0/583/0 iops]*** Error in `fio':
>>> double free or corruption (!prev): 0x000000000114d7b0 ***
>>> ======= Backtrace: =========
>>> /lib64/libc.so.6(+0x730bf)[0x7fcf25c7e0bf]
>>> /lib64/libc.so.6(+0x7892e)[0x7fcf25c8392e]
>>> /lib64/libc.so.6(+0x79636)[0x7fcf25c84636]
>>> fio(free_io_mem+0x97)[0x42c3e7]
>>> fio[0x44dc73]
>>> fio[0x450fd9]
>>> fio(fio_backend+0xfb)[0x45144b]
>>> /lib64/libc.so.6(__libc_start_main+0xf5)[0x7fcf25c2cb05]
>>> fio[0x40d3ec]
>>>
>>> # fio -v
>>> fio-2.2.7-9-g4da2
>>
>>
>> I can't reproduce this. Could you try a make clean and make again?
>> Sometimes fio's build system screws up when you pull in changes, some of
>> the dependencies are apparently whacked.
>
>
> Actually, I think I see what it is. It's because your max bs isn't a
> multiple of the min bs, and fio has a bug in where it rounds up the
> blocksize as a multiple of the min bs. So we end up rounding up to 128K,
> where the max should be 124K. This causes us to overwrite allocated memory,
> and madness ensues. Can you test this patch?
>
> --
> Jens Axboe
>



-- 
Srinivasa R Chamarthy

