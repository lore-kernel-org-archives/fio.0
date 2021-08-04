Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] two small patches
References: <CGME20210804182903uscas1p164abe67510e8fa693dbd5d999ecdf24f@uscas1p1.samsung.com>
 <20210804182841.8780-1-vincent.fu@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <96d9a65e-429d-c661-88d9-2dac1e2a0e09@kernel.dk>
Date: Wed, 4 Aug 2021 12:50:07 -0600
MIME-Version: 1.0
In-Reply-To: <20210804182841.8780-1-vincent.fu@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Vincent Fu <vincent.fu@samsung.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 8/4/21 12:29 PM, Vincent Fu wrote:
> Hello Jens,
> 
> Please consider these two small patches that (1) clarify an error
> message and (2) fix a segfault.
> 
> Vincent
> 
> Vincent Fu (2):
>   backend: clarify io scheduler setting error message
>   ioengines: fix crash with --enghelp option
> 
>  backend.c   |  2 +-
>  ioengines.c | 10 +++++-----
>  2 files changed, 6 insertions(+), 6 deletions(-)

Applied, thanks.

-- 
Jens Axboe


