Return-Path: <martin.steigerwald@teamix.de>
From: Martin Steigerwald <martin.steigerwald@teamix.de>
Subject: Removing *.py ending from python script filenames
Date: Mon, 23 Jan 2017 13:16:53 +0100
Message-ID: <2172844.j6hkAc7SIx@merkaba>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
To: fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@sandisk.com>, Mark Nelson <mnelson@redhat.com>, Ben England <bengland@redhat.com>, Karl Cronburg <karl.cronburg@gmail.com>, Jens Axboe <axboe@kernel.dk>, Sven Hoexter <hoexter@debian.org>
List-ID: <fio@vger.kernel.org>

=EF=BB=BFHello Vincent, Mark, Ben, Karl, Jens,

I just prepared packaging for fio-2.17 and as I added some of the new Pytho=
n=20
script I again came across the issues the file name ending "*.py" creates=20
within Debian.

1) As per Debian policy files in /usr/bin or /usr/sbin or any of the other =
bin=20
directory may not have such a file ending. Thus I may not put the files in=
=20
$PATH.

2) Man or the manpage integration debhelper script do not like this file en=
ding=20
either:

[=E2=80=A6]/usr/share/doc/fio> dpkg -L fio | grep man =20
[=E2=80=A6]
/usr/share/man/py
/usr/share/man/py/man1
/usr/share/man/py/man1/fiologparser_hist.1.gz

(the section here is complete crap)

And=E2=80=A6 well all ways to rename files *just* prior to the packaging ru=
n=E2=80=A6 are as=20
far as I know=E2=80=A6 quite ugly =E2=80=93 like preparing modified upstrea=
m tarball and things=20
like that.

Now I wonder whether you would be okay with just removing the "*.py" filena=
me=20
ending from the script and manpage filenames.

[=E2=80=A6]fio-upstream> find -iname "*.py*" | grep -v unit_tests
./tools/fio_latency2csv.py
./tools/fiologparser.py
./tools/hist/fiologparser_hist.py
./tools/hist/fiologparser_hist.py.1
./tools/hist/half-bins.py

This would be the easiest solution for me as a packager, would allow to put=
=20
scripts into $PATH and I think the "*.py" doesn=C2=B4t really add much valu=
e.=20
Actually the user of such a script can still see whether its a python scrip=
t=20
by looking at the file.

Also for putting things in $PATH it might make sense to add "fio" to the=20
scriptname "half-bins.py" maybe "fio-half-bins.py".

I could prepare an upstream patch for that one=E2=80=A6  if you are okay wi=
th the name=20
change.

And PS: Any intention to write some manpages for the scripts where they are=
=20
missing? :)

Thank you,

--=20
Martin Steigerwald  | Trainer

teamix GmbH
S=C3=BCdwestpark 43
90449 N=C3=BCrnberg

Tel.:  +49 911 30999 55 | Fax: +49 911 30999 99
mail: martin.steigerwald@teamix.de | web:  http://www.teamix.de | blog: htt=
p://blog.teamix.de

Amtsgericht N=C3=BCrnberg, HRB 18320 | Gesch=C3=A4ftsf=C3=BChrer: Oliver K=
=C3=BCgow, Richard M=C3=BCller, Jakob H=C3=B8holdt

teamix Support Hotline: +49 911 30999-112
=20
 *** Bitte liken Sie uns auf Facebook: facebook.com/teamix ***


