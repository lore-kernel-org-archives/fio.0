Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f52.google.com ([209.85.221.52]:45961 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgA3HeC (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 30 Jan 2020 02:34:02 -0500
Received: by mail-wr1-f52.google.com with SMTP id a6so2677002wrx.12
        for <fio@vger.kernel.org>; Wed, 29 Jan 2020 23:34:01 -0800 (PST)
MIME-Version: 1.0
References: <CAL-AFxyeQ_mnGmy_458jm=CXVdXYd9Gdz77UDbAxDknR7Lv0Ow@mail.gmail.com>
 <CALjAwxhq=+WkUjkwFNkcPoREDfvdGs4JZy7Lcn=B09+AbTy26Q@mail.gmail.com> <CAL-AFxzbJow_drH44doM-u8xJM=gz71W77PAqVr8PKDCJL4dYg@mail.gmail.com>
In-Reply-To: <CAL-AFxzbJow_drH44doM-u8xJM=gz71W77PAqVr8PKDCJL4dYg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 30 Jan 2020 07:33:33 +0000
Message-ID: <CALjAwxjzn8KR2H7dRz9w+EEnkaepdz1Zp4KU38ZWokXmHYh9-Q@mail.gmail.com>
Subject: Re: Strange benchmark results of SSD - any ideas
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Louwrentius <louwrentius@gmail.com>
Cc: fio <fio@vger.kernel.org>

On Wed, 29 Jan 2020 at 23:14, Louwrentius <louwrentius@gmail.com> wrote:
>
> Thanks a lot for your reply. I have not erased or trimmed the drives.
> I actually wanted to see how the SSDs would behave under worst
> possible circumstances.
> But maybe this causes me comparing apples to oranges.

To do this fairly, you really would have to the same preconditioning
from an "empty" device on all of them before starting your benchmark.
See the links in the previous email for more on that.

> So the explanation for the golden gate bridge pattern could be an
> interaction between the benchmark and the garbage collection kicking
> in.
> Maybe if I do erase the drive properly, mark all blocks as empty, the
> pattern should be gone and look more like the intel?

That's the hope. If it is garbage collection related, starting with
all the blocks erased will hopefully make it take much longer before
garbage collection has to kick in. It could be some SSDs had more
empty cells than others or were better at garbage collecting or had
been written with a data pattern in the past more amenable to the
workload you're doing now etc.

-- 
Sitsofe | http://sucs.org/~sits/

