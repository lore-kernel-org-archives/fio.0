Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 281F9C61DA4
	for <fio@archiver.kernel.org>; Thu,  9 Feb 2023 07:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjBIHJM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Feb 2023 02:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBIHJL (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Feb 2023 02:09:11 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43ABE1B33C
        for <fio@vger.kernel.org>; Wed,  8 Feb 2023 23:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675926549; x=1707462549;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fbFKPS56IMsJiDg+neYaQs97MMeQrEjsEuZDMO41Q4k=;
  b=LmDkfSzfMtHSf1zLC+assEMWOuQZtMzSJ4PXCRVu2zpH2GAMk0v2UOFp
   BPLTKB9VDZ7WmGwvEWR6zi3ZBQ/S5JH+0sT6kN75bS1gw2RdPEtCMtfW6
   dZbTfk6AZjS3x5li/u7wP2ZPOlJJMZuWbWp+x5HDHuA/gkUhyP+aR+t4j
   3J5q0a/wotyw3vUjAxdfhzIiG7AufTbr5+KAaEchKTk1QIM2CuvDg0uPI
   NDOU0Y+RtNMuPoW0UVV60ht8Dl1joncdyhsSExW87ZfXIc4GgEAZ6d6yp
   xYvDj24wKmeTJHwxILTcGX2DjaenctgKlHr0lktGRJheg48wt0QNeVdzP
   A==;
X-IronPort-AV: E=Sophos;i="5.97,281,1669046400"; 
   d="scan'208";a="334848066"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2023 15:09:09 +0800
IronPort-SDR: ukoGGq0JCKsxYpewKa5Rlpq/EJfnTo4W+73wdXIVmnvXnzLxYTXjCjUnnObg4p+tBSLUJ7lDZ3
 M3nG3Tr3TPfU1h0j7K0AiY6a535QkU2oXmL/j0ZU20yqA9aW+ZkrEUFQT5NikzuMPnw+mMskwT
 T0gp84an4i7JiZNFG6PVJeMyP6QT8bG8sHV2WJ1/sb1zZ91mdCVw2ps09BigopbjRx5FZ+gOBz
 brQEtn7obsUXuWV4GWBVwcS6FOLGDMvjaN0JFduKBkBrEPP260Q5y+fI6XfF7DRrNhmUdgZiW6
 eYs=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Feb 2023 22:20:39 -0800
IronPort-SDR: faMNlYjXz5i1NegYjEvkMKyXpefqaBO9wa1Htvlndk8N/k8+PcuY3OsshkhHTsA0uEo6+hMHcd
 Mw9laFSgyAcjVOz39TRo986JQGimEms3AMJurETp278eXsopHZ9TfuQzV3Ten08rbehvBVp5YB
 8xxDmuUXwkEAfgOYac/G82VXbbx4lRXUGnnuvgeimOJ36dZg3VbvenUKX2XksB+TfP4e3JXTQ9
 IuUfKk2LAyBqCVEjgAckyIZK4J+P2HOfmclOowUFF3p7Hq7i0rO3aTM6EdWyg/U+czSlClVd1j
 kJ8=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Feb 2023 23:09:08 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 0/8] zbd: fix 'sectors with data' and zone_reset_threshold accounting issues
Date:   Thu,  9 Feb 2023 16:08:59 +0900
Message-Id: <20230209070907.1733138-1-shinichiro.kawasaki@wdc.com>
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

Changes from v2:
* 4th patch: rephrased to cover the case that IO range has conventional zones
* 6th patch: added a check to ensure f->min_zone and f->max_zones are different
* 7th patch: renamed zbd_set_vdb() to zbd_verify_and_set_vdb()
* Reflected other comments on the list and added Reviewed-by tags

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
  zbd: initialize valid data bytes accounting at file setup
  t/zbd: add test cases for zone_reset_threshold option

 HOWTO.rst              |   9 ++-
 fio.1                  |   8 ++-
 t/zbd/test-zbd-support |  60 ++++++++++++++++-
 zbd.c                  | 149 +++++++++++++++++++----------------------
 zbd.h                  |  11 +--
 5 files changed, 145 insertions(+), 92 deletions(-)

-- 
2.38.1

