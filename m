Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f46.google.com ([209.85.222.46]:45675 "EHLO
        mail-ua1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728176AbeJRCaO (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 17 Oct 2018 22:30:14 -0400
Received: by mail-ua1-f46.google.com with SMTP id c10so5150502uao.12
        for <fio@vger.kernel.org>; Wed, 17 Oct 2018 11:33:17 -0700 (PDT)
MIME-Version: 1.0
References: <319f5589.a4d1.1668201794f.Coremail.feng_changyu@126.com>
In-Reply-To: <319f5589.a4d1.1668201794f.Coremail.feng_changyu@126.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 17 Oct 2018 19:32:51 +0100
Message-ID: <CALjAwxiqYiErO0uh9E4oL8ub_jMQ2MDPgNiCon51s_yaWVrcUA@mail.gmail.com>
Subject: Re: Cannot verify dedupe data, is it a bug?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: feng_changyu@126.com
Cc: fio <fio@vger.kernel.org>

On Wed, 17 Oct 2018 at 13:31, Changyu <feng_changyu@126.com> wrote:
>
> Hi,
>
> I set "dedupe_percentage " to let FIO generate some duplicated data.  I also want read these data back and verify it.
> But, there is no duplicated data after setting "verify" parameter.
>
> checking the source code, I found that  function do_io  in file backend.c fill the buffer twice. the source code is as below.
>
> do_io()
> {
>     io_u = get_io_u(td);
>     .....
>     if (io_u->ddir == DDIR_WRITE && td->flags & TD_F_DO_VERIFY)
>         populate_verify_io_u(td, io_u);
> }
>
> In function get_io_u, the buffer is filled with data as the "dedupe_percentage " specified.
> In function populate_verify_io_u, the buffer is refilled with random data. So, there would be no duplicated data.
>
> Is this a bug?

If it's not (and I'd say it is) then the current behaviour needs to it
needs to print a "conflicting options" error rather than silently not
doing what was asked. Someone else has reported something similar over
on https://github.com/axboe/fio/issues/449 ...

-- 
Sitsofe | http://sucs.org/~sits/

