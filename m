Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] init: force threads when checking overlap in offload
 mode
References: <20181016152650.7784-1-vincentfu@gmail.com>
 <20181016152650.7784-3-vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <1a792daa-4327-1a4e-48df-4c691630c834@kernel.dk>
Date: Tue, 16 Oct 2018 09:29:06 -0600
MIME-Version: 1.0
In-Reply-To: <20181016152650.7784-3-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: vincentfu@gmail.com, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 10/16/18 9:26 AM, vincentfu@gmail.com wrote:
> From: Vincent Fu <vincent.fu@wdc.com>
> 
> serialize_overlap combined with io_submit_mode=offload requires
> threads. Print a warning and force the use of threads if the user
> did not specify threads.

Why does it require threads? Is it because of the use of a pthread
mutex? If so, that should just be a fio mutex instead, and you would
not have this restrictions (on most platforms, at least).

-- 
Jens Axboe


