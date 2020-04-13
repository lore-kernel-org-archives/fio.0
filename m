Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Tue, 14 Apr 2020 00:21:11 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 3/3] zbd: Ensure first I/O is write for random read/write
 to sequential zones
Message-ID: <20200413212111.GA19503@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
To: shinichiro.kawasaki@wdc.com
Cc: damien.lemoaal@wdc.com, axboe@kernel.dk, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> zbd_adjust_block


> +	if (td_rw(td) && !f->zbd_info->sectors_with_data
> +	    && !td->o.read_beyond_wp)
> +		io_u->ddir = DDIR_WRITE;

Oh, you've noticed this too. :-)

This will issue the first write with wrong length if bs[DDIR_READ] != bs[DDIR_WRITE].
Adjusting in zbd_adjust_block() is too late.

