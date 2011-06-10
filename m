Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:63054 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab1FJTGQ (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 10 Jun 2011 15:06:16 -0400
Received: from hpaq3.eem.corp.google.com (hpaq3.eem.corp.google.com [172.25.149.3])
	by smtp-out.google.com with ESMTP id p5AJ6Em2013151
	for <fio@vger.kernel.org>; Fri, 10 Jun 2011 12:06:15 -0700
Received: from gxk22 (gxk22.prod.google.com [10.202.11.22])
	by hpaq3.eem.corp.google.com with ESMTP id p5AJ5IFa003711
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Fri, 10 Jun 2011 12:06:13 -0700
Received: by gxk22 with SMTP id 22so2297174gxk.30
        for <fio@vger.kernel.org>; Fri, 10 Jun 2011 12:06:13 -0700 (PDT)
MIME-Version: 1.0
From: Steven Lang <tirea@google.com>
Date: Fri, 10 Jun 2011 12:05:53 -0700
Message-ID: <BANLkTi=LKqCz1Pg0w3Pk8i2OzgHcQFat4A@mail.gmail.com>
Subject: Asynch IO and fill_device
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: jaxboe@fusionio.com, fio@vger.kernel.org

I found an interesting combination of using fill_device when the
iodepth is greater than 1.  All outstanding IO causes an ENOSPC error,
but only the first is treated specially.  The remainder come through
and cause an error exit condition when the IO queue is being cleared.
So it is impossible to use deep IO with fill device.

This patch should fix the issue.


diff --git a/fio.c b/fio.c
index 34956e9..5ea1a2c 100644
--- a/fio.c
+++ b/fio.c
@@ -760,8 +760,11 @@ sync_done:
                struct fio_file *f;

                i = td->cur_depth;
-               if (i)
+               if (i) {
                        ret = io_u_queued_complete(td, i, NULL);
+                       if (td->o.fill_device && td->error == ENOSPC)
+                               td->error = 0;
+               }

                if (should_fsync(td) && td->o.end_fsync) {
                        td_set_runstate(td, TD_FSYNCING);
--
