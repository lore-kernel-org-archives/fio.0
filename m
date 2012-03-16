Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:37493 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946300Ab2CPXr3 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 16 Mar 2012 19:47:29 -0400
Received: by qadc11 with SMTP id c11so78617qad.19
        for <fio@vger.kernel.org>; Fri, 16 Mar 2012 16:47:29 -0700 (PDT)
MIME-Version: 1.0
From: Steven Lang <tirea@google.com>
Date: Fri, 16 Mar 2012 16:47:08 -0700
Message-ID: <CAAUT-yPxQ5obvo_cnkcZySRDHwx8K=tvDtc=v5cLNjZGMw4wLQ@mail.gmail.com>
Subject: [PATCH] Added 99.95 and 99.99 default percentiles.
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Since there are 20 slots for percentiles, but not all used by default,
I figure it doesn't hurt to add a couple extra percentiles to the
default for tail latency capture.

---
 init.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/init.c b/init.c
index 6c74ea6..69ed30c 100644
--- a/init.c
+++ b/init.c
@@ -74,21 +74,23 @@ static char cmd_optstr[256];
 static int did_arg;

 const fio_fp64_t def_percentile_list[FIO_IO_U_LIST_MAX_LEN] = {
-	{ .u.f	=  1.0 },
-	{ .u.f	=  5.0 },
-	{ .u.f	= 10.0 },
-	{ .u.f	= 20.0 },
-	{ .u.f	= 30.0 },
-	{ .u.f	= 40.0 },
-	{ .u.f	= 50.0 },
-	{ .u.f	= 60.0 },
-	{ .u.f	= 70.0 },
-	{ .u.f	= 80.0 },
-	{ .u.f	= 90.0 },
-	{ .u.f	= 95.0 },
-	{ .u.f	= 99.0 },
-	{ .u.f	= 99.5 },
-	{ .u.f	= 99.9 },
+	{ .u.f	=  1.00 },
+	{ .u.f	=  5.00 },
+	{ .u.f	= 10.00 },
+	{ .u.f	= 20.00 },
+	{ .u.f	= 30.00 },
+	{ .u.f	= 40.00 },
+	{ .u.f	= 50.00 },
+	{ .u.f	= 60.00 },
+	{ .u.f	= 70.00 },
+	{ .u.f	= 80.00 },
+	{ .u.f	= 90.00 },
+	{ .u.f	= 95.00 },
+	{ .u.f	= 99.00 },
+	{ .u.f	= 99.50 },
+	{ .u.f	= 99.90 },
+	{ .u.f	= 99.95 },
+	{ .u.f	= 99.99 },
 };

 #define FIO_CLIENT_FLAG		(1 << 16)
-- 
1.7.7.3
