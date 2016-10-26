Return-Path: <kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1477069653-14350-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1477069653-14350-1-git-send-email-kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Wed, 26 Oct 2016 21:09:56 +0900
Message-ID: <CAHndrB=qorNcy+kQb-bZhd8L0k6KXw2jyw344Vj+UMfoMuERYQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Add blockdev_size() support for NetBSD
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi Jens

Sorry to ping you, but could you please review this (1/2) and 2/2 ?

Regards,
Tomohiro Kusumi


2016-10-22 2:07 GMT+09:00 Tomohiro Kusumi <kusumi.tomohiro@gmail.com>:
> This commit is NetBSD version of 1116dc04 in 2015.
>
> NetBSD still has block device as a file type, thus it differs
> from FreeBSD/DragonFlyBSD regarding FIO_HAVE_CHARDEV_SIZE.
>
> Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
> ---
>  os/os-netbsd.h |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
>
> diff --git a/os/os-netbsd.h b/os/os-netbsd.h
> index 1ef5866..2133d7a 100644
> --- a/os/os-netbsd.h
> +++ b/os/os-netbsd.h
> @@ -7,6 +7,9 @@
>  #include <lwp.h>
>  #include <sys/param.h>
>  #include <sys/statvfs.h>
> +#include <sys/ioctl.h>
> +#include <sys/dkio.h>
> +#include <sys/disklabel.h>
>  /* XXX hack to avoid confilcts between rbtree.h and <sys/rb.h> */
>  #define        rb_node _rb_node
>  #include <sys/sysctl.h>
> @@ -17,7 +20,6 @@
>  #include "../file.h"
>
>  #define FIO_HAVE_ODIRECT
> -#define FIO_USE_GENERIC_BDEV_SIZE
>  #define FIO_USE_GENERIC_RAND
>  #define FIO_USE_GENERIC_INIT_RANDOM_STATE
>  #define FIO_HAVE_FS_STAT
> @@ -37,6 +39,19 @@
>
>  typedef off_t off64_t;
>
> +static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
> +{
> +       struct disklabel dl;
> +
> +       if (!ioctl(f->fd, DIOCGDINFO, &dl)) {
> +               *bytes = ((unsigned long long)dl.d_secperunit) * dl.d_secsize;
> +               return 0;
> +       }
> +
> +       *bytes = 0;
> +       return errno;
> +}
> +
>  static inline int blockdev_invalidate_cache(struct fio_file *f)
>  {
>         return EINVAL;
> --
> 1.7.1
>

