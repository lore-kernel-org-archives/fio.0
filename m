Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Fri, 22 May 2020 01:27:58 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 6/9] zbd: consolidate zone mutex initialisation
Message-ID: <20200521222758.GB7915@avx2>
References: <20200505175634.2517-1-adobriyan@gmail.com>
 <20200505175634.2517-6-adobriyan@gmail.com>
 <BY5PR04MB690046CB592B1B01E93B18B5E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
 <20200521214438.GA5980@avx2>
 <BY5PR04MB6900A600016652B356128850E7B70@BY5PR04MB6900.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BY5PR04MB6900A600016652B356128850E7B70@BY5PR04MB6900.namprd04.prod.outlook.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Thu, May 21, 2020 at 10:02:09PM +0000, Damien Le Moal wrote:
> On 2020/05/22 6:44, Alexey Dobriyan wrote:
> > On Mon, May 11, 2020 at 01:16:04AM +0000, Damien Le Moal wrote:
> >> On 2020/05/06 2:56, Alexey Dobriyan wrote:
> >>> Initialise everything that is not write pointers coming from device or
> >>> faked separatedly.
> >>
> >> s/Initialise/Initialize
> >> s/separatedly/separately
> > 
> >>  	assert(td->o.zone_mode == ZONE_MODE_ZBD);
> >>> @@ -546,11 +533,25 @@ static int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
> >>>  		return -EINVAL;
> >>>  	}
> >>>  
> >>> -	if (ret == 0) {
> >>> -		f->zbd_info->model = zbd_model;
> >>> -		f->zbd_info->max_open_zones = td->o.max_open_zones;
> >>> +	if (ret)
> >>> +		return ret;
> >>> +
> >>> +	zbd = f->zbd_info;
> >>> +	zbd->model = zbd_model;
> >>> +	zbd->max_open_zones = td->o.max_open_zones;
> >>> +
> >>> +	pthread_mutexattr_init(&attr);
> >>> +	pthread_mutexattr_setpshared(&attr, true);
> >>> +	pthread_mutex_init(&zbd->mutex, &attr);
> >>> +	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
> >>> +	for (uint32_t z = 0; z < zbd->nr_zones; z++) {
> >>> +		struct fio_zone_info *zi = &zbd->zone_info[z];
> >>> +
> >>> +		pthread_mutex_init(&zi->mutex, &attr);
> >>>  	}
> >>> -	return ret;
> >>> +	pthread_mutexattr_destroy(&attr);
> >>> +
> >>> +	return 0;
> >>>  }
> >>>  
> >>>  void zbd_free_zone_info(struct fio_file *f)
> >>>
> >>
> >> On a very large drive (e.g. 20TB SMR), we have in excess of 70000 zones. Having
> >> to loop over all of them again will start to be painful and likely slow down (a
> >> little) startup. And going forward with ever increasing disk capacity, this will
> >> get even worse. So not sure if this patch makes much sense.
> > 
> > It separates hw-specific code (reading write pointers) from fio-specific
> > code.
> 
> I appreciate the cleanup the patch does, but that does not address my concern
> about startup time.
> 
> > Iterating can be made faster by going over zone in [->min_zone, ->max_zone)
> > only, but I didn't look at it.
> 
> That would make things very complicated as the zbd_info zone array would end
> being sparse or not all zones initialized in it...

It is more! Don't need to allocate memory for unused trailing zones. :^)

In the future _this_ loop will do more work:

	->mutex
	->write_mutex (divide and conquer writes and appends)
	second ->wp
	per zone seed
	per zone generator state
	write list

> What about replacing the mutex initialization helper doing the entire loop again
> over all zones with one doing a single zone mutex initialization:
> 
> init_zone_mutex(zone, &attr)
> 
> That would cleanup nicely init_zone_info() & parse_zone_info() too.

OK, it is too late here to think.
I'll send what's doesn't raise questions for the release.

