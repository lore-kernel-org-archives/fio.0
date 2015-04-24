Return-Path: <axboe@kernel.dk>
Message-ID: <553A7A74.6020306@kernel.dk>
Date: Fri, 24 Apr 2015 11:16:36 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: A probable minor mistake in HOWTO page
References: <CAGGT8x4wvSkDni2+T8mViRCQHQiVt9C1AwMTaU8rk4rvNRaK4A@mail.gmail.com>	<553A7356.9080303@kernel.dk> <CAGGT8x6QUt9kn51vpDFn8RdZxn-oJosW1OJ6daZQzUorymRXmA@mail.gmail.com>
In-Reply-To: <CAGGT8x6QUt9kn51vpDFn8RdZxn-oJosW1OJ6daZQzUorymRXmA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Mansour Shafaei Moghaddam <mansoor.shafaei@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/24/2015 11:10 AM, Mansour Shafaei Moghaddam wrote:
> But I still think that the time is not relative to anything except the
> beginning of the job i.e., 0:00:00. I again tried running the
> following trace:
>
> io version 2 iolog
> /dev/sde add
> /dev/sde open
> /dev/sde read 1499999997952 16384
> /dev/sde read 4499992682496 16384
> /dev/sde read 4499992682496 16384
> /dev/sde wait 3000 16384
> /dev/sde read 4499992682496 16384
> /dev/sde read 4499992682496 16384
> /dev/sde read 4499992682496 16384
> /dev/sde wait 5000 16384
> /dev/sde read 1499999997952 16384
> /dev/sde read 4499993485312 16384
> /dev/sde read 4499993485312 16384
> /dev/sde read 4499993485312 16384
> /dev/sde read 4499993485312 16384
> /dev/sde read 4499993485312 16384
> /dev/sde close
>
> with the job file shown below:
>
>
> [global]
> log_offset=1
> direct=1
> ioengine=sync
> [read-phase]
> write_lat_log=test
> read_iolog=testtrace
>
> Here is what I see in the clat file:
>
>
> 22, 22165, 0, 16384, 1499999997952
> 48, 25752, 0, 16384, 4499992682496
> 58, 10044, 0, 16384, 4499992682496
> 2907, 8123, 0, 16384, 4499992682496
> 2917, 10077, 0, 16384, 4499992682496
> 2927, 10002, 0, 16384, 4499992682496
> 4918, 18610, 0, 16384, 1499999997952
> 4942, 24021, 0, 16384, 4499993485312
> 4952, 10018, 0, 16384, 4499993485312
> 4962, 10017, 0, 16384, 4499993485312
> 4972, 10030, 0, 16384, 4499993485312
> 4982, 10029, 0, 16384, 4499993485312
>
> As you can see submission times are like
> (22,....,2907,.....,4918,...). So the given value as offset is being
> interpreted as absolute delay. In other words it is the time stamp for
> the IO right after that. If it is less than the current time of the
> job it will be ignored. Otherwise, it will be applied.

Yeah, I was too quick, looking at the code, on reading the log, we store 
offset in delay directly:

if (rw == DDIR_WAIT) {
         ipo->delay = offset;
} else {

and on retrieval, we factor in the 'td' time offset as an absolute delay.

-- 
Jens Axboe


