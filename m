Return-Path: <prvs=59071c28a=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 00/15] ZBD fixes and improvements
Date: Tue, 24 Nov 2020 01:38:13 +0000
Message-ID: 
 <CH2PR04MB65229153850FC4228AC18277E7FB0@CH2PR04MB6522.namprd04.prod.outlook.com>
References: <20201121024532.16834-1-dmitry.fomichev@wdc.com>
 <4e35b427-c7df-f744-3c11-8e301e83999d@acm.org>
 <MN2PR04MB595110E3436147F4BFEFFEF9E1FC0@MN2PR04MB5951.namprd04.prod.outlook.com>
 <CH2PR04MB652206B15754860733DA7D98E7FB0@CH2PR04MB6522.namprd04.prod.outlook.com>
 <MN2PR04MB59512E4747068FB075F30CA3E1FB0@MN2PR04MB5951.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2020/11/24 10:12, Dmitry Fomichev wrote:=0A=
>> -----Original Message-----=0A=
>> From: Damien Le Moal <Damien.LeMoal@wdc.com>=0A=
>> Sent: Monday, November 23, 2020 7:07 PM=0A=
>> To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>; Bart Van Assche=0A=
>> <bvanassche@acm.org>; Jens Axboe <axboe@kernel.dk>;=0A=
>> fio@vger.kernel.org; Aravind Ramesh <Aravind.Ramesh@wdc.com>;=0A=
>> Naohiro Aota <Naohiro.Aota@wdc.com>; Niklas Cassel=0A=
>> <Niklas.Cassel@wdc.com>=0A=
>> Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
>> Subject: Re: [PATCH 00/15] ZBD fixes and improvements=0A=
>>=0A=
>> On 2020/11/24 4:18, Dmitry Fomichev wrote:=0A=
>>>> -----Original Message-----=0A=
>>>> From: Bart Van Assche <bvanassche@acm.org>=0A=
>>>> Sent: Friday, November 20, 2020 11:01 PM=0A=
>>>> To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>; Jens Axboe=0A=
>>>> <axboe@kernel.dk>; fio@vger.kernel.org; Aravind Ramesh=0A=
>>>> <Aravind.Ramesh@wdc.com>; Naohiro Aota <Naohiro.Aota@wdc.com>;=0A=
>>>> Niklas Cassel <Niklas.Cassel@wdc.com>=0A=
>>>> Cc: Damien Le Moal <Damien.LeMoal@wdc.com>; Shinichiro Kawasaki=0A=
>>>> <shinichiro.kawasaki@wdc.com>=0A=
>>>> Subject: Re: [PATCH 00/15] ZBD fixes and improvements=0A=
>>>>=0A=
>>>> On 11/20/20 6:45 PM, Dmitry Fomichev wrote:=0A=
>>>>> This patch series contains bug fixes and refactoring changes=0A=
>>>>> related to support for Zoned Block Devices (ZBD) in fio.=0A=
>>>>> The highlights:=0A=
>>>>>=0A=
>>>>>  - fix several errors related to running workloads that span=0A=
>>>>>    a mix of conventional zones and write pointer zones.=0A=
>>>>>  - improve counting of sectors with data (SWD).=0A=
>>>>>  - remove dependencies on particular zone types in the code.=0A=
>>>>>  - add code to gracefully handle offline zones.=0A=
>>>>=0A=
>>>> Hi Dmitry,=0A=
>>>>=0A=
>>>> This patch series looks interesting. Out of curiosity, do you perhaps=
=0A=
>>>> know how much of the modified code is covered by the tests in t/zbd?=
=0A=
>>>=0A=
>>> Hi Bart,=0A=
>>>=0A=
>>> All tests in t/zbd are passing with this series in place. This gives us=
=0A=
>> confidence=0A=
>>> that the patches don't break anything in terms of the existing function=
ality.=0A=
>>> Most of the bugs that are fixed in this patchset were uncovered by runn=
ing=0A=
>> fio in=0A=
>>> environments that go beyond the scope of t/zbd tests, such as ZNS, XMR,=
=0A=
>> some=0A=
>>> specific MaxOpen values, etc. and the fixes have been verified in these=
=0A=
>> same=0A=
>>> conditions. Having said that, the newer test #48 has become a very hand=
y=0A=
>> tool=0A=
>>> for identifying zone deadlocks.=0A=
>>>=0A=
>>> One caveat about the paragraph above - some test script modifications a=
re=0A=
>>> needed to fully cover support for offline zones and I have some patches=
 in=0A=
>> the=0A=
>>> works to add such functionality. I am planning to send these in in the =
near=0A=
>> future.=0A=
>>> The current tests do pass in the case of individually injected offline =
zones=0A=
>> on a=0A=
>>> drive and this level of testing should suffice for the time being.=0A=
>>>=0A=
>>> One thing that I thought about while writing this email - maybe we coul=
d=0A=
>> add=0A=
>>> a script to run t/zbd tests on a mixed null_blk with a good amount of=
=0A=
>> conventional=0A=
>>> zones? Damien, Shinichiro, do you think that such an addition would=0A=
>> improve the=0A=
>>> test coverage?=0A=
>>=0A=
>> Yes, we should add that to run-tests-against-zoned-nullb to avoid future=
=0A=
>> possible regressions with conventional zones. And we should make sure th=
at=0A=
>> one=0A=
>> test case runs over a range of mixed conv/seq zones.=0A=
>>=0A=
>> Going further, I think that we should merge run-tests-against-zoned-null=
b=0A=
>> and=0A=
>> run-tests-against-zoned-nullb into a new script run-tests-against-nullb =
which=0A=
>> would test all device configurations: regular nullb, zoned nullb with=0A=
>> conventional zones (SMR disk like device), zoned nullb with seq zones on=
ly=0A=
>> and=0A=
>> zone capacity < zone size (ZNS like device). With that, test coverage wo=
uld be=0A=
>> improved to include all recent changes.=0A=
> =0A=
> I was thinking about adding a meta-script that would invoke the existing =
two=0A=
> and some new scripts, but we could just merge all of them like you sugges=
ted.=0A=
> The entire test would consist of several sections and each of them would =
run=0A=
> the entire test-zbd-support script against different null_blk configurati=
ons.=0A=
> I'll try to come up with something like that... This leaves the question =
- should=0A=
> such a script be posted separately or be included in this series. IMO, it=
 should=0A=
> be a separate patch(set).=0A=
=0A=
Merging the scripts is I think better than adding yet another one: it becom=
es=0A=
easy to understand which one to run :)=0A=
=0A=
If Jens is OK with it, I think sending the test changes as follow-up patche=
s is=0A=
fine so that we do not delay merging this series.=0A=
=0A=
> =0A=
>>=0A=
>>>=0A=
>>> Best regards,=0A=
>>> Dmitry=0A=
>>>=0A=
>>>>=0A=
>>>> Thanks,=0A=
>>>>=0A=
>>>> Bart.=0A=
>>>=0A=
>>=0A=
>>=0A=
>> --=0A=
>> Damien Le Moal=0A=
>> Western Digital Research=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

