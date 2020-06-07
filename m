Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/5] Switch to Python3
Date: Sun,  7 Jun 2020 12:10:59 -0700
Message-Id: <20200607191104.17550-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Sitsofe Wheeler <sitsofe@yahoo.com>, Vincent Fu <vincent.fu@wdc.com>, Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

Hi Jens,

Since Python2 is in maintenance mode, this patch series converts the fio
test scripts to Python3. Please consider this patch series for inclusion
in the upstream fio repository. Thanks to Sitsofe Wheeler and Vincent Fu
for the help with reviewing this series. See also
https://github.com/axboe/fio/pull/1002.

Thanks,

Bart.

Bart Van Assche (4):
  .travis.yml: Move shell code out of .travis.yml
  ci/travis-install.sh: Install python3-six package
  Switch to Python3
  t/run-fio-tests.py: Accept a wider range of IOPS values

Vincent Fu (1):
  ci/travis-install.sh, MacOS: Install the Python 'six' package

 .travis.yml                         | 28 ++----------------
 ci/travis-build.sh                  | 16 +++++++++++
 ci/travis-install.sh                | 44 +++++++++++++++++++++++++++++
 t/run-fio-tests.py                  |  2 +-
 t/sgunmap-perf.py                   |  2 +-
 t/sgunmap-test.py                   |  2 +-
 tools/fio_jsonplus_clat2csv         |  2 +-
 tools/fiologparser.py               |  3 +-
 tools/hist/fio-histo-log-pctiles.py |  5 ++--
 tools/hist/fiologparser_hist.py     | 11 +++-----
 tools/hist/half-bins.py             |  2 +-
 tools/plot/fio2gnuplot              |  2 +-
 12 files changed, 78 insertions(+), 41 deletions(-)
 create mode 100755 ci/travis-build.sh
 create mode 100755 ci/travis-install.sh


