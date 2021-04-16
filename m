Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <PU1PR04MB23909EA73FD1006DE2D5D8D5FD4E9@PU1PR04MB2390.apcprd04.prod.outlook.com>
In-Reply-To: <PU1PR04MB23909EA73FD1006DE2D5D8D5FD4E9@PU1PR04MB2390.apcprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 16 Apr 2021 06:30:50 +0100
Message-ID: <CALjAwxgPB=UdE2_9qJx3zGEsoRT_Bh1sq3P6F0d37F5g=s_H8A@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] engines: add engine for file delete
Content-Type: text/plain; charset="UTF-8"
To: "Su, Friendy" <Friendy.Su@sony.com>, Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>, "Kobayashi, Kento (Sony)" <Kento.A.Kobayashi@sony.com>, Wataru.Aoyama@sony.com
List-ID: <fio@vger.kernel.org>

On Wed, 14 Apr 2021 at 04:57, <Friendy.Su@sony.com> wrote:
>
> This engine is to measure the performance of deleting files.
>
> In practice, it is an important benchmark for a file system that
> how quick it can release the disk space of deleted files.
>
> Signed-off-by: friendy-su <friendy.su@sony.com>
> ---
>  HOWTO                            |   5 ++
>  Makefile                         |   2 +-
>  engines/filedelete.c             | 115 +++++++++++++++++++++++++++++++
>  examples/filedelete-ioengine.fio |  18 +++++
>  fio.1                            |   5 ++
>  5 files changed, 144 insertions(+), 1 deletion(-)
>  create mode 100644 engines/filedelete.c
>  create mode 100644 examples/filedelete-ioengine.fio
>
> diff --git a/HOWTO b/HOWTO
> index 2788670d..e6078c5f 100644
> --- a/HOWTO
> +++ b/HOWTO
> @@ -2055,6 +2055,11 @@ I/O engine
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
> index fce3d0d1..ba027b2e 100644
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
> index 00000000..64c58639
> --- /dev/null
> +++ b/engines/filedelete.c
> @@ -0,0 +1,115 @@
> +/*
> + * file delete engine
> + *
> + * IO engine that doesn't do any IO, just delete files and track the latency
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
> +               log_err("fio: only files are supported\n");
> +               return 1;
> +       }
> +       if (!strcmp(f->file_name, "-")) {
> +               log_err("fio: can't read/write to stdin/out\n");
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
> +static int delete_invalidate(struct thread_data *td, struct fio_file *f)
> +{
> +    /* do nothing because file not opened */
> +    return 0;
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
> +       .invalidate     = delete_invalidate,
> +       .cleanup        = cleanup,
> +       .queue          = queue_io,
> +       .get_file_size  = generic_get_file_size,
> +       .open_file      = delete_file,
> +       .flags          =  FIO_SYNCIO | FIO_FAKEIO |
> +                               FIO_NOSTATS | FIO_NOFILEHASH,
> +};
> +
> +static void fio_init fio_filedelete_register(void)
> +{
> +       register_ioengine(&ioengine);
> +}
> +
> +static void fio_exit fio_filedelete_unregister(void)
> +{
> +       unregister_ioengine(&ioengine);
> +}
> diff --git a/examples/filedelete-ioengine.fio b/examples/filedelete-ioengine.fio
> new file mode 100644
> index 00000000..3c0028f9
> --- /dev/null
> +++ b/examples/filedelete-ioengine.fio
> @@ -0,0 +1,18 @@
> +# Example filedelete job
> +
> +# 'filedelete' engine only do 'unlink(filename)', file will not be open().
> +# 'filesize' must be set, then files will be created at setup stage.
> +# 'unlink' is better set to 0, since the file is deleted in measurement.
> +# the options disabled completion latency output such as 'disable_clat' and 'gtod_reduce' must not set.
> +[global]
> +ioengine=filedelete
> +filesize=4k
> +nrfiles=200
> +unlink=0
> +
> +[t0]
> +[t1]
> +[t2]
> +[t3]
> +[t4]
> +[t5]
> diff --git a/fio.1 b/fio.1
> index f959e00d..c59a8002 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -1847,6 +1847,11 @@ Simply do stat() and do no I/O to the file. You need to set 'filesize'
>  and 'nrfiles', so that files will be created.
>  This engine is to measure file lookup and meta data access.
>  .TP
> +.B filedelete
> +Simply delete files by unlink() and do no I/O to the file. You need to set 'filesize'
> +and 'nrfiles', so that files will be created.
> +This engine is to measure file delete.
> +.TP
>  .B libpmem
>  Read and write using mmap I/O to a file on a filesystem
>  mounted with DAX on a persistent memory device through the PMDK
> --
> 2.17.1
>

Looks good to me (I'll note if you want to check for bad options and
bail out you can do so in your .init function (e.g. see
engines/dev-dax.c as an example)) but that's not a blocker.

Jens - can we pull this one?

-- 
Sitsofe

