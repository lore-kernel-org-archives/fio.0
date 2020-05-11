Return-Path: <prvs=393ca294f=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 7/9] fio: parse "io_size=1%"
Date: Mon, 11 May 2020 01:20:32 +0000
Message-ID: 
 <BY5PR04MB69004E2F74EE3F2588959212E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200505175634.2517-1-adobriyan@gmail.com>
 <20200505175634.2517-7-adobriyan@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/05/06 2:57, Alexey Dobriyan wrote:=0A=
> The following config:=0A=
> =0A=
> 	size=3D1%=0A=
> 	io_size=3D1%=0A=
> =0A=
> will generate essentially infinite loop, because io_size is set to (2^64-=
1)-1.=0A=
> =0A=
> Parse io_size as percentage to avoid the bug.=0A=
> =0A=
> Note: if size% !=3D io_size%, io_size is ignored but it is separate bug.=
=0A=
> =0A=
> Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>=0A=
> ---=0A=
>  cconv.c          |  2 ++=0A=
>  options.c        | 17 +++++++++++++++++=0A=
>  server.h         |  2 +-=0A=
>  thread_options.h |  4 ++++=0A=
>  4 files changed, 24 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/cconv.c b/cconv.c=0A=
> index 48218dc4..48b0db9e 100644=0A=
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
> @@ -366,6 +367,7 @@ void convert_thread_options_to_net(struct thread_opti=
ons_pack *top,=0A=
>  	top->iodepth_batch_complete_max =3D cpu_to_le32(o->iodepth_batch_comple=
te_max);=0A=
>  	top->serialize_overlap =3D cpu_to_le32(o->serialize_overlap);=0A=
>  	top->size_percent =3D cpu_to_le32(o->size_percent);=0A=
> +	top->io_size_percent =3D cpu_to_le32(o->io_size_percent);=0A=
>  	top->fill_device =3D cpu_to_le32(o->fill_device);=0A=
>  	top->file_append =3D cpu_to_le32(o->file_append);=0A=
>  	top->ratecycle =3D cpu_to_le32(o->ratecycle);=0A=
> diff --git a/options.c b/options.c=0A=
> index 47b3b765..3d0c3a84 100644=0A=
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
=0A=
I do not see where f->io_size is set using td->o.io_size_percent. Isn't it=
=0A=
needed to set it somewhere in filesetup.c ?=0A=
=0A=
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
> diff --git a/server.h b/server.h=0A=
> index 279b6917..de01a5c8 100644=0A=
> --- a/server.h=0A=
> +++ b/server.h=0A=
> @@ -48,7 +48,7 @@ struct fio_net_cmd_reply {=0A=
>  };=0A=
>  =0A=
>  enum {=0A=
> -	FIO_SERVER_VER			=3D 82,=0A=
> +	FIO_SERVER_VER			=3D 83,=0A=
>  =0A=
>  	FIO_SERVER_MAX_FRAGMENT_PDU	=3D 1024,=0A=
>  	FIO_SERVER_MAX_CMD_MB		=3D 2048,=0A=
> diff --git a/thread_options.h b/thread_options.h=0A=
> index b0b493e4..4979ed79 100644=0A=
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
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

