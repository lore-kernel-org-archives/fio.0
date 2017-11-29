Return-Path: <axboe@kernel.dk>
Subject: Re: Random distribution: zoned argument
References: <CAODBMzm2qZu=gcpDKLyQ27zyFgkDD1ieaw2b4=A869_zuQE7HA@mail.gmail.com>
 <261eb52b-e606-2736-d195-7abbcf2dd762@kernel.dk>
 <CAODBMzmD0o-bWNV0gpYNuFcQHo=BMLCVAALZvpPaVo36PFsd+w@mail.gmail.com>
 <2db67a6b-137f-42df-208d-1c4c97190fb2@kernel.dk>
 <ca7a2874-4f42-22c9-7d0b-04e251ab2532@kernel.dk>
 <CAODBMzkEkk8xqPFsEeFGSYL-dtJW5Q010ojuHRAcL=o71YcU7g@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <ad78196d-0e0b-bbf8-4c9f-02ce877b4051@kernel.dk>
Date: Wed, 29 Nov 2017 13:58:22 -0700
MIME-Version: 1.0
In-Reply-To: <CAODBMzkEkk8xqPFsEeFGSYL-dtJW5Q010ojuHRAcL=o71YcU7g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Phillip Chen <phillip.a.chen@seagate.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

I'll take a look at adding absolute zoning, should be pretty
trivial.


On 11/29/2017 01:39 PM, Phillip Chen wrote:
> Looks good, thanks for fixing this! If you find the time to add
> support to use block addresses in addition to percentage for
> specifying the zones, I think it would be quite useful. Thanks for the
> quick update,
> Phillip Chen
> 
> On Wed, Nov 29, 2017 at 12:37 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> OK, I checked that fix, it seems to do the trick. On top of that,
>> fio does support empty zones. If I run your script and change
>> the distribution to:
>>
>> dist_str = "zoned:50/5:0/90:50/5"
>>
>> to says "50% of access to the first 5% of the drive, nothing to
>> the middle 90% of the drive, and 50% to the last 5% of the drive",
>> I get:
>>
>> histogram percents = [50.02041783178578, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 49.97958216821422]
>>
>> which looks pretty spot on to me.
>>
>> I'm going to commit the fix.
>>
>> On 11/29/2017 12:33 PM, Jens Axboe wrote:
>>> We can add empty zones, that's fine, if that already doesn't work.
>>>
>>> For your case, can you try and kill this line:
>>>
>>>         qsort(o->zone_split[ddir], o->zone_split_nr[ddir], sizeof(struct zone_split), zone_cmp);
>>>
>>> in options.c:zone_split_ddir(), I have a feeling that's screwing us over.
>>>
>>>
>>> On 11/27/2017 04:18 PM, Phillip Chen wrote:
>>>> I agree that changing the zoned random distribution parameter to allow
>>>> absolute sizes would be an elegant way to address my use case. I'm not
>>>> sure if it would be easier to add that functionality to the zoned
>>>> distribution or create a new distribution named something like
>>>> zoned_sectors. I'd also like the ability to have zones that no I/O
>>>> will fall into. I think the easiest way to do that would be to allow 0
>>>> as a valid distribution percentage (I.E. something like
>>>> random_distribution=zoned:10/10:0/50:30/20:8/30:2/40). Currently it
>>>> seems I can specify 0 as a distribution percentage, but it doesn't
>>>> create a zero I/O zone like I would like it to. Although that might be
>>>> addressed just by making the zoned distribution randomize I/O as
>>>> expected.
>>>> Thanks for looking into this,
>>>> Phillip Chen
>>>>
>>>> On Mon, Nov 20, 2017 at 6:57 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>> On 11/20/2017 10:17 AM, Phillip Chen wrote:
>>>>>> Hello,
>>>>>> I'm a test engineer at Seagate and we're using FIO to gather some
>>>>>> performance data. This email has two parts: a bug report and a feature
>>>>>> request.
>>>>>> The bug that I'm seeing is that when using the
>>>>>> random_distribution=zoned argument, the zone order is not honored. So
>>>>>> using zoned:18/90:7/5:75/5 will not weight IO towards the end of the
>>>>>> disk but rather towards the beginning. Using zoned:75/5:7/5:18/90
>>>>>> apparently gives the same distribution, but also not the correct
>>>>>> distribution. I've attached a python3.6 script that shows this
>>>>>> behaviour. Here is the histogram information from running the two
>>>>>> zoned arguments as described above:
>>>>>>
>>>>>> Using fio --name=rand_reads --ioengine=libaio --direct=1 --exitall
>>>>>> --thread --filename=/dev/sdc --runtime=30 --readwrite=randread
>>>>>> --iodepth=1 --random_distribution=zoned:18/90:7/5:75/5 --norandommap
>>>>>> --output-format=terse
>>>>>> histogram bins = [2302, 25, 25, 30, 33, 36, 26, 32, 29, 37, 21, 21,
>>>>>> 32, 27, 49, 34, 24, 36, 26, 184]
>>>>>> histogram percents = [75.99867943215582, 0.8253549026081215,
>>>>>> 0.8253549026081215, 0.9904258831297458, 1.0894684714427203,
>>>>>> 1.188511059755695, 0.8583690987124464, 1.0564542753383954,
>>>>>> 0.9574116870254209, 1.2215252558600198, 0.6932981181908221,
>>>>>> 0.6932981181908221, 1.0564542753383954, 0.8913832948167713,
>>>>>> 1.6176956091119181, 1.1224826675470452, 0.7923407065037966,
>>>>>> 1.188511059755695, 0.8583690987124464, 6.074612083195774]
>>>>>>
>>>>>> Using fio --name=rand_reads --ioengine=libaio --direct=1 --exitall
>>>>>> --thread --filename=/dev/sdc --runtime=30 --readwrite=randread
>>>>>> --iodepth=1 --random_distribu   tion=zoned:75/5:7/5:18/90
>>>>>> --norandommap --output-format=terse
>>>>>> histogram bins = [2306, 25, 25, 30, 33, 36, 26, 32, 29, 37, 21, 21,
>>>>>> 32, 27, 49, 34, 24, 36, 26, 184]
>>>>>> histogram percents = [76.03033300362677, 0.8242664029014177,
>>>>>> 0.8242664029014177, 0.9891196834817013, 1.0880316518298714,
>>>>>> 1.1869436201780414, 0.8572370590174745, 1.0550609957138146,
>>>>>> 0.9561490273656446, 1.2199142762940982, 0.6923837784371909,
>>>>>> 0.6923837784371909, 1.0550609957138146, 0.8902077151335311,
>>>>>> 1.6155621496867787, 1.1210023079459281, 0.7912957467853611,
>>>>>> 1.1869436201780414, 0.8572370590174745, 6.0666007253544345]
>>>>>>
>>>>>> To run the script, use the -h flag to see usage, but at a minimum
>>>>>> you'll need to give the device handle to run on as the first argument
>>>>>> (the workload only does reads). The random_distribution argument is
>>>>>> set at the top of the file.
>>>>>
>>>>> I'll take a look at this tomorrow, that does seem very fishy.
>>>>>
>>>>>> Here is my environment information:
>>>>>> # cat /etc/centos-release
>>>>>> CentOS Linux release 7.3.1611 (Core)
>>>>>> # uname -r
>>>>>> 3.10.0-514.21.1.el7.x86_64
>>>>>> I used fio-3.2-13-g40e5f which was the newest version I could see as of today.
>>>>>>
>>>>>> As for the feature request:
>>>>>> I am trying to adapt our current FIO job files for FLEX testing which
>>>>>> is a new protocol we announced recently
>>>>>> (http://blog.seagate.com/intelligent/new-flex-dynamic-recording-method-redefines-data-center-hard-drive/)
>>>>>> that has some requirements on where writes/reads are allowed. I would
>>>>>> like to have better control where random reads and writes are going
>>>>>> using the zoned random_distribution setting using sector numbers
>>>>>> rather than capacity percentages. Would that be a possible feature to
>>>>>> add? Or is there an existing way to randomly read/write to
>>>>>> non-contiguous zones on the disk with varying sizes?
>>>>>
>>>>> The best way to request something like that is to come up with a logical
>>>>> way to describe it. That's usually the hardest part, implementing it is
>>>>> usually not that hard. This is especially important since it has to be
>>>>> intuitively easy to use for the user, not requiring them to pour too
>>>>> much over man pages.
>>>>>
>>>>> For yours, the zoned setup already supports split ranges for
>>>>> reads/writes/trims. The change seems to be that you want to give the
>>>>> zones in absolute sizes instead. It'd be the easiest to extend the
>>>>> zoning to allow sizes instead.
>>>>>
>>>>> --
>>>>> Jens Axboe
>>>>>
>>>
>>>
>>
>>
>> --
>> Jens Axboe
>>


-- 
Jens Axboe


