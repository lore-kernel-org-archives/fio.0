Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40506 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfEUXT3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 May 2019 19:19:29 -0400
Received: by mail-pf1-f193.google.com with SMTP id u17so234750pfn.7
        for <fio@vger.kernel.org>; Tue, 21 May 2019 16:19:28 -0700 (PDT)
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [RFC] fio-tests: add framework to build fio tests dynamically
Date: Tue, 21 May 2019 23:19:18 +0000
Message-Id: <20190521231918.13361-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: andrey.o.kudryavtsev@intel.com, Luis Chamberlain <mcgrof@kernel.org>

fio is very flexible, but writing configuration files can often be an error
prone process. When you design a test you may also decide that you'd like
to tests different read/write target profiles, using different parameters.
Editing fio files to account for different profiles can also be error prone.

fio-tests aims towards helping with these complexities by letting you
configure a DUT using a variability modeling language (kconfig), and
using a set of basic core templates which are used to generate target
tests.

With this model we are currently able to generate 753 tests using only
4 basic core template input files for fio as base.

This also adds some basic graphing generation support for results, and
a few demo results and intepretations which can be used as guidance.

fio-tests can used to test performance, but it can also be used to
provision target storage devices with target pre-conditioning for NAND
storage drives. also adds a two pre-conditioning methods:

  * SNIA IOPS interpretion as per SSS PTS Version 2.0.1
  * Santa Clara method

Certain new non-NAND drives don't require pre-conditioning, however
they may require energized state form of pre-conditioning, this is
also currently supported, refer to CONFIG_ENERGIZED_STEADY_STATE.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---

Since this patch is large I figured it'd be best to just just refer to
the branch on github and new respective documentaiton [0] so folks could
get an idea of what is being proposed first, and if we *do* want this
on fio upstream then I can break it down.

I have reviewed a series of projects with different collections of fio
tests and was not happy how error prone they were and the lack of
variablity on them. If its preferred to host this as a standalone
project I may need a bit of help with that, contact me for details,
if interested in helping with that.

I figured SNIA folks may prefer to not call the SNIA IOPS test the SNIA
IOPS test, for trademark or marketing reasons, or whatever, so to be
sure that its *my interpretation* I've called it The Buddy Holly test.

[0] https://github.com/mcgrof/fio/tree/20190521-fio-tests/tests

 tests/.gitignore                              |   29 +
 tests/Kconfig                                 |   28 +
 tests/Makefile                                |   72 +
 tests/Provisioning.md                         |  445 ++++++
 tests/README.md                               |  625 ++++++++
 tests/TODO                                    |   67 +
 tests/arch/x86/defconfig                      |  115 ++
 tests/contrib/provision_all.sh                |  232 +++
 tests/defconfigs/prov_sc_random               |   12 +
 tests/defconfigs/prov_sc_seq                  |   12 +
 .../0005-maxiobatch-randwrite-70-30-bwr.svg   |  409 +++++
 .../0005-maxiobatch-randwrite-70-30-bww.svg   |  396 +++++
 .../0005-maxiobatch-randwrite-70-30-clatr.svg |  357 +++++
 .../0005-maxiobatch-randwrite-70-30-clatw.svg |  344 +++++
 .../0005-maxiobatch-randwrite-70-30-iopsr.svg |  344 +++++
 .../0005-maxiobatch-randwrite-70-30-iopsw.svg |  357 +++++
 .../0001-256qd-randrw-bwr.svg                 |  346 +++++
 .../0001-256qd-randrw-bww.svg                 |  333 ++++
 .../0001-256qd-randrw-clatr.svg               |  359 +++++
 .../0001-256qd-randrw-clatw.svg               |  359 +++++
 .../0001-256qd-randrw-iopsr.svg               |  346 +++++
 .../0001-256qd-randrw-iopsw.svg               |  346 +++++
 .../0002-512qd-randrw-bwr.svg                 |  346 +++++
 .../0002-512qd-randrw-bww.svg                 |  333 ++++
 .../0002-512qd-randrw-clatr.svg               |  346 +++++
 .../0002-512qd-randrw-clatw.svg               |  346 +++++
 .../0002-512qd-randrw-iopsr.svg               |  346 +++++
 .../0002-512qd-randrw-iopsw.svg               |  346 +++++
 .../0003-1024qd-randrw-bwr.svg                |  346 +++++
 .../0003-1024qd-randrw-bww.svg                |  333 ++++
 .../0003-1024qd-randrw-clatr.svg              |  372 +++++
 .../0003-1024qd-randrw-clatw.svg              |  372 +++++
 .../0003-1024qd-randrw-iopsr.svg              |  346 +++++
 .../0003-1024qd-randrw-iopsw.svg              |  346 +++++
 .../0004-2048qd-randrw-bwr.svg                |  346 +++++
 .../0004-2048qd-randrw-bww.svg                |  333 ++++
 .../0004-2048qd-randrw-clatr.svg              |  372 +++++
 .../0004-2048qd-randrw-clatw.svg              |  372 +++++
 .../0004-2048qd-randrw-iopsr.svg              |  346 +++++
 .../0004-2048qd-randrw-iopsw.svg              |  346 +++++
 .../0005-4096qd-randrw-bwr.svg                |  346 +++++
 .../0005-4096qd-randrw-bww.svg                |  333 ++++
 .../0005-4096qd-randrw-clatr.svg              |  359 +++++
 .../0005-4096qd-randrw-clatw.svg              |  359 +++++
 .../0005-4096qd-randrw-iopsr.svg              |  346 +++++
 .../0005-4096qd-randrw-iopsw.svg              |  346 +++++
 tests/pre-conditioning/Makefile               |   28 +
 tests/scripts/Kbuild.include                  |   66 +
 tests/scripts/Kconfig.debug                   |   24 +
 tests/scripts/Kconfig.debug.quick             |  109 ++
 tests/scripts/Kconfig.dut                     |  378 +++++
 tests/scripts/Kconfig.pre-condition           |   82 +
 tests/scripts/Kconfig.purge                   |  242 +++
 tests/scripts/Kconfig.santa_clara             |  274 ++++
 tests/scripts/Kconfig.steady-state            |   70 +
 tests/scripts/build.Makefile                  |   50 +
 tests/scripts/gen-fio-files.sh                |  600 ++++++++
 tests/scripts/gen-graph.sh                    |  955 ++++++++++++
 tests/scripts/gen-pre-condition.sh            |  225 +++
 tests/scripts/gen-sheet.sh                    |  195 +++
 tests/scripts/json2res                        |   91 ++
 tests/scripts/kconfig.Makefile                |   48 +
 tests/scripts/kconfig/.gitignore              |   22 +
 tests/scripts/kconfig/Makefile                |   43 +
 tests/scripts/kconfig/conf.c                  |  722 +++++++++
 tests/scripts/kconfig/confdata.c              | 1322 ++++++++++++++++
 tests/scripts/kconfig/expr.c                  | 1305 ++++++++++++++++
 tests/scripts/kconfig/expr.h                  |  331 ++++
 tests/scripts/kconfig/kconf_id.c              |   52 +
 tests/scripts/kconfig/list.h                  |  132 ++
 tests/scripts/kconfig/lkc.h                   |  169 +++
 tests/scripts/kconfig/lkc_proto.h             |   66 +
 tests/scripts/kconfig/lxdialog/.gitignore     |    4 +
 .../scripts/kconfig/lxdialog/BIG.FAT.WARNING  |    4 +
 tests/scripts/kconfig/lxdialog/checklist.c    |  332 ++++
 tests/scripts/kconfig/lxdialog/dialog.h       |  251 ++++
 tests/scripts/kconfig/lxdialog/inputbox.c     |  301 ++++
 tests/scripts/kconfig/lxdialog/menubox.c      |  437 ++++++
 tests/scripts/kconfig/lxdialog/textbox.c      |  408 +++++
 tests/scripts/kconfig/lxdialog/util.c         |  713 +++++++++
 tests/scripts/kconfig/lxdialog/yesno.c        |  114 ++
 tests/scripts/kconfig/mconf-cfg.sh            |   47 +
 tests/scripts/kconfig/mconf.c                 | 1039 +++++++++++++
 tests/scripts/kconfig/menu.c                  |  870 +++++++++++
 tests/scripts/kconfig/preprocess.c            |  572 +++++++
 tests/scripts/kconfig/symbol.c                | 1334 +++++++++++++++++
 tests/scripts/kconfig/util.c                  |  130 ++
 tests/scripts/kconfig/zconf.l                 |  455 ++++++
 tests/scripts/kconfig/zconf.y                 |  790 ++++++++++
 tests/scripts/lib.sh                          |  572 +++++++
 tests/scripts/noconfig-lib.sh                 |   43 +
 tests/scripts/objects.Makefile                |   83 +
 tests/scripts/run-all-fio.sh                  | 1046 +++++++++++++
 tests/scripts/run-fio.sh                      |  241 +++
 tests/scripts/setlocalversion                 |  117 ++
 tests/templates/0001-basic-template.ini.in    |   29 +
 .../0001-pre-condition-sequential.ini.in      |    1 +
 .../prefill/0002-pre-condition-random.ini.in  |   23 +
 ...-workload-independent-pre-condition.ini.in |   22 +
 ...02-workload-dependent-pre-condition.ini.in |   35 +
 .../steady-state/0001-steady-state.ini.in     |    1 +
 tests/tests-demo-results.tar.xz               |  Bin 0 -> 203392 bytes
 .../0001-basic-tests/0001-seqwrite/Makefile   |   37 +
 .../0001-basic-tests/0002-seqread/Makefile    |   37 +
 .../0001-basic-tests/0003-randwrite/Makefile  |   37 +
 .../0001-basic-tests/0004-randread/Makefile   |   37 +
 .../0005-randwrite-70-30/Makefile             |   38 +
 .../0006-randwrite-97-3/Makefile              |   38 +
 tests/tests/0001-basic-tests/Kconfig          |    7 +
 tests/tests/0001-basic-tests/Makefile         |   28 +
 .../0002-iobatch/0001-iobatch-write/Makefile  |   44 +
 .../0002-iobatch/0002-iobatch-read/Makefile   |   43 +
 .../0003-iobatch-randwrite/Makefile           |   44 +
 .../0004-iobatch-randread/Makefile            |   44 +
 .../0005-iobatch-randwrite-70-30/Makefile     |   45 +
 .../0006-iobatch-randwrite-97-3/Makefile      |   45 +
 tests/tests/0002-iobatch/Kconfig              |   12 +
 tests/tests/0002-iobatch/Makefile             |   28 +
 .../0001-maxiobatch-write/Makefile            |   41 +
 .../0002-maxiobatch-read/Makefile             |   41 +
 .../0003-maxiobatch-randwrite/Makefile        |   41 +
 .../0004-maxiobatch-randread/Makefile         |   41 +
 .../0005-maxiobatch-randwrite-70-30/Makefile  |   42 +
 .../0006-maxiobatch-randwrite-97-3/Makefile   |   42 +
 .../tests/0003-maxiobatch-single-job/Kconfig  |    8 +
 .../tests/0003-maxiobatch-single-job/Makefile |   28 +
 .../0001-maxiobatch-write/Makefile            |   44 +
 .../0002-maxiobatch-read/Makefile             |   44 +
 .../0003-maxiobatch-randwrite/Makefile        |   44 +
 .../0004-maxiobatch-randread/Makefile         |   44 +
 .../0005-maxiobatch-randwrite-70-30/Makefile  |   45 +
 .../0006-maxiobatch-randwrite-97-3/Makefile   |   45 +
 tests/tests/0004-maxiobatch-jobs/Kconfig      |   10 +
 tests/tests/0004-maxiobatch-jobs/Makefile     |   28 +
 tests/tests/0005-snia/0001-iops/Kconfig       |  180 +++
 tests/tests/0005-snia/0001-iops/Makefile      |   58 +
 tests/tests/0005-snia/Kconfig                 |   62 +
 tests/tests/0005-snia/Makefile                |   25 +
 tests/tests/Kconfig                           |   48 +
 tests/tests/Makefile                          |   26 +
 140 files changed, 33481 insertions(+)
 create mode 100644 tests/.gitignore
 create mode 100644 tests/Kconfig
 create mode 100644 tests/Makefile
 create mode 100644 tests/Provisioning.md
 create mode 100644 tests/README.md
 create mode 100644 tests/TODO
 create mode 100644 tests/arch/x86/defconfig
 create mode 100755 tests/contrib/provision_all.sh
 create mode 100644 tests/defconfigs/prov_sc_random
 create mode 100644 tests/defconfigs/prov_sc_seq
 create mode 100644 tests/images/20181019/0003-maxiobatch-single-job/0005-maxiobatch-randwrite-70-30-bwr.svg
 create mode 100644 tests/images/20181019/0003-maxiobatch-single-job/0005-maxiobatch-randwrite-70-30-bww.svg
 create mode 100644 tests/images/20181019/0003-maxiobatch-single-job/0005-maxiobatch-randwrite-70-30-clatr.svg
 create mode 100644 tests/images/20181019/0003-maxiobatch-single-job/0005-maxiobatch-randwrite-70-30-clatw.svg
 create mode 100644 tests/images/20181019/0003-maxiobatch-single-job/0005-maxiobatch-randwrite-70-30-iopsr.svg
 create mode 100644 tests/images/20181019/0003-maxiobatch-single-job/0005-maxiobatch-randwrite-70-30-iopsw.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0001-256qd-randrw-bwr.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0001-256qd-randrw-bww.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0001-256qd-randrw-clatr.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0001-256qd-randrw-clatw.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0001-256qd-randrw-iopsr.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0001-256qd-randrw-iopsw.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0002-512qd-randrw-bwr.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0002-512qd-randrw-bww.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0002-512qd-randrw-clatr.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0002-512qd-randrw-clatw.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0002-512qd-randrw-iopsr.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0002-512qd-randrw-iopsw.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0003-1024qd-randrw-bwr.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0003-1024qd-randrw-bww.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0003-1024qd-randrw-clatr.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0003-1024qd-randrw-clatw.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0003-1024qd-randrw-iopsr.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0003-1024qd-randrw-iopsw.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0004-2048qd-randrw-bwr.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0004-2048qd-randrw-bww.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0004-2048qd-randrw-clatr.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0004-2048qd-randrw-clatw.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0004-2048qd-randrw-iopsr.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0004-2048qd-randrw-iopsw.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0005-4096qd-randrw-bwr.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0005-4096qd-randrw-bww.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0005-4096qd-randrw-clatr.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0005-4096qd-randrw-clatw.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0005-4096qd-randrw-iopsr.svg
 create mode 100644 tests/images/20181019/0004-maxiobatch-randread/0005-4096qd-randrw-iopsw.svg
 create mode 100644 tests/pre-conditioning/Makefile
 create mode 100644 tests/scripts/Kbuild.include
 create mode 100644 tests/scripts/Kconfig.debug
 create mode 100644 tests/scripts/Kconfig.debug.quick
 create mode 100644 tests/scripts/Kconfig.dut
 create mode 100644 tests/scripts/Kconfig.pre-condition
 create mode 100644 tests/scripts/Kconfig.purge
 create mode 100644 tests/scripts/Kconfig.santa_clara
 create mode 100644 tests/scripts/Kconfig.steady-state
 create mode 100644 tests/scripts/build.Makefile
 create mode 100755 tests/scripts/gen-fio-files.sh
 create mode 100755 tests/scripts/gen-graph.sh
 create mode 100755 tests/scripts/gen-pre-condition.sh
 create mode 100755 tests/scripts/gen-sheet.sh
 create mode 100755 tests/scripts/json2res
 create mode 100644 tests/scripts/kconfig.Makefile
 create mode 100644 tests/scripts/kconfig/.gitignore
 create mode 100644 tests/scripts/kconfig/Makefile
 create mode 100644 tests/scripts/kconfig/conf.c
 create mode 100644 tests/scripts/kconfig/confdata.c
 create mode 100644 tests/scripts/kconfig/expr.c
 create mode 100644 tests/scripts/kconfig/expr.h
 create mode 100644 tests/scripts/kconfig/kconf_id.c
 create mode 100644 tests/scripts/kconfig/list.h
 create mode 100644 tests/scripts/kconfig/lkc.h
 create mode 100644 tests/scripts/kconfig/lkc_proto.h
 create mode 100644 tests/scripts/kconfig/lxdialog/.gitignore
 create mode 100644 tests/scripts/kconfig/lxdialog/BIG.FAT.WARNING
 create mode 100644 tests/scripts/kconfig/lxdialog/checklist.c
 create mode 100644 tests/scripts/kconfig/lxdialog/dialog.h
 create mode 100644 tests/scripts/kconfig/lxdialog/inputbox.c
 create mode 100644 tests/scripts/kconfig/lxdialog/menubox.c
 create mode 100644 tests/scripts/kconfig/lxdialog/textbox.c
 create mode 100644 tests/scripts/kconfig/lxdialog/util.c
 create mode 100644 tests/scripts/kconfig/lxdialog/yesno.c
 create mode 100755 tests/scripts/kconfig/mconf-cfg.sh
 create mode 100644 tests/scripts/kconfig/mconf.c
 create mode 100644 tests/scripts/kconfig/menu.c
 create mode 100644 tests/scripts/kconfig/preprocess.c
 create mode 100644 tests/scripts/kconfig/symbol.c
 create mode 100644 tests/scripts/kconfig/util.c
 create mode 100644 tests/scripts/kconfig/zconf.l
 create mode 100644 tests/scripts/kconfig/zconf.y
 create mode 100644 tests/scripts/lib.sh
 create mode 100644 tests/scripts/noconfig-lib.sh
 create mode 100644 tests/scripts/objects.Makefile
 create mode 100755 tests/scripts/run-all-fio.sh
 create mode 100755 tests/scripts/run-fio.sh
 create mode 100755 tests/scripts/setlocalversion
 create mode 100644 tests/templates/0001-basic-template.ini.in
 create mode 120000 tests/templates/pre-condition/prefill/0001-pre-condition-sequential.ini.in
 create mode 100644 tests/templates/pre-condition/prefill/0002-pre-condition-random.ini.in
 create mode 100644 tests/templates/pre-condition/snia/0001-workload-independent-pre-condition.ini.in
 create mode 100644 tests/templates/pre-condition/snia/0002-workload-dependent-pre-condition.ini.in
 create mode 120000 tests/templates/pre-condition/steady-state/0001-steady-state.ini.in
 create mode 100644 tests/tests-demo-results.tar.xz
 create mode 100644 tests/tests/0001-basic-tests/0001-seqwrite/Makefile
 create mode 100644 tests/tests/0001-basic-tests/0002-seqread/Makefile
 create mode 100644 tests/tests/0001-basic-tests/0003-randwrite/Makefile
 create mode 100644 tests/tests/0001-basic-tests/0004-randread/Makefile
 create mode 100644 tests/tests/0001-basic-tests/0005-randwrite-70-30/Makefile
 create mode 100644 tests/tests/0001-basic-tests/0006-randwrite-97-3/Makefile
 create mode 100644 tests/tests/0001-basic-tests/Kconfig
 create mode 100644 tests/tests/0001-basic-tests/Makefile
 create mode 100644 tests/tests/0002-iobatch/0001-iobatch-write/Makefile
 create mode 100644 tests/tests/0002-iobatch/0002-iobatch-read/Makefile
 create mode 100644 tests/tests/0002-iobatch/0003-iobatch-randwrite/Makefile
 create mode 100644 tests/tests/0002-iobatch/0004-iobatch-randread/Makefile
 create mode 100644 tests/tests/0002-iobatch/0005-iobatch-randwrite-70-30/Makefile
 create mode 100644 tests/tests/0002-iobatch/0006-iobatch-randwrite-97-3/Makefile
 create mode 100644 tests/tests/0002-iobatch/Kconfig
 create mode 100644 tests/tests/0002-iobatch/Makefile
 create mode 100644 tests/tests/0003-maxiobatch-single-job/0001-maxiobatch-write/Makefile
 create mode 100644 tests/tests/0003-maxiobatch-single-job/0002-maxiobatch-read/Makefile
 create mode 100644 tests/tests/0003-maxiobatch-single-job/0003-maxiobatch-randwrite/Makefile
 create mode 100644 tests/tests/0003-maxiobatch-single-job/0004-maxiobatch-randread/Makefile
 create mode 100644 tests/tests/0003-maxiobatch-single-job/0005-maxiobatch-randwrite-70-30/Makefile
 create mode 100644 tests/tests/0003-maxiobatch-single-job/0006-maxiobatch-randwrite-97-3/Makefile
 create mode 100644 tests/tests/0003-maxiobatch-single-job/Kconfig
 create mode 100644 tests/tests/0003-maxiobatch-single-job/Makefile
 create mode 100644 tests/tests/0004-maxiobatch-jobs/0001-maxiobatch-write/Makefile
 create mode 100644 tests/tests/0004-maxiobatch-jobs/0002-maxiobatch-read/Makefile
 create mode 100644 tests/tests/0004-maxiobatch-jobs/0003-maxiobatch-randwrite/Makefile
 create mode 100644 tests/tests/0004-maxiobatch-jobs/0004-maxiobatch-randread/Makefile
 create mode 100644 tests/tests/0004-maxiobatch-jobs/0005-maxiobatch-randwrite-70-30/Makefile
 create mode 100644 tests/tests/0004-maxiobatch-jobs/0006-maxiobatch-randwrite-97-3/Makefile
 create mode 100644 tests/tests/0004-maxiobatch-jobs/Kconfig
 create mode 100644 tests/tests/0004-maxiobatch-jobs/Makefile
 create mode 100644 tests/tests/0005-snia/0001-iops/Kconfig
 create mode 100644 tests/tests/0005-snia/0001-iops/Makefile
 create mode 100644 tests/tests/0005-snia/Kconfig
 create mode 100644 tests/tests/0005-snia/Makefile
 create mode 100644 tests/tests/Kconfig
 create mode 100644 tests/tests/Makefile


