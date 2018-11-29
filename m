Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] gettime: use nsec in get_cycles_per_msec division
References: <20181129181418.24788-1-vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <e784e513-65b4-bb28-8487-347ae467f5f5@kernel.dk>
Date: Thu, 29 Nov 2018 11:21:36 -0700
MIME-Version: 1.0
In-Reply-To: <20181129181418.24788-1-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: vincentfu@gmail.com, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 11/29/18 11:14 AM, vincentfu@gmail.com wrote:
> From: Vincent Fu <vincent.fu@wdc.com>
> 
> Since we now have ntime_since() we can use nsec in the division for
> get_cycles_per_msec(). This makes the cycles_per_msec value that fio
> ultimately uses more stable since fio will no longer be using values
> truncated to usec.
> 
> While we're here also modify some debug prints to make it explicit that
> fio ultimately uses a trimmed mean in its time calculations.
> 
> On platforms where only gettimeofday() is available this will be no
> worse than the original code since we will revert back to using times
> truncated to usec.
> 
> With the patch, the last three digits of the trimmed mean have a tight
> range from 784-786. Without the patch, the corresponding value (labeled
> avg) has a much wider range from 821-958. Notice also that the standard
> error S is an order of magnitude smaller with the patch.

This is great, thanks Vincent. Applied.

-- 
Jens Axboe


