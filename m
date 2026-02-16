Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865E92FB612
	for <fio@vger.kernel.org>; Mon, 16 Feb 2026 08:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771228851; cv=none; b=RaQEDa2WkKlopyDzXN4Q7POXnHftVZLqqCs74KLJ26mDRIFwQBse0StWXSY2Sq/Kek96zCHkuLHtpDHMHMQMfOcc8vUd3NX09kAh5oqRXnjanR3HlsaFUerhACeO1TcfDTT5Dua545JjI9wouLpzUEuCSjJbZVmdaVTvF5GPmFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771228851; c=relaxed/simple;
	bh=GbzWNWXm02slXKU93lubyurO3PmU8G3GZLvLO/HN7iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2Yr5xGgpgWE2mT803FvDKB+16NOascxxAqCIcpYaGbRnwBKumvFeAAqJIAkUxA8MgALT8mWrRUTfsYn9W2tiC1cS5rpaV4ObozxXah2iOrEwBqpHnn7SmFZQHTg2CcjOzesD1uSS7vMyJC/9CoGJWQopHX3gvxE+UwQ8NDYppU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=iCtfLWwa; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iCtfLWwa"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1771228849; x=1802764849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GbzWNWXm02slXKU93lubyurO3PmU8G3GZLvLO/HN7iw=;
  b=iCtfLWwaGk5myf+8Wk0AWJy+rtWCwwaY492C4E7oa2YwV6Oy+eD/rXjf
   V9CiCx+pg9TR4oiw0AQ8axHeVabIAGAGMAtdBwn6DkUuz9Ng3Gi/ANSdh
   z2i1DjEByGFMVYU9l/qdR4c6rAuH7kbZUpj7xvvrYkFsKZ5GyErBsqnG5
   rpIKN1uH+llk4WlDgln0JFzuK0GGzEFueZTaE8D1T35swGTQ6lqTEURsd
   6lRSzAwdymEHAT5JiT5KnlGsgn05lVxU7MliXG8qTOupP6ajdlt2XyZwh
   Vl4xskCz345JD6SFiL0eVPvE2cktJk0+ajxdjyNdFKmNlQv0kqJfeQ5YS
   Q==;
X-CSE-ConnectionGUID: aGTr3fknS+KJJ8DurJ3pyQ==
X-CSE-MsgGUID: FvZUnYROQLuKJ6uBHM/+9A==
X-IronPort-AV: E=Sophos;i="6.21,293,1763395200"; 
   d="scan'208";a="140812881"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Feb 2026 15:59:43 +0800
IronPort-SDR: 6992ce6f_uov4cIt3zLL09/JNjmi7anzDpUWx9dlUiePl2VcYVpESZEk
 8rE2L7UOKRxu4lcMZnFCA0gA6NF5lJVFKhi5/bw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Feb 2026 23:59:44 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 Feb 2026 23:59:43 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 4/8] doc: explain the option write_zone_remainder
Date: Mon, 16 Feb 2026 16:59:32 +0900
Message-ID: <20260216075936.3318729-5-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260216075936.3318729-1-shinichiro.kawasaki@wdc.com>
References: <20260216075936.3318729-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The recent commit introduced the option write_zone_remainder. Explain
how it changes handling of zone end remainders. Also, amend the zbd
zone mode description to explain the default handling of zone end
remainders.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 HOWTO.rst | 26 +++++++++++++++++++++++++-
 fio.1     | 25 ++++++++++++++++++++++---
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index d31851e9..148c650e 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1034,7 +1034,14 @@ Target file/device
 				all zones instead of being restricted to a
 				single zone. The :option:`zoneskip` parameter
 				is ignored. :option:`zonerange` and
-				:option:`zonesize` must be identical.
+				:option:`zonesize` must be identical. When the
+				specified block size is not aligned with the
+				zone size or the write pointer positions at
+				workload start, write workloads create unwritten
+				remainder areas at the ends of zones and keep
+				the zones in open conditions. To free up the
+				open zone resources, fio issues zone finish
+				operations to the zones with the remainders.
 				Trim is handled using a zone reset operation.
 				Trim only considers non-empty sequential write
 				required and sequential write preferred zones.
@@ -1167,6 +1174,23 @@ Target file/device
 	asynchronous IO engine and :option:`verify` workload are specified,
 	errors out. Default: false.
 
+.. option:: write_zone_remainders=bool
+
+	When the specified block size is not aligned with the zone size or the
+	write pointer positions at workload start, write workloads create
+	unwritten remainder areas at the ends of zones. By default, fio issues
+	zone finish operations on such zones, transitioning them to the full
+	condition and freeing up open zone resources. However, zone finish
+	operations introduces waits for in-flight writes, reducing overall write
+	throughput. If this option is specified, fio writes data to the
+	remainder areas instead of performing zone finish operations. This
+	improves write throughput by avoiding waits for in-flight writes,
+	particularly in asynchronous write workloads. The drawback of this
+	option is that it requires fio to perform writes smaller than the
+	minimum block size. Consequently, the option :option:`norandommap` must
+	be set. If :option:`norandommap` is not set, it is automatically set.
+	Default: false.
+
 I/O type
 ~~~~~~~~
 
diff --git a/fio.1 b/fio.1
index bc3efa5f..36581d48 100644
--- a/fio.1
+++ b/fio.1
@@ -809,9 +809,14 @@ starts. The \fBzonecapacity\fR parameter is ignored.
 .B zbd
 Zoned block device mode. I/O happens sequentially in each zone, even if random
 I/O has been selected. Random I/O happens across all zones instead of being
-restricted to a single zone.
-Trim is handled using a zone reset operation. Trim only considers non-empty
-sequential write required and sequential write preferred zones.
+restricted to a single zone. The \fBzoneskip\fR parameter is ignored.
+\fBzonerange\fR and \fBzonesize\fR must be identical. When the specified block
+size is not aligned with the zone size or the write pointer positions at
+workload start, write workloads create unwritten remainder areas at the ends of
+zones and keep the zones in open conditions. To free up the open zone resources,
+fio issues zone finish operations to the zones with the remainders. Trim is
+handled using a zone reset operation. Trim only considers non-empty sequential
+write required and sequential write preferred zones.
 .RE
 .RE
 .TP
@@ -931,6 +936,20 @@ fail due to partial writes and unexpected write pointer positions. If
 asynchronous, the write pointer move fills blocks with zero then breaks verify
 data. If an asynchronous IO engine and \fBverify\fR workload are specified,
 errors out. Default: false.
+.TP
+.BI write_zone_remainders \fR=\fPbool
+When the specified block size is not aligned with the zone size or the write
+pointer positions at workload start, write workloads create unwritten remainder
+areas at the ends of zones. By default, fio issues zone finish operations on
+such zones, transitioning them to the full condition and freeing up open zone
+resources. However, zone finish operations introduces waits for in-flight
+writes, reducing overall write throughput. If this option is specified, fio
+writes data to the remainder areas instead of performing zone finish operations.
+This improves write throughput by avoiding waits for in-flight writes,
+particularly in asynchronous write workloads. The drawback of this option is
+that it requires fio to perform writes smaller than the minimum block size.
+Consequently, the option \fBnorandommap\fR must be set. If \fBnorandommap\fR is
+not set, it is automatically set. Default: false.
 
 .SS "I/O type"
 .TP
-- 
2.49.0

