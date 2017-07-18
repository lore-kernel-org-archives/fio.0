Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:36172 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751586AbdGRGDs (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jul 2017 02:03:48 -0400
Received: by mail-ua0-f169.google.com with SMTP id 35so11529653uax.3
        for <fio@vger.kernel.org>; Mon, 17 Jul 2017 23:03:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <68e2387b-4010-aadf-4df8-1f7f434b6258@bluestop.org>
References: <68e2387b-4010-aadf-4df8-1f7f434b6258@bluestop.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 18 Jul 2017 07:03:17 +0100
Message-ID: <CALjAwxik+EZL1WrB01ye_OaiELE44HmCm2NTC_hKX2v2rxvHmw@mail.gmail.com>
Subject: Re: pmemblk ioengine broken (pmemblk_bsize unknown)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Rebecca Cran <rebecca@bluestop.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 18 July 2017 at 04:46, Rebecca Cran <rebecca@bluestop.org> wrote:
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

Looks like pmemblk_bsize didn't show up until
https://github.com/pmem/nvml/commit/463aa6bbae83942ca7819c3eb1a698f3dfcafd5=
9#diff-753ccabb0b5b2cc0453fb0bb1ef10bf8
which github says only went into 0.2+b3 and then subsequently
0.3...

--=20
Sitsofe | http://sucs.org/~sits/
