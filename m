Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:33457 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1042920AbdDVH5V (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 22 Apr 2017 03:57:21 -0400
Received: by mail-vk0-f48.google.com with SMTP id j127so20493471vkh.0
        for <fio@vger.kernel.org>; Sat, 22 Apr 2017 00:57:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxgLHBn6jPfGf3aW1CcX1Py47BCR0vEJ8ByNdZ2i+tY3-g@mail.gmail.com>
References: <625e4fdeac5a68286ce7277718a50be5@pl.sii.eu> <CALjAwxgLHBn6jPfGf3aW1CcX1Py47BCR0vEJ8ByNdZ2i+tY3-g@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 22 Apr 2017 08:56:50 +0100
Message-ID: <CALjAwxhWUYecxU91=B5M7L-0fsgt6gfkBXYaxGPBGoMRRmEYRw@mail.gmail.com>
Subject: Re: FIO mmap options dictate a minimum block size of 4096 bytes
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: kjaszczerski <kjaszczerski@pl.sii.eu>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 20 April 2017 at 23:12, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> On 20 April 2017 at 15:03, kjaszczerski <kjaszczerski@pl.sii.eu> wrote:
>>
>> I'm trying to run FIO on mmap engine on 4k socket and 4k channel. I'd like
>> to use wrokload with blocksize parameter value less than 4k, is it possible
>> ?
>
> You didn't give an example jobfile, fio version, operating system
> (which are really necessary to answer these types of questions) so the
> following is going to be a lot of speculation.
>
> I don't know if you also filed https://github.com/axboe/fio/issues/339
> but there's a partial answer there (using direct=1 forces alignment
> and size constraints). There's a follow up point which is the message
> stems from a desire to catch msync related errors earlier:
> https://github.com/axboe/fio/commit/913ea0db12596b735a030a1836bd913497b7120a
> . I suppose a filesystem will never have a blocksize smaller than a
> page and alignment constraints mean an msync must always start page
> aligned (http://man7.org/linux/man-pages/man2/msync.2.html ) so if you
> have any type of fsync taking place that will trigger that check.

The above is slightly incorrect because the requirement for page
alignment on the address passed to msync() must be obeyed regardless
of your filesystem/device. Since the fio mmap ioengine approximates
direct I/O by using msync() (see
https://github.com/axboe/fio/blob/fio-2.19/engines/mmap.c#L189 ) even
a job using that ioengine which only asks for direct=1 will have to
obey the "all offsets must be page aligned" requirement. In order to
satisfy that requirement, when using direct=1 with the mmap ioengine
the blocksize must always be a (non-zero) multiple of the page size
and if your page size is 4096 this means you can't use a block size
less than that.

-- 
Sitsofe | http://sucs.org/~sits/
