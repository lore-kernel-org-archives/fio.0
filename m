Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhBYHWJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Feb 2021 02:22:09 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDD2C061786
        for <fio@vger.kernel.org>; Wed, 24 Feb 2021 23:21:29 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id u14so4183928wri.3
        for <fio@vger.kernel.org>; Wed, 24 Feb 2021 23:21:29 -0800 (PST)
MIME-Version: 1.0
References: <HK0PR04MB2388F3AF9F2D1F04CA21E722FD819@HK0PR04MB2388.apcprd04.prod.outlook.com>
In-Reply-To: <HK0PR04MB2388F3AF9F2D1F04CA21E722FD819@HK0PR04MB2388.apcprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 25 Feb 2021 07:21:02 +0000
Message-ID: <CALjAwxgcCvhtnc_67+fwXUZ+rC-_YbFhZrNzt+RXeeWCvfKZZg@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] engines: add engine for file delete
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: "Su, Friendy" <Friendy.Su@sony.com>
Cc: fio <fio@vger.kernel.org>, "Kobayashi, Kento (Sony)" <Kento.A.Kobayashi@sony.com>, Wataru.Aoyama@sony.com

Hi,

On Mon, 22 Feb 2021 at 12:15, <Friendy.Su@sony.com> wrote:
>
> This engine is to measure performance of deleting files.
>
> In practice, it is an important benchmark for a file system that
> how quick it can release the disk space of deleted files.
>
> Signed-off-by: friendy-su <friendy.su@sony.com>
> ---
>  HOWTO                            |   5 ++
>  Makefile                         |   2 +-
>  engines/filedelete.c             | 108 +++++++++++++++++++++++++++++++
>  examples/filedelete-ioengine.fio |  23 +++++++
>  fio.1                            |   5 ++
>  5 files changed, 142 insertions(+), 1 deletion(-)
>  create mode 100644 engines/filedelete.c
>  create mode 100644 examples/filedelete-ioengine.fio
>
> diff --git a/HOWTO b/HOWTO
> index b6d1b58a..ea728439 100644
> --- a/HOWTO
> +++ b/HOWTO
> @@ -2033,6 +2033,11 @@ I/O engine
>                         and 'nrfiles', so that files will be created.
>                         This engine is to measure file lookup and meta data access.
>
> +               **filedelete**
> +                       Simply delete the files by unlink() and do no I/O to them. You need to set 'filesize'
> +                       and 'nrfiles', so that the files will be created.
> +                       This engine is to measure file delete.
> +
>                 **libpmem**
>                         Read and write using mmap I/O to a file on a filesystem
>                         mounted with DAX on a persistent memory device through the PMDK
> diff --git a/Makefile b/Makefile
> index 612344d1..11ffa089 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -51,7 +51,7 @@ SOURCE :=     $(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
>                 pshared.c options.c \
>                 smalloc.c filehash.c profile.c debug.c engines/cpu.c \
>                 engines/mmap.c engines/sync.c engines/null.c engines/net.c \
> -               engines/ftruncate.c engines/filecreate.c engines/filestat.c \
> +               engines/ftruncate.c engines/filecreate.c engines/filestat.c engines/filedelete.c \
>                 server.c client.c iolog.c backend.c libfio.c flow.c cconv.c \
>                 gettime-thread.c helpers.c json.c idletime.c td_error.c \
>                 profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
> diff --git a/engines/filedelete.c b/engines/filedelete.c
> new file mode 100644
> index 00000000..71977b22
> --- /dev/null
> +++ b/engines/filedelete.c
> @@ -0,0 +1,108 @@
> +/*
> + * file delete engine
> + *
> + * IO engine that doesn't do any IO, just delete files and tracks the latency
> + * of the file deletion.
> + */
> +#include <stdio.h>
> +#include <fcntl.h>
> +#include <errno.h>
> +#include <sys/types.h>
> +#include <unistd.h>
> +#include "../fio.h"
> +
> +struct fc_data {
> +       enum fio_ddir stat_ddir;
> +};
> +
> +static int delete_file(struct thread_data *td, struct fio_file *f)
> +{
> +       struct timespec start;
> +       int do_lat = !td->o.disable_lat;
> +       int ret;
> +
> +       dprint(FD_FILE, "fd delete %s\n", f->file_name);
> +
> +       if (f->filetype != FIO_TYPE_FILE) {
> +               log_err("fio: only files are supported fallocate \n");

This message doesn't quite make sense... only files are supported by filedelete?

> +               return 1;
> +       }
> +       if (!strcmp(f->file_name, "-")) {
> +               log_err("fio: can't read/write to stdin/out\n");

Can't delete files from stdout/stdin?

> +               return 1;
> +       }
> +
> +       if (do_lat)
> +               fio_gettime(&start, NULL);
> +
> +       ret = unlink(f->file_name);
> +
> +       if (ret == -1) {
> +               char buf[FIO_VERROR_SIZE];
> +               int e = errno;
> +
> +               snprintf(buf, sizeof(buf), "delete(%s)", f->file_name);
> +               td_verror(td, e, buf);
> +               return 1;
> +       }
> +
> +       if (do_lat) {
> +               struct fc_data *data = td->io_ops_data;
> +               uint64_t nsec;
> +
> +               nsec = ntime_since_now(&start);
> +               add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0);
> +       }
> +
> +       return 0;
> +}
> +
> +
> +static enum fio_q_status queue_io(struct thread_data *td, struct io_u fio_unused *io_u)
> +{
> +       return FIO_Q_COMPLETED;
> +}
> +
> +static int init(struct thread_data *td)
> +{
> +       struct fc_data *data;
> +
> +       data = calloc(1, sizeof(*data));
> +
> +       if (td_read(td))
> +               data->stat_ddir = DDIR_READ;
> +       else if (td_write(td))
> +               data->stat_ddir = DDIR_WRITE;
> +
> +       td->io_ops_data = data;
> +       return 0;
> +}
> +
> +static void cleanup(struct thread_data *td)
> +{
> +       struct fc_data *data = td->io_ops_data;
> +
> +       free(data);
> +}
> +
> +static struct ioengine_ops ioengine = {
> +       .name           = "filedelete",
> +       .version        = FIO_IOOPS_VERSION,
> +       .init           = init,
> +       .cleanup        = cleanup,
> +       .queue          = queue_io,
> +       .get_file_size  = generic_get_file_size,
> +       .open_file      = delete_file,
> +       .flags          =  FIO_SYNCIO | FIO_FAKEIO |
> +                               FIO_NOSTATS | FIO_NOFILEHASH,
> +};
> +
> +static void fio_init fio_filecreate_register(void)
> +{
> +       register_ioengine(&ioengine);
> +}
> +
> +static void fio_exit fio_filecreate_unregister(void)
> +{
> +       unregister_ioengine(&ioengine);
> +}
> diff --git a/examples/filedelete-ioengine.fio b/examples/filedelete-ioengine.fio
> new file mode 100644
> index 00000000..58002c8a
> --- /dev/null
> +++ b/examples/filedelete-ioengine.fio
> @@ -0,0 +1,23 @@
> +# Example filedelete job
> +
> +# 'filedelete' engine only do 'unlink(filename)', file will not be open().
> +# 'invalidate' should be set to 0 since file will not be open(), posix_fadvise(fd,....) will fail.

Did you want the ioengine to enforce this? If so you can "implement"
the .invalidate op and simply do nothing (see engines/filestat.c:173).
Others catch settings in init (e.g. engines/mmap.c:272).

> +# 'filesize' must be set, then files will be created at setup stage.
> +# 'unlink' must be set to 0, since the file is deleted in measurement.
> +
> +[global]
> +ioengine=filedelete
> +numjobs=1
> +filesize=4k
> +invalidate=0
> +nrfiles=200
> +unlink=0
> +
> +[t0]
> +[t1]
> +[t2]
> +[t3]
> +[t4]
> +[t5]
> +
> +

You can probably trim the trailing empty lines.

> diff --git a/fio.1 b/fio.1
> index aa248a3b..4b1ef80d 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -1819,6 +1819,11 @@ Simply do stat() and do no I/O to the file. You need to set 'filesize'
>  and 'nrfiles', so that files will be created.
>  This engine is to measure file lookup and meta data access.
>  .TP
> +.B filestat
> +Simply delete files by unlink() and do no I/O to the file. You need to set 'filesize'
> +and 'nrfiles', so that files will be created.
> +This engine is to measure file delete.
> +.TP

This looks different to what you put in the HOWTO. Is this intentional?

>  .B libpmem
>  Read and write using mmap I/O to a file on a filesystem
>  mounted with DAX on a persistent memory device through the PMDK
> --
> 2.17.1
>


-- 
Sitsofe

