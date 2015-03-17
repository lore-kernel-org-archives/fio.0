Return-Path: <axboe@kernel.dk>
Message-ID: <55085347.5060702@kernel.dk>
Date: Tue, 17 Mar 2015 10:16:07 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: REPORT: High CPU utilization since 2.2.5
References: <D10CFEF2.19AB0%andrey.o.kudryavtsev@intel.com> <CALjAwxgWEZFHZNgpZvHgak4-bfQQqE9A9Gtu_e2JGcQ_xaovQA@mail.gmail.com> <D1235F6C.1BF40%andrey.o.kudryavtsev@intel.com>
In-Reply-To: <D1235F6C.1BF40%andrey.o.kudryavtsev@intel.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
To: "Kudryavtsev, Andrey O" <andrey.o.kudryavtsev@intel.com>, Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/09/2015 04:07 PM, Kudryavtsev, Andrey O wrote:
> Thank you for the advise,
> Utilization is coming from fio threads, reported I/O is similar to iostat.
> Disabling all latency reporting works and returns the CPU utilization back
> to normal. Unfortunately this workaround doesn’t work for me, I’m using
> latency monitoring a lot for my tests.
>
> I did some more research,
> 	With latency reporting enabled I’m getеing 350k IOPS instead of 450k.
> 	With gdot_disable=1 back to normal 450k
> 	With disable_slat=1 only it gets 420k
> 	disable_clat=1 doesn’t make any difference and the performace is still
> low 350k.
>
> Please, advise.

Please run a git bisect, as suggested. This will help pinpoint what 
commit made it worse for you. Should be pretty easy to do, since you can 
reproduce quickly and easily. You mentioned that 2.1.14 works, and that 
2.2.5 is broken. So do:

$ git bisect start
$ git bisect good fio-2.1.14
$ git bisect bad fio-2.2.5

Now for each iteration, do:

$ make clean && make -j20
$ ./fio <jobfile>

if the result is slow, do:

$ git bisect bad

and if the result is fast, do:

$ git bisect good

Then go back to the make clean && make and rerun your test case. Repeat 
this until you've bisected your way to the problematic commit, git will 
tell you when it's done.

-- 
Jens Axboe


