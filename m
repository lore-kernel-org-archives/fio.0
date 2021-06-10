Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] io_uring: drop redundant IO_MODE_OFFLOAD check
References: <20210610155539.354452-1-stefanha@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <00308c47-f5ae-8776-cbaa-81188e4d6c52@kernel.dk>
Date: Thu, 10 Jun 2021 16:40:59 -0600
MIME-Version: 1.0
In-Reply-To: <20210610155539.354452-1-stefanha@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Stefan Hajnoczi <stefanha@redhat.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 6/10/21 9:55 AM, Stefan Hajnoczi wrote:
> check_engine_ops() already returns an error if io_submit_mode is
> IO_MODE_OFFLOAD and the engine is marked FIO_NO_OFFLOAD.

Applied, thanks.

-- 
Jens Axboe


