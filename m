Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ADFAC433FE
	for <fio@archiver.kernel.org>; Tue, 18 Oct 2022 04:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiJRERa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Oct 2022 00:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJRER3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Oct 2022 00:17:29 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41F896221
        for <fio@vger.kernel.org>; Mon, 17 Oct 2022 21:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666066647; x=1697602647;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ri9yynMwzm2k+wbqkfIEma72O9we7zM28wrYkTAas5E=;
  b=oRKacEsdQ2LsT9T4tVhC6OquNGbg6LTI2zBs7BfJBGtPdcmUQLRSrS52
   ld5BDE4C2sdFi7bv+iGjHP9T9CJ72srlhJm6gBk3MnQPdEU5Z78WFiFww
   +8SOGXgFHIzdGTyQcjLbD/rlDY7Qqf5Cm+edqNI0C/kcZ1M3CQxb7QOBw
   PkE86nBsB/P+0j7TLtUv8ctTVd2N1OmEGQXL4Ip0tu+4XijW1kIoZc/+1
   0o7eC1K9kb8x9oQ5fGXVp8bQ+Jyu3Vxk06zoa8nXrODQiV7nYniOTLm/z
   6NUA/TdHumlDGNTxUa/eFiZjcz9vjaw+5woblQnwQgXeu2SbaH1GoOzu0
   g==;
X-IronPort-AV: E=Sophos;i="5.95,193,1661788800"; 
   d="scan'208";a="214084022"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Oct 2022 12:17:27 +0800
IronPort-SDR: DD1jN8rP/+6NNvijfYN9ZoQJB7/t0aP8BwH5TPYA0Hab+cqzoPzfpj818PXfXVFbYsndn8rtEu
 GRKlwv25q7DYXyRoI+Ru6r00IKC0r1Z4IxTmdXYYZmr9QWAztz82JvogPBs9nm/A96vFEpOafY
 HbtBdQV0H26eZ1QEhaAzjyNwVYaH6z1bh/ZhxJc69g5+ZCtMQMj1nXWnSxM0IGLotQ4UrgHNh/
 J5dBgeshk9hCO5qFe7vLY+KRpE99P3fLEi2EpJJRiYuqp3CNMW3Hr5953Fop/8DmcWsqXCN+xL
 cM5iB3tm3bMFXyOH6ZnHuSEb
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Oct 2022 20:36:58 -0700
IronPort-SDR: 9zdTmcs0CMYL0OLnzQfuLedFGJi61+mZ9Er8ZeXGn/L4ihCpU6hBLeSbzeRHujbCUWSpgKV1nv
 9KtF9f8n08ePhLML4rM9KN/UC0Jqp1vp60ZvD+SjD4za9dent4VwLQvsYSWuT0ZNpmEEuYgT5H
 yj+AfOwNtSMT9GwtNAfNlYUJrZRkAcNRPQQwLPGKtlbLH+LVfT2rnGuY+QDhvh3wYA0qfznkx9
 SB3q07GLCYoSFvUq8uKZzwWtdE67A9aS5BvljvxT2cZTBX/pTINlYCYetNMPI77CCpmQQoVO0Y
 NfI=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 17 Oct 2022 21:17:26 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/4] fix experimental verify
Date:   Tue, 18 Oct 2022 13:17:21 +0900
Message-Id: <20221018041725.807940-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Recently I noticed that verify workload with --experimental_verify option does
not read back verify data. I confirmed it with simple job below:

  [job]
  filename=t0025file
  size=128k
  readwrite=write
  do_verify=1
  verify=md5
  experimental_verify=1

Fio reported as follows. No read for verify data.

  Run status group 0 (all jobs):
     READ: bw=0B/s (0B/s), 0B/s-0B/s (0B/s-0B/s), io=0B (0B), run=1-1msec
     WRITE: bw=41.7MiB/s (43.7MB/s), 41.7MiB/s-41.7MiB/s (43.7MB/s-43.7MB/s)...

The debug log trace with --debug=io,verify option showed no verify data read
either. It indicates that experimental verify is not working as expected.

This series addresses two issues to make experimental verify work again. Also
add two test cases to confirm the issue fixes.

Of note is that this series makes test case #54 of t/zbd/test-zbd-support fail.
I'm preparing another series to address it as well as other verify issues
related to zonemode=zbd.

Shin'ichiro Kawasaki (4):
  verify: fix bytes_done accounting of experimental verify
  verify: fix numberio accounting of experimental verify
  test: add test for verify read back of experimental verify
  test: add test for experimental verify with loops and time_based
    options

 backend.c          |  8 ++++++--
 fio.h              |  2 ++
 io_u.c             | 23 +++++++++++++++++------
 libfio.c           |  1 +
 rate-submit.c      |  2 ++
 t/jobs/t0025.fio   |  8 ++++++++
 t/jobs/t0026.fio   | 20 ++++++++++++++++++++
 t/run-fio-tests.py | 31 +++++++++++++++++++++++++++++++
 verify.c           |  2 --
 9 files changed, 87 insertions(+), 10 deletions(-)
 create mode 100644 t/jobs/t0025.fio
 create mode 100644 t/jobs/t0026.fio

-- 
2.37.1

