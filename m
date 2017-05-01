Return-Path: <axboe@kernel.dk>
Date: Mon, 1 May 2017 14:48:43 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 01/11] configure: Disable CONFIG_POSIX_FALLOCATE on
 NetBSD even if posix_fallocate(3) compiles
Message-ID: <20170501204842.GB13925@kernel.dk>
References: <20170501184820.31025-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170501184820.31025-1-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

Hi,

Can you use a cover letter for multi-patch series? Makes it less awkward
to reply to the series in general.

Anway, applied 5-10. I would have applied 11 as well, but it doesn't
apply since 1-4 were dropped.

Feel free to resend the rest, considering the comments on patch #1.

-- 
Jens Axboe


