Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2EA16191B
	for <fio@vger.kernel.org>; Thu, 18 Apr 2024 09:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713432283; cv=none; b=O1YnWXM3VsHwUCEECKHKsDfwMbcZhLttYOuoV4zZEN9gPstgCQwc7nOCnjNd1u8Quz9Ujjua1rj6JkOo+4iZhne+S6SLok4zRjNKnU3/m3ynbNbZ+nUiKO3fUWsSupT1sLdxgNE1yCd2S0p34kEdGZoZEHU0OEuoQvurv1fj0Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713432283; c=relaxed/simple;
	bh=4Esj3yXgBRKVT4BAS7Vm48mLLl+kUyggMDYTdiGy+sw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xh1OAP5O095JvPw6tHobNDgLz0vp9doYiBamsunvy+93CQmRWOCAUCSqmkTlhb9y4+hUyIOtYC4r9kAGeTfggs9rOPfOUuMD9GLg32w16U4XyeI5R8InrA/hImudzDmqSK8RTb/kc6SC6uujeicYwuS549lpUIjH+E9GUXBZsj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=JN9vFKU4; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JN9vFKU4"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1713432281; x=1744968281;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4Esj3yXgBRKVT4BAS7Vm48mLLl+kUyggMDYTdiGy+sw=;
  b=JN9vFKU4uwHi5sl+PeGncVf+qu7eDuPNbvS1ZT4L0/DJs6Sgc2xHKkQH
   ZgNacjxCr6POUC5FzxsqnyoPgrwVpAytZw+UWWjclk45+zbctdEx8jaxt
   5mLIdMtzDUGePmabUALdmM0zswis0bvvsANdy0iavqt5CXEZhyCOGGUDX
   hZ8PRXSKt0xUbP4BXF3NoUg8aLjFp7XS/ymB+qIh2di4TtGFaHwUt24sx
   X+DIcNfL7HMixcbmsYqtdafqRf80rlUWKFWlgIFYc0ob5ZDE9hCTr5o7r
   zWchYz583oLcdNYVman4YJ+mLNJb5SKQYZD/8emcmk9yZJ72rcm3Nsw3w
   g==;
X-CSE-ConnectionGUID: d4/pNqCLTmu9KSNm5RBtHQ==
X-CSE-MsgGUID: zKGBqnYsT0CGzeaaQGnLIg==
X-IronPort-AV: E=Sophos;i="6.07,211,1708358400"; 
   d="scan'208";a="14548443"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Apr 2024 17:24:39 +0800
IronPort-SDR: i/DHb7+dh0J35CsM3NPQRE8y3l8Hfa3JNc5wcA+v6Af2XfRvE/VXIMnZgPsVGXsG9qMfvcHvp+
 T1/uO27eMvC1PAT+Bp6Rjqj2vPClW3iEpm3FFU2jHYFR5I7tGdj5IwykcMUZimlYJB0zVuhvJo
 nYzQw137m3RMK9fJN+bpxN+ZlU1zQc1Erydc6GXrM8yivDhVAiDrZDjtdWAfO7EMwyKWO079SQ
 DHugqqBOTnAFmoL9DKlVrLJp3J0G+IGYifQdHrjXEFO/z1Gj1k0skwzsxDdBsBIna4dtzXfDei
 gl0=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Apr 2024 01:32:57 -0700
IronPort-SDR: Hp935s2uLrtOYoRENxMrrTLTLA3FvS8wpc6mjbCeLI53XxiTXsxDqqYteMubQSV+FnxX71+mqe
 lXQy5vD/OjuRj19ENJpXD4GfuLr5STeEwHSZfSFa/Ml87xps7L/bn+O95e67aNYWNXyhsLZvsU
 kebVFgReb/uxyHAhKY9fKMAx0l/UinISX17fNNFXZEEFm43gL0AO0xvHKGZ4ciOnkQNyvINDl0
 LvR96lv5DFYNVu4Wcadeh+WSYjINhBvcJXQNSF+UVqS1GlOudHZc8wc7zgjDL4hxnc0FYL38Ke
 WYA=
WDCIronportException: Internal
Received: from 5cg1443s5d.ad.shared (HELO 5CG1421G2K.ad.shared) ([10.225.32.191])
  by uls-op-cesaip02.wdc.com with ESMTP; 18 Apr 2024 02:24:37 -0700
From: Chana Zaks <chana.zaks@wdc.com>
To: Jens,
	Axboe,
	axboe@kernel.dk,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Chana-Zaks-wdc <chana.zaks@wdc.com>
Subject: [PATCH 2/2] test: add test for readwrite issue
Date: Thu, 18 Apr 2024 12:22:23 +0300
Message-Id: <20240418092222.20543-3-chana.zaks@wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240418092222.20543-1-chana.zaks@wdc.com>
References: <20240418092222.20543-1-chana.zaks@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chana-Zaks-wdc <chana.zaks@wdc.com>

test the previous commit: Don’t break too early in readwrite mode

In rw mode if io_size > size An early reset of the addresses occurred.
Make sure all addresses are done correctly.

Signed-off-by: Chana-Zaks-wdc <chana.zaks@wdc.com>
---
 t/jobs/t0032-43063a1c.fio | 12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100644 t/jobs/t0032-43063a1c.fio

diff --git a/t/jobs/t0032-43063a1c.fio b/t/jobs/t0032-43063a1c.fio
new file mode 100644
index 00000000..db998e5b
--- /dev/null
+++ b/t/jobs/t0032-43063a1c.fio
@@ -0,0 +1,12 @@
+# Expected results: max offset is ~1280K
+# Buggy result: max offset is ~640K
+#
+
+[global]
+ioengine=null
+size=1280K
+io_size=2560k
+bs=128K
+
+[test1]
+rw=rw
-- 
2.25.1

