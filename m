Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: Simulating Real Random I/O with FIO
Date: Wed, 6 Feb 2013 13:19:06 +0000
Message-ID: <843E15216120C047928F6879B0E2D9240F6EF3F8@SACEXCMBX02-PRD.hq.netapp.com>
In-Reply-To: <20130206131031.GT15092@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FA27ACA0B9FAB046A8BCB0D981C7FD52@tahoe.netapp.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



On 2/6/13 8:10 AM, "Jens Axboe" <axboe@kernel.dk> wrote:

>On Mon, Feb 04 2013, Neto, Antonio Jose Rodrigues wrote:
>> Hi All,
>>=20
>> This is neto from Brazil
>>=20
>> How are you?
>>=20
>> I am doing a performance POC and I need to simulate 100% true random
>>workload. I am using Fibre Channel and Windows 2008R2.
>>=20
>> I have 8 LUNs (125GB each) and my configuration file is:
>>=20
>> [workload]
>> bs=3D8k
>> ioengine=3Dwindowsaio
>> iodepth=3D3
>> numjobs=3D35
>> direct=3D1
>> runtime=3D120
>> size=3D1024g
>> filename=3D\\.\PhysicalDrive1
>> filename=3D\\.\PhysicalDrive2
>> filename=3D\\.\PhysicalDrive3
>> filename=3D\\.\PhysicalDrive4
>> filename=3D\\.\PhysicalDrive5
>> filename=3D\\.\PhysicalDrive6
>> filename=3D\\.\PhysicalDrive7
>> filename=3D\\.\PhysicalDrive8
>> zonesize=3D1024m
>> zoneskip=3D3g
>> rw=3Drandrw
>> rwmixread=3D80
>> rwmixwrite=3D20
>> thread
>> unified_rw_reporting=3D1
>> group_reporting=3D1
>> randrepeat=3D0
>> norandommap
>>=20
>> Questions:
>>=20
>> 1) I am assuming the working set is the size parameter that is 1TB. Is
>> that correct?
>
>Correct
>
>> 2) What is the correlaction of the zonesize and zoneskip with the
>> randomness? Adding those will help with the randomness of the workload
>> or not?=20
>
>Your setting of zonesize=3D1g, skip=3D3g, will do random read/write within=
 a
>1gb zone (so from 0-1G initially), then move to the next zone (3G-4G),
>etc. For a rotating drive, this will mean shorter seeks, since while it
>is doing one zone, it will only seek within that zone.
>
>> 3) If I use zonesize=3D1024m and zoneskip=3D3g I have like 100K IOPS
>> (coming from cache not disks) and if I use zonesize=3D10g and
>> zoneskip=3D26g I have more realistic numbers. Could someone explain
>> which is the a good example to use zonesize and zoneskip?
>
>Depends on what you want, really. With zonesize=3D10g, you are now seeking
>in a 10x wider area than you were before.
>
>> 4) Is it possible with fio to specify per disk randomness area: For
>> example: disk1 - start blocks 456 till blocks 3456, disk2 - start
>> blocks 4567 to 103456
>
>You'd have to use different jobs. You above example uses 8 disks and
>accesses them from all 35 jobs. You could split it a bit, so that you
>have 8 sections, each accessing one disk. You could have 4 jobs in each
>section, giving you a total of 32 jobs. Then you can set offset/size for
>each job separately.
>
>--=20
>Jens Axboe
>
>--
>To unsubscribe from this list: send the line "unsubscribe fio" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thank you so much my friend.

Could you please do me a big favor send me an example (worse for
mechanical disks (with zones, offsets, different areas etc)). I would like
to make a blog post about it and we also could add it in our examples in
FIO distribution. I just need the "perfect" random test for mechanical
disks. I have some doubts between the relation about zones and offsets. If
you could give me an example, I really appreciate.
>


