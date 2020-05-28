Return-Path: <fio-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:19745 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390086AbgE1NCI (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 May 2020 09:02:08 -0400
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: Build failure on NetBSD since "fio: Generalize zonemode=zbd"
Date: Thu, 28 May 2020 13:02:05 +0000
Message-ID: <20200528130204.senunv5454uvd7hy@shindev.dhcp.fujisawa.hgst.com>
References: <CAHndrBnYH-i1y890GfAjHq1Mz2kgB4b6JcxtT4q0wjE_pV-hUQ@mail.gmail.com>
In-Reply-To: <CAHndrBnYH-i1y890GfAjHq1Mz2kgB4b6JcxtT4q0wjE_pV-hUQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8A515A4AF24AA44EA094EBCD120A96CC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Cc: fio <fio@vger.kernel.org>

On May 27, 2020 / 01:08, Tomohiro Kusumi wrote:
> b76949618d557bd63181245aa522ead9b92d274b ("fio: Generalize zonemode=3Dzbd=
")
> which got rid of CONFIG_HAS_BLKZONED flag broke compilation on NetBSD,
> as pthread in NetBSD doesn't have pthread_mutexattr_setpshared(3).
> Looks like OpenBSD doesn't have it either.
>=20
> --
> ld: zbd.o: in function `parse_zone_info':
> fio/zbd.c:422: undefined reference to `pthread_mutexattr_setpshared'
> ld: zbd.o: in function `init_zone_info':
> fio/zbd.c:378: undefined reference to `pthread_mutexattr_setpshared'
> gmake: *** [Makefile:483: fio] Error 1

Hello Tomohiro,

I have sent out a patch series with subject "Fix compilation error on BSD"
which tries to address the issue. I do not have BSD systems and can not con=
firm
the series fixes the issue. Could you help to check the fix with your syste=
m?

--=20
Best Regards,
Shin'ichiro Kawasaki=

