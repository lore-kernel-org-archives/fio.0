Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:36133 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752042AbdBFUOu (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 6 Feb 2017 15:14:50 -0500
Received: by mail-ua0-f182.google.com with SMTP id 96so69383233uaq.3
        for <fio@vger.kernel.org>; Mon, 06 Feb 2017 12:14:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <o7a678$p7c$1@blaine.gmane.org>
References: <o7a678$p7c$1@blaine.gmane.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 6 Feb 2017 20:14:18 +0000
Message-ID: <CALjAwxhRGvFh=t60=OJ6s0dpuJ=z1waPQF=OpKVZZtwsjZtaOA@mail.gmail.com>
Subject: Re: randrepeat false for ssds
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Slow bucks <frankwhitebe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Depends on your objective (are you trying to dodge tricks your SSD
might do?) but bear in you can't control where the SSD ultimately
chooses to put the data or how much it chooses to stuff into each
erase block size. Additionally randrepeat only has an impact when an
entire run is repeated. Some modern SSDs do compression/de-duplication
so if you want to try defeat that you might want to look at the
refill_buffers/scramble_buffers parameters
(http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-refill_buffers
).

On 6 February 2017 at 15:54, Slow bucks <frankwhitebe@gmail.com> wrote:
> Does it make sense to disable randrepeat on SSDs with the way data is
> written (always write to new block with empty pages)?
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Sitsofe | http://sucs.org/~sits/
