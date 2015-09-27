Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36096 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbbI0TZE (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 27 Sep 2015 15:25:04 -0400
Received: by wicgb1 with SMTP id gb1so78097551wic.1
        for <fio@vger.kernel.org>; Sun, 27 Sep 2015 12:25:02 -0700 (PDT)
From: Roman Pen <r.peniaev@gmail.com>
Subject: [PATCH 1/2] fio.1,HOWTO: keep 'iodepth_batch' option in sync
Date: Sun, 27 Sep 2015 21:24:54 +0200
Message-Id: <1443381895-21287-1-git-send-email-r.peniaev@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 
Cc: Roman Pen <r.peniaev@gmail.com>, fio@vger.kernel.org

Signed-off-by: Roman Pen <r.peniaev@gmail.com>
Cc: fio@vger.kernel.org
---
 HOWTO | 3 ++-
 fio.1 | 7 +++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/HOWTO b/HOWTO
index d3ead19..3049316 100644
--- a/HOWTO
+++ b/HOWTO
@@ -812,7 +812,8 @@ iodepth_batch_submit=int
 iodepth_batch=int This defines how many pieces of IO to submit at once.
 		It defaults to 1 which means that we submit each IO
 		as soon as it is available, but can be raised to submit
-		bigger batches of IO at the time.
+		bigger batches of IO at the time. If it is set to 0 the iodepth
+		value will be used.
 
 iodepth_batch_complete=int This defines how many pieces of IO to retrieve
 		at once. It defaults to 1 which means that we'll ask
diff --git a/fio.1 b/fio.1
index c1cb2a5..aea9f34 100644
--- a/fio.1
+++ b/fio.1
@@ -698,8 +698,11 @@ Linux when using libaio and not setting \fBdirect\fR=1, since buffered IO is
 not async on that OS. Keep an eye on the IO depth distribution in the
 fio output to verify that the achieved depth is as expected. Default: 1.
 .TP
-.BI iodepth_batch \fR=\fPint
-Number of I/Os to submit at once.  Default: \fBiodepth\fR.
+.BI iodepth_batch \fR=\fPint "\fR,\fP iodepth_batch_submit" \fR=\fPint
+This defines how many pieces of IO to submit at once. It defaults to 1
+which means that we submit each IO as soon as it is available, but can
+be raised to submit bigger batches of IO at the time. If it is set to 0
+the \fBiodepth\fR value will be used.
 .TP
 .BI iodepth_batch_complete \fR=\fPint
 This defines how many pieces of IO to retrieve at once. It defaults to 1 which
-- 
2.5.1

