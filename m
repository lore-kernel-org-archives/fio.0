Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:53690 "EHLO
        mx0a-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751372AbeCOSGv (ORCPT
        <rfc822;fio@vger.kernel.org>); Thu, 15 Mar 2018 14:06:51 -0400
Received: from pps.filterd (m0075554.ppops.net [127.0.0.1])
        by mx0a-000cda01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w2FI3jKR012134
        for <fio@vger.kernel.org>; Thu, 15 Mar 2018 14:06:50 -0400
Received: from mail-lf0-f71.google.com (mail-lf0-f71.google.com [209.85.215.71])
        by mx0a-000cda01.pphosted.com with ESMTP id 2gqub3gpba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <fio@vger.kernel.org>; Thu, 15 Mar 2018 14:06:49 -0400
Received: by mail-lf0-f71.google.com with SMTP id a28-v6so2548275lfg.7
        for <fio@vger.kernel.org>; Thu, 15 Mar 2018 11:06:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1521132231.2834.4.camel@wdc.com>
References: <CAODBMz=rOy1kJGVGn3fyCGT78QUK0BH0rzw7cTRMxKZ6sdSF-Q@mail.gmail.com>
 <CY1PR0401MB11166E39586E25D46B482E4581D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxgn-yxPf5noENrdbhPKS7T3BVsArSa8wG50e0r88DPr-A@mail.gmail.com> <1521132231.2834.4.camel@wdc.com>
From: Phillip Chen <phillip.a.chen@seagate.com>
Date: Thu, 15 Mar 2018 12:06:04 -0600
Message-ID: <CAODBMznzVriS6kL5aFddKZBfdLfBLYOk=Chfas4+Xn6LjOxveQ@mail.gmail.com>
Subject: Re: ZBC/FLEX FIO addition ideas
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "sitsofe@gmail.com" <sitsofe@gmail.com>, Kris Davis <Kris.Davis@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jason Jorgensen <jason.jorgensen@wdc.com>

Would creating new profiles for all the I/O patterns be particularly
difficult? I'm sure you're much more familiar with the FIO codebase
than I am, but it seems to me that all you'd need to do for randoms is
move the logic from the zbc_adjust_block cases upstream into the
various methods called by get_off_from_method(), or possibly modify
the existing methods to work differently when working on a ZBC drive.
For sequentials it seems like you'd just have to move the logic into
get_next_seq_offset().
It also seems to me that it might be better to have get_next_block()
pick a valid area to begin with. The main benefit to doing this that I
can see would be to allow much more control over the number of open
zones, which I think will be of particular interest in testing ZBC
drive performance. Additionally, it might be worthwhile to have an
option allows the workload to pick a new zone instead of resetting the
write pointer of a zone when writing to a full zone. This would also
be made easier with a more upstream approach, because you wouldn't
need to retry and get a new offset, you could just avoid full zones
entirely. Or you could keep track of which zones are open and
add/replace open zones as necessary.
Phillip

On Thu, Mar 15, 2018 at 10:43 AM, Bart Van Assche
<Bart.VanAssche@wdc.com> wrote:
> On Thu, 2018-03-15 at 16:30 +0000, Sitsofe Wheeler wrote:
>
>> On 15 March 2018 at 16:15, Kris Davis <Kris.Davis@wdc.com> wrote:
>
>> > Despite the desire to have fio work with Host Managed devices independ=
ent of the engine, a Host Managed device operation is different than a trad=
itional block device, and the kernel also has to
>
>> > manage it differently. Thus, I would still recommend creating a new IO=
 engine for use with Host Managed devices, we would not want the additional=
 overhead associated with SMR to impact the
>
>> > standard aio engine.  We have mostly used the fio SG engine along with=
 external operations in testing of SMR.
>
>> >
>
>> > Here is the way we envision a new fio engine might work with Host Mana=
ged devices:
>
>>
>
>> It's definitely going to need something special. I think last time
>
>> round (https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.spinic=
s.net_lists_fio_msg06646.html&d=3DDwIGaQ&c=3DIGDlg0lD0b-nebmJJ0Kp8A&r=3DeNM=
OVQH16Aa4ThAFVwj-O7goG7k06cW3W6DO_yXnzSg&m=3DicSXCK6t72RPOJKtqT2YyV-6X8g2HQ=
nSmGSFsvlJgOo&s=3Dti4Mozyfv9Huy4ZNAs9GDPnvDhaiz40m16tWRS4cOVM&e=3D ) I sugg=
ested a
>
>> profile but perhaps that won't be enough. I doubt an ioengine would be
>
>> enough because you're going to have interact with the next offset code
>
>> etc. unless you're going to fake I/Os done to "wrong" regions...
>
>
>
> Hello Sitsofe,
>
>
>
> Adding support for ZBC drives as a profile has a significant disadvantage=
,
>
> namely that the different I/O patterns (sequential read, sequential write=
,
>
> random read, random write, ...) all have to be reimplemented. That's why =
I'm
>
> considering to add ZBC support by modifying what get_next_block() produce=
s.
>
> Can you have a look at the (barely tested) patch below?
>
>
>
> Thanks,
>
>
>
> Bart.
>
>
>
>
>
> diff --git a/Makefile b/Makefile
>
> index 8f4871c63528..44dd7f3439f6 100644
>
> --- a/Makefile
>
> +++ b/Makefile
>
> @@ -145,6 +145,9 @@ endif
>
>  ifdef CONFIG_LIBPMEM
>
>    SOURCE +=3D engines/libpmem.c
>
>  endif
>
> +ifdef HAVE_LINUX_BLKZONED_H
>
> +  SOURCE +=3D zbc.c
>
> +endif
>
>
>
>  ifeq ($(CONFIG_TARGET_OS), Linux)
>
>    SOURCE +=3D diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c =
\
>
> diff --git a/configure b/configure
>
> index 4442a1cc0d75..688e86201320 100755
>
> --- a/configure
>
> +++ b/configure
>
> @@ -2104,6 +2104,27 @@ if compile_prog "" "" "valgrind_dev"; then
>
>  fi
>
>  print_config "Valgrind headers" "$valgrind_dev"
>
>
>
> +##########################################
>
> +# <linux/blkzoned.h> probe
>
> +if test "$linux_blkzoned_h" !=3D "yes" ; then
>
> +  linux_blkzoned_h=3D"no"
>
> +fi
>
> +cat > $TMPC << EOF
>
> +#include <linux/blkzoned.h>
>
> +int main(int argc, char **argv)
>
> +{
>
> +  return 0;
>
> +}
>
> +EOF
>
> +if compile_prog "" "" "linux_blkzoned_h"; then
>
> +  linux_blkzoned_h=3D"yes"
>
> +fi
>
> +print_config "<linux/blkzoned.h>" "$linux_blkzoned_h"
>
> +if test "$linux_blkzoned_h" =3D "yes" ; then
>
> +  output_sym "HAVE_LINUX_BLKZONED_H"
>
> +fi
>
> +
>
> +##########################################
>
>  # check march=3Darmv8-a+crc+crypto
>
>  if test "$march_armv8_a_crc_crypto" !=3D "yes" ; then
>
>    march_armv8_a_crc_crypto=3D"no"
>
> diff --git a/debug.h b/debug.h
>
> index b8718ddc225f..c69c8079beda 100644
>
> --- a/debug.h
>
> +++ b/debug.h
>
> @@ -24,6 +24,7 @@ enum {
>
>         FD_COMPRESS,
>
>         FD_STEADYSTATE,
>
>         FD_HELPERTHREAD,
>
> +       FD_ZBC,
>
>         FD_DEBUG_MAX,
>
>  };
>
>
>
> diff --git a/file.h b/file.h
>
> index 8fd34b136c23..42b304629824 100644
>
> --- a/file.h
>
> +++ b/file.h
>
> @@ -10,6 +10,9 @@
>
>  #include "lib/lfsr.h"
>
>  #include "lib/gauss.h"
>
>
>
> +/* Forward declarations */
>
> +struct zoned_block_device_info;
>
> +
>
>  /*
>
>   * The type of object we are working on
>
>   */
>
> @@ -97,6 +100,11 @@ struct fio_file {
>
>         uint64_t file_offset;
>
>         uint64_t io_size;
>
>
>
> +       /*
>
> +        * Zoned device information
>
> +        */
>
> +       struct zoned_block_device_info *zbd_info;
>
> +
>
>         /*
>
>          * Track last end and last start of IO for a given data direction
>
>          */
>
> diff --git a/filesetup.c b/filesetup.c
>
> index 7cbce1327f8f..d981c61f5b7f 100644
>
> --- a/filesetup.c
>
> +++ b/filesetup.c
>
> @@ -16,6 +16,7 @@
>
>  #include "hash.h"
>
>  #include "lib/axmap.h"
>
>  #include "rwlock.h"
>
> +#include "zbc.h"
>
>
>
>  #ifdef CONFIG_LINUX_FALLOCATE
>
>  #include <linux/falloc.h>
>
> @@ -773,6 +774,9 @@ static int get_file_sizes(struct thread_data *td)
>
>                  */
>
>                 if (f->real_file_size =3D=3D -1ULL && td->o.size)
>
>                         f->real_file_size =3D td->o.size / td->o.nr_files=
;
>
> +
>
> +               if (f->filetype =3D=3D FIO_TYPE_BLOCK)
>
> +                       zbc_init_zone_info(f);
>
>         }
>
>
>
>         return err;
>
> @@ -1165,7 +1169,9 @@ done:
>
>                 td->done =3D 1;
>
>
>
>         td_restore_runstate(td, old_state);
>
> -       return 0;
>
> +
>
> +       return zbc_verify_options();
>
> +
>
>  err_offset:
>
>         log_err("%s: you need to specify valid offset=3D\n", o->name);
>
>  err_out:
>
> diff --git a/init.c b/init.c
>
> index e47e5384119b..3ea5ea57e3a1 100644
>
> --- a/init.c
>
> +++ b/init.c
>
> @@ -2266,6 +2266,10 @@ const struct debug_level debug_levels[] =3D {
>
>           .help =3D "Helper thread logging",
>
>           .shift =3D FD_HELPERTHREAD,
>
>         },
>
> +       { .name =3D "zbc",
>
> +         .help =3D "Zoned Block Device logging",
>
> +         .shift =3D FD_ZBC,
>
> +       },
>
>         { .name =3D NULL, },
>
>  };
>
>
>
> diff --git a/io_u.c b/io_u.c
>
> index 01b36938d1b5..ba4dbb9d8ecc 100644
>
> --- a/io_u.c
>
> +++ b/io_u.c
>
> @@ -14,6 +14,7 @@
>
>  #include "err.h"
>
>  #include "lib/pow2.h"
>
>  #include "minmax.h"
>
> +#include "zbc.h"
>
>
>
>  struct io_completion_data {
>
>         int nr;                         /* input */
>
> @@ -558,6 +559,9 @@ static int get_next_offset(struct thread_data *td, st=
ruct io_u *io_u,
>
>         if (get_next_block(td, io_u, ddir, rw_seq_hit, is_random))
>
>                 return 1;
>
>
>
> +       if (zbc_adjust_block(td, io_u))
>
> +               return 1;
>
> +
>
>         if (io_u->offset >=3D f->io_size) {
>
>                 dprint(FD_IO, "get_next_offset: offset %llu >=3D io_size =
%llu\n",
>
>                                         (unsigned long long) io_u->offset=
,
>
> diff --git a/ioengines.c b/ioengines.c
>
> index 965581aa4157..a04a977cca9f 100644
>
> --- a/ioengines.c
>
> +++ b/ioengines.c
>
> @@ -19,6 +19,7 @@
>
>
>
>  #include "fio.h"
>
>  #include "diskutil.h"
>
> +#include "zbc.h"
>
>
>
>  static FLIST_HEAD(engine_list);
>
>
>
> @@ -320,6 +321,8 @@ int td_io_queue(struct thread_data *td, struct io_u *=
io_u)
>
>         }
>
>
>
>         ret =3D td->io_ops->queue(td, io_u);
>
> +       if (ret < FIO_Q_BUSY)
>
> +               zbc_update_wp(td, io_u);
>
>
>
>         unlock_file(td, io_u->file);
>
>
>
> diff --git a/zbc.c b/zbc.c
>
> new file mode 100644
>
> index 000000000000..57e1981ee35d
>
> --- /dev/null
>
> +++ b/zbc.c
>
> @@ -0,0 +1,604 @@
>
> +/*
>
> + * Copyright (C) 2018 Western Digital Corporation or its affiliates.
>
> + *
>
> + * This file is released under the GPL.
>
> + */
>
> +
>
> +#include <errno.h>
>
> +#include <string.h>
>
> +#include <stdlib.h>
>
> +#include <dirent.h>
>
> +#include <fcntl.h>
>
> +#include <sys/ioctl.h>
>
> +#include <unistd.h>
>
> +#include <linux/blkzoned.h>
>
> +#include "file.h"
>
> +#include "fio.h"
>
> +#include "log.h"
>
> +#include "zbc.h"
>
> +
>
> +/* Return the name of the first entry in a directory */
>
> +static char *get_first_dirent(const char *dir_path)
>
> +{
>
> +       char *res =3D NULL;
>
> +       struct dirent *e;
>
> +       DIR *d;
>
> +
>
> +       d =3D opendir(dir_path);
>
> +       if (!d)
>
> +               return NULL;
>
> +       while ((e =3D readdir(d))) {
>
> +               /* Skip "." and ".." */
>
> +               if (e->d_name[0] =3D=3D '.')
>
> +                       continue;
>
> +               res =3D strdup(e->d_name);
>
> +               break;
>
> +       }
>
> +       closedir(d);
>
> +
>
> +       return res;
>
> +}
>
> +
>
> +/*
>
> + * Convert a block device name into a SCSI device path, e.g. /dev/sdc in=
to
>
> + * /sys/class/scsi_device/0:0:0:0.
>
> + */
>
> +static int bdev_to_scsi(char **scsi_id, const char *bdev)
>
> +{
>
> +       char *bdev_path =3D NULL, *bdev2 =3D NULL;
>
> +       struct dirent *e;
>
> +       bool matches;
>
> +       DIR *d;
>
> +       int res =3D 0;
>
> +
>
> +       if (strncmp(bdev, "/dev/", 5) !=3D 0)
>
> +               return -EINVAL;
>
> +       d =3D opendir("/sys/class/scsi_device");
>
> +       if (!d)
>
> +               return -ENOMEM;
>
> +       while ((e =3D readdir(d))) {
>
> +               /* Skip "." and ".." */
>
> +               if (e->d_name[0] =3D=3D '.')
>
> +                       continue;
>
> +               free(bdev_path);
>
> +               bdev_path =3D NULL;
>
> +               res =3D -ENOMEM;
>
> +               if (asprintf(&bdev_path,
>
> +                            "/sys/class/scsi_device/%s/device/block",
>
> +                            e->d_name) < 0)
>
> +                       break;
>
> +               bdev2 =3D get_first_dirent(bdev_path);
>
> +               matches =3D bdev2 && strcmp(bdev2, bdev + 5) =3D=3D 0;
>
> +               free(bdev2);
>
> +               if (matches) {
>
> +                       *scsi_id =3D strdup(e->d_name);
>
> +                       res =3D 0;
>
> +                       break;
>
> +               }
>
> +               res =3D -ENOENT;
>
> +       }
>
> +       closedir(d);
>
> +
>
> +       free(bdev_path);
>
> +
>
> +       return res;
>
> +}
>
> +
>
> +/*
>
> + * Get the SCSI device type from VPD page 0x80. That device type is call=
ed the
>
> + * "peripheral device type" in the SCSI SPC-5 standard. Returns -ENXIO i=
f and
>
> + * only if the device is not a SCSI device.
>
> + */
>
> +static int get_scsi_device_type(const char *bdev)
>
> +{
>
> +       char *scsi_id =3D NULL, *vpd_pg80_path =3D NULL;
>
> +       uint8_t vpd_pg80[8];
>
> +       int vpd_fd;
>
> +       int ret;
>
> +
>
> +       ret =3D bdev_to_scsi(&scsi_id, bdev);
>
> +       if (ret < 0 && ret !=3D -ENOENT)
>
> +               return ret;
>
> +       if (scsi_id =3D=3D NULL)
>
> +               return -ENXIO;
>
> +       dprint(FD_ZBC, "Block device %s has SCSI ID %s\n", bdev, scsi_id)=
;
>
> +       ret =3D -ENOMEM;
>
> +       if (asprintf(&vpd_pg80_path,
>
> +                    "/sys/class/scsi_device/%s/device/vpd_pg80", scsi_id=
) < 0)
>
> +               goto out;
>
> +
>
> +       vpd_fd =3D open(vpd_pg80_path, O_RDONLY);
>
> +       if (vpd_fd < 0)
>
> +               goto out;
>
> +       ret =3D read(vpd_fd, vpd_pg80, sizeof(vpd_pg80));
>
> +       close(vpd_fd);
>
> +       if (ret < sizeof(vpd_pg80))
>
> +               goto out;
>
> +
>
> +       ret =3D vpd_pg80[0] & 0x1f;
>
> +
>
> +out:
>
> +       free(vpd_pg80_path);
>
> +       free(scsi_id);
>
> +       return ret;
>
> +}
>
> +
>
> +/**
>
> + * zbc_reset_zone - reset the write pointer of one or more zones
>
> + * @f: FIO file associated with the disk for which to reset write pointe=
rs
>
> + * @sector: First sector for which to reset the write pointer in units o=
f 512
>
> + *     bytes.
>
> + * @nr_sectors: Number of sectors to reset the write pointer of.
>
> + */
>
> +static int zbc_reset_zone(const struct fio_file *f, uint64_t sector,
>
> +                         uint64_t nr_sectors)
>
> +{
>
> +       struct blk_zone_range zr =3D {
>
> +               .sector =3D sector,
>
> +               .nr_sectors =3D nr_sectors
>
> +       };
>
> +       int ret;
>
> +
>
> +       ret =3D ioctl(f->fd, BLKRESETZONE, &zr);
>
> +       if (ret < 0)
>
> +               log_err("%s: resetting wp for %lu sectors at sector %lu f=
ailed (%d).\n",
>
> +                       f->file_name, nr_sectors, sector, errno);
>
> +       return ret;
>
> +}
>
> +
>
> +/*
>
> + * Read zone information into @buf starting from sector @start_sector.
>
> + * @fd is a file descriptor that refers to a block device and @bufsz is =
the
>
> + * size of @buf.
>
> + */
>
> +static int read_zone_info(int fd, uint64_t start_sector,
>
> +                         void *buf, unsigned int bufsz)
>
> +{
>
> +       struct blk_zone_report *hdr =3D buf;
>
> +
>
> +       if (bufsz < sizeof(*hdr))
>
> +               return -EINVAL;
>
> +
>
> +       memset(hdr, 0, sizeof(*hdr));
>
> +
>
> +       hdr->nr_zones =3D (bufsz - sizeof(*hdr)) / sizeof(struct blk_zone=
);
>
> +       hdr->sector =3D start_sector;
>
> +       return ioctl(fd, BLKREPORTZONE, hdr);
>
> +}
>
> +
>
> +/*
>
> + * Initialize f->zbd_info.
>
> + */
>
> +int zbc_init_zone_info(struct fio_file *f)
>
> +{
>
> +       const unsigned int bufsz =3D sizeof(struct blk_zone_report) +
>
> +               32768 * sizeof(struct blk_zone);
>
> +       unsigned int nr_zones;
>
> +       struct blk_zone_report *hdr;
>
> +       const struct blk_zone *z;
>
> +       struct fio_zone_info *p;
>
> +       uint64_t zone_size, start_sector;
>
> +       struct zoned_block_device_info *zbd_info =3D NULL;
>
> +       void *buf;
>
> +       int fd, i, j, ret =3D -ENOMEM;
>
> +
>
> +       ret =3D get_scsi_device_type(f->file_name);
>
> +       if (ret =3D=3D -ENXIO) {
>
> +               dprint(FD_ZBC, "%s: not a SCSI device\n", f->file_name);
>
> +               ret =3D 0;
>
> +               goto out;
>
> +       }
>
> +       if (ret < 0)
>
> +               log_info("fio: unable to determine device type for %s.\n"=
,
>
> +                        f->file_name);
>
> +
>
> +       dprint(FD_ZBC, "Block device %s has SCSI device type %#x\n",
>
> +              f->file_name, ret);
>
> +
>
> +       if (ret !=3D 0x14 /* ZBC */) {
>
> +               ret =3D 0;
>
> +               goto out;
>
> +       }
>
> +
>
> +       dprint(FD_ZBC, "Reading zone information for device %s\n",
>
> +              f->file_name);
>
> +
>
> +       buf =3D malloc(bufsz);
>
> +       if (!buf)
>
> +               goto out;
>
> +
>
> +       fd =3D open(f->file_name, O_RDONLY | O_LARGEFILE);
>
> +       if (fd < 0) {
>
> +               ret =3D -errno;
>
> +               goto free;
>
> +       }
>
> +
>
> +       ret =3D read_zone_info(fd, 0, buf, bufsz);
>
> +       if (ret < 0) {
>
> +               log_info("fio: BLKREPORTZONE(%lu) failed for %s (%d).\n",
>
> +                        0UL, f->file_name, errno);
>
> +               goto close;
>
> +       }
>
> +       hdr =3D buf;
>
> +       if (hdr->nr_zones < 1) {
>
> +               log_info("fio: %s has invalid zone information.\n",
>
> +                        f->file_name);
>
> +               goto close;
>
> +       }
>
> +       z =3D (void *)(hdr + 1);
>
> +       zone_size =3D z->len;
>
> +       nr_zones =3D (f->real_file_size >> 9) / zone_size;
>
> +
>
> +       dprint(FD_ZBC, "Device %s has %d zones of size %lu\n", f->file_na=
me,
>
> +              nr_zones, zone_size);
>
> +
>
> +       zbd_info =3D calloc(1, sizeof(*zbd_info) +
>
> +                         (nr_zones + 1) * sizeof(zbd_info->zone_info[0])=
);
>
> +       ret =3D -ENOMEM;
>
> +       if (!zbd_info)
>
> +               goto close;
>
> +       p =3D &zbd_info->zone_info[0];
>
> +       for (start_sector =3D 0, j =3D 0; j < nr_zones;) {
>
> +               z =3D (void *)(hdr + 1);
>
> +               for (i =3D 0; i < hdr->nr_zones; i++, j++, z++, p++) {
>
> +                       p->start =3D z->start;
>
> +                       p->wp =3D z->wp;
>
> +                       p->type =3D z->type;
>
> +                       if (j > 0 && p->start !=3D p[-1].start + zone_siz=
e) {
>
> +                               log_info("%s: invalid zone data\n",
>
> +                                        f->file_name);
>
> +                               ret =3D -EINVAL;
>
> +                               goto close;
>
> +                       }
>
> +               }
>
> +               z--;
>
> +               start_sector =3D z->start + z->len;
>
> +               if (j >=3D nr_zones)
>
> +                       break;
>
> +               ret =3D read_zone_info(fd, start_sector, buf, bufsz);
>
> +               if (ret < 0) {
>
> +                       log_info("fio: BLKREPORTZONE(%lu) failed for %s (=
%d).\n",
>
> +                                start_sector, f->file_name, errno);
>
> +                       goto close;
>
> +               }
>
> +       }
>
> +       /* a sentinel */
>
> +       zbd_info->zone_info[nr_zones].start =3D start_sector;
>
> +
>
> +       f->zbd_info =3D zbd_info;
>
> +       f->zbd_info->zone_size =3D zone_size;
>
> +       f->zbd_info->nr_zones =3D nr_zones;
>
> +       zbd_info =3D NULL;
>
> +       ret =3D 0;
>
> +
>
> +close:
>
> +       free(zbd_info);
>
> +       close(fd);
>
> +free:
>
> +       free(buf);
>
> +out:
>
> +       return ret;
>
> +}
>
> +
>
> +/**
>
> + * zbc_zone_idx - convert an offset into a zone number
>
> + * @td: thread data.
>
> + * @f: file pointer.
>
> + * @offset: offset in bytes. If this offset equals the disk size then th=
e
>
> + *         index of the sentinel is returned.
>
> + */
>
> +static uint32_t zbc_zone_idx(const struct thread_data *td,
>
> +                            const struct fio_file *f, uint64_t offset)
>
> +{
>
> +       uint32_t zone_idx =3D (offset >> 9) / f->zbd_info->zone_size;
>
> +
>
> +       assert(offset <=3D f->real_file_size);
>
> +       assert(zone_idx <=3D f->zbd_info->nr_zones);
>
> +       return zone_idx;
>
> +}
>
> +
>
> +static bool zone_full(const struct fio_file *f, const struct fio_zone_in=
fo *z)
>
> +{
>
> +       return z->wp >=3D z->start + f->zbd_info->zone_size;
>
> +}
>
> +
>
> +static bool is_valid_offset(const struct fio_file *f, uint64_t offset)
>
> +{
>
> +       return (uint64_t)(offset - f->file_offset) < f->io_size;
>
> +}
>
> +
>
> +/* Verify whether direct I/O is used for all ZBC drives. */
>
> +static bool zbc_using_direct_io(void)
>
> +{
>
> +       struct thread_data *td;
>
> +       struct fio_file *f;
>
> +       int i, j;
>
> +
>
> +       for_each_td(td, i) {
>
> +               if (td->o.odirect)
>
> +                       continue;
>
> +               for_each_file(td, f, j) {
>
> +                       if (f->zbd_info)
>
> +                               return false;
>
> +               }
>
> +       }
>
> +
>
> +       return true;
>
> +}
>
> +
>
> +static bool other_job_writes_to(struct thread_data *const td,
>
> +                               struct fio_file *const f,
>
> +                               const int i, const int j)
>
> +{
>
> +       struct thread_data *td2;
>
> +       struct fio_file *f2;
>
> +       int k, m;
>
> +
>
> +       for_each_td(td2, k) {
>
> +               if ((td->o.td_ddir & (TD_DDIR_WRITE | TD_DDIR_TRIM)) =3D=
=3D 0)
>
> +                       continue;
>
> +               for_each_file(td2, f2, m) {
>
> +                       if (k =3D=3D i && m =3D=3D j)
>
> +                               continue;
>
> +                       if (f2->zbd_info &&
>
> +                           strcmp(f->file_name, f2->file_name) =3D=3D 0)
>
> +                               return true;
>
> +               }
>
> +       }
>
> +
>
> +       return false;
>
> +}
>
> +
>
> +/*
>
> + * Check whether multiple ZBC write or trim jobs have been specified for=
 the
>
> + * same drive.
>
> + *
>
> + * To do: refine this code such that locking is only required if multipl=
e
>
> + * ZBC write or trim jobs have been specified for the same drive.
>
> + */
>
> +static bool zbc_multiple_writers(void)
>
> +{
>
> +       struct thread_data *td;
>
> +       struct fio_file *f;
>
> +       int i, j;
>
> +
>
> +       for_each_td(td, i) {
>
> +               if ((td->o.td_ddir & (TD_DDIR_WRITE | TD_DDIR_TRIM)) =3D=
=3D 0)
>
> +                       continue;
>
> +               for_each_file(td, f, j)
>
> +                       if (f->zbd_info &&
>
> +                           other_job_writes_to(td, f, i, j))
>
> +                               return true;
>
> +       }
>
> +
>
> +       return false;
>
> +}
>
> +
>
> +static bool zbc_verify_sizes(void)
>
> +{
>
> +       const struct fio_zone_info *z;
>
> +       struct thread_data *td;
>
> +       struct fio_file *f;
>
> +       uint64_t new_offset, new_start;
>
> +       uint32_t zone_idx;
>
> +       int i, j;
>
> +
>
> +       for_each_td(td, i) {
>
> +               for_each_file(td, f, j) {
>
> +                       if (!f->zbd_info)
>
> +                               continue;
>
> +                       zone_idx =3D zbc_zone_idx(td, f, f->file_offset);
>
> +                       z =3D &f->zbd_info->zone_info[zone_idx];
>
> +                       if ((z->start << 9) !=3D f->file_offset) {
>
> +                               new_offset =3D (z->start +
>
> +                                             f->zbd_info->zone_size) << =
9;
>
> +                               log_info("%s: rounded up offset from %lu =
to %lu\n",
>
> +                                        f->file_name, f->file_offset,
>
> +                                        new_offset);
>
> +                               f->io_size -=3D (new_offset - f->file_off=
set);
>
> +                               f->file_offset =3D new_offset;
>
> +                       }
>
> +                       zone_idx =3D zbc_zone_idx(td, f, f->file_offset +
>
> +                                               f->io_size);
>
> +                       z =3D &f->zbd_info->zone_info[zone_idx];
>
> +                       new_start =3D z->start << 9;
>
> +                       if (f->file_offset + f->io_size !=3D new_start) {
>
> +                               if (new_start =3D=3D f->file_offset) {
>
> +                                       log_info("%s: io_size must be at =
least one zone\n",
>
> +                                                f->file_name);
>
> +                                       return false;
>
> +                               }
>
> +                               log_info("%s: rounded down io_size from %=
lu to %lu\n",
>
> +                                        f->file_name, f->io_size, new_st=
art);
>
> +                               f->io_size =3D new_start;
>
> +                       }
>
> +               }
>
> +       }
>
> +
>
> +       return true;
>
> +}
>
> +
>
> +int zbc_verify_options(void)
>
> +{
>
> +       if (!zbc_using_direct_io()) {
>
> +               log_err("Using direct I/O is mandatory for ZBC drives\n\n=
");
>
> +               return 1;
>
> +       }
>
> +
>
> +       if (zbc_multiple_writers()) {
>
> +               log_err("Concurrent writing to ZBC disks is not supported=
\n\n");
>
> +               return 1;
>
> +       }
>
> +
>
> +       if (!zbc_verify_sizes())
>
> +               return 1;
>
> +
>
> +       return 0;
>
> +}
>
> +
>
> +/**
>
> + * zbc_adjust_block - adjust the offset and length as necessary for ZBC =
drives
>
> + * @td: FIO thread data.
>
> + * @io_u: FIO I/O unit.
>
> + *
>
> + * Returns 0 if the I/O unit should be used and 1 if not.
>
> + */
>
> +int zbc_adjust_block(const struct thread_data *td, struct io_u *io_u)
>
> +{
>
> +       const struct fio_file *f =3D io_u->file;
>
> +       uint32_t zone_idx_b, zone_idx_e;
>
> +       struct fio_zone_info *zb, *ze;
>
> +       uint64_t offset, orig_o =3D io_u->offset;
>
> +       uint32_t orig_len =3D io_u->buflen;
>
> +       uint64_t delta;
>
> +
>
> +       if (!f->zbd_info)
>
> +               return 0;
>
> +
>
> +       zone_idx_b =3D zbc_zone_idx(td, f, f->file_offset + io_u->offset)=
;
>
> +       zone_idx_e =3D zbc_zone_idx(td, f, f->file_offset + io_u->offset =
+
>
> +                                 (io_u->buflen ? io_u->buflen - 1 : 0));
>
> +       zb =3D &f->zbd_info->zone_info[zone_idx_b];
>
> +       ze =3D &f->zbd_info->zone_info[zone_idx_e];
>
> +
>
> +       switch (io_u->ddir) {
>
> +       case DDIR_READ:
>
> +               /*
>
> +                * From the ZBC spec: a read operation past the write poi=
nter
>
> +                * of a zone shall return logical block data set to the l=
ast
>
> +                * initialization pattern that was set at manufacture tim=
e,
>
> +                * by the FORMAT UNIT command or by the most recent SANIT=
IZE
>
> +                * command with the service action set to OVERWRITE. Henc=
e,
>
> +                * for random I/O, do not read past the write pointer.
>
> +                */
>
> +               if (!td_random(td))
>
> +                       return 0;
>
> +               if (io_u->buflen > ((zb->wp - zb->start) << 9))
>
> +                       return 1;
>
> +               if (io_u->offset + io_u->buflen > (zb->wp << 9)) {
>
> +                       io_u->offset =3D (zb->wp << 9) - io_u->buflen;
>
> +                       dprint(FD_IO,
>
> +                              "changed write offset from %ld into %lld\n=
",
>
> +                              orig_o, io_u->offset);
>
> +               }
>
> +               return 0;
>
> +       case DDIR_WRITE:
>
> +               if (zb->type !=3D BLK_ZONE_TYPE_SEQWRITE_REQ)
>
> +                       return 0;
>
> +               /* Make writes occur at the write pointer */
>
> +               if (zone_full(f, zb)) {
>
> +                       if (zbc_reset_zone(f, zb->start,
>
> +                                          f->zbd_info->zone_size) < 0)
>
> +                               return 1;
>
> +                       zb->wp =3D zb->start;
>
> +                       offset =3D zb->start << 9;
>
> +                       dprint(FD_IO,
>
> +                              "reset zone write pointer at offset %ld\n"=
,
>
> +                              offset);
>
> +               } else {
>
> +                       offset =3D zb->wp << 9;
>
> +               }
>
> +               if (!is_valid_offset(f, offset))
>
> +                       return 1;
>
> +               io_u->offset =3D offset - f->file_offset;
>
> +               if (orig_o !=3D io_u->offset)
>
> +                       dprint(FD_IO,
>
> +                              "changed write offset from %ld into %lld\n=
",
>
> +                              orig_o, io_u->offset);
>
> +               /* Shrink write requests that cross zone boundaries. */
>
> +               if (zone_idx_b !=3D zone_idx_e) {
>
> +                       io_u->buflen =3D ((zb->start + f->zbd_info->zone_=
size)
>
> +                                       << 9) - (io_u->offset + f->file_o=
ffset);
>
> +                       dprint(FD_IO, "Changed length from %u into %lu\n"=
,
>
> +                              orig_len, io_u->buflen);
>
> +               }
>
> +               return 0;
>
> +       case DDIR_TRIM:
>
> +               /* Align trims to zone boundaries. */
>
> +               if (zone_idx_b =3D=3D zone_idx_e) {
>
> +                       if (zb->type =3D=3D BLK_ZONE_TYPE_SEQWRITE_REQ &&
>
> +                           io_u->buflen < f->zbd_info->zone_size)
>
> +                               io_u->buflen =3D 0;
>
> +               } else {
>
> +                       if (zb->type =3D=3D BLK_ZONE_TYPE_SEQWRITE_REQ) {
>
> +                               delta =3D f->zbd_info->zone_size -
>
> +                                       (f->file_offset + io_u->offset -
>
> +                                        (zb->start << 9));
>
> +                               io_u->offset +=3D delta;
>
> +                               io_u->buflen -=3D delta;
>
> +                       }
>
> +                       if (ze->type =3D=3D BLK_ZONE_TYPE_SEQWRITE_REQ)
>
> +                               io_u->buflen -=3D (f->file_offset +
>
> +                                                io_u->offset + io_u->buf=
len) -
>
> +                                       (ze->start << 9);
>
> +               }
>
> +               dprint(FD_IO, "Changed trim range from %lu + %u into %llu=
 + %lu (adjustments: offset + %llu; len - %lu)\n",
>
> +                      orig_o, orig_len, io_u->offset, io_u->buflen,
>
> +                      io_u->offset - orig_o, orig_len - io_u->buflen);
>
> +               return 0;
>
> +       case DDIR_SYNC:
>
> +       case DDIR_DATASYNC:
>
> +       case DDIR_SYNC_FILE_RANGE:
>
> +       case DDIR_WAIT:
>
> +       case DDIR_LAST:
>
> +       case DDIR_INVAL:
>
> +               return 0;
>
> +       }
>
> +
>
> +       assert(false);
>
> +       return 1;
>
> +}
>
> +
>
> +/**
>
> + * zbc_update_wp - update the write pointer
>
> + * @td: thread data
>
> + * @io_u: I/O unit
>
> + *
>
> + * For write and trim operations, update the write pointer of all affect=
ed
>
> + * zones.
>
> + */
>
> +void zbc_update_wp(struct thread_data *td, const struct io_u *io_u)
>
> +{
>
> +       struct zoned_block_device_info *zbd_info;
>
> +       struct fio_zone_info *z;
>
> +       uint32_t zone_idx;
>
> +       uint64_t end;
>
> +
>
> +       if (!io_u->file->zbd_info)
>
> +               return;
>
> +
>
> +       switch (io_u->ddir) {
>
> +       case DDIR_READ:
>
> +       case DDIR_SYNC:
>
> +       case DDIR_DATASYNC:
>
> +       case DDIR_SYNC_FILE_RANGE:
>
> +       case DDIR_WAIT:
>
> +       case DDIR_LAST:
>
> +       case DDIR_INVAL:
>
> +               return;
>
> +       case DDIR_WRITE:
>
> +       case DDIR_TRIM:
>
> +               break;
>
> +       }
>
> +
>
> +       zbd_info =3D io_u->file->zbd_info;
>
> +       zone_idx =3D zbc_zone_idx(td, io_u->file, io_u->offset);
>
> +       end =3D (io_u->offset + io_u->buflen) >> 9;
>
> +       for (z =3D &zbd_info->zone_info[zone_idx]; z->start < end;
>
> +            z++, zone_idx++) {
>
> +               assert(zone_idx < zbd_info->nr_zones);
>
> +               if (z->type !=3D BLK_ZONE_TYPE_SEQWRITE_REQ)
>
> +                       continue;
>
> +               switch (io_u->ddir) {
>
> +               case DDIR_WRITE:
>
> +                       z->wp =3D end;
>
> +                       break;
>
> +               case DDIR_TRIM:
>
> +                       z->wp =3D z->start;
>
> +                       break;
>
> +               default:
>
> +                       assert(false);
>
> +                       break;
>
> +               }
>
> +       }
>
> +}
>
> diff --git a/zbc.h b/zbc.h
>
> new file mode 100644
>
> index 000000000000..de2a39551ca8
>
> --- /dev/null
>
> +++ b/zbc.h
>
> @@ -0,0 +1,69 @@
>
> +/*
>
> + * Copyright (C) 2018 Western Digital Corporation or its affiliates.
>
> + *
>
> + * This file is released under the GPL.
>
> + */
>
> +
>
> +#ifndef FIO_ZBC_H
>
> +#define FIO_ZBC_H
>
> +
>
> +#include <inttypes.h>
>
> +
>
> +struct fio_file;
>
> +
>
> +/**
>
> + * struct fio_zone_info - information about a single ZBC zone
>
> + * @start: zone start in 512 byte units
>
> + * @wp: zone write pointer location in 512 byte units
>
> + * @type: zone type as defined by enum blk_zone_type
>
> + */
>
> +struct fio_zone_info {
>
> +       uint64_t        start;
>
> +       uint64_t        wp;
>
> +       uint8_t         type;
>
> +};
>
> +
>
> +/**
>
> + * zoned_block_device_info - zoned block device characteristics
>
> + * @zone_size: size of a single zone in units of 512 bytes
>
> + * @nr_zones: number of zones
>
> + * @zone_info: description of the individual zones
>
> + *
>
> + * Only devices for which all zones have the same size are supported.
>
> + * Note: if the capacity is not a multiple of the zone size then the las=
t zone
>
> + * will be smaller than 'zone_size'.
>
> + */
>
> +struct zoned_block_device_info {
>
> +       uint64_t                zone_size;
>
> +       uint64_t                nr_zones;
>
> +       struct fio_zone_info    zone_info[0];
>
> +};
>
> +
>
> +#ifdef HAVE_LINUX_BLKZONED_H
>
> +int zbc_init_zone_info(struct fio_file *f);
>
> +int zbc_verify_options(void);
>
> +int zbc_adjust_block(const struct thread_data *td, struct io_u *io_u);
>
> +void zbc_update_wp(struct thread_data *td, const struct io_u *io_u);
>
> +#else
>
> +static inline int zbc_init_zone_info(struct fio_file *f)
>
> +{
>
> +       return 0;
>
> +}
>
> +
>
> +static inline int zbc_verify_options(void)
>
> +{
>
> +       return 0;
>
> +}
>
> +
>
> +static inline int zbc_adjust_block(struct thread_data *td, struct io_u *=
io_u)
>
> +{
>
> +       return 0;
>
> +}
>
> +
>
> +static inline void zbc_update_wp(struct thread_data *td,
>
> +                                const struct io_u *io_u)
>
> +{
>
> +}
>
> +#endif
>
> +
>
> +#endif /* FIO_ZBC_H */
>
>
>
>
>
