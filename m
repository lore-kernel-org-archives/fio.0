Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2 0/1] fio: reset more counters when ramp time has
 elapsed
References: <20181018204254.5350-1-vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <4bd0e380-b954-c936-7ac0-1f8dd4e6a96f@kernel.dk>
Date: Thu, 18 Oct 2018 15:32:31 -0600
MIME-Version: 1.0
In-Reply-To: <20181018204254.5350-1-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: vincentfu@gmail.com, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 10/18/18 2:42 PM, vincentfu@gmail.com wrote:
> From: Vincent Fu <vincent.fu@wdc.com>
> 
> Jens, I sent the wrong patch earlier.
> 
> This version should be safer since reset_io_stats() is now called in
> ramp_time_over() instead of in reset_all_stats().

Agree, that makes me less nervous. Applied, thanks.

-- 
Jens Axboe


