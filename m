Return-Path: <axboe@kernel.dk>
Message-ID: <53879530.9020509@kernel.dk>
Date: Thu, 29 May 2014 14:14:40 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Make rbd engine use aio flush
References: <1400661055-1452-1-git-send-email-haomaiwang@gmail.com>
In-Reply-To: <1400661055-1452-1-git-send-email-haomaiwang@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Haomai Wang <haomaiwang@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 05/21/2014 02:30 AM, Haomai Wang wrote:
> The fio's option "fsync" can make rbd engine issue sync request. In practice,
> we would like to use aio_rbd_flush to make it non-block. So it will be more
> reliable to use fio to evaluate actual io scene like qemu.

Thanks, added.

-- 
Jens Axboe


