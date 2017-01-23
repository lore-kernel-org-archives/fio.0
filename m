Return-Path: <axboe@kernel.dk>
Date: Mon, 23 Jan 2017 08:26:32 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/8] Define pointer alignment macro in fio.h
Message-ID: <20170123152632.GA20374@kernel.dk>
References: <1485184391-11036-1-git-send-email-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1485184391-11036-1-git-send-email-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Tue, Jan 24 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> Define PTR_ALIGN() as a common utility within the entire fio,
> but inside FIO_INTERNAL guard since it could be a common name.

Thanks, applied 1-8.

-- 
Jens Axboe


