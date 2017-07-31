Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:37065 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750920AbdGaGLC (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jul 2017 02:11:02 -0400
Received: by mail-ua0-f180.google.com with SMTP id f9so186786764uaf.4
        for <fio@vger.kernel.org>; Sun, 30 Jul 2017 23:11:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56BA67C0.1030603@gmail.com>
References: <56BA67C0.1030603@gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 31 Jul 2017 07:10:31 +0100
Message-ID: <CALjAwxhNLWRJq_A8nD0=VCo0r-FBywB4XTrC-PBakuunCUOkHA@mail.gmail.com>
Subject: Re: missing waitpid() and server functionality at Windows
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?Q?Michal_=C5=A0mucr?= <msmucr@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Bruce Cran <bruce@cran.org.uk>

I've only just noticed this slipped by without reply - sorry this took so l=
ong!

On 9 February 2016 at 22:27, Michal =C5=A0mucr <msmucr@gmail.com> wrote:
>
> previously I've used fio mainly at Linux and OS X, so I didn't have any
> issues with fio in server mode. Now I'm trying to simulate workload to
> shared storage for Windows clients and this functionality with remote
> control of fio instances running at Windows machines will be very handy.
> Unfortunately it isn't possible to use it that way, because of missing
> waitpid() syscall implementation and forking in MinGw builds for Windows.
>
> I've stumbled upon at some messages posted 2y ago, where Bruce explained =
it.
> http://www.spinics.net/lists/fio/msg02565.html
>
> I don't know, if I got it correctly, but can be a build with Cygwin
> toolchain possible workaround for this issue?
> I've tried to compile current fio with Cygwin (so no MinGw toolchain) and
> compiler variables override, but failed badly.. It doesn't even pass thro=
ugh
> crc/test.c with lot of messed definitions. Is it currently possible to bu=
ild
> with it or MinGW is currently only way for Windows compilation of fio?

Even at the time of writing fio does not build in a "full" Cygwin
environment. It actually tries to be a native Windows program (hence
MinGW) so it can access native Windows calls (rather than Cygwin ones)
and not carry the Cygwin portability library. I suppose someone could
undertake such a port but it would be nicer if server mode could be
made to work with threads (but that's also new work someone would have
to perform).

--=20
Sitsofe | http://sucs.org/~sits/
