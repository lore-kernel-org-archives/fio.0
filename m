Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2 0/8] zbd: Fix initial zone write pointer of regular
 block devices
References: <20200715041322.114929-1-shinichiro.kawasaki@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <458e9c72-0cf3-afea-4410-0c2f7e51a55c@kernel.dk>
Date: Fri, 17 Jul 2020 07:32:34 -0600
MIME-Version: 1.0
In-Reply-To: <20200715041322.114929-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 7/14/20 10:13 PM, Shin'ichiro Kawasaki wrote:
> With zonemode=zbd and regular block devices, fio initializes zone status as
> empty. However, write pointers are set not at zone start but at zone end. This
> inconsistency between write pointer position and zone status caused different
> behavior of regular block devices from zoned block devices. This patch series
> fixes the inconsistency and the behavior gap.
> 
> The 1st patch fixes the zone status initialization code by setting write
> pointers at zone start. Following patches fixes t/zbd test script to handle
> regular block devices and zoned block devices in same manner.

Applied, thanks.

-- 
Jens Axboe


