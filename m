Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:59012 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbZD0W65 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 27 Apr 2009 18:58:57 -0400
Received: from spaceape23.eur.corp.google.com (spaceape23.eur.corp.google.com [172.28.16.75])
	by smtp-out.google.com with ESMTP id n3RMwusI003388
	for <fio@vger.kernel.org>; Mon, 27 Apr 2009 15:58:56 -0700
Received: from rv-out-0506.google.com (rvbk40.prod.google.com [10.140.87.40])
	by spaceape23.eur.corp.google.com with ESMTP id n3RMwrTE008777
	for <fio@vger.kernel.org>; Mon, 27 Apr 2009 15:58:54 -0700
Received: by rv-out-0506.google.com with SMTP id k40so123793rvb.3
        for <fio@vger.kernel.org>; Mon, 27 Apr 2009 15:58:53 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 27 Apr 2009 15:58:52 -0700
Message-ID: <66dfd3fe0904271558s6b8c3faamdc6ebb7f8fb95054@mail.gmail.com>
Subject: Populating the io_u before the I/O
From: Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
I was seeing some performance drop during the read verification phase
of a test, and from the code in io_u.c in get_io_u function, we
prepare/populate the buffer in the io_u structure based on the verify
patterns/options.
This makes sense when we are doing writes, but I dont understand why
we do this for the read phase when this data is going to be
overwritten anyways(and in case of truncated reads, we do modify the
buf_len).
So based on that I changed the code to populate the buffer(io_u->buf)
only if its a write with verify enabled.
This works for my tests, but I do not know if there was a reason why
this was populated for reads as well to begin with.
My change:

 diff -up io_u.c.orig io_u.c
--- io_u.c.orig 2009-04-27 15:42:11.213724000 -0700
+++ io_u.c      2009-04-27 15:51:34.881647000 -0700
@@ -838,7 +838,7 @@ struct io_u *get_io_u(struct thread_data

                f->last_pos = io_u->offset + io_u->buflen;

-               if (td->o.verify != VERIFY_NONE)
+               if (td->o.verify != VERIFY_NONE && io_u->ddir == DDIR_WRITE)
                        populate_verify_io_u(td, io_u);
                else if (td->o.refill_buffers && io_u->ddir == DDIR_WRITE)
                        io_u_fill_buffer(td, io_u, io_u->xfer_buflen);

thanks
-radha
