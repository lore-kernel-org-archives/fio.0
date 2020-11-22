Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <87d0088vxm.fsf@copper.locationd.net>
In-Reply-To: <87d0088vxm.fsf@copper.locationd.net>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 22 Nov 2020 14:29:40 +0000
Message-ID: <CALjAwxjXV4zZbwJAT9NpFcjccTdKNzE1J_=+kjd2wnH3XTktYg@mail.gmail.com>
Subject: Re: [RFC PATCH] error out if ENOSPC during file layout
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: Kushal Kumaran <kushal@locationd.net>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi,

This does look like better behaviour to me.

Jens, can we pick this one up?

On Fri, 20 Nov 2020 at 05:09, Kushal Kumaran <kushal@locationd.net> wrote:
>
> Hi,
>
> When I run fio with --create_only=1 and it runs out of space, it still
> exits with status 0.  I could not figure out if this was intentional
> (except for the fill_device case, where this is obviously the expected
> behavior).
>
> $ cat ~/fio
> [global]
> ioengine=posixaio
> rw=readwrite
> size=2g
> directory=${HOME}/mounts/testdisk
> thread=1
>
> [trivial-readwrite-1g]
> $ df -h .
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/loop6      976M  2.6M  907M   1% /home/kushal/mounts/testdisk
> $ fio ~/fio --create_only=1
> trivial-readwrite-1g: (g=0): rw=rw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=pos
> ixaio, iodepth=1
> fio-3.12
> Starting 1 thread
> trivial-readwrite-1g: Laying out IO file (1 file / 2048MiB)
> fio: ENOSPC on laying out file, stopping
>
>
> Run status group 0 (all jobs):
>
> Disk stats (read/write):
>   loop6: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
> $ echo $?
> 0
>
> A trivial patch for this gives me the behavior I expect.
>
> ---
>  filesetup.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/filesetup.c b/filesetup.c
> index f4360a6f..42c5f630 100644
> --- a/filesetup.c
> +++ b/filesetup.c
> @@ -231,13 +231,12 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
>                                                 break;
>                                         log_info("fio: ENOSPC on laying out "
>                                                  "file, stopping\n");
> -                                       break;
>                                 }
>                                 td_verror(td, errno, "write");
>                         } else
>                                 td_verror(td, EIO, "write");
>
> -                       break;
> +                       goto err;
>                 }
>         }
>
> --
> 2.20.1



-- 
Sitsofe | http://sucs.org/~sits/

