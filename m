Return-Path: <bengland@redhat.com>
Date: Tue, 24 May 2016 07:12:35 -0400 (EDT)
From: Ben England <bengland@redhat.com>
Message-ID: <2097283958.65342663.1464088355308.JavaMail.zimbra@redhat.com>
In-Reply-To: <12634496.Be1YEipj88@merkaba>
References: <12634496.Be1YEipj88@merkaba>
Subject: Re: fiologparser.py
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
To: Martin Steigerwald <ms@teamix.de>
Cc: fio@vger.kernel.org, Mark Nelson <mnelson@redhat.com>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

no objections here,=20

There is some additional documentation in the parse_args() routine in the "=
help" keyword parameter to parser.add_argument.

  parser.add_argument("FILE", help=3D"collectl log output files to parse", =
nargs=3D"+")

it's really a fio-generated latency log, not a collectl log

not aware of any dependencies except python-scipy.  It doesn't work with py=
thon3 yet.

Additional documentation for the -A option is in:

https://github.com/axboe/fio/pull/177

-ben

----- Original Message -----
> From: "Martin Steigerwald" <ms@teamix.de>
> To: fio@vger.kernel.org
> Cc: "Mark Nelson" <mnelson@redhat.com>, "Ben England" <bengland@redhat.co=
m>, "Jens Axboe" <axboe@kernel.dk>
> Sent: Tuesday, May 24, 2016 6:35:54 AM
> Subject: fiologparser.py
>=20
> Hello Mark, Ben,
>=20
> I found fiologparser.py in fio 2.10 and for now packaged it into the /usr=
/
> share/doc/fio. Yet I=C2=B4d like to more promintly place it in /usr/bin o=
r so=E2=80=A6 for
> that I would need it to have no script name ending (as according to Debia=
n
> Policy). Would be fine with having it renamed to just  fiologparser? I ca=
n
> provide a patch to Jens.
>=20
> Also it has no manpage, but a short intro in the script source itself. Do=
 you
> intent to provide a manpage? Otherwise I may have a go at it with help2ma=
n or
> so once in a while. It appears to have quite some options:
>=20
> # ./fiologparser.py
> usage: fiologparser.py [-h] [-i INTERVAL] [-d DIVISOR] [-f] [-A] [-a] [-s=
]
>                        FILE [FILE ...]
> fiologparser.py: error: too few arguments
>=20
> Care to elaborate what these are doing (besides what is mentioned in scri=
pt
> header)?
>=20
> It requires python-scipy it seems. Anything else?
>=20
> Thank you,
>=20
>=20

