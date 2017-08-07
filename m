Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <2bbf3bdf-e11b-2f58-a222-1e284b7d0cee@kernel.dk>
References: <2bbf3bdf-e11b-2f58-a222-1e284b7d0cee@kernel.dk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 7 Aug 2017 20:05:00 +0100
Message-ID: <CALjAwxizNpBTAWLR4eTixM0QfgLrkvEEJzWmi_88_k_KKp5dUg@mail.gmail.com>
Subject: Re: Pending fio 3.0 release
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Rebecca Cran <rebecca@bluestop.org>, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

Hi Jens,

On 7 August 2017 at 17:10, Jens Axboe <axboe@kernel.dk> wrote:
>
> CC'ing a few key people here - I want to release fio 3.0 shortly, which
> is why the last released jumped to 2.99. However, before doing so, I'd
> like to ensure that we are uptodate on platforms. Rebecca, is Windows
> currently building fine with current -git? I suspect it is, but would be
> nice to know for sure.
>
> Any other important pending fixes that should go in before 3.0 is
> released?

There are a few pull requests queued up over on
https://github.com/axboe/fio/pulls (json+ patches, inflight overlap
use after free fix, C++ ioengine changes, serialise overlap changes,
sheepdog ioengine, change some output to debugging only etc.).

Locally, I have an experimental libiscsi ioengine, support for
verify_state when verifying a readwrite workload, some HOWTO
reordering to improve the man page conversion and some initial
investigations into invalidation on Windows. The only one I'd have
loved to see go in is the libiscsi engine but it's kinda raw and needs
fixing up and I don't know when I'll have time to finish it...

With regard to Windows, it seems to at least be building
(https://ci.appveyor.com/project/axboe/fio/build/1.0.245 ) and running
basic workloads for me...

-- 
Sitsofe | http://sucs.org/~sits/

