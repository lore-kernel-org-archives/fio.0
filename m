Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7281AC44D
	for <fio@vger.kernel.org>; Mon,  2 Mar 2026 02:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772418378; cv=none; b=fyF2s3p8B7EKtM+vKGwiI0VNa65Bu97YDeClc/2ET1NdTufHCNBeZsR2jZelela5+DGTAgOFWseT1DINMHaItVdLR6lzi1JAg2x5U7RDBX42rcpj9562zdsQk7kgyNaejHInJfJCzNFv0hjJpMndjWP/XYOv4xPPhSAbdXFpCWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772418378; c=relaxed/simple;
	bh=FAKXsKtUj0GKo0IF3B/AEuRNJ1lY0v2iCWmC4eksZU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1U5NF/hSbnFrFtQuTu2Su3TVUYVm4OkOteIMcnAgR0pYlBT2StSk+6XNRzylPZaJ/hQEqdGds5oNwpSUrR0MhANUmUvYoLS0ArJuTu4oGrEshaE+DSkI6lUqiYAd+QA9ry8X9AlUEWZK0PWTrDE17ent2n2sRPok7oS8Nxdp2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Cj5DD074; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Cj5DD074"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772418376; x=1803954376;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FAKXsKtUj0GKo0IF3B/AEuRNJ1lY0v2iCWmC4eksZU0=;
  b=Cj5DD074vo+l/Dlk+J0Gfy+MUJ2OlNw5fYHWQNfN3uh+n/KgCoQjE3LN
   wYBGJvLWiupoLwCQgbyrpDP2Fr/kPye5i1tZCAaZ7OSyvqYMdARGqIVHk
   OdI9NRs1OYixcuEDvN6OkhGKhZRJ0BfBqUt08Jv90GARenCnNyzZ861a2
   Pi2SwJbQWMyIejQLzJDoOosBuDjlrrseVCufXUJFm7WdpUB1ngJz8864p
   8FSocCX9EtyAcNUd57jTS5xg3gY97ai7Ox/MpUDX1GFhXdl2FG7mvK384
   ul+VxzxMiP/g3MOGUnt1+JPuzpPVYfs71dKs4n3wVWAhbVNnVmCVqkQy0
   g==;
X-CSE-ConnectionGUID: /JFgviVgQW2sdQTSxOwnkw==
X-CSE-MsgGUID: 3INGR4XzRre6bKG/HBU8GQ==
X-IronPort-AV: E=Sophos;i="6.21,319,1763395200"; 
   d="scan'208";a="141307952"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2026 10:26:16 +0800
IronPort-SDR: 69a4f548_4mF9Bh0CS/Ai4gB/oAqgDZiUIvOVgPf0gawfXD0qsAqc7HB
 mk7yMHglV5WH/qUyU0VaUjpxsYuZkiAxDjYlhwg==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Mar 2026 18:26:16 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 01 Mar 2026 18:26:16 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 5/8] t/zbd: add -m option to enable write_zone_remainder option
Date: Mon,  2 Mar 2026 11:26:06 +0900
Message-ID: <20260302022609.3526823-6-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260302022609.3526823-1-shinichiro.kawasaki@wdc.com>
References: <20260302022609.3526823-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The previous commit introduced the option write_zone_remainder. To
confirm the option works as expected, introduce the new option -m
to the test scripts test-zbd-support and run-tests-against-nullb.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/run-tests-against-nullb |  6 ++++++
 t/zbd/test-zbd-support        | 30 ++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/t/zbd/run-tests-against-nullb b/t/zbd/run-tests-against-nullb
index f1cba355..628e41a3 100755
--- a/t/zbd/run-tests-against-nullb
+++ b/t/zbd/run-tests-against-nullb
@@ -23,6 +23,7 @@ usage()
 	echo -e "\t-o <max_open_zones> Specify MaxOpen value, (${set_max_open} by default)."
 	echo -e "\t-n <#number of runs> Set the number of times to run the entire suite "
 	echo -e "\t   or an individual section/test."
+	echo -e "\t-m Pass -m option to test-zbd-support to enable write_zone_remainder."
 	echo -e "\t-q Quit t/zbd/test-zbd-support run after any failed test."
 	echo -e "\t-r Remove the /dev/nullb0 device that may still exist after"
 	echo -e "\t   running this script."
@@ -426,6 +427,7 @@ dev_size=1024
 dev_blocksize=4096
 set_max_open=8
 set_extra_max_active=2
+write_zone_remainder=0
 zbd_test_opts=()
 num_of_runs=1
 test_case=0
@@ -438,6 +440,7 @@ while (($#)); do
 		-L) list_only=1; shift;;
 		-r) cleanup_nullb; exit 0;;
 		-n) num_of_runs="${2}"; shift; shift;;
+		-m) write_zone_remainder=1; shift;;
 		-t) test_case="${2}"; shift; shift;;
 		-q) quit_on_err=1; shift;;
 		-h) usage; break;;
@@ -491,6 +494,9 @@ while ((run_nr <= $num_of_runs)); do
 		if ((quit_on_err)); then
 			zbd_test_opts+=("-q")
 		fi
+		if ((write_zone_remainder)); then
+			zbd_test_opts+=("-m")
+		fi
 		section$section_number
 		configure_nullb
 		rc=$?
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 40f1de90..01fb4dd3 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -13,6 +13,7 @@ usage() {
 	echo -e "\t-l Test with libzbc ioengine"
 	echo -e "\t-r Reset all zones before test start"
 	echo -e "\t-w Reset all zones before executing each write test case"
+	echo -e "\t-m Write zone remainder instead of zone finish operation"
 	echo -e "\t-o <max_open_zones> Run fio with max_open_zones limit"
 	echo -e "\t-t <test #> Run only a single test case with specified number"
 	echo -e "\t-s <test #> Start testing from the case with the specified number"
@@ -202,6 +203,30 @@ has_max_open_zones() {
 	return 1
 }
 
+has_zone_writes() {
+	local has_zonemode_zbd=0
+	local has_write=0
+	local word
+
+	while (($# > 1)); do
+		if [[ ${1} =~ "--zonemode=zbd" ]]; then
+			has_zonemode_zbd=1
+		fi
+		if [[ ${1} =~ "--rw=" ]]; then
+			word=${1}
+			word=${word/--rw=/}
+			if [[ $word =~ w ]]; then
+				has_write=1
+			fi
+		fi
+		shift
+	done
+	if ((has_zonemode_zbd && has_write)); then
+		return 0
+	fi
+	return 1
+}
+
 run_fio() {
     local fio opts
 
@@ -215,6 +240,9 @@ run_fio() {
     if [[ -n ${max_open_zones_opt} ]] && ! has_max_open_zones "${opts[@]}"; then
 	    opts+=("--max_open_zones=${max_open_zones_opt}")
     fi
+    if [[ -n ${write_zone_remainder} ]] && has_zone_writes "${opts[@]}"; then
+	    opts+=("--write_zone_remainder=1")
+    fi
     { echo; echo "fio ${opts[*]}"; echo; } >>"${logfile}.${test_number}"
 
     "${dynamic_analyzer[@]}" "$fio" "${opts[@]}"
@@ -1877,6 +1905,7 @@ reset_all_zones=
 reset_before_write=
 use_libzbc=
 zbd_debug=
+write_zone_remainder=
 max_open_zones_opt=
 quit_on_err=
 force_io_uring=
@@ -1892,6 +1921,7 @@ while [ "${1#-}" != "$1" ]; do
     -l) use_libzbc=1; shift;;
     -r) reset_all_zones=1; shift;;
     -w) reset_before_write=1; shift;;
+    -m) write_zone_remainder=1; shift;;
     -t) tests+=("$2"); shift; shift;;
     -o) max_open_zones_opt="${2}"; shift; shift;;
     -s) start_test=$2; shift; shift;;
-- 
2.49.0

