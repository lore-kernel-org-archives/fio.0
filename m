Return-Path: <axboe@kernel.dk>
Message-ID: <55C8CAF4.8020900@kernel.dk>
Date: Mon, 10 Aug 2015 10:01:56 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] verify: move meta header to generic verify_header
References: <1437767373-26631-1-git-send-email-r.peniaev@gmail.com>	<55B69F09.2010802@kernel.dk> <CACZ9PQX_8snVRoteGjhW00WhLrmKxwE4+BDkAboFOCnk0-UomQ@mail.gmail.com>
In-Reply-To: <CACZ9PQX_8snVRoteGjhW00WhLrmKxwE4+BDkAboFOCnk0-UomQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Roman Peniaev <r.peniaev@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 08/10/2015 05:29 AM, Roman Peniaev wrote:
> On Mon, Jul 27, 2015 at 11:13 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 07/24/2015 01:49 PM, Roman Pen wrote:
>>>
>>> fio does not provide any possibility to verify checksum of a block with
>>> meta
>>> information inside. You can create configuration for verifincation
>>> checksum
>>> of random data either you can verify meta information with some pattern or
>>> random data, but not both.
>>>
>>> Why checksumming and meta together can be useful? Meta helps to figure out
>>> internally
>>> on filesystem or storage what block was written in case of corruption,
>>> i.e. offset
>>> of the block and block number explicitly tell us the virtual address of
>>> the block.
>>> On the other hand checksum of random data helps to detect corruption.
>>> Using meta
>>> and pattern together do not help a lot, since 'verify_interval' can be big
>>> enough
>>> and same sequence of pattern bytes will be undistinguishable internally on
>>> filesystem
>>> or storage.
>>>
>>> Also, it seems to me that keeping meta header separately from generic
>>> verify header
>>> does not make a lot of sense, since generic verify header can include all
>>> members
>>> of meta header without any performance or other impact.
>>>
>>> In this patch I move all members from vhdr_meta structure to generic
>>> verify_header,
>>> always verifying meta with the possiblity to checksum the following data:
>>> random
>>> or pattern.
>>>
>>> You are allowed to specify verify_pattern=str with any of the possible
>>> verification
>>> methods and have also meta verification, i.e.
>>>
>>>      verify=md5
>>>      verify_pattern=0xfe
>>>
>>>    or
>>>
>>>      verify=sha1
>>>      verify_pattern=0xff
>>>
>>>    etc.
>>>
>>> To keep everything compatible with old configurations it is still possible
>>> to specify
>>>
>>>      verify=meta
>>>
>>> but this option marked and depricated and kept only for compatibility
>>> reasons.
>>>
>>> Before that patch the verification layout according to the specified
>>> options looks
>>> as the following, e.g.:
>>>
>>>    #1
>>>       --
>>>       verify=meta
>>>       verify_pattern=0xff
>>>       --
>>>
>>>       result layout of each block: [hdr|meta|pattern]
>>>
>>>    #2
>>>       --
>>>       verify_pattern=0xff
>>>       --
>>>
>>>       result layout of each block: [hdr|pattern]
>>>
>>>    #3
>>>       --
>>>       verify=pattern
>>>       verify_pattern=0xff
>>>       --
>>>
>>>       result layout of each block: [pattern]
>>>
>>> After applying of the patch 'vhdr_meta' is always embedded into
>>> 'verify_header' and layout
>>> looks as the following, e.g.:
>>>
>>>    #1
>>>       --
>>>       verify=meta
>>>       verify_pattern=0xff
>>>       --
>>>
>>>       result layout of each block: [hdr+meta|pattern]
>>>    #2
>>>       --
>>>       verify=md5|sha1|etc
>>>       verify_pattern=0xff
>>>       --
>>>
>>>       result layout of each block: [hdr+meta|cksum|pattern]
>>>
>>>    #3
>>>       --
>>>       verify_pattern=0xff
>>>       --
>>>
>>>       result layout of each block: [hdr+meta|pattern]
>>>
>>>    #4
>>>       --
>>>       verify=pattern
>>>       verify_pattern=0xff
>>>       --
>>>
>>>       result layout of each block: [pattern]
>>
>>
>> Good work! I'll make some time this week to fully review this, so we can get
>> it committed.
>
> Hi, Jens.
>
> Do you still have plans to review this patch?

I do, vacation came in the way, however. Back now, will get to it this week.

-- 
Jens Axboe


