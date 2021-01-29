Return-Path: <prvs=6568a101b=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v4 00/38] ZBD fixes and improvements
Date: Fri, 29 Jan 2021 00:03:12 +0000
Message-ID: 
 <BL0PR04MB65145865B647371B1B31E826E7B99@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <Naohiro.Aota@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2021/01/27 13:19, Dmitry Fomichev wrote:=0A=
> Jens,=0A=
> =0A=
> This series has gone through a few iterations without raising any major=
=0A=
> objections and this version only includes cosmetic changes (see below).=
=0A=
> Please consider applying this series to fio master branch.=0A=
=0A=
Jens,=0A=
=0A=
Could you pick this up please ? This fixes a few bugs that we are seeing in=
 the=0A=
field. And the tests are improved too for us to run weekly on each kernel r=
c.=0A=
=0A=
Thanks !=0A=
=0A=
=0A=
> =0A=
> Best regards,=0A=
> Dmitry=0A=
> =0A=
> v3 -> v4:=0A=
> =0A=
>  - address Shinichiro's review feedback:=0A=
>    * make style improvements in t/zbd/run-tests-against-nullb.=0A=
>    * correct naming of one of test sections in the same script.=0A=
>    * improve commit message in "zbd: improve replay range validation"=0A=
>      patch.=0A=
>  - add Reviewed-by and Signed-off annotations.=0A=
> =0A=
> v2 -> v3:=0A=
> =0A=
>  - fix two libzbc-related bugs in test scripts (found by Shinichiro).=0A=
>  - modify libzbc ioengine code to allow fio to operate successfully=0A=
>    against null_blk devices while using this ioengine.=0A=
>  - add -l option to run-tests-against-nullb script to allow running=0A=
>    the tests while using libzbc ioengine.=0A=
>  - add -n option to run-tests-against-nullb to allow running the=0A=
>    specified tests multiple times. This option is the most useful=0A=
>    in combination with the existing -s and -t options.=0A=
>  - fix sporadic failed assertion in test #51 that is easily triggered=0A=
>    by running run-tests-against-nullb script with -l and -n options.=0A=
>  - make minor coding style improvements in run-tests-against-nullb.=0A=
> =0A=
> v1 -> v2:=0A=
> =0A=
>  - replace both run-tests-against-conventional-nullb and =0A=
>    run-tests-against-conventional-nullb with a single script,=0A=
>    run-tests-against-nullb, that runs test-zbd-support unit tests=0A=
>    over a variety on different zoned configurations.=0A=
>  - add five new test cases to test-zbd-support to cover the code=0A=
>    changes made in zbd.c as a part of this series.=0A=
>  - mark all test cases in test-zbd-support script that are not=0A=
>    applicable for the device configuration as SKIP instead of=0A=
>    reporting them as passed.=0A=
>  - properly handle writes to conventional zones that cross over=0A=
>    to sequential zones.=0A=
>  - make additional improvements in zone locking parts of zbd.c.=0A=
>  - implement miscellaneous test script enhancements.=0A=
> =0A=
> This patch series contains bug fixes and refactoring changes=0A=
> related to support for Zoned Block Devices (ZBD) in fio.=0A=
> The highlights:=0A=
> =0A=
>  - fix several errors related to running workloads that span=0A=
>    a mix of conventional zones and write pointer zones.=0A=
>  - improve counting of sectors with data (SWD).=0A=
>  - remove dependencies on particular zone types in the code.=0A=
>  - add code to gracefully handle offline zones.=0A=
> =0A=
> Aravind Ramesh (1):=0A=
>   zbd: initialize sectors with data at start time=0A=
> =0A=
> Dmitry Fomichev (25):=0A=
>   zbd: return ENOMEM if zone buffer allocation fails=0A=
>   zbd: use zbd_zone_nr() more actively in the code=0A=
>   zbd: add get_zone() helper function=0A=
>   zbd: introduce zone_unlock()=0A=
>   zbd: engines/libzbc: don't fail on assert for offline zones=0A=
>   zbd: remove dependency on zone type during i/o=0A=
>   zbd: skip offline zones in zbd_convert_to_open_zone()=0A=
>   zbd: avoid zone buffer overrun=0A=
>   zbd: don't unlock zone mutex after verify replay=0A=
>   zbd: use zone_lock() in zbd_process_swd()=0A=
>   zbd: don't log "zone nnnn is not open" message=0A=
>   zbd: handle conventional start zone in zbd_convert_to_open_zone()=0A=
>   zbd: improve replay range validation=0A=
>   engines/libzbc: enable block backend=0A=
>   zbd: avoid failing assertion in zbd_convert_to_open_zone()=0A=
>   zbd: set thread errors in zbd_adjust_block()=0A=
>   t/zbd: check for error in test #2=0A=
>   t/zbd: add run-tests-against-nullb script=0A=
>   t/zbd: add an option to bail on a failed test=0A=
>   t/zbd: prevent test #31 from looping=0A=
>   t/zbd: add checks for offline zone condition=0A=
>   t/zbd: add test #54 to exercise ZBD verification=0A=
>   t/zbd: show elapsed time in test-zbd-support=0A=
>   t/zbd: increase timeout in test #48=0A=
>   t/zbd: avoid looping on invalid command line options=0A=
> =0A=
> Shin'ichiro Kawasaki (12):=0A=
>   zbd: do not lock conventional zones on I/O adjustment=0A=
>   zbd: do not set zbd handlers for conventional zones=0A=
>   zbd: count sectors with data for write pointer zones=0A=
>   zbd: initialize min_zone and max_zone for all zone types=0A=
>   zbd: disable crossing from conventional to sequential zones=0A=
>   t/zbd: add -t option to run-tests-against-nullb=0A=
>   t/zbd: skip tests when test prerequisites are not met=0A=
>   t/zbd: skip tests that need too many sequential zones=0A=
>   t/zbd: test that conventional zones are not locked during random i/o=0A=
>   t/zbd: test that zone_reset_threshold calculation is correct=0A=
>   t/zbd: test random I/O direction in all-conventional case=0A=
>   t/zbd: fix wrong units in test case #37=0A=
> =0A=
>  Makefile                              |   5 +-=0A=
>  engines/libzbc.c                      |   5 +-=0A=
>  oslib/linux-blkzoned.c                |   2 +-=0A=
>  t/run-fio-tests.py                    |   8 +-=0A=
>  t/zbd/functions                       |  56 +++-=0A=
>  t/zbd/run-tests-against-nullb         | 354 +++++++++++++++++++++++++=0A=
>  t/zbd/run-tests-against-regular-nullb |  27 --=0A=
>  t/zbd/run-tests-against-zoned-nullb   |  53 ----=0A=
>  t/zbd/test-zbd-support                | 301 +++++++++++++++++++---=0A=
>  zbd.c                                 | 357 ++++++++++++++++----------=
=0A=
>  zbd.h                                 |   5 +=0A=
>  11 files changed, 912 insertions(+), 261 deletions(-)=0A=
>  create mode 100755 t/zbd/run-tests-against-nullb=0A=
>  delete mode 100755 t/zbd/run-tests-against-regular-nullb=0A=
>  delete mode 100755 t/zbd/run-tests-against-zoned-nullb=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

