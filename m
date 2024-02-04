Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3606828DB7
	for <fio@vger.kernel.org>; Sun,  4 Feb 2024 21:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707081411; cv=none; b=RlknJh8lAhg/xVyd7ZmR9I6Dn/WO3SRksISjTKVcMRnKD5a6exGYJgpeMZdoUXBHdWEVTmIPy3tLgLNqOVU/7JSzpU2e4pn5nEVXo3HcsuYnCGOMqx7IYPYhZtle6lhdeHcJBTQyqXudswbpK+JPm3NVJXn/rtOPxOTr8Riqs2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707081411; c=relaxed/simple;
	bh=Phj87fPlxWquRvNYhTwr/S/HKVeQN+uSOOwCPiXd5M4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uI6euB1JFjfmMWxNF8ld2imZJq+kUBIQh/7oe3JXgSE2wUdFvew89aRSC2UcNJS7SuQXNtO0ifiRGN1NHGdMI0D1QJU7CSjG8DZVw1oZvYp+K2o7DdcGWQKHy/3qk+5vuoj3Qqei/8iRgai1w/znjVnTMy79Yn1ZkO0E7eRhR+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=cElE3uST; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cElE3uST"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1707081409; x=1738617409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Phj87fPlxWquRvNYhTwr/S/HKVeQN+uSOOwCPiXd5M4=;
  b=cElE3uSTvHlLRx6McE7Dz4JgQ/JHuV5PQAROTqih0i6Too1OZrroZz3+
   hyD61kRFR5aVoEYxX+mI/otFNsV5Do+nYJd9IdEql+5VuIWyILLUSOhVg
   Au6VZN3+MzhhPS2XIJjPp5jJRWGt1DRW2GudV8ZAZRC7KZiB0r5j/AnL4
   f0ezYsWpyGH7hXdmLc4pAmNzeIvF+eHAJ59Khbbgt3j/rKcgVujU7tlFz
   s1D9uTe5UXkNoYDku/NQEXU12dEtQu9lHwVgWarj31YNB3dsMg2J8rmIv
   HfRrRSEshIMl6WvuhvUAPB5K4dmatAAeIGde9o4nt5jT1SS0nnGlHLWlP
   Q==;
X-CSE-ConnectionGUID: j5LkYssHQZigg2oWFnQz0A==
X-CSE-MsgGUID: 4t4zGN2SSvavaWgJeFdnfA==
X-IronPort-AV: E=Sophos;i="6.05,242,1701100800"; 
   d="scan'208";a="8472769"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Feb 2024 05:16:45 +0800
IronPort-SDR: m8Ut8RBT4bXwR43V1yEPyp7TsYHULIsQLTYhigZbefkbTo5m0n3600REAVQmZJgSr4hR6lDwMF
 73+pfzn467yg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Feb 2024 12:20:51 -0800
IronPort-SDR: hLvbeu0BUalbwGV3wJFQkwHIwWXiljbrujyyJYoK4Mdl14rzHSq3A0dWppSVnya2yJ6KMfJhgI
 tbuER1mjYRLA==
WDCIronportException: Internal
Received: from unknown (HELO redsun50.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Feb 2024 13:16:45 -0800
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>,
	fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 4/5] t/zbd: check device for unrestricted read support
Date: Mon,  5 Feb 2024 06:16:36 +0900
Message-Id: <20240204211637.210199-5-dmitry.fomichev@wdc.com>
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

ZBD unit tests in t/zbd/test-zbd-support currently assume that the
drive that is being tested supports unrestricted reads, i.e. reads
that (partially or entirely) occur above the write pointer. This is
always the case with ZBD core code because Linux kernel always rejects
zoned devices with restricted reads. However, libzbc ioengine does
support devices with restricted reads.

The restricted/unrestricted reads feature is controlled by URSWRZ
device bit ("Unrestricted Reads of Sequential Write Required Zones")
which, depending on the device design, can be hard-coded to be reported
as 1 or 0 or it can be made configurable by MODE SET or SET FEATURES
commands. The unit tests need to behave correctly with any URSWRZ bit
value reported by the device if libzbc ioengine is used for testing.

Test #4 in the test script currently expects the device to have
unrestricted SWR zone reads. This test is guaranteed to fail if
the script is run against a drive that reports URSWRZ=0 with libzbc
ioengine.

Check if the drive has unrestricted read support enabled and process
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

