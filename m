Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:37973
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1HaCrq (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 30 Aug 2011 22:47:46 -0400
Message-ID: <4E5DA0D1.9010600@kernel.dk>
Date: Tue, 30 Aug 2011 20:47:45 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH v2] Adding userspace_libaio_reap option
References: <1314751823-17972-1-git-send-email-dehrenberg@google.com> <4E5D870B.8050108@kernel.dk> <CAAK6Zt1kz_QXMo7=6+madqa5FSSUxm9U3_wsJV25JY-W70136Q@mail.gmail.com>
In-Reply-To: <CAAK6Zt1kz_QXMo7=6+madqa5FSSUxm9U3_wsJV25JY-W70136Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Daniel Ehrenberg <dehrenberg@google.com>
Cc: fio@vger.kernel.org

On 2011-08-30 19:09, Daniel Ehrenberg wrote:
> On Tue, Aug 30, 2011 at 5:57 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2011-08-30 18:50, Dan Ehrenberg wrote:
>>> @@ -66,7 +107,16 @@ static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
>>>       int r, events = 0;
>>>
>>>       do {
>>> -             r = io_getevents(ld->aio_ctx, actual_min, max, ld->aio_events + events, t);
>>> +             if (td->o.userspace_libaio_reap == 1
>>> +                 && actual_min == 0
>>> +                 && ((struct aio_ring *)(ld->aio_ctx))->magic
>>> +                             == AIO_RING_MAGIC) {
>>> +                     r = user_io_getevents(ld->aio_ctx, max,
>>> +                             ld->aio_events + events);
>>> +             } else {
>>> +                     r = io_getevents(ld->aio_ctx, actual_min,
>>> +                             max, ld->aio_events + events, t);
>>> +             }
>>
>> One question here - why depend on actual_min == 0? The check is
>> practically free, would not hurt to do the user_io_getevents() first and
>> punt to io_getevents() afterwards if need be.
> 
> I guess I don't need to depend on that, since you'll never be calling
> both user_io_getevents() and sys_io_getevents() at the same time
> still. It was just paranoia, really--if I'm not grabbing the ring_lock
> spinlock that exists in the kernel, then I'll be really safe if I
> never run code that wants to grab it. But I guess the condition is not
> really necessary since the whole thing is single-threaded.

I think it should be safe.

FWIW, I committed this version, so just base further improves on fio
git. I also half-assed a patch to add the sub-option support, and
converted this one. So you should use

ioengine=libaio:userspace_reap

to set it now. I say half-assed, since it's only really supported for
ioengine at the moment, and it's not included in --cmdhelp output. But
it should work, hopefully.

Please give it a spin :-)

-- 
Jens Axboe

