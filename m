Return-Path: <axboe@kernel.dk>
Date: Mon, 13 Mar 2017 12:54:57 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Conditionally enable FIO_HAVE_PSHARED_MUTEX on FreeBSD
Message-ID: <20170313185457.GD23256@kernel.dk>
References: <20170313184237.33515-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170313184237.33515-1-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Mon, Mar 13 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> > This commit needs a better title, I had no idea what it does until I
> > read the patch and the URL pointed at.
> 
> Sorry, I rewrote the commit message.
> 
> FreeBSD ports has had an outbox patch to conditionally enable
> FIO_HAVE_PSHARED_MUTEX, which can be upstream'd.
> 
> This commit brings in below diff from FreeBSD ports.
> https://github.com/freebsd/freebsd-ports/commit/271a84d2df7bc9b983fe2fabe1615d01202d429b

Applied, thanks.

-- 
Jens Axboe


