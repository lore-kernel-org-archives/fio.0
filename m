Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3AD208A9
	for <fio@vger.kernel.org>; Fri,  6 Sep 2024 02:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725590249; cv=none; b=ghk1OIAzeGT6v+4MpwH8F5HrY+DOfwQfTTVFdbT+hxQpErcwimHyzxHmCHihBWsu2XzthD7/vkRmFN0tlwCovYz8GQiaWcWfBKDmEEyQRbuwc05BN2RPO+4kmGV3Yku2XTkSyR8o8yAPwCJ1GOQzNRVgPmtHLMqso8nxeF+xUr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725590249; c=relaxed/simple;
	bh=mt8YWQy/jIC7SyVXz4l8X3xBvQ5jshb1ch09StqF0SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOVtCaS9t+JDjTHI5Y8AteVbjFJ2QVOhav0NeWbBSNaWfM7tQP1su6aDQlOcIKn0d7hfgsiz0OvMkKB4gV4eVBqCSwWEQzfNmikJf6f8Hfa3+5umIc7RrdiUJ+3SK/qtNQYWfbdxUwarLRrYNOp7DXW0N9uuwxjAn9MelF/Bfic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=JiKqqPym; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JiKqqPym"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1725590247; x=1757126247;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mt8YWQy/jIC7SyVXz4l8X3xBvQ5jshb1ch09StqF0SQ=;
  b=JiKqqPymaCGkNJXZ09fo77RnybZ9+xXKQFaQgfbAPw3HYV7DgRLkyWCl
   uGklvbl5xJGCajefcEEoJ3WGxw2JXDq6GV7X6AUZAQxk3QIohDAEnBlxg
   uYjmyWWYDgJDQ6G/fuiEwWSDN047eLo2mrv9KJa5vj/E1teCQsgPHRGPE
   zR6YzLNQp5EH/GlNeon+7+gUzStdEWdABI+Dk0oSCdOhnx6gWDDSbWbaa
   bK2q+x7SXo2Y8hPQ60YbEau+5JQNHFZ4sbTTdIYzuFIzN24F2AMCiubfa
   aIWhLabyeYtUiO2CK56ikYWjR+nMhiidrvKl7xRoaFjbBUJ7+bDtaGxqu
   w==;
X-CSE-ConnectionGUID: S4Lle4WUScuTXlEJmNtTeA==
X-CSE-MsgGUID: sjqPHwbdTG6zvdUWEeybKQ==
X-IronPort-AV: E=Sophos;i="6.10,206,1719849600"; 
   d="scan'208";a="26440244"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Sep 2024 10:37:20 +0800
IronPort-SDR: 66da5cc1_OrN2q9qQLXtyLw+TCzdWIXJwxS8b5KqA+evYLUBN+yAbNbo
 sJJRwHHNUiUZseIcS5FzxIT0B/S6N5KrQDtuh2w==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Sep 2024 18:37:06 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 05 Sep 2024 19:37:19 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/2] stat: fix the null io_u dereference in add_clat_sample()
Date: Fri,  6 Sep 2024 11:37:16 +0900
Message-ID: <20240906023717.1464031-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240906023717.1464031-1-shinichiro.kawasaki@wdc.com>
References: <20240906023717.1464031-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As recorded in the Link, NULL pointer dereference happens when the
write_lat_log option is specified for the file operations IO engine.
This failure was caused by the commit 14d3134a5fc0 ("introduce the
log_issue_time option") which added the new field 'issue_time' to the
struct log_sample. To calculate the issue time, add_clat_sample() was
modified to refer to io_u->issue_time. However, the file operations IO
engine passes NULL as the io_u pointer. Hence the failure.

Fix this by skipping the io_u->issue_time reference when io_u is NULL.
Instead, set 0 as the issue time.

Link: https://lore.kernel.org/fio/0e2c84c9-f9e4-4073-a075-016393ca7bde@gmail.com/
Fixes: 14d3134a5fc0 ("introduce the log_issue_time option")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 stat.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/stat.c b/stat.c
index 2cfd6819..c5413f2f 100644
--- a/stat.c
+++ b/stat.c
@@ -3340,8 +3340,11 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	if (td->clat_log) {
 		struct log_sample sample = { sample_val(nsec), ddir, bs,
-			offset, ioprio,
-			ntime_since(&td->epoch, &io_u->issue_time) };
+			offset, ioprio, 0 };
+
+		if (io_u)
+			sample.issue_time =
+				ntime_since(&td->epoch, &io_u->issue_time);
 
 		add_log_sample(td, td->clat_log, &sample);
 	}
-- 
2.45.2

