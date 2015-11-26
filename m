Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38378 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbbKZPvO (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 26 Nov 2015 10:51:14 -0500
Received: by wmec201 with SMTP id c201so27479651wme.1
        for <fio@vger.kernel.org>; Thu, 26 Nov 2015 07:51:12 -0800 (PST)
Received: from cuboid ([185.27.182.2])
        by smtp.gmail.com with ESMTPSA id uz5sm28617848wjc.8.2015.11.26.07.51.11
        for <fio@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Thu, 26 Nov 2015 07:51:11 -0800 (PST)
Message-ID: <1448553070.29391.3.camel@x-ion.de>
Subject: Re: RBD client cache
From: Jens Rosenboom <j.rosenboom@x-ion.de>
Date: Thu, 26 Nov 2015 16:51:10 +0100
In-Reply-To: <564E318C.3060602@kernel.dk>
References: <CADr68WZZqpVAeS-EuUgc5eOz=XoyrcCWCTymx58WBEAger442A@mail.gmail.com>
	 <564E318C.3060602@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

From dbd950891a43a7104bce5ec935cd992c7e2b27ff Mon Sep 17 00:00:00 2001
From: Jens Rosenboom <j.rosenboom@x-ion.de>
Date: Thu, 26 Nov 2015 16:27:49 +0100
Subject: [PATCH] Add an option to flush RBD after opening

With recent Ceph releases the default value for

rbd cache writethrough until flush

has been changed to true, so the librbd client cache will stay in
writethrough mode for fio.

This patch adds an option to perform an rbd_flush() call after opening
the RBD, causing the client cache to activate writeback mode.

Signed-off-by: Jens Rosenboom <j.rosenboom@x-ion.de>
---

This works in my test enviroment and boosts 4k randwrites at iodepth=1 from 100 to 6000.
Still it would probably be good if other people could test this, too.


 engines/rbd.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/engines/rbd.c b/engines/rbd.c
index 2be9b55..b3efedf 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -30,6 +30,7 @@ struct rbd_options {
 	char *pool_name;
 	char *client_name;
 	int busy_poll;
+	int flush_on_open;
 };
 
 static struct fio_option options[] = {
@@ -71,6 +72,16 @@ static struct fio_option options[] = {
 		.group		= FIO_OPT_G_RBD,
 	},
 	{
+		.name		= "flush_on_open",
+		.lname		= "Flush on open",
+		.type		= FIO_OPT_BOOL,
+		.help		= "Flush on opening the RBD to activate client cache",
+		.off1		= offsetof(struct rbd_options, flush_on_open),
+		.def		= "0",
+		.category	= FIO_OPT_C_ENGINE,
+		.group		= FIO_OPT_G_RBD,
+	},
+	{
 		.name = NULL,
 	},
 };
@@ -140,6 +151,13 @@ static int _fio_rbd_connect(struct thread_data *td)
 		log_err("rbd_open failed.\n");
 		goto failed_open;
 	}
+	if (o->flush_on_open) {
+		r = rbd_flush(rbd->image);
+		if (r < 0) {
+			log_err("rbd_flush failed.\n");
+			goto failed_open;
+		}
+	}
 	return 0;
 
 failed_open:
-- 
2.4.10

