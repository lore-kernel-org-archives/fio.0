Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDAB3C433FE
	for <fio@archiver.kernel.org>; Tue,  8 Nov 2022 08:50:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbiKHIuE (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Nov 2022 03:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbiKHIuB (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Nov 2022 03:50:01 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3972ED56
        for <fio@vger.kernel.org>; Tue,  8 Nov 2022 00:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667897399; x=1699433399;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eemxvjaitJeYRs4iF0edUZBq4Lg1ZmE+JhmFpW7Sd50=;
  b=lum2NrZ7+VdJlWokiDPof313mWNC6vIXw29j10g+xwxMhJusqO8grswj
   hap5L4S/ITuzbg3LjA2SzhRikM3WfyusvoSZIIGh+lvHUHMup5EQbWAJh
   MNpuTLgF3j/4fN713FTljZHCSsM/KF1O6UgxnxSColdabGKWaMiEK9wWq
   iqFGNMmo6ZIQVe3itLZ7PM84JxHVWQTZpmeeEEEkWg41GFnKX7OoPgRUs
   azn8PHafDR8gZ4Ge2MXBg7SioYA47qG4ef7bgZhzYf5Z35aCj7IN2ffLM
   IilrQgxURkSN1OuJ473BVjVfIC6g/G3EKtMw8LJPkTE4TKP/tYg6a2an+
   w==;
X-IronPort-AV: E=Sophos;i="5.96,147,1665417600"; 
   d="scan'208";a="215743485"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2022 16:49:59 +0800
IronPort-SDR: mhUoRFJT/TEQ6VAZqvwF+lEqoP9heVE1tnHSN+hwEBUxbrjQDtvEgu+eF9+0sN7Q1GHjQ81B3r
 SZhq0TsC1BK3is49wHVy4b4L9/66l5jTSSHB+QGrHdcQsE0uoB6sd7quiIA41bYTXkSZq8a6/V
 u5ICiLjKrb7wa0nQ9fTWYMgjthaEj8Wbdnal6589mbNf7ZzX119JEljyRefSOKpHTwAsDenGki
 JvqBa8S9OK/kptgPDnCwriTMxcK58xVFsshFUPflTFOz6iKkw+I0RZiczPTPD7EuTqAs+F4qBY
 HHc=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 00:03:20 -0800
IronPort-SDR: 1gJhMn5HNihe6Cbodpcx3TQnVxvbzeIMgJuz9rEvc2xDKEhH3mzqmejdVynvev9/hSUgr1O2Pv
 E2vy39yDVb/QPWpSR0n/J04lyIdEZoUgxegGl3J63lNIzIj3fAIfsL6UHWUROs+QYm914IcKag
 ojfsAG4jmd1UQ99y0mf6efEXjUkBCYfanQ24P6Ih9gnzcruTGid/VvgUPH1k4pBnW0S3Kox2DJ
 NKqLpxdszq8Vc/xF3reoKBvZiE13VeH5tcN+QKbDum32mNx3s4Ss6nuNeE+s0Vzcirn5a+LNXn
 qk8=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2022 00:49:58 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 13/13] t/zbd: add test case to check experimental_verify option
Date:   Tue,  8 Nov 2022 17:49:40 +0900
Message-Id: <20221108084940.1574939-14-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
References: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
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
index 7b2a71a5..b383a3e3 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1293,6 +1293,14 @@ test59() {
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

