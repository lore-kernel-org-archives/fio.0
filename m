Return-Path: <Martin@lichtvoll.de>
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: "Invalidate" not functional on Windows?
Date: Tue, 14 Aug 2012 19:33:59 +0200
References: <CAHaS=QzLW_CcDATeZnWXPEiVEGRJr9UHdohyJo53M4pp+hh27g@mail.gmail.com> <CAHaS=Qw-2ZvfvhyAHUN_y9HADFihuB=h5g=JmV9_wa27S=1Lag@mail.gmail.com> <502A4D53.7080801@kernel.dk> (sfid-20120814_151756_149302_8A63BE3A)
In-Reply-To: <502A4D53.7080801@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Message-Id: <201208141934.00289.Martin@lichtvoll.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Greg Sullivan <greg.sullivan@sullivang.net>, fio@vger.kernel.org, Bruce Cran <BCran@fusionio.com>
List-ID: <fio@vger.kernel.org>

Am Dienstag, 14. August 2012 schrieb Jens Axboe:
> On 08/14/2012 06:57 AM, Greg Sullivan wrote:
> > I need to perform reads without using any caching. I have the line
> > "invalidate=3D1" in my job file, however it is still using the cache.  I
> > am running Windows 7 32-bit. Is the "invalidate" command supposed to
> > be functional on Windows? If so, what am I doing wrong?
> >=20
> > That aside, what a great utility this is - thankyou!!
>=20
> As far as what I remember from talking/mailing with Bruce (CC'ed),
> there's no way to invalidate the cache in Windows.

invalidate discards the buffer cache before the job group is started.
During the job execution caches will be in use anyway. Unless using
direct I/O (direct=3D1). Don=B4t know whether direct I/O will work with
"windowsaio" I/O engine or in any other way on Windows.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

