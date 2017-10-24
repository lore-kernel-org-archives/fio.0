Return-Path: <martin.steigerwald@proact.de>
From: Martin Steigerwald <martin.steigerwald@proact.de>
Subject: Re: fio: uses the opposite symbol for kibibytes/kilobytes (Kb/KiB) than ISO 80000-1
Date: Tue, 24 Oct 2017 10:13:11 +0200
Message-ID: <1714288.mpFKz9OknG@merkaba>
In-Reply-To: <7412967.4hxrjql1Vb@merkaba>
References: <7412967.4hxrjql1Vb@merkaba>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
To: FIO mailing list <fio@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Send again without that long and misleading mail signature. Sorry for noise.


Hello Jens, hello fio community.

Anything? Anything at all?

If not, I go by a NEWS.Debian entry that explains the issue, but otherwise =
I=20
tend to leave intact the broken, but wide-spread default behavior.

Thanks,
Martin

Martin Steigerwald - 28.08.17, 11:06:
> I bcc=C2=B4ed Debian bug report for this initial mail so it receives a re=
cord
> that I forwarded this issue upstream.
>=20
>=20
> Hello Jens,
>=20
> I got this bug report for fio Debian package:
>=20
> fio: uses the opposite symbol for kibibytes/kilobytes (Kb/KiB) than ISO
> 80000-1 https://bugs.debian.org/872321
>=20
> Its right. Completely right. The current behavior of fio is broken.
>=20
> But if I choose to divert from upstream default, I break *all included
> examples* unless I patch them up to and I risk bug reports "my script bro=
ke
> cause you decided to divert from upstream default behavior". Additionally
> currently it seems to me that I have to patch fio source code, unless fio
> supports a global configuration file in /etc, which, I believe, it does n=
ot.
>=20
> What do you suggest me to do?
>=20
> I am currently pondering the following options:
>=20
> - Adding a warning note to NEWS.Debian and README.Debian that at least us=
ers
> who have apt-listchanges installed will see.
>=20
> - Add a debconf configuration option aka "Yes, be correct and break all
> scripts", "No, let me stay compatible with upstream". But that wouldn=C2=
=B4t
> possible anyway unless there is a global configuration file for fio.
>=20
> None of these options sound appealing to me.
>=20
>=20
> I really think this issue needs to be dealt with upstream, but I honestly=
 do
> not know how either. But just staying with the broken behavior for eterni=
ty
> does not seem right to me. I think the move to fio 3 would have been an
> opportunity, but thats gone.
>=20
> I wonder about the following compromize:
>=20
> - blocksize=3D4k =3D> KiB, 4096
> - blocksize=3D4kb =3D> KB, 4000
> - blocksize=3D4kib =3D> KiB, 4096
>=20
> This at least won=C2=B4t break existing scripts unless they used kib, gib=
 and so
> on, I think.
>=20
> And it would at least fix:
>=20
> % fio --name=3Drand-read --bs=3D4k --size=3D1GiB --iodepth=3D64 --runtime=
=3D10 --
> rw=3Drandread
> [=E2=80=A6]
> rand-read: Laying out IO file(s) (1 file(s) / 953MiB)
> [=E2=80=A6]
>=20
> which is just as broken as it can become. Seriously, 1 GiB is not 953 MiB.
> Period.
>=20
>=20
> Even if thats an uncomfortable issue to deal with, I honestly don=C2=B4t =
really
> see it as my responsibility as a package maintainer to fix up broken
> upstream behavior and probably receive the blame for doing so. If you
> choose to stay with the current behavior I may at least add a note in
> NEWS.Debian and README.Debian about the broken behavior tough.
>=20
> Thanks,


