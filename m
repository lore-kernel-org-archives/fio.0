Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:37384 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbgKBA1l (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 1 Nov 2020 19:27:41 -0500
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: Writing/reading OD, MD, ID of a disk
Date: Mon, 2 Nov 2020 00:27:36 +0000
Message-ID: <BL0PR04MB65149BB5CC69BBC98F88F1D5E7100@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <CAAEM5qKsqw44j_Bwi7fnJF0KXGcVG9qFp_=Nmg6LiwQ3t+LtBQ@mail.gmail.com>
 <CALjAwxjJXEaDjacbfT5=rS6XzFxDwJOP5Rnktqc1+Y95UKcWsg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>, siha lawrence <sihaj33@gmail.com>
Cc: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, fio <fio@vger.kernel.org>

On 2020/11/01 18:06, Sitsofe Wheeler wrote:=0A=
> Hi,=0A=
> =0A=
> On Tue, 6 Oct 2020 at 13:40, siha lawrence <sihaj33@gmail.com> wrote:=0A=
>>=0A=
>> Hi,=0A=
>>=0A=
>> What parameters could we use to write/read OD, MD, ID of a disk or=0A=
>> specific LBAs?=0A=
>>=0A=
>> Thanks,=0A=
>> Siha=0A=
> =0A=
> It seems like OD (Outer Disk), MD (Middle Disk) and ID (Inner Disk)=0A=
> are SMR drive terms. I don't know how you explicitly target those...=0A=
> maybe someone more familiar with SMR would know? (I've CC'd Dmitry in=0A=
> case they know).=0A=
=0A=
OD/MD/ID is not SMR specific. These terms refer to the physical location on=
 the=0A=
disk platters of the sectors being accessed. Any HDD, regardless of the=0A=
underlying recording technology (PMR, SMR, energy assist or not) will map=
=0A=
logical blocks to a physical block on a particular track on a platter, with=
 the=0A=
track located toward the outer diameters of the platter or mid or inner dia=
meters.=0A=
=0A=
Since the number of sectors on a track is not constant and depends on the l=
inear=0A=
length of the track, accesses at outer diameters of a disk gives higher=0A=
throughput since the tracks there are longer and so more sectors can be=0A=
processed with one revolution (8.33ms for a 7200 rpm drive) compared to acc=
esses=0A=
to shorter tracks toward the spindle (axis) of the platter.=0A=
=0A=
> If you want to write a specific LBA you will have to get as close to=0A=
> the disk as possible. If we're talking Linux you can access the disk's=0A=
> raw block device (filename=3D/dev/<dev>), use direct=3D1, set blocksize t=
o=0A=
> the underlying block size and then you could play back a hand crafted=0A=
> iolog (https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-re=
ad-iolog=0A=
> / https://fio.readthedocs.io/en/latest/fio_doc.html#trace-file-format-v2=
=0A=
> ) where the offset would correspond to the LBA.=0A=
=0A=
Correct. But the block size does not need to be the same size as the disk=
=0A=
physical sector size. It can be any value that is a multiple of the physica=
l=0A=
block size. E.g. to measure sequential throughput at OD (lba=3D0), one can =
simply=0A=
run something like:=0A=
=0A=
fio --name=3DOD --filename=3D/dev/sdX --ioengine=3Dlibaio --iodepth=3D16 --=
rw=3Dread=0A=
--direct=3D1 --bs=3D512K --iosize=3Dsome-large-ish-value --offset=3D0=0A=
=0A=
And to measure at ID.... Well that's where problems start: the=0A=
logical-to-physical mapping is not a standard and varies from drive to driv=
e. So=0A=
there is no way to tell what the logical block value is for MD and ID. Old-=
ish=0A=
or low capacity drives tend to have a somewhat linear mapping: 0 is OD, mid=
=0A=
capacity is MD and ID is toward the max LBA of the disk. But a *lot* of dri=
ves=0A=
have different mapping, e.g mid-capacity LBAs are at ID and max capacity LB=
As=0A=
are at MD.=0A=
=0A=
This is however very easy to discover. Simply run:=0A=
=0A=
fio --name=3Dthroughput --filename=3D/dev/sdX --ioengine=3Dlibaio --iodepth=
=3D16=0A=
--rw=3Dread --direct=3D1 --bs=3D512K=0A=
=0A=
To read the entire drive. Add logging of the throughput over time and plot =
that.=0A=
You will clearly see how the throughput varies depending on the LBA being=
=0A=
accessed and the throughput value is directly dependent on the diameter loc=
ation=0A=
of the LBAs accessed.=0A=
=0A=
Note that even LBA 0 =3D=3D OD is not a given. Some SMR drives with convent=
ional=0A=
zones tend to place these zones at MD but they are mapped starting from LBA=
 0.=0A=
=0A=
Best regards.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

