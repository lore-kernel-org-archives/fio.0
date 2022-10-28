Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED6DFFA3740
	for <fio@archiver.kernel.org>; Fri, 28 Oct 2022 11:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiJ1LyU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Oct 2022 07:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiJ1LyS (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Oct 2022 07:54:18 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFB21D2F53
        for <fio@vger.kernel.org>; Fri, 28 Oct 2022 04:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666958056; x=1698494056;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aDNU/9MdgzOhPi+txDEBsA6n3SMOS6DR33xQ0RBzdxk=;
  b=dCTfokIsKrtRd6nemKyiNAHBtL7n6APGzyP5UmbhL5fGX7JrCgZY0gdN
   sPHvphdGayraV/9iiyvhN5WJfnQU2DIvbTJSnFdL7e7pWJwT4vsrBkxdQ
   TMrKCCjSAcm1wtAkohaFdzUFB95nTFgnkWU+oRrSQPdMRi+yHySNrR2xp
   /UcSb4ID+ikpz0fC8C2u8kP74gdj8Zs6Vc2k29ZPazt+yrev/qhSQ0Hr/
   NsrFxUTO51Prq8GqwT025CmSCIWagdLAl96pWc5uqyOdXMRx3RqAJOCWV
   2TQJAn9NICmsrZnk6hgjDqbt0nA0AG+PIi4s5sJF9UG+W+JnLO8fgRSeD
   g==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661788800"; 
   d="scan'208";a="327074544"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2022 19:54:15 +0800
IronPort-SDR: 7M+xxLC0Jvj8g7qMZ4nD+QRrAUlC+crjzoxTF31AAfowzRdAghMMlphN4KX25D1hoSxjqC5Yuf
 AqqjohVhmX9jDKQdlkmSFQxSkWK7aDvQlIcxxk3FpZQY5LSzEHYuV9K8IBy2Z7adFxTeRJNsSF
 76rWsH7/8hOwwFPhp+VqHqQWHjS/XAbnqYE5Ymbwr9d0gIeo5e94LSy16mRc5GaItfw0/oYCON
 BYrx4zNTbsM/cZkbcoNTauyoiPWjPVK4yg5SZpyuf2hvdnwBHhwT1vYybybeven1KsyT/l1xDi
 JM1PaxFS8JD8n82vPLlFDVYX
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Oct 2022 04:07:52 -0700
IronPort-SDR: +tEXzIDn2EzPtXZUDTYqvXrh0ffQfYGx6fm/3vh2jw70b+Uf0Z3497h0IRk96Sr1fStD2te7Ov
 nbW451krWkMdDosIH9pn9huKBJ0quVuD3ljxp8j+Yyu0cpDJBdTUePvKUw1M8hMUaVduphtbKQ
 w8FLK7Eyo0jRn+8/aiafeJ43NQbsifReob8SXlPpkRrQtI2sLw7j8DIJS7dMmhMcVoQ9oA8hGD
 9zfD/snhs3byIfOICnVhtpKuVxn0ibfdV5Hz4mH+cfvRFM3zP8VYJJjY0PXWlIx4O1+2VRZzsC
 /xE=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 28 Oct 2022 04:54:15 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 12/13] t/zbd: remove experimental_verify option from test case #54
Date:   Fri, 28 Oct 2022 20:53:53 +0900
Message-Id: <20221028115354.971715-13-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
References: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The option experimental_verify does not work with zonemode=zbd. Remove
it from the test case #54.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 1 -
 1 file changed, 1 deletion(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 0e185997..ce4a5916 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1178,7 +1178,6 @@ test54() {
 		--rw=randrw:2 --rwmixwrite=25 --bsrange=4k-${zone_size} \
 		--zonemode=zbd --zonesize=${zone_size} \
 		--verify=crc32c --do_verify=1 --verify_backlog=2 \
-		--experimental_verify=1 \
 		--alloc-size=65536 --random_generator=tausworthe64 \
 		${job_var_opts[@]} --debug=zbd \
 		>> "${logfile}.${test_number}" 2>&1 || return $?
-- 
2.37.1

