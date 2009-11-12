Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:37929 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbZKLAsk (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 11 Nov 2009 19:48:40 -0500
Received: from zps19.corp.google.com (zps19.corp.google.com [172.25.146.19])
	by smtp-out.google.com with ESMTP id nAC0mibD006296
	for <fio@vger.kernel.org>; Thu, 12 Nov 2009 00:48:45 GMT
Received: from pwj8 (pwj8.prod.google.com [10.241.219.72])
	by zps19.corp.google.com with ESMTP id nAC0laHa003730
	for <fio@vger.kernel.org>; Wed, 11 Nov 2009 16:48:42 -0800
Received: by pwj8 with SMTP id 8so1102828pwj.33
        for <fio@vger.kernel.org>; Wed, 11 Nov 2009 16:48:42 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 11 Nov 2009 16:48:42 -0800
Message-ID: <66dfd3fe0911111648u17b94ff1sd95fd9e040fca947@mail.gmail.com>
Subject: Log bad veify header location
From: Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, fio@vger.kernel.org

Hi,
Can we please add the bad verify header location when the header
MAGIC_NUMBER does not match.
Thanks
-radha

diff --git a/verify.c b/verify.c
index 84e888b..52e1289 100644
--- a/verify.c
+++ b/verify.c
@@ -478,7 +478,8 @@ int verify_io_u(struct thread_data *td, struct io_u *io_u)
                hdr = p;

                if (hdr->fio_magic != FIO_HDR_MAGIC) {
-                       log_err("Bad verify header %x\n", hdr->fio_magic);
+                       log_err("Bad verify header %x at %llu\n",
hdr->fio_magic,
+                               io_u->offset + hdr_num * hdr->len);
                        return EILSEQ;
                }
