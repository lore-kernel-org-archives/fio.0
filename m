Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] stat cleanup/bugfix patches
References: <20190207155107.7148-1-vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <7530595b-03e9-64a5-3dd9-5a221155b607@kernel.dk>
Date: Thu, 7 Feb 2019 09:49:02 -0700
MIME-Version: 1.0
In-Reply-To: <20190207155107.7148-1-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: vincentfu@gmail.com, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2/7/19 8:51 AM, vincentfu@gmail.com wrote:
> From: Vincent Fu <vincent.fu@wdc.com>
> 
> Jens, please consider these two cleanup/bugfix patches for stat.c
> 
> Vincent
> 
> Vincent Fu (2):
>   stat: clean up calc_clat_percentiles
>   stat: put 'percentiles' object in appropriate 'clat_ns' or 'lat_ns'
>     parent
> 
>  stat.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)

Looks good, applied both. Thanks Vincent.

-- 
Jens Axboe


