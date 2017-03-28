Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 02/13] Use GOLDEN_RATIO_PRIME
References: <20170328200301.8622-1-tkusumi@tuxera.com>
 <20170328200301.8622-2-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <a0c00913-954f-0bc7-a0fa-abbcd87bff7e@kernel.dk>
Date: Tue, 28 Mar 2017 14:44:46 -0600
MIME-Version: 1.0
In-Reply-To: <20170328200301.8622-2-tkusumi@tuxera.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 03/28/2017 02:02 PM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> Using this macro (originally for hash in Linux kernel) for rand seed
> instead of hard-coded value should make sense. rdma ioengine uses
> this for the seed as well.

This will change the seed behavior for 64-bit builds. I don't think
we should do that in the name of a cleanup.

-- 
Jens Axboe


