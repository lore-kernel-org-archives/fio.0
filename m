Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 1/5] verify: decouple seed generation from buffer fill
References: <20200521231716.28832-1-adobriyan@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <30db1c78-6a83-4de5-4976-0372080ca91b@kernel.dk>
Date: Thu, 21 May 2020 17:24:02 -0600
MIME-Version: 1.0
In-Reply-To: <20200521231716.28832-1-adobriyan@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: damien.lemoal@wdc.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 5/21/20 5:17 PM, Alexey Dobriyan wrote:
> It is nicer this way and there will be more code in this area
> with ZBD verification.

Applied this (and 2-5), thanks.

-- 
Jens Axboe


