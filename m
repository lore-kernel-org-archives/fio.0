Return-Path: <prvs=84123ada3=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 00/11] Improve libaio IO priority support
Date: Mon, 2 Aug 2021 05:44:25 +0000
Message-ID: 
 <DM6PR04MB708161A2A76A8195297B0902E7EF9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210706001743.10818-1-damien.lemoal@wdc.com>
 <DM6PR04MB7081F4A4644DCE721C6B0575E7E19@DM6PR04MB7081.namprd04.prod.outlook.com>
 <db4d09a0-5240-0bf9-01b2-92e7020a31de@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

On 2021/07/19 23:20, Jens Axboe wrote:=0A=
> On 7/18/21 9:24 PM, Damien Le Moal wrote:=0A=
>> On 2021/07/06 9:17, Damien Le Moal wrote:=0A=
>>> This series improves libaio engine support for IO priority, adding=0A=
>>> options to allow for mixed priority workloads to be specified more=0A=
>>> easily and to match the kernel supported IO priority features.=0A=
>>>=0A=
>>> The first 3 patches are small cleanup and fixes in the manpage and=0A=
>>> fiograph tool.=0A=
>>>=0A=
>>> Patch 4 and 5 introduce some helper functions to simplify the code in=
=0A=
>>> the followup patches.=0A=
>>>=0A=
>>> Patch 6 changes the cmdprio_percentage option to allow specifying=0A=
>>> different percentages for reads and writes.=0A=
>>>=0A=
>>> Patch 7 and 8 introduce the aioprioclass, aioprio and aioprio_bssplit.=
=0A=
>>> These together allow a script to specify different IO priorities for=0A=
>>> reads and writes of different sizes with different percentages.=0A=
>>>=0A=
>>> Patch 9 relaxes restrictions on the cmdprio_percentage option to allow=
=0A=
>>> jobs to execute AIOs using a default priority as set with ioprio_set()=
=0A=
>>> (as the kernel supports this).=0A=
>>>=0A=
>>> Patch 10 introduces the log_prio option to log each IO priority value,=
=0A=
>>> allowing users to do per-priority level performance analysis with=0A=
>>> complex workloads using many jobs.=0A=
>>>=0A=
>>> Finally, patch 11 adds a couple of example scripts to illustrate the us=
e=0A=
>>> of the new options introduced.=0A=
>>>=0A=
>>> Comments are as always most welcome.=0A=
>>=0A=
>> Hi Jens,=0A=
>>=0A=
>> Any comment on this series ? We have been using this for a while now int=
ernally=0A=
>> and in the field to test ATA NCQ priority with good results. I am also p=
lanning=0A=
>> to re-use this to add support for the Command Duration Limits feature (A=
TA &=0A=
>> SCSI) using a new priority class (kernel patching cooking, but this will=
 need=0A=
>> some more time as the specifications must stabilize first.=0A=
>>=0A=
>> One thing that can be considered missing with this series is a full set =
of=0A=
>> per-priority level statistics (IOPS, BW, etc). But that is a major chang=
e and so=0A=
>> this is not talked here.=0A=
> =0A=
> I'll give it a look over today. My main object would be to ensure that=0A=
> aio and io_uring provide the same kind of interface, there shouldn't be=
=0A=
> any differences there in terms of how to use them and what they do. Even=
=0A=
> naming should be the same. Engine options exist for engine specific=0A=
> options. These don't apply to all engines, but to the ones they do, they=
=0A=
> should be interchangable. I should be able to take a job file with=0A=
> ioengine=3DX and change it to =3DY and have the priorities still work,=0A=
> provided that engine Y supports it.=0A=
> =0A=
> As far as I'm concerned, aio is legacy and I have no real interest in=0A=
> adding anything that supports that, be it kernel or software.=0A=
=0A=
OK. Let me cook a V2 to include io_uring support for the priority options.=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

