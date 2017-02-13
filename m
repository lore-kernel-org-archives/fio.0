Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Windows: re-enable the mmap ioengine and fix static
 asserts
References: <20170209221727.5828-1-rebecca@bluestop.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <972ab08f-0f92-e3d3-ec02-e5d8e7d309c3@kernel.dk>
Date: Mon, 13 Feb 2017 15:39:17 -0700
MIME-Version: 1.0
In-Reply-To: <20170209221727.5828-1-rebecca@bluestop.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bluestop.org>, fio@vger.kernel.org
Cc: Rebecca Cran <bruce.cran@sandisk.com>
List-ID: <fio@vger.kernel.org>

On 02/09/2017 03:17 PM, Rebecca Cran wrote:
> From: Rebecca Cran <bruce.cran@sandisk.com>
> 
> Windows supports mmap functionality via the CreateFileMapping and
> MapViewOfFile functions. Update posix.c and re-enable the mmap
> ioengine in the Makefile.
> 
> Also, enable the built-in static asserts, without which the build
> breaks when configured with --disable-optimizations.

Applied, thanks.

-- 
Jens Axboe


