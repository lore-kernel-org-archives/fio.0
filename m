Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:36263 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753541AbeDPIf1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 16 Apr 2018 04:35:27 -0400
Received: by mail-vk0-f44.google.com with SMTP id w1so2227023vkf.3
        for <fio@vger.kernel.org>; Mon, 16 Apr 2018 01:35:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180326235824.GC30981@mayhem.atnf.CSIRO.AU>
References: <20180326235824.GC30981@mayhem.atnf.CSIRO.AU>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 16 Apr 2018 09:34:56 +0100
Message-ID: <CALjAwxinOoEwCV4GyZL-ud0YffQOdOGPZnw=NPcUeS=PcJeUmQ@mail.gmail.com>
Subject: Re: help constructing job file
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vincent McIntyre <vincent.mcintyre@csiro.au>
Cc: fio <fio@vger.kernel.org>

Hi!

On 27 March 2018 at 00:58, Vincent McIntyre <vincent.mcintyre@csiro.au> wrote:
> Hi
>
> (newbie alert)
>
> I am struggling with how to model a particular workload:
>  - there are two groups of processes (8 writers and 8 readers),
>    that run concurrently, writing to a single RAID unit
>
>  - each of the writers
>    - opens 36 files
>    - appends to the files in 1M chunks until they reach 100G

Perhaps you want to set bs=1M ?

>    - closes those files and opens a new set

This might be tricky. You can control the number of files open
simultaneously but I don't think a single job can change the set of
files it works over. You would have to have a job that waits for an
earlier one to finish and works with a different set of files.

>
>  - each of the readers
>    - reads a group of 36 contemporaneous files from beginning to end
>    - moves on to the next group

See above.

> My goal is not to maximise numbers from fio tests but rather
> to model the system and how it is likely to scale up or down.
> In particular I want to observe the system behaviour over an
> extended period (up to 24h) with readers & writers hammering away.
>
> Below is my initial sketch which isn't right; in my tests (with
> smaller filesize, numjobs, nrfiles) it runs the file layout fine
> but I never seem to get a prolonged period of read operations
> in parallel with writes.
>
> [global]
> direct=0
> fsync=0
> bs=4k
> size=1M

I'm not sure this is right. Perhaps size=100g bs=1M ?

> ioengine=posixaio

If you're on Linux you might find libaio is faster. Also note you
don't have direct=1 so your kernel is allowed to do caching.

> rwmixread=50
> rwmixwrite=50

All jobs will be doing both reads AND writes. Is this what you really want?

> group_reporting=1
> per_job_logs=0
> filesize=100G
> file_append=1

Did you want files to be reset before being grown (e.g. if the file
already with 100G of size do you want it to grow to 200G)?

> invalidate=1

invalidate is 1 by default.

> refill_buffers=1
>
> [writer]
> name=writer
> readwrite=write
> numjobs=8
> nrfiles=36
> file_service_type=roundrobin
>
> [reader]
> name=reader
> readwrite=read
> numjobs=8
> nrfiles=36
> file_service_type=roundrobin

-- 
Sitsofe | http://sucs.org/~sits/
