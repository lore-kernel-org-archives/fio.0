Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9917C4332F
	for <fio@archiver.kernel.org>; Mon, 14 Nov 2022 02:13:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbiKNCNr (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 13 Nov 2022 21:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235683AbiKNCNm (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 13 Nov 2022 21:13:42 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0AD6579
        for <fio@vger.kernel.org>; Sun, 13 Nov 2022 18:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668392019; x=1699928019;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hCS3RWeajyOI8oNJoU3XjXuiyxAE21C0JIU71fHGlgE=;
  b=Aogc/t3bYrV3McC8TxsXWYqGM3WccmfVOTbieX4dpoSW+RL/6XqUvkAs
   ibkN8SYuS+ieEpQQ3QRuccUr2dNkZ5UyrfAAGgIjklp0LuBtJWtpMvniN
   y8fa+fiDhPaI1rbvtHJqyglChnfwhSarWjEM7EQbmGLaWQ+JTZ6/Oz0Sp
   E5obkxKVASkzizB7W8zOgQNdizQiLQbeLX0wVX3SnlgQJmQ+nghMyOlRq
   qe73h2OSvZPTlV3Z12Ga4TDg3LcaVMDQLgI3PixELoZhwgx2OufZ2aT0g
   9VaM4phU+11Jgt4wojX61DuGy0zD09hZVYEiYrWVEMYKP+YfTCDubkIt2
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665417600"; 
   d="scan'208";a="328279252"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2022 10:13:38 +0800
IronPort-SDR: iQJUK6Oub8iZMg7mOGAhHi4QcO6QgF5MEmnr6Gm2StGzeJk3x5Zx1cwmWKKUm+kkkSHYVWvyOG
 0CKskUd8RDhsnySygCiAJAMYLKXDrW6PlDPkNtUks6fDrEV/M300NxTm/ZlNk5VkzFr6y1DD/Z
 7MaEs49Ucfet6shUbp9bIODumAX0wBz4xkCYXFj3t7n5T3dCUqLSJmXwZJoFyCKkxFGhpxjOsY
 PKS3ewMMN/40MyBLb7V8VR89QGrc/J0iOZMi+hkel3IHh0o0JeWqqgfOdIGk+Mm5jYZv6Gt3/v
 onY=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Nov 2022 17:32:37 -0800
IronPort-SDR: /b9fbr4Cf/vq//PuDmUjNL+XCdrPftA5a7JD7jM61RLHgd43cEhE1O2nrySHDpWuOtAZNsLCsu
 xtsM7LOmc+em77GH0RKr+d0FtlXeWAzgCxbuucWwsXsNLzunRfAJPdIhJzZ0gqNP4Z7TTeMQz9
 4TvOv0FZ2YwQzBOrYHeCQBCdFxse4V7pKj1cx9e0yBIh+eCFr+LKw8hmbwMkc19fNgqHIdR7De
 xAz9DfpNH7QG0y/tN20OYi5BMCXgs13Mb+265b6uYr6StkKrEmbUTzcmDkKbyN6NFF5ypQjxmx
 gbs=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Nov 2022 18:13:38 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v5 13/13] t/zbd: add test case to check experimental_verify option
Date:   Mon, 14 Nov 2022 11:13:08 +0900
Message-Id: <20221114021308.1684141-14-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
References: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The option experimental_verify does not work with zonemode=zbd. Add a
test case to check that fio errors out when the both options are
specified.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 5124296c..4091d9ac 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1297,6 +1297,14 @@ test59() {
 	done
 }
 
+# Test fio errors out experimental_verify option with zonemode=zbd.
+test60() {
+	run_fio_on_seq "$(ioengine "psync")" --rw=write --size=$zone_size \
+		       --do_verify=1 --verify=md5 --experimental_verify=1 \
+		       >> "${logfile}.${test_number}" 2>&1 && return 1
+	grep -q 'not support experimental verify' "${logfile}.${test_number}"
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
-- 
2.37.1

