Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:34865 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754178AbdDKJGR (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 Apr 2017 05:06:17 -0400
Received: by mail-ua0-f170.google.com with SMTP id 49so54411312uau.2
        for <fio@vger.kernel.org>; Tue, 11 Apr 2017 02:06:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a57ca9a46da448c18611264ee149a9d1@bowex36b.micron.com>
References: <72a0d7083a3e46b4a4369c19d73c62fc@bowex36b.micron.com>
 <CANvN+ekzXJLBYU+N0b-UCg=StSQDeoPRgYpD8TyS_WB_xLgSbw@mail.gmail.com>
 <00494c90cb794f3989606f3cb6fabe53@bowex36b.micron.com> <CANvN+enoDFUpXTpj8HQw2cu8PUbQRV-6yttNUaGn7ovfMNQPsg@mail.gmail.com>
 <CANvN+ekVsscY4adJyns3tup57Fuhg3ixw-u_4Ny9DWDcB5ymHQ@mail.gmail.com>
 <CANvN+e=m-Kt68SjT_iUNTLcjPLWWjOSYPeJiE-w54ASBv+F+DQ@mail.gmail.com> <a57ca9a46da448c18611264ee149a9d1@bowex36b.micron.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Tue, 11 Apr 2017 12:05:56 +0300
Message-ID: <CANvN+e=5NQ-rOHa+aWL4JWmW-=aTmD_NQHYReWL4H1+NqTArSQ@mail.gmail.com>
Subject: Re: Adding IO engine
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Deyoung Hong (dhong)" <dhong@micron.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Tue, Apr 11, 2017 at 8:22 AM, Deyoung Hong (dhong) <dhong@micron.com> wrote:
> I would think both ->setup and ->get_file_size should be called before

get_file_size is not being called if the engine provides setup()
method. If it doesn't, fio calls get_file_size too early, to my
recollection even before the engine has been properly initialized, and
that's why setup() workaround exists.

> ->iomem_alloc, but I have an fio job file (case problem reported by the
> user) where ->iomem_alloc is called before ->setup.

if you see this happening (although, from my year-old recollection,
that's not the case with setup()), just submit a bug report showing
your job file and call sequence.

Regards,
Andrey

> My main question is
> that an fio bug (minor)?  If someone would like to fix it, I can send a test
> job file.
>
>
>
> Thanks,
>
> Deyoung
>
>
>
>
>
> From: Andrey Kuzmin [mailto:andrey.v.kuzmin@gmail.com]
> Sent: Monday, April 10, 2017 2:40 PM
> To: Deyoung Hong (dhong) <dhong@micron.com>
> Cc: fio@vger.kernel.org
> Subject: RE: Adding IO engine
>
>
>
>
>
>
>
> On Apr 11, 2017 00:21, "Deyoung Hong (dhong)" <dhong@micron.com> wrote:
>
> The concept of "file" can represent a special device and driver unknown to
> the system, and get_file_size() and/or setup() are usually the first APIs
> that fio should call where the device will be initialized and set its max
> size so that fio can know the device "file" capacity.  Such device has to be
> initialized prior to IO (DMA) buffer allocation/free that is specific only
> to that device.   There isn't any other fio plugin APIs that precede
> iomem_alloc, and I think iomem_alloc/free were added specifically to support
> that special device.
>
>
>
>
>
> No, the API was added to support I/O engines with special requirements re
> I/O buffer memory, with no relation to special files. If you have specific
> file setup requirements, your engine should provide setup method. As far as
> I recall, it occurs before iomem initialization.
>
>
>
> Regards,
>
> Andrey
>
>
> How is that a misconception?
>
>
>
> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf
> Of Andrey Kuzmin
> Sent: Monday, April 10, 2017 12:44 PM
> To: Deyoung Hong (dhong) <dhong@micron.com>
> Cc: fio@vger.kernel.org
> Subject: Re: Adding IO engine
>
> On Mon, Apr 10, 2017 at 8:45 PM, Deyoung Hong (dhong) <dhong@micron.com>
> wrote:
>> Hi Jens,
>>
>> I have a couple basic questions:
>>
>> 1)  If I want to submit a new IO engine with fio and it has a dependency
>> on an external library, how does that work when fio is compiled?  Please
>> also point me to info how to submit a new IO engine to be packaged with fio?
>>
>> 2)  I've seen cases where the ->iomem_alloc() function (i.e. for a custom
>> IO engine) is invoked first by fio before ->get_file_size() or ->setup().
>> This causes an issue since IO memory allocation can have dependency on
>> certain initialization (for the custom IO engine) that is done in
>> ->get_file_size().   I just wonder if that's an fio bug or how it should be?
>
> It sounds more like a misconception re iomem_{alloc,free} API. It is
> about buffers I/O goes to/from, not files. As an example (and the root
> cause behind the API proposal), I wanted to be able to allocate
> buffers in DMAable memory as my engine required that to interact with
> hardware directly.
>
> Being unrelated to files by design, buffer initialization occurs way
> before file setup as it did in fio before iomem_* API was introduced.
>
> Regards,
> Andrey
>
>
>
>>   My current work around is to check in ->iomem_alloc() each time and do
>> initializion first if has not.
>>
>> Thanks,
>> Deyoung
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
