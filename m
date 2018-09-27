Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vs1-f44.google.com ([209.85.217.44]:43337 "EHLO
        mail-vs1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbeI0ThB (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Sep 2018 15:37:01 -0400
Received: by mail-vs1-f44.google.com with SMTP id y22-v6so1445484vsj.10
        for <fio@vger.kernel.org>; Thu, 27 Sep 2018 06:18:47 -0700 (PDT)
MIME-Version: 1.0
References: <000001d455b9$6e4e6850$4aeb38f0$@integritech.solutions>
In-Reply-To: <000001d455b9$6e4e6850$4aeb38f0$@integritech.solutions>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 27 Sep 2018 14:18:20 +0100
Message-ID: <CALjAwxiUCAsmXC7xx4QLS+zfz0k6erdbgd89nYbJNp9KtfhruA@mail.gmail.com>
Subject: Re: Resending: fio testing on S3 object storage
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: eliezer@integritech.solutions
Cc: fio <fio@vger.kernel.org>

Hi,

You
On Wed, 26 Sep 2018 at 17:54, <eliezer@integritech.solutions> wrote:
>
> It looks like I don=E2=80=99t have the "http" ioengine on my server:
>
> # fio --enghelp
> Available IO engines:
>         cpuio
>         mmap
>         sync
>         psync
>         vsync
>         pvsync
>         pvsync2
>         null
>         net
>         netsplice
>         ftruncate
>         libaio
>         rdma
>         posixaio
>         falloc
>         e4defrag
>         splice
>         rbd
>         mtd
>         pmemblk
>         dev-dax
>         sg
>         binject

You need to have the appropriate dependencies available when you go to
compile fio (you'll find that ./configure says that http is enabled).
I believe for the http engine you need the development libraries for
curl and openssl installed...

--=20
Sitsofe | http://sucs.org/~sits/

