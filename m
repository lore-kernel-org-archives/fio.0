Return-Path: <fio-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:60213 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgHME50 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 Aug 2020 00:57:26 -0400
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/6] Improve open zones accounting
Date: Thu, 13 Aug 2020 13:57:18 +0900
Message-Id: <20200813045724.47475-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>

The max_open_zones and job_max_open_zones option control number of write target
open zones within the specified limit. Currently, this write target zone
accounting is not accurate enough. Even with these options set, the limits can
exceed during write workloads.

This patch series improves accuracy of the open zones accounting. The first
patch moves the moment to decrement number of currently open zones from write
command submit to write command completion. This avoids zone writes beyond the
limit caused by concurrent write commands at queue depths approaching the max
limits. The second patch fixes the open zone status initialization issue. Other
following patches improve t/zbd scripts to take maximum write target zone limit
and allow to test devices with the limit.

Shin'ichiro Kawasaki (6):
  zbd: Decrement open zones count at write command completion
  zbd: Initialize open zones list referring zone status at fio start
  t/zbd: Improve usage message of test-zbd-support script
  t/zbd: Add -o option to t/zbd/test-zoned-support
  t/zbd: Reset all zones before test when max open zones is specified
  t/zbd: Remove unnecessary option for zbc_reset_zone

 io_u.c                 |   4 +-
 io_u.h                 |   5 +-
 ioengines.c            |   4 +-
 t/zbd/functions        |   2 +-
 t/zbd/test-zbd-support | 124 +++++++++++++++++++++++++++++++++++------
 zbd.c                  | 113 ++++++++++++++++++++++++++++---------
 zbd.h                  |   9 +--
 7 files changed, 208 insertions(+), 53 deletions(-)

-- 
2.26.2


