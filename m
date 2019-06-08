Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f42.google.com ([209.85.128.42]:53443 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFHEwN (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 8 Jun 2019 00:52:13 -0400
Received: by mail-wm1-f42.google.com with SMTP id x15so3844367wmj.3
        for <fio@vger.kernel.org>; Fri, 07 Jun 2019 21:52:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAJzzwJziVYzTV4wjmA6CzGO-NcmXxMFvzYr3-b9juHmY2R-oMw@mail.gmail.com>
In-Reply-To: <CAJzzwJziVYzTV4wjmA6CzGO-NcmXxMFvzYr3-b9juHmY2R-oMw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 8 Jun 2019 05:52:00 +0100
Message-ID: <CALjAwxi+PQBmYk=j8ErW5wAPVY0oTuxGeUvsDxSLZnb+vn5YDg@mail.gmail.com>
Subject: Re: Round Robin IO
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kurt Dorsey <batlin@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Fri, 7 Jun 2019 at 21:18, Kurt Dorsey <batlin@gmail.com> wrote:
>
> I am trying to do multi device round robin, I have been utilizing
> --filename=dev1:dev2 and it works great for Randoms but it doesn't
> work correctly for sequential (This is for multi path devices)
> Looking at the debug output and a blktrace for sequential it looks
> like it is sending the same offset to both devices
> Is there a way to issue Sequential IO where it increments the LBA for each IO?
> File1  LBA 0-4
> File2 LBA  4-8
> File1 LBA 8-12
> File2 LBA 12-16
> If this is not implemented would it be possible to implement this?

Are multiple jobs acceptable? If so you could get what you want by
given a job to each file where all jobs are using zonemode=strided
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-zonemode
 ) with additional parameters (i.e. zonerange, zoneskip, zonesize) to
maintain gaps and the second job uses offset
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-offset
) to control how the gaps and lands align compared to the first job.
If you ONLY have two jobs and must tie the progression of the jobs
together, you could then use flow
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-flow
)...

Just out of curiosity in your example are you sure you want the
overlap? For example, in File1 you are writing LBA 4 and in File 2 you
are also writing LBA 4...

-- 
Sitsofe | http://sucs.org/~sits/

