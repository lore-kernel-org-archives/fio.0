Return-Path: <axboe@kernel.dk>
Message-ID: <54E26953.9070001@kernel.dk>
Date: Mon, 16 Feb 2015 15:04:03 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Bug#776701: ssd-test 1g file size too small
References: <54CCD756.7000105@pocock.pro> <13200420.bigzCatb1k@merkaba>
In-Reply-To: <13200420.bigzCatb1k@merkaba>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Martin Steigerwald <ms@teamix.de>, Daniel Pocock <daniel@pocock.pro>, 776701@bugs.debian.org, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 02/04/2015 02:10 AM, Martin Steigerwald wrote:
> Hello Daniel, hi Jens,
>
> Am Samstag, 31. Januar 2015, 14:23:34 schrieb Daniel Pocock:
>> Package: fio
>> Version: 2.1.11-2
>> Severity: important
>>
>>
>> In the ssd-test sample config:
>>
>> https://sources.debian.net/src/fio/2.1.11-2/examples/ssd-test.fio/
>>
>>
>> The test size is 1GB, this line:
>>
>> size=1g
>>
>>
>> There are SSDs that have 1g caches and this leads to unhelpful results.
>>
>> One user I discussed this with had to use a 10g test file to get
>> consistent and meaningful results.
>>
>> Maybe bump the example to 10g or add a comment in front of that line.
>
> As the examples are taken from the upstream tarball, I suggest taking this
> upstream. I put upstream in Cc, Jens, what do you think about this?

Sure, that sounds fine to me. 1G is tiny by todays standards, 10G would 
be a lot more reasonable. I'll commit that change.

-- 
Jens Axboe


