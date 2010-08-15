Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:38517 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab0HOTDt (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 15 Aug 2010 15:03:49 -0400
Message-ID: <4C683A09.6090303@fusionio.com>
Date: Sun, 15 Aug 2010 15:03:37 -0400
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Build issue on arm: undefined reference to `get_cpu_clock'
References: <4C6141EC.7060205@free-electrons.com> <4C6194C8.2090405@fusionio.com> <4C63B92F.3000009@free-electrons.com> <4C63DFE6.9000608@fusionio.com>
In-Reply-To: <4C63DFE6.9000608@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: fio mailing list <fio@vger.kernel.org>

On 08/12/2010 07:49 AM, Jens Axboe wrote:
> On 08/12/2010 05:04 AM, Michael Opdenacker wrote:
>> Hi Jens,
>>
>> On 08/10/2010 08:04 PM, Jens Axboe wrote:
>>> On 08/10/2010 08:11 AM, Michael Opdenacker wrote:
>>>> The get_cpu_clock function is only defined in
>>>> arch/arch-ia64.h
>>>> arch/arch-x86.h
>>>> arch/arch-x86_64.h
>>>>
>>>> How are other architectures supported? I don't understand fio can
>>>> support them without defining the get_cpu_clock() function.
>>>>
>>>> I did my tests on version 1.42, but faced the same issues with the
>>>> latest git version.
>>>>     
>>> Indeed, dunno what happened there. I'll take a look.
>>>   
>> I have seen your addition of get_cpu_clock() for the ppc architecture.
>>
>> By the way, wouldn't it be more portable to use the POSIX
>> clock_gettime() function instead of reading an architecture dependent
>> register? At least, this is recommended on
>> http://en.wikipedia.org/wiki/Time_Stamp_Counter
> 
> Of course using clock_gettime() would be more portable. The
> point of the CPU clock is speed. If you are testing IOPS into
> the ranges of millions and doing ~5 clock calls per IO, then
> portability takes a back seat to speed.
> 
> But arm needs to work of course, I will commit a patch to
> fix it as soon as I can.

Committed such a patch, would be nice if you could test.
Either git pull or download fio-1.43-rc1 (or latest snap).

-- 
Jens Axboe

