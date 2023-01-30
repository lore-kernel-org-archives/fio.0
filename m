Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FAFC05027
	for <fio@archiver.kernel.org>; Mon, 30 Jan 2023 02:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234378AbjA3C2y (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 29 Jan 2023 21:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjA3C2x (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 29 Jan 2023 21:28:53 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AC3166D3
        for <fio@vger.kernel.org>; Sun, 29 Jan 2023 18:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675045732; x=1706581732;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tFnmdO4kfkoRQ888ZzAWyol45wGh446H9CS9OFRHnU8=;
  b=Kotm7ZE2e5MciJG3d26tbYghqD8odQ0J4AVeEELDrw74ivNdSWnR3BNQ
   tAgdVHlKdcwejrkPspm0KWXmJKFZW7/qcg6q/BTX2p3RiXqRL/UPTCH1U
   loXnmlfLinlPvs1yqCLyE0kiBE2bBvJjFf2+JU+t5jnl4JbzuqGt/XYXv
   FkKx1LnVzWxhpfmORGQ1UVVKOGadkTGX49WqbWDKtZ5Ojz6G2pednPxym
   fSW5ZYPKpMkmfwemOQc78kkdKqQ7vrmMBvYXE38scoNHtYCVOl2Hb3PaN
   BYnjH8ZHR9Szg+T3NFNasAGpk/s6W039qKmK/6Z7ToEj5zLcOchcuXU/I
   w==;
X-IronPort-AV: E=Sophos;i="5.97,256,1669046400"; 
   d="scan'208";a="227010377"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jan 2023 10:28:52 +0800
IronPort-SDR: AIfKv0ChgLoWczLyklsj3ae5CZxEKEYAPOJrQUlQ/t+QLk4vc0V5EHho8u8jQs83ujJ2GxWbBe
 2ouN123U4GjwTvZcZVacJH6S3g+DnizpVntLE01IKn5FbceAi7Y6SD0D5Wwyia26A0tKeqPp5c
 ggqoSy1jWc16k9b72gp8bAx+HMJUbKoiYqaQ8ujjbvptfaXZXwM+k2M7Sts/tj0kZfwRouQd6/
 G00l7f2+uUZEpUovRQOhslG5BgPNR50E5aX0qtRttLhDsOhYJ/onvuoGqXZ6omQkToW3csuCUA
 vPc=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Jan 2023 17:40:34 -0800
IronPort-SDR: oi1rdqcSZgO3yQXPQLV52T6ls6ee/vQfEhi1/I+1QKN+ohaFoO6XFxeQvWisvln0FibPYluSEM
 bLRmglXibJIcqlnHSmavfd5UoxgjxJiHR0c0AUVExbM5xkRUd1F1grWK6xYGo8GGdUKBKEXOfQ
 X4jLUqgQw46p+Tn1AT/Lk9ErAVCQqqV57cI3bMzVrOOMMiosxbZQ9UlN5yYZrxeD/S4wMqBMPE
 9t2JtBkiwDp/sbeJzoSkNnv0pdqdZdnSVWLVWqHx8hOt/SAPhp6o1LQZ81O9CbBtHPsWj1DTn7
 zrw=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 29 Jan 2023 18:28:50 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/5] zbd: drop 'sectors with data' accounting
Date:   Mon, 30 Jan 2023 11:28:45 +0900
Message-Id: <20230130022850.1375523-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When zonemode=zbd is specified, fio does 'sectors with data' accounting to
record the total number of sectors that have been written on a zoned block
device. This accounting has two issues:

1) The current implementation counts sectors with data per job, over the IO
   range of the job. So for a workload with multiple jobs with overlapping IO
   ranges, the number of sectors with data is overestimated as written sectors
   common to multiple jobs are counted multiple times.

2) Counting the total number of written sectors requires taking the zone lock of
   all zones in a job IO range. For a multi-job workload with overlapping IO
   ranges, this often leads to significant zone lock contention, resulting in
   some jobs starting doing IOs only after other jobs have completed their work
   (which looks like an apparent deadlock on startup).

This series addresses the issues by dropping the 'sectors with data' accounting.
The accounting is used only for two features: 1) randrw first IO direction
decision and 2) zone_reset_threshold ratio check. The first two patches modify
these two features to not rely on the 'sectors with data' accounting. The third
patch drops the 'sectors with data' accounting. The last two patches adjust test
cases and an fio example script for the zone_reset_threshold.

Shin'ichiro Kawasaki (5):
  zbd: refer file->last_start[] instead of sectors with data accounting
  zbd: calculate zone_reset_threshold ratio for device
  zbd: remove sectors with data accounting feature
  t/zbd: adjust test cases to zone_reset_threshold change
  example: adjust example to zone_reset_threshold change

 HOWTO.rst                                 |   7 +-
 examples/zbd-rand-write-zone-reset-gc.fio |  20 ++---
 examples/zbd-rand-write-zone-reset-gc.png | Bin 59186 -> 62974 bytes
 fio.1                                     |   7 +-
 t/zbd/test-zbd-support                    |  66 +++++++++++------
 zbd.c                                     |  85 +++-------------------
 zbd.h                                     |  10 +--
 7 files changed, 79 insertions(+), 116 deletions(-)

-- 
2.38.1

