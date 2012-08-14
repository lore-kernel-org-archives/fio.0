Return-Path: <bruce@cran.org.uk>
Message-ID: <502A8D8E.70200@cran.org.uk>
Date: Tue, 14 Aug 2012 18:40:30 +0100
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: "Invalidate" not functional on Windows?
References: <CAHaS=QzLW_CcDATeZnWXPEiVEGRJr9UHdohyJo53M4pp+hh27g@mail.gmail.com> <CAHaS=Qw-2ZvfvhyAHUN_y9HADFihuB=h5g=JmV9_wa27S=1Lag@mail.gmail.com> <502A4D53.7080801@kernel.dk> (sfid-20120814_151756_149302_8A63BE3A) <201208141934.00289.Martin@lichtvoll.de>
In-Reply-To: <201208141934.00289.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Jens Axboe <axboe@kernel.dk>, Greg Sullivan <greg.sullivan@sullivang.net>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 14/08/2012 18:33, Martin Steigerwald wrote:
> invalidate discards the buffer cache before the job group is started.
> During the job execution caches will be in use anyway. Unless using
> direct I/O (direct=3D1). Don=B4t know whether direct I/O will work with
> "windowsaio" I/O engine or in any other way on Windows.

On Windows (windowsaio) use sync=3D1 to disable buffering of writes. For=20
reads, use direct=3D1.

--=20
Bruce Cran

