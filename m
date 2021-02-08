Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Mon, 8 Feb 2021 19:37:56 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] zbd: support 'z' suffix for zone granularity
Message-ID: <20210208163756.GA32414@localhost.localdomain>
References: <20210204083220.GA10648@localhost.localdomain>
 <MN2PR04MB5951459146F5244AD7DC6A13E1B29@MN2PR04MB5951.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <MN2PR04MB5951459146F5244AD7DC6A13E1B29@MN2PR04MB5951.namprd04.prod.outlook.com>
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Fri, Feb 05, 2021 at 12:53:32AM +0000, Dmitry Fomichev wrote:
> > @@ -599,7 +600,10 @@ static int __handle_option(const struct fio_option
> > *o, const char *ptr,
> >  		fallthrough;
> >  	case FIO_OPT_ULL:
> >  	case FIO_OPT_INT:
> > -	case FIO_OPT_STR_VAL: {
> > +	case FIO_OPT_STR_VAL:
> > +not_zone_granularity:;
> > +		{
> > +
> >  		fio_opt_str_val_fn *fn = o->cb;
> >  		char tmp[128], *p;
> > 
> > @@ -944,6 +948,39 @@ static int __handle_option(const struct fio_option
> > *o, const char *ptr,
> >  		}
> >  		break;
> >  	}
> > +	case FIO_OPT_STR_VAL_ZONE: {
> > +		int (*f)(void*, unsigned long long *) = o->cb;
> > +		char *ep;
> > +		unsigned long long val;
> > +		size_t len = strlen(ptr);
> > +
> > +		if (len == 0 || ptr[len - 1] != 'z')
> > +			goto not_zone_granularity;
> 
> The goto above looks pretty bad - the jump is quite far and backwards.
> How about arranging the new code a little bit differently in this
> function? Something like
> 
> 	case FIO_OPT_INT:
> + 	if (len > 0 && ptr[len - 1] == 'z') {
> +		log_err(<zoned units are not allowed>);
> +		return 1;
> +	}
> +	fallthrough;
> + 	case FIO_OPT_STR_VAL_ZONE:
> + 	if (len > 0 && ptr[len - 1] == 'z') {
> + 		<process the new STR_VAL_ZONE>
> +		break;
> +	}
> +	fallthrough;
> + 	case FIO_OPT_STR_VAL:
> + 		<process the regular STR_VAL>

This will make FIO_OPT_STR_VAL_TIME options to acquire support
for 'z' suffix. goto has to be somewhere.

