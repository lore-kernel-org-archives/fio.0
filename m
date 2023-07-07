Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB13FEB64D9
	for <fio@archiver.kernel.org>; Fri,  7 Jul 2023 03:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjGGDPJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 6 Jul 2023 23:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjGGDPI (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Jul 2023 23:15:08 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEBD919BD
        for <fio@vger.kernel.org>; Thu,  6 Jul 2023 20:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688699707; x=1720235707;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QFmxUul5HsenEoJjFxC5nhUsWdKDqDlCqQY7wQIyfw4=;
  b=Dqf/LA0Q7iUCdMUNGlVXZWMqiFZPbO/zLPg5IdgUJzI9hLDG9LpSX/e/
   ThwAvsM0qOdruoXSH8CC51CKylVeQWO9MIK8Y1pqWTvQ0SQFvMQZo5oeS
   IbkpDLHdZmTuGWvadEMCEuwnddiqw3/tSPa7TkSnVhs7Dqt9L10joEIux
   KaO33/HPvtQZPXAKa1BNssMDYN7LTj9RtwJa5gx/ZkcS6GGkS31AxI54b
   pyISRppIXyVKZXDGLXhzNcjZjweBaqBaKbyuX5IAoHHeUh479hNxcHy74
   TZMx2I4E5o+qhHSL9TGJqMxcFYA26wnchymcSetpts4mYOFq9JS01KnBb
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,187,1684771200"; 
   d="scan'208";a="342468789"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jul 2023 11:15:06 +0800
IronPort-SDR: aWjjsGu9jMY8bZmFu+AqEgWkwerR4uDv1gdsVRia6frarpUEvvRfkjnjDr3yuIDnyNBbpTX+a9
 qIFsmFHwhpZ8lBlQB+wpVSHrBKgztEt3XmDmHGD/0hFMSC/p4pmL/feIdgoULV0NWsMkgYYhPk
 6M2y3Q7qWP81Aa39gEqlD1lDzV6dS9W2CvhgfJfLPua1Rtal3MSULX0ckJcEXr9D6h2N47rbZx
 kJzgx9/m8sg3VUlktOhzNocbGLDRiTZ8P11FjOOJrIPsLE4+Q/Vgv5WgAp9XRboaXPrvnWdLd4
 KCY=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2023 19:29:14 -0700
IronPort-SDR: Bgh2ueh30SJcYNlTPRWvR8jhgpMNpRgKe9tBZaKE1C68Nvrx8TkcpeMOQxvrzEPLn3BAciwNVk
 dEVDTnFQ3PbVwgD+nmEeM7dpXYkfnjZ5quJLEc30SybHTML/zIoJwaWJ1RJkvvcMsGczb4aKzA
 Ji2Sp0BLy3S6PntRz5zhIcbvhDv7WkQJQqDaQ1pev6klal2c4g1iw6Kiy1HYmdfVpEfTF1RT//
 loyE/AeZnsLzhXfqu70aeb7TsXl8S4UO1XV2Avde4GIJeJjc9QjiqJH2jp+WhJbX1QboOrNdx0
 /pA=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2023 20:15:06 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 00/13] zbd: improve max_active_zones limit handling
Date:   Fri,  7 Jul 2023 12:14:52 +0900
Message-Id: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
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

Dmitry Fomichev (2):
  t/zbd: fix null_blk configuration in run-tests-against-nullb
  t/zbd: add max_active configs to run-tests-against-nullb

Shin'ichiro Kawasaki (11):
  zbd: refer max_active_zones sysfs attribute
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
 oslib/blkzoned.h              |   9 ++
 oslib/linux-blkzoned.c        |  23 ++++
 t/zbd/functions               |  33 +++++-
 t/zbd/run-tests-against-nullb | 203 ++++++++++++++++++++++++++++++++--
 t/zbd/test-zbd-support        |  91 ++++++++++++++-
 zbd.c                         |  26 ++++-
 zbd.h                         |   5 +
 10 files changed, 433 insertions(+), 39 deletions(-)

-- 
2.40.1

