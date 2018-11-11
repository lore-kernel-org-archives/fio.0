Return-Path: <axboe@kernel.dk>
Subject: Re: Mention of fio by Apple
References: <CALjAwxjW8=DniS12hBvPXmd1Cp0NjEm9RewHAO8rHerDQg=eDQ@mail.gmail.com>
 <944db5fc-9ba8-870c-8e9d-50ff3d42bdd2@gydle.com>
 <57c6c101-3149-6643-ae3b-6cf4d4f2b966@kernel.dk>
 <bf67cfd1-2750-ba5c-50ba-e56a15c1e393@gydle.com>
 <02706430-71fe-dc68-e5d4-6d89565f0432@kernel.dk>
 <CALjAwxihDGXAm5k_KQY69b9RiTWaphwhvfjt0BoicKF83di8Sw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d0e5e15b-bdb5-b20e-69c1-3791991fd84d@kernel.dk>
Date: Sun, 11 Nov 2018 08:51:42 -0700
MIME-Version: 1.0
In-Reply-To: <CALjAwxihDGXAm5k_KQY69b9RiTWaphwhvfjt0BoicKF83di8Sw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: sboisvert@gydle.com, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 11/11/18 1:03 AM, Sitsofe Wheeler wrote:
> On Fri, 9 Nov 2018 at 00:18, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 11/8/18 1:09 PM, Sebastien Boisvert wrote:
>>>
>>>
>>> On 2018-11-07 3:57 p.m., Jens Axboe wrote:
>>>> On 11/5/18 8:00 AM, Sebastien Boisvert wrote:
>>>>>
>>>>>
>>>>> On 2018-11-04 5:44 a.m., Sitsofe Wheeler wrote:
>>>>>> Looks like someone is referencing an fio benchmark result on Apple's
>>>>>> Mac Mini page and whoever did it took care to respect the Moral
>>>>>> License (https://fio.readthedocs.io/en/latest/fio_doc.html#moral-license
>>>>>> ). From https://www.apple.com/mac-mini/ :
>>>>>>
>>>>>> "4. Testing conducted by Apple in October 2018 using preproduction
>>>>>> 3.2GHz 6-core Intel Core i7-based Mac mini systems with 64GB of RAM
>>>>>> and 1TB SSD, and shipping 3.0GHz dual-core Intel Core i7-based Mac
>>>>>> mini systems with 16GB of RAM and 1TB SSD. Tested with FIO 3.8, 1024KB
>>>>>> request size, 150GB test file and IO depth=8. Performance tests are
>>>>>> conducted using specific computer systems and reflect the approximate
>>>>>> performance of Mac mini."
>>>>>>
>>>>>> My only question is: as the depth was 8 were they using the posixaio engine?
>>>>>>
>>>>>
>>>>> The foot note number 4 supports this claim:
>>>>>
>>>>>     "Up to 4X faster read speed"
>>>>>
>>>>> It would make sense to use asynchronous I/O since ioengine=psync is the default on Mac.
>>>>
>>>> I'd be fine making that change, if someone can benchmark psync vs posixaio
>>>> in terms of latency in that platform.
>>>>
>>>> Might also make sense to improve the setup so that we have a default
>>>> engine per OS depending on iodepth. For instance, on Linux, QD=1 should
>>>> just be psync. But if QD > 1, then we should default to libaio. I'm
>>>> afraid lots of folks have run iodepth=32 or whatever without changing
>>>> the IO engine and wondering what is going on.
>>>
>>> Would this change be *after* parse_options() has been called ?
>>>
>>> I looked at init.c and options.{h,c}.
>>
>> Right now we use FIO_PREFERRED_ENGINE to set the default engine, which
>> can be defined by the platform. I think we should drop that, don't set
>> a default, and instead add some logic to eg fixup_options() that sets
>> the preferred engine based on platform and depth. Probably want
>> platforms to define
>>
>> FIO_PREF_SYNC_ENGINE
>> FIO_PREF_ASYNC_ENGINE
>>
>> and just pick one of those depending on iodepth. Something like that.
> 
> I don't know this is a safe idea unless we are also going to start
> tweaking other defaults at the same time. Imagine someone going from
> iodepth=1 to iodepth=2 but with direct=0 set - ihey are now comparing
> pvsync iodepth=1 to libaio iodepth=2. Perhaps there should be an
> "best" ioengine that does what described?

That'll only happen IFF you didn't set ioengine. If ioengine is already
set, we should just log an info notification of some sort.

Documentation would also be useful, but judging on what kind of questions
get asked, not sure that would help a whole lot...

> I still wonder whether we should just warn if someone uses a
> synchronous engine with an iodepth > 1 when they aren't using one of
> the typical cases (https://github.com/axboe/fio/pull/347 + (libaio
> with direct=1) ) ...

We probably should. I think there's room for usability improvements
all around.

-- 
Jens Axboe


