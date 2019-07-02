Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f45.google.com ([209.85.221.45]:46185 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfGBJfZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 2 Jul 2019 05:35:25 -0400
Received: by mail-wr1-f45.google.com with SMTP id n4so16926110wrw.13
        for <fio@vger.kernel.org>; Tue, 02 Jul 2019 02:35:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAF+0mvm4RkkOV1S53Q5HDsvmt0g8RfLFm1nGc-i0U+8NcV-2WA@mail.gmail.com>
In-Reply-To: <CAF+0mvm4RkkOV1S53Q5HDsvmt0g8RfLFm1nGc-i0U+8NcV-2WA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 2 Jul 2019 10:34:55 +0100
Message-ID: <CALjAwxh1Vq74h+4UmsgKStAh5Y9BfmZh=Xsm9YsdzTVcg55Ccg@mail.gmail.com>
Subject: Re: Concurrent random and sequential IO
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi Matthew!

On Tue, 2 Jul 2019 at 01:05, Matthew Eaton <m.eaton82@gmail.com> wrote:
>
> Hi group,
>
> I'm trying to create a workload that is 50% random read and 50%
> sequential write. Is the command line below accurate for that
> workload?
>
> fio --ioengine=libaio --direct=1 --size=100% --bs=16k --rw=randrw
> --percentage_random=50,50 --numjobs=1 --iodepth=32 --runtime=600
> --time_based --norandommap --randrepeat=0 --refill_buffers --name=job1
> --filename=/dev/sdb

Hard to say. My reading of what you would like is:
- 50% of the I/O should be random read
- The other 50% of the I/O should be sequential write

https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-percentage-random
says percentage_random controls how random a given direction is so
you're actually asking for a writes to be split between 50% sequential
and 50% random, and also asking for reads to be split between 50%
sequential and 50% random. By default there will be a 50% split
between reads and writes with rw=[rw|randrw] (see
https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-readwrite
and https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-rwmixread).

I'd guess you want --percentage_random=100,0 ?

-- 
Sitsofe | http://sucs.org/~sits/

