Return-Path: <aherrmann@suse.com>
Date: Mon, 31 Aug 2020 08:03:59 +0200
From: Andreas Herrmann <aherrmann@suse.com>
Subject: Re: [PATCH 1/2] thread_options: Add cgroup_use_bfq
Message-ID: <20200831060359.GL6041@suselix>
References: <20200828100230.GG6041@suselix>
 <20200828100435.GH6041@suselix>
 <DF4PR8401MB10491D443BCBDD8B9586F4FFAB520@DF4PR8401MB1049.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <DF4PR8401MB10491D443BCBDD8B9586F4FFAB520@DF4PR8401MB1049.NAMPRD84.PROD.OUTLOOK.COM>
Return-Path: aherrmann@suse.com
MIME-Version: 1.0
To: "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, Aug 28, 2020 at 06:36:56PM +0000, Elliott, Robert (Servers) wrote:
>=20
>=20
> > -----Original Message-----
> > From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> On Behalf
> > Of Andreas Herrmann
> > Sent: Friday, August 28, 2020 5:05 AM
> > To: Jens Axboe <axboe@kernel.dk>
> > Cc: fio@vger.kernel.org
> > Subject: [PATCH 1/2] thread_options: Add cgroup_use_bfq
> >=20
> ...
> > @@ -593,11 +594,13 @@ struct thread_options_pack {
> >  	uint8_t profile[FIO_TOP_STR_MAX];
> >=20
> >  	/*
> > -	 * blkio cgroup support
> > +	 * (blk)io cgroup support
> >  	 */
> >  	uint8_t cgroup[FIO_TOP_STR_MAX];
> >  	uint32_t cgroup_weight;
> >  	uint32_t cgroup_nodelete;
> > +	uint32_t cgroup_use_bfq;
> > +	uint32_t padding;       /* remove when possible to maintain alignment=
 */
> >=20
> >  	uint32_t uid;
> >  	uint32_t gid;
>=20
> Since the structure already has three pad fields:
>         uint32_t pad;
>=20
>         uint64_t size;
> 	...
>         uint32_t pad2;
>         uint64_t rand_seed;
> 	...
>         uint32_t pad3;
>         fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
>=20
> pad4 would seem like the natural name for another padding field, and
> the comment doesn't seem necessary.

Good point.
I'll modify my patch.

--=20
Regards,
Andreas

SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer (HRB 36809, AG N=C3=BCrnberg)


