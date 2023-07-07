Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F56EB64DA
	for <fio@archiver.kernel.org>; Fri,  7 Jul 2023 03:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbjGGDPW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 6 Jul 2023 23:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbjGGDPT (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Jul 2023 23:15:19 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AFC1BDB
        for <fio@vger.kernel.org>; Thu,  6 Jul 2023 20:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688699718; x=1720235718;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8XgfxfaqWhLJcYyIzJWXBtpoSTnAYkAP2xf6I/nRgno=;
  b=MqyDJCQY3JCAKUWGb191oECRbWqFuJcWJ4eqcuykKDbcUlMUYw8stHSU
   Xt9qzBAlz32FpGQ0TAJl9BRGOK7iCAaESgm1E0USJsUO3h3U5fnqz13uI
   0BU02BgpK1Pk2C8vg6oqKNriBx1KPDWhQRQFfgbzm7AF/uRUwvxyXrDHp
   j4ZYbWZxNLgwO/EUOrRh9qYhS3oD9wHmCoBn1nE1YrlCrdpJWMsGM2OkO
   79KA/4VUHmkjx9XpukmJT4CoS2sba54FAvtE1HpQGI2GbDJRLwV/R8asW
   iUfldFKVTMG0P8esnVLLFm9pQdJQbYjRFWYkxR5Zdw0x0PeNGFQ+GK6FO
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,187,1684771200"; 
   d="scan'208";a="342468816"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jul 2023 11:15:17 +0800
IronPort-SDR: o+uHC2dP2UU2Aue51roxc2LYrC/lbwayadVmob91bzChgipXhsdstlFjRG1l0e/caVCkw3XMTh
 6wYn6I3yIsyrvGGG9Mp7gC30cdih01v2kXYcfiy5Uk1YBQ9HOe3GGNiMj1V5Tc+lk4iDda/gXI
 sX+u8Y+b074Cu+cys0aRqoDQWotSTf++bC8GX2wyhR8nYeM7KAi/W+bNtrQTXLaAioO4Flqcek
 C0mnIhkkyY85GlM4B0nRN5ezRAZ2lVtoZf/r5tkxXFm2cjMeCTrLKo6Nm6lGK+cAMxbhhTYf3p
 634=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2023 19:29:25 -0700
IronPort-SDR: Q+bUx1umuONnhv/IMiCXh1NkVpmRomY9T3udh0MEosMYA3qE1e8zST4+v1nos7kCAMpjivTBKD
 cQQKKFbvAurtdG3jRqwlT5P/kYiagre9WEm813ThNamuzCTroFvj0n/JrQaDmyYeNkq/0CFQCI
 SCNMW9NvYKVQCTzTu5Kmyv1bs/+VZgXfoEFoit0l95RozNJFk4YBhnuB3uHKh9zbHE67ZIQfYs
 9BMc8AuW4phYnsAlJZ6QLCP/zuMqTZEI119vGezSylWwz+/+bwF39Ot9t6zcPk/RC94lFUSF6j
 CUQ=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2023 20:15:17 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 09/13] t/zbd: get max_open_zones from sysfs
Date:   Fri,  7 Jul 2023 12:15:01 +0900
Message-Id: <20230707031505.3468915-10-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
References: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The helper bash function gets max_open_zones limit of the test target
device using sg_inq and libzbc tools. This works for SAS/SATA devices
but does not work for ZNS or null_blk devices. This results is running
the test case 31 with wrong max_open_zones value. Fix this by referring
max_open_zones sysfs attribute.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/functions | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/t/zbd/functions b/t/zbd/functions
index 529e7944..4faa45a9 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -212,8 +212,14 @@ last_online_zone() {
 # max_open_zones in sysfs, or which lacks zoned block device support completely.
 max_open_zones() {
     local dev=$1
+    local realdev syspath
 
-    if [ -n "${sg_inq}" ] && [ ! -n "${use_libzbc}" ]; then
+    realdev=$(readlink -f "$dev")
+    syspath=/sys/block/${realdev##*/}/queue/max_open_zones
+
+    if [ -b "${realdev}" ] && [ -r "${syspath}" ]; then
+	cat ${syspath}
+    elif [ -n "${sg_inq}" ] && [ ! -n "${use_libzbc}" ]; then
 	if ! ${sg_inq} -e --page=0xB6 --len=20 --hex "$dev" \
 		 > /dev/null 2>&1; then
 	    # When sg_inq can not get max open zones, specify 0 which indicates
-- 
2.40.1

