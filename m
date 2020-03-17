Return-Path: <feng.tang@intel.com>
Date: Tue, 17 Mar 2020 22:52:40 +0800
From: Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH RFC] gauss.c: correct the stddev initializtion
Message-ID: <20200317145240.GA18256@shbuild999.sh.intel.com>
References: <20200317125331.6799-1-feng.tang@intel.com>
 <dab7e008-2fff-62d8-28f6-cc08a5388738@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dab7e008-2fff-62d8-28f6-cc08a5388738@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi,

On Tue, Mar 17, 2020 at 08:34:48AM -0600, Jens Axboe wrote:
> On 3/17/20 6:53 AM, Feng Tang wrote:
> > Signed-off-by: Feng Tang <feng.tang@intel.com>
> > ---
> >  lib/gauss.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/lib/gauss.c b/lib/gauss.c
> > index 1d24e187..3f84dbc6 100644
> > --- a/lib/gauss.c
> > +++ b/lib/gauss.c
> > @@ -51,7 +51,7 @@ void gauss_init(struct gauss_state *gs, unsigned long nranges, double dev,
> >  	gs->nranges = nranges;
> >  
> >  	if (dev != 0.0) {
> > -		gs->stddev = ceil((double) (nranges * 100.0) / dev);
> > +		gs->stddev = ceil((double)(nranges * dev) / 100.0);
> >  		if (gs->stddev > nranges / 2)
> >  			gs->stddev = nranges / 2;
> >  	}
> 
> Looks like I very helpfully did not include a reference to to where
> this is from... Can you expand on the need for the patch?

Thanks for your prompt response! 

I tried to run fio with "random_distribution=normal:20" as one
parameter, and didn't notice it has difference with "normal:50",
so I went to read the source code, as the man page says the
deviation ranges from 0 to 100, so this gs->stddev will
always be "nranges/2". Or I misunderstood the man page?

Thanks,
Feng

> 
> -- 
> Jens Axboe

