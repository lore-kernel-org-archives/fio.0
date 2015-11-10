Return-Path: <axboe@kernel.dk>
Subject: Re: relationship of fio versus gfio
References: <6266593.Pst2hzQaXB@merkaba> <564117A0.1070900@kernel.dk>
 <2367452.mALFllXUSD@merkaba>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56420B4C.2040708@kernel.dk>
Date: Tue, 10 Nov 2015 08:20:44 -0700
MIME-Version: 1.0
In-Reply-To: <2367452.mALFllXUSD@merkaba>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Martin Steigerwald <ms@teamix.de>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 11/10/2015 03:25 AM, Martin Steigerwald wrote:
> Am Montag, 9. November 2015, 15:01:04 CET schrieb Jens Axboe:
>> On 11/06/2015 01:54 AM, Martin Steigerwald wrote:
>>> Hello Jens, hello fio community.
>>>
>>> During package review of my new fio package my reviewer raised the
>>> question of the relationship between gfio and fio. I already also
>>> wondered about it before.
>>>
>>> Can gfio be used on a system, without fio installed? My guess would be
>>> yes: As fio could be running on another machine as a server.
>>
>> That is correct.
>
> Thanks. My sponsor Sven just uploaded the debian package to unstable.
>
>>
>>> Also currently I have it that gfio is linked against the same libraries as
>>> fio. Is a complete fio engine included in gfio?
>>
>> There was a plan to more cleanly separate them, as the client frontends
>> need not link with all the nitty gritty details as the backend. But the
>> amount of effort required to get that cleaner meant that it didn't
>> really happen. It's not difficult, it's just a lot of manual work in
>> establishing the code boundaries between the two.
>
> I see.
>
> I also wondered about doing some Qt Quick based frontend for fio, but never
> got along starting it. Also it would be redoing work that is already done
> (gfio).

That'd be great, though. gtk isn't very portable, one of the goals of 
the gui frontend was to have something that people on OSX/Windows could 
also use without having to resort to a command line.

-- 
Jens Axboe


