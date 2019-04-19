Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f48.google.com ([209.85.221.48]:46010 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbfDSSV3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 19 Apr 2019 14:21:29 -0400
Received: by mail-wr1-f48.google.com with SMTP id s15so7789809wra.12
        for <fio@vger.kernel.org>; Fri, 19 Apr 2019 11:21:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAEESUgmg2YW7qsq+xQqWyJhmOHi1Rfs_4h0kFthWm2FpHe1oaw@mail.gmail.com>
In-Reply-To: <CAEESUgmg2YW7qsq+xQqWyJhmOHi1Rfs_4h0kFthWm2FpHe1oaw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 19 Apr 2019 09:37:52 +0100
Message-ID: <CALjAwxgiQGXkqY9cUp=1iNnUAVk2cNFZAn7RxD3gjKKis0Kbbw@mail.gmail.com>
Subject: Re: force sync percentiles unit of measure
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matteo Olivi <matteoolivi7@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi Matteo,

On Thu, 4 Apr 2019 at 17:41, Matteo Olivi <matteoolivi7@gmail.com> wrote:
>
> Is there a way to force fio output (no --minimal) to use msec as the
> unit of measure for sync percentiles?
>
> I'm using fio-3.13.

If you are willing to switch fio to output in a different format (such
as JSON) then the answer is yes.

It sounds as if you scraping fio's human readable output at the moment
- is this the case? If so, please switch to using the JSON output (or
at least minimal/terse)! Fio's human output is NOT stable across
versions and is NOT meant for machines! If you are wondering why see
https://github.com/axboe/fio/issues/451 (and
https://www.youtube.com/watch?v=vm1GJMp0QN4#t=17m48s ) for further
details.

--
Sitsofe | http://sucs.org/~sits/

