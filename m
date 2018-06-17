Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:45003 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754883AbeFQG6A (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 17 Jun 2018 02:58:00 -0400
Received: by mail-vk0-f50.google.com with SMTP id x4-v6so7824368vkx.11
        for <fio@vger.kernel.org>; Sat, 16 Jun 2018 23:58:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKwzdDqCd5kBP2RwkT473X5DfzdXDjbS=d02iNA_QSuzHhqM_Q@mail.gmail.com>
References: <CAKwzdDqCd5kBP2RwkT473X5DfzdXDjbS=d02iNA_QSuzHhqM_Q@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 17 Jun 2018 07:57:29 +0100
Message-ID: <CALjAwxhxE-hVYRz4vLt_b2OGaFHpMbn-hHZ2aVrhcn4QdJk-9w@mail.gmail.com>
Subject: Re: ramp_data logging in json+ format question
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: abhishek koundal <akoundal@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On 8 June 2018 at 00:15, abhishek koundal <akoundal@gmail.com> wrote:
> All,
> Is there a way to collect all the fio data with the json+ logs in the
> way it only calculates the values after the ramp_time?
> e.g.
> ramp_time=10s (still collect all data in some file but not use for calculations)
> runtime = 60s (actual data for the calculations).

I don't think this is possible at present. In fact, I think many stats
are not even recorded until the ramp_time expires (e.g. see
https://github.com/axboe/fio/blob/386501be7e22b6810f1810f0e631c35c95325035/io_u.c#L1889
and https://github.com/axboe/fio/blob/ab5643cb04dac549b2202231d5c6e33339b7fe7d/stat.c#L2662
).

> This will help to track the workloads transition analysis.

-- 
Sitsofe | http://sucs.org/~sits/
