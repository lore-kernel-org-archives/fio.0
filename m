Return-Path: <amemushaj@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5425C0C7.8080303@kernel.dk>
References: <CA+BkS8NvVNyj3KDy3UjtD2G0q-B3Ai7sdbqwRu_DafLQmKk37Q@mail.gmail.com>
	<5425B9B7.2080003@kernel.dk>
	<5425C0C7.8080303@kernel.dk>
Date: Sat, 27 Sep 2014 12:19:46 +0100
Message-ID: <CA+BkS8MZ+TC=itWx4DSpRdqewhRNkNqSem08Em2KWBXWJ4DJMg@mail.gmail.com>
Subject: Re: dedupe and replay
From: Alket Memushaj <amemushaj@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

thanks for the quick response - but unfortunately this patch does not
seem to have changed the result. I managed to get a 1.4:1 dedupe when
setting dedupe_percentage to 99%. The test rig I have is like this: an
array w/ inline dedupe @ 4K and I am the only user on it - I have a
single machine mounting a single lun from the array (the whole space
in the array is assigned to this lun). The synthetic test at
dedupe_percentage=80 results in a 4:1 dedupe ratio from the array. The
replay at 80% comes out as undedupable (ratio = 1.0:1) even with the
latest patch. The replay generates about 1.7 million I/Os. ~1 million
are 4K, 80 thousand are 8K, 70 thousand are 32K, etc... there's a
decent number of I/O that is not a multiple of 4K, but the vast
majority of the I/O is a multiple of 4K. The offset for each I/O is 4K
aligned in the vast majority of I/Os.

On Fri, Sep 26, 2014 at 8:38 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 09/26/2014 01:08 PM, Jens Axboe wrote:
>> On 09/26/2014 12:30 PM, Alket Memushaj wrote:
>>> Hi,
>>>
>>> I am playing with the dedupe option and while it works well under
>>> synthetic tests, it doesn't seem to work when replaying a trace.
>>>
>>> My test jobs are simple:
>>>
>>> fio --name=replay --ioengine=libaio --direct=1 --iodepth=32
>>> --read_iolog=/path/to/trace --dedupe_percentage=80
>>
>> That should work, as far as I can tell, since we do the buffer fill
>> after the iolog retrieval has filled out an IO unit for us. Can you say
>> more about what doesn't appear to work?
>>
>>> I understand that block sizes would be variable during a trace replay,
>>> but is it possible to specify a base block size and calculate dedupe
>>> based on that for blocks that are multiples of the base size?
>>
>> Ah, that might be the key element here. Yes, the dedupe part might not
>> really work well for multiple write sizes. Nothing that inherently
>> prevents that from working, just didn't add that bit yet. Will do that.
>
> Does it work better with this patch?
>
> --
> Jens Axboe
>

