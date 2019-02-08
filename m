Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] client/server: inflate error handling
References: <MWHPR04MB03208D586D958B32CAC0AD678F690@MWHPR04MB0320.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <89da1e12-adc5-6d20-81d5-40ddd67e7c5a@kernel.dk>
Date: Fri, 8 Feb 2019 16:35:09 -0700
MIME-Version: 1.0
In-Reply-To: <MWHPR04MB03208D586D958B32CAC0AD678F690@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2/8/19 2:43 PM, Jeff Furlong wrote:
> Occasionally fio client/server with zlib enabled may report:
> 
> fio: inflate error -5
> fio: failed decompressing log
> fio: failed converting IO log

[snip]

Applied, with some formatting changes. Thanks for this. zlib really is
the worst API in the world...

-- 
Jens Axboe


