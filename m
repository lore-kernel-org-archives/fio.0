Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:58513 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab2FHNDR (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 8 Jun 2012 09:03:17 -0400
Message-ID: <4FD1F462.4070404@fusionio.com>
Date: Fri, 8 Jun 2012 14:47:30 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Error running Fio SSD example
References: <4FC8942A.6090805@thomas-krenn.com>
In-Reply-To: <4FC8942A.6090805@thomas-krenn.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?ISO-8859-15?Q?Georg_Sch=F6nberger?= <gschoenberger@thomas-krenn.com>
Cc: fio@vger.kernel.org

On 06/01/2012 12:06 PM, Georg Sch=EF=BF=BDnberger wrote:
> Hello again,
>=20
> I am having some troubles with running the fio example "ssd-test". I
> changed the global section to decrease the size:
> [global]
> bs=3D4k
> ioengine=3Dlibaio
> iodepth=3D4
> size=3D100M
> direct=3D1
> runtime=3D60
> filename=3Dssd.test.file
>=20
> If I am running Fio I get the following error:
> ----------------------------------------
> fio.git/examples$ fio ssd-test
> seq-read: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, iodept=
h=3D4
> rand-read: (g=3D1): rw=3Drandread, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, i=
odepth=3D4
> seq-write: (g=3D2): rw=3Dwrite, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, iode=
pth=3D4
> rand-write: (g=3D3): rw=3Drandwrite, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio,=
 iodepth=3D4
> fio-2.0.8
> Starting 4 processes
> fio: pid=3D17997, err=3D22/file:filesetup.c:529, func=3Dopen(ssd.test.fil=
e),
> error=3DInvalid argument
> fio: pid=3D17998, err=3D22/file:filesetup.c:529, func=3Dopen(ssd.test.fil=
e),
> error=3DInvalid argument
> fio: pid=3D17999, err=3D22/file:filesetup.c:529, func=3Dopen(ssd.test.fil=
e),
> error=3DInvalid argument
> fio: pid=3D18000, err=3D22/file:filesetup.c:529, func=3Dopen(ssd.test.fil=
e),
> error=3DInvalid argument

Looks like the file system hosting the test file does not support
O_DIRECT.

--=20
Jens Axboe

