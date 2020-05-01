Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Fri, 1 May 2020 21:37:34 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 5/7] zbd: consolidate zone mutex initialisation
Message-ID: <20200501183734.GA32674@avx2>
References: <20200430124050.20146-1-adobriyan@gmail.com>
 <20200430124050.20146-5-adobriyan@gmail.com>
 <BY5PR04MB69009FD94999AC765AA1E25AE7AB0@BY5PR04MB6900.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BY5PR04MB69009FD94999AC765AA1E25AE7AB0@BY5PR04MB6900.namprd04.prod.outlook.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, May 01, 2020 at 01:44:26AM +0000, Damien Le Moal wrote:
> On 2020/04/30 21:41, Alexey Dobriyan wrote:
> > Another mutex is coming!
> 
> That is not very descriptive at all.
> What the patch does is to make the per zone mutex initialization code common
> between init_zone_info() and parse_zone_info(), moving it to create_zone_info().

> > @@ -546,11 +532,27 @@ static int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
> >  		return -EINVAL;
> >  	}
> >  
> > -	if (ret == 0) {
> > -		f->zbd_info->model = zbd_model;
> > -		f->zbd_info->max_open_zones = td->o.global_max_open_zones;
> > +	if (ret)
> > +		return ret;
> > +
> > +	zbd = f->zbd_info;
> > +	zbd->model = zbd_model;
> > +	zbd->max_open_zones = td->o.global_max_open_zones;
> > +	{
> > +		pthread_mutexattr_t attr;
> 
> If you move this declaration to the beginning of zbd_create_zone_info(), you can
> avoid this block code, which does not look pretty.

It is done on purpose, to move declaration closer to usage.
fio is built with -std=gnu99 _and_ -Wdeclaration-after-statement which
prevents

	a = b;
	int c;
	c = d;

modern style of declaration.

> > +		pthread_mutexattr_init(&attr);
> > +		pthread_mutexattr_setpshared(&attr, true);
> > +		pthread_mutex_init(&zbd->mutex, &attr);
> > +		pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
> > +		for (uint32_t z = 0; z < zbd->nr_zones; z++) {
> > +			struct fio_zone_info *zi = &zbd->zone_info[z];
> > +
> > +			pthread_mutex_init(&zi->mutex, &attr);
> > +		}
> > +		pthread_mutexattr_destroy(&attr);
> >  	}
> > -	return ret;
> > +	return 0;
> >  }
> >  
> >  void zbd_free_zone_info(struct fio_file *f)
> > 
> 
> With the nits above fixed, Looks good to me.
> 
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

