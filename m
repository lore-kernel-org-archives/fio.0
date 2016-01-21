Return-Path: <bruce@cran.org.uk>
Subject: Re: fio newer than 2.2.12 segfaults on examples/tiobench-example.fio
References: <569B9F48.3010808@cran.org.uk> <569D5FB4.6050602@kernel.dk>
From: Bruce Cran <bruce@cran.org.uk>
Message-ID: <56A05EDC.4030309@cran.org.uk>
Date: Wed, 20 Jan 2016 21:30:20 -0700
MIME-Version: 1.0
In-Reply-To: <569D5FB4.6050602@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 01/18/2016 02:57 PM, Jens Axboe wrote:
> Can you compile with with --disable-optimizations passed to configure, 
> ensure that a core file is dumped (ulimit -c1000000000000 or 
> whatever), and then run gdb ./fio core to show a full backtrace?
>
> I can't reproduce the crash with 2.3 or current -git, runs fine for me.
>

I'm wondering if this is a microcode bug, since I have one of the new 
Skylake CPUs (Intel(R) Core(TM) i7-6700K CPU @ 4.00GHz; stepping: 3; 
microcode: 0x6a) and others have mentioned crashes in 
__lll_unlock_elision related to broken CPUs/BIOSes, though for older 
generations.
Anyway, here's the output and backtrace:

(gdb) run examples/tiobench-example.fio
Starting program: /home/bcran/workspace/fio/fio 
examples/tiobench-example.fio
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib64/libthread_db.so.1".
f1: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
...
f2: (g=1): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
...
f3: (g=2): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
...
f4: (g=3): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
...
fio-2.4-1-g44ac
Starting 16 processes
Detaching after fork from child process 26797.
[New Thread 0x7fffe7d53700 (LWP 26796)]

Program received signal SIGSEGV, Segmentation fault.
__lll_unlock_elision (lock=0x7ffff7feb000, private=128) at 
../sysdeps/unix/sysv/linux/x86/elision-unlock.c:29
29    ../sysdeps/unix/sysv/linux/x86/elision-unlock.c: No such file or 
directory.
(gdb) bt
#0  __lll_unlock_elision (lock=0x7ffff7feb000, private=128) at 
../sysdeps/unix/sysv/linux/x86/elision-unlock.c:29
#1  0x00000000004482fa in fio_mutex_down_timeout (mutex=0x7ffff7feb000, 
msecs=10000) at mutex.c:141
#2  0x0000000000468dda in run_threads (sk_out=0x0) at backend.c:2183
#3  0x0000000000469487 in fio_backend (sk_out=0x0) at backend.c:2381
#4  0x0000000000486c42 in main (argc=2, argv=0x7fffffffdf18, 
envp=0x7fffffffdf30) at fio.c:63



-- 
Bruce

