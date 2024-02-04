Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A0F28E3C
	for <fio@vger.kernel.org>; Sun,  4 Feb 2024 21:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707081411; cv=none; b=BIGsemKCExhybKM5dkp/6VU7+ic4VH5PL//l6o33wuz8aZ3eTBEbOxlBlmVMlz8g03pUIzpsXnhprV+8rRKCr7V1Uq7geSF03f7HZZiOSJeDe2KUpZjKpA+IKpT6xfEtKMCg1v9rNh3dey5pxM0J9etbpHHHxSkO38UjzujHmfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707081411; c=relaxed/simple;
	bh=JxXXNehHJX92IOopJUJf35Xi5OUsJB0iPZXkhIKWlsI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D7hQZDvwG1QZLuYvxCOHdF+xdJMK+y4MMWvPA3PPVS9Gnbvx0wEnNlUZzyeQDZvkYoUbUveFn8027HrUynTkzielkKB7jhZ4kkLlu6bFuD5xuixK5UfXvf0G8gMt/0BdO7F8ctb3jOv/RpyGacFBRfUq/rxUCFuKh8DtxK3LvOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hJFULoP9; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hJFULoP9"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1707081409; x=1738617409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JxXXNehHJX92IOopJUJf35Xi5OUsJB0iPZXkhIKWlsI=;
  b=hJFULoP9IaeNUv+Y8OPT6GgIrMP0yelEnJFTK89wJccjAwnkcXCwyOn+
   fOYPI02EnGPD82siW0V/d7TLJCuFu5oAXO9jA42jtSt8KGCRZfXT/EiUC
   OeKuVPDhvbX+2aDcOaNYC1K1+HzCvyL18OU6BhJayOotlqH04Rs334HvD
   q2aZqAFW3dayGDIutyqmqAOlibe9eBICQDfJ6VpP4KYGFUfdo8HT0SaPb
   2i/Wz0m79QaCH7kTHlXyP1NToM6MwyIX2GVKVzg5uXQwgsD0dBgL/COjA
   YFp8ZamNOze06zwXJHxf1wo6W6SozJBjzauAYGT/cUrvCIXJV8cxYZB4C
   A==;
X-CSE-ConnectionGUID: aB36EbGSS1+p+UPe/FJcHA==
X-CSE-MsgGUID: chx0bbumQHiab+fm5FWM0A==
X-IronPort-AV: E=Sophos;i="6.05,242,1701100800"; 
   d="scan'208";a="8472775"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Feb 2024 05:16:47 +0800
IronPort-SDR: t9Ozz/wI3EMitcANZqbNI96i0qbSdctSj6pFcrRTmqTx1F/n04qhvHDiZbhNaB6y4TPXmSryAK
 eJbtKms5A49Q==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Feb 2024 12:20:53 -0800
IronPort-SDR: zw2mTwLAsrxjZeIsfYSijxM01p0eP2cO8reZVbhYf2sIKWvwIhnoBVZ+NzUg3dSd2TBScwdqq1
 IiggThbZk24A==
WDCIronportException: Internal
Received: from unknown (HELO redsun50.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Feb 2024 13:16:47 -0800
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>,
	fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 5/5] t/zbd: add -s option to test-zbd-support script
Date: Mon,  5 Feb 2024 06:16:37 +0900
Message-Id: <20240204211637.210199-6-dmitry.fomichev@wdc.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20240204211637.210199-1-dmitry.fomichev@wdc.com>
References: <20240204211637.210199-1-dmitry.fomichev@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The total number of ZBD tests in test-zbd-support script has grown
considerably over the years and zoned drive capacity has significantly
increased as well. Today, the test run duration may reach one hour for
large drives. If a terminal session failure happens during a run, it
is more efficient to restart the tests from the point where the last
run stopped rather than from the beginning.

Add -s option to the script command line to specify the starting
test number.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/test-zbd-support | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index defb3652..c27d2ad6 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -15,6 +15,7 @@ usage() {
 	echo -e "\t-w Reset all zones before executing each write test case"
 	echo -e "\t-o <max_open_zones> Run fio with max_open_zones limit"
 	echo -e "\t-t <test #> Run only a single test case with specified number"
+	echo -e "\t-s <test #> Start testing from the case with the specified number"
 	echo -e "\t-q Quit the test run after any failed test"
 	echo -e "\t-z Run fio with debug=zbd option"
 	echo -e "\t-u Use io_uring ioengine in place of libaio"
@@ -1602,6 +1603,7 @@ zbd_debug=
 max_open_zones_opt=
 quit_on_err=
 force_io_uring=
+start_test=1
 
 while [ "${1#-}" != "$1" ]; do
   case "$1" in
@@ -1615,6 +1617,7 @@ while [ "${1#-}" != "$1" ]; do
     -w) reset_before_write=1; shift;;
     -t) tests+=("$2"); shift; shift;;
     -o) max_open_zones_opt="${2}"; shift; shift;;
+    -s) start_test=$2; shift; shift;;
     -v) dynamic_analyzer=(valgrind "--read-var-info=yes");
 	shift;;
     -q) quit_on_err=1; shift;;
@@ -1694,6 +1697,7 @@ if [[ -b "$realdev" ]]; then
 		set_io_scheduler "$basename" none || exit $?
 		;;
 	esac
+
 elif [[ -c "$realdev" ]]; then
 	# For an SG node, we must have libzbc option specified
 	if [[ ! -n "$use_libzbc" ]]; then
@@ -1772,6 +1776,7 @@ trap 'intr=1' SIGINT
 ret=0
 
 for test_number in "${tests[@]}"; do
+    [ "${test_number}" -lt "${start_test}" ] && continue
     rm -f "${logfile}.${test_number}"
     unset SKIP_REASON
     echo -n "Running test $(printf "%02d" $test_number) ... "
-- 
2.37.3

