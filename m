Return-Path: <axboe@kernel.dk>
Date: Tue, 10 Jan 2017 13:21:35 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/4] Partly revert 8172fe97 in 2008 (A few debug debug
 log fixes)
Message-ID: <20170110202135.GA15187@kernel.dk>
References: <1484069987-13105-1-git-send-email-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484069987-13105-1-git-send-email-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Wed, Jan 11 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> Not sure what the point of 8172fe97 was, but shouldn't all the
> prints within a single line be dprint() (or all be log_info()) ?

Applied 1-4, thanks.

-- 
Jens Axboe


