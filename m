Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/3] three patches
References: <20191111163055.7358-1-vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <be1df904-f3ec-3d09-547e-4a83c35494e6@kernel.dk>
Date: Thu, 14 Nov 2019 14:07:51 -0700
MIME-Version: 1.0
In-Reply-To: <20191111163055.7358-1-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: vincentfu@gmail.com, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 11/11/19 9:30 AM, vincentfu@gmail.com wrote:
> From: Vincent Fu <vincent.fu@wdc.com>
> 
> Jens, please consider this patch series.
> 
> The LFSR error message and test script error handling changes I believe
> should be uncontroversial.
> 
> Regarding the zonemode=strided patch, it will break job files that
> depend on the old buggy behavior, but that behavior is so inconsistent
> with the documentation that I think this fix is warranted.

Agree, and I don't think that's a high risk.

Applied, thanks.

-- 
Jens Axboe


