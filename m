Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:35413 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab2BBIEO (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 2 Feb 2012 03:04:14 -0500
Message-ID: <4F2A4345.5050007@fusionio.com>
Date: Thu, 2 Feb 2012 09:03:17 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: A commented out optimization...
References: <CAAUT-yNTJGUircBV+P3CD3FuozBfTfwLgLwu+JpsED4dTMnNKA@mail.gmail.com> <4F28F62E.4060708@fusionio.com> <CAAUT-yOWxvf9z+9vEe-8Cj4VDpnPwyubc+HGa1ghVA0P36hr3A@mail.gmail.com>
In-Reply-To: <CAAUT-yOWxvf9z+9vEe-8Cj4VDpnPwyubc+HGa1ghVA0P36hr3A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 02/01/2012 10:46 PM, Steven Lang wrote:
> On Wed, Feb 1, 2012 at 12:22 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>> On 02/01/2012 02:40 AM, Steven Lang wrote:
>>> In comparing the performance between older versions of fio and newer
>>> versions, I noticed right away that pattern writes were slower in fio
>>> 2.0.1.  Running perf showed that most of the time spent in fio was in
>>> fill_pattern (Over 50% of the CPU time), which was not the case in the
>>> past.
>>>
>>> This seems like it is worth it to have around, however a year ago it
>>> was commented out with the following commit log:
>>>
>>> Author: Jens Axboe <jaxboe@fusionio.com>  2011-01-14 06:32:30
>>> Committer: Jens Axboe <jaxboe@fusionio.com>  2011-01-14 06:32:30
>>> Parent: 9a793c2f91a47df348237f1a9b778253ca87ec2e (Fix race in exit of
>>> eta/util thread)
>>> Child:  69204d6e8830464bc98fcc28ca91412d6d360775 (Eta/disk thread uses
>>> more than the minimum stack)
>>> Branches: continue_on_error_type_2, master, remotes/origin/master,
>>> remotes/origin/stable-1.x
>>> Follows: fio-1.50-rc2
>>> Precedes: fio-1.50-rc3
>>>
>>>     Comment out ->buf_filled_len in pattern fill
>>>
>>>     It's buggy, needs to be debugged. Disable for now. It can cause
>>>     verify failures.
>>>
>>>     Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
>>>
>>> And in the code the comments say "We need to ensure that the pattern
>>> stores are seen before the fill length store, or we could observe
>>> headers that aren't valid to the extent notified by the fill length".
>>>
>>> However I'm having trouble imaging a case when that will happen, given
>>> that buffers are filled and consumed within the context of a single
>>> thread.
>>
>> That's not always the case, if you are using async verifies you can have
>> multiple threads/CPUs looking at the same buffers.
> 
> I thought of that; but unless I am misunderstanding the verify code
> (entirely possible) the call to fill_pattern is only made when writing
> data.  Doing a rw=readwrite load could potentially mix asynchronous
> verify threads with calls to fill_buffer, but only the IO thread would
> be touching the buf_filled_len field, setting it to 0 before reads,
> and the length before writes.
> 
> I have not worked with multiprocessor PPC, so I have no idea how bad
> memory ordering issues are there, however I am at a loss as to how
> there would be an issue here.  My understanding of the life of an io_u
> is that it is created within the IO thread, initially filled with the
> base pattern (Or random data) within that thread, pulled off the free
> list and re-filled, passed to the IO engine, then put back on the free
> list to repeat the process.  Never, in a write-only load, is the io_u
> ever touched by any other thread.  For a read load with verify_async,
> the io_u could be passed off to a verify thread (But will never be
> concurrently accessed in both the verify thread and the IO thread),
> however the verify thread  would never update either the buffer data
> or the filled len field.  (Or, really, even check it, since that only
> happens on writes.)  A readwrite load with verify_async would be the
> only case I could see a potential issue, but the verify thread still
> never modifies either the buffer or the filled len.
> 
> So either my understanding of the fio code is mistaken, my
> understanding of memory ordering errors is mistaken, or something else
> I am not considering is happening.

I'm not really seeing it either. It bothers me, since I was remembering
some sort of test case for this. You are right in the async verifies, it
should not be an issue there. In any case, the pthread lock primitives
ought to have the appropriate memory barriers. So any addition/removal
from the freelist should be fine. And for the non-async case, a preempt
to a different CPU always implies a full memory barrier.

>>> Do you happen to remember what sort of case was buggy and causing this
>>> to fail?
>>
>> Let me see if I can find the thread... OK, here it is:
>>
>> http://www.spinics.net/lists/fio/msg00538.html
>>
>> I think the issue just dropped off the debug todo. I'd appreciate your
>> input :-)
> 
> Ah thanks, it seems I didn't look back far enough in the archives; I'd
> assumed any thread would be closer to the commit in January.
> 
> Unfortunately if that's indeed the case, I'm not sure I can fully
> understand why the bug existed to offer up any input on a fix.  I
> don't even understand how this particular code could deviate far
> enough from a single threaded load for memory barriers to make a
> difference.

I'll reenable it.

-- 
Jens Axboe

