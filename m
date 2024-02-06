Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14A412E1FB
	for <fio@vger.kernel.org>; Tue,  6 Feb 2024 10:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707217156; cv=none; b=jmKw9w/bRKLcvQgYCBgi3WcP8JrPubAYiEfHd3yoXRIAaJHXVCVhJriK7uad/QSyteoT/v7XE2iq+tish9zov94+VrUQixrDidwUrT9A0viDiBQEPmA4dGKPlAdkSr8uEvNEklvrMUQ5uc5toN+BqNG4nqKC7KMTnKdYaK6Rpfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707217156; c=relaxed/simple;
	bh=JxXXNehHJX92IOopJUJf35Xi5OUsJB0iPZXkhIKWlsI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qA8bRa21ITGLy19LqpOgeqltcY2ymHUhHvW9XPzL1nzSoD1Xf177tpo4+H4T590Ir6HRnW5f2WtrUVqtxg2ZduFrs4JrqWZ0mdRaqUtq7ZqiYn9YV/eBIVaOHXpjJgEZ3HGlhspZiAKmcB8hHLjntdj67ByJW4lWDXFN5Iq/6xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=oUOmOiHa; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oUOmOiHa"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1707217154; x=1738753154;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JxXXNehHJX92IOopJUJf35Xi5OUsJB0iPZXkhIKWlsI=;
  b=oUOmOiHa8k4kFKW6WyGxQNK6+ZGr2hTJDfLIEm2fN+am3M2Ezl28isQ4
   gb3SO9bIw/nKm5ocVLMpF56BCy8gO2aK9D5V9Zld5KuXmfesLDwVFvSeo
   r53Kwt3BlqrKsS6UitopynqFwPg8gRRy9zsa6PRL5Kc1uTXQKYZc7opnL
   kmJX2iKwuHfJkKarDIk3gs4827xmuFhj+WF/gUhXOZmi4LVzjBZeOMe/B
   WhUje0b+zzJutnMkbC19kvwGxsiINSTlfY5tXApyrGK7bt67UbebceeJP
   YX2ctFtOVLuLnsch41Hazr8nyCOJZVILqsgSWFrPPhxo7M4GEvhzDKMd4
   Q==;
X-CSE-ConnectionGUID: 4WDQNvWnTzGcPBWJvwWsGA==
X-CSE-MsgGUID: YbaKcnkMTEm/An81mgX4/w==
X-IronPort-AV: E=Sophos;i="6.05,247,1701100800"; 
   d="scan'208";a="8663354"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Feb 2024 18:58:04 +0800
IronPort-SDR: orwXt17c7p14oSlyeSh42dXY1mQpVXuqT/5VI7a4LQ77xrNWMEPDa+S2+NucET4p9wmSUgF/ka
 YUtSHI+lK+Xw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Feb 2024 02:02:09 -0800
IronPort-SDR: MtHUKDTGDSY0FL7x+bOrECABRxpL0Q73DN4IyIPq+012ExzoRFNaofQEu3JH1i72ahBryg3W/f
 PHPS7UDFVr6A==
WDCIronportException: Internal
Received: from unknown (HELO redsun50.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Feb 2024 02:58:03 -0800
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>,
	fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 5/5] t/zbd: add -s option to test-zbd-support script
Date: Tue,  6 Feb 2024 19:57:55 +0900
Message-Id: <20240206105755.214891-6-dmitry.fomichev@wdc.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20240206105755.214891-1-dmitry.fomichev@wdc.com>
References: <20240206105755.214891-1-dmitry.fomichev@wdc.com>
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

