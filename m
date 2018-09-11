Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f54.google.com ([209.85.222.54]:38782 "EHLO
        mail-ua1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbeIKLCw (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 Sep 2018 07:02:52 -0400
Received: by mail-ua1-f54.google.com with SMTP id o11-v6so19500921uak.5
        for <fio@vger.kernel.org>; Mon, 10 Sep 2018 23:05:12 -0700 (PDT)
MIME-Version: 1.0
References: <20180910222404.GB3456@garbanzo.do-not-panic.com>
In-Reply-To: <20180910222404.GB3456@garbanzo.do-not-panic.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 11 Sep 2018 07:04:45 +0100
Message-ID: <CALjAwxixx0ehz72hwNcUKBnEpUur55gJvmSTfMXUTDAmk_85CQ@mail.gmail.com>
Subject: Re: graphing with fio - architectural docs - gfio Vs fiovisualizer
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: mcgrof@kernel.org
Cc: fio <fio@vger.kernel.org>, "Kudryavtsev, Andrey O" <andrey.o.kudryavtsev@intel.com>, jblunck@infradead.org

Hi,

(Sorry for the brevity)

On Mon, 10 Sep 2018 at 23:25, Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> The doc is up here:
>
> https://gitlab.com/mcgrof/graphing-with-fio
>
> Please give it some review and let me know your thoughts, rants,
> disagreements.  Perhaps with time, after things are actually set up and
> documented correctly, if folks consider it proper, I could massage it
> and put the generic fio stuff into documentation for fio upstream.

I think there's also https://github.com/earlephilhower/ezfio and also
see fio2gnuplot within
https://github.com/axboe/fio/tree/master/tools/plot . Also see
https://github.com/axboe/fio/issues/495 for a "why not a shorter
update interval" question.

-- 
Sitsofe | http://sucs.org/~sits/

