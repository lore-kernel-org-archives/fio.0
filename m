Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbhBON1f (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 15 Feb 2021 08:27:35 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5EAC061756
        for <fio@vger.kernel.org>; Mon, 15 Feb 2021 05:26:53 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id a16so5457716ilq.5
        for <fio@vger.kernel.org>; Mon, 15 Feb 2021 05:26:53 -0800 (PST)
MIME-Version: 1.0
References: <CAA4OwwVJuUWCkA_ZRJC+izsqx-4Mv2BG+vvR=JCv2A7kOr343Q@mail.gmail.com>
 <CALjAwxg-NDqixYgxEPVDFf8_CTWpO5UEQhM9byPZwicazGoAzw@mail.gmail.com>
In-Reply-To: <CALjAwxg-NDqixYgxEPVDFf8_CTWpO5UEQhM9byPZwicazGoAzw@mail.gmail.com>
From: Robert Balogh <ethrbh@gmail.com>
Date: Mon, 15 Feb 2021 14:26:42 +0100
Message-ID: <CAA4OwwWpmqdA7qzNqR0Us6mDucV0r62Abig4=bX9rpmfemnhyQ@mail.gmail.com>
Subject: Re: how to put FIO stat into file and check that periodically while
 FIO is running
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

hello Sitsofe,

Thanks, I'll check it out.

br,
/Robi

On Thu, Feb 11, 2021 at 10:52 PM Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> Hi,
>
> On Wed, 10 Feb 2021 at 13:26, Robert Balogh <ethrbh@gmail.com> wrote:
> >
> > What I would like to do is now, to start FIO, keep running it, and
> > "instruct/ask" FIO for putting the measurement statistic at every X
> > sec into the given stat file. Is it possible to do?
>
> The information in https://www.spinics.net/lists/fio/msg09025.html
> ("Re: Getting eta-status-line to the output file?") may be what you're
> looking for. If you are just after a specific stat the write_*_log
> options - https://fio.readthedocs.io/en/latest/fio_doc.html#measurements-and-reporting
> may be more useful to you.
>
> --
> Sitsofe

