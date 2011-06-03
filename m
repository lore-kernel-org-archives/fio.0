Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:49602 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab1FCTOq (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 3 Jun 2011 15:14:46 -0400
Received: from kpbe20.cbf.corp.google.com (kpbe20.cbf.corp.google.com [172.25.105.84])
	by smtp-out.google.com with ESMTP id p53JEjER023015
	for <fio@vger.kernel.org>; Fri, 3 Jun 2011 12:14:45 -0700
Received: from gwb1 (gwb1.prod.google.com [10.200.2.1])
	by kpbe20.cbf.corp.google.com with ESMTP id p53JE9Fl016982
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Fri, 3 Jun 2011 12:14:44 -0700
Received: by gwb1 with SMTP id 1so1287624gwb.22
        for <fio@vger.kernel.org>; Fri, 03 Jun 2011 12:14:44 -0700 (PDT)
MIME-Version: 1.0
From: Steven Lang <tirea@google.com>
Date: Fri, 3 Jun 2011 12:14:24 -0700
Message-ID: <BANLkTi=qFqUv00QCh5yBV9_7jCg07E4qZ3mE7uAm_tugns7dow@mail.gmail.com>
Subject: Small cleanup patch
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: jaxboe@fusionio.com

The wrong ddir enum was being used here, which trips up compilers
which want to strictly check enum usage.

diff --git a/fio.c b/fio.c
index 76c6ebd..34956e9 100644
--- a/fio.c
+++ b/fio.c
@@ -180,7 +180,7 @@ static void set_sig_handlers(void)
  * Check if we are above the minimum rate given.
  */
 static int __check_min_rate(struct thread_data *td, struct timeval *now,
-			    enum td_ddir ddir)
+			    enum fio_ddir ddir)
 {
 	unsigned long long bytes = 0;
 	unsigned long iops = 0;
-- 

- Steven
