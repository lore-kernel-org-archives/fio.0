Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbhBJF2d (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 10 Feb 2021 00:28:33 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3B6C061574
        for <fio@vger.kernel.org>; Tue,  9 Feb 2021 21:27:52 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id q8so1024955wru.13
        for <fio@vger.kernel.org>; Tue, 09 Feb 2021 21:27:51 -0800 (PST)
MIME-Version: 1.0
References: <CADRyqkUdkuoN0cfDhXBNuVuy1NaYVW85deBbHF5HDZvXLWNSEQ@mail.gmail.com>
In-Reply-To: <CADRyqkUdkuoN0cfDhXBNuVuy1NaYVW85deBbHF5HDZvXLWNSEQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 10 Feb 2021 05:27:25 +0000
Message-ID: <CALjAwxisegjPFT3Z4fwcm2U-K=GmtzFQstxCyRi9S+UftwOzTg@mail.gmail.com>
Subject: Re: Control % of compressible write workload
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: Michele Pardini <michele.pardini@gmail.com>
Cc: fio <fio@vger.kernel.org>

On Wed, 10 Feb 2021 at 03:38, Michele Pardini <michele.pardini@gmail.com> wrote:
>
> Hello,
>
> I need to test a storage device adjusting the % of the write workload
> that can be compressed. I've learnt how to use
>
> buffer_compress_percentage=70
> refill_buffers
> buffer_pattern
>
> When you set  buffer_compress_percentage to a job, or to global, then
> 100% of the write workload will be compressed (at 70% rate ,in this
> example) .
>
> What I'd like to understand is if there's a way to tune the % of the
> write workload that will be compressed. Ideally FIO should send 70%
> writes compressible (at 10% compress rate) and 30% not compressible
> (or 0% compress rate)
>
> I could create 7 jobs with  buffer_compress_percentage and 3 jobs
> without, but I need to have the 70/30 ratio in a single job/thread.

You could do this with two jobs where one job was writes compressed at
10% and another job was uncompressed writes and then use flow
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-flow
) to balance them against each other in a 7:3 ratio. You would have to
modify the source code of fio if you want to do it in a single job -
feel free to submit a patch if you can provide it as an option that
fits well with the rest of fio!

-- 
Sitsofe

