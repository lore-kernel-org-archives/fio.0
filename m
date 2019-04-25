Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] zbd random read conventional zones
References: <20190424214741.21554-1-phillip.a.chen@seagate.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <c296f846-1fde-f5c4-0029-ae4ab03401b8@kernel.dk>
Date: Thu, 25 Apr 2019 08:14:37 -0600
MIME-Version: 1.0
In-Reply-To: <20190424214741.21554-1-phillip.a.chen@seagate.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: phillip.a.chen@seagate.com, fio@vger.kernel.org
Cc: damien.lemoal@wdc.com
List-ID: <fio@vger.kernel.org>

On 4/24/19 3:47 PM, phillip.a.chen@seagate.com wrote:
> From: Phillip Chen <phillip.a.chen@seagate.com>
> 
> Signed-off-by: Phillip Chen <phillip.a.chen@seagate.com>
> Initialize conventional zone write pointers to full so
> zbd_find_zone will accept conventional zones when searching
> around a randomly chosen empty zone.

Fixed up the style and applied, thanks.

-- 
Jens Axboe


