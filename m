Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Thu, 13 Aug 2020 13:36:24 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] fio: add for_each_rw_ddir() macro
Message-ID: <20200813103624.GA5475@localhost.localdomain>
References: <20200812152622.GA40719@localhost.localdomain>
 <TU4PR8401MB10556465AD0CE9AF3A1E4B30AB420@TU4PR8401MB1055.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <TU4PR8401MB10556465AD0CE9AF3A1E4B30AB420@TU4PR8401MB1055.NAMPRD84.PROD.OUTLOOK.COM>
To: "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Wed, Aug 12, 2020 at 10:01:56PM +0000, Elliott, Robert (Servers) wrote:
> > -----Original Message-----
> > From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> On Behalf
> > Of Alexey Dobriyan
> > Sent: Wednesday, August 12, 2020 10:26 AM
> > To: axboe@kernel.dk
> > Cc: fio@vger.kernel.org
> > Subject: [PATCH] fio: add for_each_rw_ddir() macro
> > 
> > Make it slightly easier to add DDIR_APPEND as fully fledged I/O type.

> >  	/*
> >  	 * For random IO, allow blockalign offset other than min_bs.
> >  	 */
> > -	if (!o->ba[DDIR_READ] || !td_random(td))
> > -		o->ba[DDIR_READ] = o->min_bs[DDIR_READ];
> > -	if (!o->ba[DDIR_WRITE] || !td_random(td))
> > -		o->ba[DDIR_WRITE] = o->min_bs[DDIR_WRITE];
> > -	if (!o->ba[DDIR_TRIM] || !td_random(td))
> > -		o->ba[DDIR_TRIM] = o->min_bs[DDIR_TRIM];
> > +	for_each_rw_ddir(ddir) {
> > +		if (!o->ba[ddir] || !td_random(td))
> > +			o->ba[ddir] = o->min_bs[ddir];
> > +	}
> > 
> >  	if ((o->ba[DDIR_READ] != o->min_bs[DDIR_READ] ||
> >  	    o->ba[DDIR_WRITE] != o->min_bs[DDIR_WRITE] ||
> 
> continues as:
>             o->ba[DDIR_TRIM] != o->min_bs[DDIR_TRIM]) &&
>             !o->norandommap) {
> 
> which should be updated too.

Actually it should not. This error message doesn't make sense for Append:

        if ((o->ba[DDIR_READ] != o->min_bs[DDIR_READ] ||
            o->ba[DDIR_WRITE] != o->min_bs[DDIR_WRITE] ||
            o->ba[DDIR_TRIM] != o->min_bs[DDIR_TRIM]) &&
            !o->norandommap) {
                log_err("fio: Any use of blockalign= turns off randommap\n");
                o->norandommap = 1;
                ret |= warnings_fatal;
        }

ba= should be ignored for Append (maybe with a non-fatal warning message).

> > @@ -765,14 +757,12 @@ static int fixup_options(struct thread_data
> > *td)
> >  		log_err("fio: rate and rate_iops are mutually
> > exclusive\n");
> >  		ret |= 1;
> >  	}
> > -	if ((o->rate[DDIR_READ] && (o->rate[DDIR_READ] < o->ratemin[DDIR_READ])) ||
> > -	    (o->rate[DDIR_WRITE] && (o->rate[DDIR_WRITE] < o->ratemin[DDIR_WRITE])) ||
> > -	    (o->rate[DDIR_TRIM] && (o->rate[DDIR_TRIM] < o->ratemin[DDIR_TRIM])) ||
> > -	    (o->rate_iops[DDIR_READ] && (o->rate_iops[DDIR_READ] < o->rate_iops_min[DDIR_READ])) ||
> > -	    (o->rate_iops[DDIR_WRITE] && (o->rate_iops[DDIR_WRITE] < o->rate_iops_min[DDIR_WRITE])) ||
> > -	    (o->rate_iops[DDIR_TRIM] && (o->rate_iops[DDIR_TRIM] < o->rate_iops_min[DDIR_TRIM]))) {
> > -		log_err("fio: minimum rate exceeds rate\n");
> > -		ret |= 1;
> > +	for_each_rw_ddir(ddir) {
> > +		if ((o->rate[ddir] && (o->rate[ddir] < o->ratemin[ddir])) ||
> > +		    (o->rate_iops[ddir] && (o->rate_iops[ddir] < o->rate_iops_min[ddir]))) {
> > +			log_err("fio: minimum rate exceeds rate\n");
> > +			ret |= 1;
> > +		}
> >  	}
> 
> That changes the behavior slightly - you can now get up to three of
> those messages. Printing the value of ddir would help identify the
> problem(s) and be more informative than the current single message.

OK.

