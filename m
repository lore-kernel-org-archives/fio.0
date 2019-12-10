Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 0/9] testing patches
Date: Tue, 10 Dec 2019 12:54:33 -0500
Message-Id: <20191210175442.2975-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Jens, please consider this series of patches related to testing.

The patches improve t/run-fio-tests.py in various ways, most prominently
adding support for Windows and macOS.

Also included are travis and appveyor patches that add run-fio-tests.py
as a step.  Currently both the travis and appveyor build processes
complete in less than four minutes.  Adding run-fio-tests.py increases
this to about 20 minutes for travis and 14 minutes for appveyor. 

Also worth noting is that sometimes the VMs these builds run on appear
to become overloaded and produce false failures. For instance, builds on
the same hash fail here

https://ci.appveyor.com/project/vincentkfu/fio/builds/29342164

but succeed here

https://ci.appveyor.com/project/vincentkfu/fio/builds/29344271

The failure occured because of a timeout running a null ioengine job that
reads 10G of data.

It's certainly nice to have these tests automatically run with every
commit, but the downside is that the build process is significantly
lengthened and some noise is introduced.


Vincent Fu (9):
  .gitignore: ignore zbd test output files
  t/run-fio-tests: a few small improvements
  t/run-fio-tests: detect requirements and skip tests accordingly
  t/run-fio-tests: improve Windows support
  t/run-fio-tests: identify test id for debug messages
  t/steadystate_tests: use null ioengine for tests
  .travis.yml: run t/run-fio.tests.py as part of build
  .appveyor.yml: run run-fio-tests.py
  t/run-fio-tests: relax acceptance criterion for t0011

 .appveyor.yml          |   6 +-
 .gitignore             |   1 +
 .travis.yml            |  26 ++---
 t/run-fio-tests.py     | 219 ++++++++++++++++++++++++++++++++++++-----
 t/steadystate_tests.py |  21 +---
 5 files changed, 219 insertions(+), 54 deletions(-)

-- 
2.17.1


