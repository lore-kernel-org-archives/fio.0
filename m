Return-Path: <matt.freel@broadcom.com>
From: Matt Freel <matt.freel@broadcom.com>
References: <8d5a5fe209774d24b9df39cf6a226dbb@mail.gmail.com> <bb2e6c2d-032d-6a8f-1313-9e255af621ef@kernel.dk>
In-Reply-To: <bb2e6c2d-032d-6a8f-1313-9e255af621ef@kernel.dk>
MIME-Version: 1.0
Date: Wed, 21 Mar 2018 08:39:44 -0600
Message-ID: <5c04f55f59338786b9fa5be6f530c64b@mail.gmail.com>
Subject: RE: Proper way to shut down FIO in Linux
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Thanks.  Making that change makes things work correctly.  There was some
confusion on my part with Python because I wasn't getting the PID of the FIO
process.  Once I figured out why it's working sending sigint to the main
process.

-----Original Message-----
From: Jens Axboe <axboe@kernel.dk>
Sent: Wednesday, March 21, 2018 8:37 AM
To: Matt Freel <matt.freel@broadcom.com>; fio@vger.kernel.org
Subject: Re: Proper way to shut down FIO in Linux

On 3/13/18 12:56 PM, Matt Freel wrote:
> I'm using FIO to run IOs to a number of block devices.  I'm looking
> for the proper way to shut down all the threads that are spawned.
>
> I'm doing the following:
>
> /usr/bin/pkill --signal INT fio
>
> Most of the time this works fine, but I do have cases where some of
> the FIO processes remain open.  Eventually I get a 300s timeout and
> then they're killed.
>
> A couple questions:
>
> 1.	When these threads have to be ungracefully killed, do the results
> still get counted in the output file?
> a.	I'm using JSON output file
> 2.	Is there a better way I should be killing all the threads?

You want to SIGINT the main process, not all the jobs that are running.
If you do that, you would get the same behavior as when you ctrl-c a running
job. The way you are doing it, you are randomly killing job processes. You
want to let the main thread shut things down instead.

--
Jens Axboe

