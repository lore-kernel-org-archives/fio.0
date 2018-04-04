Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:38623 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbeDDUJn (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 4 Apr 2018 16:09:43 -0400
Received: by mail-ua0-f169.google.com with SMTP id q38so14047720uad.5
        for <fio@vger.kernel.org>; Wed, 04 Apr 2018 13:09:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKwzdDrVtNh+EHM4fwuKzxkyzUQLowYs454B7byXE2hi7dUCdw@mail.gmail.com>
References: <CAKwzdDrVtNh+EHM4fwuKzxkyzUQLowYs454B7byXE2hi7dUCdw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 4 Apr 2018 21:09:12 +0100
Message-ID: <CALjAwxgTqPA647r0M--56rn0r29sDLrdNotAhp3muTbirPe=Ew@mail.gmail.com>
Subject: Re: random mix workload with offset support
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: abhishek koundal <akoundal@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On 4 April 2018 at 19:02, abhishek koundal <akoundal@gmail.com> wrote:
> Hi,
> Looking some support if this is doable in fio
> I want to do random mix workload with specific % while writes going to
> certain offset span and reads going to different offset span.
>
> e.g.
>
> Rw=randrw
>
> Rndmixread=70 (70/30 mix)
>
> Offset=,70%,  (reads full span, writes to last 30% of LBA span?)

I'd say either use two separate jobs tied together with flow
(http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-flow )
or look at carefully setting random_distribution with zone/zoned
(http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-random-distribution
)...

-- 
Sitsofe | http://sucs.org/~sits/
