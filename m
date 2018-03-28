Return-Path: <axboe@kernel.dk>
Subject: Re: Windows fio build processor group support testing
References: <CALjAwxgErjdsMQ60SOgoAdfTCvdTh_TwKY2DhgcV0OeOA36FjQ@mail.gmail.com>
 <a1022d126a861770281f3003eed29b477666c496.camel@wdc.com>
 <CALjAwxhnGDcqVsq43ZyeH_Scb+bepT5gBKd0X151WTwNj85v4A@mail.gmail.com>
 <fc4d3aa0993980efbb9bbe5bf83c42d507e9f2a2.camel@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <ee74a245-dc9f-28a6-9b15-1fbcc7ac734a@kernel.dk>
Date: Wed, 28 Mar 2018 09:08:03 -0600
MIME-Version: 1.0
In-Reply-To: <fc4d3aa0993980efbb9bbe5bf83c42d507e9f2a2.camel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "sitsofe@gmail.com" <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "rebecca@bluestop.org" <rebecca@bluestop.org>, "elliott@hpe.com" <elliott@hpe.com>
List-ID: <fio@vger.kernel.org>

On 3/28/18 8:20 AM, Bart Van Assche wrote:
> On Wed, 2018-03-28 at 11:48 +0100, Sitsofe Wheeler wrote:
>> I'll note that Jens suggested we could use build time configuration in
>> https://github.com/axboe/fio/issues/527#issuecomment-363804643 . With
>> runtime lookup it becomes tricky to test the legacy paths on new
>> systems because you can no longer force them to be taken (I don't have
>> access to a Windows before 2012 R2 myself).
> 
> Let's follow what Jens proposed. But I do not agree that my proposal would
> make it tricky to test the legacy paths. One possible approach would be to
> add a command-line option that forces the legacy paths to be taken.

I think I've done one overhaul of the cpu mask mechanism, to make it more
cross platform friendly. And that was many years ago. So I don't expect
a lot of churn in this area, which should mean that the legacy code can
remain mostly untouched going forward.

If, at some later point in time that changes, then I'm fine with ditching
the old Windows processor group code if we have no way of verifying
whether it still works or not.

Hence I think that Sitsofe's approach is fine - default to the code that
works well on newer Windows and supports > 32 CPUs. That's a basic
system these days, and what most people would run on.

-- 
Jens Axboe


