Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3102C433F5
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 06:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D266260E53
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 06:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhJMGLO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 13 Oct 2021 02:11:14 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:53709 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbhJMGLM (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 13 Oct 2021 02:11:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634105349; x=1665641349;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j0oXPZB1h63uNH7xb3sR36US72F2QnDCJJHlKL4oNic=;
  b=b0DuyL8ivaWsybaUNjlO8hUII3poGiS0oM4uTXC0bDwzWIJ2cchtl1BJ
   yNSsH1Z08wU1bS0q7J8DFxobRZBcRbKnLNeuHs6JNb1QTlTi4vcBmniEs
   7EBFQSN1b4CKDzKUtst5mVZMQ6C4LNHS9Ta1TFz8iiU4ecihzG09NKgZ6
   cMb3vgLbR5Q9q2hr8YKyts0oY4m/Qbc6kizCexz+/a0m+Acd2Prg9znYJ
   wFtBqsVvzqTseD4it3L5rPArZ3+1J2eJ4tffCxdbCnLI/nHrna9m3FWV1
   JCNBp11iwnhJvzxe8nSH2oLqGqE01sr3XMO3xZDIkO4EOxxWcId9JTFwx
   A==;
X-IronPort-AV: E=Sophos;i="5.85,369,1624291200"; 
   d="scan'208";a="181718920"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Oct 2021 14:09:09 +0800
IronPort-SDR: +IUICqXUWu53eZHTpZgdVXZarjvB1rxt/MN+Rh39c1FCLGjmbHZs7fSRTSkAZT9n8wScIbqx0Q
 J2fJ2OTmYNdGaBFohlK8F/mI80WW4K4nMo0R3ysm5vJoNeWgO2OOo/ODk9Rv/s9BjA9tQRGfLB
 uw2BQJo6IGY2lsV5cBJNY/VnrkQR6Hf9FmHTJ4T4jqLRHuLjZ9B/XMzCTCWAc8bqHboUmCSDDi
 hu7tDgntqAKb9RGWg6g/oJSJxoxhM1YImDV9YRgfoMXP/nu7UJfKYgzX9K0Zrpdq2FY5dBkjTX
 B9l9c4xJFOBm3TNAlDg22v4P
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 22:43:22 -0700
IronPort-SDR: 1m08+zsVdPKXaAJ8SfJ3RaE0idmU4nqIc35ujSN06FxuP1jrV167wGpduJk3yWUPf5dVPaUfFm
 0J1iukigM48XqYyDs6XBrDQA4ukVGfCFMePaQLuY5cP3iVLoPngsBbFd580rbpoFPsiJOawKWk
 +1kyEeRwy7xTel3FqnbzorGCUVF5N5b/g2CSKbdiPJLNSWtpQJJhpnbZOsuhLBFp7B1jNxzGTr
 //TrmHY5ypFmIB2axcfp8x8cni0TrUq8HB+0bV/nCmkfF4JlyyTXlexTw+7FcK444UhyClwOe5
 xQo=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.173])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Oct 2021 23:09:09 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 3/5] t/zbd: Do not use too large block size in test case #4
Date:   Wed, 13 Oct 2021 15:09:01 +0900
Message-Id: <20211013060903.166543-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013060903.166543-1-shinichiro.kawasaki@wdc.com>
References: <20211013060903.166543-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The test case #4 specifies zone size as block size to read a zone. For
some devices, zone size is very large in GB order, then single pread64
system call can not complete the request. This makes the test case fail.

To avoid the failure, keep the block size adequate. If zone size is too
large, use logical_block_size * 256 as the block size.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 5103c406..f9dc9001 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -310,7 +310,8 @@ test4() {
     off=$((first_sequential_zone_sector * 512 + 129 * zone_size))
     size=$((zone_size))
     [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
-    opts+=("--name=$dev" "--filename=$dev" "--offset=$off" "--bs=$size")
+    opts+=("--name=$dev" "--filename=$dev" "--offset=$off")
+    opts+=(--bs="$(min $((logical_block_size * 256)) $size)")
     opts+=("--size=$size" "--thread=1" "--read_beyond_wp=1")
     opts+=("$(ioengine "psync")" "--rw=read" "--direct=1" "--disable_lat=1")
     opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
-- 
2.31.1

