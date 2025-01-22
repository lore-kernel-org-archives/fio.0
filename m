Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DC554648
	for <fio@vger.kernel.org>; Wed, 22 Jan 2025 01:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737509927; cv=none; b=XUUqrkgEjgRFQLeMUv0yb5+8TzoB/llRwGNQFt8/tlaywsAI4lPVm8RT43U1mxY2lAnQ6QaXhlxAqOTyymtuC3xrJSxgc1gvztNHMLlud8a8Up7tepJY1GHRpXkUdorM+1iUQVZRLSrFi0uqab1ocD/wA1EjvmF/bzMQXkTcyIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737509927; c=relaxed/simple;
	bh=dHvEJHZLXHiX9UsbL5NtYjt2qbPcE/dXgPHVJcKRXhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0Xg0p/Luod/FOn2NqT/e+owOImPyQMdeGOyv0pqLNQe7UQYbjjODkaAU+Juqu5lI9MOJ0Ps6RV2KLH/vHUFD0YPlXjiFsFMBuzqDP+RUxy2nhZwRvYnl5sX7nbtne9y5Tm+tT/FjesmyBEH//EXjMQKODNpfKoYy5X0cSTjrLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=eL6QlEUt; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eL6QlEUt"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737509926; x=1769045926;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dHvEJHZLXHiX9UsbL5NtYjt2qbPcE/dXgPHVJcKRXhg=;
  b=eL6QlEUtnWNX119Q9DwFfcqRX5rxaF5TW+PbgBygrCbpAZnipahygOgF
   6zRcXE9VLY0dPVfVOjkkgM2/4POkJhKuF1a7NQLLxDvcmJ08eTVno8qdx
   STy9DYdvd4ty+GDTh1IttSKYAIKax7v+LIIPT6Z1JCZKkvbY6Misstgjg
   HYn85xWDN9IKghI+7xwlptO4M8iB4yzFEbp5L/r2/7GN4UCKEY96UYQ6c
   k/6s65ueAj7X4jRuD2VzA901z6etadRLsDfr1KD96euuS7NTnHYrY/6tU
   MK4uSGQztW51bbHLzfNlJDHwUWIS7Ax5BKpzsQlK0Wz4/tUrwGuv5hLfj
   g==;
X-CSE-ConnectionGUID: kRuDfQrjTAaQ5vjUQr1atw==
X-CSE-MsgGUID: gxwETKBVQkyF3c+/Vixwpw==
X-IronPort-AV: E=Sophos;i="6.13,223,1732550400"; 
   d="scan'208";a="37689156"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jan 2025 09:38:38 +0800
IronPort-SDR: 67903e87_tI7rZx6lUCMdrSLSkRYNlCPItMP9hxEpJsbl3Cqp7U45tZ6
 S5wclaRx0xRLYlwZ2ifHQazFqqust7eoV7w/lpw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Jan 2025 16:40:39 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 21 Jan 2025 17:38:38 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 1/2] zbd: do not check open zones status and limits when jobs do not write
Date: Wed, 22 Jan 2025 10:38:34 +0900
Message-ID: <20250122013835.1223725-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250122013835.1223725-1-shinichiro.kawasaki@wdc.com>
References: <20250122013835.1223725-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, fio checks the conditions of each zone within the IO range at
the job start. If a zone is in an open condition, it is added to the
write target zone array. If the number of write target zones exceeds the
max_open_zones or job_max_open_zones limit, fio terminates with the
error message "Number of open zones exceeds max_open_zones limit". This
check for zone condition and the resulting termination occur even when
the job does not perform a write operation, leading to confusion among
users.

To avoid the confusion, skip the check when jobs do not perform write
operations. Additionally, print the message to inform that the
job_max_open_zones limit does not work for non-write jobs.

Fixes: 954217b90191 ("zbd: Initialize open zones list referring zone status at fio start")
Fixes: 8ac768899d63 ("zbd: do not reset extra zones in open conditions")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/zbd.c b/zbd.c
index 8a092cbe..ee095b1d 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1264,6 +1264,16 @@ int zbd_setup_files(struct thread_data *td)
 			return 1;
 		}
 
+		/*
+		 * If this job does not do write operations, skip open zone
+		 * condition check.
+		 */
+		if (!td_write(td)) {
+			if (td->o.job_max_open_zones)
+				log_info("'job_max_open_zones' is valid only for write jobs\n");
+			continue;
+		}
+
 		/*
 		 * The per job max open zones limit cannot be used without a
 		 * global max open zones limit. (As the tracking of open zones
-- 
2.47.0

