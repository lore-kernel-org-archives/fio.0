Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vs1-f50.google.com ([209.85.217.50]:45257 "EHLO
        mail-vs1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbeIQDbQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 16 Sep 2018 23:31:16 -0400
Received: by mail-vs1-f50.google.com with SMTP id x198-v6so2194910vsx.12
        for <fio@vger.kernel.org>; Sun, 16 Sep 2018 15:06:52 -0700 (PDT)
MIME-Version: 1.0
References: <20180910222404.GB3456@garbanzo.do-not-panic.com> <CALjAwxixx0ehz72hwNcUKBnEpUur55gJvmSTfMXUTDAmk_85CQ@mail.gmail.com>
In-Reply-To: <CALjAwxixx0ehz72hwNcUKBnEpUur55gJvmSTfMXUTDAmk_85CQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 16 Sep 2018 23:06:25 +0100
Message-ID: <CALjAwxixxVzzUEG56_erMPZ9PivnmKUjjpTXVWDH6AX_kJLzhQ@mail.gmail.com>
Subject: Re: graphing with fio - architectural docs - gfio Vs fiovisualizer
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: mcgrof@kernel.org
Cc: fio <fio@vger.kernel.org>, "Kudryavtsev, Andrey O" <andrey.o.kudryavtsev@intel.com>, Jan Blunck <jblunck@infradead.org>

On Tue, 11 Sep 2018 at 07:04, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> Hi,
>
> (Sorry for the brevity)
>
> On Mon, 10 Sep 2018 at 23:25, Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > The doc is up here:
> >
> > https://gitlab.com/mcgrof/graphing-with-fio
> >
> > Please give it some review and let me know your thoughts, rants,
> > disagreements.  Perhaps with time, after things are actually set up and
> > documented correctly, if folks consider it proper, I could massage it
> > and put the generic fio stuff into documentation for fio upstream.
>
> I think there's also https://github.com/earlephilhower/ezfio and also
> see fio2gnuplot within
> https://github.com/axboe/fio/tree/master/tools/plot . Also see
> https://github.com/axboe/fio/issues/495 for a "why not a shorter
> update interval" question.

> I was told the github fio issue #495 explains why
> there is a limit to the time interval (I guess ETA?)
> I do not know yet as github is being DoS'd...

"setting --status-interval to a value in the 10s of microseconds or
below will probably not work well because the constant output will
interfere with the run itself and there are better options for this in
"Log File Formats" section of the HOWTO/man page."

--
Sitsofe | http://sucs.org/~sits/

