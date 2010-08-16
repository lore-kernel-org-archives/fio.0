Return-Path: <fio-owner@vger.kernel.org>
Received: from sd-19487.dedibox.fr ([88.190.12.23]:39032 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab0HPNAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 16 Aug 2010 09:00:03 -0400
Message-ID: <4C693642.3060706@free-electrons.com>
Date: Mon, 16 Aug 2010 14:59:46 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Subject: Re: Build issue on arm: undefined reference to `get_cpu_clock'
References: <4C6141EC.7060205@free-electrons.com> <4C6194C8.2090405@fusionio.com> <4C63B92F.3000009@free-electrons.com> <4C63DFE6.9000608@fusionio.com> <4C683A09.6090303@fusionio.com>
In-Reply-To: <4C683A09.6090303@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: fio mailing list <fio@vger.kernel.org>

Hi Jens,

On 08/15/2010 09:03 PM, Jens Axboe wrote:
>
>> Of course using clock_gettime() would be more portable. The
>> point of the CPU clock is speed. If you are testing IOPS into
>> the ranges of millions and doing ~5 clock calls per IO, then
>> portability takes a back seat to speed.
>>
>> But arm needs to work of course, I will commit a patch to
>> fix it as soon as I can.
>>     
> Committed such a patch, would be nice if you could test.
> Either git pull or download fio-1.43-rc1 (or latest snap).
>   
Many thanks for the patch!

I had no problem compiling it on ARM, and I ran it with no problem on an
example job file:

[random-writers]
ioengine=libaio
iodepth=4
rw=randwrite
bs=32k
direct=0
size=64m
numjobs=4

Now, you may modify the README file to mention that the ARM platform is
supported too.

Thanks again,

Cheers,

Michael.

-- 
Michael Opdenacker, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
+ 33 621 604 642

