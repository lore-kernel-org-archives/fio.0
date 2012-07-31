Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60508 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234Ab2GaSsi (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 31 Jul 2012 14:48:38 -0400
Message-ID: <50182883.7060204@kernel.dk>
Date: Tue, 31 Jul 2012 20:48:35 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Print info if direct I/O is used
References: <4FF456C1.9070200@thomas-krenn.com>
In-Reply-To: <4FF456C1.9070200@thomas-krenn.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?ISO-8859-15?Q?Georg_Sch=F6nberger?= <gschoenberger@thomas-krenn.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2012-07-04 16:44, Georg Sch=EF=BF=BDnberger wrote:
> Hi Jens,
>=20
> it would be nice if an information is printed out if direct I/O has been
> used:
> Instead of
> --------
> /usr/local/bin/fio --rw=3Dwrite --direct=3D1 --name=3Dusb --filename=3D/d=
ev/sdb1
> usb: (g=3D0): rw=3Dwrite, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodepth=3D1
> --------
> I suggest
> --------
> /usr/local/bin/fio --rw=3Dwrite --direct=3D1 --name=3Dusb --filename=3D/d=
ev/sdb1
> usb: (g=3D0): rw=3Dwrite, bs=3D4K-4K/4K-4K, ioengine=3Dsync, direct=3D1, =
iodepth=3D1
> --------
> So I can verify if the page cache has been used for a test when
> inspecting the output files.

I'll take a patch to add that :-)

--=20
Jens Axboe

