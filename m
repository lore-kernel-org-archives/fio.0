Return-Path: <axboe@kernel.dk>
Subject: Re: Increasing startup time
References: <CAF+0mvkVOvpqUHRLO_mBXt7UFMFYJMQWH0Au1wssZHa5V=THVA@mail.gmail.com>
 <20151108002911.GB9335@kernel.dk> <20151108003448.GD9335@kernel.dk>
 <CAF+0mvmqHG+eu_dV=SPE-GX9-+jeX4FtecJ0RbksV9-8OniS2Q@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5640DA7C.5020704@kernel.dk>
Date: Mon, 9 Nov 2015 10:40:12 -0700
MIME-Version: 1.0
In-Reply-To: <CAF+0mvmqHG+eu_dV=SPE-GX9-+jeX4FtecJ0RbksV9-8OniS2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 11/09/2015 10:33 AM, Matthew Eaton wrote:
>> Committed, with a fixup to still clear the actual bitmap. Should work
>> faster for you than even the earlier versions you tested.
>
>
> Thank you for looking at this Jens!  You are correct, startup times
> are even faster now.

Great, thanks for (re)testing.

-- 
Jens Axboe


