Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgFPHdD (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 16 Jun 2020 03:33:03 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDA6C05BD43
        for <fio@vger.kernel.org>; Tue, 16 Jun 2020 00:33:03 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id x6so19578578wrm.13
        for <fio@vger.kernel.org>; Tue, 16 Jun 2020 00:33:03 -0700 (PDT)
MIME-Version: 1.0
References: <3866F5B3-377A-4452-B7DB-F57404C6D157@gmail.com>
In-Reply-To: <3866F5B3-377A-4452-B7DB-F57404C6D157@gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 16 Jun 2020 08:32:36 +0100
Message-ID: <CALjAwxiaMosfY0XuvwAvDiahjz6=mYp3LBskT=W-kg3z=zSgJg@mail.gmail.com>
Subject: Re: How to split IO by block size and read/write
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jared Walton <jawalking@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Mon, 15 Jun 2020 at 20:30, Jared Walton <jawalking@gmail.com> wrote:
>
> I=E2=80=99m trying to setup workload where 70% of the IOs are read and 30=
% are write, but all reads would be 4k reads, and all writes would be 8k. I=
s this possible with FIO?
>
> I see that I can set bssplit=3D4k/70:8k/30 but where how would I ensure t=
hat all 4k are reads?

Can't you use just plain blocksize
(https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-blocksize
) and rwmixread
(https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-rwmixread
) for this? blocksize takes comma separated values for each direction
so you could set bs=3D4k,8k and then you could use rwmixread=3D70 to skew
the balance of reads to writes...

--=20
Sitsofe | http://sucs.org/~sits/

