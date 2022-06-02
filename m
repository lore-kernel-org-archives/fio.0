Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED513C43334
	for <fio@archiver.kernel.org>; Thu,  2 Jun 2022 09:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbiFBJNR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 2 Jun 2022 05:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiFBJNP (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 2 Jun 2022 05:13:15 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1A311142
        for <fio@vger.kernel.org>; Thu,  2 Jun 2022 02:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654161192; x=1685697192;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1CFxkvG7SWRqJJ9POP6zXCjShFvvCef1Fe/BhvhlPxQ=;
  b=Nh467ScA5lmAYJFIGDfNcqjwySxzl/Vs8RiRQ5/5sSZEK+AqqnwLAmg6
   OR4CH5s9HcxBGk0+FLvE7IeOaBLrukNTqD9D+3mRURlnr15KCz9eCbZ/x
   w7xI6A/IcyP2l+w4BtdSRVb3cwgqX82Z/ehMPFkdlrqJpMKojX30h4lEM
   ZDvazKnhuA48FRYMxRtFSqIPD8mXwhTARbSOUwiL4POkWHN3W4iip9OYH
   rXEvYAZVpQ7wPDw95QldiX+n4h58WkOJFSrjfZbwV148xndFS8zIPlFUj
   K1sD49a2l8TjxNiys3+jhpYYjlmOezfQURdiLjobIhcAp05y1iOePQ68u
   w==;
X-IronPort-AV: E=Sophos;i="5.91,270,1647273600"; 
   d="scan'208";a="202085937"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Jun 2022 17:13:11 +0800
IronPort-SDR: Caus5erm3hVYt2hp1+OE3oi8fLUhwv8KWgjxN/XmLfE0aJrRjHXdLRyp8FAbri0l+TnzMM4fAS
 lSt+PK1cWiRieBfM7x3nxpEcf057yoSOa0CfXe/CmQAQdyspSZFfg1Zq2tjR3IfqgBh7sjP8mP
 CkfdnLT+KPSSp/kJabP5BnUpt6MWTHJPDnEKlyWdMk548cifL+9S+Tre/jHwQ0xanBTkwSaDpr
 YB6WNUQAjKuxpZgFw72YxQSIApw7MAm2ZM4dVrU7Ncs65CyMdHkqPKUmm36IRC0QwUEnpVyz1R
 MFE3BgaGwHPO3SkJs1kOLFRm
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Jun 2022 01:32:21 -0700
IronPort-SDR: cywDYKbpjWmD4XplHQgPLVk/o2rJ+x/csH2wVTDHiXzKhZgP0HznPHprLmyJwcJ1W+CssQoMAL
 qlS2uxk+wDd65cMGGILf5CzYR1Z4hQ3qc2rrifDTMnOVbJnsR9US8VWEvmIMAs4DvzW4sEMuEV
 BeuV0cLYTl8HS/vVkQEP8y35E1sIkHg+o5wzl670RxqOZ9zWlhBoci3STXOudi//hNoxe5AxLQ
 F5v1D6j4YWnhtuu5WzKW4FglZkyl9iOqkPklFoHPpeh4O9rSJge5M1tIJRx/LG4Bq88E5aZcKo
 83g=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Jun 2022 02:13:11 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Vincent Fu <vincent.fu@samsung.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] t/zbd: skip test case #13 when max_open_zones is too small
Date:   Thu,  2 Jun 2022 18:13:10 +0900
Message-Id: <20220602091310.97189-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Test case #13 of t/zbd/test-zbd-support fails when the test target
device has max_open_zones smaller than 4. To avoid the failure, add a
helper function require_max_open_zones and use it to skip the test case
when the device does not have required minimum max_open_zones.

Reported-by: Vincent Fu <vincent.fu@samsung.com>
Link: https://lore.kernel.org/fio/20220602015316.6ismlexb22fwd5ko@shindev/
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 5190ae84..d4aaa813 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -259,6 +259,16 @@ require_conv_zones() {
 	return 0
 }
 
+require_max_open_zones() {
+	local min=${1}
+
+	if ((max_open_zones !=0 && max_open_zones < min)); then
+		SKIP_REASON="max_open_zones of $dev is smaller than $min"
+		return 1
+	fi
+	return 0
+}
+
 # Check whether buffered writes are refused for block devices.
 test1() {
     require_block_dev || return $SKIP_TESTCASE
@@ -462,6 +472,8 @@ test12() {
 test13() {
     local size off capacity
 
+    require_max_open_zones 4 || return $SKIP_TESTCASE
+
     prep_write
     size=$((8 * zone_size))
     off=$((first_sequential_zone_sector * 512))
-- 
2.36.1

