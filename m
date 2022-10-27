Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86BFEC38A2D
	for <fio@archiver.kernel.org>; Thu, 27 Oct 2022 06:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiJ0GBp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Oct 2022 02:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbiJ0GBo (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Oct 2022 02:01:44 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6230B7A518
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 23:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666850503; x=1698386503;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vtjLAhDYY05bY0+0z2eYP7QkSDINcDyi72ZI0+tarFg=;
  b=Ik0bvnKno3Afrcg3rPrCdkNMbvLfh59q+yGSg9Jd1/jAYppHK88TtLOb
   /KHG2eZaYXTvbQFGr3TKuu2gvfcH8bUxyr0T+kap2Fxs0vng1Arptrdlv
   3Rji4NpNrv7nXt0/AuvXuQoGtr2TU3Ga/sDUDSU+cFRyB3J+F5Ds3ahXX
   I40Iq3Zwdw+YbimnwYzItuQnYQU3vwXFLuBr+f/jtwTnykCL8k1ZDiMS4
   qu3o/ic9MKx/Ja8sRL9vxU69PuMUlm4zXcg+p1jT8JhG7i/uYMZrXlUma
   k+XrDRUl/Wsx7REQtiiFn0ydmTF94keUy9fQndcVcTd4MoBrSK4QnVCKW
   w==;
X-IronPort-AV: E=Sophos;i="5.95,215,1661788800"; 
   d="scan'208";a="214845821"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2022 14:01:42 +0800
IronPort-SDR: vO3Szw0oOCBI0cP35f6CEN1zznTevXKsUqzfcXCXSRFhQBlw6fGy7mhi6Md5dEeMYs6DmULeUn
 8Cuqa1M1Apft7HBKyDj8k9EFOJJLFyNhsz8qTMzYzQVc6y77VfM2nSMnBGfW+27hj+YlgmLFqv
 dwOPc1zVwQBQ0HYIJEDgmK8Zc/dOK/cPT01xAZCCmuyxjRi3j+VImT1M537tWlKjbrzAvbquNP
 p+OnpzEGEN5eFzlskNmiGBXN+iNUCn8oZvbUrxdB45he6eudU1r5okT34BP+Iu83aV4rxvqJhe
 FRddihww6B+F21cOqr2vQ37m
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 22:15:20 -0700
IronPort-SDR: TzYf0PTr8ZONV+F3lxg6L4sC8CCbzdx/p5OII6BLzyR3m0SIYGuoLH8xME67KS1qF2ZR4iNQ1u
 wvsdZNNBeP1FaieuKcM/K/dMpc6HPc1A02BOPWcsPxKBmiYL5S32G4VIwjVmoOZ5AeJespRQAt
 5LlzEyBf1RWy7Y/2oWGN9XECAV/5ldv0ccltvJUDsVMgdK5Mq2WShVYSKxCd0mEsIilluzbmgu
 9TnjEHWXjt2JQW5tSNJSn2s7U/UV4rWzkY7LQVQmb39ckNZ3TAEWPqdGWyrhOl93m8pdKLo7Se
 lWU=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Oct 2022 23:01:41 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 00/13] zbd: fix unaligned block size issue and verify issues
Date:   Thu, 27 Oct 2022 15:01:26 +0900
Message-Id: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When zonemode is zbd and block size is not divisor of zone size, write target
zone selection does not work as expected. First four patches in this series fix
the issue by introducing zone finish operation. First three patches do
preparation and the 4th patch does the fix.

This series also fix four more issues related to verify with zonemode zbd. The
first issue is that verify is allowed only when block size is divisor of zone
size. The 5th patch removes this limitation. The second and third issue are
caused by zone reset, which erases data pattern for verify. The 6th and 7th
patches adjust verify and zone reset timing to avoid verify errors by the erased
data pattern. The last issue is experimental verify, which does not work with
zonemode=zbd. The 8th patch checks options to error out when experimental
verify is specified together with zonemode=zbd.

Five more patches follow to make test cases in t/zbd match with the fixes.

Changes from v1:
* Separated zbd_zone_remainder() addition to 3rd patch and added suggested hunks
* Added last 13th patch for a new test case to test experimental_verify option
* Reflected other comments on the list
* Added Tested-by and Reviewed-by tags

Shin'ichiro Kawasaki (13):
  oslib: blkzoned: add blkzoned_finish_zone() helper function
  engines/libzbc: add libzbc_finish_zone() helper function
  zbd: add zbd_zone_remainder() helper function
  zbd: finish zones with remainder smaller than minimum write block size
  zbd: allow block size not divisor of zone size
  zbd: verify before zone reset for zone_reset_threshold option
  zbd: fix zone reset condition for verify_backlog option
  zbd: prevent experimental verify with zonemode=zbd
  t/zbd: fix test case #33 for block size unaligned to zone size
  t/zbd: modify test case #34 for block size unaligned to zone size
  t/zbd: add test case to check zone_reset_threshold option with verify
  t/zbd: remove experimental_verify option from test case #54
  t/zbd: add test case to check experimental_verify option

 engines/libzbc.c       |  34 +++++++++
 ioengines.h            |   2 +
 oslib/blkzoned.h       |   8 +++
 oslib/linux-blkzoned.c |  37 ++++++++++
 t/zbd/test-zbd-support |  52 ++++++++++----
 zbd.c                  | 158 ++++++++++++++++++++++++++---------------
 zbd.h                  |   2 -
 7 files changed, 222 insertions(+), 71 deletions(-)

-- 
2.37.1

