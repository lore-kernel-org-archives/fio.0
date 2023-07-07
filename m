Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0597C001DC
	for <fio@archiver.kernel.org>; Fri,  7 Jul 2023 03:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbjGGDPR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 6 Jul 2023 23:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjGGDPO (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Jul 2023 23:15:14 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B36C1BD2
        for <fio@vger.kernel.org>; Thu,  6 Jul 2023 20:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688699713; x=1720235713;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ubMjELsAIahCLVZlcxFW1Ddte/7i8ofio7tf8KQsjpk=;
  b=gyyM9ryDHY3tdN9nYLKBCWOLbAv+1bapj2EbdT+DSy4o1Oi/ns3YcNmF
   mI+Z33k0i8YdwMtQEGtWLb+/zZLLZLDJe+XUoLlb8vX8NRliqca54pTLW
   XJhy9P1analhIjr+k0byL4SPLb3Hyhj1F/U/BGQXG7gg5Z6U3N4l5eB76
   3R1GtjWbV3sctZjhlXt4asUs9BFfQtGqZvkzkRBBkqmQ0yewh1qy1obS6
   hPkCIoDNGfzFilzZuTu1dB7LEYl/9BXSyU22eHMdn+UgCDXj3NCHPNkNj
   CrNi79mkkjppcrgWuAWoOhwvo9pG32RRq9QRr+hhiffjN8rnTAcmIwQqL
   w==;
X-IronPort-AV: E=Sophos;i="6.01,187,1684771200"; 
   d="scan'208";a="342468802"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jul 2023 11:15:12 +0800
IronPort-SDR: eeCLTbvC4TPWV7Q+hyjlXRVBFq4MwEGALwOxNzliWWZ3dGojU4FUz7/5x5YPmeJegefzHloH8H
 uXdF2E7EFJn+yolGWLEpmYqPUU3clg07ZDUoJ47Bd7qSX/JJ4WGY/TYemRAZFj6uPYHv6Lz/8C
 ltthb8KaFBivPucVztjzxQhMvs/V3ZUvoXge+S00PdXxVyeSbK0ZhocV6VDi0Xmi4mLGZFrFQ+
 Dx4ZvwkDiQnMbMjigTH1DmDCZe5c5skpOu8QbOz9arH9FO3NHEre195eGk3tQ3cTbcq5clVB9w
 CxE=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2023 19:29:20 -0700
IronPort-SDR: XyGZpTVWc4imB63sX7aCbtD2RcPHAj8A67mYjLdbl+tteVzFfyOB1OMjfcR4GTiIU4kzUgPhAe
 ozS/BH1X6alGTDZtNMxFjGTeB6LibEDSX8PQZ25+j8rRLhKyOlsIZtxKEnTMr2C/9lUPXkpNKu
 mYEAVTUv/VAaxxfWo3crUGdTysPA3aoxoC8lC20rKXZCxXLZcP1Y5iWPREPePjdXdVro7Pz6rp
 sz+ahws0hTShMgEGFVRKq6SorqnwFI2lC7r50xvxCV/euPfHuMEPjP44TF/+WHtq50WygJhvkA
 HUs=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.53.55])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2023 20:15:12 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 05/13] t/zbd: add close_zone helper function
Date:   Fri,  7 Jul 2023 12:14:57 +0900
Message-Id: <20230707031505.3468915-6-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
References: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add a helper function which sets the specified zone in closed condition.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/functions | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/t/zbd/functions b/t/zbd/functions
index 9a6d6999..fe5b3397 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -4,6 +4,7 @@ blkzone=$(type -p blkzone 2>/dev/null)
 sg_inq=$(type -p sg_inq 2>/dev/null)
 zbc_report_zones=$(type -p zbc_report_zones 2>/dev/null)
 zbc_reset_zone=$(type -p zbc_reset_zone 2>/dev/null)
+zbc_close_zone=$(type -p zbc_close_zone 2>/dev/null)
 zbc_info=$(type -p zbc_info 2>/dev/null)
 if [ -z "${blkzone}" ] &&
        { [ -z "${zbc_report_zones}" ] || [ -z "${zbc_reset_zone}" ]; }; then
@@ -304,6 +305,18 @@ reset_zone() {
     fi
 }
 
+# Close the zone on device $1 at offset $2. The offset must be specified in
+# units of 512 byte sectors.
+close_zone() {
+	local dev=$1 offset=$2
+
+	if [ -n "${blkzone}" ] && [ -z "${use_libzbc}" ]; then
+		${blkzone} close -o "${offset}" -c 1 "$dev"
+	else
+		${zbc_close_zone} -sector "$dev" "${offset}" >/dev/null
+	fi
+}
+
 # Extract the number of bytes that have been transferred from a line like
 # READ: bw=6847KiB/s (7011kB/s), 6847KiB/s-6847KiB/s (7011kB/s-7011kB/s), io=257MiB (269MB), run=38406-38406msec
 fio_io() {
-- 
2.40.1

