Return-Path: <axboe@kernel.dk>
Subject: Re: fio and posix_fadvise
References: <AEA40A07-F002-4E1C-B4E4-991FF6B13F55@orange.fr>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <35191fbf-d272-31e0-4d66-5b702d91ff03@kernel.dk>
Date: Fri, 16 Sep 2016 09:23:42 -0600
MIME-Version: 1.0
In-Reply-To: <AEA40A07-F002-4E1C-B4E4-991FF6B13F55@orange.fr>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Fabrice Bacchella <fabrice.bacchella@orange.fr>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 09/15/2016 08:23 AM, Fabrice Bacchella wrote:
> fio uses posix_fadvise, but can only take two values :
>
>         if (td->o.invalidate_cache && file_invalidate_cache(td, f))
>                 goto err;
>
>         if (td->o.fadvise_hint &&
>             (f->filetype == FIO_TYPE_BD || f->filetype == FIO_TYPE_FILE)) {
>                 int flags;
>
>                 if (td_random(td))
>                         flags = POSIX_FADV_RANDOM;
>                 else
>                         flags = POSIX_FADV_SEQUENTIAL;
>
>                 if (posix_fadvise(f->fd, f->file_offset, f->io_size, flags) < 0) {
>                         td_verror(td, errno, "fadvise");
>                         goto err;
>                 }
>         }
>
>
> But it can take many values, from linux/fadvise.h:
>
> #define POSIX_FADV_NORMAL       0 /* No further special treatment.  */
> #define POSIX_FADV_RANDOM       1 /* Expect random page references.  */
> #define POSIX_FADV_SEQUENTIAL   2 /* Expect sequential page references.  */
> #define POSIX_FADV_WILLNEED     3 /* Will need these pages.  */
> ...
> #define POSIX_FADV_DONTNEED     4 /* Don't need these pages.  */
> #define POSIX_FADV_NOREUSE      5 /* Data will be accessed once.  */
>
>
> POSIX_FADV_NOREUSE have no effect on current kernel
> (https://github.com/torvalds/linux/blob/master/mm/fadvise.c#L115) but
> DONTNEED is interesting as it allow to flush page cache after use It
> allows to do bench with machines with huge memory without having to
> bench huge files, and without using directio that is a strange beast.
> But it needs to be call right after use.
>
> It's used in file_invalidate_cache but this function seems to be call
> once, when file is open for the first time.
>
> Is there any plan to support it ?

What kind of use case did you have in mind? Dropping pages after writing
them? That basically boils down to being a non data integrity fdatasync.
You would get basically the same effect by using fdatasync=1 in your
workload. The difference would mainly be that DONTNEED would factor in
the range and offset. So if you have multiple writers on the same file,
then there would be a difference in behavior.

That said, I don't mind adding support for using DONTNEED specifically.
Currently it's just used to set a permanent hint, which is why it's only
done once. For DONTNEED, you'd want to call it after each write instead.

-- 
Jens Axboe


