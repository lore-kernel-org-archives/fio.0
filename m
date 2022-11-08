Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC56CC433FE
	for <fio@archiver.kernel.org>; Tue,  8 Nov 2022 08:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbiKHIto (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Nov 2022 03:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbiKHItn (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Nov 2022 03:49:43 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9913E6382
        for <fio@vger.kernel.org>; Tue,  8 Nov 2022 00:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667897382; x=1699433382;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Fw+qAP6H/iuJWZUoxhOc77Z7tPBMX6ow2wkudLn7cvY=;
  b=ihsqmSLUiGEUE9BkKoHyELCyk3LV5VpjQ8xq1yvkorkuLOPSl3MKdamP
   gaEokw+v91k5R5SSXyVQOY8XHiNC5ugNl21yh1AqC2zuDa7z4HM8x65OS
   22s9PVblzkAf8cPiK6c6X1rNYoOthwQnkiiBbS50Ef6U/Gor0GMeesVpY
   IJfJ9svRo+gd2U/e4wMUzQ93Gu9Iaq4hg3GWNTm0nHVd2pdkOg64Y2npO
   ZHWjkPqCwcreK7NWyYCw9RC9O2k2oTl2Hqx4GeeqZfKJo/mg7d6eddYrG
   EnqPJF2JBFolhWpZ3iDhfZGeUs0QLAB5ey+DwN5Ce9pONsKQdJncDKcBl
   w==;
X-IronPort-AV: E=Sophos;i="5.96,147,1665417600"; 
   d="scan'208";a="320079421"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2022 16:49:41 +0800
IronPort-SDR: rLb7fQm8funTzcakrdwklEyD+eRfGJqI89n3lIn+/AO/aRU72Iq1bpcJESg4g5vxtaYh5Mkp/7
 pOEiYwmFL3REc/eXiEmIBECQTHSpF6kMcPJxeKBIcaQIBhIGZyZnB9HzHJm0KVgVFtqQLZP1m0
 mhK2IDDBOxoerYfu/s9zcv6C+58GN/xV5gewPPl7snHTGrzYp18Zrh8r0ZG8tkU4QUk6k2fynn
 FJiU2ETOxDG1UECZRt+h5UqQAfzw7GPxlMO5mmgzLSBWhySZD4kY3itMFUEuual1Tp/ha8F6JN
 jMg=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 00:03:03 -0800
IronPort-SDR: JIOs88a0hppxzaZ4VQwUCAYHyLRYbBEu8bSnjNMYgGdWSJF9hEsLGg8pvRFPiY5zeoseFKFdE/
 NmttCR6hj8rY1q7PywSJ0huqYeMXEjGjYESVYPpEX3NvnmG1MuFNRVlDFP3go2ANE+Y97FEcGJ
 4921LeW/T0dCedZzB8N1MHY/wQ3flMLlFvrZBjK6zOTSynRlBO+JpzLKFddZzTRXZJdkOFRKJZ
 KguIa41C1jT3qie1H8cliIWNO8v+YhskL0Xs/UHm2VQhQy/heSLtFuF2EiJbZDiA50db22fK+l
 ieo=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2022 00:49:41 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 00/13] zbd: fix unaligned block size issue and verify issues
Date:   Tue,  8 Nov 2022 17:49:27 +0900
Message-Id: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
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

Of note is that the new test case #59 added by 11th patch may fail, when libzbc
IO engine is specified to t/zbd/test-zbd-support script with -l option. For SAS
ZBC drive, use latest libzbc with fix to avoid the faliure [1]. For SATA ZAC
drive, use kernel with a fix posted to linux-ide list recently [2].

[1] https://github.com/westerndigitalcorporation/libzbc/commit/6de6869acbe7c3a12758b1f42c9da47bb873e621
[2] https://lore.kernel.org/linux-ide/20221107040229.1548793-1-shinichiro.kawasaki@wdc.com/


Changes from v3:
* 6th patch: fixed get_next_verify() call and rand_seed check condition
* 11th patch: improved to cover four types of workloads

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
  zbd, verify: verify before zone reset for
    zone_reset_threshold/frequency
  zbd: fix zone reset condition for verify_backlog option
  zbd: prevent experimental verify with zonemode=zbd
  t/zbd: fix test case #33 for block size unaligned to zone size
  t/zbd: modify test case #34 for block size unaligned to zone size
  t/zbd: add test case to check zone_reset_threshold/frequency with
    verify
  t/zbd: remove experimental_verify option from test case #54
  t/zbd: add test case to check experimental_verify option

 engines/libzbc.c       |  34 +++++++++
 ioengines.h            |   2 +
 oslib/blkzoned.h       |   8 ++
 oslib/linux-blkzoned.c |  37 +++++++++
 t/zbd/test-zbd-support |  56 +++++++++++---
 verify.c               |   6 +-
 zbd.c                  | 168 +++++++++++++++++++++++++++--------------
 zbd.h                  |   2 -
 8 files changed, 240 insertions(+), 73 deletions(-)

-- 
2.37.1

