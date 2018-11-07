Return-Path: <axboe@kernel.dk>
Subject: Re: Mention of fio by Apple
References: <CALjAwxjW8=DniS12hBvPXmd1Cp0NjEm9RewHAO8rHerDQg=eDQ@mail.gmail.com>
 <944db5fc-9ba8-870c-8e9d-50ff3d42bdd2@gydle.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <57c6c101-3149-6643-ae3b-6cf4d4f2b966@kernel.dk>
Date: Wed, 7 Nov 2018 13:57:15 -0700
MIME-Version: 1.0
In-Reply-To: <944db5fc-9ba8-870c-8e9d-50ff3d42bdd2@gydle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sebastien Boisvert <sboisvert@gydle.com>, Sitsofe Wheeler <sitsofe@gmail.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 11/5/18 8:00 AM, Sebastien Boisvert wrote:
> 
> 
> On 2018-11-04 5:44 a.m., Sitsofe Wheeler wrote:
>> Looks like someone is referencing an fio benchmark result on Apple's
>> Mac Mini page and whoever did it took care to respect the Moral
>> License (https://fio.readthedocs.io/en/latest/fio_doc.html#moral-license
>> ). From https://www.apple.com/mac-mini/ :
>>
>> "4. Testing conducted by Apple in October 2018 using preproduction
>> 3.2GHz 6-core Intel Core i7-based Mac mini systems with 64GB of RAM
>> and 1TB SSD, and shipping 3.0GHz dual-core Intel Core i7-based Mac
>> mini systems with 16GB of RAM and 1TB SSD. Tested with FIO 3.8, 1024KB
>> request size, 150GB test file and IO depth=8. Performance tests are
>> conducted using specific computer systems and reflect the approximate
>> performance of Mac mini."
>>
>> My only question is: as the depth was 8 were they using the posixaio engine?
>>
> 
> The foot note number 4 supports this claim:
> 
>     "Up to 4X faster read speed"
> 
> It would make sense to use asynchronous I/O since ioengine=psync is the default on Mac.

I'd be fine making that change, if someone can benchmark psync vs posixaio
in terms of latency in that platform.

Might also make sense to improve the setup so that we have a default
engine per OS depending on iodepth. For instance, on Linux, QD=1 should
just be psync. But if QD > 1, then we should default to libaio. I'm
afraid lots of folks have run iodepth=32 or whatever without changing
the IO engine and wondering what is going on.

If someone would like to work on that... There might be cookies as
a bonus.

-- 
Jens Axboe


