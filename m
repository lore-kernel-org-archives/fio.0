Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v3 0/6] Support zone capacity
References: <20200717093637.139565-1-shinichiro.kawasaki@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f6d7f0e8-2212-685e-0c52-74adbc925008@kernel.dk>
Date: Tue, 21 Jul 2020 09:17:50 -0600
MIME-Version: 1.0
In-Reply-To: <20200717093637.139565-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Hans Holmberg <hans.holmberg@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>
List-ID: <fio@vger.kernel.org>

On 7/17/20 3:36 AM, Shin'ichiro Kawasaki wrote:
> Kernel 5.9 zone descriptor interface adds the new zone capacity field defining
> the range of sectors usable within a zone. This patch series adds support for
> this new field.
> 
> The 1st patch adds zone capacity support to zonemode=zbd. Get zone capacity
> values of each zone and adjust io_u to meet the zone capacity limit. The 2nd
> patch adds a new option zonecapacity which allows to test zone capacity
> handling by fio using regular block devices. Other four patches extend t/zbd
> test scripts for zone capacity.
> 
> Of note is that the zone capacity is always equal to the zone size for SCSI
> drives. For NVMe ZNS and nullblk zoned drives, the zone capacity can be
> smaller than the zone size.
> 
> This series can be applied on top of another series 'zbd: Fix initial zone
> write pointer of regular block devices'.

Applied, thanks.

-- 
Jens Axboe


