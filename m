Return-Path: <gavin_martin@xyratex.com>
MIME-Version: 1.0
In-Reply-To: <20130304142725.GP7485@kernel.dk>
References: <CANUChTxj5=ZXXkJkkRs-mFoWH7mX+DXjE+5KwYtuUFY3hvXqhw@mail.gmail.com>
 <20130304142725.GP7485@kernel.dk>
From: Gavin Martin <gavin_martin@xyratex.com>
Date: Mon, 4 Mar 2013 15:26:13 +0000
Message-ID: <CANUChTzLZBa0ex7pi+UZoJ_V==NW76bfh-F+YHPmGAc5HrOhDg@mail.gmail.com>
Subject: Re: Seq Write with holes
Content-Type: text/plain; charset=US-ASCII
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 4 March 2013 14:27, Jens Axboe <axboe@kernel.dk> wrote:
> On Mon, Mar 04 2013, Gavin Martin wrote:
>> Hi,
>>
>> I'm trying to setup a job file that tests interleaved data, so in
>> theory writing 256K blocks with a gap of 256K in between, the end
>> results is that I would like to write extra data into the gaps and
>> make sure it is not corrupting neighbouring areas.
>>
>> But I'm having a problem with the first part.
>>
>> Here is the jobfile:-
>>
>> [global]
>> ioengine=libaio
>> direct=1
>> filename=/dev/sdb
>> verify=meta
>> verify_backlog=1
>> verify_dump=1
>> verify_fatal=1
>> stonewall
>>
>> [Job 2]
>> name=SeqWrite256K
>> description=Sequential Write with 1M Bands (256K)
>> rw=write:1M
>> bs=256K
>> do_verify=0
>> verify_pattern=0x33333333
>> size=1G
>>
>> [Job 4]
>> name=SeqVerify256K
>> description=Sequential Read/Verify from Sequential Write (256K)
>> rw=read:1M
>> bs=256K
>> do_verify=1
>> verify_pattern=0x33333333
>> size=1G
>>
>> There seems to be a bug (or maybe by design) when using the 'size='
>> variable.  It seems to count the gaps (1M) within the size of 1G, but
>> only on the write, the reads seems to report the IO transferred as 1G
>>
>> Here is the status of the runs:-
>>
>> Run status group 0 (all jobs):
>>   WRITE: io=209920KB, aggrb=34039KB/s, minb=34039KB/s, maxb=34039KB/s,
>> mint=6167msec, maxt=6167msec
>>
>> Run status group 1 (all jobs):
>>    READ: io=1025.0MB, aggrb=36759KB/s, minb=36759KB/s, maxb=36759KB/s,
>> mint=28553msec, maxt=28553msec
>>
>> And you can see the Write IO is a lot lower than the Read IO, even
>> though I have asked it to cover the same disk space.
>>
>> It could be that this is by design and it is my jobfile that is not
>> setup correctly, has anybody tried something like this before?
>
> They should behave identically - if they don't, then that is a bug. I
> will take a look at this tomorrow.
>
> --
> Jens Axboe
>
Thanks Jens,

I'm not sure if interleaved is the right term, I suppose could also be
called testing bands?

I've just repeated using size=1% in case it was an issue with stating
a GB size, but it is still the same.

I was also using fio-2.0.14 so have just grabbed the latest from Git
(fio-2.0.14-23-g9c63) and it exhibits the same issue.

Regards,

-- 


------------------------------
For additional information including the registered office and the treatment of Xyratex confidential information please visit www.xyratex.com

------------------------------

