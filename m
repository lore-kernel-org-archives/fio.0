Return-Path: <prvs=360af864b=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 0/4] Generalize zonemode=zbd
Date: Wed, 8 Apr 2020 01:53:52 +0000
Message-ID: 
 <BY5PR04MB690053CDA9D7D4C86A05D8F5E7C00@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200407015900.1335019-1-damien.lemoal@wdc.com>
 <7b5d0ce0-3204-20ba-2b44-17d734511d78@kernel.dk>
 <61e87991-3fdb-bed3-95b9-b730d7bfb222@gmail.com>
 <BY5PR04MB6900AFAF3F60C1092BB842B0E7C00@BY5PR04MB6900.namprd04.prod.outlook.com>
 <43ac3364-5d63-0a89-9830-efff18b9b4b0@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Vincent Fu <vincentfu@gmail.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2020/04/08 10:08, Vincent Fu wrote:=0A=
> On 4/7/20 9:00 PM, Damien Le Moal wrote:=0A=
>> On 2020/04/08 9:07, Vincent Fu wrote:=0A=
>>> On 4/7/20 4:48 PM, Jens Axboe wrote:=0A=
>>>   > On 4/6/20 6:58 PM, Damien Le Moal wrote:=0A=
>>>   >> This series extend support for zonemode=3Dzbd beyond Linux only an=
d as is=0A=
>>>   >> allows the use of this zonemode on any platform with regular block=
=0A=
>>>   >> devices. The same also applies to Linux systems that do not have z=
oned=0A=
>>>   >> block device support (e.g. enterprise distributions with kernels v=
ersion=0A=
>>>   >> lower than 4.10). For zoned block device support, Linux implementa=
tion=0A=
>>>   >> is preserved. Other OS specific code can be added with automatic=
=0A=
>>>   >> configuration with the configure script to add zoned block device=
=0A=
>>>   >> support.=0A=
>>>   >>=0A=
>>>   >> Additionally, ioengine operations are updated to allow an IO engin=
e to=0A=
>>>   >> provide implementations for the zone operations needed to support =
zoned=0A=
>>>   >> block devices. This is convenient for cases where the system OS/ke=
rnel=0A=
>>>   >> does not have any support implementation available.=0A=
>>>   >>=0A=
>>>   >> Finally, the libzbc IO engine is introduced to support zoned block=
=0A=
>>>   >> devices on Linux distributions without native kernel level support=
 (E.g.=0A=
>>>   >> RedHat/CentOS). SImilarly to the sg ioengine, this new IO engine u=
sesi=0A=
>>>   >> passthrough commands implemeted by libzbc API to directly access S=
MR=0A=
>>>   >> drives.=0A=
>>>   >=0A=
>>>   > Looks ok to me, I've applied it. But please send a job file that us=
es=0A=
>>>   > it as well to put in examples/, thanks.=0A=
>>>   >=0A=
>>>=0A=
>>> The AppVeyor Windows builds fail due to the zbd changes:=0A=
>>>=0A=
>>> https://ci.appveyor.com/project/axboe/fio/builds/32024485=0A=
>>>=0A=
>>> configure reports:=0A=
>>>=0A=
>>> Zoned block device support    no=0A=
>>> libzbc engine                 no=0A=
>>>=0A=
>>> but nevertheless an attempt is made to build the zbd code.=0A=
>>=0A=
>> With the changes, zbd.c should be compiled for any OS to enable zonemode=
=3Dzbd=0A=
>> with regular block devices. But oslib/linux-blkzoned.c should not be com=
piled.=0A=
>> What is the compilation error ? Is it something in zbd.c ?=0A=
>> I do not have any Windows machine to test builds.=0A=
>>=0A=
>>=0A=
> =0A=
> This is the error:=0A=
> =0A=
>      CC zbd.o=0A=
> In file included from zbd.c:10:0:=0A=
> os/windows/posix/include/dirent.h:8:2: error: unknown type name =91ino_t=
=92=0A=
>    ino_t  d_ino;     /*  File serial number */=0A=
=0A=
zbd.c includes dirent.h which I think result in this error for windows. But=
=0A=
zbd.c actually does not use d_ino anywhere and removing the dirent.h includ=
e=0A=
from it is fine (just checked on Linux).=0A=
=0A=
>    ^~~~~=0A=
> zbd.c: In function =91zbd_unaligned_write=92:=0A=
> zbd.c:1242:7: error: =91EREMOTEIO=92 undeclared (first use in this functi=
on)=0A=
>    case EREMOTEIO:=0A=
>         ^~~~~~~~~=0A=
> zbd.c:1242:7: note: each undeclared identifier is reported only once for =
=0A=
> each function it appears in=0A=
=0A=
OK. This one should be easy to fix.=0A=
=0A=
> =0A=
> Here is the automated Windows build:=0A=
> =0A=
> https://ci.appveyor.com/project/axboe/fio/builds/32024485/job/wmff344x9q4=
j09iq=0A=
> =0A=
> The macOS build now also fails with a similar error:=0A=
> =0A=
> https://travis-ci.org/github/axboe/fio/jobs/672273652=0A=
=0A=
Sending a patch right away. If you could test builds with it, that would be=
=0A=
great. Thanks !=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

