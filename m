Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] zbd: use ->min_zone, ->max_zone in more places
References: <20200813163632.GB26072@localhost.localdomain>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b1fcac00-30ab-c164-bd29-1e142bccf0b5@kernel.dk>
Date: Thu, 13 Aug 2020 16:06:41 -0600
MIME-Version: 1.0
In-Reply-To: <20200813163632.GB26072@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: fio@vger.kernel.org, damien.lemoal@wdc.com
List-ID: <fio@vger.kernel.org>

On 8/13/20 10:36 AM, Alexey Dobriyan wrote:
> Check that ->min_zone is less than ->max_zone.
> This assert found one bug here.
> 
> Use it in more places, now that it was added.

Applied, thanks.

-- 
Jens Axboe


