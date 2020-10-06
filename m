Return-Path: <prvs=5413c33e9=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 0/3] v1 Patchset : Zone Explicit Open support
Date: Tue, 6 Oct 2020 05:18:42 +0000
Message-ID: 
 <CY4PR04MB37516AB0DD407D250864FCF4E70D0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: 
 <CGME20200929130315epcas5p4e6a11cc77fb06a64c31e57740d2e0e31@epcas5p4.samsung.com>
 <20200929125950.20343-1-krish.reddy@samsung.com>
 <MWHPR04MB37581FE01B73A6A0ECB9DEBAE7320@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20201006043224.GA19210@test-zns>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Krishna Kanth Reddy <krish.reddy@samsung.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/10/06 13:37, Krishna Kanth Reddy wrote:=0A=
> On Tue, Sep 29, 2020 at 04:32:09PM +0000, Damien Le Moal wrote:=0A=
>> On 2020/09/29 22:03, Krishna Kanth Reddy wrote:=0A=
>>> 1. Added a new FIO option zone_open.=0A=
>>> 	When it is enabled, Zones will be opened explicitly before sending I/O=
s.=0A=
>>> 2. Add support for open_zones in libzbc I/O engine=0A=
>>> 3. t/zbd: Add support to verify Zone Explicit Open=0A=
>>>=0A=
>>> This is a RFC.=0A=
>>> Feedback / Comments will help in improving this further.=0A=
>>=0A=
>> My main question is why ? There is no performance benefit on the drive s=
ide from=0A=
>> doing explicit zone open. On the contrary, performance may go down due t=
o the=0A=
>> added command overhead. So why do this ? What is your goal ?=0A=
>>=0A=
>> Using the max_open_zones=3DN option, fio writes will be limited to a set=
 of N=0A=
>> zones, implicitly open, until the zones are full (not open anymore) and =
new=0A=
>> zones chosen (becoming implicitly open with writes). Adding explicit zon=
e open=0A=
>> will not give you anything more with this option used. And if you do not=
 use it,=0A=
>> performance with random writes will significantly go down.=0A=
>>=0A=
>> So please try to give convincing reasons for this.=0A=
>>=0A=
> It is a building block for future TPs.=0A=
=0A=
Which one ? Without that justification, I do not see the point of introduci=
ng=0A=
this change right now.=0A=
=0A=
> We would like to do the pre-work and add the right option abstraction.=0A=
> Zone open is 'implicit' by default.=0A=
> Hence there won't be a performance drop with the newly added code.=0A=
=0A=
Sure, but there will be a drop for regular zone block devices with some=0A=
workloads when that option is used. So if explicit zone open is needed by s=
ome=0A=
future TP feature, it may be better to integrate explicit open with that fe=
ature=0A=
rather than making it a generic fio option that users may mistakenly enable=
 and=0A=
end up wondering why they see lower performance with their device...=0A=
=0A=
=0A=
> =0A=
>>>=0A=
>>> Ankit Kumar (2):=0A=
>>>   Add support for Explicit open zones=0A=
>>>   Add support for open_zones in libzbc I/O engine.=0A=
>>>=0A=
>>> Krishna Kanth Reddy (1):=0A=
>>>   t/zbd: Add support to verify Zone Explicit Open=0A=
>>>=0A=
>>>  HOWTO                       | 13 ++++++++=0A=
>>>  engines/libzbc.c            | 42 +++++++++++++++++++++++++=0A=
>>>  engines/skeleton_external.c | 12 ++++++++=0A=
>>>  fio.1                       | 11 +++++++=0A=
>>>  ioengines.h                 |  2 ++=0A=
>>>  options.c                   | 20 ++++++++++++=0A=
>>>  oslib/blkzoned.h            |  7 +++++=0A=
>>>  oslib/linux-blkzoned.c      | 26 ++++++++++++++++=0A=
>>>  t/zbd/test-zbd-support      | 27 ++++++++++++++++=0A=
>>>  thread_options.h            |  7 +++++=0A=
>>>  zbd.c                       | 61 +++++++++++++++++++++++++++++++++++++=
=0A=
>>>  11 files changed, 228 insertions(+)=0A=
>>>=0A=
>>=0A=
>>=0A=
>> -- =0A=
>> Damien Le Moal=0A=
>> Western Digital Research=0A=
>>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

