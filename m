Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2919D50096A
	for <fio@vger.kernel.org>; Fri,  9 Jan 2026 02:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767926176; cv=none; b=rQaOPepBNfnhTX+DegYARpMhTOSuBU2OvF6sJ63GNWU8hJGc1V8lHm2y2mWx7/uoNLjPyzGqXTns22sHIjLyEjiKGRMn1LQ1jISZfIibxc6+12+dCPL8oWvHrbsy2k2R8VDjyFASgX0o2EL8WycnNGCMWBYbtclzTGM/4nIpyso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767926176; c=relaxed/simple;
	bh=7rmgEl4Ra7+SceSa/LSRcJAJL+XWYdhIVMbATC3yW1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPNKx3p60MyZ71q7eq9pA3SZxELaICN6sy4U4xRBB8dsJqJaYbaY3ZgojJjBSRoJl0YYydrNpaNlyyrmzm0lQ5MbGu9EHACVoBExZ69Qc7MEmRKEg4m5YUKjhtzGwCcNFncOKSUD/ZuftdPowFZy7l6AHjjWxXkedssusDuJSI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=AfHtBkse; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AfHtBkse"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1767926173; x=1799462173;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7rmgEl4Ra7+SceSa/LSRcJAJL+XWYdhIVMbATC3yW1Q=;
  b=AfHtBkseXo5pW3VEtnfXGXJVFQxjNVDTHBRxgfkkPvJl9GysJHgpED+S
   5Nz7uDhQ4XnEx+TJMpZ/+/BkiLKk3K2y2zjCOP4f4pIR52LuVCWkiLbLF
   MK0g0eIMPRc4KCkNtCUV6OYpb9XdZkT8mwLFA+JkHLu3Gpfm7ASRuBUB1
   wy4LUzrAuCLv7m6Lnz05XNQKPyE9bA9KzaCvrQTUwc1ZoIIiz00z2LR9w
   ev7aRnDQvbJYzLNG3u2FAVUUHYH6Ci1IBswWRlAY0RgSaFxEiX3TEgcqP
   pS6YzADO0UgMUk8z8xNBwb9HRR+hhtz1BFz26PNcNibdmJcOvyKatK9Em
   w==;
X-CSE-ConnectionGUID: Q+XYXSLZRmGd3KW5YjuK+Q==
X-CSE-MsgGUID: EXA322kZRdes8nSRQyumag==
X-IronPort-AV: E=Sophos;i="6.21,211,1763395200"; 
   d="scan'208";a="137774583"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jan 2026 10:36:13 +0800
IronPort-SDR: 6960699e_HKvPR26yu+0zTzpIBz/n2/EHDOE38wJLfpYhHqGkTheP0CS
 FNiI+0IGkM40gbeX0Isne4uNYz2kvtQtLu9FlJQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jan 2026 18:36:15 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Jan 2026 18:36:14 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 09/12] doc: explain norandommap restriction and small remainder of zonemode=zbd
Date: Fri,  9 Jan 2026 11:36:00 +0900
Message-ID: <20260109023603.2848421-10-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com>
References: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The recent commit "zbd: set norandommap=1 when zonemode=zbd is
specified" introduced norandommap=1 restriction for the zbd zonemode.
Also, the recent commit "zbd: write zone remainders smaller than minimum
block size" changed the handling of the small remainder at zone end.
Describe them in the documents.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 HOWTO.rst | 9 ++++++++-
 fio.1     | 7 ++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index b1642cf0..cd5edd01 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1034,7 +1034,14 @@ Target file/device
 				all zones instead of being restricted to a
 				single zone. The :option:`zoneskip` parameter
 				is ignored. :option:`zonerange` and
-				:option:`zonesize` must be identical.
+				:option:`zonesize` must be identical. The option
+				:option:`norandommap` must be set to 1.
+				Otherwise it is automatically set. When the
+				block size is not aligned to the zone size,
+				write operations leave small areas at zone ends.
+				Fio truncates the specified block size to fill
+				the small left areas with write size smaller
+				than the block size.
 				Trim is handled using a zone reset operation.
 				Trim only considers non-empty sequential write
 				required and sequential write preferred zones.
diff --git a/fio.1 b/fio.1
index 3ee154ed..f7552eb5 100644
--- a/fio.1
+++ b/fio.1
@@ -809,7 +809,12 @@ starts. The \fBzonecapacity\fR parameter is ignored.
 .B zbd
 Zoned block device mode. I/O happens sequentially in each zone, even if random
 I/O has been selected. Random I/O happens across all zones instead of being
-restricted to a single zone.
+restricted to a single zone. The \fBzoneskip\fR parameter is ignored.
+\fBzonerange\fR and \fBzonesize\fR must be identical. The option
+\fBnorandommap\fR must be set to 1. Otherwise it is automatically set. When the
+block size is not aligned to the zone size, write operations leave small areas
+at zone ends. Fio truncates the specified block size to fill the small left
+areas with write size smaller than the block size.
 Trim is handled using a zone reset operation. Trim only considers non-empty
 sequential write required and sequential write preferred zones.
 .RE
-- 
2.49.0

