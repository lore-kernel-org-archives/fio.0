Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726288AbgHPUs1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 16 Aug 2020 16:48:27 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D7DC061786
        for <fio@vger.kernel.org>; Sun, 16 Aug 2020 13:48:27 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id f7so12968385wrw.1
        for <fio@vger.kernel.org>; Sun, 16 Aug 2020 13:48:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200804013828.1569-1-dmitry.fomichev@wdc.com>
 <20200804013828.1569-3-dmitry.fomichev@wdc.com> <CY4PR04MB3751C92C5E4A5048EB689BADE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <CAHndrBmszp=crv_bqHo7FxPsgJZOWBKF9Crv7bT0hHVcN92jmg@mail.gmail.com>
In-Reply-To: <CAHndrBmszp=crv_bqHo7FxPsgJZOWBKF9Crv7bT0hHVcN92jmg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 16 Aug 2020 21:48:00 +0100
Message-ID: <CALjAwxjsmg3=QkT6V8ci5FLosJ5+BG_1xwHEEeG5OY6xAx_w9Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] configure: check if pkg-config is installed
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Sat, 15 Aug 2020 at 23:05, Tomohiro Kusumi <kusumi.tomohiro@gmail.com> w=
rote:
>
> 2020=E5=B9=B48=E6=9C=885=E6=97=A5(=E6=B0=B4) 16:06 Damien Le Moal <Damien=
.LeMoal@wdc.com>:
> >
> > On 2020/08/04 10:38, Dmitry Fomichev wrote:
> > > A few libraries need to be newer than a specific version in order to =
be
> > > supported by fio and pkg-config utility is used to verify the version=
s
> > > of the installed libraries. Since this step may fail because pkg-conf=
ig
> > > is not installed, verify pkg-config presence and warn the user if it
> > > could not be found.
> > >
> > > To avoid code duplication, add a common helper function to perform
> > > these checks.
>
> This line
> "if test ${!feature} =3D "yes" ; then"
> seems to have broken compilation on some BSD's.
>
> [root@localhost fio]# uname
> NetBSD
> [root@localhost fio]# gmake clean && gmake
> FIO_VERSION =3D fio-3.21-56-g0ce7e
> Running configure ...
> ./configure: 144: Syntax error: Bad substitution
> Makefile:19: config-host.mak: No such file or directory
> gmake: *** [Makefile:10: config-host.mak] Error 2

Looks like a few bashisms have snuck into configure (shellcheck warns
about some other stuff). I think NetBSD's sh is ash...

--=20
Sitsofe | http://sucs.org/~sits/

