Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:37724 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab2BVCb3 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 21 Feb 2012 21:31:29 -0500
Received: by yhgm50 with SMTP id m50so919215yhg.1
        for <fio@vger.kernel.org>; Tue, 21 Feb 2012 18:31:28 -0800 (PST)
MIME-Version: 1.0
From: Dan Ehrenberg <dehrenberg@google.com>
Subject: [PATCH] flow: Fixing uninitialized variable
Date: Tue, 21 Feb 2012 18:31:26 -0800
Message-Id: <1329877886-1930-1-git-send-email-dehrenberg@google.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: nauman@google.com, egouriou@google.com, tirea@google.com, Dan Ehrenberg <dehrenberg@google.com>

In the flow initialization code path, there was an uninitialized
variable that led to memory corruption in certain cases. This
patch should initialize the variable properly.
---
 flow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/flow.c b/flow.c
index e5c4a40..bf5eeec 100644
--- a/flow.c
+++ b/flow.c
@@ -36,7 +36,7 @@ int flow_threshold_exceeded(struct thread_data *td)
 
 static struct fio_flow *flow_get(unsigned int id)
 {
-	struct fio_flow *flow;
+	struct fio_flow *flow = NULL;
 	struct flist_head *n;
 
 	fio_mutex_down(flow_lock);
-- 
1.7.7.3

