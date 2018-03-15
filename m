Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CY1PR0401MB1116B5FBEFE751DAE8A07A3C81D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
References: <CY1PR0401MB1116B5FBEFE751DAE8A07A3C81D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 15 Mar 2018 06:36:03 +0000
Message-ID: <CALjAwxhS++UF+LG166gR_tQNBsJHa-pTUJfHck_FjcN8DUtY2g@mail.gmail.com>
Subject: Re: Patch to add read and write fua bit options to the SG engine
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kris Davis <Kris.Davis@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi,

On 15 March 2018 at 03:59, Kris Davis <Kris.Davis@wdc.com> wrote:
> I like to submit the patch below to add read and write fua bit options to=
 the SG engine.  It adds a readfua=3Dbool, and writefua=3Dbool options in t=
he SG engine, which causes the "force unit access" bits to be set in the re=
ad and write operations respectively.  I patterned the code changes from wh=
at I found in the libaio engine option code.  So, I also added a "__FIO_OPT=
_G_SG" enum to optgroup.h, which seemed to follow the pattern - but I reall=
y don't understand where or how the enum settings values in the options are=
 used, so I'm unsure.

If you don't need different I/Os to have different FUA states (if they
were ever supported in the sg ioengine could trims via
unmaps/write_sames be FUA'd?) could you overload direct=3D1 for this
purpose?

--=20
Sitsofe | http://sucs.org/~sits/

On 15 March 2018 at 03:59, Kris Davis <Kris.Davis@wdc.com> wrote:
> I like to submit the patch below to add read and write fua bit options to=
 the SG engine.  It adds a readfua=3Dbool, and writefua=3Dbool options in t=
he SG engine, which causes the "force unit access" bits to be set in the re=
ad and write operations respectively.  I patterned the code changes from wh=
at I found in the libaio engine option code.  So, I also added a "__FIO_OPT=
_G_SG" enum to optgroup.h, which seemed to follow the pattern - but I reall=
y don't understand where or how the enum settings values in the options are=
 used, so I'm unsure.
> Thanks
> Kris Davis
>
>
>
> diff --git a/HOWTO b/HOWTO
> index acb9e97..4f9d26a 100644
> --- a/HOWTO
> +++ b/HOWTO
> @@ -1747,6 +1747,7 @@
>                         :manpage:`read(2)` and :manpage:`write(2)` for as=
ynchronous
>                         I/O. Requires :option:`filename` option to specif=
y either block or
>                         character devices.
> +                       The sg engine includes engine specific options.
>
>                 **null**
>                         Doesn't transfer any data, just pretends to.  Thi=
s is mainly used to
> @@ -2068,6 +2069,17 @@
>         multiple paths exist between the client and the server or in cert=
ain loopback
>         configurations.
>
> +.. option:: readfua=3Dbool : [sg]
> +
> +       With readfua option set to 1, read operations include the
> +       the force unit access (fua) flag.
> +
> +.. option:: writefua=3Dbool : [sg]
> +
> +       With writefua option set to 1, write operations include the
> +       the force unit access (fua) flag.
> +
> +
>  I/O depth
>  ~~~~~~~~~
>
> diff --git a/engines/sg.c b/engines/sg.c
> index 4540b57..f240755 100644
> --- a/engines/sg.c
> +++ b/engines/sg.c
> @@ -12,8 +12,42 @@
>  #include <sys/poll.h>
>
>  #include "../fio.h"
> +#include "../optgroup.h"
>
>  #ifdef FIO_HAVE_SGIO
> +
> +
> +struct sg_options {
> +       void *pad;
> +       unsigned int readfua;
> +       unsigned int writefua;
> +};
> +
> +static struct fio_option options[] =3D {
> +       {
> +               .name   =3D "readfua",
> +               .lname  =3D "sg engine read fua flag support",
> +               .type   =3D FIO_OPT_BOOL,
> +               .off1   =3D offsetof(struct sg_options, readfua),
> +               .help   =3D "Set FUA flag (force unit access) for all Rea=
d operations",
> +               .def    =3D "0",
> +               .category =3D FIO_OPT_C_ENGINE,
> +               .group  =3D FIO_OPT_G_SG,
> +       },
> +       {
> +               .name   =3D "writefua",
> +               .lname  =3D "sg engine write fua flag support",
> +               .type   =3D FIO_OPT_BOOL,
> +               .off1   =3D offsetof(struct sg_options, writefua),
> +               .help   =3D "Set FUA flag (force unit access) for all Wri=
te operations",
> +               .def    =3D "0",
> +               .category =3D FIO_OPT_C_ENGINE,
> +               .group  =3D FIO_OPT_G_SG,
> +       },
> +       {
> +               .name   =3D NULL,
> +       },
> +};
>
>  #define MAX_10B_LBA  0xFFFFFFFFULL
>  #define SCSI_TIMEOUT_MS 30000   // 30 second timeout; currently no metho=
d to override
> @@ -267,6 +301,7 @@
>  static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
>  {
>         struct sg_io_hdr *hdr =3D &io_u->hdr;
> +       struct sg_options *o =3D td->eo;
>         struct sgio_data *sd =3D td->io_ops_data;
>         long long nr_blocks, lba;
>
> @@ -286,6 +321,10 @@
>                         hdr->cmdp[0] =3D 0x28; // read(10)
>                 else
>                         hdr->cmdp[0] =3D 0x88; // read(16)
> +
> +               if (o->readfua)
> +                       hdr->cmdp[1] |=3D 0x08;
> +
>         } else if (io_u->ddir =3D=3D DDIR_WRITE) {
>                 sgio_hdr_init(sd, hdr, io_u, 1);
>
> @@ -294,6 +333,10 @@
>                         hdr->cmdp[0] =3D 0x2a; // write(10)
>                 else
>                         hdr->cmdp[0] =3D 0x8a; // write(16)
> +
> +               if (o->writefua)
> +                       hdr->cmdp[1] |=3D 0x08;
> +
>         } else {
>                 sgio_hdr_init(sd, hdr, io_u, 0);
>                 hdr->dxfer_direction =3D SG_DXFER_NONE;
> @@ -822,6 +865,8 @@
>         .close_file     =3D generic_close_file,
>         .get_file_size  =3D fio_sgio_get_file_size,
>         .flags          =3D FIO_SYNCIO | FIO_RAWIO,
> +       .options        =3D options,
> +       .option_struct_size     =3D sizeof(struct sg_options)
>  };
>
>  #else /* FIO_HAVE_SGIO */
> diff --git a/optgroup.h b/optgroup.h
> index 815ac16..d5e968d 100644
> --- a/optgroup.h
> +++ b/optgroup.h
> @@ -55,10 +55,11 @@
>         __FIO_OPT_G_LIBAIO,
>         __FIO_OPT_G_ACT,
>         __FIO_OPT_G_LATPROF,
> -        __FIO_OPT_G_RBD,
> -        __FIO_OPT_G_GFAPI,
> -        __FIO_OPT_G_MTD,
> +       __FIO_OPT_G_RBD,
> +       __FIO_OPT_G_GFAPI,
> +       __FIO_OPT_G_MTD,
>         __FIO_OPT_G_HDFS,
> +       __FIO_OPT_G_SG,
>         __FIO_OPT_G_NR,
>
>         FIO_OPT_G_RATE          =3D (1ULL << __FIO_OPT_G_RATE),
> @@ -93,6 +94,7 @@
>         FIO_OPT_G_GFAPI         =3D (1ULL << __FIO_OPT_G_GFAPI),
>         FIO_OPT_G_MTD           =3D (1ULL << __FIO_OPT_G_MTD),
>         FIO_OPT_G_HDFS          =3D (1ULL << __FIO_OPT_G_HDFS),
> +       FIO_OPT_G_SG            =3D (1ULL << __FIO_OPT_G_SG),
>         FIO_OPT_G_INVALID       =3D (1ULL << __FIO_OPT_G_NR),
>  };
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Sitsofe | http://sucs.org/~sits/

