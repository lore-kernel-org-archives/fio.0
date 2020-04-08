Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
Subject: Re: [PATCH 0/4] Generalize zonemode=zbd
References: <20200407015900.1335019-1-damien.lemoal@wdc.com>
 <7b5d0ce0-3204-20ba-2b44-17d734511d78@kernel.dk>
 <61e87991-3fdb-bed3-95b9-b730d7bfb222@gmail.com>
 <BY5PR04MB6900AFAF3F60C1092BB842B0E7C00@BY5PR04MB6900.namprd04.prod.outlook.com>
 <43ac3364-5d63-0a89-9830-efff18b9b4b0@gmail.com>
 <BY5PR04MB690053CDA9D7D4C86A05D8F5E7C00@BY5PR04MB6900.namprd04.prod.outlook.com>
From: Vincent Fu <vincentfu@gmail.com>
Message-ID: <341b4035-f524-0d18-79d7-c9eb055dff0f@gmail.com>
Date: Wed, 8 Apr 2020 17:29:24 -0400
MIME-Version: 1.0
In-Reply-To: <BY5PR04MB690053CDA9D7D4C86A05D8F5E7C00@BY5PR04MB6900.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
To: Damien Le Moal <Damien.LeMoal@wdc.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On 4/7/20 9:53 PM, Damien Le Moal wrote:
> On 2020/04/08 10:08, Vincent Fu wrote:
>> On 4/7/20 9:00 PM, Damien Le Moal wrote:
>>> On 2020/04/08 9:07, Vincent Fu wrote:
>>>> On 4/7/20 4:48 PM, Jens Axboe wrote:
>>>>    > On 4/6/20 6:58 PM, Damien Le Moal wrote:
>>>>    >> This series extend support for zonemode=3Dzbd beyond Linux only =
and as is
>>>>    >> allows the use of this zonemode on any platform with regular blo=
ck
>>>>    >> devices. The same also applies to Linux systems that do not have=
 zoned
>>>>    >> block device support (e.g. enterprise distributions with kernels=
 version
>>>>    >> lower than 4.10). For zoned block device support, Linux implemen=
tation
>>>>    >> is preserved. Other OS specific code can be added with automatic
>>>>    >> configuration with the configure script to add zoned block device
>>>>    >> support.
>>>>    >>
>>>>    >> Additionally, ioengine operations are updated to allow an IO eng=
ine to
>>>>    >> provide implementations for the zone operations needed to suppor=
t zoned
>>>>    >> block devices. This is convenient for cases where the system OS/=
kernel
>>>>    >> does not have any support implementation available.
>>>>    >>
>>>>    >> Finally, the libzbc IO engine is introduced to support zoned blo=
ck
>>>>    >> devices on Linux distributions without native kernel level suppo=
rt (E.g.
>>>>    >> RedHat/CentOS). SImilarly to the sg ioengine, this new IO engine=
 usesi
>>>>    >> passthrough commands implemeted by libzbc API to directly access=
 SMR
>>>>    >> drives.
>>>>    >
>>>>    > Looks ok to me, I've applied it. But please send a job file that =
uses
>>>>    > it as well to put in examples/, thanks.
>>>>    >
>>>>
>>>> The AppVeyor Windows builds fail due to the zbd changes:
>>>>
>>>> https://ci.appveyor.com/project/axboe/fio/builds/32024485
>>>>
>>>> configure reports:
>>>>
>>>> Zoned block device support    no
>>>> libzbc engine                 no
>>>>
>>>> but nevertheless an attempt is made to build the zbd code.
>>>
>>> With the changes, zbd.c should be compiled for any OS to enable zonemod=
e=3Dzbd
>>> with regular block devices. But oslib/linux-blkzoned.c should not be co=
mpiled.
>>> What is the compilation error ? Is it something in zbd.c ?
>>> I do not have any Windows machine to test builds.
>>>
>>>
>>
>> This is the error:
>>
>>       CC zbd.o
>> In file included from zbd.c:10:0:
>> os/windows/posix/include/dirent.h:8:2: error: unknown type name =EF=BF=
=BDino_t=EF=BF=BD
>>     ino_t  d_ino;     /*  File serial number */
>=20
> zbd.c includes dirent.h which I think result in this error for windows. B=
ut
> zbd.c actually does not use d_ino anywhere and removing the dirent.h incl=
ude
> from it is fine (just checked on Linux).
>=20
>>     ^~~~~
>> zbd.c: In function =EF=BF=BDzbd_unaligned_write=EF=BF=BD:
>> zbd.c:1242:7: error: =EF=BF=BDEREMOTEIO=EF=BF=BD undeclared (first use i=
n this function)
>>     case EREMOTEIO:
>>          ^~~~~~~~~
>> zbd.c:1242:7: note: each undeclared identifier is reported only once for
>> each function it appears in
>=20
> OK. This one should be easy to fix.
>=20
>>
>> Here is the automated Windows build:
>>
>> https://ci.appveyor.com/project/axboe/fio/builds/32024485/job/wmff344x9q=
4j09iq
>>
>> The macOS build now also fails with a similar error:
>>
>> https://travis-ci.org/github/axboe/fio/jobs/672273652
>=20
> Sending a patch right away. If you could test builds with it, that would =
be
> great. Thanks !
>=20
>=20

For what it's worth, I have integrated AppVeyor and travis-ci with my=20
own github account, allowing the two services to run through the=20
build/test cycle on Linux, Windows, and macOS any time I push changes to=20
my fork of fio.

It's been a while since I set up the integration but it looks like the=20
right places to look are here:

https://github.com/marketplace/appveyor
https://github.com/marketplace/travis-ci

The main drawback of the two services is that they do not provide access=20
to the test artifacts. So I maintain a small cluster of servers that=20
does automated builds/testing for fio, although this is all going away=20
when our lab is dismantled at the end of May.

