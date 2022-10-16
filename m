Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 878CDC4332F
	for <fio@archiver.kernel.org>; Sun, 16 Oct 2022 01:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiJPBnN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 15 Oct 2022 21:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiJPBnM (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 15 Oct 2022 21:43:12 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8B6422CD
        for <fio@vger.kernel.org>; Sat, 15 Oct 2022 18:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1665884591; x=1697420591;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YAPSoSn8oFuJdhIaYJBnJ5sG6IXEQKohX0M9wc81f8A=;
  b=oPzrjMAVIfSTNZHAI3xKrvglv3tRmafYdnbxEI0WJ8Sx3xfA9tVx4frj
   JBzmxpZM/v3PeMnKi68Lx3G5rwPijrRqTBARxyWfPb9b8U6F3njnbXgPo
   gpN/eR7IA2MOUDZVgHyhYOWZ8dJZ9NtpI+OuPBoZXBia5NbHPWu/87wwD
   muSWolhd7VCGcNFFeZX611oc7Vi3iwq3DO5LRuGe811nvc0wtKi2eYIiE
   2WO9WbUABbwa8hvIUk/AuTyDRP/FraKYIEn1ZKnGQ4qgHR239+P584ARu
   IXcTKtIU973mwvhR77LXBiM6P6bWuCvrTZyLea3TsuWITYFrEAj9cdGSE
   w==;
X-IronPort-AV: E=Sophos;i="5.95,188,1661788800"; 
   d="scan'208";a="326013703"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Oct 2022 09:43:11 +0800
IronPort-SDR: 8qXI0w7SbEgNCxCZfxhOEA0iOocHVuiLIOLHQdAKhJ4JNkZ3aE9Ur3inIulZx2GtlSQ3VJgN/f
 i+X93LHfsVSWN7p6BqayILxm/H4JMp6ntOPbeT3K9OiDDnReGV0mmzE3IOW1yUs7DzZAQo8Afb
 TnPWn3FDXNlyxA+gkaZh75eQiWgvbzJU+4fzunk/AsTPaJxD8mwx1aLqN6Wnhp2dmv9M7+Ljma
 C8+W52lZj/BDtYIsGHv7bP6gAiw1Y1jQzmn8ehwrTkiJQUCWj8hhskgZb2ac9haUJziHyzXKSu
 VM17aB2bFhOji/f1eCQFpMO8
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Oct 2022 18:02:45 -0700
IronPort-SDR: GK/71IXnGbuch3L3WQ6F4D+M5kQwV/vQQhsSxHsmFJsYhYFwo5jHRfrnkf8iA+IqDeP4ROaNwA
 XDFBgHi7J9pkJgg1ypslKGpGrZmMkTj13Yko1IFlKXjrIMhsVZI3Ew7n+hJ5fwwCc3wJPeXwIS
 jF/X3XiNjWREKPwVG7k5XACVh3KOJn/pUaTVAr8D78b+kmzn/dwZVUf1voOChpTeFftHU4cCMk
 pfGwdIYGBbhyTvjkKOTGq8fST1NdSHDVt1+ANlyhf66KoXBdKJbhkC5ublPvY86nBdYla1fOLn
 EWI=
WDCIronportException: Internal
Received: from unknown (HELO redsun50.ssa.fujisawa.hgst.com) ([10.149.66.24])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 Oct 2022 18:43:11 -0700
From:   Dmitry Fomichev <dmitry.fomichev@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 1/2] t/zbd: fix max_open_zones determination in tests
Date:   Sun, 16 Oct 2022 10:43:08 +0900
Message-Id: <20221016014309.53682-1-dmitry.fomichev@wdc.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The test script erroneously falls back to using libzbc for finding out
the max_open_zones setting if the device being tested is not a SCSI
device. This causes false positives if libzbc is not installed in the
test system. To fix, unless the option to use libzbc is explicitly set,
set this value to 0 for non-SCSI devices to let fio find the actual
max_open_zones value using the system block interface.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/functions | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/t/zbd/functions b/t/zbd/functions
index 7cff18fd..812320f5 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -230,9 +230,11 @@ max_open_zones() {
 		    echo ${max_nr_open_zones}
 		}
 	fi
-    else
+    elif [ -n "${use_libzbc}" ]; then
 	${zbc_report_zones} "$dev" |
 	    sed -n 's/^[[:blank:]]*Maximum number of open sequential write required zones:[[:blank:]]*//p'
+    else
+	echo 0
     fi
 }
 
-- 
2.37.3

