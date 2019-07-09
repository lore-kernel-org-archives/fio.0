Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] engines/http: set FIO_SYNCIO flag
References: <20190709145440.18297-1-vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <561a7e87-4e66-a3b0-d04e-7bf9d2e2fcfa@kernel.dk>
Date: Tue, 9 Jul 2019 08:55:42 -0600
MIME-Version: 1.0
In-Reply-To: <20190709145440.18297-1-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: vincentfu@gmail.com, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 7/9/19 8:54 AM, vincentfu@gmail.com wrote:
> From: Vincent Fu <vincent.fu@wdc.com>
> 
> This ioengine carries out synchronous operations. So the FIO_SYNCIO flag
> needs to be set in order for latencies to be calculated correctly.

Applied, thanks.

-- 
Jens Axboe


