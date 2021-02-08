Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Mon, 8 Feb 2021 17:43:20 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] zbd: support 'z' suffix for zone granularity
Message-ID: <20210208144320.GA10115@localhost.localdomain>
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
> I like the general idea of this patch. Adding zone units looks useful,
> especially for ZNS workloads.

OK -- tests, wording.

> > --- a/filesetup.c
> > +++ b/filesetup.c
> > @@ -1029,6 +1029,35 @@ int setup_files(struct thread_data *td)
> >  	if (o->read_iolog_file)
> >  		goto done;
> > 
> > +	if (td->o.zone_mode == ZONE_MODE_ZBD) {
> 
> What about ZONE_MODE_STRIDED? Shouldn't 'z' suffix be enabled for it too?

I converted zoneskip= as well, but the code asserts somewhere else.
I didn't figure why exactly. zoneskip= and strided mode can be enabled
separatedly.

> > +		struct fio_file *f;
> > +		int i;
> > +
> > +		err = zbd_init_files(td);
> > +		if (err)
> > +			goto err_out;
> > +
> 
> zbd_init_files() is only called once. Why not fold the loop below into zbd_init_files()
> since the code is ZBD-specific?

OK.

> > +		for_each_file(td, f, i) {
> > +			struct zoned_block_device_info *zbd = f->zbd_info;
> > +
> > +			if (!zbd)
> > +				continue;
> > +
> > +			if (td->o.size_nz > 0) {
> > +				td->o.size = td->o.size_nz * zbd->zone_size;
> > +			}
> > +			if (td->o.io_size_nz > 0) {
> > +				td->o.io_size = td->o.io_size_nz * zbd-
> > >zone_size;
> > +			}
> > +			if (td->o.start_offset_nz > 0) {
> > +				td->o.start_offset = td->o.start_offset_nz *
> > zbd->zone_size;
> > +			}
> > +			if (td->o.offset_increment_nz > 0) {
> > +				td->o.offset_increment = td-
> > >o.offset_increment_nz * zbd->zone_size;
> > +			}
> > +		}
> > +	}

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
> 
> > +
> > +		errno = 0;
> > +		val = strtoul(ptr, &ep, 10);
> > +		if (errno == 0 && ep != ptr) {
> > +			switch (*ep) {
> > +			case 'z':
> > +				val = ZONE_BASE_VAL + (uint32_t)val;
> > +				break;
> > +
> > +			default:
> > +				ret = 1;
> > +				break;
> > +			}
> > +			val_store(ullp, val, o->off1, 0, data, o);
> > +			ret = 0;
> > +		} else {
> > +			ret = 1;
> > +		}
> > +		if (ret) {
> > +			return ret;
> > +		}
> > +
> > +		ret = f(data, &val);
> > +		break;
> > +	}
> >  	case FIO_OPT_DEPRECATED:
> >  		ret = 1;
> >  		fallthrough;

> > --- a/thread_options.h
> > +++ b/thread_options.h
> > @@ -83,13 +83,16 @@ struct thread_options {
> >  	unsigned long long size;
> >  	unsigned long long io_size;
> >  	unsigned int size_percent;
> > +	unsigned int size_nz;
> >  	unsigned int io_size_percent;
> > +	unsigned int io_size_nz;
> >  	unsigned int fill_device;
> >  	unsigned int file_append;
> >  	unsigned long long file_size_low;
> >  	unsigned long long file_size_high;
> >  	unsigned long long start_offset;
> >  	unsigned long long start_offset_align;
> > +	unsigned int start_offset_nz;
> > 
> >  	unsigned long long bs[DDIR_RWDIR_CNT];
> >  	unsigned long long ba[DDIR_RWDIR_CNT];
> > @@ -315,6 +318,7 @@ struct thread_options {
> >  	unsigned int gid;
> > 
> >  	unsigned int offset_increment_percent;
> > +	unsigned int offset_increment_nz;
> >  	unsigned long long offset_increment;
> >  	unsigned long long number_ios;
> > 
> > @@ -384,14 +388,19 @@ struct thread_options_pack {
> >  	uint64_t size;
> >  	uint64_t io_size;
> >  	uint32_t size_percent;
> > +	uint32_t size_nz;
> >  	uint32_t io_size_percent;
> > +	uint32_t io_size_nz;
> >  	uint32_t fill_device;
> >  	uint32_t file_append;
> >  	uint32_t unique_filename;
> > +	uint32_t _;
> 
> It seems that the addition of the padding above is unrelated
> to this patch. This could be made a separate patch though
> along with some explanation. Also, I think it is best to follow
> the kernel style for naming of multiple pad members in
> a struct -
> uint32_t pad1;
> ....
> uint32_t pad2;
> , etc.
> 
> >  	uint64_t file_size_low;
> >  	uint64_t file_size_high;
> >  	uint64_t start_offset;
> >  	uint64_t start_offset_align;
> > +	uint32_t start_offset_nz;
> > +	uint32_t __;
> 
> uint32_t pad2;
> 
> > 
> >  	uint64_t bs[DDIR_RWDIR_CNT];
> >  	uint64_t ba[DDIR_RWDIR_CNT];
> > @@ -464,8 +473,6 @@ struct thread_options_pack {
> >  	struct zone_split zone_split[DDIR_RWDIR_CNT][ZONESPLIT_MAX];
> >  	uint32_t zone_split_nr[DDIR_RWDIR_CNT];
> > 
> > -	uint8_t pad1[4];
> 
> This change doesn't look related to the patch either.
> 
> > -
> >  	fio_fp64_t zipf_theta;
> >  	fio_fp64_t pareto_h;
> >  	fio_fp64_t gauss_dev;
> > @@ -616,12 +623,14 @@ struct thread_options_pack {
> >  	uint32_t gid;
> > 
> >  	uint32_t offset_increment_percent;
> > +	uint32_t offset_increment_nz;
> >  	uint64_t offset_increment;
> >  	uint64_t number_ios;
> > 
> >  	uint64_t latency_target;
> >  	uint64_t latency_window;
> >  	uint64_t max_latency;
> > +	uint32_t ___;
> 
> Why is this needed?

There are compile failure minefield in libfio.c.
Padding needs to be redone any time new options are added.

