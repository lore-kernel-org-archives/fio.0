Return-Path: <axboe@kernel.dk>
Message-ID: <53B1799B.4080002@kernel.dk>
Date: Mon, 30 Jun 2014 08:52:11 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: using fio client on 64-bit machine with fio server on 32-bit
 machine
References: <53AD168F.3070403@s3group.com> <53ADA00A.7010401@kernel.dk> <53ADDBF6.5020701@kernel.dk> <53B14574.7050900@s3group.com>
In-Reply-To: <53B14574.7050900@s3group.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Frank D'Arcy <frank.darcy@s3group.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 06/30/2014 05:09 AM, Frank D'Arcy wrote:
> 
> Hi Jens,
> thanks for getting back to me.
> I've rebuilt with the latest but I still see problems with the numbers.
> 
> I do see one improvement,
> the "% done" printed while the test is in progress now increases nicely
> from 0% to 100%
> whereas before it would jump around to seemingly random values between
> 0% to 100%
> 
> I wonder is it picking the wrong set of numbers to print in some cases.
> eg. from a test with 2 jobs that runs for 23 seconds I faound the
> following in normal output ...
> 
> when run standalone on a 32-bit VM I see this for a "rw=randread" job
>>   read : io=47106B, bw=2047B/s, iops=1023, runt= 23001msec
> whereas when the same test is run from  64-bit client to 32-bit server I
> see this for the same job
>>   trim: io=98789GB, bw=1000/s, iops=0, runt=98784247808000msec
> so it says "trim" where it should say "read"
> 
> and for the 2nd job which is "rw=write"
> when run standalone on a 32-bit VM I see this
>>   write: io=34502B, bw=1500B/s, iops=750, runt= 23001msec
> whereas when the same test is run from  64-bit client to 32-bit server I
> see this for the same job
>>   read : io=148185GB, bw=1500/s, iops=750, runt=98788542775296msec
> so it says "read" where it should say "write"
> 
> In the same test run, the following results are identical when run both
> ways ...
>>
>> Run status group 0 (all jobs):
>>    READ: io=46KB, aggrb=1KB/s, minb=1KB/s, maxb=1KB/s, mint=23001msec,
>> maxt=23001msec
>>   WRITE: io=33KB, aggrb=1KB/s, minb=1KB/s, maxb=1KB/s, mint=23001msec,
>> maxt=23001msec
> so these results look correct.
> 
> All the above problems are only seen when run from 64-bit client to
> 32-bit server,
> no problems seen when running standalone,
> and no problems seen when running 64-bit client to 64-bit server.

Try updating again. Not sure I caught all of them, so would be nice to
know how it works now.

-- 
Jens Axboe


