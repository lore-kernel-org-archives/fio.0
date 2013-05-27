Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43637 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab3E0NeB (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 27 May 2013 09:34:01 -0400
Date: Mon, 27 May 2013 15:33:32 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Any Delay Introduced by FIO between submission of Two IOs?
Message-ID: <20130527133332.GH29680@kernel.dk>
References: <CAJqT0ix50Pr0+DEVVStAZxiAa6Xx=SGRwQQX9QXa0Jdu13HG2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJqT0ix50Pr0+DEVVStAZxiAa6Xx=SGRwQQX9QXa0Jdu13HG2A@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: sampath rapaka <sampath.rapaka@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Mon, May 27 2013, sampath rapaka wrote:
> hi
> 
> i have run couple of fio runs. i am running this over raid1 device. i
> have captured blktrace for each run. I was going through the
> blktraces. what i have observed is there instances where there is
> commit happening to disk at say time stamp X. I was expecting a new IO
> to be submitted at X+1 time stamp. but i see next IO is submitted at
> time stamp Y.
> 
> Y-X is more than 1. Is there any delay introduced from FIO between two
> fios. or what could be the probable reasons to see such delay? let me
> know if my understanding is wrong.
> 
> Below is the excerpt from blktrace:
> 
> 21378   8,32   3     9162     0.116015463     0  C  WS 574576152 + 8 [0]
>  21379   8,16   3    10690     0.116020386     0  C  WS 574576152 + 8 [0]
>  21380   9,0    0        1     0.120074779  8797  Q  WS 131300520 + 8 [fitness]
> 
> from lines 21379(C) to 21380(Q) there is lots of delay for submission of new IO.
> 
> So i was thinking in lines of any delay from FIO between submissions
> of IO or they submit IO as soon as it is available.
> 
> Question 2:
> I have also observed larger delays in Q-D values. which is more than D-C value.
> 
> What could be the possible reasons for this behavior ?

Fio doesn't introduce any delays on purpose. What job file are you
running?

It could either be that fio is scheduled out or in other ways in a
non-running state. Or perhaps fio is waiting for completions.

Line 21380 above is something called 'fitness', what is that?

-- 
Jens Axboe

