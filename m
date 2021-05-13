Return-Path: <prvs=760bdaabf=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 3/4] ioengines: add get_max_open_zones zoned block device
 operation
Date: Thu, 13 May 2021 00:23:59 +0000
Message-ID: 
 <DM6PR04MB7081E5A56B9868AB2A259076E7519@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210512223615.17239-1-Niklas.Cassel@wdc.com>
 <20210512223615.17239-4-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Niklas Cassel <Niklas.Cassel@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2021/05/13 7:37, Niklas Cassel wrote:=0A=
> From: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> =0A=
> Define a new IO engine operation to get the maximum number of open zones.=
=0A=
> Like the existing IO engine operations: .get_zoned_model, .report_zones,=
=0A=
> and .reset_wp, this new IO engine operation is only valid for zoned block=
=0A=
> devices.=0A=
> =0A=
> Similarly to the other zbd IO engine operations, also provide a default=
=0A=
> implementation inside oslib/linux-blkzoned.c that will be used if the=0A=
> ioengine does not override it.=0A=
> =0A=
> The default Linux oslib implementation is implemented similarly to=0A=
> blkzoned_get_zoned_model(), i.e. it will return a successful error code=
=0A=
> even when the sysfs attribute does not exist.=0A=
> This is because the sysfs max_open_zones attribute was introduced first=
=0A=
> in Linux v5.9.=0A=
> All error handling is still there, so an ioengine that provides its own=
=0A=
> implementation will still have its error code respected properly.=0A=
> =0A=
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> ---=0A=
>  engines/skeleton_external.c | 13 ++++++=0A=
>  ioengines.h                 |  4 +-=0A=
>  oslib/blkzoned.h            |  7 +++=0A=
>  oslib/linux-blkzoned.c      | 22 ++++++++++=0A=
>  zbd.c                       | 87 ++++++++++++++++++++++++++++++++++---=
=0A=
>  5 files changed, 127 insertions(+), 6 deletions(-)=0A=
> =0A=
> diff --git a/engines/skeleton_external.c b/engines/skeleton_external.c=0A=
> index 7f3e4cb3..c79b6f11 100644=0A=
> --- a/engines/skeleton_external.c=0A=
> +++ b/engines/skeleton_external.c=0A=
> @@ -193,6 +193,18 @@ static int fio_skeleton_reset_wp(struct thread_data =
*td, struct fio_file *f,=0A=
>  	return 0;=0A=
>  }=0A=
>  =0A=
> +/*=0A=
> + * Hook called for getting the maximum number of open zones for a=0A=
> + * ZBD_HOST_MANAGED zoned block device.=0A=
> + * A @max_open_zones value set to zero means no limit.=0A=
> + */=0A=
> +static int fio_skeleton_get_max_open_zones(struct thread_data *td,=0A=
> +					   struct fio_file *f,=0A=
> +					   unsigned int *max_open_zones)=0A=
> +{=0A=
> +	return 0;=0A=
> +}=0A=
> +=0A=
>  /*=0A=
>   * Note that the structure is exported, so that fio can get it via=0A=
>   * dlsym(..., "ioengine"); for (and only for) external engines.=0A=
> @@ -212,6 +224,7 @@ struct ioengine_ops ioengine =3D {=0A=
>  	.get_zoned_model =3D fio_skeleton_get_zoned_model,=0A=
>  	.report_zones	=3D fio_skeleton_report_zones,=0A=
>  	.reset_wp	=3D fio_skeleton_reset_wp,=0A=
> +	.get_max_open_zones =3D fio_skeleton_get_max_open_zones,=0A=
>  	.options	=3D options,=0A=
>  	.option_struct_size	=3D sizeof(struct fio_skeleton_options),=0A=
>  };=0A=
> diff --git a/ioengines.h b/ioengines.h=0A=
> index 1d01ab0a..b3f755b4 100644=0A=
> --- a/ioengines.h=0A=
> +++ b/ioengines.h=0A=
> @@ -8,7 +8,7 @@=0A=
>  #include "io_u.h"=0A=
>  #include "zbd_types.h"=0A=
>  =0A=
> -#define FIO_IOOPS_VERSION	29=0A=
> +#define FIO_IOOPS_VERSION	30=0A=
>  =0A=
>  #ifndef CONFIG_DYNAMIC_ENGINES=0A=
>  #define FIO_STATIC	static=0A=
> @@ -59,6 +59,8 @@ struct ioengine_ops {=0A=
>  			    uint64_t, struct zbd_zone *, unsigned int);=0A=
>  	int (*reset_wp)(struct thread_data *, struct fio_file *,=0A=
>  			uint64_t, uint64_t);=0A=
> +	int (*get_max_open_zones)(struct thread_data *, struct fio_file *,=0A=
> +				  unsigned int *);=0A=
>  	int option_struct_size;=0A=
>  	struct fio_option *options;=0A=
>  };=0A=
> diff --git a/oslib/blkzoned.h b/oslib/blkzoned.h=0A=
> index 4cc071dc..719b041d 100644=0A=
> --- a/oslib/blkzoned.h=0A=
> +++ b/oslib/blkzoned.h=0A=
> @@ -16,6 +16,8 @@ extern int blkzoned_report_zones(struct thread_data *td=
,=0A=
>  				struct zbd_zone *zones, unsigned int nr_zones);=0A=
>  extern int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,=
=0A=
>  				uint64_t offset, uint64_t length);=0A=
> +extern int blkzoned_get_max_open_zones(struct thread_data *td, struct fi=
o_file *f,=0A=
> +				       unsigned int *max_open_zones);=0A=
>  #else=0A=
>  /*=0A=
>   * Define stubs for systems that do not have zoned block device support.=
=0A=
> @@ -44,6 +46,11 @@ static inline int blkzoned_reset_wp(struct thread_data=
 *td, struct fio_file *f,=0A=
>  {=0A=
>  	return -EIO;=0A=
>  }=0A=
> +static inline int blkzoned_get_max_open_zones(struct thread_data *td, st=
ruct fio_file *f,=0A=
> +					      unsigned int *max_open_zones)=0A=
> +{=0A=
> +	return -EIO;=0A=
> +}=0A=
>  #endif=0A=
>  =0A=
>  #endif /* FIO_BLKZONED_H */=0A=
> diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c=0A=
> index 127069ca..82b662a2 100644=0A=
> --- a/oslib/linux-blkzoned.c=0A=
> +++ b/oslib/linux-blkzoned.c=0A=
> @@ -160,6 +160,28 @@ int blkzoned_get_zoned_model(struct thread_data *td,=
 struct fio_file *f,=0A=
>  	return 0;=0A=
>  }=0A=
>  =0A=
> +int blkzoned_get_max_open_zones(struct thread_data *td, struct fio_file =
*f,=0A=
> +				unsigned int *max_open_zones)=0A=
> +{=0A=
> +	char *max_open_str;=0A=
> +=0A=
> +	if (f->filetype !=3D FIO_TYPE_BLOCK) {=0A=
> +		return -EIO;=0A=
> +	}=0A=
=0A=
No need for the curly brackets.=0A=
=0A=
> +=0A=
> +	max_open_str =3D blkzoned_get_sysfs_attr(f->file_name, "queue/max_open_=
zones");=0A=
> +	if (!max_open_str)=0A=
> +		return 0;=0A=
> +=0A=
> +	dprint(FD_ZBD, "%s: max open zones supported by device: %s\n",=0A=
> +	       f->file_name, max_open_str);=0A=
> +	*max_open_zones =3D atoll(max_open_str);=0A=
> +=0A=
> +	free(max_open_str);=0A=
> +=0A=
> +	return 0;=0A=
> +}=0A=
> +=0A=
>  static uint64_t zone_capacity(struct blk_zone_report *hdr,=0A=
>  			      struct blk_zone *blkz)=0A=
>  {=0A=
> diff --git a/zbd.c b/zbd.c=0A=
> index 8ed8f195..f23bbbac 100644=0A=
> --- a/zbd.c=0A=
> +++ b/zbd.c=0A=
> @@ -113,6 +113,34 @@ int zbd_reset_wp(struct thread_data *td, struct fio_=
file *f,=0A=
>  	return ret;=0A=
>  }=0A=
>  =0A=
> +/**=0A=
> + * zbd_get_max_open_zones - Get the maximum number of open zones=0A=
> + * @td: FIO thread data=0A=
> + * @f: FIO file for which to get max open zones=0A=
> + * @max_open_zones: Upon success, result will be stored here.=0A=
> + *=0A=
> + * A @max_open_zones value set to zero means no limit.=0A=
> + *=0A=
> + * Returns 0 upon success and a negative error code upon failure.=0A=
> + */=0A=
> +int zbd_get_max_open_zones(struct thread_data *td, struct fio_file *f,=
=0A=
> +			   unsigned int *max_open_zones)=0A=
> +{=0A=
> +	int ret;=0A=
> +=0A=
> +	if (td->io_ops && td->io_ops->get_max_open_zones)=0A=
> +		ret =3D td->io_ops->get_max_open_zones(td, f, max_open_zones);=0A=
> +	else=0A=
> +		ret =3D blkzoned_get_max_open_zones(td, f, max_open_zones);=0A=
> +	if (ret < 0) {=0A=
> +		td_verror(td, errno, "get max open zones failed");=0A=
> +		log_err("%s: get max open zones failed (%d).\n",=0A=
> +			f->file_name, errno);=0A=
> +	}=0A=
> +=0A=
> +	return ret;=0A=
> +}=0A=
> +=0A=
>  /**=0A=
>   * zbd_zone_idx - convert an offset into a zone number=0A=
>   * @f: file pointer.=0A=
> @@ -554,6 +582,48 @@ out:=0A=
>  	return ret;=0A=
>  }=0A=
>  =0A=
> +static int zbd_set_max_open_zones(struct thread_data *td, struct fio_fil=
e *f)=0A=
> +{=0A=
> +	struct zoned_block_device_info *zbd =3D f->zbd_info;=0A=
> +	unsigned int max_open_zones;=0A=
> +	int ret;=0A=
> +=0A=
> +	if (zbd->model !=3D ZBD_HOST_MANAGED) {=0A=
> +		/* Only host-managed devices have a max open limit */=0A=
> +		zbd->max_open_zones =3D td->o.max_open_zones;=0A=
> +		goto out;=0A=
> +	}=0A=
> +=0A=
> +	/* If host-managed, get the max open limit */=0A=
> +	ret =3D zbd_get_max_open_zones(td, f, &max_open_zones);=0A=
> +	if (ret)=0A=
> +		return ret;=0A=
> +=0A=
> +	if (td->o.max_open_zones > 0 && max_open_zones > 0 &&=0A=
> +	    td->o.max_open_zones > max_open_zones) {=0A=
> +		/* User requested a limit, but limit is too large */=0A=
> +		td_verror(td, EINVAL,=0A=
> +			  "Specified --max_open_zones is too large");=0A=
> +		log_err("Specified --max_open_zones (%d) is larger than max (%u)\n",=
=0A=
> +			td->o.max_open_zones, max_open_zones);=0A=
> +		return -EINVAL;=0A=
> +	} else if (td->o.max_open_zones > 0) {=0A=
> +		/* User requested a limit, limit is not too large */=0A=
> +		zbd->max_open_zones =3D td->o.max_open_zones;=0A=
> +	} else {=0A=
> +		/* User did not request a limit. Set limit to max supported */=0A=
> +		zbd->max_open_zones =3D max_open_zones;=0A=
> +	}=0A=
=0A=
Here, you could reverse the order of the if/else if/else. That would simpli=
fy=0A=
the conditions:=0A=
=0A=
	if (!td->o.max_open_zones) {=0A=
		/* User did not request a limit. Set limit to max supported */=0A=
		zbd->max_open_zones =3D max_open_zones;=0A=
	} else if (td->o.max_open_zones < max_open_zones) {=0A=
		/* User requested a limit, limit is not too large */=0A=
		zbd->max_open_zones =3D td->o.max_open_zones;=0A=
	} else {=0A=
		/* User requested a limit, but limit is too large */=0A=
		...=0A=
		return -EINVAL;=0A=
	}=0A=
=0A=
> +=0A=
> +out:=0A=
> +	/* Ensure that the limit is not larger than FIO's internal limit */=0A=
> +	zbd->max_open_zones =3D zbd->max_open_zones ?: ZBD_MAX_OPEN_ZONES;=0A=
> +	dprint(FD_ZBD, "%s: using max open zones limit: %"PRIu32"\n",=0A=
> +	       f->file_name, zbd->max_open_zones);=0A=
=0A=
It may be good to have a log_info() too here, no ?=0A=
=0A=
> +=0A=
> +	return 0;=0A=
> +}=0A=
> +=0A=
>  /*=0A=
>   * Allocate zone information and store it into f->zbd_info if zonemode=
=3Dzbd.=0A=
>   *=0A=
> @@ -576,9 +646,13 @@ static int zbd_create_zone_info(struct thread_data *=
td, struct fio_file *f)=0A=
>  	case ZBD_HOST_AWARE:=0A=
>  	case ZBD_HOST_MANAGED:=0A=
>  		ret =3D parse_zone_info(td, f);=0A=
> +		if (ret)=0A=
> +			return ret;=0A=
>  		break;=0A=
>  	case ZBD_NONE:=0A=
>  		ret =3D init_zone_info(td, f);=0A=
> +		if (ret)=0A=
> +			return ret;=0A=
>  		break;=0A=
>  	default:=0A=
>  		td_verror(td, EINVAL, "Unsupported zoned model");=0A=
> @@ -586,12 +660,15 @@ static int zbd_create_zone_info(struct thread_data =
*td, struct fio_file *f)=0A=
>  		return -EINVAL;=0A=
>  	}=0A=
>  =0A=
> -	if (ret =3D=3D 0) {=0A=
> -		f->zbd_info->model =3D zbd_model;=0A=
> -		f->zbd_info->max_open_zones =3D=0A=
> -			td->o.max_open_zones ?: ZBD_MAX_OPEN_ZONES;=0A=
> +	f->zbd_info->model =3D zbd_model;=0A=
> +=0A=
> +	ret =3D zbd_set_max_open_zones(td, f);=0A=
> +	if (ret) {=0A=
> +		zbd_free_zone_info(f);=0A=
> +		return ret;=0A=
>  	}=0A=
> -	return ret;=0A=
> +=0A=
> +	return 0;=0A=
>  }=0A=
>  =0A=
>  void zbd_free_zone_info(struct fio_file *f)=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

