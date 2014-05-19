Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:40930 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaESB6l (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 18 May 2014 21:58:41 -0400
Received: by mail-ie0-f170.google.com with SMTP id at1so1676952iec.15
        for <fio@vger.kernel.org>; Sun, 18 May 2014 18:58:41 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 19 May 2014 09:58:41 +0800
Message-ID: <CA+8ZFnjK+68M1aSp4pFx=orD4fhM0D+Qi1QOjpQsDBwQvOhVSA@mail.gmail.com>
Subject: A possible patch for a dangling pointer issue of librbd engine
From: "xan.peng" <xanpeng@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, daniel.gollub@gmail.com

I'm interested in the librbd engine, and I possibly found a bug which
you can see from the following patch.

And you can see more information at https://github.com/axboe/fio/pull/10.
(BTW, are github pull requests the correct way to submit patches to fio?)

Signed-off-by: Xan Peng xanpeng@gmail.com
---
diff --git a/engines/rbd.c b/engines/rbd.c
index ff35373..38528c2 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -131,8 +131,10 @@ static int _fio_rbd_connect(struct thread_data *td)

 failed_open:
        rados_ioctx_destroy(rbd_data->io_ctx);
+       rbd_data->io_ctx = NULL;
 failed_shutdown:
        rados_shutdown(rbd_data->cluster);
+       rbd_data->cluster = NULL;
 failed_early:
        return 1;
 }
@@ -354,9 +356,8 @@ static int fio_rbd_setup(struct thread_data *td)
         */
        td->o.use_thread = 1;

-       /* connect in the main thread to determine to determine
-        * the size of the given RADOS block device. And disconnect
-        * later on.
+       /* connect in the main thread to determine the size of the given RADOS
+        * block device. And disconnect later on.
         */
        r = _fio_rbd_connect(td);
        if (r) {
