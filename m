Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E18C433EF
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 06:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E30A60E74
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 06:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhJMGLJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 13 Oct 2021 02:11:09 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:53709 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhJMGLI (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 13 Oct 2021 02:11:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634105346; x=1665641346;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KLMjlN6wjqaD+/itKKor/omLDHEgBmoCsK14vNc5e/4=;
  b=c4F0l3KVgR2OPZCRXdrNzqPqy7aW8sCMeDfaLsYxXjTB4/5ZKsphaeOG
   xF7iks2MTcxiv+cr89EdvaEuS3ByTMoiHHfaor/68xeJqLFfo5/7Kfro7
   zYBTXnpRgpBLkD31Zt85zFF4KUSrS+2rsOVn03e5cZW3eTprbxSP4fFk+
   lAjUd/URD5ZP17WTHJdYuLdbgsIANuRoSIfeEMxeTAPG4AHda8Owr9akQ
   mwpEbwaGu4kgINHnYcId6LOBaoBDE8mF+mnpxG8XDMxe6zgbCCtUsUqqz
   cZQGD39DCL06RN5EUJZQIQfrR44H4BpNlTatF4w/3UwvJd7P6Za42On8Z
   w==;
X-IronPort-AV: E=Sophos;i="5.85,369,1624291200"; 
   d="scan'208";a="181718909"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Oct 2021 14:09:05 +0800
IronPort-SDR: aGGLqxbXM0qBmK535Iw1d8tttSoi0vlxUEIAUjv6EBJpJAwhnXvoIR6XO5KexMdYRmgEsxX1Zd
 bHCZOmIVN5iFPtygtkx1HWT/oLXkKnl8Dxuw+MwxXI+xnMfwq2msLSSGD5zq9lc+KGEOXZ16cT
 gLVav86Xh5IZdU/D22yni/7hbDerJPAlEMJlDnNLqOCcY4fP5TI3M8AHjHBQSY5F928iWRImdW
 TFM1PzCG0jgVnOC9vnwgphNMF2Cqv9WoX1xFt9hj3bD6atMy6MJK6c1UDynH6TEwDWmkCF/7fK
 5GqH3FyUTdtmWAh5jE31t7XA
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 22:43:18 -0700
IronPort-SDR: IfXET+ibavmi+1kNGYppPErWmJSHG8tHR+c8bVaKDiypw15BWnS328sozMC0zwthDXeIfFJuTH
 RoqMh2usVEkK6E79PamLHsrmv2hCDQ8A/9xS25fCueSNqjnDbdbx9zjPDBIV7/uUS/Z1VoHLrz
 OFj4e3AYMfue0X9R9o6oQiyauy8jsH10yYBcawfKhZ3GS0NzqN0nYbf6DPUWxl4yIbdqg5fqsA
 Wf46PiNkgFK112M/2i0Q5BxsH5mMRa+wFVlolPBifVIXhDKVn06tEFE52LFQWgsTG4dHZeD/Wq
 Rl8=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.173])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Oct 2021 23:09:05 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/5] zbd: Fix failures unique to specific zoned devices
Date:   Wed, 13 Oct 2021 15:08:58 +0900
Message-Id: <20211013060903.166543-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Recently test case failures of t/zbd/test-zoned-support were observed, which
were unique to specific zoned block devices. Several test cases fail when the
device has large zone size in GB order. Some test cases fail when zone capacity
is unaligned to block sizes. Some other test cases fail when the zoned block
device has strict open zone resource limitations.

This patch series addresses the failures. The 1st patch is a preparation for the
next patch. The 2nd and the 3rd patches fix the failures observed due to large
zone size. The 4th patch fixes the failures observed due to zone capacity
unaligned to block size. The last patch adds an option to the test script to
support strict zone resource limitations.

Shin'ichiro Kawasaki (5):
  zbd: Remove cast to unsigned long long for printf
  zbd: Fix type of local variable min_bs
  t/zbd: Do not use too large block size in test case #4
  t/zbd: Align block size to zone capacity
  t/zbd: Add -w option to ensure no open zone before write tests

 t/zbd/functions        |  26 ++++++++++
 t/zbd/test-zbd-support |  40 +++++++++------
 zbd.c                  | 107 +++++++++++++++++++----------------------
 3 files changed, 100 insertions(+), 73 deletions(-)

-- 
2.31.1

