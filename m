Return-Path: <axboe@kernel.dk>
Message-ID: <55A91826.8080407@kernel.dk>
Date: Fri, 17 Jul 2015 08:58:46 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: PATCH: Don't lose pending completions on exit in time- or size-based
 job with asynchronous I/O engine
References: <CANvN+ekBVCAMge-A9dMTeOnXSJ7sZ9OdQ_ZMeqgcTsoa8J0bJg@mail.gmail.com>	<55A912DB.8030306@kernel.dk> <CANvN+en4p0q4Ff4n9KBLku5O67Cs68VUpp0qHK+ye2Cu4YbcJw@mail.gmail.com>
In-Reply-To: <CANvN+en4p0q4Ff4n9KBLku5O67Cs68VUpp0qHK+ye2Cu4YbcJw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 07/17/2015 08:53 AM, Andrey Kuzmin wrote:
>
> On Jul 17, 2015 5:36 PM, "Jens Axboe" <axboe@kernel.dk
> <mailto:axboe@kernel.dk>> wrote:
>  >
>  > On 07/17/2015 08:30 AM, Andrey Kuzmin wrote:
>  >>
>  >> Probably worth adding to do_verify() as well.
>  >
>  >
>  > Might be better to ensure that they are reaped when we break out of
> the loop instead?
>  >
>
> That's exactly what happens with the patch, doesn't it?

It might be... It's not very clear why a !td->cur_depth should force us 
to stay in the loop?

So lets back this up a bit. What problems were observed? Test case?

-- 
Jens Axboe


