Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725861AbgD2Fd5 (ORCPT
        <rfc822;fio@vger.kernel.org>); Wed, 29 Apr 2020 01:33:57 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447FEC03C1AC
        for <fio@vger.kernel.org>; Tue, 28 Apr 2020 22:33:57 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id g13so901806wrb.8
        for <fio@vger.kernel.org>; Tue, 28 Apr 2020 22:33:57 -0700 (PDT)
MIME-Version: 1.0
References: <af3fe93c-bd21-c991-b4ce-80037623b723@eafit.edu.co>
In-Reply-To: <af3fe93c-bd21-c991-b4ce-80037623b723@eafit.edu.co>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 29 Apr 2020 06:33:30 +0100
Message-ID: <CALjAwxjY5NTtpB-vLqdYju_dH2rGofTSCEPZyM53BUbj4oFu9g@mail.gmail.com>
Subject: Re: Sequential read/write with multiple threads
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Hamilton Tobon Mosquera <htobonm@eafit.edu.co>
Cc: fio <fio@vger.kernel.org>

Hi,

On Wed, 29 Apr 2020 at 04:39, Hamilton Tobon Mosquera
<htobonm@eafit.edu.co> wrote:
>
> Hi there,
>
> I'm trying to run some benchmarks using the ioegnines libaio and
> pvsync2. I'm trying to run sequential reads/writes and random
> read/writes in a file of 200G with a maximum of 4 jobs, that is,
> threads. I don't mix them, that is, I run sequentially or randomly
> reads/writes.
>
> My question is this: when running sequentially, given that I'm using 4
> threads, is it really sequential?. Do the threads interfere with each
> other?, if yes, which options should I use to make each thread only

Sequential to which layer? It's worth noting that the more concurrent
sequential streams there are the more a workload will appear to be
random to the lower levels. From an fio perspective without seeing the
actual job it's hard to answer your question. For example, if each of
the four sequential jobs are working on the same file (because you
specified filename) then there's a high chance of interference and
it's hard to say what the interference will look like given the
interaction of the cache etc. If they are separate files then I guess
you would argue they don't interfere...

> issue requests to disjoint parts of the file, each of 50G (in case of 4
> threads). I tried using offset_increment, but sometimes it overflows on
> random requests, and for sequential requests the file size increases
> automatically, that is, the requests are going further the size of the
> file, but it does not crashes. More specifically, I get the file size in
> bytes, exactly 214748364800. I divide that number in the number of
> threads, and I use the result as the offset_increment. The file is
> created using the filecreate engine with size 200G.

In your case I would expect you would have to use offset AND size to
limit the region worked within (see
https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-offset
).

> Lastly, is it possible for each thread to issue random requests only in
> that piece of 50G, so that it does not overflows to other threads piece
> of file or even overflow outside the file?.

See above!

-- 
Sitsofe | http://sucs.org/~sits/

