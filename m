Return-Path: <prvs=7094d7b7f=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/2] zbd: fix zone reset during asynchronous IOs
Date: Tue, 23 Mar 2021 10:13:22 +0900
Message-Id: <20210323011324.1365343-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

Repeated random write jobs to zones with libaio engine trigger unaligned command
errors because of zone resets for file reset during asynchronous writes in-
flight. The first patch of this series addresses the problem by waiting the
asynchronous IOs to complete before zone reset. The second patch adds a new test
case to confirm the problem fix and to prevent future regression.

Shin'ichiro Kawasaki (2):
  zbd: avoid zone reset for file reset during asynchronous IOs in-flight
  t/zbd: test repeated async write to sequential write required zones

 t/zbd/functions        | 12 ++++++++++++
 t/zbd/test-zbd-support | 18 ++++++++++++++++++
 zbd.c                  |  7 +++++++
 3 files changed, 37 insertions(+)

-- 
2.29.2


