Return-Path: <axboe@kernel.dk>
Subject: Re: fio memory use seems .... large
References: <bd4ad58b-74ef-f07a-fe9d-69cd32b5e759@redhat.com>
 <3e3d79f3-0d24-6414-4018-9a578ca5de3b@kernel.dk>
 <746c56b8-0146-70a2-4f19-4824f1f381b7@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <55270d41-3272-92d2-e90a-2b5bbcb8837e@kernel.dk>
Date: Tue, 28 Apr 2020 18:51:42 -0600
MIME-Version: 1.0
In-Reply-To: <746c56b8-0146-70a2-4f19-4824f1f381b7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@redhat.com>, fio <fio@vger.kernel.org>
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 4/28/20 6:14 PM, Eric Sandeen wrote:
> On 4/28/20 6:55 PM, Jens Axboe wrote:
>> On 4/28/20 5:41 PM, Eric Sandeen wrote:
>>> This seems ... large, no?
>>>
>>> # /usr/bin/time -f "RSS %M kb" ./fio --name=writetest --filename=/mnt/testfile1 --rw=write --bs=4096 --size=64M --iodepth=1 --ioengine=libaio --direct=1 --verify=sha512 --do_verify=0
>>>
>>> RSS 1138748 kb
>>>
>>> and it got quite a bit larger with commit 
>>>
>>> df8781b6 fio: groundwork for adding slat, lat percentiles
>>>
>>> i.e. if I check out the commit just before that,
>>>
>>> ab45cf07 Merge branch 'stat-averaging-interval-start-fix' of https://github.com/maciejsszmigiero/fio
>>>
>>> I get:
>>>
>>> RSS 782236 kb
>>>
>>> which is, if I'm reading it right, ~350mb smaller.
>>>
>>> 760mb seems pretty big for a simple fio job like this in the first
>>> place, that commit growing it by 350mb is unexpected and I ... haven't
>>> been able to figure out where that increase came from.  Am I
>>> mis-analyzing something here?
>>
>> It probably got larger with that commit because it added to the
>> thread_data, and fio defaults to a large number of jobs... You can try
>> and add:
>>
>> --max-jobs=X
>>
>> to shrink the max jobs it supports, that'll reduce it drastically. I
>> think we default to 4k of jobs by default, or something like that, and
>> each job will consume ~274K.
> 
> Ah, that's what I was missing.  That commit grew an array by 3x but I
> couldn't get from there to 350MB.
> 
> It's obvious now, thanks! Not sure how I missed that.
> 
> OTOH, 4k default seems like a lot of overhead...

It is... I don't have any good ideas for how to make it better. We setup
this area before we parse jobs, because we add as we go. We can't
realloc it. We could add a layer of indirection, where 128 jobs (or
whatever) per area. That would just require changes to the 'threads'
indexing. Then you could simply add another area if you went above 128
threads, and so forth.

I might take a stab at it tonight. Recently had someone else complain
because they were running memory constrained. But at least the option
exists to make it smaller, so it doesn't require source changes.

-- 
Jens Axboe


