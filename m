Return-Path: <martin.steigerwald@teamix.de>
From: Martin Steigerwald <ms@teamix.de>
Subject: Re: relationship of fio versus gfio
Date: Tue, 10 Nov 2015 11:25:32 +0100
Message-ID: <2367452.mALFllXUSD@merkaba>
In-Reply-To: <564117A0.1070900@kernel.dk>
References: <6266593.Pst2hzQaXB@merkaba> <564117A0.1070900@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

=EF=BB=BFAm Montag, 9. November 2015, 15:01:04 CET schrieb Jens Axboe:
> On 11/06/2015 01:54 AM, Martin Steigerwald wrote:
> > Hello Jens, hello fio community.
> >=20
> > During package review of my new fio package my reviewer raised the
> > question of the relationship between gfio and fio. I already also
> > wondered about it before.
> >=20
> > Can gfio be used on a system, without fio installed? My guess would be
> > yes: As fio could be running on another machine as a server.
>=20
> That is correct.

Thanks. My sponsor Sven just uploaded the debian package to unstable.

>=20
> > Also currently I have it that gfio is linked against the same libraries=
 as
> > fio. Is a complete fio engine included in gfio?
>=20
> There was a plan to more cleanly separate them, as the client frontends
> need not link with all the nitty gritty details as the backend. But the
> amount of effort required to get that cleaner meant that it didn't
> really happen. It's not difficult, it's just a lot of manual work in
> establishing the code boundaries between the two.

I see.

I also wondered about doing some Qt Quick based frontend for fio, but never=
=20
got along starting it. Also it would be redoing work that is already done=20
(gfio).

Thanks,

--=20
Martin Steigerwald  | Consultant / Trainer

teamix GmbH
S=C3=BCdwestpark 43
90449 N=C3=BCrnberg

Tel.:  +49 911 30999 55 | Fax: +49 911 30999 99
mail: martin.steigerwald@teamix.de | web:  http://www.teamix.de | blog: htt=
p://blog.teamix.de

Amtsgericht N=C3=BCrnberg, HRB 18320 | Gesch=C3=A4ftsf=C3=BChrer: Oliver K=
=C3=BCgow, Richard M=C3=BCller

teamix Support Hotline: +49 911 30999-112
=20
 *** Besuchen Sie uns vom 16.-19.11.2015 auf der NetApp Insight im CityCube=
 in Berlin auf Stand A5. ***


