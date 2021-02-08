Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Mon, 8 Feb 2021 18:53:37 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] zbd: support 'z' suffix for zone granularity
Message-ID: <20210208155337.GA26078@localhost.localdomain>
References: <20210204083220.GA10648@localhost.localdomain>
 <MN2PR04MB5951459146F5244AD7DC6A13E1B29@MN2PR04MB5951.namprd04.prod.outlook.com>
 <20210208144320.GA10115@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210208144320.GA10115@localhost.localdomain>
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Mon, Feb 08, 2021 at 05:43:20PM +0300, Alexey Dobriyan wrote:
> On Fri, Feb 05, 2021 at 12:53:32AM +0000, Dmitry Fomichev wrote:
> > I like the general idea of this patch. Adding zone units looks useful,
> > especially for ZNS workloads.
> 
> OK -- tests, wording.
> 
> > > --- a/filesetup.c
> > > +++ b/filesetup.c
> > > @@ -1029,6 +1029,35 @@ int setup_files(struct thread_data *td)
> > >  	if (o->read_iolog_file)
> > >  		goto done;
> > > 
> > > +	if (td->o.zone_mode == ZONE_MODE_ZBD) {
> > 
> > What about ZONE_MODE_STRIDED? Shouldn't 'z' suffix be enabled for it too?
> 
> I converted zoneskip= as well, but the code asserts somewhere else.
> I didn't figure why exactly. zoneskip= and strided mode can be enabled
> separatedly.
> 
> > > +		struct fio_file *f;
> > > +		int i;
> > > +
> > > +		err = zbd_init_files(td);
> > > +		if (err)
> > > +			goto err_out;
> > > +
> > 
> > zbd_init_files() is only called once. Why not fold the loop below into zbd_init_files()
> > since the code is ZBD-specific?
> 
> OK.

I take that back!

The reason for a split is that size= and offset= and io_size= must be
available before those checks:

	/*
	 * now file sizes are known, so we can set ->io_size. if size= is
	 * not given, ->io_size is just equal to ->real_file_size. if size
	 * is given, ->io_size is size / nr_files.
	 */

so the init is done in 3 parts:

	optionally create/alloc f->zbd_info

	recalculate if size=/io_size=/offset=/... is supplied in zones

	...

	calculate ->min_zone/->max_zone, etc

but size recalculation is necessary for zonemode=strided as well.

