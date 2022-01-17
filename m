Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 840E8C433EF
	for <fio@archiver.kernel.org>; Mon, 17 Jan 2022 02:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236797AbiAQCLa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 16 Jan 2022 21:11:30 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:6774 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233977AbiAQCL2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 16 Jan 2022 21:11:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1642385488; x=1673921488;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rPkgk5pNviSA2KceZTGZ0fK3KnpB1xguYCkwldDex1Y=;
  b=dUK7ngahAXiPmsE3cPFI/IsZEXVNHNrF+ZbfoFxgxrFbvKPXqnUvbKNq
   +VT4Sp0cixen6kY7HdkICRK9eU9roib4XWp4/xtLe6wJNYgYBdQZ9urjR
   c9C1wFVXuhRiuivCmhkmhUaa3oYvPSul+nXm8gBYGYHIieUXEEe2kYOED
   f7Ykz6WIP8V58zl8utMa/69z0c/RJYJ6GQTCZNIBfq4naTXaI8ioVMvi5
   FZCSlWZhdn4z6pOUhYl3hwY0XhoADcfTmRcpbZWAVWg4VQbpelm0+rlA6
   xXWcX5CqneMtHij18XKsbISmHpRGcqOCMmQMM40e7geHEor8zlf8nNpwA
   w==;
X-IronPort-AV: E=Sophos;i="5.88,294,1635177600"; 
   d="scan'208";a="294665996"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jan 2022 10:11:28 +0800
IronPort-SDR: tPz1XTLKszpvcibSTyIqi55bRB889xrgYiqNtbzD7bfE78KpY6UCDS6vMtIJRqq2zp/95EJkpU
 sBoWdOpI4gQyVIgseB7Pdn/Sn0A3p/gcLp4F9qJo4yWEQ53zLAArQktSqP5qqjCyd9mTVJGgo/
 ca7ngH18eZKnCzXLTJhsPsFvDJA2TmRJWMVakom6V+sE2uyLOFOBJ8BBEmjW2E0cvzb8m5Vj44
 ayOyBb55gX1snwu6ykquXPO4LeoFcOp7imq4KDFELlaq/D8c77QTblJj7sJi2vzWyxH8UDQIZt
 EpmB5NBS7OQ42vY4JVCmWuEJ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2022 17:43:44 -0800
IronPort-SDR: b8u8xekQoUlDjYHBqY9Ht7r1gqNRmB4/3Q1xiuDEUwdTEUqMvOSNeond4rynhZLagTJImN2X/9
 CdO8/rBU0ypEIzR/os9PHt7gV3kt2H6GtkSi4xWBOjjt28Ic70lcQ09xbIrLk1lauftE8ulI2S
 38ZZR4HLPIn8d4wz8jb4DsCtTXshnCvPh35IDtSs06+rTQqkdHQQRecIMjvOEc7/ZoOAX1HD3M
 9Q6ohcJDgQBaYHX5GhtmWNuvgIurpoL2eQUZFJIxE9/zQAoTCzi79wzmKsVYbzPysBOoIoUPDu
 NaM=
WDCIronportException: Internal
Received: from unknown (HELO twashi.fujisawa.hgst.com) ([10.225.163.49])
  by uls-op-cesaip02.wdc.com with ESMTP; 16 Jan 2022 18:11:27 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH] init: do not create lat logs when not needed
Date:   Mon, 17 Jan 2022 11:11:27 +0900
Message-Id: <20220117021127.9259-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When any of the options disable_lat, disable_slat and disable_clat are
used, there is no need to create the lat log associated with the
disabled latency. In addition, when write_lat_log is also specified,
this change avoids the creation of empty latency log files.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 init.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/init.c b/init.c
index 5f069d9a..07daaa84 100644
--- a/init.c
+++ b/init.c
@@ -1586,17 +1586,23 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		else
 			suf = "log";
 
-		gen_log_name(logname, sizeof(logname), "lat", pre,
-				td->thread_number, suf, o->per_job_logs);
-		setup_log(&td->lat_log, &p, logname);
+		if (!o->disable_lat) {
+			gen_log_name(logname, sizeof(logname), "lat", pre,
+				     td->thread_number, suf, o->per_job_logs);
+			setup_log(&td->lat_log, &p, logname);
+		}
 
-		gen_log_name(logname, sizeof(logname), "slat", pre,
-				td->thread_number, suf, o->per_job_logs);
-		setup_log(&td->slat_log, &p, logname);
+		if (!o->disable_slat) {
+			gen_log_name(logname, sizeof(logname), "slat", pre,
+				     td->thread_number, suf, o->per_job_logs);
+			setup_log(&td->slat_log, &p, logname);
+		}
 
-		gen_log_name(logname, sizeof(logname), "clat", pre,
-				td->thread_number, suf, o->per_job_logs);
-		setup_log(&td->clat_log, &p, logname);
+		if (!o->disable_clat) {
+			gen_log_name(logname, sizeof(logname), "clat", pre,
+				     td->thread_number, suf, o->per_job_logs);
+			setup_log(&td->clat_log, &p, logname);
+		}
 
 	}
 
-- 
2.34.1

