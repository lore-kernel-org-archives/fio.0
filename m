Return-Path: <axboe@kernel.dk>
Message-ID: <5427716A.1080407@kernel.dk>
Date: Sat, 27 Sep 2014 20:24:42 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [Question] How to perform stride access?
References: <542179FA.5040106@gmail.com>	<CANvN+enrUD45Zp1CJKQ3kxQncHLyhp7hE1jr4AnzRD65oDTUvg@mail.gmail.com>	<54228237.5000805@gmail.com>	<CALjAwxg+o05=3YDOmXaKskrdg3AHU88T-pkqZw=QFQkwRTjdwA@mail.gmail.com> <CALjAwxirUW+v662QZ9zQG-2zuTNtE8xkpfaJqv=5ArLviqjhGw@mail.gmail.com>
In-Reply-To: <CALjAwxirUW+v662QZ9zQG-2zuTNtE8xkpfaJqv=5ArLviqjhGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Akira Hayakawa <ruby.wktk@gmail.com>, andrey.v.kuzmin@gmail.com, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-09-24 15:22, Sitsofe Wheeler wrote:
> (Adding Jens to the CC list)
>
> On 24 September 2014 10:52, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>> On 24 September 2014 09:35, Akira Hayakawa <ruby.wktk@gmail.com> wrote:
>>>
>>> However, I [...] think I still have a problem.
>>>
>>> I modified the command
>>>
>>> From:
>>>>> fio --name=test --filename=#{dev.path} --rw=write --ioengine=libaio --direct=1 --io_limit=32M --size=100% --ba=4k --bs=512
>>> To:
>>> fio --name=test --filename=#{dev.path} --rw=write:4k --ioengine=libaio --direct=1 --io_limit=32M --bs=512
>>>
>>> The result is the runtime is too short.
>>
>> This looks like a bug. I can reproduce it with 2.1.11-11-gb7f5 too:
>>
>> dd if=/dev/zero of=/dev/shm/1M bs=1M count=1
>> fio --bs=4k --rw=write:4k --filename=/dev/shm/1M --stonewall --name=1M
>> --io_limit=1M  --name=2M --io_limit=2M
>> [...]
>>
>> Run status group 0 (all jobs):
>>    WRITE: io=512KB, aggrb=256000KB/s, minb=256000KB/s, maxb=256000KB/s,
>> mint=2msec, maxt=2msec
>>
>> Run status group 1 (all jobs):
>>    WRITE: io=512KB, aggrb=256000KB/s, minb=256000KB/s, maxb=256000KB/s,
>> mint=2msec, maxt=2msec
>>
>> Why isn't io 1024KB for group 0? Additionally, shouldn't the total io
>> written each group be different? Jens?

You are doing a sequential workload, skipping 4k every time. First write 
will be to offset 0, next to 8KB, etc. Write 128 would be to 1040384, 
which is 1MB - 8KB. Hence the next feasible offset after that would be 
1MB, which is end of the file. So how could it do more than 512KB of IO? 
That's 128 * 4KB.

I didn't read the whole thread in detail, just looked at your last 
example here. And for that one, I don't see anything wrong.

-- 
Jens Axboe


