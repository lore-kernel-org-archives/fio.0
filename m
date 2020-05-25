Return-Path: <prvs=407053df0=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 0/4] zbd: clean up libzbc ioengine and tests
Date: Tue, 26 May 2020 06:32:52 +0900
Message-Id: <20200525213256.7476-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

This series makes a few minor, but IMO useful changes in libzbc
ioengine and ZBD test script.

Dmitry Fomichev (4):
  libzbc: cleanup init code
  libzbc: fix whitespace errors
  t/zbd: beautify test script output
  t/zbd: make the test script easier to terminate

 engines/libzbc.c       | 33 +++++++++++++++++----------------
 t/zbd/test-zbd-support | 20 ++++++++++++++++++--
 2 files changed, 35 insertions(+), 18 deletions(-)

-- 
2.21.0


