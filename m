Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 147F3FA3741
	for <fio@archiver.kernel.org>; Thu, 27 Oct 2022 06:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbiJ0GDS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Oct 2022 02:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234283AbiJ0GDB (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Oct 2022 02:03:01 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3658415DB22
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 23:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666850557; x=1698386557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aDNU/9MdgzOhPi+txDEBsA6n3SMOS6DR33xQ0RBzdxk=;
  b=W6gzj9jDdIUwDjOyczio8Xd0XonZ3zF83JoB8EewV4K/x4ViY+rmxuKc
   lGclh9bTgL7jnRuYCeQk1KL1Sev7llWGD1r4A01sJBXmJa4tSbCTlKHeE
   r3ZuJCvi7UrKdkaSzI1CwptWxhVjGgp9hm3XEqPshhWVSuD6lyehxxvtA
   jYjgInNswHcE/4HrISVAsTkBFtCWWa8E4bxPy2JSUKG/MLuORId0xecb5
   jk+h1YTaxWBWJYuqrk0PH7Uk3AB1FRsw6P3nxAB8u3L9fzF9Kh3N1Czhl
   M+CG0XJejfAKkve3U+KjZ3z9bldwowXtzc9gJrYYLdWMvq3cNgyR2+MY/
   g==;
X-IronPort-AV: E=Sophos;i="5.95,215,1661788800"; 
   d="scan'208";a="319174472"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2022 14:01:57 +0800
IronPort-SDR: fDHP8mfZ+sCxm68SAQHMEyRmOlblR0ut9v11PkJCjWBsdBUvBOgXkT/52pEw3SyfM1fA0gWE5U
 9dYToFceYRRa61KXC7r3ioD4OnCGPlTh/hmqZ6aOmGq7g+WZ1qVwkD3DT9WyLlPmi63iiGEz0U
 DQCR1lHqYLG0KqZ1+hbiAT0OxX/Y9u53emthIPhZmoHFCPkJ3BRdOkIOYMFJWdh4SD7q4ndpu3
 OnGmsoNPk7aFdSfMpn71PeA7KCZHzmgDFGWOT+Py1BxyhBjkciGoBVX0ki9wspiWyKBe7fZyD6
 zKJghh45bi7LxVvRsV5fc2c5
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 22:15:36 -0700
IronPort-SDR: JvmXL2vyK1CDaMAHGauOPN8ju4dAJdBswGHQ8OhEEMqqLcdDGUSSOKXoWSp1X7jKhmIO+p8COv
 zq1ETAf4tNHVcxWlM3UdoBY2RjDtIRzpYOa+OVE5ElSR1jhIpoYZMH9VN7nTNU0aMIMJgDPZMO
 g4RVw1IFR0HRnrcfQtSjcm+3t2vG6aOKaOSvOuPDKjqiUGPz1E6B3LpBVXqnqaMJuSYtZqytz3
 ggP7c8TI7syH5zSPaAb6kfY8iB8aQSxbsU4UpWr+e7xUB3PIy3YB1yBkkufVzQpuB7+DkGbUod
 jmo=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Oct 2022 23:01:56 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 12/13] t/zbd: remove experimental_verify option from test case #54
Date:   Thu, 27 Oct 2022 15:01:38 +0900
Message-Id: <20221027060139.952508-13-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
References: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
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

