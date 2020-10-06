Return-Path: <krish.reddy@samsung.com>
Date: Tue, 6 Oct 2020 10:02:24 +0530
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: Re: [PATCH 0/3] v1 Patchset : Zone Explicit Open support
Message-ID: <20201006043224.GA19210@test-zns>
MIME-Version: 1.0
In-Reply-To: <MWHPR04MB37581FE01B73A6A0ECB9DEBAE7320@MWHPR04MB3758.namprd04.prod.outlook.com>
Content-Type: multipart/mixed;
	boundary="----.SbLpEChV8y8LoQpb_2t7nYdot55MkfN9twA47R_fm6-MYmY=_45d43_"
References: <CGME20200929130315epcas5p4e6a11cc77fb06a64c31e57740d2e0e31@epcas5p4.samsung.com>
	<20200929125950.20343-1-krish.reddy@samsung.com>
	<MWHPR04MB37581FE01B73A6A0ECB9DEBAE7320@MWHPR04MB3758.namprd04.prod.outlook.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

------.SbLpEChV8y8LoQpb_2t7nYdot55MkfN9twA47R_fm6-MYmY=_45d43_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, Sep 29, 2020 at 04:32:09PM +0000, Damien Le Moal wrote:
>On 2020/09/29 22:03, Krishna Kanth Reddy wrote:
>> 1. Added a new FIO option zone_open.
>> 	When it is enabled, Zones will be opened explicitly before sending I/Os.
>> 2. Add support for open_zones in libzbc I/O engine
>> 3. t/zbd: Add support to verify Zone Explicit Open
>>
>> This is a RFC.
>> Feedback / Comments will help in improving this further.
>
>My main question is why ? There is no performance benefit on the drive side from
>doing explicit zone open. On the contrary, performance may go down due to the
>added command overhead. So why do this ? What is your goal ?
>
>Using the max_open_zones=N option, fio writes will be limited to a set of N
>zones, implicitly open, until the zones are full (not open anymore) and new
>zones chosen (becoming implicitly open with writes). Adding explicit zone open
>will not give you anything more with this option used. And if you do not use it,
>performance with random writes will significantly go down.
>
>So please try to give convincing reasons for this.
>
It is a building block for future TPs.
We would like to do the pre-work and add the right option abstraction.
Zone open is 'implicit' by default.
Hence there won't be a performance drop with the newly added code.

>>
>> Ankit Kumar (2):
>>   Add support for Explicit open zones
>>   Add support for open_zones in libzbc I/O engine.
>>
>> Krishna Kanth Reddy (1):
>>   t/zbd: Add support to verify Zone Explicit Open
>>
>>  HOWTO                       | 13 ++++++++
>>  engines/libzbc.c            | 42 +++++++++++++++++++++++++
>>  engines/skeleton_external.c | 12 ++++++++
>>  fio.1                       | 11 +++++++
>>  ioengines.h                 |  2 ++
>>  options.c                   | 20 ++++++++++++
>>  oslib/blkzoned.h            |  7 +++++
>>  oslib/linux-blkzoned.c      | 26 ++++++++++++++++
>>  t/zbd/test-zbd-support      | 27 ++++++++++++++++
>>  thread_options.h            |  7 +++++
>>  zbd.c                       | 61 +++++++++++++++++++++++++++++++++++++
>>  11 files changed, 228 insertions(+)
>>
>
>
>-- 
>Damien Le Moal
>Western Digital Research
>

------.SbLpEChV8y8LoQpb_2t7nYdot55MkfN9twA47R_fm6-MYmY=_45d43_
Content-Type: text/plain; charset="utf-8"


------.SbLpEChV8y8LoQpb_2t7nYdot55MkfN9twA47R_fm6-MYmY=_45d43_--

