Return-Path: <sits@sucs.org>
Date: Thu, 13 Feb 2014 20:05:03 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [PATCH] io_u_qiter: Fix buffer overrun
Message-ID: <20140213200459.GA31261@sucs.org>
References: <20140213070625.GA9117@sucs.org>
 <20140213161733.GD10926@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213161733.GD10926@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Thu, Feb 13, 2014 at 09:17:33AM -0700, Jens Axboe wrote:
> 
> Initially I didn't see the issue, but then I realized that ->io_us is a
> pointer to the io_u pointer. So it is an issue. The fix isn't super
> pretty, but it gets rid of the bug, so I'll apply it. It might be nicer
> to split it into a top and bottom define.

Can you explain this top and bottom define more - would this let me turn
it into a while loop?

The only reason for the current abuse was because I couldn't think of a
another way to fix it while preserving the macro...

-- 
Sitsofe | http://sucs.org/~sits/

