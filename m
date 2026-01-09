Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B783161B1
	for <fio@vger.kernel.org>; Fri,  9 Jan 2026 02:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767926235; cv=none; b=WDwuGZTuFNZ9eWvk4/5rkUBJwDv0e/G8o9uzdwjYAvrWTqyRRe4kyims/UySKyQVDVt7bMBF4xXnkyfH7gKEQG6kkOrish5wekF9flvnopoGsLGY9L5BfUh7rFBAznF4d6CfL/Ocj3FjM7SkQ+FvR+SP3CleH6SOCcWktmoU09o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767926235; c=relaxed/simple;
	bh=88Pj83BYXFtrjV1gVxhhOhl7IFsThPpMlW/3JfCx014=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MyFVmHZiE1inpjud3d2lpQZXO/+fG5OCG8uVq5x0VYHjVsdgNLH6uHPbcOtrNKOPLp61r9nUTUDiNtxxij4ZUBXrVaCDCMxkqkugu/JNsZPIsbpjJX3+yk52GDX1vkDCXzx13AbG9BzSrFHBHQLQNGEvXcaGpOoroKg7X/pZ5z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jZkvo8k1; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jZkvo8k1"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1767926233; x=1799462233;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=88Pj83BYXFtrjV1gVxhhOhl7IFsThPpMlW/3JfCx014=;
  b=jZkvo8k1YEevfLKo9Y5us3Pk2Xzh7DbEb+4XdWer+pPReWAXZECq5sya
   DUeENmGbYVev/YWEevApA3SjYkKpw0bjWxJrkOYsazAgUMQMxw+HTeTeg
   O+CEDG9kGdRac1e61Nd1BrXk1zQNfZuKhN8cmI/kg/XaoUNeh8y03ilbe
   XSA9asVYIaE+VBWIrsmvxml43zImlfDXVb8Q8DLRQZ5ikVJssauh8NuDF
   1vNqCWYE5AJIuHJnp3Ptlg81X9z3l8hZiwh2nMZxygHzMPomCM/J7ghjU
   2Oni2JeYdiv7HKYIMo5/3Dh2uJmV8rFN8VP8mC/Az0EmkX8n1a9suew3V
   w==;
X-CSE-ConnectionGUID: ddIHlJqHQO2o3tTLt2b2rg==
X-CSE-MsgGUID: Zy4GLr3/TvuWx+dmk35e5Q==
X-IronPort-AV: E=Sophos;i="6.21,211,1763395200"; 
   d="scan'208";a="137774572"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jan 2026 10:36:03 +0800
IronPort-SDR: 69606995_dBilOUptZfnWzDtGdc4YRRzNglZpvw5YZP3+rNxCvhV2nON
 eF1v8bvgh5zn7XC7UlrcqSCNLIhneg5LG8pPZeQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jan 2026 18:36:05 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Jan 2026 18:36:05 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 00/12] zbd: fix problems of random write with unaligned block size
Date: Fri,  9 Jan 2026 11:35:51 +0900
Message-ID: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When random write workload runs with zonemode=zbd and block size
unaligned to the zone size or the initial write pointer position, two
problems are observed. The first one is write target zone selection.
When one zone is filled by the write workload, the same zone is selected
as the next write target. This results in writes concentrating on
certain zones despite the workload specifies random write.

The second problem is write performance. The writes with unaligned block
size leaves small remainder areas at the end of write target zones. To
free up the zone resource, current fio does zone finish operations to
the zones with the small remainder. Fio also calls io_u_quiesce() to
prepare for the zone finish operation and the write target zone
switching. These zone finish operation and io_u_quiesce() calls
significantly degrade the random write performance.

This series address these problems. The first patch addresses the write
target zone selection problem. The following four patches address the
performance problem. Next three patches clean up the code by removing
the zone finish operation. The last four patches adjust documentation
and the test set for the changes in the series.

Shin'ichiro Kawasaki (12):
  zbd: fix zone selection of random writes
  zbd: set norandommap=1 when zonemode=zbd is specified
  zbd: write zone remainders smaller than minimum block size
  zbd: fix write zone accounting
  zbd: remove io_u_quiesce() at write target zone switch
  zbd: remove zbd_finish_zone()
  oslib: remove blkzoned_finish_zone()
  ioengine: remove finish_zone()
  doc: explain norandommap restriction and small remainder of
    zonemode=zbd
  t/zbd: avoid test case 14 failure due to no randam map
  t/zbd: avoid test case 33 failure due to zone end remainder
  t/zbd: avoid test case 71 failure due to zone end remainder

 HOWTO.rst              |   9 ++-
 engines/libzbc.c       |  34 ---------
 fio.1                  |   7 +-
 init.c                 |  13 ++++
 ioengines.h            |   4 +-
 oslib/blkzoned.h       |   8 --
 oslib/linux-blkzoned.c |  34 ---------
 t/zbd/test-zbd-support |  12 +--
 zbd.c                  | 163 ++++++++---------------------------------
 9 files changed, 65 insertions(+), 219 deletions(-)

-- 
2.49.0

