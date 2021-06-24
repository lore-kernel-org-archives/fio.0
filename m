Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Thu, 24 Jun 2021 23:09:11 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/3] zbd: create a local zbdi variable for f->zbd_info
Message-ID: <YNTmZ3y8r+/DXyds@localhost.localdomain>
References: <20210624172256.37177-1-Niklas.Cassel@wdc.com>
 <20210624172256.37177-2-Niklas.Cassel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210624172256.37177-2-Niklas.Cassel@wdc.com>
To: Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

On Thu, Jun 24, 2021 at 05:23:07PM +0000, Niklas Cassel wrote:
> +	struct zoned_block_device_info *zbdi = f->zbd_info;

It is unrelated to the patch. But! It is impossible to type
"zoned_block_device_info" without autocompletion.

Can it be renamed just to 

	struct zbd * const zbd = f->zbd_info;

"info" is kind of information free word, too.

