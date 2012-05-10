Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:55829 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716Ab2EJN1h (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 May 2012 09:27:37 -0400
Message-ID: <4FABC243.2050708@kernel.dk>
Date: Thu, 10 May 2012 15:27:31 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Floating point exception in client/server mode
References: <201205091337.26414.ms@teamix.de>
In-Reply-To: <201205091337.26414.ms@teamix.de>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <ms@teamix.de>
Cc: fio@vger.kernel.org

On 05/09/2012 01:37 PM, Martin Steigerwald wrote:
> Hi Jens, hi everyone,
>=20
> Client is 32-bit Debian Wheezy with my 2.0.7 fio package and server is 64=
-bit=20
> Debian Wheezy with 2.0.7 fio package.
>=20
>=20
> ms@mango:~/Zeit> cat /proc/version
> Linux version 3.2.0-2-686-pae (Debian 3.2.15-1) (debian-
> kernel@lists.debian.org) (gcc version 4.6.3 (Debian 4.6.3-3) ) #1 SMP Sun=
 Apr=20
> 15 17:56:31 UTC 2012
>=20
>=20
> ms@mango:~/Zeit> vim randreadwrite.job
> ms@mango:~/Zeit> fio --client=3Dfrisbie randreadwrite.job=20
> hostname=3Dfrisbie, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64, fio=3D2.0.7
> <frisbie> zuf=EF=BF=BDlliglesen: (g=3D0): rw=3Drandread, bs=3D4K-4K/4K-4K=
, ioengine=3Dsync,=20
> iodepth=3D1
> <frisbie> zuf=EF=BF=BDlligschreiben: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/=
4K-4K,=20
> ioengine=3Dsync, iodepth=3D1
> <frisbie> Starting 2 processes
> <frisbie> =3D2): [] [100.0% done] [613K/650K /s] [149 /158  iops] [eta 00=
m:00s]
> zuf=EF=BF=BDlliglesen: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D8090
> zsh: floating point exception  fio --client=3Dfrisbie randreadwrite.job

Not reproducing here. Can you enable core dumps and see where it divides
by zero?

--=20
Jens Axboe

