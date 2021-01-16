Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2] Fix a rate limit issue.
References: <1610826754-2931-1-git-send-email-glqinhongwei@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <3013fec2-11d0-955e-b889-ddb6abb85777@kernel.dk>
Date: Sat, 16 Jan 2021 13:10:16 -0700
MIME-Version: 1.0
In-Reply-To: <1610826754-2931-1-git-send-email-glqinhongwei@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: HongweiQin <glqinhongwei@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 1/16/21 12:52 PM, HongweiQin wrote:
> In the current implementation, should_check_rate() returns false
> if ddir_rw_sum(td->bytes_done)==0. Therefore, a thread may violate
> the rate if iodepth*bs > rate.
> 
> This patch addresses the issue by not checking td->bytes_done in should_check_rate.

Much better, thanks. I have applied it.

-- 
Jens Axboe


