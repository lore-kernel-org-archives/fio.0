Return-Path: <prvs=6493999f6=Dmitry.Fomichev@wdc.com>
From: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: RE: [PATCH v3 00/38] ZBD fixes and improvements
Date: Fri, 22 Jan 2021 20:31:58 +0000
Message-ID: 
 <MN2PR04MB5951837AD8739C63EA1CA707E1A00@MN2PR04MB5951.namprd04.prod.outlook.com>
References: <20210106215739.264524-1-dmitry.fomichev@wdc.com>
 <20210122092457.kya3nis4g3bs2j6i@shindev.dhcp.fujisawa.hgst.com>
In-Reply-To: <20210122092457.kya3nis4g3bs2j6i@shindev.dhcp.fujisawa.hgst.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

Shinichiro,

Thank you for reviewing! I am going to send a v4 with the changes to
t/zbd/run-tests-against-nullb script that you have suggested, extended
commit message in "zbd: improve replay range validation" patch and
added sign-off for " zbd: count sectors with data for write pointer zones"
patch.

Best regards,
Dmitry

> -----Original Message-----
> From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Sent: Friday, January 22, 2021 4:25 AM
> To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
> Cc: Jens Axboe <axboe@kernel.dk>; fio@vger.kernel.org; Aravind Ramesh
> <Aravind.Ramesh@wdc.com>; Bart Van Assche <bvanassche@acm.org>;
> Naohiro Aota <Naohiro.Aota@wdc.com>; Niklas Cassel
> <Niklas.Cassel@wdc.com>; Damien Le Moal <Damien.LeMoal@wdc.com>
> Subject: Re: [PATCH v3 00/38] ZBD fixes and improvements
>=20
> On Jan 07, 2021 / 06:57, Dmitry Fomichev wrote:
> > v2 -> v3:
> >
> >  - fix two libzbc-related bugs in test scripts (found by Shinichiro).
> >  - modify libzbc ioengine code to allow fio to operate successfully
> >    against null_blk devices while using this ioengine.
> >  - add -l option to run-tests-against-nullb script to allow running
> >    the tests while using libzbc ioengine.
> >  - add -n option to run-tests-against-nullb to allow running the
> >    specified tests multiple times. This option is the most useful
> >    in combination with the existing -s and -t options.
> >  - fix sporadic failed assertion in test #51 that is easily triggered
> >    by running run-tests-against-nullb script with -l and -n options.
> >  - make minor coding style improvements in run-tests-against-nullb.
> >
> > v1 -> v2:
> >
> >  - replace both run-tests-against-conventional-nullb and
> >    run-tests-against-conventional-nullb with a single script,
> >    run-tests-against-nullb, that runs test-zbd-support unit tests
> >    over a variety on different zoned configurations.
> >  - add five new test cases to test-zbd-support to cover the code
> >    changes made in zbd.c as a part of this series.
> >  - mark all test cases in test-zbd-support script that are not
> >    applicable for the device configuration as SKIP instead of
> >    reporting them as passed.
> >  - properly handle writes to conventional zones that cross over
> >    to sequential zones.
> >  - make additional improvements in zone locking parts of zbd.c.
> >  - implement miscellaneous test script enhancements.
> >
> > This patch series contains bug fixes and refactoring changes
> > related to support for Zoned Block Devices (ZBD) in fio.
> > The highlights:
> >
> >  - fix several errors related to running workloads that span
> >    a mix of conventional zones and write pointer zones.
> >  - improve counting of sectors with data (SWD).
> >  - remove dependencies on particular zone types in the code.
> >  - add code to gracefully handle offline zones.
> >
> > Aravind Ramesh (1):
> >   zbd: initialize sectors with data at start time
> >
> > Dmitry Fomichev (25):
> >   zbd: return ENOMEM if zone buffer allocation fails
> >   zbd: use zbd_zone_nr() more actively in the code
> >   zbd: add get_zone() helper function
> >   zbd: introduce zone_unlock()
> >   zbd: engines/libzbc: don't fail on assert for offline zones
> >   zbd: remove dependency on zone type during i/o
> >   zbd: skip offline zones in zbd_convert_to_open_zone()
> >   zbd: avoid zone buffer overrun
> >   zbd: don't unlock zone mutex after verify replay
> >   zbd: use zone_lock() in zbd_process_swd()
> >   zbd: don't log "zone nnnn is not open" message
> >   zbd: handle conventional start zone in zbd_convert_to_open_zone()
> >   zbd: improve replay range validation
> >   engines/libzbc: enable block backend
> >   zbd: avoid failing assertion in zbd_convert_to_open_zone()
> >   zbd: set thread errors in zbd_adjust_block()
> >   t/zbd: check for error in test #2
> >   t/zbd: add run-tests-against-nullb script
>=20
> Dmitry, thank you for posting this series. I reviewed all of your patches=
 in it.
> Overall, they are all good and I believe they worth up-streaming. One thi=
ng, I
> think the patch above needs update. Please find my comments on it in othe=
r
> mail.
>=20
> >   t/zbd: add an option to bail on a failed test
> >   t/zbd: prevent test #31 from looping
> >   t/zbd: add checks for offline zone condition
> >   t/zbd: add test #54 to exercise ZBD verification
> >   t/zbd: show elapsed time in test-zbd-support
> >   t/zbd: increase timeout in test #48
> >   t/zbd: avoid looping on invalid command line options
> >
> > Shin'ichiro Kawasaki (12):
> >   zbd: do not lock conventional zones on I/O adjustment
> >   zbd: do not set zbd handlers for conventional zones
> >   zbd: count sectors with data for write pointer zones
>=20
> Regarding my patches, you kindly reviewed them and added your SOB tags,
> except this patch above. Could you check it again?
>=20
> Thanks!
>=20
> --
> Best Regards,
> Shin'ichiro Kawasaki

