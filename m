Return-Path: <axboe@kernel.dk>
Subject: Re: fio newer than 2.2.12 segfaults on examples/tiobench-example.fio
References: <569B9F48.3010808@cran.org.uk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <569D5FB4.6050602@kernel.dk>
Date: Mon, 18 Jan 2016 14:57:08 -0700
MIME-Version: 1.0
In-Reply-To: <569B9F48.3010808@cran.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 01/17/2016 07:03 AM, Bruce Cran wrote:
> I'm seeing a crash when running anything newer than 2.2.12 (I've tried
> 2.2.13 and 2.3) on my openSUSE Tumbleweed system: "./fio
> examples/tiobench-example.fio" causes a segfault in pthreads (apparently
> via fio_mutex_down).

Can you compile with with --disable-optimizations passed to configure, 
ensure that a core file is dumped (ulimit -c1000000000000 or whatever), 
and then run gdb ./fio core to show a full backtrace?

I can't reproduce the crash with 2.3 or current -git, runs fine for me.

-- 
Jens Axboe


