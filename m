Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 1/3] zbd: Fix missing mutex unlock and warnings detected
 with coverity
References: <20200408064645.1621805-1-damien.lemoal@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f0af29de-e840-2867-0701-97237135cb43@kernel.dk>
Date: Wed, 8 Apr 2020 07:44:07 -0700
MIME-Version: 1.0
In-Reply-To: <20200408064645.1621805-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 4/7/20 11:46 PM, Damien Le Moal wrote:
> With max_open_zones != 0, if no candidate zone for open is found by
> zbd_convert_to_open_zone(), the file zbd_info mutex as well as the
> current target zone mutex must both be unlocked before returning NULL.
> 
> While at it, also assert check for min_bs != 0 where min_bs is used for
> divisions to avoid division by zero warnings from coverity.

You forgot the cover letter, so replying to this one. Applied 1-3 (v2).

-- 
Jens Axboe


