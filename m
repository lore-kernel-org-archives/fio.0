Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:43606 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbdJEGJt (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 5 Oct 2017 02:09:49 -0400
Received: by mail-vk0-f51.google.com with SMTP id h4so7541348vkg.0
        for <fio@vger.kernel.org>; Wed, 04 Oct 2017 23:09:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGEeD9ajaBeqZvXnP+wn3Cc48sL+O_jF1p6RavLQzFn0vX8SvA@mail.gmail.com>
References: <CAGEeD9YPvDhbt7KFvLOJ6W99UM_Jck6PFF6HV2h=B5u2gChggg@mail.gmail.com>
 <CAGEeD9ajaBeqZvXnP+wn3Cc48sL+O_jF1p6RavLQzFn0vX8SvA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 5 Oct 2017 07:09:18 +0100
Message-ID: <CALjAwxjhk84FSx0K2FbgUJLL2sJMSDksxbJQg5OvbSeHZVcO=A@mail.gmail.com>
Subject: Re: Some questions
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?B?0J3QuNC60LjRgtCwINCT0L7RgNCx0YPQvdC+0LI=?= <tshiva@promobit.ru>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 4 October 2017 at 07:58, =D0=9D=D0=B8=D0=BA=D0=B8=D1=82=D0=B0 =D0=93=D0=
=BE=D1=80=D0=B1=D1=83=D0=BD=D0=BE=D0=B2 <tshiva@promobit.ru> wrote:
> I write my ioengine and have some questions about how work fio.
>
> 1. What to do if function "getevents" transmitted pointer (const
> struct timespec *t) which indicated garbage?
> I want to paused my ioengine on some msec(sec,nsec) when ioengine
> wants get answer about recording of write. I don't understand how can
> get time for waiting if time pointer indicated garbage. Why does he
> pass the pointer to the garbage?

You need to check if it is not null before you use it. Off the top of
my head I think this is the only place I've seen it being used
https://github.com/axboe/fio/blob/fio-3.1/engines/libaio.c#L145 and
it's only usuable in certain conditions. If you chase your way up the
code to https://github.com/axboe/fio/blob/fio-3.1/io_u.c#L2001 you can
see you only get a non-NULL timespec when you don't require a minimum
number of events before returning (i.e. the case where you're using
the libaio ioengine with userspace_reap=3D1 - see
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-userspace-re=
ap
). If you need to just wait for an amount of time you can grab/check
time with fio_gettime/mtime_since_now as in
https://github.com/axboe/fio/blob/fio-3.1/engines/libaio.c#L284 .

> 2. What is the call queue function of ioengine? Can you write minimal
> viable call chain? (init->open->queue->commit->getevents->cleanup)

It's going to depend. The comments in the skeleton ioengine
(https://github.com/axboe/fio/blob/fio-3.1/engines/skeleton_external.c
actually state which callbacks must be present (e.g. commit is
optional because your ioengine might be synchrnous). Even open/close
may not be required if the ioengine is somehow synthetic or
connectionless. There are also additional optional callbacks that can
be added that are not mentioned in the skeleton ioengine...

Your suggested chain looks OK if all those are callbacks are defined
but you may find queue is called multiple times successively (since it
seems your theoretical ioengine is async), getevents may be called
multiple times etc.

> 3. Are the function of ioengine can be called in several threads
> without indicated numjobs?

Each numjob gets its own ioengine - you don't know if a job is going
to be run as a process or a thread. If your ioengine is using
something that's not thread safe then your ioengine is responsible for
serializing access to it...

> 4. Why in null-ioengine when iodepth=3D1 we indicate this flag:
> "td->io_ops->flags |=3D FIO_SYNCIO;" (sorry for my english)

(I think this setting is informal enough you don't need to worry too
much about your English so long as people know what you mean :-) That
ioengine "wants" to behave like a synchronous ioengine when the depth
is 1 and like an asynchronous ioengine when the depth is greater than
1. I'm guessing wildly but perhaps being an asynchronous ioengine
induces a bit of extra overhead? If you're writing a "throw everything
away" ioengine that is going as fast as possible for benchmarking the
other parts of fio itself, every little counts...

--=20
Sitsofe | http://sucs.org/~sits/
