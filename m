Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgHRNVu (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Aug 2020 09:21:50 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5EBC061389
        for <fio@vger.kernel.org>; Tue, 18 Aug 2020 06:21:49 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id b16so21149007ioj.4
        for <fio@vger.kernel.org>; Tue, 18 Aug 2020 06:21:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200804013828.1569-1-dmitry.fomichev@wdc.com>
 <20200804013828.1569-3-dmitry.fomichev@wdc.com> <CY4PR04MB3751C92C5E4A5048EB689BADE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <CAHndrBmszp=crv_bqHo7FxPsgJZOWBKF9Crv7bT0hHVcN92jmg@mail.gmail.com>
 <CALjAwxjsmg3=QkT6V8ci5FLosJ5+BG_1xwHEEeG5OY6xAx_w9Q@mail.gmail.com> <MN2PR04MB5951CC3B05E953AF3CBDBFA1E15F0@MN2PR04MB5951.namprd04.prod.outlook.com>
In-Reply-To: <MN2PR04MB5951CC3B05E953AF3CBDBFA1E15F0@MN2PR04MB5951.namprd04.prod.outlook.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Tue, 18 Aug 2020 22:21:11 +0900
Message-ID: <CAHndrB=E2hEpNtc0+xEVfXUHxVNXUrmkAkNdR4E7vqRNH1PytA@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] configure: check if pkg-config is installed
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

2020=E5=B9=B48=E6=9C=8818=E6=97=A5(=E7=81=AB) 8:50 Dmitry Fomichev <Dmitry.=
Fomichev@wdc.com>:
>
>
>
> > -----Original Message-----
> > From: Sitsofe Wheeler <sitsofe@gmail.com>
> > Sent: Sunday, August 16, 2020 4:48 PM
> > To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
> > Cc: Damien Le Moal <Damien.LeMoal@wdc.com>; Dmitry Fomichev
> > <Dmitry.Fomichev@wdc.com>; fio@vger.kernel.org
> > Subject: Re: [PATCH v3 2/4] configure: check if pkg-config is installed
> >
> > On Sat, 15 Aug 2020 at 23:05, Tomohiro Kusumi
> > <kusumi.tomohiro@gmail.com> wrote:
> > >
> > > 2020=E5=B9=B48=E6=9C=885=E6=97=A5(=E6=B0=B4) 16:06 Damien Le Moal <Da=
mien.LeMoal@wdc.com>:
> > > >
> > > > On 2020/08/04 10:38, Dmitry Fomichev wrote:
> > > > > A few libraries need to be newer than a specific version in order=
 to be
> > > > > supported by fio and pkg-config utility is used to verify the ver=
sions
> > > > > of the installed libraries. Since this step may fail because pkg-=
config
> > > > > is not installed, verify pkg-config presence and warn the user if=
 it
> > > > > could not be found.
> > > > >
> > > > > To avoid code duplication, add a common helper function to perfor=
m
> > > > > these checks.
> > >
> > > This line
> > > "if test ${!feature} =3D "yes" ; then"
> > > seems to have broken compilation on some BSD's.
> > >
> > > [root@localhost fio]# uname
> > > NetBSD
> > > [root@localhost fio]# gmake clean && gmake
> > > FIO_VERSION =3D fio-3.21-56-g0ce7e
> > > Running configure ...
> > > ./configure: 144: Syntax error: Bad substitution
> > > Makefile:19: config-host.mak: No such file or directory
> > > gmake: *** [Makefile:10: config-host.mak] Error 2
> >
> > Looks like a few bashisms have snuck into configure (shellcheck warns
> > about some other stuff). I think NetBSD's sh is ash...
> >
>
> Indeed. I just sent the fix for this problem.
>
> Tomohiro,
> Would you be able to test the new patch?
>
> Thank you,
> Dmitry

Thanks, I've confirmed ./configure issue is fixed on NetBSD.

