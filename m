Return-Path: <ms@teamix.de>
From: Martin Steigerwald <ms@teamix.de>
Subject: fiologparser.py
Date: Tue, 24 May 2016 12:35:54 +0200
Message-ID: <12634496.Be1YEipj88@merkaba>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
To: fio@vger.kernel.org
Cc: Mark Nelson <mnelson@redhat.com>, Ben England <bengland@redhat.com>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hello Mark, Ben,

I found fiologparser.py in fio 2.10 and for now packaged it into the /usr/
share/doc/fio. Yet I=C2=B4d like to more promintly place it in /usr/bin or =
so=E2=80=A6 for=20
that I would need it to have no script name ending (as according to Debian=
=20
Policy). Would be fine with having it renamed to just  fiologparser? I can=
=20
provide a patch to Jens.

Also it has no manpage, but a short intro in the script source itself. Do y=
ou=20
intent to provide a manpage? Otherwise I may have a go at it with help2man =
or=20
so once in a while. It appears to have quite some options:

# ./fiologparser.py        =20
usage: fiologparser.py [-h] [-i INTERVAL] [-d DIVISOR] [-f] [-A] [-a] [-s]
                       FILE [FILE ...]
fiologparser.py: error: too few arguments

Care to elaborate what these are doing (besides what is mentioned in script=
=20
header)?

It requires python-scipy it seems. Anything else?

Thank you,


