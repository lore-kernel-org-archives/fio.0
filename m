Return-Path: <martin.steigerwald@teamix.de>
From: Martin Steigerwald <martin.steigerwald@teamix.de>
Subject: fio: uses the opposite symbol for kibibytes/kilobytes (Kb/KiB) than ISO 80000-1
Date: Mon, 28 Aug 2017 11:06:26 +0200
Message-ID: <7412967.4hxrjql1Vb@merkaba>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
To: FIO mailing list <fio@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, 872321@bugs.debian.org
List-ID: <fio@vger.kernel.org>

=EF=BB=BFI bcc=C2=B4ed Debian bug report for this initial mail so it receiv=
es a record that=20
I forwarded this issue upstream.


Hello Jens,

I got this bug report for fio Debian package:

fio: uses the opposite symbol for kibibytes/kilobytes (Kb/KiB) than ISO 800=
00-1
https://bugs.debian.org/872321

Its right. Completely right. The current behavior of fio is broken.

But if I choose to divert from upstream default, I break *all included=20
examples* unless I patch them up to and I risk bug reports "my script broke=
=20
cause you decided to divert from upstream default behavior". Additionally=20
currently it seems to me that I have to patch fio source code, unless fio=20
supports a global configuration file in /etc, which, I believe, it does not=
.

What do you suggest me to do?

I am currently pondering the following options:

- Adding a warning note to NEWS.Debian and README.Debian that at least user=
s=20
who have apt-listchanges installed will see.

- Add a debconf configuration option aka "Yes, be correct and break all=20
scripts", "No, let me stay compatible with upstream". But that wouldn=C2=B4=
t=20
possible anyway unless there is a global configuration file for fio.

None of these options sound appealing to me.


I really think this issue needs to be dealt with upstream, but I honestly d=
o=20
not know how either. But just staying with the broken behavior for eternity=
=20
does not seem right to me. I think the move to fio 3 would have been an=20
opportunity, but thats gone.

I wonder about the following compromize:

- blocksize=3D4k =3D> KiB, 4096
- blocksize=3D4kb =3D> KB, 4000
- blocksize=3D4kib =3D> KiB, 4096

This at least won=C2=B4t break existing scripts unless they used kib, gib a=
nd so=20
on, I think.

And it would at least fix:

% fio --name=3Drand-read --bs=3D4k --size=3D1GiB --iodepth=3D64 --runtime=
=3D10 --
rw=3Drandread
[=E2=80=A6]
rand-read: Laying out IO file(s) (1 file(s) / 953MiB)
[=E2=80=A6]

which is just as broken as it can become. Seriously, 1 GiB is not 953 MiB.=
=20
Period.


Even if thats an uncomfortable issue to deal with, I honestly don=C2=B4t re=
ally see=20
it as my responsibility as a package maintainer to fix up broken upstream=20
behavior and probably receive the blame for doing so. If you choose to stay=
=20
with the current behavior I may at least add a note in NEWS.Debian and=20
README.Debian about the broken behavior tough.

Thanks,

--=20
Martin Steigerwald  | Trainer

teamix GmbH
S=C3=BCdwestpark 43
90449 N=C3=BCrnberg

Tel.:  +49 911 30999 55 | Fax: +49 911 30999 99
mail: martin.steigerwald@teamix.de | web:  http://www.teamix.de | blog: htt=
p://blog.teamix.de

Amtsgericht N=C3=BCrnberg, HRB 18320 | Gesch=C3=A4ftsf=C3=BChrer: Oliver K=
=C3=BCgow, Richard M=C3=BCller, Jason Clark, Jakob H=C3=B8holdt

teamix Support Hotline: +49 911 30999-112
=20
 *** Bitte liken Sie uns auf Facebook: facebook.com/teamix ***


