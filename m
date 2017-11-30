Return-Path: <phillip.a.chen@seagate.com>
MIME-Version: 1.0
In-Reply-To: <e68f2b27-05dc-1329-6649-3b5b641bfb40@kernel.dk>
References: <CAODBMzm2qZu=gcpDKLyQ27zyFgkDD1ieaw2b4=A869_zuQE7HA@mail.gmail.com>
 <261eb52b-e606-2736-d195-7abbcf2dd762@kernel.dk> <CAODBMzmD0o-bWNV0gpYNuFcQHo=BMLCVAALZvpPaVo36PFsd+w@mail.gmail.com>
 <2db67a6b-137f-42df-208d-1c4c97190fb2@kernel.dk> <ca7a2874-4f42-22c9-7d0b-04e251ab2532@kernel.dk>
 <CAODBMzkEkk8xqPFsEeFGSYL-dtJW5Q010ojuHRAcL=o71YcU7g@mail.gmail.com>
 <ad78196d-0e0b-bbf8-4c9f-02ce877b4051@kernel.dk> <b352de81-8175-87fa-be5e-3c5ceda20b23@kernel.dk>
 <ec439e5c-5df3-06ff-c21a-22c22b90ebff@kernel.dk> <e68f2b27-05dc-1329-6649-3b5b641bfb40@kernel.dk>
From: Phillip Chen <phillip.a.chen@seagate.com>
Date: Thu, 30 Nov 2017 14:19:49 -0700
Message-ID: <CAODBMzmfRfm9bE8xwvoi=-u=xhvbbG+R6ktgwdROxh11uwhKLg@mail.gmail.com>
Subject: Re: Random distribution: zoned argument
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

It looks like it's working great! I haven't found any problems in any
of the cases I've tried, and I'll let you know if I find any issues as
I work on more test cases.
Thanks again for the help and quick turn-around,
Phillip Chen

On Wed, Nov 29, 2017 at 7:30 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 11/29/2017 07:16 PM, Jens Axboe wrote:
>> On 11/29/2017 06:37 PM, Jens Axboe wrote:
>>> On 11/29/2017 01:58 PM, Jens Axboe wrote:
>>>> I'll take a look at adding absolute zoning, should be pretty
>>>> trivial.
>>>
>>> Quick and dirty here, can you see if this works with your magic
>>> script?
>>>
>>> Basically you just do:
>>>
>>> random_distribution=3Dzoned_abs:60/100m:10/200m:30/700m
>>>
>>> like you would for 'zoned' - the first is a percentage, the
>>> other part is a size. So the above would be:
>>>
>>> - 60% of accesss to the first 100M
>>> - 10% of access to the next 200M
>>> - 30% of access to the next 700m
>>>
>>> No checking for whether or not we exceed device/file size or anything
>>> like that in this version, but everything else should work with the
>>> existing code pretty nicely. Not tested...
>>
>> Added documentation, and modified your script do have:
>>
>> dist_str =3D "zoned_abs:50/35770m:10/286166m:40/35770m"
>>
>> for a 375G nvme drive I have, this yields:
>>
>> histogram percents =3D [25.011592135525543, 25.014596077621864, 0.617733=
7336535484, 0.6206606515935528, 0.6198133858740779, 0.6175796853409167, 0.6=
187350476856551, 0.6266685357861933, 0.6370667968888403, 0.6393004974220015=
, 0.6279009222872477, 0.6302886711330408, 0.6230484004393458, 0.62743877734=
93523, 0.6131122842745942, 0.6258982942230342, 0.614036574150385, 0.6185809=
993730234, 19.971208370369116, 20.02474015900867]
>> histogram edges =3D [36629084.0, 73258168.0, 109887252.0, 146516336.0, 1=
83145420.0, 219774504.0, 256403588.0, 293032672.0, 329661756.0, 366290840.0=
, 402919924.0, 439549008.0, 476178092.0, 512807176.0, 549436260.0, 58606534=
4.0, 622694428.0, 659323512.0, 695952596.0, 732581680.0]
>> zoned_abs:50/35770m:10/286166m:40/35770m
>>
>> which looks correct to me - 50% in the first two buckets, which is defin=
ed as
>> the first 10% of the drive. 40% in the last two buckets, which is the la=
st 10%
>> of the drive. And the rest in the middle, which should add up to 10 (qui=
ck
>> eyeballing says it does).
>>
>> Updated patch below. Only change is the added documentation, and a check
>> for exceeding device/file size.
>
> Did some basic testing, and it seems fine to me. I've committed it, so
> may be easier for you to just git update and run with that.
>
> Do let me know when you test it and what your findings are, so we can
> ensure that it works the way it should for all cases.
>
>
> --
> Jens Axboe
>

