Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33171 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752444AbdBMTe5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Feb 2017 14:34:57 -0500
Received: by mail-oi0-f68.google.com with SMTP id j15so594158oih.0
        for <fio@vger.kernel.org>; Mon, 13 Feb 2017 11:34:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <DF4PR84MB01697A35FA0838226A39B300AB590@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <20170213163239.46188-1-tkusumi@tuxera.com> <20170213163239.46188-2-tkusumi@tuxera.com>
 <DF4PR84MB01697A35FA0838226A39B300AB590@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Mon, 13 Feb 2017 21:34:16 +0200
Message-ID: <CAHndrBkcH59tr8uK=iT6mJ16qR5oZeW=CMm7SCHEmPVChnhXaA@mail.gmail.com>
Subject: Re: [PATCH 2/6] configure: Use x86 instead of i386 for $cpu for IA32
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Tomohiro Kusumi <tkusumi@tuxera.com>

Hi

2017-02-13 21:24 GMT+02:00 Elliott, Robert (Persistent Memory)
<elliott@hpe.com>:
>
>
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>> Behalf Of kusumi.tomohiro@gmail.com
>> Sent: Monday, February 13, 2017 10:33 AM
>> To: axboe@kernel.dk; fio@vger.kernel.org
>> Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
>> Subject: [PATCH 2/6] configure: Use x86 instead of i386 for $cpu for IA32
>>
>> From: Tomohiro Kusumi <tkusumi@tuxera.com>
>>
>> fio internally uses "x86" for any sort of IA32, so use x86 for $cpu
>> as well which gets printed on ./configure.
>
> That's the gcc cpu_type, and derives from  the __i386__  macro value
> that configure is checking for. All the other architectures stay with
> the cpu_type name at this level.
>
>>  # grep i386 . -rI
>>  ./arch/arch.h:#if defined(__i386__)
>>  ./configure:elif check_define __i386__ ; then
>>  ./configure:  cpu="i386"
>>  ./configure:  i386|i486|i586|i686|i86pc|BePC)
>>  ./configure:    cpu="i386"
>>  ./crc/sha1.c:#if defined(__i386__) || defined(__x86_64__)
>>  ./crc/xxhash.c:#if defined(__ARM_FEATURE_UNALIGNED) ||
>> defined(__i386) || defined(_M_IX86) || defined(__x86_64__) ||
>> defined(_M_X64)
>
> That search points out crc/xxhash.c is missing the trailing __ on the
> __i386__ macro, which seems like a bug.
>
> The search should have also found this in arch/arch-x86.h:
>     #define FIO_ARCH        (arch_i386)
>
> and an enum arch/arch.h:
>     enum {
>       arch_i386,


This has been changed to x86 (actually by myself in e12f4ede46 in 2016) also.
What this patch does actually should have been changed at that time.


>
> I think they would also need to be changed, if the change is made.
> FIO_ARCH is used by gfio in the Architecture box.
>
> ---
> Robert Elliott, HPE Persistent Memory
>
>
>
>
