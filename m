Return-Path: <axboe@kernel.dk>
Date: Thu, 25 Jun 2015 09:22:33 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Fix testing and setting set_options bitmap
Message-ID: <20150625152233.GE13739@kernel.dk>
References: <1435239581-6642-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1435239581-6642-1-git-send-email-akinobu.mita@gmail.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Thu, Jun 25 2015, Akinobu Mita wrote:
> set_options bitmap is an array of uint64_t.  But while testing and
> setting a bit in the bitmap, the bit mask is calculated with an
> unsigned long value.  For the systems which have 32-bit long type,
> upper 32-bit cannot be set correctly.
> 
> Fix it by using (uint64_t)1 instead of 1UL to calculate correct bit
> mask.

Thanks, applied.

-- 
Jens Axboe


