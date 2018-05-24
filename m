Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:37945 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935346AbeEXDYD (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 23 May 2018 23:24:03 -0400
Received: by mail-ua0-f195.google.com with SMTP id y8-v6so130645ual.5
        for <fio@vger.kernel.org>; Wed, 23 May 2018 20:24:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAM0bxh9TvSAVWVjPnwa7Cb5Nwm_FUc9Gfr2qdVZ6sTuyNVyxww@mail.gmail.com>
References: <CAM0bxh9TvSAVWVjPnwa7Cb5Nwm_FUc9Gfr2qdVZ6sTuyNVyxww@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 24 May 2018 04:23:32 +0100
Message-ID: <CALjAwxhrfk5d25oArd0g0FpyBD=68CmgKnWYcM-gGftuEK+eJA@mail.gmail.com>
Subject: Re: Porting fio to RTEMS
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Udit agarwal <dev.madaari@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi there Udit!

(resending this reply to the list)

On 23 May 2018 at 16:34, Udit agarwal <dev.madaari@gmail.com> wrote:
> Hi community,
> I am a Google SoC participant working on RTEMS. One of my project goal
> is to import a multi functional IO benchmark to RTEMS and fio is
> definitely my first choice. RTEMS has structure pretty much like
> FreeBSD,  so porting won't be very difficult. This mail is just
> intended to give a small introduction of my goal, and to provide a
> context for my future queries.
> I have started working towards this, and would love to see an official
> release of FIO for RTEMS too.
> Thanks!

Sounds like it should be fun! In general fio should be portable to an
operating system that has the following nature:

o Has GCC or a compiler that understands GCC's dialect of C (e.g. clang)
o Can present various "posixy" style interfaces
o Has *nix userland utilities available in the build environment. For
example, the Makefile only works with GNUmake.

Fio really needs some form of POSIX threads (aka
pthreads) because it is heavily
dependent on them. I'd argue the Windows port is the one to a system
that contains the least POSIX within it and thus fio has to supply
various platform specific
shims to workaround this but even there a POSIX style threading
library is utilised outside the windowsaio I/O
engine. Further, the build happens using *nix utilities (but a *nix
environment is not required at runtime).

As another reference, I did an fio port to MINIX over on
https://github.com/sitsofe/fio/tree/minix . What made things trickier
there (at least at the time of writing) was the issue that MINIX lacks
kernel threads and thus does not ship a pthread library by default.
Fortunately MINIX has a port of GNU Pth which
provides co-operative threading (and it can also present a pthread
interface) so I was able to use that. My MINIX fio port isn't
perfect and has a few ugly workarounds but it was surprisingly
functional.

Anyway good luck and let us know how you get on!

-- 
Sitsofe | http://sucs.org/~sits/
