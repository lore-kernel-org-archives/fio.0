Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/3] zbd: Fix issues found with test script
References: <20200413083300.256784-1-shinichiro.kawasaki@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b33684ac-08aa-c5c4-01a8-226981e73569@kernel.dk>
Date: Mon, 13 Apr 2020 08:22:29 -0600
MIME-Version: 1.0
In-Reply-To: <20200413083300.256784-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 4/13/20 2:32 AM, Shin'ichiro Kawasaki wrote:
> This series addresses issues found with t/zbd/test-zbd-support script runs with
> various conditions. The three patches fix issues about maximum open zone check,
> reset all zones and random read/write on empty zones, respectively.
> 
> Please consider this series for the fio upstream.

Applied, thanks.

-- 
Jens Axboe


