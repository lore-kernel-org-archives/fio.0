Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:37043
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab1H3Rvo (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 30 Aug 2011 13:51:44 -0400
Message-ID: <4E5D2329.7070909@kernel.dk>
Date: Tue, 30 Aug 2011 11:51:37 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Adding userspace_libaio_reap option
References: <1314664153-21134-1-git-send-email-dehrenberg@google.com> <4E5CE96D.3000905@kernel.dk> <CAAK6Zt23Aq86=5Cbe+Bzpy=8QoAmequf-9Keo7wE45hHWwxW7g@mail.gmail.com>
In-Reply-To: <CAAK6Zt23Aq86=5Cbe+Bzpy=8QoAmequf-9Keo7wE45hHWwxW7g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Daniel Ehrenberg <dehrenberg@google.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-08-30 11:47, Daniel Ehrenberg wrote:
> On Tuesday, August 30, 2011, Jens Axboe <axboe@kernel.dk <mailto:axboe@kernel.dk>> wrote:
>> On 2011-08-29 18:29, Dan Ehrenberg wrote:
>>> When a single thread is reading from a libaio io_context_t object
>>> in a non-blocking polling manner (that is, with the minimum number
>>> of events to return being 0), then it is possible to safely read
>>> events directly from user-space, taking advantage of the fact that
>>> the io_context_t object is a pointer to memory with a certain layout.
>>> This patch adds an option, userspace_libaio_reap, which allows
>>> reading events in this manner when the libaio engine is used.
>>>
>>> You can observe its effect by setting iodepth_batch_complete=0
>>> and seeing the change in distribution of system/user time based on
>>> whether this new flag is set. If userspace_libaio_reap=1, then
>>> busy polling takes place in userspace, and there is a larger amount of
>>> usr CPU. If userspace_libaio_reap=0 (the default), then there is a
>>> larger amount of sys CPU from the polling in the kernel.
>>>
>>> Polling from a queue in this manner is several times faster. In my
>>> testing, it took less than an eighth as much time to execute a
>>> polling operation in user-space than with the io_getevents syscall.
>>
>> Good stuff! The libaio side looks good, but I think we should add engine
>> specific options under the specific engine. With all the
>> commands/options that fio has, it quickly becomes a bit unwieldy. So,
>> idea would be to have:
>>
>> ioengine=libaio:userspace_reap
> 
> Good idea. I was looking around for engine-specific options but didn't
> see any examples. I like this convention.

Optimally, we should be able to nest options under the options. But a
quicker hack should suffice, can always be extended if need be.

>>
>> I'll look into that.
>>
>> One question on the code:
>>
>>> +static int user_io_getevents(io_context_t aio_ctx, unsigned int max,
>>> +                     struct io_event *events)
>>> +{
>>> +     long i = 0;
>>> +     unsigned head;
>>> +     struct aio_ring *ring = (struct aio_ring*)aio_ctx;
>>> +
>>> +     while (i < max) {
>>> +             head = ring->head;
>>> +
>>> +             if (head == ring->tail) {
>>> +                     /* There are no more completions */
>>> +                     break;
>>> +             } else {
>>> +                     /* There is another completion to reap */
>>> +                     events[i] = ring->events[head];
>>> +                     ring->head = (head + 1) % ring->nr;
>>> +                     i++;
>>> +             }
>>> +     }
>>
>> Don't we need a read barrier here before reading the head/tail?
>>
> Of course; how did I forget that?
> 
> I can make a fine barrier to run on my x64 machines, but it would be
> much better to not introduce an architectural dependency. Is there any
> kind of free library for this? Google has one (used in V8) but it's
> C++ and probably isn't on enough architectures. And of course the
> Linux kernel has one, but it would be a small project to extract it
> for use in user-space--or has someone done this work?

Fio already includes read and write barriers, they are called
read_barrier() and write_barrier().

FWIW, I agree with Jeff that this would be best handled in the libaio
library code. But if we can make it work reliably with the generic
kernel code (and I think we should), then I want to carry it in fio. For
patches that aren't even merged yet, the road to a setup that already
has this included by default is very long.

-- 
Jens Axboe

