Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] flow: fix hang with flow control and zoned block devices
References: <20201207103045.3433366-1-aravind.ramesh@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <3bb8d092-c26d-1675-bdc3-c0b065870716@kernel.dk>
Date: Mon, 7 Dec 2020 16:56:47 -0700
MIME-Version: 1.0
In-Reply-To: <20201207103045.3433366-1-aravind.ramesh@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Aravind Ramesh <aravind.ramesh@wdc.com>, fio@vger.kernel.org, shinichiro.kawasaki@wdc.com
List-ID: <fio@vger.kernel.org>

On 12/7/20 3:30 AM, Aravind Ramesh wrote:
> From: Aravind Ramesh <Aravind.Ramesh@wdc.com>
> 
> When flow control is specified between 2 or more threads executing a workload
> with zonemode=zbd and flow_sleep is not specified by the user (default to zero),
> then a job A can lock a zone Z with the flow ratio exceeded, resulting in the
> job to not issue the IO until other jobs IOs balance the flow ratio.
> Since job A will wait with the Zone Z locked, other jobs will deadlock waiting
> for this zone lock if their workload resulted in this zone Z being chosen
> as an IO target.
> 
> Executing io_u_quiesce() when the flow ratio is exceeded solves this potential
> deadlock as job A will wait for the flow ratio to balance without holding the
> zone A lock. To preserve the behavior for regular block devices and to avoid
> extra overhead, io_u_quiesce() only needs to be executed when the workload
> specifies zonedmode=zbd.

Applied, thanks.

-- 
Jens Axboe


