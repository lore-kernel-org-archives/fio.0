Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:26974 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbZEUVvM (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 21 May 2009 17:51:12 -0400
Received: from zps36.corp.google.com (zps36.corp.google.com [172.25.146.36])
	by smtp-out.google.com with ESMTP id n4LLpDlw008163
	for <fio@vger.kernel.org>; Thu, 21 May 2009 14:51:13 -0700
Received: from qw-out-1920.google.com (qwc5.prod.google.com [10.241.193.133])
	by zps36.corp.google.com with ESMTP id n4LLpCic004689
	for <fio@vger.kernel.org>; Thu, 21 May 2009 14:51:12 -0700
Received: by qw-out-1920.google.com with SMTP id 5so863497qwc.48
        for <fio@vger.kernel.org>; Thu, 21 May 2009 14:51:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <66dfd3fe0905211440s2b95867ex12a741e7a391b2fb@mail.gmail.com>
References: <66dfd3fe0905211440s2b95867ex12a741e7a391b2fb@mail.gmail.com>
Date: Thu, 21 May 2009 14:51:12 -0700
Message-ID: <66dfd3fe0905211451x353c250bt326136f87be5d7f6@mail.gmail.com>
Subject: Re: Set io_u field(endpos) value during verify phase
From: Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Sorry for the confusion, Please disregard this fix.
Looks like I was looking at the older version of the fio code that had this bug.
The current version of fio does not work the same way, so will not see
this error.
-radha


On Thu, May 21, 2009 at 2:40 PM, Radha Ramachandran <radha@google.com> wrote:
> Hi,
> We ran into an issue where during the verify phase (sync engine),
> because the io_u->endpos field was not set, it was using a stale
> value.
> If the sync engine is used then for every read(during the verify
> phase) to avoid an extra seek, the code checks if we are already at
> the position we expect to be at and if so bypasses the seek.
> So in the case where the current file position field which is stale
> (From the previous i/o completion) matches  where the read needs to be
> done from, there will be no seek and the code lands up reading the
> wrong data and goes down the error path because the data does not
> match.
> This case is only seen during the verify phase where the code uses
> __get_io_u directly. In the regular read/write phase the code uses
> get_io_u and that function correctly sets the value of the endpos
> field.
>
> Hopefully, I explained the problem coherently
>
> Here is the fix:
>
> diff -up verify.c.old verify.c
> --- verify.c.old        2009-05-21 13:14:51.703698000 -0700
> +++ verify.c    2009-05-21 13:18:48.052540000 -0700
> @@ -711,6 +711,7 @@ int get_next_verify(struct thread_data *
>                io_u->ddir = DDIR_READ;
>                io_u->xfer_buf = io_u->buf;
>                io_u->xfer_buflen = io_u->buflen;
> +               io_u->endpos = io_u->offset + io_u->buflen;
>                free(ipo);
>                dprint(FD_VERIFY, "get_next_verify: ret io_u %p\n", io_u);
>                return 0;
>
>
> Thanks
> -radha
>
