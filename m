Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655E512EBE3
	for <fio@vger.kernel.org>; Tue,  6 Feb 2024 10:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707217156; cv=none; b=jVudzPCpf96u5BwUWSPH/sm4zHaLMHqyDjiNnjBRUqI4sriCwiLxfj4BgqzV6C6SC4RR+4tP/Dfvy/PxeWncExBCAQ4oFzlCgfH0AbqehH2VGY9Z08AXq2leM6Fk+rD1UZTM9tI3taNmzY/a3fLajGld34Oo1PcXPWPWcpWvzAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707217156; c=relaxed/simple;
	bh=xRl+1WN1reI1SWBLTBm47B+fzmx4G/kdM/mjLkRm9II=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TWok8GLtqq9IT7QCp8K1vv2YfJeVhuFrc8wMvKbojzGmRO/uH/P1Obdqi9MRQcAzQ8ow88CjkIVIuXSkPF+lPhkQBUOa5xB/tSX9YR13F/1QVVbgin6bEf1PG9x0wJJ01+Sh5ARMcKbFr+D4QeEtpCySx6LaxIEYh4tlLhYpsLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=PUxAKtcD; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PUxAKtcD"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1707217154; x=1738753154;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xRl+1WN1reI1SWBLTBm47B+fzmx4G/kdM/mjLkRm9II=;
  b=PUxAKtcDxjYZIvct/Zx4OC8WQicpe3Ywd2EcedDzF+8fnHwBOgniqf5+
   SnKfmE9pJu005hIlX4f84S2NX2wFrIN2DcQqQb63WzKtjEBPLvU6Q9hNi
   pmxJGGlvPM83pse/JId0wbT7WCXjmcll5D5HsYpCfWDQYsFHJyWUSLDKm
   Ny27zpCNogctUqhC+ZDGOAWiclxaeDLuZClbiEdlY/Q/xEdoKqwsl7Nvh
   xmCSAJYTm/CEuI4f3orzPRfrb4MHUb6tUbHVmaxlOB60/vFlGmf6QTaW+
   sNEvArZ8CZxs1OYZhbBemS36jljHq0WqIVoiwvQ9tD2gul8KA6I9i1a/U
   Q==;
X-CSE-ConnectionGUID: wNL9biy7QJWnNvvzlrJR4w==
X-CSE-MsgGUID: wR5TyUZDT0GYwWU5MsyMGA==
X-IronPort-AV: E=Sophos;i="6.05,247,1701100800"; 
   d="scan'208";a="8663352"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Feb 2024 18:58:02 +0800
IronPort-SDR: w2fctcgmFuLY/gcTvDT/EhPsST5eittlJNKb9G/TESx20OSpu/aP+0znzdAYwGcuzYkpvQXaof
 QI2jPybsnk+Q==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Feb 2024 02:02:08 -0800
IronPort-SDR: n4jpX80C4LD1izFSiQ7dtUFT1C+FpvlpslwSz/GGvhldChxn8BqHy3XFOBUDG435HBS8j8ku34
 f9a0GuBp2qow==
WDCIronportException: Internal
Received: from unknown (HELO redsun50.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Feb 2024 02:58:01 -0800
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>,
	fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 4/5] t/zbd: check device for unrestricted read support
Date: Tue,  6 Feb 2024 19:57:54 +0900
Message-Id: <20240206105755.214891-5-dmitry.fomichev@wdc.com>
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

ZBD unit tests in t/zbd/test-zbd-support currently assume that the
drive that is being tested supports unrestricted reads, i.e. reads
that (partially or entirely) occur above the write pointer. This is
always the case with ZBD core code because Linux kernel rejects zoned
devices with restricted reads. However, libzbc ioengine does support
such devices.

The restricted/unrestricted reads feature is controlled by URSWRZ
device bit ("Unrestricted Reads of Sequential Write Required Zones")
which, depending on the device design, can be hard-coded to be reported
as 1 or 0 or it can be made configurable via MODE SET or SET FEATURES
commands. The unit tests need to behave correctly with any URSWRZ bit
value reported by the device if libzbc ioengine is used for testing.

Test #4 in the test script currently expects the device to have
unrestricted SWR zone reads. This test is guaranteed to fail if
the script is run against a drive that reports URSWRZ=0 with libzbc
ioengine.

Check if the drive has unrestricted read support disabled and process
the outcome of test #4 accordingly.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 t/zbd/functions        | 22 ++++++++++++++++++++++
 t/zbd/test-zbd-support | 15 +++++++++++++--
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/t/zbd/functions b/t/zbd/functions
index 028df404..7734371e 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -290,6 +290,28 @@ min_seq_write_size() {
 	fi
 }
 
+urswrz() {
+    local dev=$1
+
+    if [ -n "${sg_inq}" ] && [ ! -n "${use_libzbc}" ]; then
+	if ! ${sg_inq} -e --page=0xB6 --len=10 --hex "$dev" \
+		 > /dev/null 2>&1; then
+	    # Couldn't get URSWRZ bit. Assume the reads are unrestricted
+	    # because this configuration is more common.
+	    echo 1
+	else
+	    ${sg_inq} -e --page=0xB6 --len=10 --hex "$dev" | tail -1 |
+		{
+		    read -r offset b0 b1 b2 b3 b4 trailer && \
+			echo $(( $b4 & 0x01 )) || echo 0
+		}
+	fi
+    else
+	${zbc_info} "$dev" |
+	    sed -n 's/^[[:blank:]].*Read commands are \(un\)restricted*/\1/p' | grep -q ^ && echo 1 || echo 0
+    fi
+}
+
 is_zbc() {
 	local dev=$1
 
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 532860eb..defb3652 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -412,8 +412,16 @@ test4() {
     opts+=("--size=$size" "--thread=1" "--read_beyond_wp=1")
     opts+=("$(ioengine "psync")" "--rw=read" "--direct=1" "--disable_lat=1")
     opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
-    run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
-    check_read $size || return $?
+    run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1
+    fio_rc=$?
+    if [[ $unrestricted_reads != 0 ]]; then
+	if [[ $fio_rc != 0 ]]; then
+		return "$fio_rc"
+	fi
+	check_read $size || return $?
+    else
+        [ $fio_rc == 0 ] && return 1 || return 0
+    fi
 }
 
 # Sequential write to sequential zones.
@@ -1664,6 +1672,7 @@ if [[ -b "$realdev" ]]; then
 		first_sequential_zone_sector=${result[0]}
 		sectors_per_zone=${result[1]}
 		zone_size=$((sectors_per_zone * 512))
+		unrestricted_reads=$(urswrz "$dev")
 		if ! max_open_zones=$(max_open_zones "$dev"); then
 			echo "Failed to determine maximum number of open zones"
 			exit 1
@@ -1681,6 +1690,7 @@ if [[ -b "$realdev" ]]; then
 		sectors_per_zone=$((zone_size / 512))
 		max_open_zones=128
 		max_active_zones=0
+		unrestricted_reads=1
 		set_io_scheduler "$basename" none || exit $?
 		;;
 	esac
@@ -1712,6 +1722,7 @@ elif [[ -c "$realdev" ]]; then
 	first_sequential_zone_sector=${result[0]}
 	sectors_per_zone=${result[1]}
 	zone_size=$((sectors_per_zone * 512))
+	unrestricted_reads=$(urswrz "$dev")
 	if ! max_open_zones=$(max_open_zones "$dev"); then
 		echo "Failed to determine maximum number of open zones"
 		exit 1
-- 
2.37.3

