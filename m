Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:33736 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751464AbdGVBjd (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Jul 2017 21:39:33 -0400
Received: by mail-ua0-f178.google.com with SMTP id 80so55333855uas.0
        for <fio@vger.kernel.org>; Fri, 21 Jul 2017 18:39:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGSHeY2B1AqeKMNq-nfPik9S-XqUx5_Vj3yaZ8X0XX1MGq6t1w@mail.gmail.com>
References: <CAGSHeY2B1AqeKMNq-nfPik9S-XqUx5_Vj3yaZ8X0XX1MGq6t1w@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 22 Jul 2017 02:39:02 +0100
Message-ID: <CALjAwxg_+nT15+76oEXOuxn9-9edk58Fx7MOUkcDjq=dLo7ZiA@mail.gmail.com>
Subject: Re: Fio IOPS reported incorrectly in some cases
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Yogi Wannabe <yogi43222@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 21 July 2017 at 18:49, Yogi Wannabe <yogi43222@gmail.com> wrote:
>
> When I run fio like this: fio <config filename>
>
> it reports the correct IOPS from beginning of the test. But when I run
> fio like this,
>
> fio --minimal --status-interval=1 <config filename>
>
> the IOPS reported is about 150K lower than expected but gradually
> ramps up and shows the correct value just before the test ends. Is
> this a known issue? Is there a work around for this?

There's not enough detail to really comment - have you seen
https://github.com/axboe/fio/blob/master/REPORTING-BUGS ?. Which part
of the output in particular are you referring to in your comparisons?
Are you on the latest (2.99) version of fio?

-- 
Sitsofe | http://sucs.org/~sits/
