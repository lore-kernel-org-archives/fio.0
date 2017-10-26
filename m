Return-Path: <martin.steigerwald@proact.de>
From: Martin Steigerwald <martin.steigerwald@proact.de>
Subject: Re: fio: uses the opposite symbol for kibibytes/kilobytes (Kb/KiB) than ISO 80000-1
Date: Thu, 26 Oct 2017 10:42:11 +0200
Message-ID: <3016894.pBtxSRvArJ@merkaba>
In-Reply-To: <AT5PR84MB0082C5593313904363219920AB470@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
References: <7412967.4hxrjql1Vb@merkaba> <6373845.SOZOToCyQ8@merkaba> <AT5PR84MB0082C5593313904363219920AB470@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: FIO mailing list <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hello Robert.

Elliott, Robert (Persistent Memory) - 24.10.17, 16:23:
> > > I got this bug report for fio Debian package:
> > >
> > >
> > >
> > > fio: uses the opposite symbol for kibibytes/kilobytes (Kb/KiB) than

Sorry for safelink crap. (Need to remember to use my own SMTP to circumvent=
=20
it.)

> https://bugs.debian.org/872321
>
> > > Its right. Completely right. The current behavior of fio is broken.
> > >
> > >
> > >
> > > But if I choose to divert from upstream default, I break *all included
> > > examples* unless I patch them up to and I risk bug reports "my script
> > > broke cause you decided to divert from upstream default behavior".
>=20
>=20
> No scripts were harmed in the process; the default still presumes that
> scripts are specifying numbers based on binary units.  You must add=20
> kb_base=3D1000 to switch to correct units.

I don=B4t really understand this one. If I would change fio=B4s default beh=
avior, I=20
bet scripts may break. I wouldn=B4t change the meaning of "k" anyway, but j=
ust=20
of "kib" and "kb", but still if a script uses one of these, it would break.

Additionally I would need to patch fio source code as I am not aware of any=
=20
other way to change this default behavior.

I decided that I won=B4t do that.

So unless any change in upstream I will do with the README approach.

However, likely after an initial fio 3.1 Debian package uploaded is done. I=
=20
just asked my sponsor Sven Hoexter to review the package.

> The user-readable text output changed to use correct units, but the
> structured output formats intended for automated parsing did not change.

Hmm, interesting.

Thanks,
Martin


