Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Tue, 5 May 2020 20:59:29 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 8/9] zbd: support verification
Message-ID: <20200505175929.GA2719@avx2>
References: <20200505175634.2517-1-adobriyan@gmail.com>
 <20200505175634.2517-8-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200505175634.2517-8-adobriyan@gmail.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, damien.lemoal@wdc.com
List-ID: <fio@vger.kernel.org>

On Tue, May 05, 2020 at 08:56:34PM +0300, Alexey Dobriyan wrote:
> Verification is not supported in ZBD mode which is codified in this
> assert:
> 
> 	if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {
> 		assert(td->o.verify == VERIFY_NONE);

This is RFC for now, not for merging, there rest are.

And no, patches haven't been lost, 9/9 is debugging is usual...

