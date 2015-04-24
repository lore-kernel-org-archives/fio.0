Return-Path: <mansoor.shafaei@gmail.com>
MIME-Version: 1.0
In-Reply-To: <553A7356.9080303@kernel.dk>
References: <CAGGT8x4wvSkDni2+T8mViRCQHQiVt9C1AwMTaU8rk4rvNRaK4A@mail.gmail.com>
	<553A7356.9080303@kernel.dk>
Date: Fri, 24 Apr 2015 13:10:20 -0400
Message-ID: <CAGGT8x6QUt9kn51vpDFn8RdZxn-oJosW1OJ6daZQzUorymRXmA@mail.gmail.com>
Subject: Re: A probable minor mistake in HOWTO page
From: Mansour Shafaei Moghaddam <mansoor.shafaei@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

But I still think that the time is not relative to anything except the
beginning of the job i.e., 0:00:00. I again tried running the
following trace:

io version 2 iolog
/dev/sde add
/dev/sde open
/dev/sde read 1499999997952 16384
/dev/sde read 4499992682496 16384
/dev/sde read 4499992682496 16384
/dev/sde wait 3000 16384
/dev/sde read 4499992682496 16384
/dev/sde read 4499992682496 16384
/dev/sde read 4499992682496 16384
/dev/sde wait 5000 16384
/dev/sde read 1499999997952 16384
/dev/sde read 4499993485312 16384
/dev/sde read 4499993485312 16384
/dev/sde read 4499993485312 16384
/dev/sde read 4499993485312 16384
/dev/sde read 4499993485312 16384
/dev/sde close

with the job file shown below:


[global]
log_offset=1
direct=1
ioengine=sync
[read-phase]
write_lat_log=test
read_iolog=testtrace

Here is what I see in the clat file:


22, 22165, 0, 16384, 1499999997952
48, 25752, 0, 16384, 4499992682496
58, 10044, 0, 16384, 4499992682496
2907, 8123, 0, 16384, 4499992682496
2917, 10077, 0, 16384, 4499992682496
2927, 10002, 0, 16384, 4499992682496
4918, 18610, 0, 16384, 1499999997952
4942, 24021, 0, 16384, 4499993485312
4952, 10018, 0, 16384, 4499993485312
4962, 10017, 0, 16384, 4499993485312
4972, 10030, 0, 16384, 4499993485312
4982, 10029, 0, 16384, 4499993485312

As you can see submission times are like
(22,....,2907,.....,4918,...). So the given value as offset is being
interpreted as absolute delay. In other words it is the time stamp for
the IO right after that. If it is less than the current time of the
job it will be ignored. Otherwise, it will be applied.


On Fri, Apr 24, 2015 at 12:46 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 04/07/2015 11:23 AM, Mansour Shafaei Moghaddam wrote:
>>
>> Hi,
>>
>> I found a minor mistake in the Fio's HOWTO page. According to this
>> document the "wait" command considers the offset as the number of
>> milliseconds which it must hold on before submitting the next I/O. A
>> very simple experiment with a short trace including those "wait"
>> commands shows that the numbers that you put as offset are interpreted
>> as the time for submission of next I/O not the amount of wait time
>> between them. In other words, the value in offset field is the
>> absolute delay from the beginning of run not the relative delay.
>>
>> P.S.: The version of fio I have been working on is 2.1.11, but I saw
>> the same explanation in more recent versions' HOWTO page as well. So,
>> decided to share it with you.
>
>
> Thanks, updated. It is indeed a relative time.
>
> --
> Jens Axboe
>

