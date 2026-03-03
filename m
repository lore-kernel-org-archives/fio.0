Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF68373C01
	for <fio@vger.kernel.org>; Tue,  3 Mar 2026 01:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772501529; cv=none; b=P90pfL8N1sKdNa5ZuRPIb2DJV55XW1bZTPTd/WRb1c32ywOcnDYc2GcldmyOJvFvtNduZZnWDYWbnPuhnRb+rkkiY0rgdtkDIhiKwxDhmQZP6bWhcZphI3e144h0/MqgigzlVcB1tM+HXlwawIhtOYSxJA7JPOYj5w0NLl/A+B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772501529; c=relaxed/simple;
	bh=xlcfsAybKUMKWPb5Bq8iZALlYPnfWpeioLb/b8RHny8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/oiDkyUPfTZLxjGezMghl2p/PcuEVL8kHatwAuArOtIC6z6Uw0T8HyyxCUiGuzOrsbovyVKQW4GN2/oaCV230V1C5DFgau6/cAsk16dsKKLs7sjpWlB6cLXZaoUF64VxahCHBYLfOmyiQIrDC54k2dHC+wqLrO3YIlKo+torns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ijjxCNaa; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ijjxCNaa"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772501527; x=1804037527;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xlcfsAybKUMKWPb5Bq8iZALlYPnfWpeioLb/b8RHny8=;
  b=ijjxCNaaBbVvRMwn6HeN4qVgo28Z+qJi5osQHGYi7M4qw63qQcF4GQh2
   /JQhN55M5riOxDqK+Jh/NH3imChiTDFYmIPyEYm1QsI0wWuwaUlnFP4jY
   6GakSfy8I7jwYzVHjHxJVmxP8Yw7BBL/waiabjlq6SHoB+hhCGsOvCszi
   CJsUclec11U6FJ+JBKKUwMkIxLvCL0opa/Oyynq0EIxUGEU7BssigjBjc
   08umuZ7Arguxw6PrZZQnF56Es5+F1+4jpr76e3WWB6o/7XeXl5UJpOmeg
   eyjJ9lMc8CjYe85av4bdtB8SFw2C8MeS4UuzCHm4n2k4WOUFBxemMg9UV
   A==;
X-CSE-ConnectionGUID: vqmYPonlThiUf6yDrpBB4A==
X-CSE-MsgGUID: dpBg5NGbROW9nD88E/+4IA==
X-IronPort-AV: E=Sophos;i="6.21,321,1763395200"; 
   d="scan'208";a="140813518"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2026 09:32:06 +0800
IronPort-SDR: 69a63a16_0G0UM9Fs9QaoKemnt0/HGxg5BPOpSW64aGPJw7krT6JnAld
 MgA7TrkPXJnHjMIVNsQkD9v7N7FIpjr/vqyxSbQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Mar 2026 17:32:06 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Mar 2026 17:32:05 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 4/8] doc: explain the option write_zone_remainder
Date: Tue,  3 Mar 2026 10:31:55 +0900
Message-ID: <20260303013159.3543787-5-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260303013159.3543787-1-shinichiro.kawasaki@wdc.com>
References: <20260303013159.3543787-1-shinichiro.kawasaki@wdc.com>
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
index 20903496..e712ee2e 100644
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
index 207fdb42..4c37848b 100644
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

