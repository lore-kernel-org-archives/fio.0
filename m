Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A91C433FE
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 06:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BC1A60E53
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 06:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhJMGLS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 13 Oct 2021 02:11:18 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:53721 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbhJMGLP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 13 Oct 2021 02:11:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634105352; x=1665641352;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KPekixaiGKVPLqZBMhqFbruiWD6U6RAZVoX5fZQlNhE=;
  b=HFD4ajDlxsDFWOPcpHHQ1MOkP+HijIRRx9ERn5a4BEcPbBQosNQ7/3rI
   IR3LSCdSjmpvN8oFZNp3bqrGjy+lhHrWu6VrY0mSCGzAgGLBBxdRr/2nH
   h4mKV9vMqipP8Sjzhx5Yz1rcGAYAK3MOcpVcHX49y/CaK+b6gtaRbh4qC
   vjtrT/1VKQ3Ie//MBX2zApi32TfkQRWj/isbYhcO1y/9YQ9WN9SbvOwE3
   kaqkDfwpI40OIuFNZk6Iynowzgj1q0fPeMWv9qOVi3ZUka0wAtNOE33iC
   46A1AFf1lDaNf+gq+8ERa1B3fHzcsbrwqLOH+ei/yt0toABxKZz9eAUOq
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,369,1624291200"; 
   d="scan'208";a="181718929"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Oct 2021 14:09:12 +0800
IronPort-SDR: TH4uJtg9iRWpNda9ii84dBwVCCcuGQZE8lb33zDTjGn3uQ5vKopI4Vh3fS8ZHSswTMWlZhFzNG
 LCn181J/WSbSWWF8sHkZNNlaIeUk4esiypuiwWNWm5uettqw5hWj9L98jfaMlY6+r3LBgmJtJ5
 1Afv0d0O4oZhKzJMQPxQcqVqXy78haHw2rLDryyClsz4q8K8SqZPDtUha/Iba0iDtLXYlKwtxE
 eqvj+sgO7G2nEJCQ4X0SFqNC9OoxifWfNVi35YWkOWFZaj3BMTgqtwiPWpEY+95b2msRvjnw7L
 TRDpZu/2x/pLp5K9tDy0xG78
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 22:43:25 -0700
IronPort-SDR: m7bfrdrknSTAuEwnWcd1+jxMwW/MIxEFW7vXdzBE39e0/L/BuKu4V3L+l3I3KwmwivcBwojoXZ
 09sspCjfwlFFVEtBVCqs45BVfzRZqohMTuIRftyyl7RsowrtgNIx2E15onDMeI+NUdKTWbPPAZ
 AelGEk/iK+BruWf+BwlTYCHA/cI/bXJQ7EuRFbTtPytWKYOWLuvZuNw/sqAeI6UpRAZa7vvPPP
 CKlTfyqM5n8F5lcGX/3CezldGyxI92S+XfdRJvQRdNgaegeCfoFnrWGOxK6LoUXA94ESSIBvhC
 J+Q=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.173])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Oct 2021 23:09:11 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 5/5] t/zbd: Add -w option to ensure no open zone before write tests
Date:   Wed, 13 Oct 2021 15:09:03 +0900
Message-Id: <20211013060903.166543-6-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013060903.166543-1-shinichiro.kawasaki@wdc.com>
References: <20211013060903.166543-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The commit b34eb155e4a6 ("t/zbd: Reset all zones before test when max
open zones is specified") introduced -o max_open_zones option to the
script t/zbd/test-zbd-support. It passes max_open_zones value to fio and
resets all zones of the test target device before each test case run
with write operation. This zone reset by the script ensures that no zone
out of the IO range is in open status and the write operation do not
exceed the max_open_zones limit.

On the other hand, since commit d2f442bc0bd5 ("ioengines: add
get_max_open_zones zoned block device operation"), fio automatically
fetches the max_open_zones value. So it is no longer required to pass
the max_open_zones value from the script to fio. To simplify the script
usage, introduce -w option which does not require max_open_zones value.
This option just resets zones before test cases with write operation.

Of note is that fio itself resets the zones exceeding max_open_zones
limit since the commit 954217b90191 ("zbd: Initialize open zones list
referring zone status at fio start"), but it just resets zones within
the fio IO range. Still zone reset by the test script is required for
zones out of IO range. Zone reset out of IO range by fio is not
implemented since it may cause unexpected data erasure.

Suggested-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 4ee46de3..7e2fff00 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -12,6 +12,7 @@ usage() {
 	echo -e "\t-v Run fio with valgrind --read-var-info option"
 	echo -e "\t-l Test with libzbc ioengine"
 	echo -e "\t-r Reset all zones before test start"
+	echo -e "\t-w Reset all zones before executing each write test case"
 	echo -e "\t-o <max_open_zones> Run fio with max_open_zones limit"
 	echo -e "\t-t <test #> Run only a single test case with specified number"
 	echo -e "\t-q Quit the test run after any failed test"
@@ -182,13 +183,14 @@ run_fio_on_seq() {
     run_one_fio_job "${opts[@]}" "$@"
 }
 
-# Prepare for write test by resetting zones. When max_open_zones option is
-# specified, reset all zones of the test target to ensure that zones out of the
-# test target range do not have open zones. This allows the write test to the
-# target range to be able to open zones up to max_open_zones.
+# Prepare for write test by resetting zones. When reset_before_write or
+# max_open_zones option is specified, reset all zones of the test target to
+# ensure that zones out of the test target range do not have open zones. This
+# allows the write test to the target range to be able to open zones up to
+# max_open_zones limit specified as the option or obtained from sysfs.
 prep_write() {
-	[[ -n "${max_open_zones_opt}" && -n "${is_zbd}" ]] &&
-		reset_zone "${dev}" -1
+	[[ -n "${reset_before_write}" || -n "${max_open_zones_opt}" ]] &&
+		[[ -n "${is_zbd}" ]] && reset_zone "${dev}" -1
 }
 
 SKIP_TESTCASE=255
@@ -1247,6 +1249,7 @@ SECONDS=0
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
+reset_before_write=
 use_libzbc=
 zbd_debug=
 max_open_zones_opt=
@@ -1261,6 +1264,7 @@ while [ "${1#-}" != "$1" ]; do
 	shift;;
     -l) use_libzbc=1; shift;;
     -r) reset_all_zones=1; shift;;
+    -w) reset_before_write=1; shift;;
     -t) tests+=("$2"); shift; shift;;
     -o) max_open_zones_opt="${2}"; shift; shift;;
     -v) dynamic_analyzer=(valgrind "--read-var-info=yes");
-- 
2.31.1

