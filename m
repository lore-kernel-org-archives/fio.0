Return-Path: <axboe@kernel.dk>
Subject: Re: engine rbd broken after commit
 2466096336bd0fbc1a94811aa338926af6baf42f
References: <CADr68WZJ0+r4M5WArqvRkHHTAj=uLg8bi8xmGr+mMJ=KamQ+UQ@mail.gmail.com>
 <CADr68Wam45zdOL_d_4PPAZ-O8nfuoVxHDHnPUkCYqSd720FwYA@mail.gmail.com>
 <CADr68WaLSogc_a9PptZ0Q7MeG3Dhnp4QDAfbFzAOeykQNzj37A@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56967D27.1070803@kernel.dk>
Date: Wed, 13 Jan 2016 09:36:55 -0700
MIME-Version: 1.0
In-Reply-To: <CADr68WaLSogc_a9PptZ0Q7MeG3Dhnp4QDAfbFzAOeykQNzj37A@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Rosenboom <j.rosenboom@x-ion.de>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 01/11/2016 07:03 AM, Jens Rosenboom wrote:
> 2016-01-11 12:09 GMT+01:00 Jens Rosenboom <j.rosenboom@x-ion.de>:
>> 2016-01-08 12:15 GMT+01:00 Jens Rosenboom <j.rosenboom@x-ion.de>:
>>> When running fio-2.3 with the rbd engine, the tests themselves run
>>> fine, but instead of the results being printed, I get:
>>>
>>> fio: mutex.c:163: fio_mutex_down: Assertion `mutex->magic ==
>>> 0x4d555445U' failed.
>>>
>>> The command I am using is
>>>
>>> fio --ioengine=rbd --clientname=admin --pool=test --rbdname=test1
>>> --rw=randwrite --runtime=10 --ramp_time=None --numjobs=1 --direct=1
>>> --bs=1048576B --iodepth=64 --name=test1
>>>
>>> If I instead use another engine, everything is fine, e.g.:
>>>
>>> fio --ioengine=libaio --filename=/dev/sdb1 --rw=randwrite --runtime=10
>>> --ramp_time=None --numjobs=1 --direct=1 --bs=1048576B --iodepth=64
>>> --name=test1
>>>
>>> Going back to fio-2.2.13 makes the error go away and running a git
>>> bisect leads to the commit mentioned in the subject as the culprit,
>>> the error turns into a Segmentation Fault at that point, though.
>>
>> Accidentally I found out that I can also reproduce the bug with libaio if I set
>>
>> LD_PRELOAD=../jemalloc/lib/libjemalloc.so
>>
>> compiled from https://github.com/jemalloc/jemalloc.git (tested with
>> 3.6.0 and 4.0.4)
>>
>> So it seems there is some use-after-free issue in this commit. I'll
>> try to dig into this a bit more when I get the time, but I won't be
>> sad if someone else is faster. ;)
>
> In the standalone case, sk_out_key is used uninitialized, which may
> happen to work fine until some other library also uses a pthread_key,
> like it seems both librbd and libjemalloc do.
>
> Attached is a patch that fixes this.

Thanks for reporting this! I merged a cleaner fix, we can just set up 
the key earlier and not have to worry about server vs non-server. Can 
you check if current -git works for you?


-- 
Jens Axboe


