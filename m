Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:33658 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbdGRFn0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jul 2017 01:43:26 -0400
Received: by mail-ua0-f172.google.com with SMTP id b64so11550611uab.0
        for <fio@vger.kernel.org>; Mon, 17 Jul 2017 22:43:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <68e2387b-4010-aadf-4df8-1f7f434b6258@bluestop.org>
References: <68e2387b-4010-aadf-4df8-1f7f434b6258@bluestop.org>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Tue, 18 Jul 2017 08:42:45 +0300
Message-ID: <CAHndrB=qxf7+sj9YWSKpc8gSX7fBcfV7X3dXPLXpdKEW6kSnQA@mail.gmail.com>
Subject: Re: pmemblk ioengine broken (pmemblk_bsize unknown)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Rebecca Cran <rebecca@bluestop.org>
Cc: fio@vger.kernel.org

It compiles with libpmemblk-1.2.2.
At least it doesn't fail on compile-time.

0.2 might be a bit old ?

# rpm -qa | grep pmemblk
libpmemblk-1.2.2-1.fc25.x86_64
libpmemblk-debug-1.2.2-1.fc25.x86_64
libpmemblk-devel-1.2.2-1.fc25.x86_64
# ./configure | grep pmemblk
libpmemblk                    yes
NVML pmemblk engine           yes
# make -j8 > /dev/null
FIO_VERSION =3D fio-2.99-7-g785e4
# ./fio --enghelp | grep pmemblk
        pmemblk


2017-07-18 6:46 GMT+03:00 Rebecca Cran <rebecca@bluestop.org>:
> I noticed the pmemblk ioengine is broken - I've tested with commit
> 785e49c659023df1735bff195ad4ba133ebd23a7 (i.e. git master as of today).
>
> engines/pmemblk.c: In function =E2=80=98pmb_open=E2=80=99:
> engines/pmemblk.c:219:3: warning: implicit declaration of function
> =E2=80=98pmemblk_bsize=E2=80=99 [-Wimplicit-function-declaration]
>    pmb->pmb_bsize =3D pmemblk_bsize(pmb->pmb_pool);
>    ^
> ...
> engines/pmemblk.o: In function `pmb_open':
> /home/bcran/workspace/fio/engines/pmemblk.c:219: undefined reference to
> `pmemblk_bsize'
> collect2: error: ld returned 1 exit status
>
> I have libpmemblk 0.2 installed.
>
> --
> Rebecca
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
