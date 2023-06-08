Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B657C7EE25
	for <fio@archiver.kernel.org>; Thu,  8 Jun 2023 07:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233608AbjFHHGS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 8 Jun 2023 03:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbjFHHGQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Jun 2023 03:06:16 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9847E43
        for <fio@vger.kernel.org>; Thu,  8 Jun 2023 00:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686207975; x=1717743975;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=61izek9A2lTgIg2so2GKsOyGqzztY+b2gTFF9ymehAo=;
  b=lDjPl/uObDMHbNx0AugOO4eFvGopO4UdldHRWdJaFTljsIvHIMBd/Mtq
   OZaS/jhcN72Fb+RCOEEcWpuJghUxy8c8saGzpU9AtRkOf6bXQFQsulzDd
   p6fVTCoI0u4H82HQMsc2bMvSrNN3ZyVprj9ueFkHMF8yOkBC1O+CQxyiH
   ZfRKFE2R2tKPCCILucekxTdkpZLgpvdO5WNS6ae4hz+0OwC/xYtvuc2s8
   5gvU1OTExRtHhr/OmJZ6MNN/+TloOBVbd2s8NREyAFPajyqzz10HZRoeZ
   VIP+NqW9DXsJIarXijTL8ptA51CTQ7oy/I7E7J/PrV0UbhuvAF7GeHi4K
   A==;
X-IronPort-AV: E=Sophos;i="6.00,226,1681142400"; 
   d="scan'208";a="237987003"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jun 2023 15:06:15 +0800
IronPort-SDR: 0TZR8J49Xc1U8NIKM2XpBeBv9kBPhG2bsXXSNjDDZbb/YgUzNAGkOjJB7NP+YoOdiL0C31v/s2
 wIWuzbItQvtwacaA1QSY5udSe31o5OSBaJq3k+f+V+44lxH/4qKLxIjqGWqcmO5QRdbWwa+Hxy
 TC2RvlP2JbmXWxBxs4ZvUeU5sqb5O3v2c9KX1xKudLanWMLGHsyXBPlbVnOQ9+Q6LUsbDZYRWs
 C+B+CO6nScyvDQZw6mn5fzCs/OIat2Y5j8KovjQ7GKFBfpphW+zC8nU/y0VZnA39jrgyi5Ag62
 9BM=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2023 23:20:57 -0700
IronPort-SDR: ByLEF7L7CaEz62XZl12cxF7mSQY1ILKaRGKdrGHfmIEXqXtgD1esmaTyKHxZZ76e/GwVipOJNu
 q83+ZSaCoCUEyxk91aHhkZHTDgmee4xOvJmnM0x6m59cuCOCriZDlj7hOZQiUgm/cBfDCI6mcc
 Nwkz24Cve8v87urUnmGICGnVIrxW+n9i9/rnFBRNEPB3cgGyPTTb7ok1IfI2nErSlP/mVKPfU3
 SSOX31mAz+d2PxMpxt9jq6Ipy8gQPBGUozJ+uDcLCG6cshDZNUBOoit+j0nNyeChh1D70apxm1
 DO8=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Jun 2023 00:06:10 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 0/7] zbd: clean up code and fix bugs for open zones accounting
Date:   Thu,  8 Jun 2023 16:06:01 +0900
Message-Id: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Fio with zonemode=zbd does accounting of 'open zones'. However, the meaning of
'open zone' is confusing because its definition is similar but different
between fio and zoned block devices. The first patch in this series avoids the
confusion by renaming the word 'open zone' to 'write zone'.

Also, recently three bugs were found related to the open zones accounting.
Following three patches fix the bugs. The last three patches improve test cases
corresponding to the fixes.

Changes from v1:
* Reflected review comments on the 4th patch
* Added Reviewed-by tags

Shin'ichiro Kawasaki (7):
  zbd: rename 'open zones' to 'write zones'
  zbd: do not reset extra zones in open conditions
  zbd: fix write zone accounting of almost full zones
  zbd: fix write zone accounting of trim workload
  t/zbd: reset zones before tests with max_open_zones option
  t/zbd: test write zone accounting of almost full zones
  t/zbd: test write zone accounting of trim workload

 engines/io_uring.c     |   2 +-
 fio.h                  |   2 +-
 io_u.c                 |   2 +-
 io_u.h                 |   2 +-
 options.c              |   4 +-
 t/zbd/test-zbd-support |  64 ++++++++-
 zbd.c                  | 292 ++++++++++++++++++++++++-----------------
 zbd.h                  |  25 ++--
 zbd_types.h            |   2 +-
 9 files changed, 248 insertions(+), 147 deletions(-)

-- 
2.40.1

