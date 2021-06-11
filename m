Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f43.google.com ([209.85.221.43]:41840 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbhFKRtG (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 11 Jun 2021 13:49:06 -0400
Received: by mail-wr1-f43.google.com with SMTP id o3so6912461wri.8
        for <fio@vger.kernel.org>; Fri, 11 Jun 2021 10:46:52 -0700 (PDT)
MIME-Version: 1.0
References: <26482be0-75b2-ab35-e217-94cbc39a0171@gmail.com>
In-Reply-To: <26482be0-75b2-ab35-e217-94cbc39a0171@gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 11 Jun 2021 18:45:26 +0100
Message-ID: <CALjAwxgqqoSbm7pxrrc0BeFg8R-01fTfEmowfPhVkunar8G45A@mail.gmail.com>
Subject: Re: Can we build fio statically with both libaio and posixaio?
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: Professor Pro <annivation@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On Wed, 26 May 2021 at 21:38, Professor Pro <annivation@gmail.com> wrote:
>
> I'm missing reason why fio can not be built statically with both libaio
> and posixaio
>
> Here is simplest way to reproduce on clear linux using docker ubuntu image:
>
> echo '
> url=https://brick.kernel.dk/snaps/fio-3.26.tar.gz
> libaio=https://pagure.io/libaio/archive/libaio-0.3.112/libaio-libaio-0.3.112.tar.gz
> apt-get update
> apt-get install libc6-dev build-essential autoconf autoconf make wget -y -q
> work=/build/fio-src

<snip>

> # build libaio
> cd lib*
> make prefix=/usr/local install
> cd ../fio*
>
> # build fio
> ./configure --prefix=/usr/local --build-static | tee configure.log
> make -j && make install && echo "SUCCESS. $(fio --version) engines:" &&
> fio --enghelp | tail -n +2 | sort
> cat configure.log | grep "AIO"

<snip>

> Linux AIO support             yes
> Linux AIO support rw flags    yes
> POSIX AIO support             no
> POSIX AIO support needs -lrt  no
> POSIX AIO fsync               no
> Solaris AIO support           no
>
>
> According to man [https://man7.org/linux/man-pages/man7/aio.7.html]
> posix aio was introduced in glibc 2.1.
> Another words, libc6-dev 2.31 is preinstalled but posixaio is not
> available for static build?
>
> Can we build fio statically with both libaio and posixaio?

Probably not both without a large amount of effort.

Whether you can build fio statically with Linux AIO depends entirely on whether
you have a static (.a) version of of libaio library in your library search
path. Since you're building libaio by hand it's up to you to check the
paths/fiddle with environment variables... FWIW I thought Debian-like distros
like Ubuntu actually shipped a static libaio in libaio-dev (e.g.
https://packages.ubuntu.com/focal/amd64/libaio-dev/filelist ) so I'm unsure why
you need to build your own...

For the POSIX AIO failure you would have to look through config.log. My guess
is that when you use posixaio on Linux it also needs libpthread to be available
and perhaps this is something that doesn't take place when doing a static build
(i.e. try adding -lpthread after -lrt in the fio configure script). Note that
the posixaio I/O engine on Linux is somewhat slow and won't achieve high
concurrency when multiple I/Os are targeting the same file descriptor.

--
Sitsofe

