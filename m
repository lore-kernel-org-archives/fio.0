Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:30217 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbZEUVkP (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 21 May 2009 17:40:15 -0400
Received: from wpaz24.hot.corp.google.com (wpaz24.hot.corp.google.com [172.24.198.88])
	by smtp-out.google.com with ESMTP id n4LLeE9w021481
	for <fio@vger.kernel.org>; Thu, 21 May 2009 22:40:15 +0100
Received: from qw-out-1920.google.com (qwj9.prod.google.com [10.241.195.73])
	by wpaz24.hot.corp.google.com with ESMTP id n4LLeDEJ001244
	for <fio@vger.kernel.org>; Thu, 21 May 2009 14:40:13 -0700
Received: by qw-out-1920.google.com with SMTP id 9so882615qwj.36
        for <fio@vger.kernel.org>; Thu, 21 May 2009 14:40:13 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 21 May 2009 14:40:13 -0700
Message-ID: <66dfd3fe0905211440s2b95867ex12a741e7a391b2fb@mail.gmail.com>
Subject: Set io_u field(endpos) value during verify phase
From: Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
We ran into an issue where during the verify phase (sync engine),
because the io_u->endpos field was not set, it was using a stale
value.
If the sync engine is used then for every read(during the verify
phase) to avoid an extra seek, the code checks if we are already at
the position we expect to be at and if so bypasses the seek.
So in the case where the current file position field which is stale
(From the previous i/o completion) matches  where the read needs to be
done from, there will be no seek and the code lands up reading the
wrong data and goes down the error path because the data does not
match.
This case is only seen during the verify phase where the code uses
__get_io_u directly. In the regular read/write phase the code uses
get_io_u and that function correctly sets the value of the endpos
field.

Hopefully, I explained the problem coherently

Here is the fix:

diff -up verify.c.old verify.c
--- verify.c.old        2009-05-21 13:14:51.703698000 -0700
+++ verify.c    2009-05-21 13:18:48.052540000 -0700
@@ -711,6 +711,7 @@ int get_next_verify(struct thread_data *
                io_u->ddir = DDIR_READ;
                io_u->xfer_buf = io_u->buf;
                io_u->xfer_buflen = io_u->buflen;
+               io_u->endpos = io_u->offset + io_u->buflen;
                free(ipo);
                dprint(FD_VERIFY, "get_next_verify: ret io_u %p\n", io_u);
                return 0;


Thanks
-radha
