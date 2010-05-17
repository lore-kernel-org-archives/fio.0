Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49959 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab0EQRn5 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 17 May 2010 13:43:57 -0400
Date: Mon, 17 May 2010 19:43:56 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: eta broken at numjobs=1024
Message-ID: <20100517174356.GR25951@kernel.dk>
References: <alpine.BSF.2.00.1005160231090.68302@anduin.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <alpine.BSF.2.00.1005160231090.68302@anduin.net>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erik Inge =?iso-8859-1?Q?Bols=F8?= <knan-fio@anduin.net>
Cc: fio@vger.kernel.org

On Sun, May 16 2010, Erik Inge Bols=EF=BF=BD wrote:
> Or rather, eta is broken while fio is busy forking processes, which takes=
=20
> some time at numjobs=3D1024. And while they are shutting down at the end =
a=20
> run. (fio 1.38)
>=20
> Early in the run:
>=20
> [139M/15217K /s] [35K/3715 iops] [eta 1158035696d:06h:32m:18s]
>=20
>=20
> At the end:
>=20
> Jobs: 8 (f=3D8):=20
> [________________________________________________________________________=
___________________________________________________________________________=
________________________________________________________________m___m______=
____________________________mmmmmm]=20
> [0.5% done] [91226K/10174K /s] [22K/2484 iops] [eta 02h:04m:00s]
>=20
> Hopefully just a cosmetic issue...

It's a cosmetic issue, I'll add it to the todo list.

> Btw, what's the intended replacement for rwmixcycle, since that is marked=
=20
> deprecated in the source and on use?

There's no replacement, the rwmixread/rwmixwrite are the only exposed
options.

--=20
Jens Axboe

