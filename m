Return-Path: <axboe@kernel.dk>
Subject: Re: relationship of fio versus gfio
References: <6266593.Pst2hzQaXB@merkaba>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <564117A0.1070900@kernel.dk>
Date: Mon, 9 Nov 2015 15:01:04 -0700
MIME-Version: 1.0
In-Reply-To: <6266593.Pst2hzQaXB@merkaba>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Martin Steigerwald <ms@teamix.de>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 11/06/2015 01:54 AM, Martin Steigerwald wrote:
> Hello Jens, hello fio community.
>
> During package review of my new fio package my reviewer raised the question of
> the relationship between gfio and fio. I already also wondered about it
> before.
>
> Can gfio be used on a system, without fio installed? My guess would be yes: As
> fio could be running on another machine as a server.

That is correct.

> Also currently I have it that gfio is linked against the same libraries as
> fio. Is a complete fio engine included in gfio?

There was a plan to more cleanly separate them, as the client frontends 
need not link with all the nitty gritty details as the backend. But the 
amount of effort required to get that cleaner meant that it didn't 
really happen. It's not difficult, it's just a lot of manual work in 
establishing the code boundaries between the two.

-- 
Jens Axboe


