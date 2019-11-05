Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f51.google.com ([209.85.221.51]:35406 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKEFuR (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 5 Nov 2019 00:50:17 -0500
Received: by mail-wr1-f51.google.com with SMTP id l10so19811588wrb.2
        for <fio@vger.kernel.org>; Mon, 04 Nov 2019 21:50:16 -0800 (PST)
MIME-Version: 1.0
References: <CABO+gV_H3EcY70W+=Q_oZX+skVMQ_q+O1LqocC8kUhfdvoos3g@mail.gmail.com>
 <CALjAwxgSSdcH7MWCa89okeVNfsrzWiaT-xbqQHmQ_s1sRLtafQ@mail.gmail.com> <AT5PR8401MB1169209F101524F68537C7FBAB9E0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <AT5PR8401MB1169209F101524F68537C7FBAB9E0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 5 Nov 2019 05:49:49 +0000
Message-ID: <CALjAwxioZrH1g6xZTmWG7zxy+0GuRNp2_Bquav1Tv8+5QDm+tA@mail.gmail.com>
Subject: Re: IO Depth measurement
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc: Elliott Balsley <elliott@altsystems.com>, fio <fio@vger.kernel.org>

On Fri, 4 Oct 2019 at 14:38, Elliott, Robert (Servers) <elliott@hpe.com> wrote:
>
> > (see the sentence that begins Note in documentation for iodepth -
> > https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-
> > iodepth
> > ). In your output we can see you have "ioengine=psync" which is
> > synchronous. Getting ahead of ourselves note that very recent ZFS
>
> This question has come up before... maybe a warning message when
> iodepth is being ignored would help users?

I have a faint memory of wanting to do this some time ago but the
approach I was using was flawed -
https://github.com/axboe/fio/pull/347 ...

-- 
Sitsofe | http://sucs.org/~sits/

