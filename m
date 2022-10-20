Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A57BC4332F
	for <fio@archiver.kernel.org>; Thu, 20 Oct 2022 06:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiJTGjD (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 20 Oct 2022 02:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiJTGjB (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Oct 2022 02:39:01 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769CD1BE43A
        for <fio@vger.kernel.org>; Wed, 19 Oct 2022 23:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666247938; x=1697783938;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=df7oOal8E7cbXvqi0QJSxba5k2i4+TacORRW6kUje9A=;
  b=o+SoDVUfEDyDio5JiCKKaTfGA5yFuVwu9CdXoa2zUqf7UZlyWIvyvkrY
   kL/6VPb5tP0H2lBEE4yikOLIyAslyRccJLNWQghgss/2Vl6WVM+YVfI1d
   pBRhXLqPcHjjdOPHpfbW1dhdo5X3k1TS4f9N3evrZS4OMtZUQ3oORGe51
   nfY7XmPxYVjfZ2RukUUft1Jg8a7/o7/9XpX6zf878cLPMwHxg/xLr21D6
   FDk668VteiP69Ryg8jWKlY7SU0jihzcEzrL4paA/aaafvLfn3NkCBK8Pf
   TMxU/Izb6FLLHmCzyfG2NwBjFtB1UtD6IQspv0nOyFA9sggmYqf5pRPiZ
   w==;
X-IronPort-AV: E=Sophos;i="5.95,198,1661788800"; 
   d="scan'208";a="212615950"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 20 Oct 2022 14:38:56 +0800
IronPort-SDR: P3aOQquEGrkicc0l9UdpU5zHVSdYUGFFlwhUU/P/Fje8lzPTyJep52AYhTLOof7jbq/vQhRZPm
 TVa+k4ysXyntThuoan1rp3gbWz3gaQ/uUa7Ldats8f/+O8RU2Vx8AYrLZineozBudlEIkzgnxI
 neWsVLU15mS6bIWkPLACUbpZ5OgWNDapgpwSzTHwVoTYLDP0Y4fAQ8SQ4akTkT5BsMciorhAu2
 xW485y2xlIKABel96KfOo6m9dMsyhVaKQpXbI7Q7qRZbKi8shd6K5xzB5RM7SWBiSgXjhepYRu
 aj96bYeNVOHYrtlXmhSEtxi5
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Oct 2022 22:58:25 -0700
IronPort-SDR: pTPj3S7QHJfna7C20grlAn9GYQqTDNxX7AvH9ljXNBDZ/JDAMQTtWWMfP8RfbId2Iy/m958v7W
 REOURqTGuwbn4drFLph7eAre24x4ugrusD4WrGc8HW2miT7c7MO0ZcE+VQTlkPZnmOv7qyIxi/
 XiTIyJd5u5w55b36WPWgy981KrYfWE3eNMdLjAzSssQ8H4EHu2XoikrOoedjvWcRMMZb8J6CTW
 l0f/ciLMPGGr/sFRsHunaI9tGaTSkEUmH7R90pXkAn3uj8tQcjjgLxhYI7rzdCQnqpD+2/ak0p
 VHA=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 19 Oct 2022 23:38:55 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 0/4] fix experimental verify
Date:   Thu, 20 Oct 2022 15:38:50 +0900
Message-Id: <20221020063854.839158-1-shinichiro.kawasaki@wdc.com>
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

Changes from v1:
* Reflected comments on the list to patch 3 and 4

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

