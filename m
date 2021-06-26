Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhFZK3S (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 26 Jun 2021 06:29:18 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48BFC061574
        for <fio@vger.kernel.org>; Sat, 26 Jun 2021 03:26:36 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id k184so1976885ybf.12
        for <fio@vger.kernel.org>; Sat, 26 Jun 2021 03:26:36 -0700 (PDT)
MIME-Version: 1.0
References: <CANyP7Cj4hNtq5aeQ-h1L3ZtyBch0GDfab+4E2cChnKJTwjYsLg@mail.gmail.com>
 <CALjAwxgo0gYvmitK0GvLiYLQZvMAK2UeUJRAvWdVTrbmtioD0g@mail.gmail.com> <CAGfUJcHrQWM0viroU+bkKPCfBc7bAeRqajCgegzoEbNsSY8M=w@mail.gmail.com>
In-Reply-To: <CAGfUJcHrQWM0viroU+bkKPCfBc7bAeRqajCgegzoEbNsSY8M=w@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 26 Jun 2021 11:26:09 +0100
Message-ID: <CALjAwxizh-CjK_LaVt-27GCpSSX3aAwPpDm6y42v52bkhn0S=A@mail.gmail.com>
Subject: Re: What exactly is iodepth in fio?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
List-Id: fio@vger.kernel.org
To: Jared Walton <jawalking@gmail.com>
Cc: fio <fio@vger.kernel.org>

On Sat, 26 Jun 2021 at 05:32, Jared Walton <jawalking@gmail.com> wrote:
>
> Sorry if this is bringing up an old thread, but I've been googling and I =
can't find an answer so I thought I'd ask here.

Fair enough but please don't send fio mails to just me - send them to
the mailing list so:
- More people are given the chance to see and reply
- The threads get archived so they turn up in search results ;-)

Out of curiosity, what did you make of
https://serverfault.com/q/923487 ,
https://unix.stackexchange.com/q/459045 ?

Additionally because you didn't state a platform and a concrete job
file the answers below will have to be deliberately vague.

> when you say:
>>
>> io will not create parallel *fio jobs* just because of iodepth BUT using=
 parallel fio jobs is another way of increasing the amount of simultaneous =
I/O being submitted at any given time (by using different threads/processes=
) and using both on the same device will act in tandem (so if you have two =
fio jobs submitting asynchronous I/O at an iodepth of 16 each your OS could=
 be be actually receiving 32 I/Os at any given time). There can be reasons =
for combining the two (e.g. you have multiple devices and they are so fast =
that one CPU can't keep up even when submitting I/O asynchronously).
>
>
> What is the expected outcome when a single job has numjobs=3D2 and iodept=
h=3D16? Will this result in a total iodepth of 32? Or will fio use 2 thread=
s to maintain an iodepth of 16?

You are using iodepth in two different contexts:
1. fio's internal queue for a single job
2. The simultaneous I/O going to kernel from multiple threads/processes

Let's arbitrarily redefine thing:

1. iodepth - Maximum amount of simultaneous I/O *fio* will queue for a
*single job*
2. queue depth - amount of simultaneous I/O going to kernel from
multiple threads/processes

> What is the expected outcome when a single job has numjobs=3D2 and iodept=
h=3D16? Will this result in a total iodepth of 32?

Each job (more on that in a moment) queues *up to* 16 I/Os
simultaneously (iodepth) and the total amount of simultaneous I/O from
all jobs is *up to* 32 I/Os (queue depth). There may be reasons why a
depth of 32 isn't reached hence some of the careful wording (you can
check the depths that were actually reached by looking at fio's output
after the jobs have completed).

> Or will fio use 2 threads to maintain an iodepth of 16?

As stated in the fio documentation
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-thread
) by default a job is a *process* on non-Windows platforms/most
ioengines unless you use the thread option.

(Please try to avoid top-posting on this mailing list. Thanks!)


--
Sitsofe

