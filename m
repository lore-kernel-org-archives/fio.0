Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] zbd: Fix max_open_zones checks
References: <20200527012013.87661-1-shinichiro.kawasaki@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <16f21e1b-1055-318c-ca11-efd56cf786e0@kernel.dk>
Date: Wed, 3 Jun 2020 20:15:52 -0600
MIME-Version: 1.0
In-Reply-To: <20200527012013.87661-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 5/26/20 7:20 PM, Shin'ichiro Kawasaki wrote:
> Commit 219c662d3b12 ("zbd: introduce per job maximum open zones limit")
> introduced job_max_open_zones option which limits the number of open
> zones per job. It has similar role as max_open_zones option which limits
> the number of open zones for all jobs. It was intended that these two
> options both work, but the commit replaced some checks for max_open_zones
> simply with checks for job_max_open_zones. Because of this, when
> max_open_zones is set and job_max_open_zones is not set, fio fails to
> limit the number of open zones. This resulted in test case #29 failure
> of t/zbd/test-zbd-support script for regular null_blk devices.
> 
> To fix the failure, modify the checks to target both job_max_open_zones
> and max_open_zones.

Applied, thanks.

-- 
Jens Axboe


