Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk1-f172.google.com ([209.85.221.172]:35365 "EHLO
        mail-vk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbeJYN62 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Oct 2018 09:58:28 -0400
Received: by mail-vk1-f172.google.com with SMTP id b207so1865303vke.2
        for <fio@vger.kernel.org>; Wed, 24 Oct 2018 22:27:22 -0700 (PDT)
MIME-Version: 1.0
References: <F18878F1-E710-4BAC-AF00-C65A7BA90E7E@emc.com>
In-Reply-To: <F18878F1-E710-4BAC-AF00-C65A7BA90E7E@emc.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 25 Oct 2018 06:26:55 +0100
Message-ID: <CALjAwxjcUU0-EV90YfmxQYJmoigbyEWHViNEOCHPSZkuAX=qqA@mail.gmail.com>
Subject: Re: Initial Data Write
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mark Beierl <Mark.Beierl@dell.com>
Cc: fio <fio@vger.kernel.org>

Hi Mark,

On Wed, 24 Oct 2018 at 19:15, Beierl, Mark <Mark.Beierl@dell.com> wrote:
>
> Hello,
>
> I think I=E2=80=99m confusing myself here.  When I issue the following jo=
b:
>
>   fio --rw=3Drandwrite --name=3Dinitialize --direct=3D1 --size=3D10m --bs=
=3D4k --loops=3D1 --iodepth=3D1 --ioengine=3Dlibaio
>
> and then do a hexdump of the output file, I see a lot of empty (0000) dat=
a in the file.  Shouldn=E2=80=99t the full 10m of the file be filled with r=
andom data?
>
> Sample output:
>
>   hexdump initialize.0.0 | head
>   0000000 5000 004b 0000 0000 4000 0091 0000 0000
>   0000010 6000 0022 0000 0000 2000 0034 0000 0000
>   0000020 2000 0061 0000 0000 2000 006c 0000 0000
>   0000030 7000 0019 0000 0000 5000 0049 0000 0000
>   0000040 4000 0079 0000 0000 7000 002e 0000 0000
>   0000050 9000 009d 0000 0000 d000 0090 0000 0000
>   0000060 4000 0028 0000 0000 e000 0095 0000 0000
>   0000070 1000 000c 0000 0000 b000 0004 0000 0000
>   0000080 d000 0000 0000 0000 f000 0009 0000 0000
>   0000090 d000 004f 0000 0000 0000 0018 0000 0000
>
> What am I missing?
>
> fio verision is 2.2.10

Agh, that fio is REALLY old! We (upstream) only support the latest fio
(see https://github.com/axboe/fio/releases for what we're up to). I
will answer as if you are but be aware there are differences and fixes
that have gone in since 2.2.10 so I strongly recommend you upgrade...

OK a stab at an answer: as mentioned in the fio help pages / manual
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-refill-buf=
fers
) by default fio will reuse buffer contents after the initial init
where possible. If this is not what you want you will need to set
additional options (hints:
https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-refill-buff=
ers
, https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-scramble-=
buffers
, https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-buffer-co=
mpress-percentage
etc.).

--=20
Sitsofe | http://sucs.org/~sits/

