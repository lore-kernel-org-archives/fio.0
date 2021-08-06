Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v3 0/5] zbd: Support zone reset by trim
References: <20210806010711.1128153-1-shinichiro.kawasaki@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <6e74b519-18a2-22a0-0abb-2b62242ce65d@kernel.dk>
Date: Fri, 6 Aug 2021 16:39:50 -0600
MIME-Version: 1.0
In-Reply-To: <20210806010711.1128153-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

On 8/5/21 7:07 PM, Shin'ichiro Kawasaki wrote:
> Trim workload is currently not supported for zonemode=zbd. This patch series
> enables it by resetting zones for trim I/Os. This allows fio to measure
> performance of zoned block devices using more realistic workloads which mixes
> write and trim.
> 
> The first patch prepares for trim support by modifying the helper function
> zbd_find_zone(). The second patch adds zone reset for trim. The third patch
> enables trim workload for libzbc I/O engine. The fourth patch updates the HOWTO
> file to describe the added functionality. The fifth patch adds a test case that
> exercises trim operation with zonemode=zbd.

Applied, thanks.

-- 
Jens Axboe


