Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgKAI2o (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 1 Nov 2020 03:28:44 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA5AC0617A6
        for <fio@vger.kernel.org>; Sun,  1 Nov 2020 01:28:44 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id c16so6546596wmd.2
        for <fio@vger.kernel.org>; Sun, 01 Nov 2020 01:28:44 -0700 (PDT)
MIME-Version: 1.0
References: <CADcL3SAgfT0Cy4FAgj2YK2xH7Egogc5QKR_7Eg6b7OuuwVczTw@mail.gmail.com>
 <CADcL3SCAnDGP+3rPgL8ZT3UK6UGs-Ee-XGVXtG-G6XZMjSHkGQ@mail.gmail.com>
In-Reply-To: <CADcL3SCAnDGP+3rPgL8ZT3UK6UGs-Ee-XGVXtG-G6XZMjSHkGQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 1 Nov 2020 08:28:17 +0000
Message-ID: <CALjAwxhnWZBKdh0TydJBvKNcJE=ZqxQa6amt+earqUnpiWWQOg@mail.gmail.com>
Subject: Re: Getting eta-status-line to the output file?
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: Brian Wengel <m40636067@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Sat, 31 Oct 2020 at 17:23, Brian Wengel <m40636067@gmail.com> wrote:
>
> I would very much like to get the status-line I get from
> "--eta-newline=1s" written to the output file. Is that possible (or
> just something similar)?
>
> I'm interested in the sub-results of bandwidth and IOPS during the job.
> There might be an option for that but couldn't find it?

Usually people do this by grabbing stdio and setting the output-format
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-output-format
) to something like json (although be aware of
https://github.com/axboe/fio/issues/672 and
https://github.com/axboe/fio/issues/731 ) and also using
https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-status-interval
. I suppose if you still need to see stdio you could pipe to a tool
like tee(2) (https://man7.org/linux/man-pages/man1/tee.1.html )
first...

-- 
Sitsofe | http://sucs.org/~sits/

