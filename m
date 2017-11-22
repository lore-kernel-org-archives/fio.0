Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] add sig_figs parameter
References: <BN3PR0401MB1457EE94EC3FDDC638DCF5638F200@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <634086ff-0d29-103b-8cdf-b4603c82be22@kernel.dk>
Date: Wed, 22 Nov 2017 11:06:55 -0700
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB1457EE94EC3FDDC638DCF5638F200@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 11/21/2017 07:09 PM, Jeff Furlong wrote:
> Hi All,
> Attached is a patch for adding a new significant figures parameter to
> the normal output format.  Somes when using large I/O sizes, the
> hardcoded 4 sig figs does not truly represent the throughput, due to
> rounding/truncating.  So this parameter allows the value to be user
> settable, without having to inspect json outputs (intended for machine
> readable, not human readable).  With this patch, the default behavior
> is exactly as it is today, meaning the default sig_figs is 4.  If a
> user enables --sig_figs=5, then one extra digit will be displayed.
> Please let me know of any bugs/issues.  Thanks.

Looks good to me, but sig_figs is sort-of a horrible name. Why not just
call it 'significant_figures' instead? It's longer, but you know what it
is.

Your patch also seems somewhat mangled on white space. Care to resend
with the name change, and in a cleaner version?

-- 
Jens Axboe


