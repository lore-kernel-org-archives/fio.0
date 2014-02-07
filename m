Return-Path: <axboe@kernel.dk>
Message-ID: <52F505A8.30004@kernel.dk>
Date: Fri, 07 Feb 2014 09:11:20 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Mutex destruction, invalid memory accesses, leaks
References: <20140206192135.GB3950@kernel.dk> <20140207034439.GA17588@sucs.org>
In-Reply-To: <20140207034439.GA17588@sucs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-02-06 20:44, Sitsofe Wheeler wrote:
> On Thu, Feb 06, 2014 at 12:21:35PM -0700, Jens Axboe wrote:
>>
>> Similarly, if you know of bugs (particularly regressions from previous
>> releases), speak up now so we can get them fixed before 2.1.5 is cut.
>
> I think there is a problem with how mutexes are being destroyed and it's
> manifesting as a reproducible segfault in libwinpthread-1.dll on
> Windows. From
> http://thread.gmane.org/gmane.comp.storage.fio/97/focus=136 :
>
>> I've finally had time to reproduce this on a Windows 7 box. I use a
>> different command line:
>>
>> ./fio.exe --debug=all --filename=fiojob --thread --size=512 --rw=read --bs=512 --ioengine=sync --verify_pattern=0xdeadbeef --name=fiojobname
>>
>> The problem appears to be that the mutex is being destroyed while it
>> is still being held by a different thread. Adding return; to the first
>> line of fio_mutex_remove in mutex.c papers over the problem...
>
> This issue hasn't seen much interest since it was raised a few weeks ago
> and I haven't had time to come up with a proper fix but it looks similar
> to the issue described in https://lwn.net/Articles/575460/ (A surprise
> with mutexes and reference counts).

Does this still happen in current -git? The bug is a weird one - it 
looks like it's crashing in bringing up the thread, but the 
synchronization around that should ensure that it never gets to touch 
td->mutex. If the mutexes are broken somehow and the thread doesn't 
properly wait for the main thread to bring it up, then I can see it 
happening. Hence my question whether it's still happening after Bruce 
fixed the pthread linkage in current -git.

> Additionally Dr Memory is also flagging up an invalid memory access on
> the Windows version of fio (one is in a macro which makes a for loop but
> I only have a non-macro fix for it at the moment) and some memory leaks
> around string_to_cpu and init_io_u.

I'm going to need more info on the invalid mem access. Not surprised 
there are a few leaks around the init functions. Would be nice to get 
fixed up, but not a ship-stopper.

-- 
Jens Axboe


