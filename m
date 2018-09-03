Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] engines/sg: improve error handling
References: <1535402411-8396-1-git-send-email-vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <a5312604-0875-a51a-7101-d377894d8d5a@kernel.dk>
Date: Mon, 3 Sep 2018 09:01:25 -0600
MIME-Version: 1.0
In-Reply-To: <1535402411-8396-1-git-send-email-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Vincent Fu <vincentfu@gmail.com>, fio@vger.kernel.org
Cc: Vincent Fu <Vincent.Fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 8/27/18 2:40 PM, Vincent Fu wrote:
> From: Vincent Fu <Vincent.Fu@wdc.com>
> 
> The Linux sg driver accepts only 16 SCSI commands in flight
> at a time per file descriptor. fio does not exit gracefully
> when it attempts to queue up 17 or more trim commands via
> the sg ioengine. This patch improves error handling in the
> sg ioengine commit function to achieve a graceful exit if
> fio attempts to queue up too many trim commands. The key to
> this is calling clear_io_u on each io_u in the 17th trim
> command. With this patch fio no longer loops forever
> waiting for the IOs in the (not succesffully submitted)
> 17th trim command to complete.

Applied, thanks Vincent.

-- 
Jens Axboe


