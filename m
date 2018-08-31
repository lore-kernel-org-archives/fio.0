Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:33481 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727239AbeHaKUh (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 Aug 2018 06:20:37 -0400
Received: by mail-vk0-f44.google.com with SMTP id w187-v6so5118404vkw.0
        for <fio@vger.kernel.org>; Thu, 30 Aug 2018 23:14:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAPSTwmT79gq_WY89XpQ-VPNYi27sSDokZFxBmOrUhLCGRzCXww@mail.gmail.com>
 <CALjAwxi8xoYS9wuzE3sZCfpR2i2HqcORyY+=_fVwo4HvvtkG3g@mail.gmail.com> <CAPSTwmSOeiK1zWnz_6o8BfbnnDn9VOvqy7ddXRH1WcdLV6w+Tw@mail.gmail.com>
In-Reply-To: <CAPSTwmSOeiK1zWnz_6o8BfbnnDn9VOvqy7ddXRH1WcdLV6w+Tw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 31 Aug 2018 07:14:19 +0100
Message-ID: <CALjAwxgZybB9J0Zt9HXDLmc+Wb6cNUYAw_84nJB7Bj4_oSNmOg@mail.gmail.com>
Subject: Re: FIO Question with random I/O
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gnana Sekhar <kgsgnana2020@gmail.com>
Cc: fio <fio@vger.kernel.org>

On Wed, 15 Aug 2018 at 18:05, Gnana Sekhar <kgsgnana2020@gmail.com> wrote:
>
> Thanks for the detailed explanation Sitsofe.
>
> So if I have --percentage_random flag, fio doesn't fill 5% of the
> drive or may exit without filling 5% of the drive?

At least 5% of the size you specified won't be touched but because the
distribution of regions used is no longer uniform you could end up
with it being more than 5%.

> If so is there a way to fill 5% partly sequential and partially
> random. I mean, in the same job to have combination of both sequential
> and random writes

Not within the same job. If you wanted to do this you would split it
into two jobs and have one job work on a region sequentially and the
other job work on a region randomly. It's possible to tether jobs
together using flow
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-flow
) but it will complicate things a bit.

> Sorry for side track, one another question, is there a way you know to
> exit fio completely
> There are some instances where drive dropped off from the system due
> to timeout but fio process still exists.
> With the parameters I shared in the thread before, fio seems to be
> running. Tried with --exitall_on_error and --continue_on_error flags

I know what you're talking about but no, there's very little fio can
do. On Linux SCSI error handling should kick in when an I/O takes too
long and eventually force the I/O to fail. However, if you're
suppressing that by quietly holding the I/O forever (people using
multipath are known to configure their systems in this fashion)
userspace will never be told the I/O finished in any way and the knock
on of this is that fio will fail to exit forever. See
https://github.com/axboe/fio/issues/550#issuecomment-370127049 for a
similar case with multipath . Additionally if you're trying to fake
infinite I/O suspends the commands mentioned in
https://www.spinics.net/lists/fio/msg05213.html can be useful.

--
Sitsofe | http://sucs.org/~sits/

