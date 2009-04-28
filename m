Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:42235 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbZD1Vjx (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 28 Apr 2009 17:39:53 -0400
Received: from wpaz33.hot.corp.google.com (wpaz33.hot.corp.google.com [172.24.198.97])
	by smtp-out.google.com with ESMTP id n3SLdpPS005307
	for <fio@vger.kernel.org>; Tue, 28 Apr 2009 14:39:52 -0700
Received: from yx-out-2324.google.com (yxm8.prod.google.com [10.190.4.8])
	by wpaz33.hot.corp.google.com with ESMTP id n3SLdLLH024476
	for <fio@vger.kernel.org>; Tue, 28 Apr 2009 14:39:50 -0700
Received: by yx-out-2324.google.com with SMTP id 8so451322yxm.29
        for <fio@vger.kernel.org>; Tue, 28 Apr 2009 14:39:50 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 28 Apr 2009 14:39:50 -0700
Message-ID: <66dfd3fe0904281439v72b661e5n1319025c8a9f8e6@mail.gmail.com>
Subject: Fix name of the slat log file
From: Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Fix the name of the latency log file:
Currently the slat and clat logs go to the same clat log file when the
latency log file is specified.

diff -up fio.c.orig fio.c
--- fio.c.orig  2009-04-28 14:37:50.049570000 -0700
+++ fio.c       2009-04-28 14:38:17.306291000 -0700
@@ -1086,7 +1086,7 @@ static void *thread_main(void *data)
        if (td->ts.slat_log) {
                if (td->o.lat_log_file) {
                        finish_log_named(td, td->ts.slat_log,
-                                               td->o.lat_log_file, "clat");
+                                               td->o.lat_log_file, "slat");
                } else
                        finish_log(td, td->ts.slat_log, "slat");
        }

thanks
-radha
