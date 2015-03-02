Return-Path: <ehrhardt@linux.vnet.ibm.com>
Message-ID: <54F41DBA.4060301@linux.vnet.ibm.com>
Date: Mon, 02 Mar 2015 09:22:18 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fio: fix cycles_start build issue
References: <54F02B6C.8080506@linux.vnet.ibm.com> <54F08B3C.1080102@kernel.dk>
In-Reply-To: <54F08B3C.1080102@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 27/02/15 16:20, Jens Axboe wrote:
> On 02/27/2015 01:31 AM, Christian Ehrhardt wrote:
>> Hi,
>> a recent checkout of fio-git revealed a build issue on s390.
>> For whatever reason my git send-email setup is broken so I paste it in
>> the mail and hope it doesn't get mangled, let me know if that fails.
>
> It mangled it horribly, but I just hand applied it. One issue, though:
>
>> diff --git a/arch/arch-generic.h b/arch/arch-generic.h
>> index a0b71f8..825a829 100644
>> --- a/arch/arch-generic.h
>> +++ b/arch/arch-generic.h
>> @@ -2,6 +2,7 @@
>>   #define ARCH_GENERIC_H
>>
>>   #define FIO_ARCH    (arch_generic)
>> +#define ARCH_CPU_CLOCK_WRAPS
>
> This wont work like I suspect you think it does. This define needs to go
> in the arch.h header, if you want all archs to catch it.
>

I can only agree and thank you for unmangling the content.
Thanks !


