Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C43879F0
	for <fio@vger.kernel.org>; Sat,  2 Mar 2024 08:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709368621; cv=none; b=Y/N1CLmq//MqZtORHFFRcgyiXCbvgonTzlfZ15QWDtzTh4A7wP3XtwLZDhfVSzev3c3UI6scIYupHQcn51aISOHrlbhCG453J/WW61DWK6/mbXo6v8kNJfc0o00f+hpMxuEvutrWW/C4oJjsjkVXer4l1LH8CixXXeim7akIRro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709368621; c=relaxed/simple;
	bh=ITMU1/D8ZLV2EYNldAPaz4yz+cbb2ck1anTUnrl2yy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H37co/PM7jxb7w9JXej9hmmwTmVaG7K37TcHUyOlGGX/XdNkjQHTsfg1IE5iF6GzjNgs04SsufQ2qMOA2eSOKvOqc/xAmGWWSdLuzLQjF7OfV9dAv7LmFEFS2mohH5t7K7F+4Zxq7ZxyjsC09SZhwnVWKXhc0AiqMNlC2OZZKCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Z+xyOj6n; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Z+xyOj6n"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709368620; x=1740904620;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ITMU1/D8ZLV2EYNldAPaz4yz+cbb2ck1anTUnrl2yy0=;
  b=Z+xyOj6nS7ok8HyOuHVlTNNtZCBMll9OjmhmRVk/KNXVSqTsUdVtFCHs
   TFLabURB9Wr0dPakgozmy2eY6HbmIRnd8KkVqOSGQ0nEe7ykw6qlRSRPY
   dxWAfGnjC8diJjahMqgg0WcU3tgv7KhMYDMA3PcXFDF+XbI/uUMeei6OA
   J5/4bSuB8WPAp1MjisBk5+nK58NumxbnfcOtkOOWoauzgRCzOk7V6o0Do
   n7r4wksmpoJ607sZXIZuDGvyOqyQQ2hUkkKX6M3nZhCRpSfnD4EOBQW0d
   J04Nl+jFqjsNPCuqrqOy1SD+ea83UJtfBgLl6QuHLASJz5ZmmtscHGEh8
   w==;
X-CSE-ConnectionGUID: Gy6AiXIuT5WDgkUCLOz2Pg==
X-CSE-MsgGUID: WF2LKyxSQVqY6J/W5RCz3g==
X-IronPort-AV: E=Sophos;i="6.06,199,1705334400"; 
   d="scan'208";a="10496851"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2024 16:37:00 +0800
IronPort-SDR: Htxiu8wMM2aFiBZewxnIB/Qzn4+7GE5RGB+XWenKxmT/7vhXIIFr4ikH7Mr6zdgxSrg6E+fPUk
 0T0nUmHYfaZg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Mar 2024 23:40:33 -0800
IronPort-SDR: eA0Ml1XokU3VnRe4rSVkrGZ7aNHtzviZQiGHaGQZdxomflEBF/M9FS+ZhTAqzKTTwF8eZrTyAz
 X/qkAp8qFY2g==
WDCIronportException: Internal
Received: from 87h6l33.ad.shared (HELO BXYGM33.ad.shared) ([10.225.32.8])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Mar 2024 00:36:57 -0800
From: Avri Altman <avri.altman@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 4/6] t/jobs: Rename test job 15
Date: Sat,  2 Mar 2024 10:36:11 +0200
Message-ID: <20240302083613.602-5-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240302083613.602-1-avri.altman@wdc.com>
References: <20240302083613.602-1-avri.altman@wdc.com>
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

