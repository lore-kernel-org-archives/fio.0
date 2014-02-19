Return-Path: <axboe@kernel.dk>
Date: Wed, 19 Feb 2014 10:46:36 -0800
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch 0/9] Collection of various fio fixes and extensions
Message-ID: <20140219184636.GJ25515@kernel.dk>
References: <5304C9D3.4070301@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5304C9D3.4070301@linux.vnet.ibm.com>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: fio@vger.kernel.org, oberpar@linux.vnet.ibm.com
List-ID: <fio@vger.kernel.org>

On Wed, Feb 19 2014, Christian Ehrhardt wrote:
> As it is usually we needed a few little extensions to support the old use
> cases we wanted to migrate to the new benchmark. Also we found a few issues
> in the fio code that we had to fix.
> 
> All that happened a long time back and we always wanted to cotribute our
> changes to the project which after a loooong legal process now is finally
> possible. To make things worse the code was affected by some bit rot due
> to that legal waiting time which in turn stalled me making it ready for
> submission again.

Curious, what was the legal holdup? Fio being a new project to
contribute to, or just getting it out in general. If there's anything I
can do to make this easier in the future, let me know.

> I'm happy that I finally found some time to update the patches to match to
> the current fio git. It passed my 18 test cases which are based on the
> examples delivered with fio new for the new functionality added.
> 
> Looking forward to your review,
> Christian
> 
> The patch series includes:
> [patch 1/9] fio: fix job clone mem leak
> [patch 2/9] fio: allow general repeatability
> [patch 3/9] fio: allow milliseconds on all time specifiers
> [patch 4/9] fio: provide an option for a startdelay range
> [patch 5/9] fio: add multi directory support
> [patch 6/9] fio: allow combined output (default and terse)
> [patch 7/9] fio: flush log files on test end
> [patch 8/9] fio: fix last block never being touched by random offsets
> [patch 9/9] fio: allow 0 as compress percentage

Most of these can be applied directly. I need to double check 8/9, but
apart from that, all looks like they can be directly applied.

They seem to be mangled a bit, however, there's line wrapping going on.
Would it be possible to resend with that fixed?

-- 
Jens Axboe


