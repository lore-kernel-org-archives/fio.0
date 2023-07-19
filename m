Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2174DEB64DA
	for <fio@archiver.kernel.org>; Wed, 19 Jul 2023 10:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjGSK6M (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jul 2023 06:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjGSK6L (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jul 2023 06:58:11 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8489E52
        for <fio@vger.kernel.org>; Wed, 19 Jul 2023 03:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689764289; x=1721300289;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8XgfxfaqWhLJcYyIzJWXBtpoSTnAYkAP2xf6I/nRgno=;
  b=MNKTu1I+FovZFyyeGiQ+NFoUJuhpXUbtt5savCgU7sBp15sxr8HPjxVy
   8JaElWzaeEJNPZ3v6u2aHv+VmHU0Ef7QT3m1mN+99th9gFYMK0b1zfnum
   o12W5PuWhyDGZWo9BNxe3VaKDDoT6tYBDqSJ3xIN2TMDGiKQAq32YM5XZ
   JEdxDxCuHKogoAw1uj1Kaspa2IpIXO1EmXf6WiTIDt8e/gnK8yNHBa43X
   gSFpJMxVPccKuRv7fwevAAqfEDqbQLih9xFgV+JgVXXs9Eu80tZulOGqH
   27ReMO25TlzCzq7l7XfkrMf6cEGiycSmrNTyvX4GyMmRRmLCOpi8lMjsz
   g==;
X-IronPort-AV: E=Sophos;i="6.01,216,1684771200"; 
   d="scan'208";a="236860338"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2023 18:58:09 +0800
IronPort-SDR: RctbxI4GgVRy2pOl8s63TypFhrMP7GIyn/LaSTqGn1Uf5NXA96tMs4mprYH5xrJ31mYCyLYSiQ
 HvZgtPMracUq3LxtU6VQYeLMbTQfaSTErTTOvjt2scUhJsC2voalf4pIYTw+YZt8pvb/RcQrq0
 eqAg/V1eS+4mOAFoDZEKCKX0eQkvSVTFU3dr6Ci5ss8uPg/O3Wb+YsCIERyeaecYEwjzjuEIpI
 UpiOF+UPARpjiOaSAyFQHAWcvVC6IFiPLxptkGKJw1dKFTnza9OUflIxOwAs2w5yBSLDDXpfLo
 cOQ=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jul 2023 03:06:20 -0700
IronPort-SDR: /cZ6exsKuzyTIHR0WTTXFxGGaWn3H/GF9K2l2Ff6smhtfV5AHFwS3yV+9b2F4EzzA+UklwqVCd
 6Lpu4/an6eJFXu5GaOt87nuJajzZQnyCWvVQrfkivvePb5TfIeMczLrL6E4IvVtfMaGppgiJsR
 /g7JEpOWlHr9Nsi8WGA/2Lt2GVgCZE7a3yaQ/jBdSFKmew4dKChuq3zVhmm36wjrOjLuPBMrvH
 rs9g4bD/csk2Yp+4lRQ/YWXValvrIy3B2E10cfFC687zwrgO3Mg+NiFtg1roqBtOQQvBI/6Xkp
 5nM=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Jul 2023 03:58:09 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 09/13] t/zbd: get max_open_zones from sysfs
Date:   Wed, 19 Jul 2023 19:57:52 +0900
Message-Id: <20230719105756.553146-10-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
References: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
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

