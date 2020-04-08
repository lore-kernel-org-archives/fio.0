Return-Path: <prvs=360af864b=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 0/4] Generalize zonemode=zbd
Date: Wed, 8 Apr 2020 01:00:30 +0000
Message-ID: 
 <BY5PR04MB6900AFAF3F60C1092BB842B0E7C00@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200407015900.1335019-1-damien.lemoal@wdc.com>
 <7b5d0ce0-3204-20ba-2b44-17d734511d78@kernel.dk>
 <61e87991-3fdb-bed3-95b9-b730d7bfb222@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Vincent Fu <vincentfu@gmail.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2020/04/08 9:07, Vincent Fu wrote:=0A=
> On 4/7/20 4:48 PM, Jens Axboe wrote:=0A=
>  > On 4/6/20 6:58 PM, Damien Le Moal wrote:=0A=
>  >> This series extend support for zonemode=3Dzbd beyond Linux only and a=
s is=0A=
>  >> allows the use of this zonemode on any platform with regular block=0A=
>  >> devices. The same also applies to Linux systems that do not have zone=
d=0A=
>  >> block device support (e.g. enterprise distributions with kernels vers=
ion=0A=
>  >> lower than 4.10). For zoned block device support, Linux implementatio=
n=0A=
>  >> is preserved. Other OS specific code can be added with automatic=0A=
>  >> configuration with the configure script to add zoned block device=0A=
>  >> support.=0A=
>  >>=0A=
>  >> Additionally, ioengine operations are updated to allow an IO engine t=
o=0A=
>  >> provide implementations for the zone operations needed to support zon=
ed=0A=
>  >> block devices. This is convenient for cases where the system OS/kerne=
l=0A=
>  >> does not have any support implementation available.=0A=
>  >>=0A=
>  >> Finally, the libzbc IO engine is introduced to support zoned block=0A=
>  >> devices on Linux distributions without native kernel level support (E=
.g.=0A=
>  >> RedHat/CentOS). SImilarly to the sg ioengine, this new IO engine uses=
i=0A=
>  >> passthrough commands implemeted by libzbc API to directly access SMR=
=0A=
>  >> drives.=0A=
>  >=0A=
>  > Looks ok to me, I've applied it. But please send a job file that uses=
=0A=
>  > it as well to put in examples/, thanks.=0A=
>  >=0A=
> =0A=
> The AppVeyor Windows builds fail due to the zbd changes:=0A=
> =0A=
> https://ci.appveyor.com/project/axboe/fio/builds/32024485=0A=
> =0A=
> configure reports:=0A=
> =0A=
> Zoned block device support    no=0A=
> libzbc engine                 no=0A=
> =0A=
> but nevertheless an attempt is made to build the zbd code.=0A=
=0A=
With the changes, zbd.c should be compiled for any OS to enable zonemode=3D=
zbd=0A=
with regular block devices. But oslib/linux-blkzoned.c should not be compil=
ed.=0A=
What is the compilation error ? Is it something in zbd.c ?=0A=
I do not have any Windows machine to test builds.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

