Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f41.google.com ([209.85.128.41]:55460 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfL2VJx (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 29 Dec 2019 16:09:53 -0500
Received: by mail-wm1-f41.google.com with SMTP id q9so11008550wmj.5
        for <fio@vger.kernel.org>; Sun, 29 Dec 2019 13:09:52 -0800 (PST)
MIME-Version: 1.0
References: <871rssdb1x.fsf@replix.io>
In-Reply-To: <871rssdb1x.fsf@replix.io>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 29 Dec 2019 21:09:25 +0000
Message-ID: <CALjAwxi0qQT3K=g+m8PUPur3CAj845yE2y96gPQan28eg_A95w@mail.gmail.com>
Subject: Re: Multiple jobs and fill_device
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Oleg Sivokon <oleg.sivokon@replix.io>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On Wed, 25 Dec 2019 at 09:12, Oleg Sivokon <oleg.sivokon@replix.io> wrote:
>
> Hello list,
>
> I'm wondering how the configuration below is interpreted:
>
>     [global]
>     ioengine=libaio
>     direct=1
>     loops=1
>     numjobs=8
>
>     [write-prep]
>     rw=write
>     filename=/dev/sdb
>     iodepth=16
>     bs=16k
>     fill_device=1
>     stonewall=1
>
> Will every one of the 8 jobs try to fill the device completely or will

Yes the device will be filled but not due to fill_device=1.
Confusingly fill_device is actually meant for when you are creating
files on filesystems where you want the file to use up all the
remaining space
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-fill-device
says this a different way). A file representing a device will already
have a fixed size that can't be grown by just writing to it (OK
there's thin provisioning but even there the "device" has a fixed size
ahead of time). When a file already has a size that is what is used
when "size" is not set (see
https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-size
).

> they split the task of filling the device between themselves, where each
> will do only 1/8 of filling the device?  My reading of documentation

No they will all overwrite/overlap the same areas.

> seems to suggest the device will be filled 8 times, with jobs, possibly,
> stepping on each other's toes (i.e. contesting the same block), but I'm
> not sure.

Your reading is correct - they will step on each others toes. If you
want to somehow avoid this you'll have to look into offset_increment
(https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-offset-increment
) and size (https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-size
).

NB: stonewall=1 likely won't do anything in this case because no job
definition is "after" another when using numjobs within the same job.

-- 
Sitsofe | http://sucs.org/~sits/

