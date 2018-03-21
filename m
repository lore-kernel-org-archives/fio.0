Return-Path: <axboe@kernel.dk>
Subject: Re: Proper way to shut down FIO in Linux
References: <8d5a5fe209774d24b9df39cf6a226dbb@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <bb2e6c2d-032d-6a8f-1313-9e255af621ef@kernel.dk>
Date: Wed, 21 Mar 2018 08:36:31 -0600
MIME-Version: 1.0
In-Reply-To: <8d5a5fe209774d24b9df39cf6a226dbb@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Matt Freel <matt.freel@broadcom.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 3/13/18 12:56 PM, Matt Freel wrote:
> I'm using FIO to run IOs to a number of block devices.  I'm looking for
> the proper way to shut down all the threads that are spawned.
> 
> I'm doing the following:
> 
> /usr/bin/pkill --signal INT fio
> 
> Most of the time this works fine, but I do have cases where some of the
> FIO processes remain open.  Eventually I get a 300s timeout and then
> they're killed.
> 
> A couple questions:
> 
> 1.	When these threads have to be ungracefully killed, do the results
> still get counted in the output file?
> a.	I'm using JSON output file
> 2.	Is there a better way I should be killing all the threads?

You want to SIGINT the main process, not all the jobs that are running.
If you do that, you would get the same behavior as when you ctrl-c
a running job. The way you are doing it, you are randomly killing
job processes. You want to let the main thread shut things down
instead.

-- 
Jens Axboe


