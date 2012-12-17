Return-Path: <sbradshaw@micron.com>
From: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
Subject: RE: Latency spikes with 'thread' option
Date: Mon, 17 Dec 2012 22:23:56 +0000
Message-ID: <80B89753B40C5141A3E2D53FE7A2A8A930031AC5@NTXBOIMBX02.micron.com>
References: <80B89753B40C5141A3E2D53FE7A2A8A930030D7E@NTXBOIMBX02.micron.com>
 <50C9D5CA.9000904@kernel.dk>
In-Reply-To: <50C9D5CA.9000904@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "Mike Berhan (mberhan)" <mberhan@micron.com>
List-ID: <fio@vger.kernel.org>


> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Thursday, December 13, 2012 5:19 AM
> To: Sam Bradshaw (sbradshaw)
> Cc: fio@vger.kernel.org
> Subject: Re: Latency spikes with 'thread' option
>=20
> On 2012-12-12 21:11, Sam Bradshaw (sbradshaw) wrote:
> > Hi All,
> >
> > We're running queue depth sweeps with a 4k random read workload (sample=
 config
> > below) against a high performance PCIe SSD - the Micron p320h.  We're s=
eeing
> > latency spikes to 1 sec when the 'thread' option is used.  Instrumentin=
g the
> > driver, we see max latencies from driver entry point to block layer com=
pletion
> > callback of <20 ms at high queue depths.  If 'thread' is not used, the =
max
> > latencies reported by fio align almost exactly with that seen by the dr=
iver.
> > There are typically only one or two of these latency outliers during a =
40 sec
> > run, for example, but they represent a significant enough excursion to =
pull
> > our std. dev. very high.
> >
> > Has anyone witnessed this sort of behavior?  We see it with all the ver=
sions
> > of fio that we have used (2.0.5+) with a variety of kernels.  It's also=
 very
> > suspicious that the max latency is either almost exactly 1 sec or align=
s with
> > our hardware incurred latency for the given queue depth.
>=20
> I've seen that happen before as well, but I never got to the bottom of
> it. I just tried, and I can trigger it fairly easily that dell box. If I
> beat on two devices, it doesn't happen easily. Add the third, and it
> hits almost immediately after starting up the threads.
>=20
> For fio, the only difference between a thread and process is how they
> are kicked off. So it would seem unlikely to be something in fio.
> Perhaps it's a scheduling bug? But then it seems odd that nobody else
> has seen this. I see exactly the same latencies you report, very close
> to precisely 1s latencies. That is indeed very odd.

I've spent some time poking around and I have some more data points and a
suggestion.

First, the 1 second latency events come in batches and those batches occur=
=20
suspiciously close to a usec wrap (0.999999 us -> 1.000000 us).  Second, if=
 you
subtract exactly 1 second from these outlier latencies, the remaining amoun=
t is
very close to what our instrumented low level driver records for the IO lat=
ency
and consistent with the expected latencies of our SSD.  Similarly, the tv_u=
sec
portion of the timeval structs shows increasing values.  See snippet below.

Format is like    start: <start_time.tv_sec>.<start_time.tv_usec>

latency: 1004657 us, lba: 1111289192, start: 1355776806.995294 issue: 13557=
76806.995312 complete: 1355776807.999969
latency: 1000494 us, lba: 203093568, start: 1355776806.999456 issue: 135577=
6806.999475 complete: 1355776807.999969
latency: 1000404 us, lba: 551350992, start: 1355776806.999546 issue: 135577=
6806.999565 complete: 1355776807.999969
latency: 1000477 us, lba: 449672928, start: 1355776806.999484 issue: 135577=
6806.999492 complete: 1355776807.999969

All this pointed to the time collection code being buggy.  Reviewing the=20
code, I spotted this in fio_gettime():

	/*
	 * If Linux is using the tsc clock on non-synced processors,
	 * sometimes time can appear to drift backwards. Fix that up.
	 */
	if (last_tv_valid) {
		if (tp->tv_sec < last_tv.tv_sec)
			tp->tv_sec =3D last_tv.tv_sec;
		else if (last_tv.tv_sec =3D=3D tp->tv_sec &&
			 tp->tv_usec < last_tv.tv_usec)
			tp->tv_usec =3D last_tv.tv_usec;
	}
	last_tv_valid =3D 1;
	memcpy(&last_tv, tp, sizeof(*tp));

This does not appear to be multi-thread safe.  Pre-emption can occur betwee=
n=20
either comparison and the subsequent update.  Commenting it out makes the
problem go away (at the expense of being subject to drift).  How about
making last_tv & last_tv_valid thread-local?

-Sam



