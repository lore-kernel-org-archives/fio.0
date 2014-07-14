Return-Path: <axboe@kernel.dk>
Message-ID: <53C3D70B.8060005@kernel.dk>
Date: Mon, 14 Jul 2014 15:11:39 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Generate Terse Output at specific time interval
References: <9E26C6259ACF1842A4815F929194EDD394B5AC14@phex01.corp.bitmicro.com> <CAFTzLMNa1XQXKnn+L+r25P1yiZawNPyYU51cij=Hk1w521bK5A@mail.gmail.com>
In-Reply-To: <CAFTzLMNa1XQXKnn+L+r25P1yiZawNPyYU51cij=Hk1w521bK5A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Vasily Tarasov <tarasov@vasily.name>, Ritchie Babaylan <Ritchie.Babaylan@bitmicro.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-07-14 15:03, Vasily Tarasov wrote:
> Ritchie,
>
> You can use
>
>   --status-interval <interval_in_seconds>
>
> switch to achieve what you want. One thing to notice, is that fio will
> print aggregated statistics from the very beginning of the run, but
> not the instantaneous statistics for the last 10 seconds.
>
> Instanteneous statistics can be recalculated from the aggregated one,
> but it would be really nice to have an ability in fio to print
> instantaneous performance numbers by its own...

That would be easy enough to do, just have it print stats since last 
time it was invoked. The harder part was doing it the way it is done 
now, but I do see merit in allowing "since last time" status updates as 
well.

-- 
Jens Axboe


