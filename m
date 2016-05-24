Return-Path: <ms@teamix.de>
From: Martin Steigerwald <ms@teamix.de>
Subject: GPG signed release tarballs
Date: Tue, 24 May 2016 11:52:59 +0200
Message-ID: <5317714.h06u3Dy0pi@merkaba>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi Jens!

I wonder about a way to retrieve the source after checking upstream gpg=20
signature. Do you provide those somewhere?

I don=B4t see any on: http://brick.kernel.dk/snaps/ where I usually go for=
=20
getting new upstream release tarball.


N: Processing source package fio (version 2.10-1, arch source) ...
P: fio source: debian-watch-may-check-gpg-signature
N:=20
N:    This watch file does not include a means to verify the upstream tarba=
ll
N:    using cryptographic signature.
N:   =20
N:    If upstream distributions provide such signatures, please use the
N:    pgpsigurlmangle options in this watch file's opts=3D to generate the =
URL
N:    of an upstream GPG signature. This signature is automatically downloa=
ded
N:    and verified against a keyring stored in
N:    debian/upstream/signing-key.asc.
N:   =20
N:    Of course, not all upstreams provide such signatures, but you could
N:    request them as a way of verifying that no third party has modified t=
he
N:    code against their wishes after the release. Projects such as
N:    phpmyadmin, unrealircd, and proftpd have suffered from this kind of
N:    attack.
N:   =20
N:    Refer to the uscan(1) manual page for details.
N:   =20
N:    Severity: pedantic, Certainty: certain
N:   =20
N:    Check: watch-file, Type: source

