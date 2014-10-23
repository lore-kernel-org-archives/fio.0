Return-Path: <michael.mattsson@gmail.com>
MIME-Version: 1.0
In-Reply-To: <53D6A95B.8020307@kernel.dk>
References: <CAE56cDuAUkhEnjMqCSWDcWrdwJrbffMcDG+FeCw6+7GN+jrWUg@mail.gmail.com>
 <53BE5286.2060203@kernel.dk> <CAE56cDvPKq31NrawN_KZF2+eDHiMY2A7azsx8z_DQfG1=-_cnw@mail.gmail.com>
 <53BEF29E.3040500@kernel.dk> <CAE56cDv7UmeGN=1rwyhbv7v5LfUkv+ueOoi+6KhnaXZYNx_7Fg@mail.gmail.com>
 <53BFCF22.8020407@kernel.dk> <CAE56cDtO9v3h2TkiyXQQ8dakmPiE+e-+wSazAc=XESOWA954Tg@mail.gmail.com>
 <53C0F4EC.9010107@kernel.dk> <CAFTzLMPFs0E4XphF5o155GiFaae0gGqJySswXpKUPPokPWoebw@mail.gmail.com>
 <53CCCA96.7010703@kernel.dk> <CAFTzLMP5GRx6R2HCykKN4pjkPLwHGafMc2HNh4gUONRRjBgYFg@mail.gmail.com>
 <53D20AA8.6020700@kernel.dk> <53D20DB8.10100@kernel.dk> <CAFTzLMPE+h_v8ydUP+iuCwJErQLuU=ZNcuKKcuxuZztandp+mQ@mail.gmail.com>
 <53D61053.9030902@kernel.dk> <CAFTzLMMP1tWNQ0tHj62enk-emhtX9sHv5wq+UCJpXO71RhB_NQ@mail.gmail.com>
 <53D6A95B.8020307@kernel.dk>
From: Michael Mattsson <michael.mattsson@gmail.com>
Date: Thu, 23 Oct 2014 08:57:37 -0700
Message-ID: <CAE56cDvVtc3kqw-BiEBwM2a34WB-csYMfR6TKjCtS9D=AUnJcw@mail.gmail.com>
Subject: Re: fio hangs with --status-interval
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Vasily Tarasov <tarasov@vasily.name>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hey,
Have there been any work on this? This is still an issue for me on fio
2.1.13. It happens less frequently but I've had two hangs in a sample
of ~40 runs.

Regards
Michael

On Mon, Jul 28, 2014 at 12:49 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-07-28 18:05, Vasily Tarasov wrote:
>>
>> Hi Jens,
>>
>> Thanks for looking into this. Here is the information you've requested:
>>
>> 1. Workload I'm running:
>>
>> <snip starts>
>>
>> [global]
>> rw=write
>> bs=8m
>> direct=0
>> thread=1
>> size=4g
>>
>> [sdaa]
>> filename=/dev/sdaa
>>
>> <snip ends>
>>
>> 2. That's what I see on the screen:
>>
>> <snip starts>
>>
>> # fio --status-interval 10 1.fio
>> sdaa: (g=0): rw=write, bs=8M-8M/8M-8M/8M-8M, ioengine=sync, iodepth=1
>> fio-2.1.11-10-gae7e
>> Starting 1 thread
>> Jobs: 1 (f=1): [W(1)] [-.-% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta
>> 00m:00s]
>> sdaa: (groupid=0, jobs=1): err= 0: pid=18849: Mon Jul 28 08:50:47 2014
>>    write: io=4096.0MB, bw=367567KB/s, iops=44, runt= 11411msec
>>      clat (usec): min=2400, max=3657, avg=2677.80, stdev=234.68
>>       lat (usec): min=2674, max=3968, avg=2948.69, stdev=269.71
>>      clat percentiles (usec):
>>       |  1.00th=[ 2448],  5.00th=[ 2480], 10.00th=[ 2512], 20.00th=[
>> 2544],
>>       | 30.00th=[ 2544], 40.00th=[ 2576], 50.00th=[ 2576], 60.00th=[
>> 2576],
>>       | 70.00th=[ 2608], 80.00th=[ 3024], 90.00th=[ 3120], 95.00th=[
>> 3152],
>>       | 99.00th=[ 3248], 99.50th=[ 3312], 99.90th=[ 3664], 99.95th=[
>> 3664],
>>       | 99.99th=[ 3664]
>>      bw (MB  /s): min= 2464, max= 2842, per=100.00%, avg=2712.77,
>> stdev=215.50
>>      lat (msec) : 4=100.00%
>>    cpu          : usr=1.31%, sys=13.92%, ctx=161, majf=0, minf=6
>>    IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>> >=64=0.0%
>>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >=64=0.0%
>>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >=64=0.0%
>>       issued    : total=r=0/w=512/d=0, short=r=0/w=0/d=0
>>       latency   : target=0, window=0, percentile=100.00%, depth=1
>>
>> Run status group 0 (all jobs):
>>    WRITE: io=4096.0MB, aggrb=367566KB/s, minb=367566KB/s,
>> maxb=367566KB/s, mint=11411msec, maxt=11411msec
>>
>> Disk stats (read/write):
>>    sdaa: ios=84/0, merge=0/0, ticks=43/0, in_queue=35, util=2.36%
>>
>> <snip ends>
>>
>> At this point fio does not exit. Below are the gdb backtraces. There
>> are three threads in the run. When I attach to one thread, get
>> backtrace, and then detach fio crashes with Segfault. So, to collect 3
>> backtraces, I ran the experiment 3 times and attached to a different
>> thread every time. Below, I change the PIDs so that they match the ps
>> output.
>>
>> # ps -eLf | grep fio
>> root     18844 10064 18844  0    3 08:50 pts/1    00:00:00 fio
>> --status-interval 10 1.fio
>> root     18844 10064 18862  0    3 08:50 pts/1    00:00:00 fio
>> --status-interval 10 1.fio
>> root     18844 10064 18863  0    3 08:50 pts/1    00:00:00 fio
>> --status-interval 10 1.fio
>> root     18902 18805 18902  0    1 08:53 pts/0    00:00:00 grep fio
>> # gdb
>> (gdb) attach 18844
>> (gdb) bt
>> #0  0x000000376f60b5bc in pthread_cond_wait@@GLIBC_2.3.2 () from
>> /lib64/libpthread.so.0
>> #1  0x0000000000430419 in fio_mutex_down (mutex=0x7ffff7ff6000) at
>> mutex.c:155
>> #2  0x0000000000411bc0 in stat_exit () at stat.c:1905
>> #3  0x000000000044c1d6 in fio_backend () at backend.c:2094
>> #4  0x000000376ee1ed1d in __libc_start_main () from /lib64/libc.so.6
>> #5  0x000000000040a679 in _start ()
>> (gdb) attach 1862
>> (gdb) bt
>> #0  0x000000376f60b5bc in pthread_cond_wait@@GLIBC_2.3.2 () from
>> /lib64/libpthread.so.0
>> #1  0x0000000000430419 in fio_mutex_down (mutex=0x7ffff7ff2000) at
>> mutex.c:155
>> #2  0x000000000041c717 in __show_running_run_stats (arg=0x72a330) at
>> stat.c:1445
>> #3  0x000000376f6079d1 in start_thread () from /lib64/libpthread.so.0
>> #4  0x000000376eee8b6d in clone () from /lib64/libc.so.6
>> (gdb) attach 1863
>> (gdb) bt
>> #0  0x000000376f60b5bc in pthread_cond_wait@@GLIBC_2.3.2 () from
>> /lib64/libpthread.so.0
>> #1  0x0000000000430419 in fio_mutex_down (mutex=0x7ffff7ff6000) at
>> mutex.c:155
>> #2  0x000000000041c5cd in __show_running_run_stats (arg=0x72a490) at
>> stat.c:1421
>> #3  0x000000376f6079d1 in start_thread () from /lib64/libpthread.so.0
>> #4  0x000000376eee8b6d in clone () from /lib64/libc.so.6
>>
>> Let me know if you need any additional information.
>
>
> This is perfect, makes a lot more sense. Progress on this may be a little
> slow, I'm on vacation this week... But expect something next week, at least.
>
>
> --
> Jens Axboe
>

