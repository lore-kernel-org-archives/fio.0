Return-Path: <m.eaton82@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20151108003448.GD9335@kernel.dk>
References: <CAF+0mvkVOvpqUHRLO_mBXt7UFMFYJMQWH0Au1wssZHa5V=THVA@mail.gmail.com>
	<20151108002911.GB9335@kernel.dk>
	<20151108003448.GD9335@kernel.dk>
Date: Mon, 9 Nov 2015 09:33:37 -0800
Message-ID: <CAF+0mvmqHG+eu_dV=SPE-GX9-+jeX4FtecJ0RbksV9-8OniS2Q@mail.gmail.com>
Subject: Re: Increasing startup time
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> Committed, with a fixup to still clear the actual bitmap. Should work
> faster for you than even the earlier versions you tested.


Thank you for looking at this Jens!  You are correct, startup times
are even faster now.

matt@matt-work:~$ time fio -v
fio-2.1.14

real    0m0.008s
user    0m0.000s
sys    0m0.004s
matt@matt-work:~$ time fio -v
fio-2.1.14

real    0m0.008s
user    0m0.004s
sys    0m0.000s
matt@matt-work:~$ time fio -v
fio-2.1.14

real    0m0.008s
user    0m0.000s
sys    0m0.004s
matt@matt-work:~$ time fio/fio -v
fio-2.2.11-3-g9c3e

real    0m0.003s
user    0m0.000s
sys    0m0.000s
matt@matt-work:~$ time fio/fio -v
fio-2.2.11-3-g9c3e

real    0m0.003s
user    0m0.000s
sys    0m0.000s
matt@matt-work:~$ time fio/fio -v
fio-2.2.11-3-g9c3e

real    0m0.003s
user    0m0.004s
sys    0m0.000s

