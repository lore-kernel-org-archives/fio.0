Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20190802153225.11480-1-rjones@redhat.com> <20190802153225.11480-2-rjones@redhat.com>
In-Reply-To: <20190802153225.11480-2-rjones@redhat.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 3 Aug 2019 16:10:07 +0100
Message-ID: <CALjAwxgdf_XNwquVDJtSTKRjD9kcXcdM9MoDCZUY2qh9bxwwNg@mail.gmail.com>
Subject: Re: [PATCH v4] engines: Add Network Block Device (NBD) support using libnbd.
Content-Type: text/plain; charset="UTF-8"
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: fio <fio@vger.kernel.org>, eblake@redhat.com, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On Sat, 3 Aug 2019 at 15:38, Richard W.M. Jones <rjones@redhat.com> wrote:
>
> This commit adds a new engine for testing Network Block Devices
> directly.  It requires libnbd (https://github.com/libguestfs/libnbd).
>
> To see how to test nbdkit or qemu-nbd read examples/nbd.fio.
>
> Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
> ---
>  HOWTO            |   2 +
>  Makefile         |   6 +
>  configure        |  27 ++++
>  engines/nbd.c    | 368 +++++++++++++++++++++++++++++++++++++++++++++++
>  examples/nbd.fio |  35 +++++
>  fio.1            |   3 +
>  optgroup.c       |   4 +
>  optgroup.h       |   2 +
>  options.c        |   3 +
>  9 files changed, 450 insertions(+)
>
> diff --git a/HOWTO b/HOWTO
> index 81244064..955ea43c 100644
> --- a/HOWTO
> +++ b/HOWTO
> @@ -1998,6 +1998,8 @@ I/O engine
>                         requests for IME. FIO will then decide when to commit these requests.
>                 **libiscsi**
>                         Read and write iscsi lun with libiscsi.
> +               **nbd**
> +                       Synchronous read and write a Network Block Device (NBD).

I wonder if the engine should be called nbdkit as that's what it uses
under hood to talk NBD...

>
>  I/O engine specific parameters
>  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> diff --git a/Makefile b/Makefile
> index d7e5fca7..fe02bf1d 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -65,6 +65,12 @@ ifdef CONFIG_LIBISCSI
>    SOURCE += engines/libiscsi.c
>  endif
>
> +ifdef CONFIG_LIBNBD
> +  CFLAGS += $(LIBNBD_CFLAGS)
> +  LIBS += $(LIBNBD_LIBS)
> +  SOURCE += engines/nbd.c
> +endif
> +
>  ifdef CONFIG_64BIT
>    CFLAGS += -DBITS_PER_LONG=64
>  endif
> diff --git a/configure b/configure
> index a0692d58..b11b2dce 100755
> --- a/configure
> +++ b/configure
> @@ -149,6 +149,7 @@ disable_pmem="no"
>  disable_native="no"
>  march_set="no"
>  libiscsi="no"
> +libnbd="no"
>  prefix=/usr/local
>
>  # parse options
> @@ -207,6 +208,8 @@ for opt do
>    ;;
>    --enable-libiscsi) libiscsi="yes"
>    ;;
> +  --enable-libnbd) libnbd="yes"
> +  ;;

Why not enable by default if available and then do a probe to see if
it can be enabled?

> +
> +static struct ioengine_ops ioengine = {
> +       .name                   = "nbd",
> +       .version                = FIO_IOOPS_VERSION,
> +       .options                = options,
> +       .option_struct_size     = sizeof(struct nbd_options),
> +       .flags                  = FIO_DISKLESSIO | FIO_NOEXTEND,
> +
> +       .setup                  = nbd_setup,
> +       .init                   = nbd_init,
> +       .cleanup                = nbd_cleanup,
> +       .queue                  = nbd_queue,
> +       .getevents              = nbd_getevents,
> +       .event                  = nbd_event,
> +       .io_u_init              = nbd_io_u_init,
> +       .io_u_free              = nbd_io_u_free,
> +
> +       .open_file              = nbd_open_file,
> +       .invalidate             = nbd_invalidate,

Do you have to register functions for things that you don't do
anything (e.g. nbd_io_u_free)?

> --- /dev/null
> +++ b/examples/nbd.fio
> @@ -0,0 +1,35 @@
> +# To use fio to test nbdkit:
> +#
> +# nbdkit -U - memory size=256M --run 'export unixsocket; fio examples/nbd.fio'
> +#
> +# To use fio to test qemu-nbd:
> +#
> +# rm -f /tmp/disk.img /tmp/socket
> +# truncate -s 256M /tmp/disk.img
> +# export unixsocket=/tmp/socket
> +# qemu-nbd -t -k $unixsocket -f raw /tmp/disk.img &
> +# fio examples/nbd.fio
> +# killall qemu-nbd
> +
> +[global]
> +ioengine=nbd
> +uri=nbd+unix:///?socket=${unixsocket}
> +# Starting from nbdkit 1.14 the following will work:
> +#uri=${uri}
> +rw=randrw
> +time_based
> +runtime=60
> +group_reporting
> +iodepth=64
> +
> +[job0]
> +offset=0
> +
> +[job1]
> +offset=064m

I'd drop the leading 0.

-- 
Sitsofe | http://sucs.org/~sits/

