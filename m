Return-Path: <axboe@kernel.dk>
Date: Sun, 30 Apr 2017 16:52:15 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/6] make fio work on OpenBSD again
Message-ID: <20170430225213.GA10051@kernel.dk>
References: <20170430173511.44593-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170430173511.44593-1-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Sun, Apr 30 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> This series of patches fix compile time errors recent OpenBSD
> versions have had. Now fio compiles and runs on recent versions,
> at least on the latest one which is 6.1.
> 
> It still shows warnings on sprintf() and strxxx() variants,
> but I didn't fix these. There are simply way too many sprintf()
> calls, and strlxxx() variants which OpenBSD suggests to use have
> their own problems (and that's why glibc doesn't have them,
> although fio has its own strlcat() for some reason).

Thanks, applied.

-- 
Jens Axboe


