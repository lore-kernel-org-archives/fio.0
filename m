Return-Path: <prvs=8739f553a=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v2] options: Add thinktime_iotime option
Date: Fri, 3 Sep 2021 21:38:01 +0000
Message-ID: <20210903213801.m46bdht67ukz7blm@shindev>
References: <20210903083719.1757299-1-shinichiro.kawasaki@wdc.com>
 <ef8b37bd-d743-5e89-eb98-c619523c34e2@kernel.dk>
In-Reply-To: <ef8b37bd-d743-5e89-eb98-c619523c34e2@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0D64DCF337D71F478BCB123200FE8B98@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On Sep 03, 2021 / 06:38, Jens Axboe wrote:
> On 9/3/21 2:37 AM, Shin'ichiro Kawasaki wrote:
> > diff --git a/options.c b/options.c
> > index 8c2ab7cc..3fe1e6bd 100644
> > --- a/options.c
> > +++ b/options.c
> > @@ -3688,6 +3688,20 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D =
{
> >  		},
> >  		.parent =3D "thinktime",
> >  	},
> > +	{
> > +		.name	=3D "thinktime_iotime",
> > +		.lname	=3D "Thinktime interval",
> > +		.type	=3D FIO_OPT_INT,
> > +		.off1	=3D offsetof(struct thread_options, thinktime_iotime),
> > +		.help	=3D "IO time interval between 'thinktime'",
> > +		.is_time =3D 1,
> > +		.is_seconds =3D 1,
> > +		.def	=3D "0",
> > +		.parent	=3D "thinktime",
> > +		.hide	=3D 1,
> > +		.category =3D FIO_OPT_C_IO,
> > +		.group	=3D FIO_OPT_G_THINKTIME,
> > +	},
>=20
> Please line these up nicely as is done elsewhere.

Ah, the order of the members are diffferent from others. I will move a few
members to make the order same as others.

>=20
> Apart from that, this looks fine. Could really use an example job
> though, and an improvement in the explanation. The commit message looks
> great, but then the doc additions are pretty lackluster. Maybe steal a
> bit of the text you wrote from the commit message and put it in the
> shipped documentation?

I will improve the descriptions of the new option in fio.1 and HOWTO, copyi=
ng
some of the commit message. Also I will add "for example" option usage in t=
he
descriptions.

Thank you for your review.

--=20
Best Regards,
Shin'ichiro Kawasaki=

