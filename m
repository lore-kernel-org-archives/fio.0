Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <7B5FFC71-BE67-435F-8DE6-8376E52754EB@nutanix.com>
References: <e044afaa-22ad-c7e2-d041-e2658f49bac8@bluestop.org>
 <CALjAwxjoTtRp1jVhfKMTcbn6wnmEmmCsjkpO7CkBgF5zj4B3Bg@mail.gmail.com>
 <9cf7d62a-5c4a-737a-d119-13763fb42c72@bluestop.org> <CALjAwxhxpLuLeysnp5kC-kQoWH++4hvehCWJxc9yA_Fcsy=pmw@mail.gmail.com>
 <BAE7B5AF-63F9-4E95-940D-7C84CE5AD92E@nutanix.com> <36259BEC-1CF0-45A5-85AE-F557989EDF30@nutanix.com>
 <2B8D69D8-05F3-4500-8A4E-F5DE21356676@nutanix.com> <CALjAwxiTX1=7pJKQ1Lz7nDkMXZqVJkMkNZDOA_XJYsEGP7wSfw@mail.gmail.com>
 <971ECD81-B100-4EEE-98CE-0E578A59BB02@nutanix.com> <7B5FFC71-BE67-435F-8DE6-8376E52754EB@nutanix.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 8 Mar 2018 15:13:00 +0000
Message-ID: <CALjAwxgF-2dK+Bc9iwkVsxA4sfWKYSmHe8k3YbpUyDmBWP34ow@mail.gmail.com>
Subject: Re: Windows: FIO randomly hangs using attached script
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Rob Scheepens <rob.scheepens@nutanix.com>
Cc: David Knierim <knierim@nutanix.com>, Rebecca Cran <rebecca@bluestop.org>, fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

OK wow that was big.

The threads from 3 - 101 seem to be stuck with a backtrace that looks
similar to this:

Thread 3 (Thread 3784.0xd38):
#0  0x00007ff845d06124 in ntdll!ZwWaitForSingleObject () from
C:\Windows\SYSTEM32\ntdll.dll
#1  0x00007ff842633acf in WaitForSingleObjectEx () from
C:\Windows\System32\KernelBase.dll
#2  0x000000000046c0df in pthread_mutex_lock_intern
(timeout=3D4294967295, m=3D0x1e1880)
    at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/mutex.c:167
#3  pthread_mutex_lock (m=3Dm@entry=3D0x1b0000) at
/usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/mutex.c:188
#4  0x0000000000441213 in fio_mutex_down (mutex=3D0x1b0000) at mutex.c:220
#5  0x0000000000446eae in sfree_pool (ptr=3D0x2bc6060, pool=3D0x55c980
<mp>) at smalloc.c:312
#6  sfree (ptr=3D0x2bc6070) at smalloc.c:336
#7  0x000000000042df59 in close_and_free_files (td=3Dtd@entry=3D0xb0d2960)
at filesetup.c:1358
#8  0x000000000045992c in thread_main (data=3D<optimized out>) at backend.c=
:1901
#9  0x000000000046df74 in pthread_create_wrapper (args=3D0x0)
    at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/thread.c:1492
#10 0x00007ff845a9b2ba in msvcrt!_beginthreadex () from
C:\Windows\System32\msvcrt.dll
#11 0x00007ff845a9b38c in msvcrt!_endthreadex () from
C:\Windows\System32\msvcrt.dll
#12 0x00007ff8448d8364 in KERNEL32!BaseThreadInitThunk () from
C:\Windows\System32\kernel32.dll
#13 0x00007ff845cc7091 in ntdll!RtlUserThreadStart () from
C:\Windows\SYSTEM32\ntdll.dll
#14 0x0000000000000000 in ?? ()
Backtrace stopped: previous frame inner to this frame (corrupt stack?)

From thread 102 - 201 things look like this:

Thread 102 (Thread 3784.0x8d4):
#0  0x00007ff845d061c4 in ntdll!ZwRemoveIoCompletion () from
C:\Windows\SYSTEM32\ntdll.dll
#1  0x00007ff84264ac2f in KERNELBASE!GetQueuedCompletionStatus () from
C:\Windows\System32\KernelBase.dll
#2  0x00000000004686b0 in IoCompletionRoutine (lpParameter=3D0xb001bd0)
at engines/windowsaio.c:427
#3  0x00007ff8448d8364 in KERNEL32!BaseThreadInitThunk () from
C:\Windows\System32\kernel32.dll
#4  0x00007ff845cc7091 in ntdll!RtlUserThreadStart () from
C:\Windows\SYSTEM32\ntdll.dll
#5  0x0000000000000000 in ?? ()
Backtrace stopped: previous frame inner to this frame (corrupt stack?)

For completeness here's Thread 1 and 2:

Thread 2 (Thread 3784.0x1574):
#0  0x00007ff845d06bf4 in ntdll!ZwWaitForMultipleObjects () from
C:\Windows\SYSTEM32\ntdll.dll
#1  0x00007ff84264796f in WaitForMultipleObjectsEx () from
C:\Windows\System32\KernelBase.dll
#2  0x00007ff84264786e in WaitForMultipleObjects () from
C:\Windows\System32\KernelBase.dll
#3  0x000000000046b31f in do_sema_b_wait_intern
(sema=3Dsema@entry=3D0x8cc, nointerrupt=3Dnointerrupt@entry=3D0,
    timeout=3Dtimeout@entry=3D500) at
/usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/cond.c:625
#4  0x000000000046b60e in do_sema_b_wait (sema=3D0x8cc, nointerrupt=3D0,
timeout=3D500, cs=3D0xafc9a60, val=3D0xafc9a88)
    at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/cond.c:584
#5  0x000000000046be8e in pthread_cond_timedwait_impl (c=3Dc@entry=3D0x2c2d=
0f8,
    external_mutex=3Dexternal_mutex@entry=3D0x2c2d0f0,
t=3Dt@entry=3D0x1ce9fe30, rel=3Drel@entry=3D0)
    at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/cond.c:504
#6  0x000000000046bea8 in pthread_cond_timedwait (c=3Dc@entry=3D0x2c2d0f8,
m=3Dm@entry=3D0x2c2d0f0, t=3Dt@entry=3D0x1ce9fe30)
    at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/cond.c:515
#7  0x0000000000466978 in helper_thread_main (data=3D0x2c2d0d0) at
helper_thread.c:95
#8  0x000000000046df74 in pthread_create_wrapper (args=3D0x0)
    at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/thread.c:1492
#9  0x00007ff845a9b2ba in msvcrt!_beginthreadex () from
C:\Windows\System32\msvcrt.dll
#10 0x00007ff845a9b38c in msvcrt!_endthreadex () from
C:\Windows\System32\msvcrt.dll
#11 0x00007ff8448d8364 in KERNEL32!BaseThreadInitThunk () from
C:\Windows\System32\kernel32.dll
#12 0x00007ff845cc7091 in ntdll!RtlUserThreadStart () from
C:\Windows\SYSTEM32\ntdll.dll
#13 0x0000000000000000 in ?? ()
Backtrace stopped: previous frame inner to this frame (corrupt stack?)

Thread 1 (Thread 3784.0x16fc):
#0  0x00007ff845d06724 in ntdll!ZwDelayExecution () from
C:\Windows\SYSTEM32\ntdll.dll
#1  0x00007ff842647b47 in SleepEx () from C:\Windows\System32\KernelBase.dl=
l
#2  0x0000000000469fa8 in usleep (useconds=3D<optimized out>,
useconds@entry=3D10000) at os/windows/posix.c:572
#3  0x000000000045d03a in do_usleep (usecs=3D10000) at backend.c:2129
#4  run_threads (sk_out=3Dsk_out@entry=3D0x0) at backend.c:2444
#5  0x000000000045d3da in fio_backend (sk_out=3Dsk_out@entry=3D0x0) at
backend.c:2493
#6  0x0000000000480329 in main (argc=3D4, argv=3D0x1e13c0, envp=3D<optimize=
d
out>) at fio.c:65

This could take a while to figure out!

On 8 March 2018 at 14:35, Rob Scheepens <rob.scheepens@nutanix.com> wrote:
> Sitsofe,
>
> See attached for the fio threads' backtraces.
>
> \Rob
>
>
> =EF=BB=BFOn 08/03/2018, 14:39, "Rob Scheepens" <rob.scheepens@nutanix.com=
> wrote:
>
>     I'll see if I can get gdb setup like that.
>
>     Below output shows spec 176 was the last job that ran ok, so you coul=
d try if it reproduces with 177. However, the job number exhibiting the han=
g usually is different every time.

--=20
Sitsofe | http://sucs.org/~sits/

