Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.154.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B512BD5A3
	for <fio@vger.kernel.org>; Thu, 31 Jul 2025 12:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753964489; cv=none; b=tHxhqMX9v9Y8TaYR/C9JqTqz7Sy1/c5HYaIWJll0qfLdOimCwcWVVglmqKytK+t7PUPnY0UuMnvHLODL/xINA6JqAPEdPQUDeoMhBk/szAibek9VbpJEf3iMnZ0BT5GikWfxwJ0X8hrAMkjQs5XdYOBY1bdnksYo2cMsQ7A4zYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753964489; c=relaxed/simple;
	bh=Fjx2KH1iA6eGtykqQEy34UiEfm5p2SB9YI8EoriCzU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eekj2Lm/WULVQloJJomhczieifFb+VhnGQS6jF1NI6BhWTM5R3cwFLqqPQLSjPbmgcn3yQLPe6ckmJ3YKClGEwXRXbdtq36n0MqGS0TBRE6G/ZVloEQrhvHlKJ2sKbCxqeOynJbVoGV1xFvyTO6yRx5ZQy8A8QlCj3C/0SRw8U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=taq961K/; arc=none smtp.client-ip=216.71.154.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="taq961K/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1753964487; x=1785500487;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fjx2KH1iA6eGtykqQEy34UiEfm5p2SB9YI8EoriCzU4=;
  b=taq961K/SlbrtkRYXltuOQaZdD9gj05Tsmupn+tx03D8qUpp7d1uOPjP
   W0OBsjwF83PnYmtELlNo/KeZqdCwqUKj6VVjhngpGQOOMzaxwI0eLiC1x
   ZAyag7KdvPGHLzMS/pyD59ItFhOKy/SuUveaCISwieUFRUnzAWb20+k7n
   b44Sfz1vAGcQkQ1aBL9GfXaaZpsutY2pT1Ce2/LVR2gQPZ5ruvCXzcRTK
   ireLV+InIIPAohwJVefN/bmtFkPGJDLQR+fIn1ijLYf0iTRRKxGFYBdu1
   mtZZU0R3f8U0l8i52F/67wFSCU6esxKE4A1WQ2vBi5oWpIJGipCp2YIW4
   Q==;
X-CSE-ConnectionGUID: RqxzYxcVRaSuKRAPg+shyA==
X-CSE-MsgGUID: jY+YquSySIiTjwEeHuuswA==
Received: from unknown (HELO uls-op-esaep02.corp.sandisk.com) ([129.253.192.43])
  by ob1.hc6817-7.iphmx.com with ESMTP; 31 Jul 2025 05:20:18 -0700
IronPort-SDR: 688b5f82_2DoAORENvINzc7K8vpQe4t7diBiFqdeWPbUR+R4spvHVcZX
 nG/W5GzMj+o2JHC73kEat4HzxK3iWx1aF2O8row==
Received: from unknown (HELO uls-op-esaip02.corp.sandisk.com) ([10.15.0.10])
  by uls-op-esaep02.corp.sandisk.com with ESMTP; 31 Jul 2025 05:20:19 -0700
SanDiskIronportException: Internal
Received: from ulssdxvpxsnip.corp.sandisk.com (HELO sandisk-inand-1.sdcorp.global.sandisk.com) ([10.9.34.160])
  by uls-op-esaip02.corp.sandisk.com with ESMTP; 31 Jul 2025 05:20:18 -0700
From: Tomas Winkler <tomas.winkler@sandisk.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Tomas Winkler <tomas.winkler@sandisk.com>
Subject: [PATCH 2/2] eta: convert skip_eta() to ANSI C declaration
Date: Thu, 31 Jul 2025 15:20:11 +0300
Message-ID: <20250731122011.539660-2-tomas.winkler@sandisk.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250731122011.539660-1-tomas.winkler@sandisk.com>
References: <20250731122011.539660-1-tomas.winkler@sandisk.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update skip_eta() to use an ANSI C function declaration
by explicitly specifying the void parameter list.

Signed-off-by: Tomas Winkler <tomas.winkler@sandisk.com>
---
 eta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/eta.c b/eta.c
index 7d07708f..16109510 100644
--- a/eta.c
+++ b/eta.c
@@ -381,7 +381,7 @@ bool eta_time_within_slack(unsigned int time)
  * These are the conditions under which we might be able to skip the eta
  * calculation.
  */
-static bool skip_eta()
+static bool skip_eta(void)
 {
 	if (!(output_format & FIO_OUTPUT_NORMAL) && f_out == stdout)
 		return true;
-- 
2.45.2

