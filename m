Return-Path: <axboe@kernel.dk>
Message-ID: <54EF8701.9020008@kernel.dk>
Date: Thu, 26 Feb 2015 13:50:09 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Stonewalled ?
References: <54EE9B5D.3040208@voicenet.com> <A7A1D348E34E024BBC74480FB93A2EAB10942DEB@DAGN05C-E6.exg6.exghost.com> <54EF31C0.9030502@voicenet.com>
In-Reply-To: <54EF31C0.9030502@voicenet.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: thoms@voicenet.com, Carl Zwanzig <cpz@coraid.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 02/26/2015 07:46 AM, thoms wrote:
> 
> On 02/26/2015 02:11 AM, Carl Zwanzig wrote:
>> (sorry about top-posting here)
>>
>> For things like this, I'd use an external script specifying all params on each command line, and not use a job file at all. Order of execution is guaranteed and there's no limit to the number of jobs. (When fio evaluates the job file it creates all the jobs, but then doesn't let them all start at once.)
>>
>> z!
>> ________
> 
> I'm prepared to do that, it's just messy for my particular situation. 
> Not having looked through the code, I was under the impression that
> "stonewall" changed the semantics of that behavior.  Understood...
> 
> Thanks for the insight.  Much appreciated...

The stonewall does do what you expect. The problem isn't related to how
many jobs are running at the same time, it's how many jobs have been
added. Basically it boils down to how big of an shm segment fio will
need to run.

You could always just bump REAL_MAX_JOBS in fio.h to something larger
than 2048, that should work on most platforms.

-- 
Jens Axboe


