Return-Path: <axboe@kernel.dk>
Date: Sun, 19 Feb 2017 17:58:02 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/6] Rename thread_options' ->io_limit to io_size
Message-ID: <20170220005802.GA28188@kernel.dk>
References: <20170219182223.120559-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170219182223.120559-1-tkusumi@tuxera.com>
To: Tomohiro Kusumi <tkusumi@tuxera.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Sun, Feb 19 2017, Tomohiro Kusumi wrote:
> This is less confusing since io_size is the option name itself,
> and not much reason to use io_limit which is an alias of io_size.

Applied 1-6, thanks.

-- 
Jens Axboe


