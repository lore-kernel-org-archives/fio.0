Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CANvN+e=S1Yfy3ZCtPv+LQqDOAhxhw90PDU-1fYH66W2mrH4NOw@mail.gmail.com>
References: <CANvN+ekBVCAMge-A9dMTeOnXSJ7sZ9OdQ_ZMeqgcTsoa8J0bJg@mail.gmail.com>
 <55A912DB.8030306@kernel.dk> <CANvN+en4p0q4Ff4n9KBLku5O67Cs68VUpp0qHK+ye2Cu4YbcJw@mail.gmail.com>
 <55A91826.8080407@kernel.dk> <CANvN+e=-7zm1yYUPnUaUmoJJ6xALNKBP9kr0F2va8EqF7o2VmQ@mail.gmail.com>
 <55A91B14.3050706@kernel.dk> <CANvN+e=S1Yfy3ZCtPv+LQqDOAhxhw90PDU-1fYH66W2mrH4NOw@mail.gmail.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Sun, 19 Jul 2015 15:08:51 +0300
Message-ID: <CANvN+ekrSKEKO=VjWcMwmQiTR6=9DA=POtT+WC2WdfUEcvNONA@mail.gmail.com>
Subject: Re: PATCH: Don't lose pending completions on exit in time- or
 size-based job with asynchronous I/O engine
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, Jul 17, 2015 at 6:23 PM, Andrey Kuzmin
<andrey.v.kuzmin@gmail.com> wrote:
>
> On Jul 17, 2015 6:11 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
>>
>> On 07/17/2015 09:02 AM, Andrey Kuzmin wrote:
>>>
>>> On Fri, Jul 17, 2015 at 5:58 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 07/17/2015 08:53 AM, Andrey Kuzmin wrote:
>>>>>
>>>>>
>>>>>
>>>>> On Jul 17, 2015 5:36 PM, "Jens Axboe" <axboe@kernel.dk
>>>>> <mailto:axboe@kernel.dk>> wrote:
>>>>>   >
>>>>>   > On 07/17/2015 08:30 AM, Andrey Kuzmin wrote:
>>>>>   >>
>>>>>   >> Probably worth adding to do_verify() as well.
>>>>>   >
>>>>>   >
>>>>>   > Might be better to ensure that they are reaped when we break out of
>>>>> the loop instead?
>>>>>   >
>>>>>
>>>>> That's exactly what happens with the patch, doesn't it?
>>>>
>>>>
>>>>
>>>> It might be... It's not very clear why a !td->cur_depth should force us
>>>> to
>>>> stay in the loop?
>>>
>>>
>>> Because to me breaking out of the loop on time- or size-based limit
>>> exceeded condition with a non-zero td->cur_depth means loosing
>>> completions.
>>
>>
>> That's what I thought. Hence my suggestion would be that we reap any
>> potentially inflight IO _outside_ of the loop, that would be a lot cleaner.

Turned out the extant completion reaping code that follows the break
out from the main loop is perfectly sufficient, provided the engine
properly appreciates the minimum number of completions required (which
mine didn't). Withdrawing the original patch request.

Regards,
Andrey

>>
> Agreed, will look into the reaping code.
>
> Regards,
> A.
>> --
>> Jens Axboe
>>

