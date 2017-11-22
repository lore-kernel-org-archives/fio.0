Return-Path: <axboe@kernel.dk>
Date: Wed, 22 Nov 2017 11:39:51 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] add significant_figures parameter
Message-ID: <20171122183950.GA24363@kernel.dk>
References: <BN3PR0401MB1457B7A2EE06CE03A7C314158F200@BN3PR0401MB1457.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN3PR0401MB1457B7A2EE06CE03A7C314158F200@BN3PR0401MB1457.namprd04.prod.outlook.com>
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Wed, Nov 22 2017, Jeff Furlong wrote:
> >Looks good to me, but sig_figs is sort-of a horrible name. Why not just call it 'significant_figures' instead? It's longer, but you know what it is.
> 
> OK, simple enough.
> 
> >Your patch also seems somewhat mangled on white space. Care to resend with the name change, and in a cleaner version?
> 
> Something did get mangled.  Here's the fix.  Thanks.

Showed up as base64 encoded, but at least I could decode that. Applied,
thanks Jeff.

-- 
Jens Axboe


