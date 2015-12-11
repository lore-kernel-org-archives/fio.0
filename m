Return-Path: <axboe@kernel.dk>
Subject: Re: Exit all jobs on error
References: <CALjAwxhfyQ3ppw-MXoRwAkhk4+-LSJSTkZQa32ymKizKU0Ox-A@mail.gmail.com>
 <5669B23C.1020001@kernel.dk>
 <CALjAwxjLXTCRe0Ky08DB6in2aq_czkx5Oz8Osi7Mo=+7eFH9PQ@mail.gmail.com>
 <CANvN+e=CtQBfUmj6fQPUgaqHUXwzwY1SLuXV76n=AG2kLFpWSQ@mail.gmail.com>
 <20151210181540.GB21415@kernel.dk>
 <CANvN+e=U5O4LC40uE59iGn1jtkBGygbboXGcKpfXO2uTX3=bVw@mail.gmail.com>
 <5669C364.9020100@kernel.dk>
 <CANvN+ekovkotiX=EVxrYxmh4DJv0=+Hh4LQD+X5Ut8jDYgTdHg@mail.gmail.com>
 <5669C46F.3090300@kernel.dk>
 <CANvN+emkTn1aLk2MB41Z0hD3y0NLjoS3cz4jcF4w+ytP4A1d5w@mail.gmail.com>
 <CANvN+e=sgRBJiS8Toefk6nOHdtod1pr6bDPeux_audc5fUBUJg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <566AECA3.6000108@kernel.dk>
Date: Fri, 11 Dec 2015 08:32:51 -0700
MIME-Version: 1.0
In-Reply-To: <CANvN+e=sgRBJiS8Toefk6nOHdtod1pr6bDPeux_audc5fUBUJg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/11/2015 03:01 AM, Andrey Kuzmin wrote:
> ^Cbs: 1 (f=1): [w(1)] [0.0% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta
> 01d:12h:24m:29s]
> Program received signal SIGINT, Interrupt.
> 0x00007ffff6b7ff3d in nanosleep () at ../sysdeps/unix/syscall-template.S:81
> 81 ../sysdeps/unix/syscall-template.S: No such file or directory.
> (gdb) bt
> #0  0x00007ffff6b7ff3d in nanosleep () at ../sysdeps/unix/syscall-template.S:81
> #1  0x00007ffff6bb14a4 in usleep (useconds=<optimized out>) at
> ../sysdeps/unix/sysv/linux/usleep.c:32
> #2  0x000000000045a7ed in do_usleep (usecs=10000) at backend.c:1951
> #3  0x000000000045b33c in run_threads () at backend.c:2216
> #4  0x000000000045b6a8 in fio_backend () at backend.c:2333
> #5  0x00000000004991cb in main (argc=4, argv=0x7fffffffdda8,
> envp=0x7fffffffddd0) at fio.c:60

That's not one of the IO threads, that's the main thread. It'll sit and 
wait in that loop until jobs finish. You'll need the backtrace of one of 
the stuck IO thread instead, this trace is quite normal and expected of 
backend.

-- 
Jens Axboe


