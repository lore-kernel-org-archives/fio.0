Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.152.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC05217659
	for <fio@vger.kernel.org>; Wed, 20 Aug 2025 13:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.152.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755695078; cv=none; b=rIU8d10Fz5tY+rSSf1A8+dWGjdkQvn5dRr3+5RMnzJvnbrKvNPlwlVoOp/FmKq4QRy4nGFYbCq5DorJyQVPV4cOAs2AovXXoFUo+SpHEfnOuzVDQLF8sGAL17+2NMj//kL5Aq/YsfJYso8Ybdla2ambFGV6taplF9JEgVsSydaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755695078; c=relaxed/simple;
	bh=zSZYpmNPJ0YbLzSBbCs7aLBRvc6bmWfGoqdBksAo1sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GM3L3bma2G6fIwZGhsRaFJJf20f+z5ym1G0v/QtYCb396NcZ7Fb9lDA458goOo/ZQAgOYDEWB4vBzun0DL0F9UAX9YbKPZyzdqs9v9U3DY8+KqvkRRXi8X23OqcUagOoeVvZbt2atP8PKZea9NXiz+iU0UI92qp+DwAqhdntnkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=X0BisVJy; arc=none smtp.client-ip=216.71.152.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="X0BisVJy"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1755695076; x=1787231076;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zSZYpmNPJ0YbLzSBbCs7aLBRvc6bmWfGoqdBksAo1sE=;
  b=X0BisVJy+0Sni8NDF23ng4eWM2LL3Ztk+QV9/+aze5U7c6Gsf4TSakei
   FpXTc1iyOebiQaeXZsPAbijyRwr0eFfFqTQ+svrwhGNv+iRoYeet2orCJ
   ICirSG80+6HJIyKL3qyxpmX8AOY+lxOLGCW2yPMR3LNR8Me4RX3fu4Tm8
   zmOqSqtvtjg3t6ALziBcYL0kdDslhWNvCB1Ta7smUwWIClacGsp6+nwGl
   pORyVCfGOWEFYx3J2uhzz6D8Vq2W0q3NLPXEqtv5Fm+g21AL3ihAR0FpV
   JU+3WUI5ZdoJQQCCSR0mAJBHsYk5RWp+Cvd1WmqULXVpGEH9c3tEfK8ov
   A==;
X-CSE-ConnectionGUID: mzwHtZwiTxOm4c1LLEeRHQ==
X-CSE-MsgGUID: ra6FI5VzSzykXP7JEK//JQ==
Received: from unknown (HELO uls-op-esaep01.corp.sandisk.com) ([129.253.192.43])
  by ob1.hc6817-7.iphmx.com with ESMTP; 20 Aug 2025 06:03:31 -0700
IronPort-SDR: 68a5c7a2_BLbCQ6NNsfMqRVVVI94IGKyY9Jh2GQXr5H/W86fnXOMSDyM
 sCYANmnh2f5ciCa2bsv/NZtiQiaD3/NAP53U4fg==
Received: from unknown (HELO uls-op-esaip01.corp.sandisk.com) ([10.15.0.10])
  by uls-op-esaep01.corp.sandisk.com with ESMTP; 20 Aug 2025 06:03:30 -0700
SanDiskIronportException: Internal
Received: from ulssdxvpxsnip.corp.sandisk.com (HELO WDAP-HWJc7y5WZG.wdc.com) ([10.9.34.160])
  by uls-op-esaip01.corp.sandisk.com with ESMTP; 20 Aug 2025 06:03:29 -0700
From: Tomas Winkler <tomas.winkler@sandisk.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: fio@vger.kernel.org,
	Tomas Winkler <tomas.winkler@sandisk.com>
Subject: [PATCH 2/3] engines/http: make fio_http_getevents static
Date: Wed, 20 Aug 2025 16:03:20 +0300
Message-ID: <20250820130321.73376-3-tomas.winkler@sandisk.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820130321.73376-1-tomas.winkler@sandisk.com>
References: <20250820130321.73376-1-tomas.winkler@sandisk.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The fio_http_getevents handler is not used outside of http.c,
so it should be declared static.

Signed-off-by: Tomas Winkler <tomas.winkler@sandisk.com>
---
 engines/http.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/engines/http.c b/engines/http.c
index 1a1787bf..83891f1f 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -810,7 +810,7 @@ static struct io_u *fio_http_event(struct thread_data *td, int event)
 	return NULL;
 }
 
-int fio_http_getevents(struct thread_data *td, unsigned int min,
+static int fio_http_getevents(struct thread_data *td, unsigned int min,
 	unsigned int max, const struct timespec *t)
 {
 	/* sync IO engine - never any outstanding events */
-- 
2.43.0

