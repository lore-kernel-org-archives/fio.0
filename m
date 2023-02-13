Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A767FC636CC
	for <fio@archiver.kernel.org>; Mon, 13 Feb 2023 12:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjBMMOF (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 13 Feb 2023 07:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjBMMN4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Feb 2023 07:13:56 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD6C1B315
        for <fio@vger.kernel.org>; Mon, 13 Feb 2023 04:13:26 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-52f0001ff8eso60889347b3.4
        for <fio@vger.kernel.org>; Mon, 13 Feb 2023 04:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WJfVmAN2i+L+G9mUEMBNmhK95UwujYc6PNYRqaf+3YE=;
        b=KXCsxxFrOVI2RSPXyUXOYg6GEuFmQI/X2nc8wVTsQIgU0XkHu7ZOr+EshjtOk2oXXM
         2okb+YbUiTqYyP0XTO35t5VdurT4NIwwKO8iEhynqWRhUG9QuxPJpgpDX5HgvUAo/j/e
         O1+2PFj6/n4g3bzWUjNxZBwKfwIz+IkTRF6oyoGXpEHM/1NhO+aj8HY8CxR2jPS5bd48
         F1ylgNSdrO3aIfqCP2/aWtvvEH+osSvpi1GxSG4+aYKmFKyckR4vvNBhgYajQu1Dt/7y
         qbn0oquZVub5K9aHmd9aWZS5+uHf83NgcTZm/ooqyUeLRftN7RYYWwTTajqguhlCSa/Q
         45pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WJfVmAN2i+L+G9mUEMBNmhK95UwujYc6PNYRqaf+3YE=;
        b=WMKqF3VxUZVOARGtny5zujPiVH5Cflyf+/dxEmVxOM2YNbGMsDkJ9Br7Qh7nq9FAfH
         Ljyad4G6fqxtVUzBXID7wdRxV6ETIvlZW739R/uemLXN4iRJk43ursAANCZrQwXhzkom
         6z22VHmgPHX13AXmy7CnCokd9XpYFfkqJQmYIEml9Yqsyo01IfxcQIiUtGpCVDIYwsDv
         zldUZyKOpiRIaSzWlEbltTIlTHEtH2B0I2REFRAffavgwY+dd8eUZ/hUeAVOFW558ZXO
         /8JRnEE/fPVJ5fCN/QEYclEh15HgIp8hdJCoWZQhuF4E0nLycDl8s7ro488rwYa0ljrt
         WIJg==
X-Gm-Message-State: AO0yUKUW/mmMvbOCu4ddVcjCG794Y3npAcNsUtjGLfSj92Yc7mZchOBa
        tEUzActjkk/NWQ/8/lvRIFfCp8IkUJSallgekv2BN4KHYiQ=
X-Google-Smtp-Source: AK7set+mjwL1t23TPKoBAu7pUx0+tw6Qaf889KmDNpt1QoG4pzNf4SIHxM724lPMqUALrkcMeCxs6UaSKKvz9wze4X4=
X-Received: by 2002:a81:a1c5:0:b0:52e:d361:6836 with SMTP id
 y188-20020a81a1c5000000b0052ed3616836mr1277582ywg.21.1676290368443; Mon, 13
 Feb 2023 04:12:48 -0800 (PST)
MIME-Version: 1.0
References: <CGME20230209171249epcas5p34771bbde03c3eda8ecfba1e164a16086@epcas5p3.samsung.com>
 <20230209171236.1113887-1-kbusch@meta.com> <20230210062911.GA6390@green5>
In-Reply-To: <20230210062911.GA6390@green5>
From:   Ankit Kumar <ankit1455@gmail.com>
Date:   Mon, 13 Feb 2023 17:41:54 +0530
Message-ID: <CAKi7+we8MckKM6qeyzhEx9hmV7abqMpKMYLF9MuHyh_gA8ET-Q@mail.gmail.com>
Subject: Re: [PATCHv2] fio: add fdp support for io_uring_cmd nvme engine
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     Keith Busch <kbusch@meta.com>, fio@vger.kernel.org,
        axboe@kernel.dk, its@irrelevant.dk, kbusch@kernel.org,
        vincentfu@gmail.com, damien.lemoal@opensource.wdc.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Feb 10, 2023 at 12:12 PM Ankit Kumar <ankit.kumar@samsung.com> wrote:
>
> On Thu, Feb 09, 2023 at 09:12:36AM -0800, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> >
> > Add support for NVMe TP4146 Flexible Data Placemen, allowing placement
> > identifiers in write commands. The user can enabled this with the new
> > "fdp=1" parameter for fio's io_uring_cmd ioengine. By default, the fio
> > jobs will cycle through all the namespace's available placement
> > identifiers for write commands. The user can limit which placement
> > identifiers can be used with additional parameter, "fdp_plis=<list,>",
> > which can be used to separate write intensive jobs from less intensive
> > ones.
> >
> > Setting up your namespace for FDP is outside the scope of 'fio', so this
> > assumes the namespace is already properly configured for the mode.
> >
> > Based-on-a-patch-by: Ankit Kumar <ankit.kumar@samsung.com>
> > Signed-off-by: Keith Busch <kbusch@kernel.org>
> > ---
> > v1->v2:
> >
> > Actually 'git add' the new source files (Vincent, Ankit)
> >
> > Added HOWTO and fio.1 documentation on new options (Jens)
> >
> > Fix whitespace (Jens)
> >
> > Bump FIO_IOOPS_VERSION (Damien)
> >
> > Dropped the unnecessary fdp checks and infrastructure for it, relying
> > only on the iomgmt to provide fdp state.
> >
> >  HOWTO.rst                  |  10 +++
> >  Makefile                   |   2 +-
> >  engines/io_uring.c         |  23 +++++++
> >  engines/nvme.c             |  39 +++++++++++-
> >  engines/nvme.h             |  20 ++++++
> >  examples/uring-cmd-fdp.fio |  37 ++++++++++++
> >  fdp.c                      | 121 +++++++++++++++++++++++++++++++++++++
> >  fdp.h                      |  16 +++++
> >  file.h                     |   3 +
> >  filesetup.c                |   7 +++
> >  fio.1                      |   8 +++
> >  io_u.c                     |   3 +
> >  io_u.h                     |   3 +
> >  ioengines.h                |   5 +-
> >  options.c                  |  49 +++++++++++++++
> >  thread_options.h           |   7 +++
> >  16 files changed, 350 insertions(+), 3 deletions(-)
> >  create mode 100644 examples/uring-cmd-fdp.fio
> >  create mode 100644 fdp.c
> >  create mode 100644 fdp.h
> >
> > diff --git a/HOWTO.rst b/HOWTO.rst
> > index 17caaf5d..1e4dd25e 100644
> > --- a/HOWTO.rst
> > +++ b/HOWTO.rst
> > @@ -2431,6 +2431,16 @@ with the caveat that when used on the command line, they must come after the
> >       For direct I/O, requests will only succeed if cache invalidation isn't required,
> >       file blocks are fully allocated and the disk request could be issued immediately.
> >
> > +.. option:: fdp=bool : [io_uring_cmd]
> > +
> > +     Enable Flexible Data Placement mode for write commands.
> > +
> > +.. option:: fdp_pli=int[,int][,int] : [io_uring_cmd]
> I think it probably should just be "fdp_pli=str"
> Kind of similar to the fio "option cpus_allowed=str"
> > +
> > +     Select which Placement ID Index/Indicies this job is allowed to use for
> > +     writes. By default, the job will cycle through all available Placement
> > +     IDs, so use this to isolate these identifiers to specific jobs..
> Maybe we can also add one line description something like this:
> If you want fio to use placement identifier only at indices 0,2 and 5 specify
> ``fdp_pli=0,2,5``.
> > +
> >  .. option:: cpuload=int : [cpuio]
> >
> >       Attempt to use the specified percentage of CPU cycles. This is a mandatory
> > diff --git a/Makefile b/Makefile
> > index 5f4e6562..89205ebf 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -62,7 +62,7 @@ SOURCE :=   $(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
> >               gettime-thread.c helpers.c json.c idletime.c td_error.c \
> >               profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
> >               workqueue.c rate-submit.c optgroup.c helper_thread.c \
> > -             steadystate.c zone-dist.c zbd.c dedupe.c
> > +             steadystate.c zone-dist.c zbd.c dedupe.c fdp.c
> >
> >  ifdef CONFIG_LIBHDFS
> >    HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
> > diff --git a/engines/io_uring.c b/engines/io_uring.c
> > index a9abd11d..4d1ee021 100644
> > --- a/engines/io_uring.c
> > +++ b/engines/io_uring.c
> > @@ -1262,6 +1262,28 @@ static int fio_ioring_cmd_get_max_open_zones(struct thread_data *td,
> >       return fio_nvme_get_max_open_zones(td, f, max_open_zones);
> >  }
> >
> > +static int fio_ioring_cmd_fetch_ruhs(struct thread_data *td, struct fio_file *f,
> > +                                  struct fio_ruhs_info *fruhs_info)
> > +{
> > +     struct nvme_fdp_ruh_status *ruhs;
> > +     int bytes, ret, i;
> > +
> > +     bytes = sizeof(*ruhs) + 1024 * sizeof(struct nvme_fdp_ruh_status_desc);
> > +     ruhs = malloc(bytes);
> > +     memset(ruhs, 0, bytes);
> > +
> > +     ret = fio_nvme_iomgmt_ruhs(td, f, ruhs, bytes);
> > +     if (ret)
> > +             goto free;
> > +
> > +     fruhs_info->nr_ruhs = le16_to_cpu(ruhs->nruhsd);
> > +     for (i = 0; i < fruhs_info->nr_ruhs; i++)
> > +             fruhs_info->plis[i] = le16_to_cpu(ruhs->ruhss[i].pid);
> > +free:
> > +     free(ruhs);
> > +     return ret;
> > +}
> > +
> >  static struct ioengine_ops ioengine_uring = {
> >       .name                   = "io_uring",
> >       .version                = FIO_IOOPS_VERSION,
> > @@ -1307,6 +1329,7 @@ static struct ioengine_ops ioengine_uring_cmd = {
> >       .get_max_open_zones     = fio_ioring_cmd_get_max_open_zones,
> >       .options                = options,
> >       .option_struct_size     = sizeof(struct ioring_options),
> > +     .fdp_fetch_ruhs         = fio_ioring_cmd_fetch_ruhs,
> >  };
> >
> >  static void fio_init fio_ioring_register(void)
> > diff --git a/engines/nvme.c b/engines/nvme.c
> > index 9ffc5303..e23f909d 100644
> > --- a/engines/nvme.c
> > +++ b/engines/nvme.c
> > @@ -28,7 +28,8 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
> >       cmd->cdw10 = slba & 0xffffffff;
> >       cmd->cdw11 = slba >> 32;
> >       /* cdw12 represent number of lba's for read/write */
> > -     cmd->cdw12 = nlb;
> > +     cmd->cdw12 = nlb | (io_u->dtype << 20);
> > +     cmd->cdw13 = io_u->dspec << 16;
> >       if (iov) {
> >               iov->iov_base = io_u->xfer_buf;
> >               iov->iov_len = io_u->xfer_buflen;
> > @@ -345,3 +346,39 @@ out:
> >       close(fd);
> >       return ret;
> >  }
> > +
> > +static inline int nvme_fdp_reclaim_unit_handle_status(int fd, __u32 nsid,
> > +                                                   __u32 data_len, void *data)
> > +{
> > +     struct nvme_passthru_cmd cmd = {
> > +             .opcode         = nvme_cmd_io_mgmt_recv,
> > +             .nsid           = nsid,
> > +             .addr           = (__u64)(uintptr_t)data,
> > +             .data_len       = data_len,
> > +             .cdw10          = 1,
> > +             .cdw11          = (data_len >> 2) - 1,
> > +     };
> > +
> > +     return ioctl(fd, NVME_IOCTL_IO_CMD, &cmd);
> > +}
> > +
> > +int fio_nvme_iomgmt_ruhs(struct thread_data *td, struct fio_file *f,
> > +                      struct nvme_fdp_ruh_status *ruhs, __u32 bytes)
> > +{
> > +     struct nvme_data *data = FILE_ENG_DATA(f);
> > +     int fd, ret;
> > +
> > +     fd = open(f->file_name, O_RDONLY | O_LARGEFILE);
> > +     if (fd < 0)
> > +             return -errno;
> > +
> > +     ret = nvme_fdp_reclaim_unit_handle_status(fd, data->nsid, bytes, ruhs);
> > +     if (ret) {
> > +             log_err("%s: nvme_fdp_reclaim_unit_handle_status failed, err=%d\n",
> > +                     f->file_name, ret);
> > +             errno = ENOTSUP;
> > +     }
> > +
> > +     close(fd);
> > +     return -errno;
> should be "return ret;"
> > +}
> > diff --git a/engines/nvme.h b/engines/nvme.h
> > index 70a89b74..42ed30a1 100644
> > --- a/engines/nvme.h
> > +++ b/engines/nvme.h
> > @@ -67,6 +67,7 @@ enum nvme_admin_opcode {
> >  enum nvme_io_opcode {
> >       nvme_cmd_write                  = 0x01,
> >       nvme_cmd_read                   = 0x02,
> > +     nvme_cmd_io_mgmt_recv           = 0x12,
> >       nvme_zns_cmd_mgmt_send          = 0x79,
> >       nvme_zns_cmd_mgmt_recv          = 0x7a,
> >  };
> > @@ -192,6 +193,25 @@ struct nvme_zone_report {
> >       struct nvme_zns_desc    entries[];
> >  };
> >
> > +struct nvme_fdp_ruh_status_desc {
> > +     __u16 pid;
> > +     __u16 ruhid;
> > +     __u32 earutr;
> > +     __u64 ruamw;
> > +     __u8  rsvd16[16];
> > +};
> > +
> > +struct nvme_fdp_ruh_status {
> > +     __u8  rsvd0[14];
> > +     __le16 nruhsd;
> > +     struct nvme_fdp_ruh_status_desc ruhss[];
> > +};
> > +
> > +int fio_nvme_iomgmt_ruhs(struct thread_data *td, struct fio_file *f,
> > +                      struct nvme_fdp_ruh_status *ruhs, __u32 bytes);
> > +
> > +int fio_nvme_is_fdp(struct thread_data *td, struct fio_file *f, bool *fdp);
> > +

Missed the first time, this function prototype should also be removed.

> >  int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
> >                     __u64 *nlba);
> >
> > diff --git a/examples/uring-cmd-fdp.fio b/examples/uring-cmd-fdp.fio
> > new file mode 100644
> > index 00000000..55d741d3
> > --- /dev/null
> > +++ b/examples/uring-cmd-fdp.fio
> > @@ -0,0 +1,37 @@
> > +# io_uring_cmd I/O engine for nvme-ns generic character device with FDP enabled
> > +# This assumes the namespace is already configured with FDP support and has at
> > +# least 8 available reclaim units.
> > +#
> > +# Each job targets different ranges of LBAs with different placement
> > +# identifiers, and has different write intensity.
> > +
> > +[global]
> > +filename=/dev/ng0n1
> > +ioengine=io_uring_cmd
> > +cmd_type=nvme
> > +iodepth=32
> > +bs=4K
> > +fdp=1
> > +time_based=1
> > +runtime=1000
> > +
> > +[write-heavy]
> > +rw=randrw
> > +rwmixwrite=90
> > +fdp_pli=0,1,2,3
> > +offset=0%
> > +size=30%
> > +
> > +[write-mid]
> > +rw=randrw
> > +rwmixwrite=30
> > +fdp_pli=4,5
> > +offset=30%
> > +size=30%
> > +
> > +[write-light]
> > +rw=randrw
> > +rwmixwrite=10
> > +fdp_pli=6
> > +offset=60%
> > +size=30%
> > diff --git a/fdp.c b/fdp.c
> > new file mode 100644
> > index 00000000..50ffa392
> > --- /dev/null
> > +++ b/fdp.c
> > @@ -0,0 +1,121 @@
> > +/*
> > + * Note: This is similar to a very basic setup
> > + * of ZBD devices
> > + *
> > + * Specify fdp=1 (With char devices /dev/ng0n1)
> > + */
> > +
> > +#include <errno.h>
> > +#include <string.h>
> > +#include <stdlib.h>
> > +#include <unistd.h>
> > +#include "file.h"
> > +#include "fio.h"
> > +
> > +#include "pshared.h"
> > +#include <fdp.h>
> #include "fdp.h"
> > +
> > +/*
> > + * Maximum number of RUHS to fetch
> > + * TODO: Revisit this so that we can work with more than 1024 RUH's
> > + */
> For me, I will send a fix once these changes get merged.
> > +#define FDP_FETCH_RUHS_MAX   1024U
> > +
> > +static int fdp_ruh_info(struct thread_data *td, struct fio_file *f,
> > +                     struct fio_ruhs_info *ruhs)
> > +{
> > +     int ret = -EINVAL;
> > +
> > +     if (td->io_ops && td->io_ops->fdp_fetch_ruhs)
> > +             ret = td->io_ops->fdp_fetch_ruhs(td, f, ruhs);
> > +     else
> > +             log_err("%s: engine (%s) lacks fetch ruhs.\n",
> > +                     f->file_name, td->io_ops->name);
> > +     if (ret < 0) {
> > +             td_verror(td, errno, "fdp fetch ruhs failed");
> > +             log_err("%s: fdp fetch ruhs failed (%d).\n",
> > +                     f->file_name, errno);
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +static int init_ruh_info(struct thread_data *td, struct fio_file *f)
> > +{
> > +     struct fio_ruhs_info *ruhs, *tmp;
> > +     int i, ret;
> > +
> > +     ruhs = calloc(1, sizeof(*ruhs) +
> > +                        FDP_FETCH_RUHS_MAX * sizeof(*ruhs->plis));
> > +     if (!ruhs)
> > +             return -ENOMEM;
> > +
> > +     ret = fdp_ruh_info(td, f, ruhs);
> > +     if (ret) {
> > +             log_info("fio: ruh info failed for %s (%d).\n",
> > +                      f->file_name, -ret);
> > +             goto out;
> > +     }
> > +
> > +     if (ruhs->nr_ruhs > FDP_FETCH_RUHS_MAX)
> > +             ruhs->nr_ruhs = FDP_FETCH_RUHS_MAX;
> > +
> > +     if (td->o.fdp_nrpli == 0) {
> > +             f->ruhs_info = ruhs;
> > +             return 0;
> > +     }
> > +
> > +     for (i = 0; i < td->o.fdp_nrpli; i++) {
> > +             if (td->o.fdp_plis[i] > ruhs->nr_ruhs) {
> > +                     ret = -EINVAL;
> > +                     goto out;
> > +             }
> > +     }
> > +
> > +     tmp = calloc(1, sizeof(*tmp) + ruhs->nr_ruhs * sizeof(*tmp->plis));
> > +     tmp->nr_ruhs = td->o.fdp_nrpli;
> > +     for (i = 0; i < td->o.fdp_nrpli; i++)
> > +             tmp->plis[i] = ruhs->plis[td->o.fdp_plis[i]];
> > +     f->ruhs_info = tmp;
> > +out:
> > +     free(ruhs);
> > +     return ret;
> > +}
> > +
> > +int fdp_init(struct thread_data *td)
> > +{
> > +     struct fio_file *f;
> > +     int i, ret = 0;
> > +
> > +     for_each_file(td, f, i) {
> > +             ret = init_ruh_info(td, f);
> > +             if (ret)
> > +                     break;
> > +     }
> > +     return ret;
> > +}
> > +
> > +void fdp_free_ruhs_info(struct fio_file *f)
> > +{
> > +     if (!f->ruhs_info)
> > +             return;
> > +     free(f->ruhs_info);
> > +     f->ruhs_info = NULL;
> > +}
> > +
> > +void fdp_fill_dspec_data(struct thread_data *td, struct io_u *io_u)
> > +{
> > +     struct fio_file *f = io_u->file;
> > +     struct fio_ruhs_info *ruhs = f->ruhs_info;
> > +     int dspec;
> > +
> > +     if (!ruhs || io_u->ddir != DDIR_WRITE) {
> > +             io_u->dtype = 0;
> > +             io_u->dspec = 0;
> > +             return;
> > +     }
> > +
> > +     dspec = ruhs->plis[ruhs->pli_loc++ % ruhs->nr_ruhs];
> > +     io_u->dtype = 2;
> > +     io_u->dspec = dspec;
> > +}
> > diff --git a/fdp.h b/fdp.h
> > new file mode 100644
> > index 00000000..81691f62
> > --- /dev/null
> > +++ b/fdp.h
> > @@ -0,0 +1,16 @@
> > +#ifndef FIO_FDP_H
> > +#define FIO_FDP_H
> > +
> > +#include "io_u.h"
> > +
> > +struct fio_ruhs_info {
> > +     uint32_t nr_ruhs;
> > +     uint32_t pli_loc;
> > +     uint16_t plis[];
> > +};
> > +
> > +int fdp_init(struct thread_data *td);
> > +void fdp_free_ruhs_info(struct fio_file *f);
> > +void fdp_fill_dspec_data(struct thread_data *td, struct io_u *io_u);
> > +
> > +#endif /* FIO_FDP_H */
> > diff --git a/file.h b/file.h
> > index da1b8947..deb36e02 100644
> > --- a/file.h
> > +++ b/file.h
> > @@ -12,6 +12,7 @@
> >
> >  /* Forward declarations */
> >  struct zoned_block_device_info;
> > +struct fdp_ruh_info;
> >
> >  /*
> >   * The type of object we are working on
> > @@ -101,6 +102,8 @@ struct fio_file {
> >       uint64_t file_offset;
> >       uint64_t io_size;
> >
> > +     struct fio_ruhs_info *ruhs_info;
> > +
> >       /*
> >        * Zoned block device information. See also zonemode=zbd.
> >        */
> > diff --git a/filesetup.c b/filesetup.c
> > index cb7047c5..c1f38858 100644
> > --- a/filesetup.c
> > +++ b/filesetup.c
> > @@ -1417,6 +1417,12 @@ done:
> >
> >       td_restore_runstate(td, old_state);
> >
> > +     if (td->o.fdp) {
> > +             err = fdp_init(td);
> > +             if (err)
> > +                     goto err_out;
> > +     }
> > +
> >       return 0;
> >
> >  err_offset:
> > @@ -1627,6 +1633,7 @@ void close_and_free_files(struct thread_data *td)
> >               }
> >
> >               zbd_close_file(f);
> > +             fdp_free_ruhs_info(f);
> >               fio_file_free(f);
> >       }
> >
> > diff --git a/fio.1 b/fio.1
> > index 527b3d46..b8e9ebfb 100644
> > --- a/fio.1
> > +++ b/fio.1
> > @@ -2192,6 +2192,14 @@ cached data. Currently the RWF_NOWAIT flag does not supported for cached write.
> >  For direct I/O, requests will only succeed if cache invalidation isn't required,
> >  file blocks are fully allocated and the disk request could be issued immediately.
> >  .TP
> > +.BI (io_uring_cmd)fdp \fR=\fPbool
> > +Enable Flexible Data Placement mode for write commands.
> > +.TP
> > +.BI (io_uring_cmd)fdp_pli \fR=\fPint[,int][,int]
> > +Select which Placement ID Index/Indicies this job is allowed to use for writes.
> > +By default, the job will cycle through all available Placement IDs, so use this
> > +to isolate these identifiers to specific jobs.
> > +.TP
> Same comments from HOWTO
> >  .BI (cpuio)cpuload \fR=\fPint
> >  Attempt to use the specified percentage of CPU cycles. This is a mandatory
> >  option when using cpuio I/O engine.
> > diff --git a/io_u.c b/io_u.c
> > index eb617e64..42e70177 100644
> > --- a/io_u.c
> > +++ b/io_u.c
> > @@ -988,6 +988,9 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
> >                       return 1;
> >       }
> >
> > +     if (td->o.fdp)
> > +             fdp_fill_dspec_data(td, io_u);
> > +
> >       if (io_u->offset + io_u->buflen > io_u->file->real_file_size) {
> >               dprint(FD_IO, "io_u %p, off=0x%llx + len=0x%llx exceeds file size=0x%llx\n",
> >                       io_u,
> > diff --git a/io_u.h b/io_u.h
> > index 206e24fe..13b26d37 100644
> > --- a/io_u.h
> > +++ b/io_u.h
> > @@ -117,6 +117,9 @@ struct io_u {
> >        */
> >       int (*end_io)(struct thread_data *, struct io_u **);
> >
> > +     uint32_t dtype;
> > +     uint32_t dspec;
> > +
> >       union {
> >  #ifdef CONFIG_LIBAIO
> >               struct iocb iocb;
> > diff --git a/ioengines.h b/ioengines.h
> > index ea799180..9484265e 100644
> > --- a/ioengines.h
> > +++ b/ioengines.h
> > @@ -7,8 +7,9 @@
> >  #include "flist.h"
> >  #include "io_u.h"
> >  #include "zbd_types.h"
> > +#include "fdp.h"
> >
> > -#define FIO_IOOPS_VERSION    31
> > +#define FIO_IOOPS_VERSION    32
> >
> >  #ifndef CONFIG_DYNAMIC_ENGINES
> >  #define FIO_STATIC   static
> > @@ -63,6 +64,8 @@ struct ioengine_ops {
> >                                 unsigned int *);
> >       int (*finish_zone)(struct thread_data *, struct fio_file *,
> >                          uint64_t, uint64_t);
> > +     int (*fdp_fetch_ruhs)(struct thread_data *, struct fio_file *,
> > +                           struct fio_ruhs_info *);
> >       int option_struct_size;
> >       struct fio_option *options;
> >  };
> > diff --git a/options.c b/options.c
> > index 49612345..31d232f8 100644
> > --- a/options.c
> > +++ b/options.c
> > @@ -251,6 +251,34 @@ int str_split_parse(struct thread_data *td, char *str,
> >       return ret;
> >  }
> >
> > +static int fio_fdp_cmp(const void *p1, const void *p2)
> > +{
> > +     const uint16_t *t1 = p1;
> > +     const uint16_t *t2 = p2;
> > +
> > +     return *t1 - *t2;
> > +}
> > +
> > +static int str_fdp_pli_cb(void *data, const char *input)
> > +{
> > +     struct thread_data *td = cb_data_to_td(data);
> > +     char *str, *p, *v;
> > +     int i = 0;
> > +
> > +     p = str = strdup(input);
> > +     strip_blank_front(&str);
> > +     strip_blank_end(str);
> > +
> > +     while ((v = strsep(&str, ",")) != NULL && i < FIO_MAX_PLIS)
> > +             td->o.fdp_plis[i++] = strtoll(v, NULL, 0);
> > +     free(p);
> > +
> > +     qsort(td->o.fdp_plis, i, sizeof(*td->o.fdp_plis), fio_fdp_cmp);
> > +     td->o.fdp_nrpli = i;
> > +
> > +     return 0;
> > +}
> > +
> >  static int str_bssplit_cb(void *data, const char *input)
> >  {
> >       struct thread_data *td = cb_data_to_td(data);
> > @@ -3649,6 +3677,27 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
> >               .category = FIO_OPT_C_IO,
> >               .group  = FIO_OPT_G_ZONE,
> >       },
> > +     {
> > +             .name   = "fdp",
> > +             .lname  = "Flexible data placement",
> > +             .type   = FIO_OPT_BOOL,
> > +             .off1   = offsetof(struct thread_options, fdp),
> > +             .help   = "Use Data placement directive (FDP)",
> > +             .def    = "0",
> > +             .category = FIO_OPT_C_IO,
> > +             .group  = FIO_OPT_G_INVALID,
> > +     },
> > +     {
> > +             .name   = "fdp_pli",
> > +             .lname  = "FDP Placement ID indicies",
> > +             .type   = FIO_OPT_STR,
> > +             .cb     = str_fdp_pli_cb,
> > +             .off1   = offsetof(struct thread_options, fdp_plis),
> > +             .help   = "Sets which placement ids to use (defaults to all)",
> > +             .hide   = 1,
> > +             .category = FIO_OPT_C_IO,
> > +             .group  = FIO_OPT_G_INVALID,
> > +     },
> >       {
> >               .name   = "lockmem",
> >               .lname  = "Lock memory",
> > diff --git a/thread_options.h b/thread_options.h
> > index 74e7ea45..605eb259 100644
> > --- a/thread_options.h
> > +++ b/thread_options.h
> > @@ -386,6 +386,11 @@ struct thread_options {
> >       fio_fp64_t zrt;
> >       fio_fp64_t zrf;
> >
> > +#define FIO_MAX_PLIS 16
> > +     unsigned int fdp;
> > +     unsigned int fdp_plis[FIO_MAX_PLIS];
> > +     unsigned int fdp_nrpli;
> > +
> >       unsigned int log_entries;
> >       unsigned int log_prio;
> >  };
> > @@ -698,6 +703,8 @@ struct thread_options_pack {
> >       uint32_t log_entries;
> >       uint32_t log_prio;
> >
> > +     uint32_t fdp;
> we need change in cconv.c for this option.
> > +
> >       /*
> >        * verify_pattern followed by buffer_pattern from the unpacked struct
> >        */
> > --
> > 2.30.2
> >
> >
