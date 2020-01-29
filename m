Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f42.google.com ([209.85.128.42]:38054 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbgA2XEz (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 29 Jan 2020 18:04:55 -0500
Received: by mail-wm1-f42.google.com with SMTP id a9so1903378wmj.3
        for <fio@vger.kernel.org>; Wed, 29 Jan 2020 15:04:54 -0800 (PST)
MIME-Version: 1.0
References: <CAL-AFxyeQ_mnGmy_458jm=CXVdXYd9Gdz77UDbAxDknR7Lv0Ow@mail.gmail.com>
In-Reply-To: <CAL-AFxyeQ_mnGmy_458jm=CXVdXYd9Gdz77UDbAxDknR7Lv0Ow@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 29 Jan 2020 23:04:27 +0000
Message-ID: <CALjAwxhq=+WkUjkwFNkcPoREDfvdGs4JZy7Lcn=B09+AbTy26Q@mail.gmail.com>
Subject: Re: Strange benchmark results of SSD - any ideas
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Louwrentius <louwrentius@gmail.com>
Cc: fio <fio@vger.kernel.org>

On Wed, 29 Jan 2020 at 22:44, Louwrentius <louwrentius@gmail.com> wrote:
>
> Hello,
>
> I've done some benchmarks with FIO of entire SSD devices. So the FIO
> benchmark stops when the whole device has been read/written. I've
> logged latency and iops for the entire run.
>
> Those logs are then translated to graphs. The Intel SSD shows the kind
> of graph I would expect. The Samsung and Kingston SSDs show 'strange'
> results.
>
> I've written a brief blog article about this which includes links to
> the raw data and the images.
> https://louwrentius.com/difference-of-behavior-in-sata-solid-state-drives.html
>
> Does anybody have an idea what could be going on? Why do we see these
> 'golden gate bridge' patterns? Maybe I did something wrong?

Your job seems to be doing small (4K) randrw  norandommap... Isn't
this the sort of effect seen when garbage collection
(http://codecapsule.com/2014/02/12/coding-for-ssds-part-3-pages-blocks-and-the-flash-translation-layer/
) kicks in? Have you been doing a secure erase (or not quite so good
due to unpredictability but still better than nothing - a trim) before
starting your benchmarking?

See https://www.snia.org/sites/default/education/tutorials/2011/fall/SolidState/EstherSpanjer_The_Why_How_SSD_Performance_Benchmarking.pdf
for an overview and
https://www.snia.org/tech_activities/standards/curr_standards/pts for
a list of specs talking about the lengths that can be done to try and
make comparisons fair...

--
Sitsofe | http://sucs.org/~sits/

