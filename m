Return-Path: <michael.mattsson@gmail.com>
MIME-Version: 1.0
In-Reply-To: <54491C12.3020205@kernel.dk>
References: <CAE56cDu7ctJfTLbFRUGh+VwyHdJ=_rtLYLL_b-kJ=YmeeGaopA@mail.gmail.com>
 <5447D0F5.7090403@kernel.dk> <CAE56cDsm7-FnX2wwhmryrf-6__ZppK353nvUuXpY-96mTkeHrA@mail.gmail.com>
 <CALjAwxh-McXiYRid+e0RDW3SxCwGDfLdUeOmvLVpzXPi20auNw@mail.gmail.com>
 <CAE56cDsQVo2gZRX7n3Y4Ny+=2N2mN9upAL4QtH_yrt0TgwYCDA@mail.gmail.com> <54491C12.3020205@kernel.dk>
From: Michael Mattsson <michael.mattsson@gmail.com>
Date: Thu, 23 Oct 2014 14:54:27 -0700
Message-ID: <CAE56cDuuJFyjampbAK7bYWqzSyFmDOqC1amndMu8QBS+dG13vw@mail.gmail.com>
Subject: Re: --status-interval output race
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Tried the latest git. No change. However, offsetting the runtime to
not be an even multiple of the status interval alleviated the symptoms
somewhat but not entirely. I got 7 successful runs out of 10 by
offsetting. (Interval 5 and runtime 62).

Regards
Michael

On Thu, Oct 23, 2014 at 8:17 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 10/22/2014 12:19 PM, Michael Mattsson wrote:
>> I reran with 2.1.4 and had the same results. 1 in 10 reported successfully.
>
> Can you try current -git? I added some code to properly shutdown status
> interval dumps before we finalize everything. It's a cleanup in any
> case, but would be nice to know if it impacts your situation.
>
> --
> Jens Axboe
>

