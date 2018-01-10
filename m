Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:35496 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbeAJWS6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 10 Jan 2018 17:18:58 -0500
Received: by mail-vk0-f50.google.com with SMTP id o73so360168vkd.2
        for <fio@vger.kernel.org>; Wed, 10 Jan 2018 14:18:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b0da74b.48c6.160dfbddb65.Coremail.shadow_lin@163.com>
References: <b0da74b.48c6.160dfbddb65.Coremail.shadow_lin@163.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 10 Jan 2018 22:18:26 +0000
Message-ID: <CALjAwxhM5gdax75e6jKcep79a6g_c8mm57r6_5ZTshnHy3OH+A@mail.gmail.com>
Subject: Re: Newbie question about fio
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: shadow_lin <shadow_lin@163.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On 10 January 2018 at 11:04, shadow_lin <shadow_lin@163.com> wrote:
>
>         1.For read test fio will lay out a file for the test. how the file is generated? will the block size or rw mode effect the file?

See https://github.com/axboe/fio/blob/9d5fe300085759c0f764a62be27355fe80b5fd8f/filesetup.c#L191
. Assuming a generic file based ioengine then maximum block size
writes will be used during layout until the last write (if the size
isn't a multiple). If it's a pure write only job then then there's no
layout.

>           Can I use 4m seq write test to generate file for the 4k rand read test as long as the file size is the same or larger than the read test and the filename matches?

Yes so long as the write test is in a different (prior) fio invocation.

>           If I ran fio on a block device(like /dev/sdb1),how would fio lay out data for read test?

It won't because a block device is not treated as a normal file for
layout purposes by Linux fio.

>           In filesysterm i can change the filename to let fio lay out a new file,but I can't do that with a block device.
>           I did some test to find that if I do some write test on a block device then do read test if fio read beyond the data where write test has wrote,the result would be inaccurate(speed be much faster than it should be)

This will be highly dependent on the properties of your block device.
If it's "thin" (e.g. a trimmable SSD) then it may return "never
written/trimmed" data faster than a region which that has real data.
If you force fio to use a size bigger than the reported block device
size you will get an error when you run off the end. Correct SSD
testing is a topic in and of itself though.

>         2.Fio can use filename and directory to set the where the test is performed. For multi-thread test fio will only generate one file in filename mode but many files if in directory mode.
>
>         If I want to test against a block device I can only use filename to tell fio where to perform the test
>
>         I can understand in directory mode that each thread will read or write to a file and if i increase the numjobs to increase thread number
>         the total filesize increased so the test will cost more time.
>
>         But in filename mode there is only one file and if I increase the numjobs to increase thread number the filesize won't change,
>          but the test still cost more time(I thought differernt thread would write or read different part of the file so the time cost would be smaller,but the test result showed that I am wrong), how each thread read or write to the same file?

Each thread can open the same file and unless you take special
measures their I/O can overlap. This is just like how multiple
programs can open the same file (think about how servers write to a
file while tail follows it) on unix-like OSes.

>         for the same enviroment would the result be different for using filename or directory?which one would be more accurate?or It fully depend on how I want to simluate the workload?

Four threads accessing the same file can give very different results
to four threads accessing four different files. Which is more accurate
depends on whether you are modelling single or multiple file access.
Different simulations (e.g. filesystem vs block device)
demonstrate different things.

-- 
Sitsofe | http://sucs.org/~sits/
