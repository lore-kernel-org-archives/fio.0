Return-Path: <karthick@pernixdata.com>
MIME-Version: 1.0
In-Reply-To: <5481EF86.3000900@kernel.dk>
References: <CAGmU4NRCBQkPHQzMwK4hVrQwUF0ngYKsbzOcXbJYucNHbndRRg@mail.gmail.com>
 <547FCA1C.1000808@kernel.dk> <547FCBC7.20309@kernel.dk> <547FCDC0.3000005@kernel.dk>
 <CAGmU4NSC=7ZjjnieWxjFs8xqrVjY0gdMGWwJCTRogXKpUzBbcA@mail.gmail.com>
 <54807D4F.9080207@kernel.dk> <5480E314.4070206@kernel.dk> <CAGmU4NR8fnz4869-9hjgWR4Za429WRjJHnvJE+-CwO-BF8VX4A@mail.gmail.com>
 <5481E539.3000806@kernel.dk> <5481E959.8020402@kernel.dk> <5481EF86.3000900@kernel.dk>
From: Karthick Srinivasachary <karthick@pernixdata.com>
Date: Fri, 5 Dec 2014 12:06:20 -0800
Message-ID: <CAGmU4NQ+SE_JHkmGKurGoJPDuhyQpAdz3foeWLf6GxdjCZz1hg@mail.gmail.com>
Subject: Re: Repeat given pattern with buffer_compress_percentage
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Great.. Works now..! Thank you for considering my request and
providing new feature in quick time. Appreciated..!

Regards,
Karthick

On Fri, Dec 5, 2014 at 9:46 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 12/05/2014 10:20 AM, Jens Axboe wrote:
>>
>> On 12/05/2014 10:02 AM, Jens Axboe wrote:
>>>
>>> On 12/05/2014 12:25 AM, Karthick Srinivasachary wrote:
>>>>
>>>> Hi Jens,
>>>>
>>>> Awesome.. Thanks for the fix..!
>>>> With compress_percentage 80 or more, fio verify is failing. I don't
>>>> think there any issue with storage in my test environment. Do you
>>>> think we have a bug here. Complete command and output below.
>>>>
>>>> /usr/local/bin/fio --name=global --ioengine=libaio --bsrange=16k-64k
>>>> --rw=randrw --iodepth=16 --direct=1 --verify=md5 --name=job0
>>>> --size=100m --filename=/fio/fio.dat --rw=randrw --rate=20m
>>>> --buffer_compress_percentage=80 --refill_buffers --buffer_pattern=123
>>>> --verify_dump=1
>>>
>>>
>>> You can't do a random read/write test, it'll fail on the reads that have
>>> not been populated. It might sometimes work if the file had been laid
>>> out prior with the right contents, but generally you cannot depend upon
>>> it. You want to do just --rw=randwrite and then the verify phase will
>>> take place after the writes are done, verifying those.
>>>
>>> Try and delete fio.dat prior to running this job, and it should fail
>>> consistently with or without buffer_compress_percentage.
>>
>>
>> I take it back, there is a bug there. Fio does skip verifying the reads
>> we generate initially, and verifies the written data after the
>> read/write phase. So it _should_ work, the fact that it doesn't is a
>> bug. I'll take a look at it.
>
>
> Fixed, pull and retry please.
>
> --
> Jens Axboe
>

