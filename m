Return-Path: <axboe@kernel.dk>
Message-ID: <5408797F.3070803@kernel.dk>
Date: Thu, 04 Sep 2014 08:38:55 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] fio: fix hangs due to iodepth_low
References: <20140904002343.24650.74664.stgit@beardog.cce.hp.com> <5407C19C.1030202@kernel.dk> <5407C227.5060707@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958C4DCDC@G4W3202.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C4DCDC@G4W3202.americas.hpqcorp.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>
List-ID: <fio@vger.kernel.org>

On 09/04/2014 08:27 AM, Elliott, Robert (Server Storage) wrote:
>>> should be:
>>>
>>>      if (min_events > td->cur_depth)
>>>          min_events = td->cur_depth;
>>>
>>> and we should probably put this logic in io_u_queued_complete(), I
>> think
>>> that would be a safer alternative instead of near the callers.
> 
> io_u_quisce, which calls io_u_queued_complete with an argument 
> of 1, includes this comment:
>          * and cur_depth is meaningless for sync engines.
> 
> If that is invoked during sync traffic too, then putting this
> change inside io_u_queued_complete might not work right.

It's good enough for this use case. And it doesn't really matter if it's
near the caller or in the function from this point of view, since there
will be nothing (0) to complete for sync engines. By their very nature,
they have nothing pending at that point. So I think the patch is fine as
I sent out.

-- 
Jens Axboe


