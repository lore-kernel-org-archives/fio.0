Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.141.245
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795761630;
	b=q6+Pc9EbT3V9jucQW4RtYbDTKqbGHdRv4KpoMyAq1+zdYjZoF512MTL8LwPZTmYVPsu1
	 a0R4W7ixfXGIhCToyd6rmtvuzOqszr8xbrEPsA6eaA5KRyFO++84cqVutHpTnDqTmZVcK
	 sy5YGns/JTmZLH5qbPqQvtxsoJQU3dCCPpAJPbmdM92kBjGWC1o2d1ECQIelSGplzRIaR
	 Rpf60qloqQp5DEgF9JKS9m9hYmcB79h4QlNfXFMEuqq0aKVZSKrUoC0YPZB80JvbeLQzC
	 bMzmwzXiTfwGEN5OxmGI3YDC8d70vOH94qRt3ZpERF/qRKHQG1qF7Rcje/MrN74zsJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795761630;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 IronPort-SDR:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 WDCIronportException:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=ykfrIhyoM52NHF/5IDb7f1ftBozQD20Gp9QsmWV5Jxo=;
	b=EEu8G2dIZWWyaSEjZOnZoq3ks++8QvOlRkCqzGJ/zfHKa0CIOplHEZ7oq2tFTGWXG2UO
	 pKqvX3exda8ieyX/Hlq0kvum1uk6ejt5YbILmxDRWGSFrqjxEVA3xSkNrmUqeU2Zyxa5x
	 QCIl1I/rHGmxopVDqzFcKtSkvG9bqP84Hney3Mh/qTLEErzF7tKansKet9tVR9OE6hZ78
	 XhRV7oTQP24/kE05FnOZRLUBCaanTrNAiXlYzKmVCGkfUfiJbEF+S0P/hX+T6I0BQPXdJ
	 PbWaBZHFcX5oEGE9Ugp/kkNJMCReBY5fOBX3em2w6X0Qzq0nCHzETj4oITcB9w5hzLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=jGIjPlsh;
	arc=none smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7482A606A31C
	for <fio@vger.kernel.org>; Fri, 27 Nov 2026 06:40:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7482A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=jGIjPlsh
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795761637; x=1827297637;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=H/n1OVzkU+lbVG6VyG20O3wob9pVb6o8/AmRCVsT66w=;
  b=jGIjPlshsgs64YbzL1hU3ShGA4YNEUdSUUr9WdzbC6fhm9j+/IJS/0nX
   KRx5A6ZWqP7rXX5fGHT5A2jK8yKfmo8TDR+DyXaJtCHdScL9oCA8zU9ki
   s2UVwiv5BTrFVn6FGx2nm6KX1mCFNV0L7OqRmjrjgKyiDsRCAQExoAJWp
   VpH17ldV1Ne+eX1AFDFzmwkapQFFONerVNekqDBv1gVwiwZwzUU5HEDmW
   mCevkDWFA4qsuK0pP61Nm8IIDOQbGE1WiG76OM4ABm+97vfElIwwPDdGG
   WEbJNA5kxbqExk5L4TnC64Mj7htxHgvL+urEGWXg8zkLkjoiGUIQZwIMi
   A==;
X-CSE-ConnectionGUID: cPW1vu3MQE63d4nqwuwcaw==
X-CSE-MsgGUID: GZsfVNrxQYCilIOjeZVDOQ==
X-IronPort-AV: E=Sophos;i="6.27,236,1786982400"; 
   d="scan'208";a="161815423"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Nov 2026 14:40:36 +0800
X-CSE-ConnectionGUID: jPlnkffAR1yo16vlECMySQ==
X-CSE-MsgGUID: Vas9Q1JWRdWmSgQdJB3LMA==
IronPort-SDR: 6b0925dc_tvC5uDDMYH0VHQfD2N32ZCcVkewJ2a1gLHkXUspMw/3fCpA
 s0nYuBuNOcKurgECAfpo40AOIuwvY24QiT8FbcA==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 22:40:28 -0800
X-CSE-ConnectionGUID: g64jd0dERCOZN7jzosMOTg==
X-CSE-MsgGUID: nWafUFE7Q0qv4E3u+5UXQQ==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-esai2-o.wdc.com with ESMTP; 26 Nov 2026 22:40:28 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/8] blktrace: fix merge_blktrace_file bugs
Date: Fri, 27 Nov 2026 15:40:19 +0900
Message-ID: <20261127064027.1909326-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the read_iolog option is specified, fio can replay I/O workloads
using blktrace files recorded on Linux. When the merge_blktrace_file
option is also specified, fio merges multiple blktrace files into a
single file used for the I/O replay. However, this merge feature has six
bugs, and this series addresses them. Each of the first six patches
fixes one of the bugs. The last two patches add a test script to confirm
the fixes.

The bugs were found while I was looking into the fio code to support
the new blktrace data structure 'blk_io_trace2'. This series is a
preparation for the blk_io_trace2 support work.


Shin'ichiro Kawasaki (8):
  blktrace: initialize merge cursors
  blktrace: fix merge_blktrace_iologs() return value check
  blktrace: fix trace rewind for the merge_blktrace_iters option
  blktrace: use unscaled trace length for merge_blktrace_iters
  blktrace: fail merge_blktrace_file without read_iolog
  blktrace: ignore a partial trace at the end of a merged file
  t/blktrace_merge: add a test for merging blktrace files
  t/blktrace_merge: add tests for the merge fixes

 blktrace.c          |  50 +++++--
 blktrace.h          |   2 +-
 init.c              |   2 +-
 t/blktrace_merge.py | 340 ++++++++++++++++++++++++++++++++++++++++++++
 t/run-fio-tests.py  |   8 ++
 5 files changed, 386 insertions(+), 16 deletions(-)
 create mode 100755 t/blktrace_merge.py

-- 
2.56.0

