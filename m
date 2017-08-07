Return-Path: <axboe@kernel.dk>
Subject: Re: Pending fio 3.0 release
References: <2bbf3bdf-e11b-2f58-a222-1e284b7d0cee@kernel.dk>
 <CALjAwxizNpBTAWLR4eTixM0QfgLrkvEEJzWmi_88_k_KKp5dUg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <336d0c1b-2382-1037-2eac-e34b78242340@kernel.dk>
Date: Mon, 7 Aug 2017 13:46:46 -0600
MIME-Version: 1.0
In-Reply-To: <CALjAwxizNpBTAWLR4eTixM0QfgLrkvEEJzWmi_88_k_KKp5dUg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Rebecca Cran <rebecca@bluestop.org>, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 08/07/2017 01:05 PM, Sitsofe Wheeler wrote:
> Hi Jens,
> 
> On 7 August 2017 at 17:10, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> CC'ing a few key people here - I want to release fio 3.0 shortly, which
>> is why the last released jumped to 2.99. However, before doing so, I'd
>> like to ensure that we are uptodate on platforms. Rebecca, is Windows
>> currently building fine with current -git? I suspect it is, but would be
>> nice to know for sure.
>>
>> Any other important pending fixes that should go in before 3.0 is
>> released?
> 
> There are a few pull requests queued up over on
> https://github.com/axboe/fio/pulls (json+ patches, inflight overlap
> use after free fix, C++ ioengine changes, serialise overlap changes,
> sheepdog ioengine, change some output to debugging only etc.).

Just pulled that in, it's fine now that the more controversial bits
are out.

> Locally, I have an experimental libiscsi ioengine, support for
> verify_state when verifying a readwrite workload, some HOWTO
> reordering to improve the man page conversion and some initial
> investigations into invalidation on Windows. The only one I'd have
> loved to see go in is the libiscsi engine but it's kinda raw and needs
> fixing up and I don't know when I'll have time to finish it...

For new engines, I don't mind merging them early, as long as the people
behind them are motivated to bring them up to snuff. Up to you.

verify_state support for read/write sounds like something that would be
nice to have, but isn't a must for 3.0.

Anyway, I'll likely cut 3.0 next week, so there's still time for
whatever changes we need. But they have to be low risk at this point,
I'd hate to do a 3.0 that broke anything recent.

> With regard to Windows, it seems to at least be building
> (https://ci.appveyor.com/project/axboe/fio/build/1.0.245 ) and running
> basic workloads for me...

Ah yes, thanks!

-- 
Jens Axboe


