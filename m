Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:60026 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757673Ab0HJSEs (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 10 Aug 2010 14:04:48 -0400
Message-ID: <4C6194C8.2090405@fusionio.com>
Date: Tue, 10 Aug 2010 14:04:56 -0400
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Build issue on arm: undefined reference to `get_cpu_clock'
References: <4C6141EC.7060205@free-electrons.com>
In-Reply-To: <4C6141EC.7060205@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: fio mailing list <fio@vger.kernel.org>

On 08/10/2010 08:11 AM, Michael Opdenacker wrote:
> Hello,
> 
> Though the arm platform seems to be supported, fio fails to build on the
> arm platform. Other non Intel platforms should also be impacted.
> 
> gettime.o: In function `get_cycles_per_usec':
> /home/ubuntu/.phoronix-test-suite/installed-tests/fio/fio-1.42/gettime.c:192:
> undefined reference to `get_cpu_clock'
> /home/ubuntu/.phoronix-test-suite/installed-tests/fio/fio-1.42/gettime.c:199:
> undefined reference to `get_cpu_clock'
> make: *** [fio] Error 1
> 
> Unlike in the fio_gettime, where there is an "#ifdef
> ARCH_HAVE_CPU_CLOCK" statement around the calls to get_cpu_clock(),
> there are other places where this function is used unconditionally.
> 
> The get_cpu_clock function is only defined in
> arch/arch-ia64.h
> arch/arch-x86.h
> arch/arch-x86_64.h
> 
> How are other architectures supported? I don't understand fio can
> support them without defining the get_cpu_clock() function.
> 
> I did my tests on version 1.42, but faced the same issues with the
> latest git version.

Indeed, dunno what happened there. I'll take a look.

-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.
