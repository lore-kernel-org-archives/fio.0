Return-Path: <prvs=36634da1a=shinichiro.kawasaki@wdc.com>
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 3/3] zbd: Ensure first I/O is write for random read/write
 to sequential zones
Date: Tue, 14 Apr 2020 03:35:18 +0000
Message-ID: <20200414033517.wps6zihay7rmoevw@shindev.dhcp.fujisawa.hgst.com>
References: <20200413212111.GA19503@avx2>
In-Reply-To: <20200413212111.GA19503@avx2>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <676A2DAE07762F46A2064789F6A381E4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "damien.lemoaal@wdc.com" <damien.lemoaal@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Apr 14, 2020 / 00:21, Alexey Dobriyan wrote:
> > zbd_adjust_block
>=20
>=20
> > +	if (td_rw(td) && !f->zbd_info->sectors_with_data
> > +	    && !td->o.read_beyond_wp)
> > +		io_u->ddir =3D DDIR_WRITE;
>=20
> Oh, you've noticed this too. :-)
>=20
> This will issue the first write with wrong length if bs[DDIR_READ] !=3D b=
s[DDIR_WRITE].

Hi Alexey, thanks for pointing out that.

> Adjusting in zbd_adjust_block() is too late.

Hmm, you are right. To align the new ddir with buflen and offset, need to c=
all
get_next_offset() and get_next_buflen() again from zbd_adjust_block(). Thos=
e
functions are now static to io_u.c and will have duplicate code...

It is not ideal to add more zoned block device related code to io_u.c, but =
now I
think it is the simplest to check conditions and enforce ddir=3DDDIR_WRITE =
in
set_rw_ddir() of io_u.c. It modifies ddir before get_next_offset() and
get_next_buflen() calls then makes io_u fields consistent. Will create a pa=
tch
to ask opinions on this list.

--=20
Best Regards,
Shin'ichiro Kawasaki=

