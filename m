Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:33566 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbZHETCt (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 5 Aug 2009 15:02:49 -0400
Date: Wed, 5 Aug 2009 21:02:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Solaris issues in 1.3.1
Message-ID: <20090805190249.GD12579@kernel.dk>
References: <f3177b9e0908051110t21d989a1rb68d519c25231ba4@mail.gmail.com> <20090805185527.GB12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20090805185527.GB12579@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: fio@vger.kernel.org

On Wed, Aug 05 2009, Jens Axboe wrote:
> On Wed, Aug 05 2009, Chris Worley wrote:
> > I'm running fio 1.3.1 in Solaris.=EF=BF=BD I'm seeing two issues:
> >=20
> > 1) Direct I/O throws an error.
> > 2) Performance is way too high.
> >=20
> > W/o Direct I/O my size is set to 2.5x memory capacity to assure no
> > caching... yet performance for read/write is up to >7x the theoretical
> > speed of the storage device (i.e. it's reporting 7GB/s, when
> > theoretical for the device is 1GB/s).
> >=20
> > I'm not seeing the reporting issue in 1.2.1.
>=20
> Are you familiar with git? If yes, then you could try and bisect the
> issue. You would do something ala:
>=20
> $ git bisect start
> $ git bisect good fio-1.21
> $ git bisect bad fio-1.31
>=20
> and then git would checkout a point in between. You would then compile
> and run, checking if it works or not. If the version works, then you
> would reply with
>=20
> $ git bisect good
>=20
> if not, then you would do
>=20
> $ git bisect bad
>=20
> This continues until git tells you which commit is the defective one.
> I'll give it a spin on Solaris too, I recently put Solaris 11 on a box
> for test purposes.

Oh, and if you are not, just wait and I'll double check things here. But
please send me your job file(s) so I can reproduce more easily, thanks.

--=20
Jens Axboe

