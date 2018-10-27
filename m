Return-Path: <axboe@kernel.dk>
Subject: Re:
References: <CAFF4W0V0VTMUbtZHOziTp6ca_khY2yHEPRQNAe68ebmTg9BO6w@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <af440868-bf5a-4973-292f-42bd099670ba@kernel.dk>
Date: Sat, 27 Oct 2018 10:55:59 -0600
MIME-Version: 1.0
In-Reply-To: <CAFF4W0V0VTMUbtZHOziTp6ca_khY2yHEPRQNAe68ebmTg9BO6w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Mohanraj B <bmohanraj91@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 10/26/18 6:54 AM, Mohanraj B wrote:
> Hello,
> 
> I am trying to check how option --clocksource works.
> 
> 
> bash# fio --name job1 --size 10m --clocksource 2
>         valid values: gettimeofday Use gettimeofday(2) for timing
>                     : clock_gettime Use clock_gettime(2) for timing
>                     : cpu        Use CPU private clock
> 
> fio: failed parsing clocksource=2
> 
> bash# fio --name job1 --size 10m --clocksource gettimeofday(2)
> bash: syntax error near unexpected token `('
> 
> Below command works fine.
> bash# fio --name job1 --size 10m --clocksource gettimeofday
> 
> It runs without error but quiet not sure how to see the effect of this
> option. also tried other options - clock_gettime, cpu gettimeofday and
> dont see any difference.
> 
> Also is there any error in documentation passing gettimeofday(2)
> throws parse error.

The format is 'value' 'help', so you'd want to do:

--clocksource=gettimeofday

for instance.

-- 
Jens Axboe


