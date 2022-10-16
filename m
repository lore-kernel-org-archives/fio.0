Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0232C433FE
	for <fio@archiver.kernel.org>; Sun, 16 Oct 2022 01:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiJPBnN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 15 Oct 2022 21:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiJPBnN (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 15 Oct 2022 21:43:13 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D71422D2
        for <fio@vger.kernel.org>; Sat, 15 Oct 2022 18:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1665884592; x=1697420592;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zDLz5Uv0NPyvSmTFdA66/uejnLYFviSDeW9raDEtPys=;
  b=FrM4EbjYWYbjY7Nlx9s7/cGE4iRCjgk93FHJGZriFhJT0i/bqNNJnpg7
   xKjADs7jx3S+0ERosEixR/wNH4uF+idXRDtAZGWSBMIqlbK62qJXKHLRk
   E9Xz/TWiv6+WE8gNxDLRrDbnYKbRL1SMni63799PFfxsMJGRtzxgu+nRz
   tDVhf8cYrjm1oRb362dKtpbAKZ9DCg0E24p4wN0A40nhMwJDk1akRJ3Mz
   bq63/2oxdirwVt84TAiicpEld38eQOMWwm8G58uB8uBkivEvGZP/W+eq0
   kqqrpebhW/EtGWk7NKS5P87akVY0xY5g9UtWPZouAbBkOWNsm6Rmg9gqO
   g==;
X-IronPort-AV: E=Sophos;i="5.95,188,1661788800"; 
   d="scan'208";a="326013704"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Oct 2022 09:43:12 +0800
IronPort-SDR: lt5ufDANgNZ21OCAr62JWnAByr2G446olyHu/w8V0e4C8p4N1VeAQACuGlalsI6hUQ417o3QQR
 f7AMjWiLSwXtJBlBD0iLC5O7khq+xV9U+AeDa6gdWEDgZ16tdtzOK/iA8o2yAHqTw25a/nKTxR
 PQpCKd3GxaounVRHrR9BdZcVwIIlKOOdoc5YFmi28Hwfc2/wJIysQPqj/qomrLXsdqg1P0DnIx
 O2wPhjxowflHiPNKx0cri9JvnhLo86XoibcpRf1BYHqT0+iBcz+6JROf7US9qmY6/4InCTLLfw
 m+wiwAApd6zLBHoR5FgTn9ap
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Oct 2022 18:02:46 -0700
IronPort-SDR: L8DDiESrYxUlYnpkB1mESjIFNEzwMYzX5VmgvQLlaoEAOByRWN9kXxOsX6mmK99vdkrhKE+4Sw
 t6/yqFwRtzIjsIROFtImuBWwYq1AFLadW1yLBpsmQLW1H+dh1g5x3lNUtKrUq2zKUayoK3UB1n
 tcaicwIf5EPnJXohb9QbrD/PwrHiWr12G/Ekjhboo8D7YnVZcHO393rNb+dF3156CzGTzPsast
 NS6tzxpZ7Jz0Md0y8NpCB8YNazqXdW/o3kLBJli377LNZRWcvkyT97Q+3XLOtqGckVrvyQ31Kh
 wdk=
WDCIronportException: Internal
Received: from unknown (HELO redsun50.ssa.fujisawa.hgst.com) ([10.149.66.24])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 Oct 2022 18:43:12 -0700
From:   Dmitry Fomichev <dmitry.fomichev@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 2/2] t/zbd: add a CLI option to force io_uring
Date:   Sun, 16 Oct 2022 10:43:09 +0900
Message-Id: <20221016014309.53682-2-dmitry.fomichev@wdc.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221016014309.53682-1-dmitry.fomichev@wdc.com>
References: <20221016014309.53682-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Many modern Linux distros don't include libaio-dev or libaio-devel
package by default and this leads to libaio ioengine being
unavailable in fio instances built at such systems.

Approximately one third of the test cases in the fio test script for
zoned block devices, t/zbd/test-zbd-support, use libaio ioengine.

In order to allow users to run the entire set of ZBD tests without
libaio, introduce a new command line option, -u, to the test script.
When this option is added to the script command line, all tests that
normally use libaio will be modified to use io_uring ioengine.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index d4aaa813..cdc03f28 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -17,6 +17,7 @@ usage() {
 	echo -e "\t-t <test #> Run only a single test case with specified number"
 	echo -e "\t-q Quit the test run after any failed test"
 	echo -e "\t-z Run fio with debug=zbd option"
+	echo -e "\t-u Use io_uring ioengine in place of libaio"
 }
 
 max() {
@@ -38,6 +39,8 @@ min() {
 ioengine() {
 	if [ -n "$use_libzbc" ]; then
 		echo -n "--ioengine=libzbc"
+	elif [ "$1" = "libaio" -a -n "$force_io_uring" ]; then
+		echo -n "--ioengine=io_uring"
 	else
 		echo -n "--ioengine=$1"
 	fi
@@ -1275,6 +1278,7 @@ use_libzbc=
 zbd_debug=
 max_open_zones_opt=
 quit_on_err=
+force_io_uring=
 
 while [ "${1#-}" != "$1" ]; do
   case "$1" in
@@ -1292,6 +1296,7 @@ while [ "${1#-}" != "$1" ]; do
 	shift;;
     -q) quit_on_err=1; shift;;
     -z) zbd_debug=1; shift;;
+    -u) force_io_uring=1; shift;;
     --) shift; break;;
      *) usage; exit 1;;
   esac
@@ -1302,6 +1307,11 @@ if [ $# != 1 ]; then
     exit 1
 fi
 
+if [ -n "$use_libzbc" -a -n "$force_io_uring" ]; then
+    echo "Please specify only one of -l and -u options"
+    exit 1
+fi
+
 # shellcheck source=functions
 source "$(dirname "$0")/functions" || exit $?
 
-- 
2.37.3

