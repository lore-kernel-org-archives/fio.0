Return-Path: <tirea@google.com>
MIME-Version: 1.0
From: Steven Lang <tirea@google.com>
Date: Thu, 2 Feb 2012 12:13:51 -0700
Subject: Re: A commented out optimization...
Message-ID: 
 <CAAUT-yO3JUwe_61XiKrxhQ2cD4NJOg+4k7ttxj_1D+wXY9P=gQ@mail.gmail.com>
References: 
 <CAAUT-yNTJGUircBV+P3CD3FuozBfTfwLgLwu+JpsED4dTMnNKA@mail.gmail.com>
 <4F28F62E.4060708@fusionio.com>
 <CAAUT-yOWxvf9z+9vEe-8Cj4VDpnPwyubc+HGa1ghVA0P36hr3A@mail.gmail.com>
 <4F2A4345.5050007@fusionio.com>
In-Reply-To: <4F2A4345.5050007@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

The only thing I can think is maybe there was some sort of other issue
where perhaps a DMA IO was happening before the memory write,
unrelated to any of the code there, but the write barrier just
happened to fix it.  But even that seems like it would be a bit of a
stretch to imagine it actually being a problem.

On Thu, Feb 2, 2012 at 12:03 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 02/01/2012 10:46 PM, Steven Lang wrote:
>> On Wed, Feb 1, 2012 at 12:22 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>> On 02/01/2012 02:40 AM, Steven Lang wrote:
>>>> In comparing the performance between older versions of fio and newer
>>>> versions, I noticed right away that pattern writes were slower in fio
>>>> 2.0.1. =A0Running perf showed that most of the time spent in fio was i=
n
>>>> fill_pattern (Over 50% of the CPU time), which was not the case in the
>>>> past.
>>>>
>>>> This seems like it is worth it to have around, however a year ago it
>>>> was commented out with the following commit log:
>>>>
>>>> Author: Jens Axboe <jaxboe@fusionio.com> =A02011-01-14 06:32:30
>>>> Committer: Jens Axboe <jaxboe@fusionio.com> =A02011-01-14 06:32:30
>>>> Parent: 9a793c2f91a47df348237f1a9b778253ca87ec2e (Fix race in exit of
>>>> eta/util thread)
>>>> Child: =A069204d6e8830464bc98fcc28ca91412d6d360775 (Eta/disk thread us=
es
>>>> more than the minimum stack)
>>>> Branches: continue_on_error_type_2, master, remotes/origin/master,
>>>> remotes/origin/stable-1.x
>>>> Follows: fio-1.50-rc2
>>>> Precedes: fio-1.50-rc3
>>>>
>>>> =A0 =A0 Comment out ->buf_filled_len in pattern fill
>>>>
>>>> =A0 =A0 It's buggy, needs to be debugged. Disable for now. It can caus=
e
>>>> =A0 =A0 verify failures.
>>>>
>>>> =A0 =A0 Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
>>>>
>>>> And in the code the comments say "We need to ensure that the pattern
>>>> stores are seen before the fill length store, or we could observe
>>>> headers that aren't valid to the extent notified by the fill length".
>>>>
>>>> However I'm having trouble imaging a case when that will happen, given
>>>> that buffers are filled and consumed within the context of a single
>>>> thread.
>>>
>>> That's not always the case, if you are using async verifies you can hav=
e
>>> multiple threads/CPUs looking at the same buffers.
>>
>> I thought of that; but unless I am misunderstanding the verify code
>> (entirely possible) the call to fill_pattern is only made when writing
>> data. =A0Doing a rw=3Dreadwrite load could potentially mix asynchronous
>> verify threads with calls to fill_buffer, but only the IO thread would
>> be touching the buf_filled_len field, setting it to 0 before reads,
>> and the length before writes.
>>
>> I have not worked with multiprocessor PPC, so I have no idea how bad
>> memory ordering issues are there, however I am at a loss as to how
>> there would be an issue here. =A0My understanding of the life of an io_u
>> is that it is created within the IO thread, initially filled with the
>> base pattern (Or random data) within that thread, pulled off the free
>> list and re-filled, passed to the IO engine, then put back on the free
>> list to repeat the process. =A0Never, in a write-only load, is the io_u
>> ever touched by any other thread. =A0For a read load with verify_async,
>> the io_u could be passed off to a verify thread (But will never be
>> concurrently accessed in both the verify thread and the IO thread),
>> however the verify thread =A0would never update either the buffer data
>> or the filled len field. =A0(Or, really, even check it, since that only
>> happens on writes.) =A0A readwrite load with verify_async would be the
>> only case I could see a potential issue, but the verify thread still
>> never modifies either the buffer or the filled len.
>>
>> So either my understanding of the fio code is mistaken, my
>> understanding of memory ordering errors is mistaken, or something else
>> I am not considering is happening.
>
> I'm not really seeing it either. It bothers me, since I was remembering
> some sort of test case for this. You are right in the async verifies, it
> should not be an issue there. In any case, the pthread lock primitives
> ought to have the appropriate memory barriers. So any addition/removal
> from the freelist should be fine. And for the non-async case, a preempt
> to a different CPU always implies a full memory barrier.
>
>>>> Do you happen to remember what sort of case was buggy and causing this
>>>> to fail?
>>>
>>> Let me see if I can find the thread... OK, here it is:
>>>
>>> http://www.spinics.net/lists/fio/msg00538.html
>>>
>>> I think the issue just dropped off the debug todo. I'd appreciate your
>>> input :-)
>>
>> Ah thanks, it seems I didn't look back far enough in the archives; I'd
>> assumed any thread would be closer to the commit in January.
>>
>> Unfortunately if that's indeed the case, I'm not sure I can fully
>> understand why the bug existed to offer up any input on a fix. =A0I
>> don't even understand how this particular code could deviate far
>> enough from a single threaded load for memory barriers to make a
>> difference.
>
> I'll reenable it.
>
> --
> Jens Axboe
>

