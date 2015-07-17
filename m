Return-Path: <axboe@kernel.dk>
Message-ID: <55A91B14.3050706@kernel.dk>
Date: Fri, 17 Jul 2015 09:11:16 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: PATCH: Don't lose pending completions on exit in time- or size-based
 job with asynchronous I/O engine
References: <CANvN+ekBVCAMge-A9dMTeOnXSJ7sZ9OdQ_ZMeqgcTsoa8J0bJg@mail.gmail.com> <55A912DB.8030306@kernel.dk> <CANvN+en4p0q4Ff4n9KBLku5O67Cs68VUpp0qHK+ye2Cu4YbcJw@mail.gmail.com> <55A91826.8080407@kernel.dk> <CANvN+e=-7zm1yYUPnUaUmoJJ6xALNKBP9kr0F2va8EqF7o2VmQ@mail.gmail.com>
In-Reply-To: <CANvN+e=-7zm1yYUPnUaUmoJJ6xALNKBP9kr0F2va8EqF7o2VmQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 07/17/2015 09:02 AM, Andrey Kuzmin wrote:
> On Fri, Jul 17, 2015 at 5:58 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 07/17/2015 08:53 AM, Andrey Kuzmin wrote:
>>>
>>>
>>> On Jul 17, 2015 5:36 PM, "Jens Axboe" <axboe@kernel.dk
>>> <mailto:axboe@kernel.dk>> wrote:
>>>   >
>>>   > On 07/17/2015 08:30 AM, Andrey Kuzmin wrote:
>>>   >>
>>>   >> Probably worth adding to do_verify() as well.
>>>   >
>>>   >
>>>   > Might be better to ensure that they are reaped when we break out of
>>> the loop instead?
>>>   >
>>>
>>> That's exactly what happens with the patch, doesn't it?
>>
>>
>> It might be... It's not very clear why a !td->cur_depth should force us to
>> stay in the loop?
>
> Because to me breaking out of the loop on time- or size-based limit
> exceeded condition with a non-zero td->cur_depth means loosing
> completions.

That's what I thought. Hence my suggestion would be that we reap any 
potentially inflight IO _outside_ of the loop, that would be a lot cleaner.

-- 
Jens Axboe


