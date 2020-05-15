Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2 0/7] Assorted bug fixes and improvements
References: <20200508075645.543890-1-damien.lemoal@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <81281f8a-86c3-106c-55bb-56cd04055614@kernel.dk>
Date: Fri, 15 May 2020 07:42:27 -0600
MIME-Version: 1.0
In-Reply-To: <20200508075645.543890-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 5/8/20 1:56 AM, Damien Le Moal wrote:
> The first 3 patches of this series fix bugs with write_iolog option
> initialization (crash on initialization failure) and with zonemode=zbd
> (one possible deadlock for read workloads and an assert trigerring with
> verify option enabled).
> 
> The following 4 patches are cleanups and improvements of zbd_xxx()
> functions to reduce unnecessary overhead when zonemode=zbd is not used.
> 
> Comments are welcome !

Sorry for the delay, took a look at them and don't see anything
wrong. I'll get them applied, thanks.

-- 
Jens Axboe


