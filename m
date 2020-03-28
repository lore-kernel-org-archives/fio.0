Return-Path: <prvs=349450eed=Keith.Busch@wdc.com>
From: Keith Busch <Keith.Busch@wdc.com>
Subject: Re: [PATCH v2] fio: add NVMe engine
Date: Sat, 28 Mar 2020 00:20:58 +0000
Message-ID: 
 <BY5PR04MB6689F71BF45153FA8FA4192AFFCD0@BY5PR04MB6689.namprd04.prod.outlook.com>
References: <20200327191151.GA7688@avx2>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Keith Busch <kbusch@kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/27/20 1:12 PM, Alexey Dobriyan wrote:=0A=
> +static inline uint32_t get_nsid(const struct fio_file *f)=0A=
> +{=0A=
> +	return (uintptr_t)f->engine_data;=0A=
> +}=0A=
> +=0A=
> +static int nvme_open_file(struct thread_data *td, struct fio_file *f)=0A=
> +{=0A=
> +	struct nvme_admin_cmd cmd;=0A=
> +	struct nvme_id_ns id;=0A=
> +	struct stat st;=0A=
> +	uint32_t nsid;=0A=
> +=0A=
> +	/* NVMe ioctls ignore open flags, require CAP_SYS_ADMIN only. */=0A=
> +	f->fd =3D open(f->file_name, O_RDONLY);=0A=
> +	if (f->fd < 0) {=0A=
> +		return -errno;=0A=
> +	}=0A=
> +	if (fstat(f->fd, &st) =3D=3D -1) {=0A=
> +		return -errno;=0A=
> +	}=0A=
> +	if (!S_ISBLK(st.st_mode)) {=0A=
> +		log_err("%s: nvme engine requires NVMe block device\n",=0A=
> +			f->file_name);=0A=
> +		return 1;=0A=
> +	}=0A=
> +=0A=
> +	nsid =3D ioctl(f->fd, NVME_IOCTL_ID);=0A=
> +	if (nsid < 1) {=0A=
> +		log_err("%s: ioctl NVME_IOCTL_ID\n", f->file_name);=0A=
> +		return 1;=0A=
> +	}=0A=
> +=0A=
> +	f->engine_data =3D (void *)(uintptr_t)nsid;=0A=
> +=0A=
=0A=
=0A=
...=0A=
=0A=
=0A=
> +=0A=
> +	f->lba_shift =3D id.lbaf[id.flbas & 15].ds;=0A=
> +	return 0;=0A=
> +}=0A=
=0A=
...=0A=
=0A=
=0A=
> --- a/file.h=0A=
> +++ b/file.h=0A=
> @@ -99,6 +99,7 @@ struct fio_file {=0A=
>  	uint64_t real_file_size;=0A=
>  	uint64_t file_offset;=0A=
>  	uint64_t io_size;=0A=
> +	unsigned int lba_shift;=0A=
=0A=
=0A=
=0A=
We have the engine_data to stash engine specific data. We shouldn't add=0A=
the 'lba_shift' to the fio_file just for the nvme engine. Rather than=0A=
saving just the 'nsid' in 'engine_data', you should save a struct that=0A=
has everything the engine needs.=0A=
=0A=
=0A=
Just FYI, this is how small the nvme engine becomes with libnvme:=0A=
=0A=
=0A=
#include <libnvme.h>=0A=
#include "../fio.h"=0A=
=0A=
static int nvme_open_file(struct thread_data *td, struct fio_file *f)=0A=
{=0A=
=0A=
        nvme_ns_t n =3D nvme_ns_open(f->file_name);=0A=
=0A=
        if (!n) {=0A=
                log_err("%s: failed to open, %s\n", f->file_name,=0A=
                        strerror(errno));=0A=
                return 1;=0A=
        }=0A=
=0A=
        f->fd =3D nvme_ns_get_fd(n);=0A=
        f->engine_data =3D n;=0A=
        return 0;=0A=
}=0A=
=0A=
static enum fio_q_status nvme_queue(struct thread_data *td, struct io_u=0A=
*io_u)=0A=
{=0A=
        struct fio_file *f =3D io_u->file;=0A=
        nvme_ns_t n =3D f->engine_data;=0A=
=0A=
        fio_ro_check(td, io_u);=0A=
=0A=
        switch (io_u->ddir) {=0A=
        case DDIR_READ:=0A=
                io_u->error =3D nvme_ns_read(n, io_u->xfer_buf, io_u->offse=
t,=0A=
                                           io_u->xfer_buflen);=0A=
                break;=0A=
        case DDIR_WRITE:=0A=
                io_u->error =3D nvme_ns_write(n, io_u->xfer_buf, io_u->offs=
et,=0A=
                                            io_u->xfer_buflen);=0A=
                break;=0A=
        case DDIR_SYNC:=0A=
        case DDIR_DATASYNC:=0A=
                io_u->error =3D nvme_ns_flush(n);=0A=
                break;=0A=
        default:=0A=
                io_u->error =3D EINVAL;=0A=
                break;=0A=
        }=0A=
=0A=
        if (io_u->error =3D=3D 0) {=0A=
                io_u->resid =3D 0;=0A=
                io_u->error =3D 0;=0A=
        } else {=0A=
                io_u_log_error(td, io_u);=0A=
                td_verror(td, io_u->error, "xfer");=0A=
        }=0A=
=0A=
        return FIO_Q_COMPLETED;=0A=
}=0A=
=0A=
static struct ioengine_ops ioengine =3D {=0A=
        .name           =3D "nvme",=0A=
        .version        =3D FIO_IOOPS_VERSION,=0A=
        .flags          =3D FIO_SYNCIO|FIO_RAWIO|FIO_NOEXTEND,=0A=
        .queue          =3D nvme_queue,=0A=
        .open_file      =3D nvme_open_file,=0A=
        .close_file     =3D generic_close_file,=0A=
        .get_file_size  =3D generic_get_file_size,=0A=
};=0A=
=0A=
fio_init=0A=
static void register_nvme_ioengine(void)=0A=
{=0A=
        register_ioengine(&ioengine);=0A=
}=0A=
=0A=
fio_exit=0A=
static void unregister_nvme_ioengine(void)=0A=
{=0A=
        unregister_ioengine(&ioengine);=0A=
}=0A=
=0A=

