Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E608175A93
	for <fio@vger.kernel.org>; Mon,  2 Mar 2026 02:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772418376; cv=none; b=I5p9KQTg/o5Mr89prFqqm6g1galdS8LGbRs2bpVC5bmLPc/3uy0FxBszH4qFj8578pcZORkYReD/fW3ImGOZuX/8LUQIeZ/itxSpssHlZ+MiEzzIphwucGZTF4ObY2CXiG/mRVHPVeiKl3y/SnZunoNYLoNKQ8EniytOjU+t91Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772418376; c=relaxed/simple;
	bh=FRmT84cndQhNTIbWRH0V1tKXLJUqMS5oCSxLPk7hsQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WG68h2JsiyRSfRhzdnu7jOcLzotu0qBmSlBqTxz4mmXQQECA4DB0RdYTRdrrj5vLHQqsh+Zsvpp6ZKQxn9kWYl7JNOqPl/lggAL2VYIkfUxn5KQFk5ONPi02K1G+EBM45Tiq1he/VZ/qLroqrD56hxHQ4UI5u4aAJo+pH4cvZYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=iKXhbm0e; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iKXhbm0e"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772418375; x=1803954375;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FRmT84cndQhNTIbWRH0V1tKXLJUqMS5oCSxLPk7hsQM=;
  b=iKXhbm0eQZeXlIlZzSx7BB+ONd3LIeW2PLik9Wap8GRfkCkqHD9Z/+QS
   CbwQzL2/3vqi8V7wNtqSHU5y+L9u9K90zpPj9deDQud8LYFXjaUhi86f9
   YDfBT3Jd/vivg/AzKetpgj6uwzbq9pyDJZLkpcUhtKaXYAyBvyHaV3fYG
   2EGCc+jPVcW3NB+0wHEkSp7q/pjABy+arh4UYNj9asWOuMISZEiOPWbN/
   ou0gwU+arH653RCsFIRBmFuOAwsyk9zuv05EjHFcLpPpFx8vkQJ/OkVs5
   2mwgi9MmbxCvYFmP1gvXnEMKBKLCwDRnsHub9zBg0DKr5q4GwkpF+bYiW
   Q==;
X-CSE-ConnectionGUID: WMccfb+FRaWg1SZLk8b0Qg==
X-CSE-MsgGUID: B9VKV3ouS2CXjdxuuXYhUg==
X-IronPort-AV: E=Sophos;i="6.21,319,1763395200"; 
   d="scan'208";a="141307948"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2026 10:26:15 +0800
IronPort-SDR: 69a4f547_K81hWCdgMCeDWlLtV+hK2xB00SQUsU9UL9EEJLaTsSt9swW
 +cbIEUOdFONfof/nRDvR6FLj9HQ9ZlnIWewz5YA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Mar 2026 18:26:15 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 01 Mar 2026 18:26:15 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 4/8] doc: explain the option write_zone_remainder
Date: Mon,  2 Mar 2026 11:26:05 +0900
Message-ID: <20260302022609.3526823-5-shinichiro.kawasaki@wdc.com>
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

The recent commit introduced the option write_zone_remainder. Explain
how it changes handling of zone end remainders. Also, amend the zbd
zone mode description to explain the default handling of zone end
remainders.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 HOWTO.rst | 26 +++++++++++++++++++++++++-
 fio.1     | 25 ++++++++++++++++++++++---
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index d31851e9..d9cac796 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1034,7 +1034,14 @@ Target file/device
 				all zones instead of being restricted to a
 				single zone. The :option:`zoneskip` parameter
 				is ignored. :option:`zonerange` and
-				:option:`zonesize` must be identical.
+				:option:`zonesize` must be identical. If the
+				size of the unwritten space in a zone is not
+				a multiple of the specified block size at
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
+	If the size of the unwritten space in a zone is not a multiple of the
+	specified block size at workload start, write workloads create unwritten
+	remainder areas at the ends of zones. By default, fio issues zone finish
+	operations on such zones, transitioning them to the full condition and
+	freeing up open zone resources. However, zone finish operations
+	introduces waits for in-flight writes, reducing overall write
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
index bc3efa5f..f963d4d4 100644
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
+\fBzonerange\fR and \fBzonesize\fR must be identical. If the size of the
+unwritten space in a zone is not a multiple of the specified block size at
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
+If the size of the unwritten space in a zone is not a multiple of the specified
+block size at workload start, write workloads create unwritten remainder areas
+at the ends of zones. By default, fio issues zone finish operations on such
+zones, transitioning them to the full condition and freeing up open zone
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

