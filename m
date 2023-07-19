Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FE8EB64DA
	for <fio@archiver.kernel.org>; Wed, 19 Jul 2023 10:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjGSK6F (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 06:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjGSK6E (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 06:58:04 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E6E186
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 03:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689764283; x=1721300283;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4IaI/2d6HM6cTMsEfB3ghDBa908/yT1qttMxgDh2h2U=;
  b=VoFvosExEl/RB2+ZI6I7UBCEAKceaskYc3xS+sv+Whg4yTDxCxb/Ntlz
   rLjVyxFpc1TMUsQppEd662y3/CCtvU3/rSBx2Mv6nzEBcPx3YVfp1PHAF
   i03OkjOTlJUlfVquTXYC1godb01gpekhAu0kqpz5j7U2d9rwVJeBg9HK7
   fSnuITYykkWnH3YkfKnRRnee50wykRot9tWJDy88KLWkok8ZJAtYRs+9L
   2owXo3b3kHU4pT/2wcUwPlUhKrCRwPJWwlsZpU6ahoRQ0QhWplD1SNJvt
   dePA9ODmrYO3+5paNOzoDZGcxWwDdJKPGAZve1SlMSHcJ0+p2s5C43Fr4
   g==;
X-IronPort-AV: E=Sophos;i="6.01,216,1684771200"; 
   d="scan'208";a="236860312"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2023 18:58:00 +0800
IronPort-SDR: z69tEysgQXa6pHStwFZziLsbeBwX/V9TcusuNF/bcdcKk2bd4hVUEjF3nMPA5i0kwqe5hClzIb
 6riF4U42vAzKrVd4v1EQtFIz/gin/9kvT6ym0ZCWQ5jIYNorvTlNERtVKr4ajqmeawKAmDjiAS
 SmbUVvTiXox5/2aY6bQhwAiOx8aTmx6JZq6VzAlCehMBcb41y25LRw+/ax6lYcps3yWql514Ve
 L0/oFj5EoCcsBGUAPQLg8CKWLDwEJ8QID03KhkoFc3vpgFyUPSV6SzMkL33jeiZz1dCw/ISpW/
 5Ls=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jul 2023 03:06:09 -0700
IronPort-SDR: luXmmQD9hsugdCb/+XNZk//TMZYgId1PRVs/UVpkTF2dn9nnxYIlYq1990JseL7vDQdMnVAWA9
 gu7189RJNEGCdJwFuPBo1Tgi335mNiu3Smr413jDXZom/5T6/PBt0pTJ0n6FHh/EKhe+oTC/ku
 XRvDAu3VuFS9Uk15VJ+0fNoI63xcukuA1Q/Jyd6ocxf0Gfte5zs7Vugr0f5O/X7XBIsgz7G8r3
 WeC1EQNi+q/U8FSgD0KJz7J4rDGW0YdFomyulLyB5K3I3NC2k5iQvELPgHIu3bure/jWzpE6st
 e9o=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Jul 2023 03:57:58 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 00/13] zbd: improve max_active_zones limit handling
Date:   Wed, 19 Jul 2023 19:57:43 +0900
Message-Id: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Current fio implementation for zonemode=zbd has two problems for zoned
block devices with max_active_zones. The first problem is max_active_zones
limit error. When some of write target zones are in closed condition at fio
start, writes to other zones causes the max_active_zones limit error. The
second problem is a confusing error message. When number of active zones goes
beyond the max_active_zones limit, fio prints unrelated error message and
confuses users [1].

This series addresses the two problems. The first patch is a preparation to get
the max_active_zones value from devices. The next two patches fix the two
problems. The forth patch modifies man document of max_open_zones option to
match with the fixes. Other nine patches improve test scripts for the fixes. Add
test cases and test conditions to confirm the fixes. Also fix test script bugs
found during this work.

[1] https://lore.kernel.org/fio/ZHShQdVGkyRfd6v0@x1-carbon/T/#m4ec7ff1575981e92517c0ea7f699e7df9aba087c

Changes from v1:
* Reflected comments on the list and added Reviewed-by tags

Dmitry Fomichev (2):
  t/zbd: fix null_blk configuration in run-tests-against-nullb
  t/zbd: add max_active configs to run-tests-against-nullb

Shin'ichiro Kawasaki (11):
  zbd: get max_active_zones limit value from zoned devices
  zbd: write to closed zones on the devices with max_active_zones limit
  zbd: print max_active_zones limit error message
  docs: modify max_open_zones option description
  t/zbd: add close_zone helper function
  t/zbd: add max_active_zone variable
  t/zbd: add test case to check zones in closed condition
  t/zbd: add test case to check max_active_zones limit error message
  t/zbd: get max_open_zones from sysfs
  t/zbd: fix fio failure check and SG node failure in test case 31
  t/zbd: add missing prep_write for test cases with write workloads

 HOWTO.rst                     |  44 +++++---
 fio.1                         |  36 ++++--
 io_u.c                        |   2 +
 ioengines.h                   |   4 +-
 oslib/blkzoned.h              |   9 ++
 oslib/linux-blkzoned.c        |  23 ++++
 t/zbd/functions               |  33 +++++-
 t/zbd/run-tests-against-nullb | 203 ++++++++++++++++++++++++++++++++--
 t/zbd/test-zbd-support        |  91 ++++++++++++++-
 zbd.c                         |  47 +++++++-
 zbd.h                         |   5 +
 11 files changed, 457 insertions(+), 40 deletions(-)

-- 
2.40.1

