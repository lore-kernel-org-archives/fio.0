Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC961B81B8
	for <fio@vger.kernel.org>; Tue, 21 Jan 2025 08:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737448762; cv=none; b=q0X8g9NYWXjz6KyYSolVn7zSdHUkeYuDQLQBydleWP62aCnYD3eigkrtmdea8MsVhSTbf0+/ERpmG5dOnCOHtlYRkpOYRwWUTRhErJpNyUYERVe7FU53O1Y64OvJSyAca4W3/7uOXu3zrPLtcjNYHfVZ51kkSMok3SbVPluB0Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737448762; c=relaxed/simple;
	bh=uQotICjFkCTYXJ84GoXBR3EcmYczOcKhPxwfatP4+mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBjFi9YZNO2iiwzSVbW0dL85zJe+7SfzGn25EkPI6oxpVWYT1c4ASD44y8WnNi0vk7g//FaCr9ow4aSHo4CVKAOT3FdnerXWB7vL8p47edwd1EZU45ZQYl0JztOg73s+MMkemd6eJXg4q9+9dhyhnhwRbLHNBQvpDNR0978FKsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Vm9FZFxG; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Vm9FZFxG"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737448758; x=1768984758;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uQotICjFkCTYXJ84GoXBR3EcmYczOcKhPxwfatP4+mc=;
  b=Vm9FZFxGT+x0icz72sJr2J2shYGqK5lbypKVYLgVCVVcGBrZXAKDgCOt
   bHTRf3PcdVAc0TpwEdnFi+5Ewoz79Jbr5FfAG5B3Dp+lroGkuhqjdgjYB
   dCD18Ab79JgZLN8CGL8e+EKb0NarD4NB1RpRjxsEUx4bacoEFiDGzvkTd
   XXV2THGEjov0spWr8ul3RzomAGzy4msA4PdWwoMwx/Vzsy0TyRVc0GEGL
   i4TbbS2EUAVwEeb5vj3+9ht2FDC3kkL+YzEW6kRi/oxUK+j6n0NN1gbqi
   9OwN/kTmYSeEZndKv4SOdf7ugl2vJrsHDBoHXa2Ic2r+kf3BocJ7eDfEP
   w==;
X-CSE-ConnectionGUID: HNrI1PLrTM2Gc7HXgs+qKA==
X-CSE-MsgGUID: 2xY4MUbJRiK81XAW3cNjcw==
X-IronPort-AV: E=Sophos;i="6.13,221,1732550400"; 
   d="scan'208";a="36408679"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jan 2025 16:39:16 +0800
IronPort-SDR: 678f4f9e_VW0+tSnCuSW/V9oF7yv2gZGxUjxSpqIN3rSx/ugs6um56pi
 uMUinvqX404+EiZiD2NMFt4gEVNp7tNF+AgwK/g==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jan 2025 23:41:18 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Jan 2025 00:39:15 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/2] zbd: do not check open zones status and limits when jobs do not write
Date: Tue, 21 Jan 2025 17:39:12 +0900
Message-ID: <20250121083913.1216619-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250121083913.1216619-1-shinichiro.kawasaki@wdc.com>
References: <20250121083913.1216619-1-shinichiro.kawasaki@wdc.com>
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

