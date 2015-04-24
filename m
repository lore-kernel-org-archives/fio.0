Return-Path: <axboe@kernel.dk>
Message-ID: <553A6D62.5070803@kernel.dk>
Date: Fri, 24 Apr 2015 10:20:50 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: crash reports while running IO on raid0 btrfs
References: <CABtFm2Wh07GiQ4HAeOKzDHTNpPRpq+u=CU7xLnwej+HaESzn_w@mail.gmail.com>
In-Reply-To: <CABtFm2Wh07GiQ4HAeOKzDHTNpPRpq+u=CU7xLnwej+HaESzn_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Srinivasa Chamarthy <chamarthy.raju@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/17/2015 03:13 AM, Srinivasa Chamarthy wrote:
> Received the following crash reports:
>
> fio: pid=2847, got signal=6
> Jobs: 3 (f=101), CR=1200MB/0B KB/s: [K(1),W(1),K(1),W(2),K(1)] [80.1%
> done] [0KB/118.1MB/0KB /s] [0/1814/0 iopJobs: 3 (f=97), CR=1200MB/0B
> KB/s: [K(1),W(1),K(1),W(2),K(1)] [80.2% done] [0KB/40312KB/0KB /s]
> [0/583/0 iops]*** Error in `fio':
> double free or corruption (!prev): 0x000000000114d7b0 ***
> ======= Backtrace: =========
> /lib64/libc.so.6(+0x730bf)[0x7fcf25c7e0bf]
> /lib64/libc.so.6(+0x7892e)[0x7fcf25c8392e]
> /lib64/libc.so.6(+0x79636)[0x7fcf25c84636]
> fio(free_io_mem+0x97)[0x42c3e7]
> fio[0x44dc73]
> fio[0x450fd9]
> fio(fio_backend+0xfb)[0x45144b]
> /lib64/libc.so.6(__libc_start_main+0xf5)[0x7fcf25c2cb05]
> fio[0x40d3ec]
>
> # fio -v
> fio-2.2.7-9-g4da2

I can't reproduce this. Could you try a make clean and make again? 
Sometimes fio's build system screws up when you pull in changes, some of 
the dependencies are apparently whacked.

-- 
Jens Axboe


