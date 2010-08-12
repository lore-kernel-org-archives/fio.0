Return-Path: <fio-owner@vger.kernel.org>
Received: from sd-19487.dedibox.fr ([88.190.12.23]:50779 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab0HLJFB (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 12 Aug 2010 05:05:01 -0400
Message-ID: <4C63B92F.3000009@free-electrons.com>
Date: Thu, 12 Aug 2010 11:04:47 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Subject: Re: Build issue on arm: undefined reference to `get_cpu_clock'
References: <4C6141EC.7060205@free-electrons.com> <4C6194C8.2090405@fusionio.com>
In-Reply-To: <4C6194C8.2090405@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: fio mailing list <fio@vger.kernel.org>

Hi Jens,

On 08/10/2010 08:04 PM, Jens Axboe wrote:
> On 08/10/2010 08:11 AM, Michael Opdenacker wrote:
>> The get_cpu_clock function is only defined in
>> arch/arch-ia64.h
>> arch/arch-x86.h
>> arch/arch-x86_64.h
>>
>> How are other architectures supported? I don't understand fio can
>> support them without defining the get_cpu_clock() function.
>>
>> I did my tests on version 1.42, but faced the same issues with the
>> latest git version.
>>     
> Indeed, dunno what happened there. I'll take a look.
>   
I have seen your addition of get_cpu_clock() for the ppc architecture.

By the way, wouldn't it be more portable to use the POSIX
clock_gettime() function instead of reading an architecture dependent
register? At least, this is recommended on
http://en.wikipedia.org/wiki/Time_Stamp_Counter

Thank you for your support,

Cheers,

Michael.

-- 
Michael Opdenacker, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
+ 33 621 604 642

