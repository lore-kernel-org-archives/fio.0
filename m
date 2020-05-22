Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730114AbgEVQEa (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 22 May 2020 12:04:30 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E46C061A0E
        for <fio@vger.kernel.org>; Fri, 22 May 2020 09:04:29 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x14so5298472wrp.2
        for <fio@vger.kernel.org>; Fri, 22 May 2020 09:04:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAF6DVKOmDjTecr4ebiHZWD_5=-8kb4nwHC40tzq71ufFgiWJLg@mail.gmail.com>
 <CALjAwxjN02WtDu5xSV-AAD_9v-VDUwGEXYbVKy_jU5ObwbmQLg@mail.gmail.com>
 <CAF6DVKMMkjrZrEKr4yb6P+MrETKNh9-QHA=MA7sP-=tKPOOMyw@mail.gmail.com>
 <CAF6DVKPmyhrSJr4hFrBmYHrNTuETQm2b+2JAhUza7su_R7buwQ@mail.gmail.com> <CAF6DVKPM3ZTZoWumbEgy3A2wi9kHo3kbC7TGYa2i=EY-HkcLig@mail.gmail.com>
In-Reply-To: <CAF6DVKPM3ZTZoWumbEgy3A2wi9kHo3kbC7TGYa2i=EY-HkcLig@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 22 May 2020 17:04:02 +0100
Message-ID: <CALjAwxj6P2-ByczmZ4McgTyYEtQX9+VdVqWCMdAevyGP3VxSeg@mail.gmail.com>
Subject: Re: fio reporting high value of read iops at iodepth 1
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Debraj Manna <subharaj.manna@gmail.com>
Cc: fio <fio@vger.kernel.org>

On Fri, 22 May 2020 at 10:01, Debraj Manna <subharaj.manna@gmail.com> wrote:
>
> Few queries for my understanding
>
> 1. Is there a way to bypass the disk/buffer cache while doing a fio
> test? I know about direct=1 but that does not always bypass a cache.

Generally whether it will or won't is down to what you're doing I/O
against and how you're doing it. If you're doing it to a block device
of a real device then direct=1 usually won't touch the buffer cache.
If you're doing it to a file in a filesystem you're at the whim of the
filesystem (some do, some don't , some do unless you're using certain
options, some do so long as you get all the rules right but if you
don't then they quietly just use the buffer cache etc). I do notice
you're only doing reads and after laying out a file fio tries its best
to drop the cache for that file -
https://github.com/axboe/fio/blob/f09a7773f5821d5b89428419dcef1987ced39b67/filesetup.c#L509
. On reflection, this should mean you're unlikely to be hitting the
kernel cache (maybe check how many I/Os the kernel sent to disk versus
those that fio was asked to do).

>  2. "Maybe do I/O on a much larger file to see if the variation
> between runs goes down" - Will the file size be in some ratio of my
> system configuration?. For example if I am having a RAM of 32 GB then
> should I use a file of size of 64 GB or there are some other
> recommended best practices?

This advice is to reduce the effectiveness of caching (if caching
really is taking place it might not be - see above). If most of your
I/O isn't going to cache then most of your I/O will reflect non-cache
speeds even if you are asking for buffered I/O. Doing too little I/O
is prone to be disturbed by other things that may be happening on the
system so I'd expect longer results to be more reliable.

-- 
Sitsofe | http://sucs.org/~sits/

