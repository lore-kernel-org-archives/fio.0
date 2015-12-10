Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:34258 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbbLJG4A (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 Dec 2015 01:56:00 -0500
Received: by mail-ig0-f179.google.com with SMTP id g19so10224268igv.1
        for <fio@vger.kernel.org>; Wed, 09 Dec 2015 22:56:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20151209T033523-799@post.gmane.org>
References: <loom.20151209T033523-799@post.gmane.org>
Date: Thu, 10 Dec 2015 06:56:00 +0000
Message-ID: <CALjAwxgQwgrQbd9EeuRtqnmo5WrPoXk=HVuQ2nnuwgJ=9kDqOw@mail.gmail.com>
Subject: Re: io_size usage
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jun He <jhe@cs.wisc.edu>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Your job sets and io_size four times that of "size" of the disk that
you are using. This will force your I/O to wrap abound to the start of
the region (why not use loops?). Are you saying that you think the
sync job's iolog is wrong because it only says it performed one loop?

On 9 December 2015 at 02:50, Jun He <jhe@cs.wisc.edu> wrote:
> Hi all,
> I think there is a bug for io_size.
>
> For example, I want to write 16KB data to a file of size 8KB (so each block is
> written twice) and I have the following job file:
>
> [global]
> ioengine=sync
> rw=write
> bs=4kb
> size=8kb
> io_size=32kb
>
> [job1]
> write_iolog=iolog.1
>
>
> After running, iolog.1 will contain the following contents:
>
> fio version 2 iolog
> job1.0.0 add
> job1.0.0 open
> job1.0.0 write 0 4096
> job1.0.0 write 4096 4096
> job1.0.0 close
>
> This shows that each block has been only written once.
>
> If I change the ioengine to libaio, iolog.1 will contain:
>
> fio version 2 iolog
> job1.0.0 add
> job1.0.0 open
> job1.0.0 write 0 4096
> job1.0.0 write 4096 4096
> job1.0.0 close
> job1.0.0 open
> job1.0.0 write 0 4096
> job1.0.0 write 4096 4096
> job1.0.0 close
> job1.0.0 open
> job1.0.0 write 0 4096
> job1.0.0 write 4096 4096
> job1.0.0 close
> job1.0.0 open
> job1.0.0 write 0 4096
> job1.0.0 write 4096 4096
> job1.0.0 close
>
>
> Bug or wrong usage?
>
> Thanks,
> Jun
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Sitsofe | http://sucs.org/~sits/
