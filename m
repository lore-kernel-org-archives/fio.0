Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 146E8ECAAA1
	for <fio@archiver.kernel.org>; Fri, 28 Oct 2022 11:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiJ1Lx6 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Oct 2022 07:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJ1Lx5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Oct 2022 07:53:57 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D2B1D2B77
        for <fio@vger.kernel.org>; Fri, 28 Oct 2022 04:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666958036; x=1698494036;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sUNx8ZdiTuWk81ZWBDHPqfDriHcOUBpGU5/Zu3UttWQ=;
  b=oU2eDJv+hAFaEdp9fj259FXSb7m8VLZ/arBiBLYqvsvvoG3udGQhfW1f
   h8HviJs70dtIpjytKBxjPEyihMWcp5Ex6jaKW5pLW5AAdZ1X4OwLdKKyj
   /VNj6Mfo185KQPXjpfgBoW7OvQFsSjRsAIXhk4iiW4nGSYgDr/LLxeepM
   /KGtnoItyskXt4solvhpgpyqhPv/4+vKtg7zW9/d4ANrHcQVWOrsaFihM
   J6ml63VWWBe3FviRsQi2mNfLnBV1Rp4vbtlXl4JgAJzO7UjPD7GDwJL89
   sb11HXuKHYWtBfylX6J5BMOGfqJTwxQcb0sFE8JhG2Lhc7twRoSKDmnNu
   A==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661788800"; 
   d="scan'208";a="327074518"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2022 19:53:55 +0800
IronPort-SDR: BupS/nAFEt+EyEzJTFYBMtDVwmtvwfAFkC8QjLjmhhyejIzyMjenFsvnJ1mRSm4j96oV26WBnt
 Zogo6j0BPRuhQT6x1pU4qEkc3AaRgMM3mayQCefDPzgSFGFAYI0iZU+uqCvnq7Mi2Rn9NtX9I3
 ZFoC0tw1p3RSlHx4VweVwjyu/dKbPLcZXwbdFQMq3Vem2kvLm7iSmgDP+Q+eAp6OUVGWUL0FX8
 vPs4GXhWMhkMu4FCMq+QSiD74X0af7DPx1p9t4zsMVPldq2jygBMbIBcSAL3G5JfWbaFpJaNWx
 q93kANjljah0Oi20EJTLa7jT
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Oct 2022 04:07:32 -0700
IronPort-SDR: zgM8y8kkc6mcSYryDrVFY59G3OVdozgeoy4TFHcOUYxORSux/M86EsWcbROjApO3pkvfcjACrd
 4AxNDYM5LCKqey5br8i7Ie4uPw5drbn7KvLmSXQtPa5SHbR7gtIlSb1BoPQFky/VJqPBOWMDRx
 MT0KM6sBRTnJtOJxChjYcoHosiXnoWQhzVF7D54T68n7c3LOlCUqbJ44WV8Ffn0fDsgTLacGxZ
 ycaNf64FMuzp+vsrHCEYZ3M4irAvswk3QrJsrHbwXchJdOjnOdZE4imcUtYWZu2elbZClOyqiS
 WIs=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 28 Oct 2022 04:53:55 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 00/13] zbd: fix unaligned block size issue and verify issues
Date:   Fri, 28 Oct 2022 20:53:41 +0900
Message-Id: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
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

Changes from v2:
* Improved commit message and block comment in 3rd patch
* Fixed a comment typo in last patch
* Added Tested-by and Reviewed-by tags

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
 zbd.c                  | 159 ++++++++++++++++++++++++++---------------
 zbd.h                  |   2 -
 7 files changed, 223 insertions(+), 71 deletions(-)

-- 
2.37.1

