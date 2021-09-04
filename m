Return-Path: <fio-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:59124 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbhIDJCJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 4 Sep 2021 05:02:09 -0400
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v2] options: Add thinktime_iotime option
Date: Sat, 4 Sep 2021 09:01:05 +0000
Message-ID: <20210904090104.7ecb4wxloyzecqrt@shindev>
References: <20210903083719.1757299-1-shinichiro.kawasaki@wdc.com>
 <ef8b37bd-d743-5e89-eb98-c619523c34e2@kernel.dk>
 <20210903213801.m46bdht67ukz7blm@shindev>
 <9ddf62e1-6f8e-0f20-1ef5-9b0426b15d34@kernel.dk>
In-Reply-To: <9ddf62e1-6f8e-0f20-1ef5-9b0426b15d34@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <34343BACC7EC0241850ACA0D34B5AD8B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>

On Sep 03, 2021 / 18:58, Jens Axboe wrote:
> On 9/3/21 3:38 PM, Shinichiro Kawasaki wrote:
> > On Sep 03, 2021 / 06:38, Jens Axboe wrote:
> >> On 9/3/21 2:37 AM, Shin'ichiro Kawasaki wrote:
> >>> diff --git a/options.c b/options.c
> >>> index 8c2ab7cc..3fe1e6bd 100644
> >>> --- a/options.c
> >>> +++ b/options.c
> >>> @@ -3688,6 +3688,20 @@ struct fio_option fio_options[FIO_MAX_OPTS] =
=3D {
> >>>  		},
> >>>  		.parent =3D "thinktime",
> >>>  	},
> >>> +	{
> >>> +		.name	=3D "thinktime_iotime",
> >>> +		.lname	=3D "Thinktime interval",
> >>> +		.type	=3D FIO_OPT_INT,
> >>> +		.off1	=3D offsetof(struct thread_options, thinktime_iotime),
> >>> +		.help	=3D "IO time interval between 'thinktime'",
> >>> +		.is_time =3D 1,
> >>> +		.is_seconds =3D 1,
> >>> +		.def	=3D "0",
> >>> +		.parent	=3D "thinktime",
> >>> +		.hide	=3D 1,
> >>> +		.category =3D FIO_OPT_C_IO,
> >>> +		.group	=3D FIO_OPT_G_THINKTIME,
> >>> +	},
> >>
> >> Please line these up nicely as is done elsewhere.
> >=20
> > Ah, the order of the members are diffferent from others. I will move a
> > few members to make the order same as others.
>=20
> I didn't notice the ordering, but just to be clear, I'm just referring
> to the tabbing so the '=3D' line up. But if they are out of order, please
> do correct that too.

Thanks for the clarification. I will fix the order. As for tabbing, I found=
 that
'=3D' is not lined up in existing members of fio_options[] either. Here I q=
uote an
example from "startdelay" option.

	{
		.name	=3D "startdelay",
		.lname	=3D "Start delay",
		.type	=3D FIO_OPT_STR_VAL_TIME,
		.off1	=3D offsetof(struct thread_options, start_delay),
		.off2	=3D offsetof(struct thread_options, start_delay_high),
		.help	=3D "Only start job when this period has passed",
		.def	=3D "0",
		.is_seconds =3D 1,
		.is_time =3D 1,
		.category =3D FIO_OPT_C_GENERAL,
		.group	=3D FIO_OPT_G_RUNTIME,
	},

The number of tab in front of '=3D' is single for all members. On the other=
 hand,
some of the members have too long name: such as "is_time", "is_seconds" or
"category". So '=3D' can not be lined up for them. I think it would be the =
better
to allow unaligned '=3D' style for new options if they have the long name m=
embers.

After fixing the order of the members of the new option, that part will loo=
k as
follows:

+		.name	=3D "thinktime_iotime",
+		.lname	=3D "Thinktime interval",
+		.type	=3D FIO_OPT_INT,
+		.off1	=3D offsetof(struct thread_options, thinktime_iotime),
+		.help	=3D "IO time interval between 'thinktime'",
+		.def	=3D "0",
+		.parent	=3D "thinktime",
+		.hide	=3D 1,
+		.is_seconds =3D 1,
+		.is_time =3D 1,
+		.category =3D FIO_OPT_C_IO,
+		.group	=3D FIO_OPT_G_THINKTIME,

The unaligned '=3D's will be gathered at the last part, so I wish it does n=
ot look
so messy.

>=20
> >> Apart from that, this looks fine. Could really use an example job
> >> though, and an improvement in the explanation. The commit message look=
s
> >> great, but then the doc additions are pretty lackluster. Maybe steal a
> >> bit of the text you wrote from the commit message and put it in the
> >> shipped documentation?
> >=20
> > I will improve the descriptions of the new option in fio.1 and HOWTO,
> > copying some of the commit message. Also I will add "for example"
> > option usage in the descriptions.
>=20
> Sounds good, thanks!
>=20
> --=20
> Jens Axboe
>=20

--=20
Best Regards,
Shin'ichiro Kawasaki

