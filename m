Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38946 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbfIWMnV (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Sep 2019 08:43:21 -0400
Received: by mail-wm1-f65.google.com with SMTP id v17so9144583wml.4
        for <fio@vger.kernel.org>; Mon, 23 Sep 2019 05:43:19 -0700 (PDT)
MIME-Version: 1.0
References: <4b960e8e-f9a0-ebd0-7e8a-1ce839ffb6a4@unix-beratung.de>
In-Reply-To: <4b960e8e-f9a0-ebd0-7e8a-1ce839ffb6a4@unix-beratung.de>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 23 Sep 2019 13:42:52 +0100
Message-ID: <CALjAwxg18ifsWcXK5sMWGq92NAehbOoPhw3ASO-O_z3oS4QRQw@mail.gmail.com>
Subject: Re: what is the point of config-host.h?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Robert Urban <urban@unix-beratung.de>
Cc: fio <fio@vger.kernel.org>

Hi,

On Sun, 22 Sep 2019 at 20:22, Robert Urban <urban@unix-beratung.de> wrote:
>
> Hello,
>
> I'm trying to port fio (I used the "download ZIP" link on github on September
> 13th) to Tru64 UNIX V5.1B, an OS no longer being maintained :(
>
> In the meantime I've built gcc 4.6 for Tru64 (a few days and 3.5 GB later.)
>
> When I run configure it produces a "config-host.h" which looks correct, but this
> is never included anywhere. By what mechanism is this header supposed to be
> included?

Isn't it included in all compiles via CFLAGS -
https://github.com/axboe/fio/blob/92f75708b530989fdb13b50be6604f44b80d038d/configure#L47
?

-- 
Sitsofe | http://sucs.org/~sits/

