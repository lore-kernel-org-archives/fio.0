Return-Path: <zhong@imap.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 07 Dec 2015 15:21:52 +0800
From: zhong <zhong@imap.linux.ibm.com>
Subject: Re: [RFC PATCH] powerpc: enable cpu clock for powerpc64
In-Reply-To: <5661CC63.7070305@kernel.dk>
References: <1449208206.30683.9.camel@TP420> <5661CC63.7070305@kernel.dk>
Message-ID: <dc73b2eb8cae04be0634d3ecee0df064@imap.linux.ibm.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2015-12-05 01:24, Jens Axboe wrote:
> On 12/03/2015 10:50 PM, Li Zhong wrote:
>> This patch tries to enable cpu clock for powerpc64, the code is copied 
>> from
>> mftb() in kernel source.
>> 
>> The two instructions after mfspr are added in the kernel to solve an 
>> erratum on
>> Cell and fsl booke CPUs. On those CPUs, 64 bits mftb is not atomic, so 
>> it is
>> possible that the low order 32 bits are already reset to 0x00000000 
>> but the
>> high order bits are not yet incremented by one.
>> 
>> Don't know how to tell whether it will be running on those CPUs or 
>> not, I just
>> keep the above fix for all ppc64 CPUs. Even if we have some method to 
>> check
>> whether we are on those CPUs or not at run time, I think the check 
>> won't cost
>> less than the two added instructions. Maybe we could use the similar 
>> fix up
>> code kernel uses to dynamically patch the instructions with nops if 
>> not needed.
>> But that would add much more complexity.
> 
> Thanks, applied. I don't have any powerpc hw, so I'll depend on your
> testing for this.

Thank you. We did compile and run it on a P8 host/guest, it seemed ok.

Thanks, Zhong


