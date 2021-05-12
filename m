Return-Path: <prvs=7598eea54=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: Re: setup vs init ioengine callback order
Date: Wed, 12 May 2021 08:38:29 +0000
Message-ID: <YJuUA6hVVgdtHxZ7@x1-carbon.lan>
References: <YIhe2FkdoJMnXoHl@x1-carbon.lan>
In-Reply-To: <YIhe2FkdoJMnXoHl@x1-carbon.lan>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D39146B67908314F828B5C8EB4D18F4A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Tue, Apr 27, 2021 at 08:58:32PM +0200, Niklas Cassel wrote:
> Hello there,
>=20
>=20
> If running fio with --create_serialize=3D1 and --numjobs=3D2
>=20
> ->setup() callback will be called for each thread,
> before the ->init() callback is called for each thread:
>=20
> my_fio_setup: td: 0x7eff72d6a000
> my_fio_setup: td: 0x7eff72daea70
> my_fio_init: td: 0x7eff72d6a000
> my_fio_init: td: 0x7eff72daea70
>=20
> However, if running fio with --create_serialize=3D0 and --numjobs=3D2
> you will instead see that ->init() callback will be called for each
> thread, before the ->setup() callback is called for each thread:
>=20
> my_fio_init: td: 0x7eff72d6a000
> my_fio_init: td: 0x7eff72daea70
> my_fio_setup: td: 0x7eff72d6a000
> my_fio_setup: td: 0x7eff72daea70
>=20
>=20
> This is because, in backend.c:thread_main() looks like this:
>=20
> ...
>=20
>         if (!init_iolog(td))
>                 goto err;
>=20
>         if (td_io_init(td))
>                 goto err;
>=20
>         if (init_io_u(td))
>                 goto err;
>=20
> ...
>=20
>         if (!o->create_serialize && setup_files(td))
>                 goto err;
>=20
>         if (!init_random_map(td))
>                 goto err;
>=20
> ...
>=20
>=20
>=20
> td_io_init() will call td->io_ops->init(td) and setup_files() will
> call td->io_ops->setup(td).
>=20
> Is it just me who thinks that it is extremely confusing for an ioengine
> developer to not be able to know if the ->setup() or ->init() callback
> will be called first?
>=20
> Should we perhaps consider moving the
>=20
>         if (!o->create_serialize && setup_files(td))
>                 goto err;
>=20
> chunk so that it is before the td_io_init() call?
>=20
> That way, ->setup() would always be called before ->init()
> (which is the default, since --create_serialize defaults to 1),
> no matter what value --create_serialize is set to.
>=20
>=20
> Kind regards,
> Niklas

Hello Jens,

any thoughts on this?


Kind regards,
Niklas=

