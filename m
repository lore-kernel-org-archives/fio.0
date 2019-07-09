Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] fio: fix aio trim completion latencies
References: <20190708192354.14979-1-vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <c34aed29-8199-43ea-796f-35a4b7959c6e@kernel.dk>
Date: Tue, 9 Jul 2019 08:37:32 -0600
MIME-Version: 1.0
In-Reply-To: <20190708192354.14979-1-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: vincentfu@gmail.com, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 7/8/19 1:23 PM, vincentfu@gmail.com wrote:
> From: Vincent Fu <vincent.fu@wdc.com>
> 
> The io_uring, libaio, and posixaio ioengines actually carry out
> synchronous trim operations, but latency timestamps are recorded as if
> the trims were issued asynchronously. This patch fixes how timestamps
> are recorded for trim operations issued by these ioengines.

Thanks for fixing this Vincent, applied.

-- 
Jens Axboe


