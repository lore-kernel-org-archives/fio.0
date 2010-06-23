Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.valinux.co.jp ([210.128.90.3]:37606 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab0FWChz (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 22 Jun 2010 22:37:55 -0400
Subject: fix 1000 vs kb_base confusion in show_run_stats.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20100623023753.92DB271923@kuma.localdomain>
Date: Wed, 23 Jun 2010 11:37:53 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

hi,

please apply the following patch.

YAMAMOTO Takashi


Signed-off-by: YAMAMOTO Takashi <yamamoto@valinux.co.jp>

commit 6225a65ed63f82ae30258d3e0d45e179a645ca05
Author: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Date:   Wed Jun 23 11:36:01 2010 +0900

    fix 1000 vs kb_base confusion in show_run_stats.

diff --git a/stat.c b/stat.c
index 9d1f66a..143325a 100644
--- a/stat.c
+++ b/stat.c
@@ -635,9 +635,9 @@ void show_run_stats(void)
 		max_run[1] = rs->max_run[1];
 
 		if (rs->max_run[0])
-			rs->agg[0] = (rs->io_kb[0] * 1000) / max_run[0];
+			rs->agg[0] = (rs->io_kb[0] * rs->kb_base) / max_run[0];
 		if (rs->max_run[1])
-			rs->agg[1] = (rs->io_kb[1] * 1000) / max_run[1];
+			rs->agg[1] = (rs->io_kb[1] * rs->kb_base) / max_run[1];
 	}
 
 	/*
