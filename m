Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:34866 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbdGRUXT (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jul 2017 16:23:19 -0400
Received: by mail-ua0-f174.google.com with SMTP id 64so37357148uae.2
        for <fio@vger.kernel.org>; Tue, 18 Jul 2017 13:23:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <787DD20D-DCFE-4E01-8F6E-A84853E89F12@linaro.org>
References: <787DD20D-DCFE-4E01-8F6E-A84853E89F12@linaro.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 18 Jul 2017 21:22:47 +0100
Message-ID: <CALjAwxh-rE6vnRc8TsoOe0Sx8hFbSrhoHgXJa8WAYfLhjooECw@mail.gmail.com>
Subject: Re: random-time I/O with fio
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Paolo Valente <paolo.valente@linaro.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 18 July 2017 at 09:03, Paolo Valente <paolo.valente@linaro.org> wrote:
>
> by chance, is there a (possibly indirect) way to generate I/Os
> occurring at random times with fio?  Even a minimum variation with
> respect to periodic I/O, such as rate-limited I/O I guess, would be
> perfect.

How about rate_process=poisson
(http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-rate-process
)?

-- 
Sitsofe | http://sucs.org/~sits/
