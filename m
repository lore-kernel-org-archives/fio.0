Return-Path: <axboe@kernel.dk>
Date: Tue, 21 Mar 2017 07:16:28 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/7] Replace redundant TD_F_NOIO flag with td->io_ops_init
Message-ID: <20170321131628.GA16024@kernel.dk>
References: <20170320212847.71404-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170320212847.71404-1-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Mon, Mar 20 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> The only reason TD_F_NOIO exists in addition to FIO_NOIO is because
> fio_running_or_pending_io_threads() needs to know whether td has
> successfully initialized ioengine, whereas FIO_NOIO is statically
> set regardless of ioengines's ->init() result.
> 
> This commit adds a new td field ->io_ops_init to inidicate ->init()
> result, so that td needs no extra bit field for each ioengine like
> TD_F_NOIO. It was rather odd that td was unable to tell ->init()
> result afterward when ->init() failure (returning non zero) doesn't
> mean aborting fio itself. This commit also changes TD_F_NOIO to
> TD_F_RESERVED as it's no longer used.

Thanks, applied 1-7.

-- 
Jens Axboe


