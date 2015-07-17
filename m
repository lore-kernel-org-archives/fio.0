Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <55A91826.8080407@kernel.dk>
References: <CANvN+ekBVCAMge-A9dMTeOnXSJ7sZ9OdQ_ZMeqgcTsoa8J0bJg@mail.gmail.com>
 <55A912DB.8030306@kernel.dk> <CANvN+en4p0q4Ff4n9KBLku5O67Cs68VUpp0qHK+ye2Cu4YbcJw@mail.gmail.com>
 <55A91826.8080407@kernel.dk>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Fri, 17 Jul 2015 18:02:06 +0300
Message-ID: <CANvN+e=-7zm1yYUPnUaUmoJJ6xALNKBP9kr0F2va8EqF7o2VmQ@mail.gmail.com>
Subject: Re: PATCH: Don't lose pending completions on exit in time- or
 size-based job with asynchronous I/O engine
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, Jul 17, 2015 at 5:58 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 07/17/2015 08:53 AM, Andrey Kuzmin wrote:
>>
>>
>> On Jul 17, 2015 5:36 PM, "Jens Axboe" <axboe@kernel.dk
>> <mailto:axboe@kernel.dk>> wrote:
>>  >
>>  > On 07/17/2015 08:30 AM, Andrey Kuzmin wrote:
>>  >>
>>  >> Probably worth adding to do_verify() as well.
>>  >
>>  >
>>  > Might be better to ensure that they are reaped when we break out of
>> the loop instead?
>>  >
>>
>> That's exactly what happens with the patch, doesn't it?
>
>
> It might be... It's not very clear why a !td->cur_depth should force us to
> stay in the loop?

Because to me breaking out of the loop on time- or size-based limit
exceeded condition with a non-zero td->cur_depth means loosing
completions.

Regards,
Andrey

>
> So lets back this up a bit. What problems were observed? Test case?
>
> --
> Jens Axboe
>

