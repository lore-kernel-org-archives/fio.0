Return-Path: <prvs=7111401fc=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 0/2] zbd: fix zone reset for file reset during asynchronous IOs
Date: Thu, 25 Mar 2021 11:15:33 +0900
Message-Id: <20210325021535.1531333-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

Repeated random write jobs with block size unaligned to zone size and libaio
engine trigger unaligned command errors because of zone reset during
asynchronous writes in-flight. The first patch of this series addresses the
problem by removing the zone reset. The second patch adds a new test case to
confirm the problem fix and to prevent future regression.

Changes from v1:
* Changed fix approach from waiting IO completion to removing zone reset
* Simplified the added test case not to refer sysfs

Shin'ichiro Kawasaki (2):
  zbd: avoid zone reset during asynchronous IOs in-flight
  t/zbd: test repeated async write with block size unaligned to zone
    size

 t/zbd/test-zbd-support | 18 ++++++++++++++++++
 zbd.c                  | 23 +++++++----------------
 2 files changed, 25 insertions(+), 16 deletions(-)

-- 
2.29.2


