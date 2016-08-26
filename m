Return-Path: <ras@datera.io>
MIME-Version: 1.0
In-Reply-To: <17a9e545-989f-d93f-0d01-70dedac27e9d@kernel.dk>
References: <CALLCBzR9SEF7wMo4m9z4rtimvhNEad17PaNN5w5o2nBo-POeJw@mail.gmail.com>
 <17a9e545-989f-d93f-0d01-70dedac27e9d@kernel.dk>
From: Ryan Stiles <ras@datera.io>
Date: Fri, 26 Aug 2016 16:09:28 -0700
Message-ID: <CALLCBzQfCqiqe2ot0FKqu=9b9nXb_dvy903C2U+bd1TpdZYPzQ@mail.gmail.com>
Subject: Re: fio hanging waiting of Futex lock in 2.12
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Thanks Jens,

I have the change built. I will leave the test running over the
weekend to see if it reproduces.  It was not very common before but I
did hit it twice in 2 days or every 500 sessions or so.

Ryan

On Thu, Aug 25, 2016 at 9:37 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 08/25/2016 10:16 AM, Ryan Stiles wrote:
>>
>> Good day,
>>
>>
>> I am running fio version 2.12 compiled with the noshmem option and
>> occasionally they get stuck. I have seen this twice in the last 2
>> days.:
>>
>> /tmp/fio-2.12-noshmem --version
>>
>> fio-2.12
>>
>>
>> fio command:
>>
>> /tmp/fio-2.12-noshmem
>> /var/tmp/fio.23959cf869a111e69bb800269eb5da06.cfg --output-format=json
>> --size=10g --status-interval=10
>>
>>
>> fio config file:
>>
>> [global]
>>
>> ioengine=libaio
>>
>> direct=1
>>
>> loops=1
>>
>> ramp_time=50
>>
>> runtime=300
>>
>> randrepeat=0
>>
>> group_reporting
>>
>> time_based=1
>>
>> filename=/dev/disk/by-uuid/069e5a48-1a50-437f-bbc0-4fa612565378
>>
>> filename=/dev/disk/by-uuid/0ed13d1e-3544-49fb-a757-143d186810c3
>>
>> filename=/dev/disk/by-uuid/fed1ec42-c168-45d4-b8f6-da54ccb4fdcd
>>
>> filename=/dev/disk/by-uuid/60f5d8f9-3014-40ee-bdef-9d0e87742fd9
>>
>> filename=/dev/disk/by-uuid/dcbf8aac-f39e-45d1-9b5a-1a62aed3fb8e
>>
>> filename=/dev/disk/by-uuid/3cbbd8dc-8efa-48df-80ba-f0a6375c12ee
>>
>> filename=/dev/disk/by-uuid/b960a7a4-c1b1-47ba-9883-fc9397fae0dc
>>
>> filename=/dev/disk/by-uuid/ea0f60d1-bd1d-4741-8529-cc816aad4632
>>
>> filename=/dev/disk/by-uuid/1f401ec1-4f47-49b1-9cf3-f38953714107
>>
>> filename=/dev/disk/by-uuid/0c7644d7-5f3d-405d-ae74-976f7d6ea4ff
>>
>> filename=/dev/disk/by-uuid/6e7dbb4c-5e01-436d-a053-972a59ba39ff
>>
>> filename=/dev/disk/by-uuid/4addf688-8b78-4681-88fb-a64a8649eba0
>>
>> filename=/dev/disk/by-uuid/2b7e8012-0e00-4a95-be3d-fb3b06b2c9f6
>>
>> filename=/dev/disk/by-uuid/7844d521-46aa-4a12-a69e-af0020370f3d
>>
>> filename=/dev/disk/by-uuid/a0f1719c-7638-4c9a-96f4-76080c5ef3a3
>>
>> filename=/dev/disk/by-uuid/ea44c274-9eb2-4061-af99-b45cdd87b59a
>>
>>
>> [30%_write_4k_bs_bandwidth]
>>
>> rw=randrw
>>
>> bs=4k
>>
>> rwmixread=70
>>
>> randrepeat=0
>>
>> numjobs=8
>>
>> iodepth=4096
>>
>>
>> when I attach to one of the processes (I am running 8 and they all say
>> the same thing):
>>
>> Process 826 attached
>>
>> futex(0x7f110e43802c, FUTEX_WAIT, 11, NULL
>>
>>
>> I did some searching and found this link which had a similar issue but
>> I couldn't find which version it was (from 2014 though) and it says
>> that the problem was fixed for the people involved.
>>
>> http://www.spinics.net/lists/fio/msg03558.html
>>
>> This is a much more recent link with an issue:
>>
>> https://github.com/axboe/fio/issues/52
>>
>>
>> But when I look at the code, I see the comment you put in for that
>> issue (I am assuming):
>>
>> clear_state = 1;
>>
>>
>>                 /*
>>
>>                  * Make sure we've successfully updated the rusage stats
>>
>>                  * before waiting on the stat mutex. Otherwise we could
>> have
>>
>>                  * the stat thread holding stat mutex and waiting for
>>
>>                  * the rusage_sem, which would never get upped because
>>
>>                  * this thread is waiting for the stat mutex.
>>
>>                  */
>>
>>                 check_u
>>
>> All of the threads are at this pthread_cond_wait:
>>
>> Thread 8 (Thread 0x7f10ede69700 (LWP 826)):
>>
>> #0  0x00007f110d0ce6d5 in pthread_cond_wait@@GLIBC_2.3.2 () from
>> /lib64/libpthread.so.0
>>
>> #1  0x0000000000443f49 in fio_mutex_down (mutex=0x7f110e438000) at
>> mutex.c:213
>>
>> #2  0x000000000045b73b in thread_main (data=<optimized out>) at
>> backend.c:1689
>>
>> #3  0x00007f110d0cadc5 in start_thread () from /lib64/libpthread.so.0
>>
>> #4  0x00007f110cbf3ced in clone () from /lib64/libc.so.6
>>
>>
>> But one of the thread is at a little big different pthread_cond_wait:
>>
>> Thread 9 (Thread 0x7f10ed668700 (LWP 785)):
>>
>> #0  0x00007f110d0ce6d5 in pthread_cond_wait@@GLIBC_2.3.2 () from
>> /lib64/libpthread.so.0
>>
>> #1  0x0000000000443f49 in fio_mutex_down (mutex=0x7f110e436000) at
>> mutex.c:213
>>
>> #2  0x000000000042dbfe in __show_running_run_stats () at stat.c:1762
>>
>> #3  0x0000000000467ba9 in helper_thread_main (data=0x7f110b4802f0) at
>> helper_thread.c:122
>>
>> #4  0x00007f110d0cadc5 in start_thread () from /lib64/libpthread.so.0
>>
>> #5  0x00007f110cbf3ced in clone () from /lib64/libc.so.6
>>
>>
>> Looks like that mutex isn't getting woken up by thread 9 for some reason.
>>
>>
>> Any idea what could be causing this?
>
>
> Hmm, can you try with the below patch?
>
> diff --git a/backend.c b/backend.c
> index bb0200bb2b0f..31653f4f94c1 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -1684,9 +1684,13 @@ static void *thread_main(void *data)
>                  * the rusage_sem, which would never get upped because
>                  * this thread is waiting for the stat mutex.
>                  */
> -               check_update_rusage(td);
> +               do {
> +                       check_update_rusage(td);
> +                       if (!fio_mutex_down_trylock(stat_mutex))
> +                               break;
> +                       usleep(1000);
> +               } while (1);
>
> -               fio_mutex_down(stat_mutex);
>                 if (td_read(td) && td->io_bytes[DDIR_READ])
>                         update_runtime(td, elapsed_us, DDIR_READ);
>                 if (td_write(td) && td->io_bytes[DDIR_WRITE])
>
> --
> Jens Axboe

