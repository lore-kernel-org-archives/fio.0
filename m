Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v3 0/7] Improve open zones accounting
References: <20200901082006.1476720-1-shinichiro.kawasaki@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <9bb4bf43-409c-960c-56b2-25cb2c430392@kernel.dk>
Date: Tue, 1 Sep 2020 08:38:59 -0600
MIME-Version: 1.0
In-Reply-To: <20200901082006.1476720-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On 9/1/20 2:19 AM, Shin'ichiro Kawasaki wrote:
> The max_open_zones and job_max_open_zones option control number of write target
> open zones within the specified limit. Currently, this write target zone
> accounting is not accurate enough. Even with these options set, the limits can
> exceed during write workloads.
> 
> This patch series improves accuracy of the open zones accounting. The first
> patch moves the moment to decrement number of currently open zones from write
> command submit to write command completion. This avoids zone writes beyond the
> limit caused by concurrent write commands at queue depths approaching the max
> limits. The second and third patches fix the open zone status initialization
> issue. Other following patches improve t/zbd scripts to take maximum write
> target zone limit and allow to test devices with the limit.

Applied, thanks.

-- 
Jens Axboe


