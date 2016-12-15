Return-Path: <axboe@kernel.dk>
Date: Thu, 15 Dec 2016 13:27:35 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] fio: add debug compile flag to avoid compiler warning
Message-ID: <20161215202735.GC29056@kernel.dk>
References: <148095966487.242344.5154555200954971050.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148095966487.242344.5154555200954971050.stgit@djiang5-desk3.ch.intel.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Mon, Dec 05 2016, Dave Jiang wrote:
> When compile with debug, without the proper -O flag the compiler complains:
> /usr/include/features.h:331:4: warning: #warning _FORTIFY_SOURCE requires
> compiling with optimization (-O) [-Wcpp]
> #  warning _FORTIFY_SOURCE requires compiling with optimization (-O)

Wouldn't it be better to only add the FORTIFY parts if optimization is
enabled?

-- 
Jens Axboe


