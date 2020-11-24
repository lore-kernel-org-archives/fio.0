Return-Path: <prvs=590ceb13c=Dmitry.Fomichev@wdc.com>
From: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: RE: [PATCH 00/15] ZBD fixes and improvements
Date: Tue, 24 Nov 2020 01:12:27 +0000
Message-ID: 
 <MN2PR04MB59512E4747068FB075F30CA3E1FB0@MN2PR04MB5951.namprd04.prod.outlook.com>
References: <20201121024532.16834-1-dmitry.fomichev@wdc.com>
 <4e35b427-c7df-f744-3c11-8e301e83999d@acm.org>
 <MN2PR04MB595110E3436147F4BFEFFEF9E1FC0@MN2PR04MB5951.namprd04.prod.outlook.com>
 <CH2PR04MB652206B15754860733DA7D98E7FB0@CH2PR04MB6522.namprd04.prod.outlook.com>
In-Reply-To: 
 <CH2PR04MB652206B15754860733DA7D98E7FB0@CH2PR04MB6522.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Damien Le Moal <Damien.LeMoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

> -----Original Message-----
> From: Damien Le Moal <Damien.LeMoal@wdc.com>
> Sent: Monday, November 23, 2020 7:07 PM
> To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>; Bart Van Assche
> <bvanassche@acm.org>; Jens Axboe <axboe@kernel.dk>;
> fio@vger.kernel.org; Aravind Ramesh <Aravind.Ramesh@wdc.com>;
> Naohiro Aota <Naohiro.Aota@wdc.com>; Niklas Cassel
> <Niklas.Cassel@wdc.com>
> Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Subject: Re: [PATCH 00/15] ZBD fixes and improvements
>=20
> On 2020/11/24 4:18, Dmitry Fomichev wrote:
> >> -----Original Message-----
> >> From: Bart Van Assche <bvanassche@acm.org>
> >> Sent: Friday, November 20, 2020 11:01 PM
> >> To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>; Jens Axboe
> >> <axboe@kernel.dk>; fio@vger.kernel.org; Aravind Ramesh
> >> <Aravind.Ramesh@wdc.com>; Naohiro Aota <Naohiro.Aota@wdc.com>;
> >> Niklas Cassel <Niklas.Cassel@wdc.com>
> >> Cc: Damien Le Moal <Damien.LeMoal@wdc.com>; Shinichiro Kawasaki
> >> <shinichiro.kawasaki@wdc.com>
> >> Subject: Re: [PATCH 00/15] ZBD fixes and improvements
> >>
> >> On 11/20/20 6:45 PM, Dmitry Fomichev wrote:
> >>> This patch series contains bug fixes and refactoring changes
> >>> related to support for Zoned Block Devices (ZBD) in fio.
> >>> The highlights:
> >>>
> >>>  - fix several errors related to running workloads that span
> >>>    a mix of conventional zones and write pointer zones.
> >>>  - improve counting of sectors with data (SWD).
> >>>  - remove dependencies on particular zone types in the code.
> >>>  - add code to gracefully handle offline zones.
> >>
> >> Hi Dmitry,
> >>
> >> This patch series looks interesting. Out of curiosity, do you perhaps
> >> know how much of the modified code is covered by the tests in t/zbd?
> >
> > Hi Bart,
> >
> > All tests in t/zbd are passing with this series in place. This gives us
> confidence
> > that the patches don't break anything in terms of the existing function=
ality.
> > Most of the bugs that are fixed in this patchset were uncovered by runn=
ing
> fio in
> > environments that go beyond the scope of t/zbd tests, such as ZNS, XMR,
> some
> > specific MaxOpen values, etc. and the fixes have been verified in these
> same
> > conditions. Having said that, the newer test #48 has become a very hand=
y
> tool
> > for identifying zone deadlocks.
> >
> > One caveat about the paragraph above - some test script modifications a=
re
> > needed to fully cover support for offline zones and I have some patches=
 in
> the
> > works to add such functionality. I am planning to send these in in the =
near
> future.
> > The current tests do pass in the case of individually injected offline =
zones
> on a
> > drive and this level of testing should suffice for the time being.
> >
> > One thing that I thought about while writing this email - maybe we coul=
d
> add
> > a script to run t/zbd tests on a mixed null_blk with a good amount of
> conventional
> > zones? Damien, Shinichiro, do you think that such an addition would
> improve the
> > test coverage?
>=20
> Yes, we should add that to run-tests-against-zoned-nullb to avoid future
> possible regressions with conventional zones. And we should make sure tha=
t
> one
> test case runs over a range of mixed conv/seq zones.
>=20
> Going further, I think that we should merge run-tests-against-zoned-nullb
> and
> run-tests-against-zoned-nullb into a new script run-tests-against-nullb w=
hich
> would test all device configurations: regular nullb, zoned nullb with
> conventional zones (SMR disk like device), zoned nullb with seq zones onl=
y
> and
> zone capacity < zone size (ZNS like device). With that, test coverage wou=
ld be
> improved to include all recent changes.

I was thinking about adding a meta-script that would invoke the existing tw=
o
and some new scripts, but we could just merge all of them like you suggeste=
d.
The entire test would consist of several sections and each of them would ru=
n
the entire test-zbd-support script against different null_blk configuration=
s.
I'll try to come up with something like that... This leaves the question - =
should
such a script be posted separately or be included in this series. IMO, it s=
hould
be a separate patch(set).

>=20
> >
> > Best regards,
> > Dmitry
> >
> >>
> >> Thanks,
> >>
> >> Bart.
> >
>=20
>=20
> --
> Damien Le Moal
> Western Digital Research

