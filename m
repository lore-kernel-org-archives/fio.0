Return-Path: <axboe@kernel.dk>
Message-ID: <5547D99E.4080103@kernel.dk>
Date: Mon, 04 May 2015 14:42:06 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [Bug report] Runtime, IOPS, bandwidth recorded incorrectly if
 small size with time_based
References: <CAFFT=UmoooCznxAkUREsC5rGN-hxD++PYbL94s-m11jdycDM0w@mail.gmail.com>
In-Reply-To: <CAFFT=UmoooCznxAkUREsC5rGN-hxD++PYbL94s-m11jdycDM0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Akash Verma <akashv@google.com>, fio <fio@vger.kernel.org>
Cc: Brian Fulton <bfulton@google.com>
List-ID: <fio@vger.kernel.org>

On 04/24/2015 04:50 PM, Akash Verma wrote:
> If there's a load with a very small size, but forced to repeat using
> time_based, the runtime reported at the end, as well as IOPS,
> bandwidth are wrong.
>
> E.g. using this control file:
>
> [short_and_suite]
> rw=randread
> bs=128k
> size=128k
> ioengine=libaio
> time_based=1
> runtime=1
> filename=datafile.tmp
>
> (where datafile.tmp already exists, for a more dramatic demonstration)
> The results I'm seeing on a hard drive are:
> read : io=304128KB, bw=24750MB/s, iops=198000, runt=    12msec
>
> This is a regression from FIO 2.0.5, which gives the following results:
> read : io=242176KB, bw=242418KB/s, iops=1893 , runt=   999msec
>
> which is much more reasonable.

Looks like a shorter run, try runtime=1s. And that makes me wonder if 
the default conversion is buggy. What version are you comparing 2.0.5 to?

-- 
Jens Axboe


