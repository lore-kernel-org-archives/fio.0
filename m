Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v3 0/5] improve zbd initialization
References: <20210614134851.158700-1-Niklas.Cassel@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f0bc387d-4c64-9f37-b8d1-2ce98734a3f8@kernel.dk>
Date: Mon, 14 Jun 2021 08:55:10 -0600
MIME-Version: 1.0
In-Reply-To: <20210614134851.158700-1-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 6/14/21 7:49 AM, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Hello there,
> 
> This series improves zbd initialization, by making it more robust.
> Previously, zbd_create_zone_info() could return success at the same
> time as f->zbd_info was never initialized. Remove ZBD_IGNORE to
> avoid this combination from being possible.
> 
> Also, zonemode=zbd can now be used with regular files by emulating
> zones inside the file. (Just like how we already support emulating
> zones inside a regular block device).

Applied, thanks.

-- 
Jens Axboe


