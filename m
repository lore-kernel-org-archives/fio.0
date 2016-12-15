Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] fio: move _FORTIFY_SOURCE to only when optimization is
 turned on
References: <148183868856.125259.7337489521608029445.stgit@djiang5-desk3.ch.intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <86c49c64-9a75-466a-7e3e-805b18426ae1@kernel.dk>
Date: Thu, 15 Dec 2016 14:55:14 -0700
MIME-Version: 1.0
In-Reply-To: <148183868856.125259.7337489521608029445.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Dave Jiang <dave.jiang@intel.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 12/15/2016 02:51 PM, Dave Jiang wrote:
> When compile with debug, without the proper -O flag the compiler complains:
> /usr/include/features.h:331:4: warning: #warning _FORTIFY_SOURCE requires
> compiling with optimization (-O) [-Wcpp]
> #  warning _FORTIFY_SOURCE requires compiling with optimization (-O)
> Moving _FORTIFY_SOURCE to optimized compile option.

Applied, thanks.

-- 
Jens Axboe


