Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f49.google.com ([209.85.222.49]:34325 "EHLO
        mail-ua1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733286AbeITA1t (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Sep 2018 20:27:49 -0400
Received: by mail-ua1-f49.google.com with SMTP id r15-v6so3239255uao.1
        for <fio@vger.kernel.org>; Wed, 19 Sep 2018 11:48:35 -0700 (PDT)
MIME-Version: 1.0
References: <1769401537372008@iva3-a2a8aac410a1.qloud-c.yandex.net>
In-Reply-To: <1769401537372008@iva3-a2a8aac410a1.qloud-c.yandex.net>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 19 Sep 2018 19:48:16 +0100
Message-ID: <CALjAwxgPhfxnP68u7xdwXwkw-ZL3Tmrf20MD=n=WBy+Jd_-ESQ@mail.gmail.com>
Subject: Re: Fio O_SYNC and libaio on 4.15 kernel doesn't flush data
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: zakharov.a.g@yandex.ru
Cc: fio <fio@vger.kernel.org>

Hi,

On Wed, 19 Sep 2018 at 16:56, =D0=97=D0=B0=D1=85=D0=B0=D1=80=D0=BE=D0=B2 =
=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B5=D0=B9 <zakharov.a.g@yandex.ru> wrote:
>
> I'm testing bcache device in ubuntu 16.04 with 4.4 and 4.15 (hwe-edge) ke=
rnels and noticed some strange fio behaviour.
> When i run fio with --ioengine=3Dlibaio and --sync=3D1 options - it only =
works as expected on 4.4 kernel. There're additional flush "write" requests=
, also to backing device of bcache. If i run it on 4.15 - then iops on cach=
ing device are same as fio shows and there're no any io on backing device. =
But, if i set ioengine to posixaio or sync or even if i set --fsync=3D1 opt=
ion, then it works as expected on 4.15 - i can see flush io's.
> It looks like O_SYNC doesn't work with 4.15 when fio runs with libaio.
> Kernel was installed from ubuntu repos, but libaio is used same as for 4.=
4 kernel and I assume that it is the root cause. But i can't find any proof=
 of this guess.
>
> Have any changes been done in kernel that affect O_SYNC or is it libaio(o=
r fio) bug?
>
> Used fio-2.2.10 and fio-3.9.
>
> Hope for any help with understanding this behaviour.

You didn't include the full job that you ran so it's going to be very
hard for anyone here to say too much... If I understand what you're
saying correctly:

- You ran fio-2.2.10 on an Ubuntu 4.4 kernel with bcache and saw
flushing of writes to the backing disk.
- You ran fio-2.2.10 on an Ubuntu 4.10 kernel with bcache and and no
flushing of write to the backing disk.

Assuming that you haven't changed anything else doesn't that either
suggest there's been a change in how bcache works (it can operate as
a non-volatile write back cache so it doesn't have to flush to backing
on a sync) or that there's an issue with the kernel? How would fio
have known to change things between kernel versions? Another thing to
check would be to see if you see flushes on non-bcache devices...

--=20
Sitsofe | http://sucs.org/~sits/

