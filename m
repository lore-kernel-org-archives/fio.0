Return-Path: <axboe@kernel.dk>
Message-ID: <54B45DAB.7060406@kernel.dk>
Date: Mon, 12 Jan 2015 16:50:03 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] mmap backend broken
References: <CAL_XjKXUkmDm2kVn3b-PEuRjFP9gyx6hCorVADkUAcfcYM4=BA@mail.gmail.com>
In-Reply-To: <CAL_XjKXUkmDm2kVn3b-PEuRjFP9gyx6hCorVADkUAcfcYM4=BA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Yoshinori Sato <yo-satoh@sios.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 01/06/2015 08:30 PM, Yoshinori Sato wrote:
> Program received signal SIGSEGV, Segmentation fault.
> 0x00000000004345c2 in fio_mmapio_invalidate (td=0x7fffeed6e790,
>     f=0x7ffff75dc3d0) at engines/mmap.c:260
> warning: Source file is more recent than executable.
> 260 static struct ioengine_ops ioengine = {
> (gdb) bt
> #0  0x00000000004345c2 in fio_mmapio_invalidate (td=0x7fffeed6e790,
>     f=0x7ffff75dc3d0) at engines/mmap.c:260
> #1  0x000000000041b1da in __file_invalidate_cache (td=0x7fffeed6e790,
>     f=0x7ffff75dc3d0, off=0, len=1456128) at filesetup.c:402
> #2  0x000000000041c465 in setup_files (td=0x7fffeed6e790) at filesetup.c:924
> #3  0x0000000000443d7a in run_threads () at backend.c:1892
> #4  fio_backend () at backend.c:2197
> #5  0x0000003506a1ed1d in __libc_start_main (main=0x453980 <main>, argc=2,
>     ubp_av=0x7fffffffe228, init=<value optimized out>,
>     fini=<value optimized out>, rtld_fini=<value optimized out>,
>     stack_end=0x7fffffffe218) at libc-start.c:226
> #6  0x000000000040aa19 in _start ()

Oops thanks, your patch looks correct, but unfortunately it's garbled in
the mailer. Can you resend it attached?

-- 
Jens Axboe


