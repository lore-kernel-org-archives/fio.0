Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 198ACC433FE
	for <fio@archiver.kernel.org>; Fri, 21 Oct 2022 06:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiJUGeX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Oct 2022 02:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiJUGeW (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Oct 2022 02:34:22 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0C6F39
        for <fio@vger.kernel.org>; Thu, 20 Oct 2022 23:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666334059; x=1697870059;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=st0ZvyxqRaBXfzI30RWYnIt/M5+1ocuRiAZFf+Gg/2c=;
  b=fMM39sdxAR3VEr/Qpdbrj1cVmunEHVHRrolpzqu6QqNtx22rQZvWH+y2
   KK/b/o1M2qmvZx9pKcFZOE7FXsjrKARmRzd1Z5gwxyS+llutTpFBJpEyu
   C6ZQLdwsJhjo3udM2OrQ4IJFr2/5C8WzdN63Y3tdMXRji9kEtlj7U27pI
   /yDmSvekUnLM6B/IslkoEqvS48PGA2fZovsSHtBvpJrMcmIbd2zmby/tb
   HjDPJXjNza5+oLdokUXs2AP7KF23PtX/mGlf0v+PI5YUoqrqA5DxjlZAf
   DWLTbMSSlxoqq41SesGEFcD7+2+9pHDCtGt5UmI6bklsMHyf+ogiDBdPN
   w==;
X-IronPort-AV: E=Sophos;i="5.95,200,1661788800"; 
   d="scan'208";a="318733095"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2022 14:34:18 +0800
IronPort-SDR: zuBBKyA7vOaE3Xp+ViU+gtF8z/SXHQ+UMerUvI8Ns0JS4axoMHCVPVpnzTerCYJFouoVsivKWl
 m9BftUHreqLwDXbr8CLnYpvA3Rlgx5NgOnQjCO0VsKhITs9KxQZpy4zmH4tJuco2En1nVUnTW7
 XJUciRNwv7Er6HxLXlsf9MhmOfaIfTbPFrAFCihbSKgKgiI1gY1sE4kEymBQe5hIt3FvD1c3iW
 S2q3JayHL7jtUTLN3cN9M6uT/aNMsh96NQbUvs3+uqxlBJZ4Lw8BwdeAwBRpZLR5WtCUSRxyOm
 LcL6ZnKXnA7TTEPnGvvLkexz
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2022 22:48:05 -0700
IronPort-SDR: Dkc0JjMGThrOgsikpvyM5/aoaTpuBNTQkVtLXb5W3Tr/exW5A0HFzaH7lp1LHgOz1HtiJLn54v
 X0e3T2IS5ddK+614YWFJ8azySYCs2895KsKhQAPqUU4VWC07IFp3sN7Qy7U6W9j0fcvL8To5zZ
 +xV56+UR2DK6icGo7gxEKRQLU3boOCiLPxqiJhXOX1silb1s4jnP+OzvqY9LRmFG5Qk4wFQZa5
 bWSpLdr7SKKHLt70m2UyncZUiwNZfZTurQjLWMonFf9W18JNT9iezHKsG7+3UUJrT+sqYjz18n
 AFQ=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Oct 2022 23:34:17 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 00/11] zbd: fix unaligned block size issue and verify issues
Date:   Fri, 21 Oct 2022 15:34:05 +0900
Message-Id: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When zonemode is zbd and block size is not divisor of zone size, write target
zone selection does not work as expected. First three patches in this series
fix the issue by introducing zone finish operation. First two patches do
preparation and the 3rd patch does the fix.

This series also fix four more issues related to verify with zonemode zbd. The
first issue is that verify is allowed only when block size is divisor of zone
size. The 4th patch removes this limitation. The second and third issue are
caused by zone reset, which erases data pattern for verify. The 5th and 6th
patches adjust verify and zone reset timing to avoid verify errors by the erased
data pattern. The last issue is experimental verify, which does not work with
zonemode=zbd. The 7th patch checks options to error out when experimental
verify is specified together with zonemode=zbd.

Four more patches follow to make test cases in t/zbd match with the fixes.

Shin'ichiro Kawasaki (11):
  oslib: blkzoned: add blkzoned_finish_zone() helper function
  engines/libzbc: add libzbc_finish_zone() helper function
  zbd: finish zones with remainder smaller than minimum write block size
  zbd: allow block size not divisor of zone size
  zbd: verify before zone reset for zone_reset_threshold option
  zbd: fix zone reset condition for verify_backlog option
  zbd: prevent experimental verify with zonemode=zbd
  t/zbd: fix test case #33 for block size unaligned to zone size
  t/zbd: modify test case #34 for block size unaligned to zone size
  t/zbd: add test case to check zone_reset_threshold option with verify
  t/zbd: remove experimental_verify option from test case #54

 engines/libzbc.c       |  34 ++++++++++
 ioengines.h            |   2 +
 oslib/blkzoned.h       |   8 +++
 oslib/linux-blkzoned.c |  37 +++++++++++
 t/zbd/test-zbd-support |  44 +++++++++----
 zbd.c                  | 146 ++++++++++++++++++++++++++---------------
 zbd.h                  |   2 -
 7 files changed, 207 insertions(+), 66 deletions(-)

-- 
2.37.1

