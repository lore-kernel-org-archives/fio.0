Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oln040092002036.outbound.protection.outlook.com ([40.92.2.36]:16448
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731261AbfEWSdw (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 23 May 2019 14:33:52 -0400
From: Etienne-Hugues Fortin <efortin@cyberspicace.com>
Subject: RE: Either I don't understand how it work or I get unexpected result
 - mixed workload
Date: Thu, 23 May 2019 18:33:50 +0000
Message-ID: <CY4PR0801MB37936DF26D88B44E94A1221FD9010@CY4PR0801MB3793.namprd08.prod.outlook.com>
References: <CY4PR0801MB3793BFC227015B3DEC29C824D9010@CY4PR0801MB3793.namprd08.prod.outlook.com>
 <CY4PR0801MB3793680FDFFBB3AE6BD85514D9010@CY4PR0801MB3793.namprd08.prod.outlook.com>
 <AT5PR8401MB1169C4380AA584992B610CBDAB010@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <AT5PR8401MB1169C4380AA584992B610CBDAB010@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Servers)" <elliott@hpe.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I did the change which also forced me to switch to windowsaio as the ioengi=
ne. Now the read/write ratio is aligned with what is expected (70/30) but t=
he performance is about 1/5 of what it was. Based on your email, I understa=
nd that it was using Windows Volume Cache but I don't get why the performan=
ce as seen from the storage unit was 5x higher then it is now. If I would h=
ave had hit cache at the Windows level, it seems to me that it would not ha=
ve get a higher throughput as seen from the storage unit (not the server). =
It should have reduce the number of IO going to the storage, no?

Also, I'm using multiple 20GB files per host (16x) and the hosts only have =
4GB of RAM so... that doesn't make a large cache as I understand it. Right =
now, I can see that changing direct=3D0 by direct=3D1 and the ioengine to w=
indowsaio is slowing down the performance while, at the same time, fix the =
ratio read/write so the Windows Volume Cache is certainly doing something b=
ut I would not expect it to increase the performance and certainly not when=
 looking at it from the storage unit. I'm also monitoring the throughput on=
 the network and it was 5x higher before then now which contribute to my un=
derstanding that there was not much hit rate at the Windows Volume Cache le=
vel.

Any idea of why I'm seeing those results?

Thank you.

Etienne

-----Message d'origine-----
De=EF=BF=BD: Elliott, Robert (Servers) <elliott@hpe.com>=20
Envoy=EF=BF=BD: May 23, 2019 1:42 PM
=EF=BF=BD=EF=BF=BD: Etienne-Hugues Fortin <efortin@cyberspicace.com>; fio@v=
ger.kernel.org
Objet=EF=BF=BD: RE: Either I don't understand how it work or I get unexpect=
ed result - mixed workload



> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On=20
> Behalf Of Etienne-Hugues Fortin
> Sent: Thursday, May 23, 2019 6:57 AM
> To: fio@vger.kernel.org
> Subject: Either I don't understand how it work or I get unexpected=20
> result - mixed workload
>=20
> Hi,
>=20
> I'm trying to create a workload where 70% would be read, 30% write=20
> with a ratio of 50% random for the whole workload. Currently, the job loo=
k like this:
>=20
> [global]
> directory=3D\\server\path
> rw=3Drandrw
> rwmixread=3D70
> percentage_random=3D50
> numjobs=3D16
> size=3D20g
> bs=3D32k
> zero_buffers
> direct=3D0
> sync=3D0
> refill_buffers
> ioengine=3Dsync
> iodepth=3D1
> runtime=3D900
> time_based
> [32k_IOPS]
>=20
> My understanding is that randrw will do random read/write, rwmixread=20
> will set the read percentage to 70% and percentage_random will make=20
> 50% of the IO to be random. However, when I look at the storage unit,=20
> I'm seeing between 85-87% of read and 15-13% of write. Is that expected b=
ased on that config file? If so, what is the reason behind it?

With direct=3D0 you're going through the Windows Volume Cache (similar to t=
he linux page cache), which distorts everything - reads hit in a big cache =
in DRAM, and writes are collected there and burst out later.

> Is there a way to see the distribution of the IO that are=20
> sent/received by fio in order to validate read/write and random/sequentia=
l ratio?

debug=3Dio logs every I/O; some processing of that would confirm fio is gen=
erating what you expect. =20

In linux, strace is an easy way to observe the system calls of a program.

In linux, you can use trace points to see what various layers of the kernel=
 driver stack are doing.
Jens wrote tools to make the block layer trace points easily accessible (se=
e https://nam02.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flinux=
.die.net%2Fman%2F8%2Fblktrace&amp;data=3D02%7C01%7C%7C480ffdfa8f9f4bf5a3080=
8d6dfa6087a%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7C636942301525041867=
&amp;sdata=3Dgmb287FVCZp9Nz6Dr3kzar55gmkT2AbRcWIGz54GbOY%3D&amp;reserved=3D=
0).


>=20
> Thank you.
>=20
> Etienne

