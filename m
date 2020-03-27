Return-Path: <prvs=34834a9ff=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] fio: add NVMe engine
Date: Fri, 27 Mar 2020 00:56:00 +0000
Message-ID: 
 <CO2PR04MB2343805A950787DBA0BA18E9E7CC0@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200326204406.GA29597@avx2>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Keith Busch <Keith.Busch@wdc.com>
List-ID: <fio@vger.kernel.org>

Alexey,=0A=
=0A=
Adding Keith to this thread.=0A=
=0A=
On 2020/03/27 5:44, Alexey Dobriyan wrote:=0A=
> Add simple iodepth=3D1 NVMe engine:=0A=
> =0A=
> 	ioengine=3Dnvme=0A=
> =0A=
> It works via standard Linux NVMe ioctls.=0A=
=0A=
Keith is working on splitting up nvmecli into the cli part and libnvme whic=
h=0A=
uses the kernel ioctl iinterface for NVMe command passthrough. So I think i=
t may=0A=
be better to implement ioengine=3Dlibnvme using Keith libnvme library. That=
 will=0A=
remove the need to define all the NVMe command stuff here.=0A=
=0A=
> =0A=
> It will be used for testing upcoming ZNS stuff.=0A=
=0A=
libnvme will have this support too. But you will also need the ioengine to =
be=0A=
able to plug into the zonemode=3Dzbd to avoid a lot of nightmares on how to=
 avoid=0A=
unailigned write errors with various workloads. I have a series almost read=
y to=0A=
go out (in testing right now) to do just that for a new libzbc IO engine. T=
his=0A=
IO engine is for passthrough to SMR drives, for the exact same use case, na=
mely,=0A=
testing drives on kernels that do not have zoned block device support (e.g.=
 a=0A=
lot of customers in the field use old-ish enterprise distros with 3.x kerne=
ls=0A=
where zoned block devices are not supported).=0A=
=0A=
> =0A=
> Currently Linux doesn't recognize NVMe ZNS devices as zoned block=0A=
> devices so zone ioctls (BLKRESETZONE et al) can't be used.=0A=
=0A=
Patches for that are ready to go out as soon as the ZNS TP is approved :)=
=0A=
=0A=
> =0A=
> Passthrough ioctls should allow Zone Append and whatever commands=0A=
> new specs bring.=0A=
=0A=
Yes, but we will need a new rw=3D control for that one though as implementi=
ng=0A=
verify for it will not be trivial (data location on the device and write is=
suing=0A=
offset relation is lost with zone append).=0A=
=0A=
> =0A=
> Support read, write, fsync, fdatasync.=0A=
> Don't support sync_file_range obviously.=0A=
> Don't support trim for now, until I figure all qemu options and=0A=
> the story behind broken qemu trim support.=0A=
=0A=
Using Keith's libnvme can probably simplify support for all of this.=0A=
=0A=
> =0A=
> Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>=0A=
> ---=0A=
> =0A=
>  Makefile       |    3 =0A=
>  configure      |   20 +++++=0A=
>  engines/nvme.c |  226 ++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++=0A=
>  file.h         |    1 =0A=
>  4 files changed, 250 insertions(+)=0A=
> =0A=
> --- a/Makefile=0A=
> +++ b/Makefile=0A=
> @@ -163,6 +163,9 @@ endif=0A=
>  ifdef CONFIG_LINUX_BLKZONED=0A=
>    SOURCE +=3D zbd.c=0A=
>  endif=0A=
> +ifdef CONFIG_NVME=0A=
> +  SOURCE +=3D engines/nvme.c=0A=
> +endif=0A=
>  =0A=
>  ifeq ($(CONFIG_TARGET_OS), Linux)=0A=
>    SOURCE +=3D diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c =
\=0A=
> --- a/configure=0A=
> +++ b/configure=0A=
> @@ -2397,6 +2397,22 @@ if compile_prog "" "" "linux_blkzoned"; then=0A=
>  fi=0A=
>  print_config "Zoned block device support" "$linux_blkzoned"=0A=
>  =0A=
> +##########################################=0A=
> +if test "$linux_nvme" !=3D "yes" ; then=0A=
> +  linux_nvme=3D"no"=0A=
> +fi=0A=
> +cat >$TMPC <<EOF=0A=
> +#include <linux/nvme_ioctl.h>=0A=
> +int main(void)=0A=
> +{=0A=
> +	return 0;=0A=
> +}=0A=
> +EOF=0A=
> +if compile_prog "" "" "linux_nvme"; then=0A=
> +  linux_nvme=3D"yes"=0A=
> +fi=0A=
> +print_config "NVMe engine" "$linux_nvme"=0A=
> +=0A=
>  ##########################################=0A=
>  # check march=3Darmv8-a+crc+crypto=0A=
>  if test "$march_armv8_a_crc_crypto" !=3D "yes" ; then=0A=
> @@ -2912,6 +2928,10 @@ if test "$libnbd" =3D "yes" ; then=0A=
>    echo "LIBNBD_CFLAGS=3D$libnbd_cflags" >> $config_host_mak=0A=
>    echo "LIBNBD_LIBS=3D$libnbd_libs" >> $config_host_mak=0A=
>  fi=0A=
> +if test "$linux_nvme" =3D "yes" ; then=0A=
> +  output_sym "CONFIG_NVME"=0A=
> +fi=0A=
> +=0A=
>  cat > $TMPC << EOF=0A=
>  int main(int argc, char **argv)=0A=
>  {=0A=
> new file mode 100644=0A=
> --- /dev/null=0A=
> +++ b/engines/nvme.c=0A=
> @@ -0,0 +1,226 @@=0A=
> +/* NVMe passthrough engine. */=0A=
> +#include <linux/nvme_ioctl.h>=0A=
> +=0A=
> +#include <sys/types.h>=0A=
> +#include <sys/stat.h>=0A=
> +#include <fcntl.h>=0A=
> +#include <sys/ioctl.h>=0A=
> +=0A=
> +#include "../fio.h"=0A=
> +=0A=
> +enum {=0A=
> +	nvme_admin_identify	=3D 6,=0A=
> +};=0A=
> +=0A=
> +enum {=0A=
> +	nvme_cmd_flush		=3D 0,=0A=
> +	nvme_cmd_write		=3D 1,=0A=
> +	nvme_cmd_read		=3D 2,=0A=
> +};=0A=
> +=0A=
> +struct nvme_lbaf {=0A=
> +	__le16	ms;=0A=
> +	__u8	ds;=0A=
> +	__u8	rp;=0A=
> +};=0A=
> +=0A=
> +struct nvme_id_ns {=0A=
> +	__le64	nsze;=0A=
> +	__le64	ncap;=0A=
> +	__le64	nuse;=0A=
> +	__u8	nsfeat;=0A=
> +	__u8	nlbaf;=0A=
> +	__u8	flbas;=0A=
> +	__u8	mc;=0A=
> +	__u8	dpc;=0A=
> +	__u8	dps;=0A=
> +	__u8	nmic;=0A=
> +	__u8	rescap;=0A=
> +	__u8	fpi;=0A=
> +	__u8	dlfeat;=0A=
> +	__le16	nawun;=0A=
> +	__le16	nawupf;=0A=
> +	__le16	nacwu;=0A=
> +	__le16	nabsn;=0A=
> +	__le16	nabo;=0A=
> +	__le16	nabspf;=0A=
> +	__le16	noiob;=0A=
> +	__u8	nvmcap[16];=0A=
> +	__le16	npwg;=0A=
> +	__le16	npwa;=0A=
> +	__le16	npdg;=0A=
> +	__le16	npda;=0A=
> +	__le16	nows;=0A=
> +	__u8	rsvd74[18];=0A=
> +	__le32	anagrpid;=0A=
> +	__u8	rsvd96[3];=0A=
> +	__u8	nsattr;=0A=
> +	__le16	nvmsetid;=0A=
> +	__le16	endgid;=0A=
> +	__u8	nguid[16];=0A=
> +	__u8	eui64[8];=0A=
> +	struct nvme_lbaf lbaf[16];=0A=
> +	__u8	rsvd192[192];=0A=
> +	__u8	vs[3712];=0A=
> +};=0A=
> +=0A=
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
> +	/* Identify Namespace */=0A=
> +	memset(&cmd, 0, sizeof(struct nvme_admin_cmd));=0A=
> +	cmd.opcode =3D nvme_admin_identify;=0A=
> +	cmd.nsid =3D nsid;=0A=
> +	cmd.addr =3D (uintptr_t)&id;=0A=
> +	cmd.data_len =3D 4096;=0A=
> +	if (ioctl(f->fd, NVME_IOCTL_ADMIN_CMD, &cmd) !=3D 0)  {=0A=
> +		log_err("%s: ioctl NVME_IOCTL_ADMIN_CMD\n", f->file_name);=0A=
> +		return 1;=0A=
> +	}=0A=
> +=0A=
> +	f->lba_shift =3D id.lbaf[id.flbas & 15].ds;=0A=
> +	return 0;=0A=
> +}=0A=
> +=0A=
> +static int fio_nvme_read(struct fio_file *f, struct io_u *io_u)=0A=
> +{=0A=
> +	fio_unused uint32_t nsid =3D get_nsid(f);=0A=
> +	struct nvme_user_io cmd =3D {};=0A=
> +=0A=
> +	//printf("R %u %llu/%llu\n", nsid, io_u->offset, io_u->xfer_buflen);=0A=
> +=0A=
> +	assert((io_u->xfer_buflen & ((1ULL << f->lba_shift) - 1)) =3D=3D 0);=0A=
> +	assert((io_u->offset & ((1ULL << f->lba_shift) - 1)) =3D=3D 0);=0A=
> +=0A=
> +	cmd.opcode =3D nvme_cmd_read;=0A=
> +	cmd.nblocks =3D (io_u->xfer_buflen >> f->lba_shift) - 1;=0A=
> +	cmd.addr =3D (uintptr_t)io_u->xfer_buf;=0A=
> +	cmd.slba =3D io_u->offset >> f->lba_shift;=0A=
> +	return ioctl(f->fd, NVME_IOCTL_SUBMIT_IO, &cmd);=0A=
> +}=0A=
> +=0A=
> +static int fio_nvme_write(struct fio_file *f, struct io_u *io_u)=0A=
> +{=0A=
> +	fio_unused uint32_t nsid =3D get_nsid(f);=0A=
> +	struct nvme_user_io cmd =3D {};=0A=
> +=0A=
> +	//printf("W %u %llu/%llu\n", nsid, io_u->offset, io_u->xfer_buflen);=0A=
> +=0A=
> +	assert((io_u->xfer_buflen & ((1ULL << f->lba_shift) - 1)) =3D=3D 0);=0A=
> +	assert((io_u->offset & ((1ULL << f->lba_shift) - 1)) =3D=3D 0);=0A=
> +=0A=
> +	cmd.opcode =3D nvme_cmd_write;=0A=
> +	cmd.nblocks =3D (io_u->xfer_buflen >> f->lba_shift) - 1;=0A=
> +	cmd.addr =3D (uintptr_t)io_u->xfer_buf;=0A=
> +	cmd.slba =3D io_u->offset >> f->lba_shift;=0A=
> +	return ioctl(f->fd, NVME_IOCTL_SUBMIT_IO, &cmd);=0A=
> +}=0A=
> +=0A=
> +static int fio_nvme_flush(struct fio_file *f)=0A=
> +{=0A=
> +	uint32_t nsid =3D get_nsid(f);=0A=
> +	struct nvme_passthru_cmd cmd =3D {};=0A=
> +=0A=
> +	//printf("F %u\n", nsid);=0A=
> +=0A=
> +	cmd.opcode =3D nvme_cmd_flush;=0A=
> +	cmd.nsid =3D nsid;=0A=
> +	return ioctl(f->fd, NVME_IOCTL_IO_CMD, &cmd);=0A=
> +}=0A=
> +=0A=
> +static enum fio_q_status fio_nvme_queue(struct thread_data *td, struct i=
o_u *io_u)=0A=
> +{=0A=
> +	struct fio_file *f =3D io_u->file;=0A=
> +	int rv;=0A=
> +=0A=
> +	fio_ro_check(td, io_u);=0A=
> +=0A=
> +	if (io_u->ddir =3D=3D DDIR_READ) {=0A=
> +		// FIXME MDTS=0A=
> +		rv =3D fio_nvme_read(f, io_u);=0A=
> +		if (rv =3D=3D 0) {=0A=
> +			io_u->resid =3D 0;=0A=
> +			io_u->error =3D 0;=0A=
> +		} else {=0A=
> +			io_u->error =3D rv;=0A=
> +		}=0A=
> +	} else if (io_u->ddir =3D=3D DDIR_WRITE) {=0A=
> +		// FIXME MDTS=0A=
> +		rv =3D fio_nvme_write(f, io_u);=0A=
> +		if (rv =3D=3D 0) {=0A=
> +			io_u->resid =3D 0;=0A=
> +			io_u->error =3D 0;=0A=
> +		} else {=0A=
> +			io_u->error =3D rv;=0A=
> +		}=0A=
> +	} else if (io_u->ddir =3D=3D DDIR_TRIM) {=0A=
> +		// FIXME=0A=
> +		rv =3D io_u->xfer_buflen;=0A=
> +		io_u->error =3D EINVAL;=0A=
> +	} else if (io_u->ddir =3D=3D DDIR_SYNC || io_u->ddir =3D=3D DDIR_DATASY=
NC) {=0A=
> +		rv =3D fio_nvme_flush(f);=0A=
> +	} else {=0A=
> +		rv =3D io_u->xfer_buflen;=0A=
> +		io_u->error =3D EINVAL;=0A=
> +	}=0A=
> +=0A=
> +	if (io_u->error) {=0A=
> +		io_u_log_error(td, io_u);=0A=
> +		td_verror(td, io_u->error, "xfer");=0A=
> +	}=0A=
> +=0A=
> +	return FIO_Q_COMPLETED;=0A=
> +}=0A=
> +=0A=
> +static struct ioengine_ops ioengine =3D {=0A=
> +	.name		=3D "nvme",=0A=
> +	.version	=3D FIO_IOOPS_VERSION,=0A=
> +	.flags		=3D FIO_SYNCIO|FIO_RAWIO|FIO_NOEXTEND,=0A=
> +	.queue		=3D fio_nvme_queue,=0A=
> +	.open_file	=3D nvme_open_file,=0A=
> +	.close_file	=3D generic_close_file,=0A=
> +	.get_file_size	=3D generic_get_file_size,=0A=
> +};=0A=
> +=0A=
> +fio_init=0A=
> +static void register_nvme_ioengine(void)=0A=
> +{=0A=
> +	register_ioengine(&ioengine);=0A=
> +}=0A=
> +=0A=
> +fio_exit=0A=
> +static void unregister_nvme_ioengine(void)=0A=
> +{=0A=
> +	unregister_ioengine(&ioengine);=0A=
> +}=0A=
> --- a/file.h=0A=
> +++ b/file.h=0A=
> @@ -99,6 +99,7 @@ struct fio_file {=0A=
>  	uint64_t real_file_size;=0A=
>  	uint64_t file_offset;=0A=
>  	uint64_t io_size;=0A=
> +	unsigned int lba_shift;=0A=
>  =0A=
>  	/*=0A=
>  	 * Zoned block device information. See also zonemode=3Dzbd.=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

