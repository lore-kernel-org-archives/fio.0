Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:45025 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753552AbeFOVp5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 15 Jun 2018 17:45:57 -0400
Received: by mail-vk0-f50.google.com with SMTP id x4-v6so6475010vkx.11
        for <fio@vger.kernel.org>; Fri, 15 Jun 2018 14:45:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <MWHPR04MB032019EDD2993DA29DB190538F7C0@MWHPR04MB0320.namprd04.prod.outlook.com>
References: <MWHPR04MB032019EDD2993DA29DB190538F7C0@MWHPR04MB0320.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 15 Jun 2018 22:45:26 +0100
Message-ID: <CALjAwxhCx2AxM3yu31Xnhrvgtqsa0N59jweVFk0Z3yKMSTHQzg@mail.gmail.com>
Subject: Re: fio make warning
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hmm,

On 15 June 2018 at 18:53, Jeff Furlong <jeff.furlong@wdc.com> wrote:
> On some kernels, I am getting a make warning:
>
> CC init.o
> init.c: In function td_fill_rand_seeds:
> init.c:1049:18: warning: array subscript is above array bounds [-Warray-bounds]
>     td->rand_seeds[i] = FIO_RANDSEED * td->thread_number
>                   ^
> init.c:1049:18: warning: array subscript is above array bounds [-Warray-bounds]
> init.c:1049:18: warning: array subscript is above array bounds [-Warray-bounds]
> init.c:1049:18: warning: array subscript is above array bounds [-Warray-bounds]

Assuming latest fio (af84cd66149507424814cf9c0b4950f4cf66e3b7 ):

From fio.h
244: unsigned long rand_seeds[FIO_RAND_NR_OFFS];

init.c
1048: for (i = 0; i < FIO_RAND_NR_OFFS; i++)

So the array is from 0 - (FIO_RAND_NR_OFFS - 1) and i should going
from 0 - (FIO_RAND_NR_OFFS - 1). Not sure I understand the issue...

Which compiler were you using and what version was it?

-- 
Sitsofe | http://sucs.org/~sits/
