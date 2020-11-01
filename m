Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgKAIvc (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 1 Nov 2020 03:51:32 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16307C0617A6
        for <fio@vger.kernel.org>; Sun,  1 Nov 2020 01:51:32 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id k10so9683193wrw.13
        for <fio@vger.kernel.org>; Sun, 01 Nov 2020 01:51:31 -0700 (PDT)
MIME-Version: 1.0
References: <b1be007c-9ef8-69b8-67b9-cbe69f1f08e9@criteo.com>
In-Reply-To: <b1be007c-9ef8-69b8-67b9-cbe69f1f08e9@criteo.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 1 Nov 2020 08:51:04 +0000
Message-ID: <CALjAwxgG68G2Xhtcf24ycmUf4B6nOD0x-2di++TC4OkP9j8UOg@mail.gmail.com>
Subject: Re: Question around the time precision
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: Erwan Velu <e.velu@criteo.com>
Cc: fio <fio@vger.kernel.org>

On Tue, 27 Oct 2020 at 06:56, Erwan Velu <e.velu@criteo.com> wrote:
>
> Hello list,
>
> I found pretty handy being able to simulate and control the cpu activity
> by using the cpuio engine.
>
> The actual code is doing a simple nop loop for the expected duration.
>
>
> I'm thinking about adding other loops like having sse or avx loops to
> stress the CPU differently.
>
> I was wondering how accurate must be the loop. Is there any particular
> expectation or constrains to know ?

From looking at
https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-cpuload
it seems the load can only be specified in an integer percentage.
Looking at https://github.com/axboe/fio/blob/7eff05d723d1330a5407b2bdd9145f1bfb6dd0e1/time.c#L29
(which is used to do the waiting) it looks like it is only accurate to
microseconds. It seems like
https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-cpuchunks
is the period and that period is divided into sleeping without using
CPU and the rest of the time busy looping. By default it's 50000 usec
so if people aren't changing that it would suggest you can't have a
single loop of your burn take longer than 500 usec...

Maybe if a single loop of your burn has some minimum time greater than
a microsecond (I don't think it makes sense to set cpuchunks to less
than 100) you can check the values in the engine at init time and spit
out a warning/error?

-- 
Sitsofe | http://sucs.org/~sits/

