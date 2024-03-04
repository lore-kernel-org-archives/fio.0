Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF6553A6
	for <fio@vger.kernel.org>; Mon,  4 Mar 2024 07:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709536753; cv=none; b=m+ZXfzvx+45qEeCTz3Nm8erJ1svHfJSGkJ0p5MA9WsYl+jocn8IeeSWtyrtjh+5QMi4AxeBUDemJ4eqFXyhRQYDDuYuNTxrze9RAQUygvXPgrJWpZ/Msou25bzU2eVOtSFkQe0Nki5P97H5SXIPyL3q6w4cRRR3B+OQySLRB73c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709536753; c=relaxed/simple;
	bh=xkitf4IE7EX7Inn4dqMppqbz9qTe0JbVxkzzvMIWW+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPxdqWwesShq8PKIGfvAFjDOse6zaUntJNBzsAj0oo1NwQ0sWsaukGcLYbFPvEa/ljnbukI3NH8+ByBGG08tRjm/9mXUiimNyjIj2BYxBIpImh6CyKibgdpbNKtarJfVEWqHKQqgJ9bmB844ln1O7ccWP9vLGwb0qL/f1BEyItU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Jd3te80v; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Jd3te80v"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709536751; x=1741072751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xkitf4IE7EX7Inn4dqMppqbz9qTe0JbVxkzzvMIWW+8=;
  b=Jd3te80v8NXeEt3D6cAELI3pRjx6i4+sCiQq8Fc/sAuCUa/OhqhtRaXI
   hT8+1wDcrw2jrX/yid6YYsLuRlbikeT6kp7urHA5t27Es4xT0VyK6Z1vm
   pbvYURvAcEV2F9wrc5dbUMmWm0mRnGWQ+/MahKmu37/JJcXRJC4R3UgBE
   isbyg70AXmq4waaeF1wMlWmAoOs7carN0aEdIcJRfHNZn/I8o9xQfvTaT
   l4QfV2GVmLfYiF+KWQe58JLtpZvmv/IwUjbwFiMUlaU49EptP+tYoPt5l
   KAF9nLKLyRRMDAiwGP8i7O5XDHKi9UjauEjKT9tkap1lfZEHMp1ng6BGc
   Q==;
X-CSE-ConnectionGUID: OSMLnZmuTJCSv+mEXDuGiA==
X-CSE-MsgGUID: 44zvnn3TS/2FIdPdeNYVCQ==
X-IronPort-AV: E=Sophos;i="6.06,203,1705334400"; 
   d="scan'208";a="10728602"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Mar 2024 15:19:10 +0800
IronPort-SDR: 9UFFDdMcby20WC05UHEIujJTbhu4mKFYtYRpcVPnMIU492JQnv1uJyDqjA3r8B/KFJdoCjIb56
 ggY2IV2oPVtQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Mar 2024 22:28:23 -0800
IronPort-SDR: DLqXrLWzGd7p7W/0DFxMxi32+WUN91ExRJXPs2Bs5DyHzkHgqSIXMHCihV2/H3xsU1G8el/mc8
 LntRiehgdiaA==
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip02.wdc.com with ESMTP; 03 Mar 2024 23:19:07 -0800
From: Avri Altman <avri.altman@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 3/6] t/jobs: Further clarify regression test 8
Date: Mon,  4 Mar 2024 09:18:48 +0200
Message-ID: <20240304071851.982-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240304071851.982-1-avri.altman@wdc.com>
References: <20240304071851.982-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add some more details explaining the expected result

Signe -off-by: Avri Altman <avri.altman@wdc.com>
---
 t/jobs/t0008-ae2fafc8.fio | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/t/jobs/t0008-ae2fafc8.fio b/t/jobs/t0008-ae2fafc8.fio
index 4b364850..f4e8a06e 100644
--- a/t/jobs/t0008-ae2fafc8.fio
+++ b/t/jobs/t0008-ae2fafc8.fio
@@ -1,4 +1,5 @@
-# Expected result: fio writes 16MB, reads 16+16MB
+# Expected result: fio writes 16MB, reads 16MB+16Kb of metadata:
+# 16mb writes of 4K blocks are 4k IOs, each creates a 4 bytes of crc data = 16K
 # Buggy result: fio writes 16MB, reads ~21MB
 [global]
 bs=4k
-- 
2.42.0

