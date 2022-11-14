Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3197C433FE
	for <fio@archiver.kernel.org>; Mon, 14 Nov 2022 02:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbiKNCNN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 13 Nov 2022 21:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiKNCNM (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 13 Nov 2022 21:13:12 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7351CDFFC
        for <fio@vger.kernel.org>; Sun, 13 Nov 2022 18:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668391991; x=1699927991;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YnoCySv3EE+eEOysft7vaAbq6LsxBhJtrGi9BCOpzPg=;
  b=TM3ljmhLkTaMX8CDdjFuP/IA3j1Si7DoPrVrjBUidxDnGALwHMtPAlN/
   vTUDdj1kkKYgMu6sTyyLI91wdligGybAhz49v96WwuyfPAe/XunbOZQWg
   G12AvvOnYv9L6sztKgQAIE+bKM0vIUaTNcMKX3CSOI5NkgshWz5k/eCQv
   pjyjx37Ow9d+TiBvZd8GP8vCQpyjZKdbQDxVhGTwplNVC/HhBVD7BOPSe
   8BKBrLgBPM0Zo46vmWgU0dgZFpf5phER9JpEr3Rle/RwpAAlG0tiImtnh
   uEuKUptaEwEH7co5R6qyFcldKg7SvIHuMM8s1OoSQP1P7JDSt/q7VReIT
   g==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665417600"; 
   d="scan'208";a="328279203"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2022 10:13:10 +0800
IronPort-SDR: bK010JOZS5aOLsFottISHvqhYZuQsDOTCd3aT8xfnXm9O90BBY5Os6mTeZ74GPDlsWMzvWRNke
 OsHx+fMl943U60x2cASmr0IvE/g+332tzO6FNuh+35s5gqdh/HgWK9FsSRR2lsG8yGTnpMasUD
 K5QXA2xA8bXvezFt5hhFDdUPTTLxhJ6Vq+HNk4OajsaTF1YMY4n3qwAqZKpA6C8w21jccLsGvO
 Q011OzCML4xmrcNKtblmcpttrX4BVgiaEZHRdozFaC2/8ymRFq95P1k6bpqCmH7LIZc12S/u1J
 Ugk=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Nov 2022 17:32:10 -0800
IronPort-SDR: lI/qwSMv++2C4iCyMbgtaCXxgWiKSs4ImiVWY92XXJe3Du1NbAXnwKL12UVtyA4+9zr6a5j3ub
 RlC/RKWOXUHzWnTONnJNae19yXD1a9GTwyUDB332pUplgAcHnOE1kNrK/88Y2EPebyWv9i4/fq
 22uMYKwBzOEbKY736PT8mG/mPDb0xbvB8hlm/CWPrUb+270qpiFvTdgdHa+pi4R6Fj+V+BypLs
 Q8IR2yf71EcuiuniQz3kxpvpWsMgqt3TVVa1NKSVIOxNsd5vVcV8oUT3o4ugUxOybiAXP0ZSG3
 YDM=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Nov 2022 18:13:10 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v5 00/13] zbd: fix unaligned block size issue and verify issues
Date:   Mon, 14 Nov 2022 11:12:55 +0900
Message-Id: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
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


Changes from v4:
* 7th patch: improved fix for test case #34 failure found with 16MB zone size
* 10th patch: improved the test case #34 to trigger the failure found with 16MB
              zone size

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
  zbd: fix zone reset condition for verify
  zbd: prevent experimental verify with zonemode=zbd
  t/zbd: fix test case #33 for block size unaligned to zone size
  t/zbd: modify test case #34 for block size unaligned to zone size
  t/zbd: add test case to check zone_reset_threshold/frequency with
    verify
  t/zbd: remove experimental_verify option from test case #54
  t/zbd: add test case to check experimental_verify option

 engines/libzbc.c       |  34 ++++++++
 ioengines.h            |   2 +
 oslib/blkzoned.h       |   8 ++
 oslib/linux-blkzoned.c |  37 +++++++++
 t/zbd/test-zbd-support |  60 +++++++++++---
 verify.c               |   6 +-
 zbd.c                  | 175 +++++++++++++++++++++++++++--------------
 zbd.h                  |   2 -
 8 files changed, 250 insertions(+), 74 deletions(-)

-- 
2.37.1

