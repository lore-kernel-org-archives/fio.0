Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE8423DD
	for <fio@vger.kernel.org>; Wed, 20 Dec 2023 00:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RfDKC7Gm"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1703033938; x=1734569938;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bvGuqU4blxOTXHvCWZ7v81YbcUWC10qyQMs+TumaCqQ=;
  b=RfDKC7Gmg2Az73aloyaFn0yNVKjlOZji2QrE9ZtLJ+6iW6j31or6kjDf
   k9G4PTpIXT/SseQN73JKTLNAfFA5VW7z4qBbEsRWZmmbV8rL3rhZ7q5xj
   u1RVjmAFNPxSR2pDa4gJoMFDIIizF+5gry4tOaYnXbgdzuPKqYEAz6IWV
   njc0WTLv5poHML+QcJ1hLjYathDJ3Vgf9x5Bs0ee3a2kSvScrJm695rUT
   uCC1I9WbncujbBzhV6s/36UmQ9CdttIpTJfrvRiwAnXn0x7o29u6W20YT
   BGCidFQbeqkRGl5iETusgwQcZu6c5g5o7oq3WT1meMIyETfm3lHWx3Jqt
   g==;
X-CSE-ConnectionGUID: 3sQej5HLQM2tVNkDvxknLA==
X-CSE-MsgGUID: ENbHZze9Qien+hE0CdgjTw==
X-IronPort-AV: E=Sophos;i="6.04,290,1695657600"; 
   d="scan'208";a="5268353"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 20 Dec 2023 08:58:51 +0800
IronPort-SDR: LEDA1jtN33uE2BbGvn2VX+NlATtFCmtIyYS3qzWnwyQzJEAAOGoqmSUVpx0MmlxOPoAzPAVVL6
 r/eNZpLw0jPA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Dec 2023 16:09:35 -0800
IronPort-SDR: RutQl4pB7q2PyEqgHkLfr6WK5KvRpFeV4KIbcbGxwPQIcdoRNOpwrLlxbDOpvvh+jQEuRsIvJj
 KfKwnsIiar8g==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 19 Dec 2023 16:58:50 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/2] t/zbd: add test case to confirm no write with rwmixwrite=0 option
Date: Wed, 20 Dec 2023 09:58:46 +0900
Message-ID: <20231220005846.1371456-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220005846.1371456-1-shinichiro.kawasaki@wdc.com>
References: <20231220005846.1371456-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The previous commit fixed the issue of the unexpected write with options
zonemode=zbd, rw=randrw and rwmixwrite=0. Add a test to confirm the fix.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/zbd/test-zbd-support | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 2f15a191..532860eb 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1561,6 +1561,29 @@ test67() {
 	grep -q 'Exceeded max_active_zones limit' "${logfile}.${test_number}"
 }
 
+# Test rw=randrw and rwmixwrite=0 options do not issue write I/O unit
+test68() {
+	local off size
+
+	require_zbd || return "$SKIP_TESTCASE"
+
+	reset_zone "${dev}" -1
+
+	# Write some data as preparation
+	off=$((first_sequential_zone_sector * 512))
+	size=$min_seq_write_size
+	run_one_fio_job "$(ioengine "psync")" --rw=write --offset="$off" \
+			--io_size="$size" --zonemode=strided \
+			--zonesize="$zone_size" --zonerange="$zone_size" \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+	# Run random mixed read and write specifying zero write ratio
+	run_fio_on_seq "$(ioengine "psync")" --rw=randrw --rwmixwrite=0 \
+		       --time_based --runtime=1s \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+	# "WRITE:" shall be recoreded only once for the preparation
+	[[ $(grep -c "WRITE:" "${logfile}.${test_number}") == 1 ]]
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
-- 
2.43.0

