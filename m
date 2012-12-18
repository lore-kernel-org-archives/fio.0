Return-Path: <sbradshaw@micron.com>
From: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
Subject: RE: Latency spikes with 'thread' option
Date: Tue, 18 Dec 2012 21:16:06 +0000
Message-ID: <80B89753B40C5141A3E2D53FE7A2A8A930031FB7@NTXBOIMBX02.micron.com>
References: <80B89753B40C5141A3E2D53FE7A2A8A930030D7E@NTXBOIMBX02.micron.com>
 <50C9D5CA.9000904@kernel.dk>
 <80B89753B40C5141A3E2D53FE7A2A8A930031AC5@NTXBOIMBX02.micron.com>
 <50D01990.7080102@kernel.dk> <50D02951.4030608@kernel.dk>
In-Reply-To: <50D02951.4030608@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "Mike Berhan (mberhan)" <mberhan@micron.com>
List-ID: <fio@vger.kernel.org>


> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Tuesday, December 18, 2012 12:29 AM
> To: Sam Bradshaw (sbradshaw)
> Cc: fio@vger.kernel.org; Mike Berhan (mberhan)
> Subject: Re: Latency spikes with 'thread' option
>=20
> On 2012-12-18 08:21, Jens Axboe wrote:
> > Good analysis and I believe you are correct. It's not safely shared and
> > should be thread local. A quick test here with the below seems to
> > indicate that that is indeed the issue, I don't see any time weirdness
> > with that applied.
>=20
> Bah, so that didn't work on all the supported platforms (notably OSX
> does not have support for __thread). I've committed a patch that should
> work across platforms, please give the current fio git a try (5d879392
> or newer).

Works great.  No abnormal latency spikes, nor do our measurements of peak
IOPs differ from prior releases.

One tidbit though: fio_gettime() shows a much larger % of execution time
with the default clocksource than the gettimeofday() clocksource.  In a
512b random read workload with gtod_reduce disabled, for example, up to 15%=
=20
of the userspace execution time was spent in fio_gettime() with the default
clocksource vs. 5% with gettimeofday().  The latency is mostly incurred
at the divisions that convert nsecs? to secs for populating the timeval
struct.  I don't have a suggestion to replace the

usecs =3D t / cycles_per_usec=20

division but the=20

tp->tv_sec =3D usecs / 1000000

could be reduced by instead comparing "t" to "tv->last_cycles" to see if
they differ by more than 1000000.  If so, do the division and capture
secs in tv->tv_sec.  If not, just copy the last recorded tv->tv_sec into
tp->tv_sec.  That way, the division in only incurred every second at a=20
minimum.

I could put together a patch if you like; I just have limited ability
to test the change on the multitude of platforms supported by fio.

-Sam


