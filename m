Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f50.google.com ([209.85.128.50]:36947 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFHOVu (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 8 Jun 2019 10:21:50 -0400
Received: by mail-wm1-f50.google.com with SMTP id 22so4387442wmg.2
        for <fio@vger.kernel.org>; Sat, 08 Jun 2019 07:21:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAJzzwJziVYzTV4wjmA6CzGO-NcmXxMFvzYr3-b9juHmY2R-oMw@mail.gmail.com>
 <CALjAwxi+PQBmYk=j8ErW5wAPVY0oTuxGeUvsDxSLZnb+vn5YDg@mail.gmail.com> <CAJzzwJwXiyrQPnZL1KywOZC_vWVDWM9aOrpzi==k6QJfMr_-OA@mail.gmail.com>
In-Reply-To: <CAJzzwJwXiyrQPnZL1KywOZC_vWVDWM9aOrpzi==k6QJfMr_-OA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 8 Jun 2019 15:21:21 +0100
Message-ID: <CALjAwxj6pgv=8uShOdaPuGLKLFA4gf3MtZWmJrY2DHba0Y1n4g@mail.gmail.com>
Subject: Re: Round Robin IO
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kurt Dorsey <batlin@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

Let's keep the list CC'd - someone else may have the same question and
find this thread.

On Sat, 8 Jun 2019 at 14:51, Kurt Dorsey <batlin@gmail.com> wrote:
>
> Sitsofe,
> I need to do this single job,  Looking at the *roundrobin* option for
> --filename, random seems to generate a new offset for every file yet
> for sequential it only grabs a new offset after it cycles through all
> files.  Is there a way to add an option for it to act like random
> (grab new offset for every file?  Or if someone could point me at the
> place in the code I could create my own internal patch for this
> scenario?

I don't think the code currently supports this in a generative manner
as it would need to track the starting offset on a per file basis. I'd
start looking at get_io_u() inside io_u.c (i.e.
https://github.com/axboe/fio/blob/bc596cbcdbb58b81da53a29acf1370d8a7e94429/io_u.c#L1301
) for the place to modify. Also bear in mind that while fio already
knows how do gappy I/O via rw=write:<nr> (e.g. if my LBAs are 512
bytes big and I'm happy to write 4 of them in one go by using bs=2k
then leave a 2k gap I can usebs=2k rw=write:2k) if you want to use a
blocksize of a size smaller than a land you will likely need to write
more code to support that too.

Have you thought about faking up the sequence you want via replay
(https://fio.readthedocs.io/en/latest/fio_doc.html#i-o-replay or
https://fio.readthedocs.io/en/latest/fio_doc.html#trace-file-format-v2)?

-- 
Sitsofe | http://sucs.org/~sits/

