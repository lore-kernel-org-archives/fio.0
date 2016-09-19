Return-Path: <axboe@kernel.dk>
Subject: =?UTF-8?Q?Re:_Unaligned_zoned_write_with_bsrange_=e2=80=983k-1025K?=
 =?UTF-8?Q?=e2=80=99_always_fails_for_the_reason_being_=e2=80=98data_corrupt?=
 =?UTF-8?B?aW9u4oCZ?=
References: <CAE5BwqHyQzTx7gtGMXb7wE1xvysxeiopsCBijSHEzOx29PvzHg@mail.gmail.com>
 <f78587ff-29be-aeee-29e3-4f08873701c7@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <602fc719-1c9e-74a4-f968-b0995957467b@kernel.dk>
Date: Mon, 19 Sep 2016 15:09:38 -0600
MIME-Version: 1.0
In-Reply-To: <f78587ff-29be-aeee-29e3-4f08873701c7@kernel.dk>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
To: Sunil Nadumutlu <nadumutlusunil@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 09/19/2016 02:52 PM, Jens Axboe wrote:
> On 09/19/2016 06:30 AM, Sunil Nadumutlu wrote:
>> Hi Jens,
>>
>> I have been observing one interesting issue since couple of days where
>> write_verify is failing (due to data corruption) while running unaligned
>> zoned write with bsrange ‘3k-1025K’.
>> I have following fio CLI syntax tried on RHEL 7.0 client, by involving
>> raw device and filesystem on raw dev as well.
>>
>> Here are fio CLI syntax:
>> Raw device IO:
>> ==============
>>   fio  --runtime=43200  --filename=/dev/sdc --rw=randrw
>> --ioengine=libaio --direct=1 --time_based --verify=md5 --verify_dump=1
>> --verify_fatal=1 --threads=8 --zonesize=1m --zoneskip=1024
>> --name=zoning-unaligned-large --bsrange=3k-1025k --runtime=86400
>>
>> File system (ext4) IO:
>> ======================
>> fio  --runtime=43200  --filename=/tmp/xyz/fio3  --rw=randrw
>> --ioengine=libaio --direct=1 --time_based --verify=md5 --verify_dump=1
>> --verify_fatal=1 --threads=8 --zonesize=1m --zoneskip=1024
>> --name=zoning-unaligned-large --bsrange=3k-1025k --runtime=86400
>> --create_on_open=1 --filesize=500m
>> --buffer_pattern=0x48656c6c6f776f746c64
>>
>> write_verify always failed within few seconds on filesystem, and
>> write_verify failed on raw device within 2-3mins for the reason being
>> data corruption observed during write verification.
>> In case of raw dev, data mismatch was observed after 1K (sometiem it was
>> across block), however incase FS, data corruption was observed across
>> 3076 block.
>>
>> To narrow down the issue, I ran similar workload bs=3k ( no bsrange ,
>> and only fixed block) IO using vdbench and medusa tool, where test have
>> passed successfully. Hence I am thinking that this is not an issue with
>> storage array. At this time, I am just curious to know whether fio has
>> any known bug in this area. One thing to note here is that vdbench and
>> medusa doesn’t have block zoneing and bsrange option. It is always fixed
>> block size with these tools.
>>
>> Attached herewith are dumps collected from above 2 tests…
>> File system fio dump:
>> fio3.1390592.expected
>> fio3.1390592.received
>>
>> Raw dev fio dump:
>> sdc.3325952.expected
>> sdc.3325952.received
>>
>> Anticipating your help in this regard.
>
> Please send questions to the fio mailing list, fio@vger.kernel.org. I
> don't have time to answer all queries personally, plenty more people are
> capable of doing that.
>
> That said, you have multiple threads writing to the same file or device
> in both cases.

Actually, I take that back, looks like it's just a bad use case of
'thread' - it's a bool, so just 0/1 applies here. There's just one job
running in your test case.

Can you try and add experimental_verify=1 and see if that changes
anything for you?

-- 
Jens Axboe


