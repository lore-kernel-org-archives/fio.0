Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC7612E73
	for <fio@vger.kernel.org>; Mon,  4 Mar 2024 07:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709536754; cv=none; b=jyMx4GVabHfz66gufUOK/DeL4cPwgZn1+DpdYVSIWD8BtG7KspEQyvvEHo4EDrcIanmEzp6cy/9qbQTcVpitPedmyG9C8IO67i7dk7fzs1PUlnRBA6MjkEv2K1BKLBpk1GUHwGf6Z4+69fagoXR01b5DrOIJfNrLOVkZ1p4IWrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709536754; c=relaxed/simple;
	bh=ITMU1/D8ZLV2EYNldAPaz4yz+cbb2ck1anTUnrl2yy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxBCSVkRmQ4lHMaghzBcwsTh8nct+iK/ohD6ijBz6Vwm6uk6O5wDz1PzP5etM7yK+BDFPoMnz9oH6HFhkHRCQGP4jO7c+vEEDAovjBCWCO7/56UQ7wgTgxd16SvAK9VI9YJn8vWr0vW0vn9+NbFEREBV9sQ0JPQ36y16KLcO7LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=brPQsqj4; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="brPQsqj4"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709536752; x=1741072752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ITMU1/D8ZLV2EYNldAPaz4yz+cbb2ck1anTUnrl2yy0=;
  b=brPQsqj4PoxM541k239xv5wcpgAQdSCzCY85lvhksN/aEExtMRF/nwb2
   RGBz8ztd9JDCsTNBNUxUZGhLrEMRIannZ3JVoY6u5YY0RsVt9kqdQfG4f
   bFzqx1758v8VgXNWseJyR4NJoOuJjm+DMuahLuT+v4WTnJYYG8NCcsKs8
   aAwfjBsthHkLH+VPcghMZPxlA6fQdzE0x/fbj4k/8qRGWqg01XzYDdPuV
   5VxR/UiyEDbeRJK3pFyQ7cAmaPhPlKxwSDbMT/8ljTTqexIIyeY96eWAe
   nv9TnmXUDTQ0V+1W56PamqR/7Eky/eF72x4+TRffvtEVqs9KRvL0FCdwK
   g==;
X-CSE-ConnectionGUID: wLhGT+tmRz+VMAlDYfnOQA==
X-CSE-MsgGUID: TV3rm9sMSE2AI4Ud4pin4A==
X-IronPort-AV: E=Sophos;i="6.06,203,1705334400"; 
   d="scan'208";a="10728606"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Mar 2024 15:19:12 +0800
IronPort-SDR: QNbmgydCckOF5CxGCrslPuSie/IVisgVZmaybhrOIJ91q3QNXPlWEd9Ca9kK1O9UyY38zq6gP7
 et79bGjdSL7g==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Mar 2024 22:28:24 -0800
IronPort-SDR: 8mZq76mtVHrn9u97nLHfWzj7GQneqM/twJq10evUpPzA593hJJYGYC9V3vCIAKaoXDW/feZ0Ow
 bZ2NOmM8MVaQ==
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip02.wdc.com with ESMTP; 03 Mar 2024 23:19:10 -0800
From: Avri Altman <avri.altman@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 4/6] t/jobs: Rename test job 15
Date: Mon,  4 Mar 2024 09:18:49 +0200
Message-ID: <20240304071851.982-5-avri.altman@wdc.com>
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

Make it designate the correct fixing commit.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 t/jobs/{t0015-e78980ff.fio => t0015-4e7e7898.fio} | 0
 t/run-fio-tests.py                                | 2 +-
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename t/jobs/{t0015-e78980ff.fio => t0015-4e7e7898.fio} (100%)

diff --git a/t/jobs/t0015-e78980ff.fio b/t/jobs/t0015-4e7e7898.fio
similarity index 100%
rename from t/jobs/t0015-e78980ff.fio
rename to t/jobs/t0015-4e7e7898.fio
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index d4742e96..08134e50 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -722,7 +722,7 @@ TEST_LIST = [
     {
         'test_id':          15,
         'test_class':       FioJobFileTest_t0015,
-        'job':              't0015-e78980ff.fio',
+        'job':              't0015-4e7e7898.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
         'pre_success':      None,
-- 
2.42.0

