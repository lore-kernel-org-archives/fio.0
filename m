Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io1-f45.google.com ([209.85.166.45]:32907 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgDFGpr (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 6 Apr 2020 02:45:47 -0400
Received: by mail-io1-f45.google.com with SMTP id o127so14591791iof.0
        for <fio@vger.kernel.org>; Sun, 05 Apr 2020 23:45:46 -0700 (PDT)
MIME-Version: 1.0
References: <CABdSUwQx5HmuVQGYsY6fc1TeOwE223i4NoMKMmWxgQTcZuPvTQ@mail.gmail.com>
In-Reply-To: <CABdSUwQx5HmuVQGYsY6fc1TeOwE223i4NoMKMmWxgQTcZuPvTQ@mail.gmail.com>
From: =?UTF-8?Q?Marcin_=C5=BBukowski?= <marcin.zukowski@gmail.com>
Date: Sun, 5 Apr 2020 23:45:19 -0700
Message-ID: <CABdSUwTrNUWorFL1-52qRO962qaad+Od+tQiUnYDqMd4cvg78g@mail.gmail.com>
Subject: Re: RFC: New GAS meta-engine and S3 engine
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi all,

I wonder - any feedback on this?

Coincidentally, there was a question about externalizing ioengines
(https://www.spinics.net/lists/fio/msg08373.html) - then e.g.
GAS-based S3 engine could be built as a separate package.



On Wed, Mar 11, 2020 at 6:56 AM Marcin =C5=BBukowski
<marcin.zukowski@gmail.com> wrote:
>
> Hi all,
>
> Sending this before I send a pull request, as I wanted to consult
> first if this is something that would be desirable.
>
> A long while ago (2017) I needed ability to test AWS S3 performance,
> including aspects like concurrent IOs, various IO sizes etc. So I
> decided my favorite "fio" is probably a good tool to use for it. Back
> then, S3 mode for http.c didn't exist yet, so I had to do something
> myself. I made it work back then, but I got busy and didn't merge it
> upstream (sorry!). Trying to fix it now.
>
> Instead of manually implementing S3 HTTP interface (like http.c did),
> I thought it would be desirable to use the official AWS SDK. However,
> it had some issues, like no built-in asynchronicity, being C++ and so
> on.
>
> I realized the process of making AWS interface provide what fio needs
> is super generic. So I decided to write a mini meta-engine I called
> GAS - Generic ASync. It provides fio-compatible  async-adding wrapper
> to any IO-like library. Then, adding a full-fledged fio engine is
> trivial, see example in gas-direct-io.c . Similarly S3 engine
> (read-only for now) is quite trivial. I had to split it into a C and
> C++ part, but the entire thing is still <200 LOC.
>
> I'm now thinking about adding similar engines for Azure and GCP object
> stores, hence I wonder if it would make sense to merge it upstream.
> One concern I have is making fio dependent on all these SDKs. Hence I
> thought this should only be optionally compiled-in.
>
> The repo is here, I recently refreshed it from upstream:
> https://github.com/MarcinZukowski/fio
>
> Thoughts? Comments? Should I just send a pull request? :)
>
> Thanks,
> Marcin

