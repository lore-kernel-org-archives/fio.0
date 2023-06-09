Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F97C7EE29
	for <fio@archiver.kernel.org>; Fri,  9 Jun 2023 23:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjFIX7S (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjFIX7R (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 9 Jun 2023 19:59:17 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A572FCE
        for <fio@vger.kernel.org>; Fri,  9 Jun 2023 16:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686355156; x=1717891156;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6wSEKFKPqPP877SLvMNT2m2os1VdP80CuQ93hRxCd+k=;
  b=lwfi8pg+YFLKuTaXDL+qNOTvfSekFM15DByfR9rJltBZwl/6rYGvc5c9
   yoszJYb25pm3D+9SNIGrjbVrGL3gRFe/CwneRJUmgsmVi2iYQJ0k+Lkzx
   A5qCr0lIwyAxkp1bHIVB2wqW6cvRpz4A26s1wzbtSh3kaJjjTNp6oI7/Q
   rV9aJsK1OiLH7Lw+kDSGrqvPW7SgWtFNv/9z17ge/oMPBbPcnJpbF258+
   R7tV5VKFTiY0dAcChts1NMXdF5dRXVg6NzdgFZajRLfr16LhVa1hxu0Cy
   0w5WeEMS2+DDw/jIpQBCxqwSkZFViDZ7WVZYUk4m5BgTEOw77zfKmpLZi
   g==;
X-IronPort-AV: E=Sophos;i="6.00,230,1681142400"; 
   d="scan'208";a="339721729"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jun 2023 07:59:15 +0800
IronPort-SDR: haWGgmkg2A2RGTq/1BiETOGq4khrZkuB0np84Nh3ZJdEmbFRZljBAz6/oTlGwPQAdUKQ8dMMsC
 pe1YPpO4W63HayHV6M2jQAEaMl7CMirAqKVvCJEl8ydI2oO3YY8Ck+XQ02VQP5Vb9TT4lNEIVA
 A1YtVY96My30YiHCrcYvLXbC2h2MUeVS4i9RuBbeYZ1wOLz+zM77svbTJQHfGLo5eHp5W/yHk2
 dbElyeJREfcmt27YL7ZtqnXcShbJZEAZCOePic7LkZJtLrCcHTb+k5l3gYhIiLInUlnkEK4F8e
 Ibw=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jun 2023 16:08:15 -0700
IronPort-SDR: nuebTnMz5affgGdiI3YqBr6xfV56URAG59imHlQPWI/y7yceE3TYk0ulkIowxfUh1LOyiDIxNb
 RT3N4fDsZF6qVXKhZYaRyEePtIOyn3+/PJokftXzu1lu8a+P+oqnKbSiR5qOWxl6aaPLiBIOQa
 icUkSb14s5/PkB0ffawPoktoJCpysUmEg7qNc5R3k2hLCaHID6/Xv1GV7i9qpfpMjUE490NLcx
 qeqnf+P60H/HnXCOY/3BvBJKtytktWSl9IsP0ku1oMHav9B/stSLLbW6ggClCK0cEsEOjFx9PE
 Sww=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip01.wdc.com with ESMTP; 09 Jun 2023 16:59:16 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] zbd: avoid Coverity defect report
Date:   Sat, 10 Jun 2023 08:59:14 +0900
Message-Id: <20230609235914.1376567-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Coverity reported a defect related to the local variable "in_flight":

    Using an unreliable value of "in_flight" inside the second locked
    section. If the data that "in_flight" depends on was changed by
    another thread, this use might be incorrect.

The variable "in_flight" is thread local and other threads can not
change its value. Then the report should be false-positive. Just to
suppress the report, change reference timing of the valuable.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index 9455140a..7fcf1ec4 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1547,11 +1547,11 @@ retry:
 		dprint(FD_ZBD,
 		       "%s(%s): wait zone write and retry write target zone selection\n",
 		       __func__, f->file_name);
+		should_retry = in_flight;
 		pthread_mutex_unlock(&zbdi->mutex);
 		zone_unlock(z);
 		io_u_quiesce(td);
 		zone_lock(td, f, z);
-		should_retry = in_flight;
 		goto retry;
 	}
 
-- 
2.40.1

