Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:33590 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755405AbdL2LM5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 29 Dec 2017 06:12:57 -0500
Received: by mail-ua0-f179.google.com with SMTP id n6so13677473uak.0
        for <fio@vger.kernel.org>; Fri, 29 Dec 2017 03:12:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPSTwmSgrDt1i2m0hzHpAh9ncM1vWWSQmjcOY6mkpik-c-vwxg@mail.gmail.com>
References: <CAPSTwmSgrDt1i2m0hzHpAh9ncM1vWWSQmjcOY6mkpik-c-vwxg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 29 Dec 2017 11:12:26 +0000
Message-ID: <CALjAwxgT9ZPYAZbBQbwuqfpmBPLHSfK_kqE2mKMaMOmyF_Q6HA@mail.gmail.com>
Subject: Re: LBA selection in FIO
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gnana Sekhar <kgsgnana2020@gmail.com>
Cc: fio@vger.kernel.org

Hi,

On 28 December 2017 at 23:17, Gnana Sekhar <kgsgnana2020@gmail.com> wrote:
>
> I am looking to see if FIO has options to pass LBA count and data
> pattern as CLI arguments.

The rw parameter can take a :<nr> parameter (see
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-readwrite
). The various zone options (e.g.
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-random-distribution
, http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-zonesize
) can enable some types of repetition. It's hard to say if this is
enough for your purposes though...

If you have to precisely craft exact offsets and exact counts you
could use an iolog replay file via the read_iolog option
(http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-read-iolog
). If your shell supports it you might be even able to craft the
replay "file" on the fly (e.g. bash can use <() to do Process
Substitution).

> Data pattern means same pattern to the specified LBA range i.e.,
> either all 1's or 0's etc.,

If the data is identical in every block being written then perhaps
buffer_pattern -
http://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-buffer-pattern
?

> Also will FIO be able to write to specified number of LBAs
> irrespective of the LBA size

I am struggling to understand this question. If you mean "can fio be
told to write a specific number of blocks" then isn't this normally
the blocksize (http://fio.readthedocs.io/en/latest/fio_man.html#block-size
)?

-- 
Sitsofe | http://sucs.org/~sits/
