Return-Path: <axboe@kernel.dk>
Date: Mon, 13 Mar 2017 12:26:07 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/7] HOWTO: Add note/exception on allow_mounted_write=
Message-ID: <20170313182607.GA23256@kernel.dk>
References: <20170313181503.33322-1-tkusumi@tuxera.com>
 <20170313181503.33322-2-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170313181503.33322-2-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Mon, Mar 13 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> allow_mounted_write= is useful on Linux, but some platforms
> just return some error on open(2) for mounted devices.

Yes, same thing for Windows, in fact.

-- 
Jens Axboe


