Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CANvN+emkTn1aLk2MB41Z0hD3y0NLjoS3cz4jcF4w+ytP4A1d5w@mail.gmail.com>
References: <CALjAwxhfyQ3ppw-MXoRwAkhk4+-LSJSTkZQa32ymKizKU0Ox-A@mail.gmail.com>
 <5669B23C.1020001@kernel.dk> <CALjAwxjLXTCRe0Ky08DB6in2aq_czkx5Oz8Osi7Mo=+7eFH9PQ@mail.gmail.com>
 <CANvN+e=CtQBfUmj6fQPUgaqHUXwzwY1SLuXV76n=AG2kLFpWSQ@mail.gmail.com>
 <20151210181540.GB21415@kernel.dk> <CANvN+e=U5O4LC40uE59iGn1jtkBGygbboXGcKpfXO2uTX3=bVw@mail.gmail.com>
 <5669C364.9020100@kernel.dk> <CANvN+ekovkotiX=EVxrYxmh4DJv0=+Hh4LQD+X5Ut8jDYgTdHg@mail.gmail.com>
 <5669C46F.3090300@kernel.dk> <CANvN+emkTn1aLk2MB41Z0hD3y0NLjoS3cz4jcF4w+ytP4A1d5w@mail.gmail.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Fri, 11 Dec 2015 13:01:05 +0300
Message-ID: <CANvN+e=sgRBJiS8Toefk6nOHdtod1pr6bDPeux_audc5fUBUJg@mail.gmail.com>
Subject: Re: Exit all jobs on error
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

^Cbs: 1 (f=1): [w(1)] [0.0% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta
01d:12h:24m:29s]
Program received signal SIGINT, Interrupt.
0x00007ffff6b7ff3d in nanosleep () at ../sysdeps/unix/syscall-template.S:81
81 ../sysdeps/unix/syscall-template.S: No such file or directory.
(gdb) bt
#0  0x00007ffff6b7ff3d in nanosleep () at ../sysdeps/unix/syscall-template.S:81
#1  0x00007ffff6bb14a4 in usleep (useconds=<optimized out>) at
../sysdeps/unix/sysv/linux/usleep.c:32
#2  0x000000000045a7ed in do_usleep (usecs=10000) at backend.c:1951
#3  0x000000000045b33c in run_threads () at backend.c:2216
#4  0x000000000045b6a8 in fio_backend () at backend.c:2333
#5  0x00000000004991cb in main (argc=4, argv=0x7fffffffdda8,
envp=0x7fffffffddd0) at fio.c:60

Regards,
Andrey


On Thu, Dec 10, 2015 at 9:30 PM, Andrey Kuzmin
<andrey.v.kuzmin@gmail.com> wrote:
> On Thu, Dec 10, 2015 at 9:29 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 12/10/2015 11:27 AM, Andrey Kuzmin wrote:
>>>
>>> On Thu, Dec 10, 2015 at 9:24 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 12/10/2015 11:17 AM, Andrey Kuzmin wrote:
>>>>>
>>>>>
>>>>> On Thu, Dec 10, 2015 at 9:15 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>
>>>>>>
>>>>>> On Thu, Dec 10 2015, Andrey Kuzmin wrote:
>>>>>>>
>>>>>>>
>>>>>>> I've also encountered a similar issue a number of times where the job
>>>>>>> failed to stop (and refused to terminate in response to C-C) when a
>>>>>>> thread/process fails, e.g. due to an error. My guess is that the loop
>>>>>>> that waits for completions doesn't check for td->terminate being set.
>>>>>>
>>>>>>
>>>>>>
>>>>>> Attach with gdb and see what they are doing, could be a missing
>>>>>> terminate check. Or it could already be sitting waiting for
>>>>>> completions.
>>>>>
>>>>>
>>>>>
>>>>> It just sits there waiting for completions, as gdb understandably
>>>>> predominantly hits the wait state.
>>>>
>>>>
>>>>
>>>> Where is it sitting and/or looping?
>>>
>>>
>>> unix/wait smth ;), as far as I recall.
>>>
>>> If you need an exact ref, let me make up an error in the code, run,
>>> and get back to you with the exact gdb frame info.
>>
>>
>> I'm generally not in the crystal ball or guessing game :-)
>>
>> So yeah, a stack trace would be helpful.
>
> OK, will do.
>

^Cbs: 1 (f=1): [w(1)] [0.0% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta
01d:12h:24m:29s]
Program received signal SIGINT, Interrupt.
0x00007ffff6b7ff3d in nanosleep () at ../sysdeps/unix/syscall-template.S:81
81 ../sysdeps/unix/syscall-template.S: No such file or directory.
(gdb) bt
#0  0x00007ffff6b7ff3d in nanosleep () at ../sysdeps/unix/syscall-template.S:81
#1  0x00007ffff6bb14a4 in usleep (useconds=<optimized out>) at
../sysdeps/unix/sysv/linux/usleep.c:32
#2  0x000000000045a7ed in do_usleep (usecs=10000) at backend.c:1951
#3  0x000000000045b33c in run_threads () at backend.c:2216
#4  0x000000000045b6a8 in fio_backend () at backend.c:2333
#5  0x00000000004991cb in main (argc=4, argv=0x7fffffffdda8,
envp=0x7fffffffddd0) at fio.c:60

The log says "fio: terminating on signal 2", but killing it with ^C if
not running under gdb doesn't work - the job continues, seemingly
waiting for the completion that never comes.

Regards,
Andrey

>
> Regards,
> Andrey
>
>>
>> --
>> Jens Axboe
>>

