Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxjPGXSOGwLOSMfVdrmxXsr8ObT6W6E1UBs2LkjttSnduw@mail.gmail.com>
References: <e044afaa-22ad-c7e2-d041-e2658f49bac8@bluestop.org>
 <CALjAwxjoTtRp1jVhfKMTcbn6wnmEmmCsjkpO7CkBgF5zj4B3Bg@mail.gmail.com>
 <9cf7d62a-5c4a-737a-d119-13763fb42c72@bluestop.org> <CALjAwxhxpLuLeysnp5kC-kQoWH++4hvehCWJxc9yA_Fcsy=pmw@mail.gmail.com>
 <BAE7B5AF-63F9-4E95-940D-7C84CE5AD92E@nutanix.com> <36259BEC-1CF0-45A5-85AE-F557989EDF30@nutanix.com>
 <2B8D69D8-05F3-4500-8A4E-F5DE21356676@nutanix.com> <CALjAwxiTX1=7pJKQ1Lz7nDkMXZqVJkMkNZDOA_XJYsEGP7wSfw@mail.gmail.com>
 <971ECD81-B100-4EEE-98CE-0E578A59BB02@nutanix.com> <7B5FFC71-BE67-435F-8DE6-8376E52754EB@nutanix.com>
 <CALjAwxgF-2dK+Bc9iwkVsxA4sfWKYSmHe8k3YbpUyDmBWP34ow@mail.gmail.com>
 <CALjAwxirkjduZof+F3prrKX0wp9YS8apS-YdK8+ru1supg1dnA@mail.gmail.com> <CALjAwxjPGXSOGwLOSMfVdrmxXsr8ObT6W6E1UBs2LkjttSnduw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 8 Mar 2018 22:44:58 +0000
Message-ID: <CALjAwxhEB9UhqHX0HZEG5MD8DYj2ah=+Ar1GG-Dq1ejhdoL27w@mail.gmail.com>
Subject: Re: Windows: FIO randomly hangs using attached script
Content-Type: text/plain; charset="UTF-8"
To: Rob Scheepens <rob.scheepens@nutanix.com>
Cc: David Knierim <knierim@nutanix.com>, Rebecca Cran <rebecca@bluestop.org>, fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 8 March 2018 at 15:59, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> On 8 March 2018 at 15:46, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>> (I'm going to bottom post for now)
>>
>> On 8 March 2018 at 15:13, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>> OK wow that was big.
>>>
>>> The threads from 3 - 101 seem to be stuck with a backtrace that looks
>>> similar to this:
>>>
>>> Thread 3 (Thread 3784.0xd38):
>>> #0  0x00007ff845d06124 in ntdll!ZwWaitForSingleObject () from
>>> C:\Windows\SYSTEM32\ntdll.dll
>>> #1  0x00007ff842633acf in WaitForSingleObjectEx () from
>>> C:\Windows\System32\KernelBase.dll
>>> #2  0x000000000046c0df in pthread_mutex_lock_intern
>>> (timeout=4294967295, m=0x1e1880)
>>>     at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/mutex.c:167
>>> #3  pthread_mutex_lock (m=m@entry=0x1b0000) at
>>> /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/mutex.c:188
>>> #4  0x0000000000441213 in fio_mutex_down (mutex=0x1b0000) at mutex.c:220
>>> #5  0x0000000000446eae in sfree_pool (ptr=0x2bc6060, pool=0x55c980
>>> <mp>) at smalloc.c:312
>>> #6  sfree (ptr=0x2bc6070) at smalloc.c:336
>>> #7  0x000000000042df59 in close_and_free_files (td=td@entry=0xb0d2960)
>>> at filesetup.c:1358
>>> #8  0x000000000045992c in thread_main (data=<optimized out>) at backend.c:1901
>>> #9  0x000000000046df74 in pthread_create_wrapper (args=0x0)
>>>     at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/thread.c:1492
>>> #10 0x00007ff845a9b2ba in msvcrt!_beginthreadex () from
>>> C:\Windows\System32\msvcrt.dll
>>> #11 0x00007ff845a9b38c in msvcrt!_endthreadex () from
>>> C:\Windows\System32\msvcrt.dll
>>> #12 0x00007ff8448d8364 in KERNEL32!BaseThreadInitThunk () from
>>> C:\Windows\System32\kernel32.dll
>>> #13 0x00007ff845cc7091 in ntdll!RtlUserThreadStart () from
>>> C:\Windows\SYSTEM32\ntdll.dll
>>> #14 0x0000000000000000 in ?? ()
>>> Backtrace stopped: previous frame inner to this frame (corrupt stack?)
>>>
>>> From thread 102 - 201 things look like this:
>>>
>>> Thread 102 (Thread 3784.0x8d4):
>>> #0  0x00007ff845d061c4 in ntdll!ZwRemoveIoCompletion () from
>>> C:\Windows\SYSTEM32\ntdll.dll
>>> #1  0x00007ff84264ac2f in KERNELBASE!GetQueuedCompletionStatus () from
>>> C:\Windows\System32\KernelBase.dll
>>> #2  0x00000000004686b0 in IoCompletionRoutine (lpParameter=0xb001bd0)
>>> at engines/windowsaio.c:427
>>> #3  0x00007ff8448d8364 in KERNEL32!BaseThreadInitThunk () from
>>> C:\Windows\System32\kernel32.dll
>>> #4  0x00007ff845cc7091 in ntdll!RtlUserThreadStart () from
>>> C:\Windows\SYSTEM32\ntdll.dll
>>> #5  0x0000000000000000 in ?? ()
>>> Backtrace stopped: previous frame inner to this frame (corrupt stack?)
>>>
>>> For completeness here's Thread 1 and 2:
>>>
>>> Thread 2 (Thread 3784.0x1574):
>>> #0  0x00007ff845d06bf4 in ntdll!ZwWaitForMultipleObjects () from
>>> C:\Windows\SYSTEM32\ntdll.dll
>>> #1  0x00007ff84264796f in WaitForMultipleObjectsEx () from
>>> C:\Windows\System32\KernelBase.dll
>>> #2  0x00007ff84264786e in WaitForMultipleObjects () from
>>> C:\Windows\System32\KernelBase.dll
>>> #3  0x000000000046b31f in do_sema_b_wait_intern
>>> (sema=sema@entry=0x8cc, nointerrupt=nointerrupt@entry=0,
>>>     timeout=timeout@entry=500) at
>>> /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/cond.c:625
>>> #4  0x000000000046b60e in do_sema_b_wait (sema=0x8cc, nointerrupt=0,
>>> timeout=500, cs=0xafc9a60, val=0xafc9a88)
>>>     at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/cond.c:584
>>> #5  0x000000000046be8e in pthread_cond_timedwait_impl (c=c@entry=0x2c2d0f8,
>>>     external_mutex=external_mutex@entry=0x2c2d0f0,
>>> t=t@entry=0x1ce9fe30, rel=rel@entry=0)
>>>     at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/cond.c:504
>>> #6  0x000000000046bea8 in pthread_cond_timedwait (c=c@entry=0x2c2d0f8,
>>> m=m@entry=0x2c2d0f0, t=t@entry=0x1ce9fe30)
>>>     at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/cond.c:515
>>> #7  0x0000000000466978 in helper_thread_main (data=0x2c2d0d0) at
>>> helper_thread.c:95
>>> #8  0x000000000046df74 in pthread_create_wrapper (args=0x0)
>>>     at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/thread.c:1492
>>> #9  0x00007ff845a9b2ba in msvcrt!_beginthreadex () from
>>> C:\Windows\System32\msvcrt.dll
>>> #10 0x00007ff845a9b38c in msvcrt!_endthreadex () from
>>> C:\Windows\System32\msvcrt.dll
>>> #11 0x00007ff8448d8364 in KERNEL32!BaseThreadInitThunk () from
>>> C:\Windows\System32\kernel32.dll
>>> #12 0x00007ff845cc7091 in ntdll!RtlUserThreadStart () from
>>> C:\Windows\SYSTEM32\ntdll.dll
>>> #13 0x0000000000000000 in ?? ()
>>> Backtrace stopped: previous frame inner to this frame (corrupt stack?)
>>>
>>> Thread 1 (Thread 3784.0x16fc):
>>> #0  0x00007ff845d06724 in ntdll!ZwDelayExecution () from
>>> C:\Windows\SYSTEM32\ntdll.dll
>>> #1  0x00007ff842647b47 in SleepEx () from C:\Windows\System32\KernelBase.dll
>>> #2  0x0000000000469fa8 in usleep (useconds=<optimized out>,
>>> useconds@entry=10000) at os/windows/posix.c:572
>>> #3  0x000000000045d03a in do_usleep (usecs=10000) at backend.c:2129
>>> #4  run_threads (sk_out=sk_out@entry=0x0) at backend.c:2444
>>> #5  0x000000000045d3da in fio_backend (sk_out=sk_out@entry=0x0) at
>>> backend.c:2493
>>> #6  0x0000000000480329 in main (argc=4, argv=0x1e13c0, envp=<optimized
>>> out>) at fio.c:65
>>>
>>> This could take a while to figure out!
>>
>> Here a thread in among the others that looks different:
>>
>> Thread 53 (Thread 3784.0xca0):
>> #0  0x00007ff845d06124 in ntdll!ZwWaitForSingleObject () from
>> C:\Windows\SYSTEM32\ntdll.dll
>> #1  0x00007ff842633acf in WaitForSingleObjectEx () from
>> C:\Windows\System32\KernelBase.dll
>> #2  0x000000000046b4cc in do_sema_b_wait_intern (sema=sema@entry=0xa8,
>> nointerrupt=nointerrupt@entry=1,
>>     timeout=timeout@entry=4294967295) at
>> /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/cond.c:601
>> #3  0x000000000046b60e in do_sema_b_wait (sema=0xa8, nointerrupt=1,
>> timeout=4294967295, cs=0x1e15f0, val=0x1e1618)
>>     at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/cond.c:584
>> #4  0x000000000046b89f in pthread_cond_signal (c=<optimized out>)
>>     at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/cond.c:327
>> #5  0x00000000004412c0 in fio_mutex_up (mutex=<optimized out>) at mutex.c:246
>> #6  0x0000000000446feb in sfree_pool (ptr=<optimized out>,
>> pool=<optimized out>) at smalloc.c:317
>> #7  sfree (ptr=<optimized out>) at smalloc.c:336
>> #8  0x000000000042df59 in close_and_free_files (td=td@entry=0xb4e02a0)
>> at filesetup.c:1358
>> #9  0x000000000045992c in thread_main (data=<optimized out>) at backend.c:1901
>> #10 0x000000000046df74 in pthread_create_wrapper (args=0x0)
>>     at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/thread.c:1492
>> #11 0x00007ff845a9b2ba in msvcrt!_beginthreadex () from
>> C:\Windows\System32\msvcrt.dll
>> #12 0x00007ff845a9b38c in msvcrt!_endthreadex () from
>> C:\Windows\System32\msvcrt.dll
>> #13 0x00007ff8448d8364 in KERNEL32!BaseThreadInitThunk () from
>> C:\Windows\System32\kernel32.dll
>> #14 0x00007ff845cc7091 in ntdll!RtlUserThreadStart () from
>> C:\Windows\SYSTEM32\ntdll.dll
>> #15 0x0000000000000000 in ?? ()
>> Backtrace stopped: previous frame inner to this frame (corrupt stack?)
>
> So it looks like the smalloc.c pool->lock was heavily contended. One
> thread downed the mutex, got into the critical section, did its thing
> then after unlocking the mutex got stuck trying to let one of the
> people who might be waiting to wake up:
>
> mutex.c
> 243         pthread_mutex_unlock(&mutex->lock);
> 244
> 245         if (do_wake)
> 246                 pthread_cond_signal(&mutex->cond);
>
> This is odd. Why would a thread get stuck on that call?

Things I missed previously:

Thread 91 (Thread 3784.0x1528):
#0  0x00007ff845d09814 in ntdll!ZwWaitForAlertByThreadId () from
C:\Windows\SYSTEM32\ntdll.dll
#1  0x00007ff845c8faa7 in ntdll!RtlpUnWaitCriticalSection () from
C:\Windows\SYSTEM32\ntdll.dll
#2  0x00007ff845c8f9ae in ntdll!RtlpUnWaitCriticalSection () from
C:\Windows\SYSTEM32\ntdll.dll
#3  0x00007ff845c8f83f in ntdll!RtlpUnWaitCriticalSection () from
C:\Windows\SYSTEM32\ntdll.dll
#4  0x00007ff845c90d04 in ntdll!RtlEnterCriticalSection () from
C:\Windows\SYSTEM32\ntdll.dll
#5  0x00007ff845c90c30 in ntdll!RtlEnterCriticalSection () from
C:\Windows\SYSTEM32\ntdll.dll
#6  0x000000000046baaf in pthread_cond_wait (c=c@entry=0x1b0008,
external_mutex=external_mutex@entry=0x1b0000)
    at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/cond.c:437
#7  0x0000000000441232 in fio_mutex_down (mutex=0x1b0000) at mutex.c:224
#8  0x0000000000446eae in sfree_pool (ptr=0x2c22bc0, pool=0x55c980
<mp>) at smalloc.c:312
#9  sfree (ptr=0x2c22bd0) at smalloc.c:336
#10 0x000000000042df76 in close_and_free_files (td=td@entry=0xb782970)
at filesetup.c:1367
#11 0x000000000045992c in thread_main (data=<optimized out>) at backend.c:1901
#12 0x000000000046df74 in pthread_create_wrapper (args=0x0)
    at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/thread.c:1492
#13 0x00007ff845a9b2ba in msvcrt!_beginthreadex () from
C:\Windows\System32\msvcrt.dll
#14 0x00007ff845a9b38c in msvcrt!_endthreadex () from
C:\Windows\System32\msvcrt.dll
#15 0x00007ff8448d8364 in KERNEL32!BaseThreadInitThunk () from
C:\Windows\System32\kernel32.dll
#16 0x00007ff845cc7091 in ntdll!RtlUserThreadStart () from
C:\Windows\SYSTEM32\ntdll.dll
#17 0x0000000000000000 in ?? ()
Backtrace stopped: previous frame inner to this frame (corrupt stack?)

Thread 41 (Thread 3784.0xd20):
#0  0x00007ff845d06bf4 in ntdll!ZwWaitForMultipleObjects () from
C:\Windows\SYSTEM32\ntdll.dll
#1  0x00007ff84264796f in WaitForMultipleObjectsEx () from
C:\Windows\System32\KernelBase.dll
#2  0x00007ff84264786e in WaitForMultipleObjects () from
C:\Windows\System32\KernelBase.dll
#3  0x000000000046b31f in do_sema_b_wait_intern (sema=sema@entry=0xa4,
nointerrupt=nointerrupt@entry=0,
    timeout=timeout@entry=4294967295) at
/usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/cond.c:625
#4  0x000000000046b60e in do_sema_b_wait (sema=0xa4, nointerrupt=0,
timeout=4294967295, cs=0x1e15c0, val=0x1e15e8)
    at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/cond.c:584
#5  0x000000000046bb91 in pthread_cond_wait (c=c@entry=0x1b0008,
external_mutex=external_mutex@entry=0x1b0000)
    at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/cond.c:451
#6  0x0000000000441232 in fio_mutex_down (mutex=0x1b0000) at mutex.c:224
#7  0x0000000000446eae in sfree_pool (ptr=0x2bf3420, pool=0x55c980
<mp>) at smalloc.c:312
#8  sfree (ptr=0x2bf3430) at smalloc.c:336
#9  0x000000000042df59 in close_and_free_files (td=td@entry=0xb410a60)
at filesetup.c:1358
#10 0x000000000045992c in thread_main (data=<optimized out>) at backend.c:1901
#11 0x000000000046df74 in pthread_create_wrapper (args=0x0)
    at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/thread.c:1492
#12 0x00007ff845a9b2ba in msvcrt!_beginthreadex () from
C:\Windows\System32\msvcrt.dll
#13 0x00007ff845a9b38c in msvcrt!_endthreadex () from
C:\Windows\System32\msvcrt.dll
#14 0x00007ff8448d8364 in KERNEL32!BaseThreadInitThunk () from
C:\Windows\System32\kernel32.dll
#15 0x00007ff845cc7091 in ntdll!RtlUserThreadStart () from
C:\Windows\SYSTEM32\ntdll.dll
#16 0x0000000000000000 in ?? ()
Backtrace stopped: previous frame inner to this frame (corrupt stack?)

Thread 23 (Thread 3784.0x1404):
#0  0x00007ff845d06bf4 in ntdll!ZwWaitForMultipleObjects () from
C:\Windows\SYSTEM32\ntdll.dll
#1  0x00007ff84264796f in WaitForMultipleObjectsEx () from
C:\Windows\System32\KernelBase.dll
#2  0x00007ff84264786e in WaitForMultipleObjects () from
C:\Windows\System32\KernelBase.dll
#3  0x000000000046b31f in do_sema_b_wait_intern (sema=sema@entry=0xa4,
nointerrupt=nointerrupt@entry=0,
    timeout=timeout@entry=4294967295) at
/usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/cond.c:625
#4  0x000000000046b60e in do_sema_b_wait (sema=0xa4, nointerrupt=0,
timeout=4294967295, cs=0x1e15c0, val=0x1e15e8)
    at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/cond.c:584
#5  0x000000000046bb91 in pthread_cond_wait (c=c@entry=0x1b0008,
external_mutex=external_mutex@entry=0x1b0000)
    at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/cond.c:451
#6  0x0000000000441232 in fio_mutex_down (mutex=0x1b0000) at mutex.c:224
#7  0x0000000000446eae in sfree_pool (ptr=0x2bdee20, pool=0x55c980
<mp>) at smalloc.c:312
#8  sfree (ptr=0x2bdee30) at smalloc.c:336
#9  0x000000000042df76 in close_and_free_files (td=td@entry=0xb294340)
at filesetup.c:1367
#10 0x000000000045992c in thread_main (data=<optimized out>) at backend.c:1901
#11 0x000000000046df74 in pthread_create_wrapper (args=0x0)
    at /usr/src/debug/mingw64-x86_64-winpthreads-5.0.3-1/src/thread.c:1492
#12 0x00007ff845a9b2ba in msvcrt!_beginthreadex () from
C:\Windows\System32\msvcrt.dll
#13 0x00007ff845a9b38c in msvcrt!_endthreadex () from
C:\Windows\System32\msvcrt.dll
#14 0x00007ff8448d8364 in KERNEL32!BaseThreadInitThunk () from
C:\Windows\System32\kernel32.dll
#15 0x00007ff845cc7091 in ntdll!RtlUserThreadStart () from
C:\Windows\SYSTEM32\ntdll.dll
#16 0x0000000000000000 in ?? ()
Backtrace stopped: previous frame inner to this frame (corrupt stack?)

So three threads made it to pthread_cond_wait and presumably one of
these was trying to be woken by the pthread_cond_signal().

Something else that seems strange is why would so many threads have
stacks like this:

Thread 200 (Thread 3784.0xe70):
#0  0x00007ff845d061c4 in ntdll!ZwRemoveIoCompletion () from
C:\Windows\SYSTEM32\ntdll.dll
#1  0x00007ff84264ac2f in KERNELBASE!GetQueuedCompletionStatus () from
C:\Windows\System32\KernelBase.dll
#2  0x00000000004686b0 in IoCompletionRoutine (lpParameter=0x32b948b0)
at engines/windowsaio.c:427
#3  0x00007ff8448d8364 in KERNEL32!BaseThreadInitThunk () from
C:\Windows\System32\kernel32.dll
#4  0x00007ff845cc7091 in ntdll!RtlUserThreadStart () from
C:\Windows\SYSTEM32\ntdll.dll
#5  0x0000000000000000 in ?? ()

Surely the threads in windowsaio should still be able to make progress?

-- 
Sitsofe | http://sucs.org/~sits/

