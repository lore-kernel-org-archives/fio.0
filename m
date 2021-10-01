Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 931F8C433EF
	for <fio@archiver.kernel.org>; Fri,  1 Oct 2021 10:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7440B61361
	for <fio@archiver.kernel.org>; Fri,  1 Oct 2021 10:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353511AbhJAKen (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 1 Oct 2021 06:34:43 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:20618 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353585AbhJAKen (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 1 Oct 2021 06:34:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1633084377; x=1664620377;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CHhXG7ldMvqnsDILIHsttW17NtNGuT24WdUhZuw8QBA=;
  b=VK3aZw3jtvFwDVs5WPkiOMx9+SRoSGQjDfOsq7Y/wYiKLTk+NOn9xbWV
   wVn7cTGGKk3oOOUek5SlEIwqTNOiADWl7kHvEOezUl4wXOMj0c7sha4QA
   HBPWYGzPRrqVy59s8xOr4qFVrbjyHHPzQeuNUZo/+tp2upNBtkZg9cGCo
   Yr1r9ie3G4x41prN1mYmK34ljRTPtccOp3ZCzgZZAeYvcccePJd2NjgZ6
   IDfgAmYyjdMgx9paX/dn84QTqNsSw5rfKDr6inJ2ijIF4y4yzou+/+w3x
   pU5WzE7LgPbwI3wTa5lSAomNGrPV+AhItsAuyYgFtyOsflVh0dToJW+5s
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,337,1624291200"; 
   d="scan'208";a="186328209"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 01 Oct 2021 18:32:57 +0800
IronPort-SDR: iz1qvy0DzEichDFti9DkXrMpBfk02/mST51LQ/fg8eEQ4nRgpF2MPwArvpQ62y7qjWBCNBe5nf
 mKREJoEs5kgoMKS45anwyLFOoR7vfLckexAvSNHz+QLqBuX4TfAEH0x6S+dkL/hrrSaf5xaDdm
 tZU7FKokt1K+TL2Jlrd9TrZt7/iPd1WdjntK3ibPYQlylf9G6MpJ/3WsdRuksb6R+BkD8hdF1M
 U82yogUfBWRHrHRx9eNSP8YbnZeWMPi9vvZZ1ZrCSLTQQkZO/CWEqgo06wescuNpuzTiboZHT/
 XBtlyXs1USlUB6ZKtb76m9ZD
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 03:07:27 -0700
IronPort-SDR: 5TPJSsfPQ8sKIsEnAJo84wXo0negUpE8T2AoU97Zzve0NTxX1IXIRs2dt2Uyn8eR10w0ekRp7K
 wi2SjZJMC4Z3t4ujBu3jf883iMUjlSl1bye42HyDo63JbdxxvZ/zhUGT+BpB+HLA7VW0elnpL6
 PsXXCTG77Mb9bS0FabAVfH50l/y51ewcugJ2ATb0KjvI7y6J+MHNJJtBvXQFzz0qnmW54+E/z8
 zIr8UcrmCrkOJoyhfFABlIM6YF17zBd8HI8iGfC8bO183J+2Q2BIpCb4XU9CfGCKXiE5Ah9s/k
 kzo=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.173])
  by uls-op-cesaip01.wdc.com with ESMTP; 01 Oct 2021 03:32:58 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/2] Fix job completion failure for sequential IOs with holes
Date:   Fri,  1 Oct 2021 19:32:55 +0900
Message-Id: <20211001103257.4130231-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Commit 499cded5f435 ("Fix for loop count issue when do_verify=0 (#1093)")
triggered the failure of test case #7 of t/run-fio-tests.py. The test case
runs sequential read workload with holes and checks amount of read data. The
commit affected job completion condition, and resulted in unexpected larger
read data and the test case failure.

This series has two patches to address the issue. The first patch reverts the
commit, and the second patch proposes different fix for the loop count issue
with do_verify=0 option. I used the workload recorded in github issue #1093 to
confirm this second patch fixes the loop count issue.

Shin'ichiro Kawasaki (2):
  Revert "Fix for loop count issue when do_verify=0 (#1093)"
  Refer td->loops instead of td->o.loops to fix loop count issue

 backend.c | 4 ++--
 libfio.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.31.1

