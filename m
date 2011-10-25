Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:14272 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab1JYUdY (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 25 Oct 2011 16:33:24 -0400
Received: from hpaq1.eem.corp.google.com (hpaq1.eem.corp.google.com [172.25.149.1])
	by smtp-out.google.com with ESMTP id p9PKXNY1005667
	for <fio@vger.kernel.org>; Tue, 25 Oct 2011 13:33:23 -0700
Received: from ggnp4 (ggnp4.prod.google.com [10.218.98.68])
	by hpaq1.eem.corp.google.com with ESMTP id p9PKV4kr028498
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Tue, 25 Oct 2011 13:33:22 -0700
Received: by ggnp4 with SMTP id p4so1287294ggn.10
        for <fio@vger.kernel.org>; Tue, 25 Oct 2011 13:33:22 -0700 (PDT)
MIME-Version: 1.0
From: Steven Lang <tirea@google.com>
Date: Tue, 25 Oct 2011 13:33:01 -0700
Message-ID: <CAAUT-yPmmiUVeKDXLCKzUxL8uyYHgAT_8buF3Oor_rpy7QqBaw@mail.gmail.com>
Subject: [PATCH] Add code for verify_dump option
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Jens Axboe <jaxboe@fusionio.com>

The verify_dump option is defined and documented, but does nothing.
This one-liner enables the option.

One thing I wanted to open a small discussion on is the default
behavior.  When the verify dump behavior was added, it was something
new, so it seems more sensible to disable it by default to keep the
old behavior; and had it been in for less time I might have been
tempted to include that in the patch.  However, even ignoring the
change in behavior, it seems odd and possibly surprising/unexpected to
someone who does not have experience with fio to have it suddenly spit
out extra files; all the other options to write files
(write_iolog/write_bw_log/write_lat_log) only write anything if
requested.  Is there a good argument to why this option would be
enabled by default?

diff --git a/verify.c b/verify.c
index 68ee60f..36b49f2 100644
--- a/verify.c
+++ b/verify.c
@@ -269,6 +269,9 @@ static void dump_verify_buffers(struct
verify_header *hdr, struct vcont *vc)
 	struct io_u dummy;
 	void *buf;

+        if (!vc->td->o.verify_dump)
+          return;
+
 	/*
 	 * Dump the contents we just read off disk
 	 */
