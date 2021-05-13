Return-Path: <prvs=760bdaabf=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 2/4] oslib/linux-blkzoned: move sysfs reading into its own
 function
Date: Thu, 13 May 2021 00:14:18 +0000
Message-ID: 
 <DM6PR04MB70816CB70BC355C11E49B407E7519@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210512223615.17239-1-Niklas.Cassel@wdc.com>
 <20210512223615.17239-3-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Niklas Cassel <Niklas.Cassel@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2021/05/13 7:36, Niklas Cassel wrote:=0A=
> From: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> =0A=
> Move the sysfs reading into its own function so that it can be reused.=0A=
> This new function will be reused in an succeeding patch.=0A=
=0A=
s/succeeding/following (or subsequent)=0A=
=0A=
> =0A=
> No functional change intended.=0A=
> =0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> ---=0A=
>  oslib/linux-blkzoned.c | 60 ++++++++++++++++++++++++++----------------=
=0A=
>  1 file changed, 38 insertions(+), 22 deletions(-)=0A=
> =0A=
> diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c=0A=
> index 81e4e7f0..127069ca 100644=0A=
> --- a/oslib/linux-blkzoned.c=0A=
> +++ b/oslib/linux-blkzoned.c=0A=
> @@ -74,12 +74,14 @@ static char *read_file(const char *path)=0A=
>  	return strdup(line);=0A=
>  }=0A=
>  =0A=
> -int blkzoned_get_zoned_model(struct thread_data *td, struct fio_file *f,=
=0A=
> -			     enum zbd_zoned_model *model)=0A=
> +/*=0A=
=0A=
Please add a simple description of what the function does (ok, it is clear =
from=0A=
the function name, but that comes after the comment so it becomes weird to =
read).=0A=
=0A=
> + * Returns NULL on failure.=0A=
> + * Returns a pointer to a string on success.=0A=
> + * The caller is responsible for freeing the memory.=0A=
> + */=0A=
> +static char *blkzoned_get_sysfs_attr(const char *file_name, const char *=
attr)=0A=
>  {=0A=
> -	const char *file_name =3D f->file_name;=0A=
> -	char *zoned_attr_path =3D NULL;=0A=
> -	char *model_str =3D NULL;=0A=
> +	char *attr_path =3D NULL;=0A=
>  	struct stat statbuf;=0A=
>  	char *sys_devno_path =3D NULL;=0A=
>  	char *part_attr_path =3D NULL;=0A=
> @@ -87,13 +89,7 @@ int blkzoned_get_zoned_model(struct thread_data *td, s=
truct fio_file *f,=0A=
>  	char sys_path[PATH_MAX];=0A=
>  	ssize_t sz;=0A=
>  	char *delim =3D NULL;=0A=
> -=0A=
> -	if (f->filetype !=3D FIO_TYPE_BLOCK) {=0A=
> -		*model =3D ZBD_IGNORE;=0A=
> -		return 0;=0A=
> -	}=0A=
> -=0A=
> -	*model =3D ZBD_NONE;=0A=
> +	char *ret =3D NULL;=0A=
=0A=
calling this ret is unusual. Generally, an int is assumed. Can you change t=
hat=0A=
to something like attr_str or val_str ?=0A=
=0A=
>  =0A=
>  	if (stat(file_name, &statbuf) < 0)=0A=
>  		goto out;=0A=
> @@ -123,24 +119,44 @@ int blkzoned_get_zoned_model(struct thread_data *td=
, struct fio_file *f,=0A=
>  		*delim =3D '\0';=0A=
>  	}=0A=
>  =0A=
> -	if (asprintf(&zoned_attr_path,=0A=
> -		     "/sys/dev/block/%s/queue/zoned", sys_path) < 0)=0A=
> +	if (asprintf(&attr_path,=0A=
> +		     "/sys/dev/block/%s/%s", sys_path, attr) < 0)=0A=
>  		goto out;=0A=
>  =0A=
> -	model_str =3D read_file(zoned_attr_path);=0A=
> +	ret =3D read_file(attr_path);=0A=
> +out:=0A=
> +	free(attr_path);=0A=
> +	free(part_str);=0A=
> +	free(part_attr_path);=0A=
> +	free(sys_devno_path);=0A=
> +=0A=
> +	return ret;=0A=
> +}=0A=
> +=0A=
> +int blkzoned_get_zoned_model(struct thread_data *td, struct fio_file *f,=
=0A=
> +			     enum zbd_zoned_model *model)=0A=
> +{=0A=
> +	char *model_str =3D NULL;=0A=
> +=0A=
> +	if (f->filetype !=3D FIO_TYPE_BLOCK) {=0A=
> +		*model =3D ZBD_IGNORE;=0A=
> +		return 0;=0A=
> +	}=0A=
> +=0A=
> +	*model =3D ZBD_NONE;=0A=
> +=0A=
> +	model_str =3D blkzoned_get_sysfs_attr(f->file_name, "queue/zoned");=0A=
>  	if (!model_str)=0A=
> -		goto out;=0A=
> -	dprint(FD_ZBD, "%s: zbd model string: %s\n", file_name, model_str);=0A=
> +		return 0;=0A=
> +=0A=
> +	dprint(FD_ZBD, "%s: zbd model string: %s\n", f->file_name, model_str);=
=0A=
>  	if (strcmp(model_str, "host-aware") =3D=3D 0)=0A=
>  		*model =3D ZBD_HOST_AWARE;=0A=
>  	else if (strcmp(model_str, "host-managed") =3D=3D 0)=0A=
>  		*model =3D ZBD_HOST_MANAGED;=0A=
> -out:=0A=
> +=0A=
>  	free(model_str);=0A=
> -	free(zoned_attr_path);=0A=
> -	free(part_str);=0A=
> -	free(part_attr_path);=0A=
> -	free(sys_devno_path);=0A=
> +=0A=
>  	return 0;=0A=
>  }=0A=
>  =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

