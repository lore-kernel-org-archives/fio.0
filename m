Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vs1-f44.google.com ([209.85.217.44]:34202 "EHLO
        mail-vs1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727645AbeKHBYJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Nov 2018 20:24:09 -0500
Received: by mail-vs1-f44.google.com with SMTP id y27so7871255vsi.1
        for <fio@vger.kernel.org>; Wed, 07 Nov 2018 07:53:13 -0800 (PST)
MIME-Version: 1.0
References: <CAFF4W0UQ3pbXaeDAp_=6L1CPvP46gZO-+TyH0xH5KaGC3uKmjg@mail.gmail.com>
 <CAFF4W0WDN7XaYY1N60+af89bGhet4XUjJj09-f6h-R-kTLU-Hw@mail.gmail.com>
In-Reply-To: <CAFF4W0WDN7XaYY1N60+af89bGhet4XUjJj09-f6h-R-kTLU-Hw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 7 Nov 2018 15:52:47 +0000
Message-ID: <CALjAwxjm=++VjQCNyuo1aJQ3rH3u6tWtxkzKqYJ-JR3sTCnpag@mail.gmail.com>
Subject: Re: randrepeat allrandrepeat randseed explanation
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mohanraj B <bmohanraj91@gmail.com>
Cc: fio <fio@vger.kernel.org>

On Wed, 7 Nov 2018 at 11:43, Mohanraj B <bmohanraj91@gmail.com> wrote:
>
> Could able to see the effect of these options when used in test.
> --allrandrepeat=1
>
> How to verify that these three options working as expected when set
> during the test.

Things like allrandrepeat have an impact when you are using multiple
jobs in one invocation. With such invocations try looking at the
output you get when you use --debug=io or use things like log_offset
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-log-offset
) to see the difference...

-- 
Sitsofe | http://sucs.org/~sits/

