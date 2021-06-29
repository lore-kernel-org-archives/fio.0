Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/3] fix max open zones handling when using multiple jobs
References: <20210624172256.37177-1-Niklas.Cassel@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <e950820b-774c-9bde-8c09-3cb8308209b1@kernel.dk>
Date: Tue, 29 Jun 2021 07:44:04 -0600
MIME-Version: 1.0
In-Reply-To: <20210624172256.37177-1-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "adobriyan@gmail.com" <adobriyan@gmail.com>
List-ID: <fio@vger.kernel.org>

On 6/24/21 11:23 AM, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Currently, the fio handling of max open zones is very fragile.
> 
> zbd_open_zone() uses zbd_info->max_open_zones when checking
> the max open zones limit, while zbd_convert_to_open_zone()
> uses td->o.max_open_zones when performing the same limit check.
> 
> It is simply wrong to use td->o.max_open_zones after zbd_setup_files().
> 
> Change zbd_convert_to_open_zone() to use zbd_info->max_open_zones.
> This way, the global max open zones limit (which is per device) will be
> respected for all jobs.
> 
> This series also adds a patch that reintroduces the ability to
> run write workloads with no limit on the maximum number of open zones.
> In this case, tracking of open zones in the zbd_info->open_zones array
> is disabled to reduce overhead.

Applied, thanks.

-- 
Jens Axboe


