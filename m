Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405105AbgE1Qqm (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 May 2020 12:46:42 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3849C08C5C6
        for <fio@vger.kernel.org>; Thu, 28 May 2020 09:46:41 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id r2so20437599ioo.4
        for <fio@vger.kernel.org>; Thu, 28 May 2020 09:46:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAHndrBnYH-i1y890GfAjHq1Mz2kgB4b6JcxtT4q0wjE_pV-hUQ@mail.gmail.com>
 <20200528130204.senunv5454uvd7hy@shindev.dhcp.fujisawa.hgst.com>
In-Reply-To: <20200528130204.senunv5454uvd7hy@shindev.dhcp.fujisawa.hgst.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Fri, 29 May 2020 01:46:04 +0900
Message-ID: <CAHndrBkmJYgVXPQAcfhiTGiy2UsiJvJ-iD7oj4rfCZHSFah3-w@mail.gmail.com>
Subject: Re: Build failure on NetBSD since "fio: Generalize zonemode=zbd"
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: fio <fio@vger.kernel.org>

2020=E5=B9=B45=E6=9C=8828=E6=97=A5(=E6=9C=A8) 22:02 Shinichiro Kawasaki <sh=
inichiro.kawasaki@wdc.com>:
>
> On May 27, 2020 / 01:08, Tomohiro Kusumi wrote:
> > b76949618d557bd63181245aa522ead9b92d274b ("fio: Generalize zonemode=3Dz=
bd")
> > which got rid of CONFIG_HAS_BLKZONED flag broke compilation on NetBSD,
> > as pthread in NetBSD doesn't have pthread_mutexattr_setpshared(3).
> > Looks like OpenBSD doesn't have it either.
> >
> > --
> > ld: zbd.o: in function `parse_zone_info':
> > fio/zbd.c:422: undefined reference to `pthread_mutexattr_setpshared'
> > ld: zbd.o: in function `init_zone_info':
> > fio/zbd.c:378: undefined reference to `pthread_mutexattr_setpshared'
> > gmake: *** [Makefile:483: fio] Error 1
>
> Hello Tomohiro,
>
> I have sent out a patch series with subject "Fix compilation error on BSD=
"
> which tries to address the issue. I do not have BSD systems and can not c=
onfirm
> the series fixes the issue. Could you help to check the fix with your sys=
tem?

Hi

Thank you for taking a look at it.
The build failure on NetBSD and OpenBSD are both fixed now.

(I've also compiled it on FreeBSD and DragonFlyBSD which seem to support
pthread_mutexattr_setpshared(3) (at least compile), and they didn't have bu=
ild
issue with your patch series as well.)

>
> --
> Best Regards,
> Shin'ichiro Kawasaki

