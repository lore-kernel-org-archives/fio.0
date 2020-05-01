Return-Path: <prvs=383ebf04e=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 6/7] fio: parse "io_size=1%"
Date: Fri, 1 May 2020 01:51:31 +0000
Message-ID: 
 <BY5PR04MB69006B1BE963DE08412F960FE7AB0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200430124050.20146-1-adobriyan@gmail.com>
 <20200430124050.20146-6-adobriyan@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/04/30 21:41, Alexey Dobriyan wrote:=0A=
> The following config:=0A=
> =0A=
> 	zonemode=3Dzbd=0A=
=0A=
I do not think this problem to be restricted to zonemode=3Dzbd, no=0A=
If so, may be remove this from the example config.=0A=
=0A=
> 	size=3D1%=0A=
> 	io_size=3D1%=0A=
> =0A=
> will generate essentially infinite loop, because io_size is (2^64-1)-1.=
=0A=
> =0A=
> Parse io_size as percentage to avoid it.=0A=
> =0A=
> Note: there is different bug if size% !=3D io_size% and io_size is ignore=
d=0A=
> but it will be separate patch.=0A=
> =0A=
> Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>=0A=
> ---=0A=
>  cconv.c          |  1 +=0A=
>  options.c        | 17 +++++++++++++++++=0A=
>  thread_options.h |  4 ++++=0A=
>  3 files changed, 22 insertions(+)=0A=
> =0A=
> diff --git a/cconv.c b/cconv.c=0A=
> index 48218dc4..d547ae11 100644=0A=
> --- a/cconv.c=0A=
> +++ b/cconv.c=0A=
> @@ -102,6 +102,7 @@ void convert_thread_options_to_cpu(struct thread_opti=
ons *o,=0A=
>  	o->size =3D le64_to_cpu(top->size);=0A=
>  	o->io_size =3D le64_to_cpu(top->io_size);=0A=
>  	o->size_percent =3D le32_to_cpu(top->size_percent);=0A=
> +	o->io_size_percent =3D le32_to_cpu(top->io_size_percent);=0A=
>  	o->fill_device =3D le32_to_cpu(top->fill_device);=0A=
>  	o->file_append =3D le32_to_cpu(top->file_append);=0A=
>  	o->file_size_low =3D le64_to_cpu(top->file_size_low);=0A=
> diff --git a/options.c b/options.c=0A=
> index 306874ea..c5d33d1a 100644=0A=
> --- a/options.c=0A=
> +++ b/options.c=0A=
> @@ -1475,6 +1475,22 @@ static int str_size_cb(void *data, unsigned long l=
ong *__val)=0A=
>  	return 0;=0A=
>  }=0A=
>  =0A=
> +static int str_io_size_cb(void *data, unsigned long long *__val)=0A=
> +{=0A=
> +	struct thread_data *td =3D cb_data_to_td(data);=0A=
> +	unsigned long long v =3D *__val;=0A=
> +=0A=
> +	if (parse_is_percent(v)) {=0A=
> +		td->o.io_size =3D 0;=0A=
> +		td->o.io_size_percent =3D -1ULL - v;=0A=
> +		dprint(FD_PARSE, "SET io_size_percent %d\n",=0A=
> +					td->o.io_size_percent);=0A=
> +	} else=0A=
> +		td->o.io_size =3D v;=0A=
> +=0A=
> +	return 0;=0A=
> +}=0A=
> +=0A=
>  static int str_write_bw_log_cb(void *data, const char *str)=0A=
>  {=0A=
>  	struct thread_data *td =3D cb_data_to_td(data);=0A=
> @@ -2042,6 +2058,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D {=
=0A=
>  		.alias	=3D "io_limit",=0A=
>  		.lname	=3D "IO Size",=0A=
>  		.type	=3D FIO_OPT_STR_VAL,=0A=
> +		.cb	=3D str_io_size_cb,=0A=
>  		.off1	=3D offsetof(struct thread_options, io_size),=0A=
>  		.help	=3D "Total size of I/O to be performed",=0A=
>  		.interval =3D 1024 * 1024,=0A=
> diff --git a/thread_options.h b/thread_options.h=0A=
> index 4078d46f..197d2ec2 100644=0A=
> --- a/thread_options.h=0A=
> +++ b/thread_options.h=0A=
> @@ -83,6 +83,7 @@ struct thread_options {=0A=
>  	unsigned long long size;=0A=
>  	unsigned long long io_size;=0A=
>  	unsigned int size_percent;=0A=
> +	unsigned int io_size_percent;=0A=
>  	unsigned int fill_device;=0A=
>  	unsigned int file_append;=0A=
>  	unsigned long long file_size_low;=0A=
> @@ -377,6 +378,7 @@ struct thread_options_pack {=0A=
>  	uint64_t size;=0A=
>  	uint64_t io_size;=0A=
>  	uint32_t size_percent;=0A=
> +	uint32_t io_size_percent;=0A=
>  	uint32_t fill_device;=0A=
>  	uint32_t file_append;=0A=
>  	uint32_t unique_filename;=0A=
> @@ -456,6 +458,8 @@ struct thread_options_pack {=0A=
>  	struct zone_split zone_split[DDIR_RWDIR_CNT][ZONESPLIT_MAX];=0A=
>  	uint32_t zone_split_nr[DDIR_RWDIR_CNT];=0A=
>  =0A=
> +	uint8_t pad1[4];=0A=
> +=0A=
>  	fio_fp64_t zipf_theta;=0A=
>  	fio_fp64_t pareto_h;=0A=
>  	fio_fp64_t gauss_dev;=0A=
> =0A=
=0A=
I think you need to add the option field to struct thread_options_pack too,=
=0A=
otherwise the client/server case will break/not handle the option as expect=
ed.=0A=
There are also some changes in cconv.c needed. "git grep size_percent" and =
you=0A=
will get where that is needed.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

