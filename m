Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05169C636D4
	for <fio@archiver.kernel.org>; Tue,  7 Feb 2023 06:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbjBGGho (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 01:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbjBGGhn (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 01:37:43 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C19222E7
        for <fio@vger.kernel.org>; Mon,  6 Feb 2023 22:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675751862; x=1707287862;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=u5GecBrnCgszpZRfjycrhHjvNyXetj3U2MldQ8fHcHk=;
  b=SRTqpBWLfEjIYZ+G9dGS2viCzgwHYecC+sbZrJYFSCAJPHPGvmAppBO4
   ZwusxkSkywKmpLG4MOk/IvD/wI5Ed+DRZpe3imEaIFVQV/iRg5sB6v7wT
   gqWE4C/rI+cG2MW4DwV2sVPNTe8BYF3+1UIB+4H6vqXtyDzpqPQeWmj4d
   Q1bZlvM0lhF6/pKBsdARP9ypYEyeTknHUETjx1x01AvOodzKOqpabO7Mz
   M3lwz9kANsFHH0e+QVlIYaZBBHDjVnfNyCFYGigaIPyXEi7CK4FKwthOz
   o9/5kWsAmUQMbJK5RFcuc8U8epOwrg9xegj36lNZPFpGsE+YQtL6kXQQ9
   g==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669046400"; 
   d="scan'208";a="326982646"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2023 14:37:41 +0800
IronPort-SDR: dRqHdAeuow0399LaInsYhnn0jpoFrFTILXJ0NXCJ5STMba9qvuBBzGLZbh6ArDdENmswchuA3C
 FUHia7MN5FJGH8S5ZRNeOJg650AkHtk8szUXMCGELyFTBRL7KDccYQ1d/tTOFH7yzkrYpS2rSb
 JiuYaXO+TGdNRn3SJM1zC4jJBCNsmIkFF8h71iyQWlOMbZ2Hp3v73fuv9/ke3Y4Ax2hs7PcbHY
 gO4vqarbokDft1Hw6gZcef5Ib7sGYKn6bcUdS6nxP8ccwBTnvdstHJiyeFOystM3AEhn2Zcwbd
 Pxk=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Feb 2023 21:54:58 -0800
IronPort-SDR: JFzOiSMD0+kjToiwekK7dl1l/UvOyH+1IdI4fFwcdt7rlnOPMTg8mv4H43nP3lvEEP1/+rNc6R
 MhbueacacJHulraqYHHW9ZWMHW4Psl8pxhcNrqU35mPe8wvTLIaTa/kETnX46pOmqCUuNvdOLi
 GBKKKckPoSGc6ITFxeVyK+A8JZk6yW1DZwW+b1fxnRthcDHgphdz94AmwQnEXhRP3nYuVPtp2o
 +a060fbcMtVTAfpj5gKhonaKDLeI72iX8yRlnX9Ty+ElYz3ItR7hf4Pk0G5Jh9XQ35B0gJHWvX
 JkY=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Feb 2023 22:37:40 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 0/8] zbd: fix 'sectors with data' and zone_reset_threshold accounting issues
Date:   Tue,  7 Feb 2023 15:37:31 +0900
Message-Id: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When zonemode=zbd is specified, fio does 'sectors with data' accounting to
record the total number of sectors that have been written on a zoned block
device. This accounting has issues as follows:

Issue 1)
   The name 'sectors with data' indicates that the accounting uses 'sector' as
   the unit. However, it is implemented using 'byte' as the unit.

Issue 2)
   The accounting does not work correctly when multi-jobs with different IO
   ranges due to two reasons. One reason is the accounting field initialization.
   The accounting field is shared across all jobs, but it is initialized
   repeatedly by all jobs. This results in wrong behaviors except the last job.
   The second reason is definition difference between the zone_reset_threshold
   option and the accounting. The option is defined as the ratio of valid
   written data to the IO range of each job. However, the accounting is done
   per device and shared across all jobs. This coverage gap between each job's
   IO range and the accounting range causes unexpected zone reset.

Issue 3)
   Counting the total number of written sectors requires taking the zone lock of
   all zones in a job IO range. For a multi-job workload with overlapping IO
   ranges, this often leads to significant zone lock contention, resulting in
   some jobs starting IOs only after other jobs have completed their work
   (which looks like an apparent deadlock on startup).

This series addresses the issues with solutions as follows:

For Issue 1)
   Rephrase variables, comments and man pages to indicate that the accounting
   unit is not sector. -> 3rd and 4th patches

For Issue 2)
   Limit the condition of the accounting to ensure correct accounting. Do the
   accounting only when the zone_reset_threshold option is specified and all
   write jobs have the same IO range. Initialize the accounting field only once
   for the 1st job. -> 5th and 6th patches

For Issue 3)
   Move the total valid bytes counting code from "file reset" after job start
   to "file set up" before job start. This allows to count without zone locks,
   then avoids the lock contention. -> 7th patch

The first two patches are preparation patches to reduce references to the
'sectors with data' accounting field. The last 8th patch adds test cases for the
zone_reset_threshold option.

Changes from v1:
* Reworked not to change the definition of the zone_reset_threshold option
* Separated the patch to remove CHECK_SWD (or CHECK_VDB) to clarify the removal

Shin'ichiro Kawasaki (8):
  zbd: refer file->last_start[] instead of sectors with data accounting
  zbd: remove CHECK_SWD feature
  zbd: rename the accounting 'sectors with data' to 'valid data bytes'
  doc: fix unit of zone_reset_threshold and relation to other option
  zbd: account valid data bytes only for zone_reset_threshold option
  zbd: check write ranges for zone_reset_threshold option
  zbd: initialize valid data bytes accounting at file set up
  t/zbd: add test cases for zone_reset_threshold option

 HOWTO.rst              |   8 ++-
 fio.1                  |   8 ++-
 t/zbd/test-zbd-support |  60 +++++++++++++++++-
 zbd.c                  | 139 ++++++++++++++++++-----------------------
 zbd.h                  |  11 ++--
 5 files changed, 135 insertions(+), 91 deletions(-)

-- 
2.38.1

